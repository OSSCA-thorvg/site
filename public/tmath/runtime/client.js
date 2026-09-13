import createModule from "./tmath-wasm.js";
import {compileScene} from "./bindings.js";

export {compileScene, evaluateScene, SceneBuilder, tmath} from "./bindings.js";

const CAMERA_ACTIONS = Object.freeze({pan: 0, orbit: 1, zoom: 2, reset: 3, view2d: 4, view3d: 5});
const INPUT_TYPES = Object.freeze({
    pointerdown: 0,
    pointermove: 1,
    pointerup: 2,
    pointercancel: 3,
    wheel: 4,
    keydown: 5,
    keyup: 6,
});
const INPUT_KEYS = Object.freeze({
    ArrowLeft: 1,
    ArrowRight: 2,
    ArrowUp: 3,
    ArrowDown: 4,
    Space: 5,
    " ": 5,
    Enter: 6,
    Escape: 7,
    Plus: 44,
    "+": 44,
    "=": 44,
    Minus: 45,
    "-": 45,
    "_": 45,
    Shift: 46,
    Tab: 47,
});
const RENDER_ENGINES = Object.freeze({cpu: 0, gl: 1});
const ACTION_BINDING_LIMIT = 256;
const ACTION_NAME_LIMIT = 63;

function inputKey(value) {
    if (value === undefined || value === null || value === "") return 0;
    if (typeof value !== "string") throw new TypeError("Input key must be a string");
    const named = INPUT_KEYS[value];
    if (named !== undefined) return named;
    if (/^[a-z]$/i.test(value)) return 8 + value.toUpperCase().charCodeAt(0) - 65;
    if (/^[0-9]$/.test(value)) return 34 + value.charCodeAt(0) - 48;
    throw new TypeError(`Unsupported input key '${value}'`);
}

function actionName(value) {
    if (typeof value !== "string" || !value.length || value.includes("\0")) {
        throw new TypeError("Action name must be a non-empty string without zero bytes");
    }
    if (new TextEncoder().encode(value).length > ACTION_NAME_LIMIT) {
        throw new TypeError(`Action name must contain at most ${ACTION_NAME_LIMIT} UTF-8 bytes`);
    }
    return value;
}

function actionValue(value = {x: 1, y: 0}) {
    if (!value || typeof value !== "object" || !Number.isFinite(value.x)
        || !Number.isFinite(value.y) || (value.x === 0 && value.y === 0)) {
        throw new TypeError("Action binding value must contain finite x and y with at least one non-zero component");
    }
    return {x: value.x, y: value.y};
}

function createInputActionMap(readKey, readPointer) {
    const bindings = [];
    const bind = (binding) => {
        const found = bindings.find((candidate) => candidate.action === binding.action
            && candidate.source === binding.source
            && (binding.source === "key"
                ? candidate.key === binding.key
                : candidate.pointerId === binding.pointerId
                    && candidate.button === binding.button));
        if (found) {
            found.value = binding.value;
            return api;
        }
        if (bindings.length >= ACTION_BINDING_LIMIT) {
            throw new Error(`Action map supports at most ${ACTION_BINDING_LIMIT} bindings`);
        }
        bindings.push(binding);
        return api;
    };
    const api = Object.freeze({
        get count() {
            return bindings.length;
        },
        bindKey(action, key, value) {
            const code = inputKey(key);
            if (!code) throw new TypeError("Action key is required");
            return bind({source: "key", action: actionName(action), key: code,
                value: actionValue(value)});
        },
        bindPointer(action, button, value, pointerId = 0) {
            if (!Number.isInteger(button) || button < 0 || button >= 32) {
                throw new TypeError("Action pointer button must be an integer from 0 to 31");
            }
            if (!Number.isInteger(pointerId) || pointerId < 0 || pointerId > 0xffffffff) {
                throw new TypeError("Action pointer ID must be a uint32 integer");
            }
            return bind({source: "pointer", action: actionName(action), button, pointerId,
                value: actionValue(value)});
        },
        remove(action) {
            const name = actionName(action);
            let removed = false;
            for (let i = bindings.length - 1; i >= 0; i--) {
                if (bindings[i].action !== name) continue;
                bindings.splice(i, 1);
                removed = true;
            }
            return removed;
        },
        clear() {
            bindings.length = 0;
        },
        state(action) {
            const name = actionName(action);
            let found = false;
            let previousDown = false;
            let down = false;
            let pressed = false;
            let released = false;
            const previous = {x: 0, y: 0};
            const value = {x: 0, y: 0};
            for (const binding of bindings) {
                if (binding.action !== name) continue;
                found = true;
                const source = binding.source === "key"
                    ? readKey(binding.key)
                    : readPointer(binding.pointerId);
                if (!source) continue;
                const mask = binding.source === "pointer" ? (1 << binding.button) >>> 0 : 0;
                const wasDown = binding.source === "key"
                    ? source.previous
                    : Boolean(source.previousButtons & mask);
                const sourceDown = binding.source === "key"
                    ? source.down
                    : Boolean(source.buttons & mask);
                const sourcePressed = binding.source === "key"
                    ? source.pressed
                    : Boolean(source.pressed & mask);
                const sourceReleased = binding.source === "key"
                    ? source.released
                    : Boolean(source.released & mask);
                if (wasDown) {
                    previous.x += binding.value.x;
                    previous.y += binding.value.y;
                }
                if (sourceDown) {
                    value.x += binding.value.x;
                    value.y += binding.value.y;
                }
                previousDown ||= wasDown;
                down ||= sourceDown;
                pressed ||= sourcePressed;
                released ||= sourceReleased;
            }
            if (!found) return null;
            previous.x = Math.max(-1, Math.min(1, previous.x));
            previous.y = Math.max(-1, Math.min(1, previous.y));
            value.x = Math.max(-1, Math.min(1, value.x));
            value.y = Math.max(-1, Math.min(1, value.y));
            return Object.freeze({
                previous: Object.freeze(previous),
                value: Object.freeze(value),
                delta: Object.freeze({x: value.x - previous.x, y: value.y - previous.y}),
                down,
                pressed: (!previousDown && down) || (!previousDown && !down && pressed),
                released: (previousDown && !down) || (!previousDown && !down && released),
            });
        },
    });
    return api;
}

function colorChannel(value, label) {
    const channel = Number(value);
    if (!Number.isFinite(channel) || channel < 0 || channel > 255) {
        throw new TypeError(`${label} contains an invalid color channel`);
    }
    return Math.round(channel);
}

function rgba(value, label) {
    if (typeof value !== "string") throw new TypeError(`${label} must be a CSS color string`);
    const input = value.trim().toLowerCase();
    const hex = input.match(/^#([0-9a-f]{3,4}|[0-9a-f]{6}|[0-9a-f]{8})$/i)?.[1];
    let channels;
    if (hex) {
        const expanded = hex.length <= 4 ? [...hex].map((digit) => digit + digit).join("") : hex;
        channels = [
            Number.parseInt(expanded.slice(0, 2), 16),
            Number.parseInt(expanded.slice(2, 4), 16),
            Number.parseInt(expanded.slice(4, 6), 16),
            expanded.length === 8 ? Number.parseInt(expanded.slice(6, 8), 16) : 255,
        ];
    } else {
        const functional = input.match(/^rgba?\(\s*([\d.]+)\s*[, ]\s*([\d.]+)\s*[, ]\s*([\d.]+)(?:\s*[,/]\s*([\d.]+%?))?\s*\)$/);
        if (!functional) throw new TypeError(`${label} must use hex, rgb(), or rgba() syntax`);
        const alpha = functional[4]?.endsWith("%")
            ? Number.parseFloat(functional[4]) * 2.55
            : Number.parseFloat(functional[4] ?? "1") * 255;
        channels = [functional[1], functional[2], functional[3], alpha];
    }
    const [red, green, blue, alpha] = channels.map((channel) => colorChannel(channel, label));
    return ((red << 24) | (green << 16) | (blue << 8) | alpha) >>> 0;
}

export async function createTMath(source, name = "scene.lua", moduleOptions = {}) {
    if (!moduleOptions || typeof moduleOptions !== "object" || Array.isArray(moduleOptions)) {
        throw new TypeError("tmath module options must be an object");
    }
    const requestedRenderEngine = moduleOptions.renderEngine ?? "cpu";
    const renderEngineCode = RENDER_ENGINES[requestedRenderEngine];
    if (renderEngineCode === undefined) {
        throw new TypeError("renderEngine must be 'cpu' or 'gl'");
    }
    const module = await createModule(moduleOptions);
    if (typeof module._tmath_create_with_engine !== "function"
        || typeof module._tmath_render_engine_enabled !== "function"
        || typeof module._tmath_render_engine !== "function") {
        throw new Error("The bundled tmath runtime does not support render-engine selection");
    }
    if (module._tmath_render_engine_enabled(renderEngineCode) === 0) {
        throw new Error(`The tmath ${requestedRenderEngine.toUpperCase()} renderer is not enabled in this build`);
    }
    let engine = module._tmath_create_with_engine(renderEngineCode);
    if (!engine) {
        throw new Error(`Unable to initialize the tmath ${requestedRenderEngine.toUpperCase()} renderer`);
    }
    const activeRenderEngineCode = module._tmath_render_engine(engine);
    const renderEngine = activeRenderEngineCode === RENDER_ENGINES.cpu ? "cpu"
        : activeRenderEngineCode === RENDER_ENGINES.gl ? "gl"
        : undefined;
    if (!renderEngine) {
        module._tmath_destroy(engine);
        engine = 0;
        throw new Error(`The tmath runtime returned an unknown render engine (${activeRenderEngineCode})`);
    }

    const assertAlive = () => {
        if (!engine) throw new Error("tmath instance has been destroyed");
    };
    const loadLua = (sourceText, sourceName = "scene.lua") => {
        assertAlive();
        if (typeof sourceText !== "string") throw new TypeError("Lua source must be a string");
        const source = new TextEncoder().encode(sourceText);
        const encodedName = new TextEncoder().encode(sourceName);
        if (!source.length || source.length > 0xffffffff) throw new Error("Lua source must be 1 to 4294967295 bytes");
        if (!encodedName.length || encodedName.includes(0)) throw new Error("Scene name must be non-empty and cannot contain zero bytes");
        const sourcePtr = module._malloc(source.length);
        const namePtr = module._malloc(encodedName.length + 1);
        if (!sourcePtr || !namePtr) {
            if (sourcePtr) module._free(sourcePtr);
            if (namePtr) module._free(namePtr);
            throw new Error("Unable to allocate WASM input");
        }
        let status;
        try {
            module.HEAPU8.set(source, sourcePtr);
            module.HEAPU8.set(encodedName, namePtr);
            module.HEAPU8[namePtr + encodedName.length] = 0;
            status = module._tmath_load_lua(engine, sourcePtr, source.length, namePtr);
        } finally {
            module._free(namePtr);
            module._free(sourcePtr);
        }
        if (status !== 0) {
            const message = module.UTF8ToString(module._tmath_last_error(engine));
            throw new Error(message || `Lua load failed (${status})`);
        }
        return module._tmath_duration(engine);
    };
    const loadScene = (definition, sourceName = "scene.js") => loadLua(compileScene(definition), sourceName);
    const load = (input, sourceName = typeof input === "string" ? "scene.lua" : "scene.js") => {
        return typeof input === "string" ? loadLua(input, sourceName) : loadScene(input, sourceName);
    };

    try {
        load(source, name);
    } catch (error) {
        module._tmath_destroy(engine);
        engine = 0;
        throw error;
    }

    const renderFrame = (time, copy, pixelRatio) => {
        assertAlive();
        const result = pixelRatio === 1
            ? module._tmath_render(engine, time)
            : module._tmath_render_scaled(engine, time, pixelRatio);
        if (result !== 0) {
            if (renderEngine === "gl" && result === 3) {
                throw new Error(
                    "GL rendering requires an explicit native GL target; the pixel and Canvas 2D paths never fall back to CPU",
                );
            }
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Render failed (${result})`);
        }
        const ptr = module._tmath_pixels(engine);
        const size = module._tmath_pixels_size(engine);
        const pixels = new Uint8ClampedArray(module.HEAPU8.buffer, ptr, size);
        return copy ? new Uint8ClampedArray(pixels) : pixels;
    };
    const render = (time, copy = false) => renderFrame(time, copy, 1);

    const lottie = (fps = 0) => {
        assertAlive();
        if (!Number.isInteger(fps) || fps < 0 || fps > 0xffffffff) {
            throw new RangeError("Lottie FPS must be an integer from 0 to 4294967295");
        }
        const result = module._tmath_lottie(engine, fps);
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Lottie export failed (${result})`);
        }
        const pointer = module._tmath_lottie_data(engine);
        const size = module._tmath_lottie_size(engine);
        if (!pointer || !size) throw new Error("Lottie export returned no data");
        return module.HEAPU8.slice(pointer, pointer + size);
    };

    const encodedObject = (value, label) => {
        if (typeof value !== "string") throw new TypeError(`${label} must be an object ID`);
        const encoded = new TextEncoder().encode(value);
        if (!encoded.length || encoded.length > 4096 || encoded.includes(0)) {
            throw new TypeError(`${label} must be a non-empty object ID without zero bytes`);
        }
        return encoded;
    };
    const bounds = (object, time = 0) => {
        assertAlive();
        if (!Number.isFinite(time) || time < 0) throw new RangeError("Bounds time must be a non-negative number");
        const encoded = encodedObject(object, "Bounds target");
        const objectPtr = module._malloc(encoded.length + 1);
        const outputPtr = module._malloc(16);
        if (!objectPtr || !outputPtr) {
            if (objectPtr) module._free(objectPtr);
            if (outputPtr) module._free(outputPtr);
            throw new Error("Unable to allocate WASM bounds input");
        }
        let result;
        let values;
        try {
            module.HEAPU8.set(encoded, objectPtr);
            module.HEAPU8[objectPtr + encoded.length] = 0;
            result = module._tmath_bounds(engine, objectPtr, time, outputPtr);
            if (result === 0) values = new Float32Array(module.HEAPU8.buffer, outputPtr, 4).slice();
        } finally {
            module._free(outputPtr);
            module._free(objectPtr);
        }
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Bounds query failed (${result})`);
        }
        return Object.freeze({x: values[0], y: values[1], width: values[2], height: values[3]});
    };
    const intersects = (first, second, time = 0, padding = 0) => {
        assertAlive();
        if (!Number.isFinite(time) || time < 0) {
            throw new RangeError("Intersection time must be a non-negative number");
        }
        if (!Number.isFinite(padding) || padding < 0) {
            throw new RangeError("Intersection padding must be a non-negative number");
        }
        const firstEncoded = encodedObject(first, "First intersection target");
        const secondEncoded = encodedObject(second, "Second intersection target");
        const firstPtr = module._malloc(firstEncoded.length + 1);
        const secondPtr = module._malloc(secondEncoded.length + 1);
        const outputPtr = module._malloc(1);
        if (!firstPtr || !secondPtr || !outputPtr) {
            if (firstPtr) module._free(firstPtr);
            if (secondPtr) module._free(secondPtr);
            if (outputPtr) module._free(outputPtr);
            throw new Error("Unable to allocate WASM intersection input");
        }
        let result;
        let output;
        try {
            module.HEAPU8.set(firstEncoded, firstPtr);
            module.HEAPU8[firstPtr + firstEncoded.length] = 0;
            module.HEAPU8.set(secondEncoded, secondPtr);
            module.HEAPU8[secondPtr + secondEncoded.length] = 0;
            result = module._tmath_intersects(engine, firstPtr, secondPtr, time, padding, outputPtr);
            output = module.HEAPU8[outputPtr] !== 0;
        } finally {
            module._free(outputPtr);
            module._free(secondPtr);
            module._free(firstPtr);
        }
        if (result !== 0) {
            throw new Error(
                module.UTF8ToString(module._tmath_last_error(engine)) || `Intersection query failed (${result})`,
            );
        }
        return output;
    };
    const layoutReport = (time = 0, padding = 0) => {
        assertAlive();
        if (!Number.isFinite(time) || time < 0) {
            throw new RangeError("Layout report time must be a non-negative number");
        }
        if (!Number.isFinite(padding) || padding < 0) {
            throw new RangeError("Layout report padding must be a non-negative number");
        }
        const result = module._tmath_layout_report(engine, time, padding);
        if (result !== 0) {
            throw new Error(
                module.UTF8ToString(module._tmath_last_error(engine)) || `Layout report failed (${result})`,
            );
        }
        const pointer = module._tmath_layout_report_data(engine);
        const size = module._tmath_layout_report_size(engine);
        if (!pointer || !size) throw new Error("Layout report returned no data");
        return JSON.parse(new TextDecoder().decode(module.HEAPU8.subarray(pointer, pointer + size)));
    };

    const resource = (loader, label, name, data, mime) => {
        assertAlive();
        const bytes = data instanceof Uint8Array ? data : new Uint8Array(data);
        const encodedName = new TextEncoder().encode(name);
        const encodedMime = new TextEncoder().encode(mime);
        if (!bytes.length || bytes.length > 32 * 1024 * 1024) throw new Error(`${label} must be 1 byte to 32 MiB`);
        if (!encodedName.length || encodedName.length > 256 || encodedName.includes(0) ||
            !encodedMime.length || encodedMime.length > 256 || encodedMime.includes(0)) {
            throw new Error(`${label} name and MIME must be non-empty, at most 256 bytes, and contain no zero bytes`);
        }
        const dataPtr = module._malloc(bytes.length);
        const namePtr = module._malloc(encodedName.length + 1);
        const mimePtr = module._malloc(encodedMime.length + 1);
        if (!dataPtr || !namePtr || !mimePtr) {
            if (dataPtr) module._free(dataPtr);
            if (namePtr) module._free(namePtr);
            if (mimePtr) module._free(mimePtr);
            throw new Error(`Unable to allocate WASM ${label.toLowerCase()} input`);
        }
        let result;
        try {
            module.HEAPU8.set(bytes, dataPtr);
            module.HEAPU8.set(encodedName, namePtr);
            module.HEAPU8[namePtr + encodedName.length] = 0;
            module.HEAPU8.set(encodedMime, mimePtr);
            module.HEAPU8[mimePtr + encodedMime.length] = 0;
            result = loader(engine, namePtr, dataPtr, bytes.length, mimePtr);
        } finally {
            module._free(mimePtr);
            module._free(namePtr);
            module._free(dataPtr);
        }
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `${label} load failed (${result})`);
        }
    };
    const font = (name, data, mime = "ttf") => resource(module._tmath_load_font, "Font", name, data, mime);
    const asset = (name, data, mime) => resource(module._tmath_load_asset, "Asset", name, data, mime);
    const audioExportNames = [
        "_tmath_audio_supported",
        "_tmath_audio_load",
        "_tmath_audio_start",
        "_tmath_audio_play",
        "_tmath_audio_stop",
        "_tmath_audio_active",
        "_tmath_audio_master_gain",
        "_tmath_audio_bus_gain",
        "_tmath_audio_transport",
    ];
    const hasAudio = audioExportNames.every((exportName) => typeof module[exportName] === "function")
        && module._tmath_audio_supported(engine) !== 0;
    const audio = hasAudio ? (() => {
        const buses = Object.freeze({music: 0, effect: 1, ui: 2});
        const status = (result, operation) => {
            if (result === 0) return;
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine))
                || `Audio ${operation} failed (${result})`);
        };
        const nameBytes = (name) => {
            if (typeof name !== "string" || !name.length || name.includes("\0")) {
                throw new TypeError("Audio asset name must be non-empty text without zero bytes");
            }
            const encoded = new TextEncoder().encode(name);
            if (encoded.length > 255) throw new RangeError("Audio asset name must contain at most 255 UTF-8 bytes");
            return encoded;
        };
        const withName = (name, operation) => {
            const encoded = nameBytes(name);
            const pointer = module._malloc(encoded.length + 1);
            if (!pointer) throw new Error("Unable to allocate WASM audio name input");
            try {
                module.HEAPU8.set(encoded, pointer);
                module.HEAPU8[pointer + encoded.length] = 0;
                return operation(pointer);
            } finally {
                module._free(pointer);
            }
        };
        const gain = (value, label) => {
            const native = Math.fround(value);
            if (!Number.isFinite(value) || !Number.isFinite(native) || value < 0 || value > 4) {
                throw new RangeError(`${label} must be finite and between 0 and 4`);
            }
            return native;
        };
        const rate = (value) => {
            const native = Math.fround(value);
            if (!Number.isFinite(value) || !Number.isFinite(native) || value < 0.125 || value > 8) {
                throw new RangeError("Audio rate must be finite and between 0.125 and 8");
            }
            return native;
        };
        const bus = (value) => {
            if (!Object.hasOwn(buses, value)) {
                throw new TypeError("Audio bus must be music, effect, or ui");
            }
            const code = buses[value];
            return code;
        };
        const voice = (value) => {
            if (!Number.isInteger(value) || value <= 0 || value > 0xffffffff) {
                throw new TypeError("Audio voice must be a non-zero uint32 handle");
            }
            return value >>> 0;
        };
        return Object.freeze({
            load(name, data) {
                assertAlive();
                const bytes = data instanceof Uint8Array ? data : new Uint8Array(data);
                if (!bytes.length || bytes.length > 32 * 1024 * 1024) {
                    throw new RangeError("Audio data must be 1 byte to 32 MiB");
                }
                const dataPtr = module._malloc(bytes.length);
                if (!dataPtr) throw new Error("Unable to allocate WASM audio input");
                try {
                    module.HEAPU8.set(bytes, dataPtr);
                    withName(name, (namePtr) => status(
                        module._tmath_audio_load(engine, namePtr, dataPtr, bytes.length),
                        "load",
                    ));
                } finally {
                    module._free(dataPtr);
                }
            },
            start() {
                assertAlive();
                status(module._tmath_audio_start(engine), "start");
            },
            play(name, options = {}) {
                assertAlive();
                if (!options || (Object.getPrototypeOf(options) !== Object.prototype
                    && Object.getPrototypeOf(options) !== null)) {
                    throw new TypeError("Audio playback options must be a plain object");
                }
                const fields = new Set(["bus", "gain", "rate", "loop"]);
                const unknown = Object.keys(options).find((key) => !fields.has(key));
                if (unknown) throw new TypeError(`Unknown audio playback option: ${unknown}`);
                const busCode = bus(options.bus ?? "effect");
                const gainValue = gain(options.gain ?? 1, "Audio playback gain");
                const rateValue = rate(options.rate ?? 1);
                const loop = options.loop ?? false;
                if (typeof loop !== "boolean") throw new TypeError("Audio playback loop must be boolean");
                const output = module._malloc(4);
                if (!output) throw new Error("Unable to allocate WASM audio voice output");
                try {
                    return withName(name, (namePtr) => {
                        status(module._tmath_audio_play(
                            engine, namePtr, busCode, gainValue, rateValue, loop ? 1 : 0, output,
                        ), "play");
                        const handle = new Uint32Array(module.HEAPU8.buffer, output, 1)[0];
                        if (!handle) throw new Error("Audio play returned no voice handle");
                        return handle;
                    });
                } finally {
                    module._free(output);
                }
            },
            stop(handle) {
                assertAlive();
                status(module._tmath_audio_stop(engine, voice(handle)), "stop");
            },
            active(handle) {
                assertAlive();
                return module._tmath_audio_active(engine, voice(handle)) !== 0;
            },
            masterGain(value) {
                assertAlive();
                status(module._tmath_audio_master_gain(engine, gain(value, "Audio master gain")), "master gain");
            },
            busGain(name, value) {
                assertAlive();
                status(module._tmath_audio_bus_gain(
                    engine, bus(name), gain(value, "Audio bus gain"),
                ), "bus gain");
            },
            transport(value) {
                assertAlive();
                if (!value || (Object.getPrototypeOf(value) !== Object.prototype
                    && Object.getPrototypeOf(value) !== null)) {
                    throw new TypeError("Audio transport must be a plain object");
                }
                const fields = new Set(["time", "rate", "playing", "seek"]);
                const unknown = Object.keys(value).find((key) => !fields.has(key));
                if (unknown) throw new TypeError(`Unknown audio transport field: ${unknown}`);
                const time = Math.fround(value.time);
                if (!Number.isFinite(value.time) || !Number.isFinite(time) || value.time < 0) {
                    throw new RangeError("Audio transport time must be finite, non-negative, and representable as float32");
                }
                const playing = value.playing ?? false;
                const seek = value.seek ?? false;
                if (typeof playing !== "boolean" || typeof seek !== "boolean") {
                    throw new TypeError("Audio transport playing and seek must be boolean");
                }
                status(module._tmath_audio_transport(
                    engine, time, rate(value.rate ?? 1), playing ? 1 : 0, seek ? 1 : 0,
                ), "transport sync");
            },
        });
    })() : undefined;

    const camera = (action, x = 0, y = 0) => {
        assertAlive();
        const code = CAMERA_ACTIONS[action];
        if (code === undefined) throw new TypeError(`Unknown camera action '${action}'`);
        if (!Number.isFinite(x) || !Number.isFinite(y)) throw new TypeError("Camera deltas must be finite numbers");
        if (typeof module._tmath_camera !== "function") return false;
        const result = module._tmath_camera(engine, code, x, y);
        if (result === 2 || result === 3) return false;
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Camera input failed (${result})`);
        }
        return true;
    };
    const genericInput = typeof module._tmath_input === "function";
    const inputExport = genericInput ? module._tmath_input : module._tmath_ui_input;
    const input = typeof inputExport === "function" ? (event) => {
        assertAlive();
        if (!event || typeof event !== "object") throw new TypeError("Input must be an event object");
        const type = INPUT_TYPES[event.type];
        if (type === undefined) throw new TypeError(`Unknown input type '${event.type}'`);
        const numbers = [
            event.x,
            event.y,
            event.dx,
            event.dy,
            event.wheelX,
            event.wheelY,
            event.time,
        ];
        if (!numbers.every(Number.isFinite) || event.time < 0) {
            throw new TypeError("Input coordinates, deltas, wheel values, and time must be finite and time must be non-negative");
        }
        if (!Number.isInteger(event.button) || event.button < -1 || event.button > 0x7fffffff
            || !Number.isInteger(event.buttons) || event.buttons < 0 || event.buttons > 0xffffffff
            || !Number.isInteger(event.modifiers) || event.modifiers < 0 || event.modifiers > 0xffffffff
            || !Number.isInteger(event.pointerId) || event.pointerId < 0 || event.pointerId > 0xffffffff) {
            throw new TypeError("Input button, buttons, modifiers, and pointer ID must be valid integers");
        }
        const key = inputKey(event.key);
        if (genericInput && type >= INPUT_TYPES.keydown && key === 0) {
            throw new TypeError("Input key is required for keydown and keyup events");
        }
        const flags = (genericInput
            ? inputExport(
                engine,
                type,
                event.x,
                event.y,
                event.dx,
                event.dy,
                event.wheelX,
                event.wheelY,
                event.button,
                event.buttons,
                event.modifiers,
                event.pointerId,
                key,
                event.repeat ? 1 : 0,
                event.time,
            )
            : inputExport(
                engine,
                type,
                event.x,
                event.y,
                event.dx,
                event.dy,
                event.wheelX,
                event.wheelY,
                event.button,
                event.buttons,
                event.modifiers,
                event.pointerId,
                event.time,
            )) >>> 0;
        let sample;
        if (flags & 16) {
            const getters = [
                "_tmath_ui_sample_handle",
                "_tmath_ui_sample_tag",
                "_tmath_ui_sample_type",
                "_tmath_ui_sample_x",
                "_tmath_ui_sample_y",
                "_tmath_ui_sample_u",
                "_tmath_ui_sample_v",
                "_tmath_ui_sample_rgba",
            ];
            if (!getters.every((getter) => typeof module[getter] === "function")) {
                throw new Error("UI sample result is missing its metadata exports");
            }
            const tag = module._tmath_ui_sample_tag(engine);
            const typeName = module._tmath_ui_sample_type(engine);
            const packed = module._tmath_ui_sample_rgba(engine) >>> 0;
            sample = Object.freeze({
                position: Object.freeze({
                    x: module._tmath_ui_sample_x(engine),
                    y: module._tmath_ui_sample_y(engine),
                }),
                value: Object.freeze({
                    x: module._tmath_ui_sample_u(engine),
                    y: module._tmath_ui_sample_v(engine),
                }),
                rgba: Object.freeze([
                    (packed >>> 24) & 0xff,
                    (packed >>> 16) & 0xff,
                    (packed >>> 8) & 0xff,
                    packed & 0xff,
                ]),
                object: Object.freeze({
                    handle: module._tmath_ui_sample_handle(engine) >>> 0,
                    id: tag ? module.UTF8ToString(tag) : null,
                    type: typeName ? module.UTF8ToString(typeName) : "",
                }),
            });
        }
        const result = {
            handled: Boolean(flags & 1),
            redraw: Boolean(flags & 2),
            capture: Boolean(flags & 4),
            release: Boolean(flags & 8),
        };
        if (sample) result.sample = sample;
        if (flags & 32) {
            result.error = module.UTF8ToString(module._tmath_last_error(engine))
                || "Input handling failed";
        }
        return Object.freeze(result);
    } : undefined;
    const stateExports = [
        "_tmath_input_begin",
        "_tmath_input_release",
        "_tmath_input_key_state",
        "_tmath_input_key_begin",
        "_tmath_input_key_end",
        "_tmath_input_pointer_state",
        "_tmath_input_pointer_x",
        "_tmath_input_pointer_y",
        "_tmath_input_pointer_dx",
        "_tmath_input_pointer_dy",
        "_tmath_input_pointer_wheel_x",
        "_tmath_input_pointer_wheel_y",
        "_tmath_input_pointer_previous_buttons",
        "_tmath_input_pointer_buttons",
        "_tmath_input_pointer_pressed",
        "_tmath_input_pointer_released",
    ];
    const hasInputState = stateExports.every((name) => typeof module[name] === "function");
    const beginInputFrame = hasInputState ? (time) => {
        assertAlive();
        if (!Number.isFinite(time) || time < 0) {
            throw new TypeError("Input frame time must be finite and non-negative");
        }
        const result = module._tmath_input_begin(engine, time);
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine))
                || `Input frame begin failed (${result})`);
        }
    } : undefined;
    const releaseInput = hasInputState ? (time) => {
        assertAlive();
        if (!Number.isFinite(time) || time < 0) {
            throw new TypeError("Input release time must be finite and non-negative");
        }
        const flags = module._tmath_input_release(engine, time) >>> 0;
        const result = {
            handled: Boolean(flags & 1),
            redraw: Boolean(flags & 2),
            capture: false,
            release: false,
        };
        if (flags & 32) {
            result.error = module.UTF8ToString(module._tmath_last_error(engine))
                || "Input release failed";
        }
        return Object.freeze(result);
    } : undefined;
    const readKeyState = hasInputState ? (key) => {
        assertAlive();
        const flags = module._tmath_input_key_state(engine, key) >>> 0;
        if (flags === 0xffffffff) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine))
                || "Input key-state query failed");
        }
        return Object.freeze({
            begin: module._tmath_input_key_begin(engine),
            end: module._tmath_input_key_end(engine),
            previous: Boolean(flags & 1),
            down: Boolean(flags & 2),
            pressed: Boolean(flags & 4),
            released: Boolean(flags & 8),
        });
    } : undefined;
    const keyState = hasInputState ? (key) => {
        const code = inputKey(key);
        if (!code) throw new TypeError("Input key is required");
        return readKeyState(code);
    } : undefined;
    const pointerState = hasInputState ? (pointerId = 0) => {
        assertAlive();
        if (!Number.isInteger(pointerId) || pointerId < 0 || pointerId > 0xffffffff) {
            throw new TypeError("Input pointer ID must be a uint32 integer");
        }
        const flags = module._tmath_input_pointer_state(engine, pointerId) >>> 0;
        if (flags === 0xffffffff) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine))
                || "Input pointer-state query failed");
        }
        if (!(flags & 1)) return null;
        return Object.freeze({
            pointerId,
            position: Object.freeze({
                x: module._tmath_input_pointer_x(engine),
                y: module._tmath_input_pointer_y(engine),
            }),
            delta: Object.freeze({
                x: module._tmath_input_pointer_dx(engine),
                y: module._tmath_input_pointer_dy(engine),
            }),
            wheel: Object.freeze({
                x: module._tmath_input_pointer_wheel_x(engine),
                y: module._tmath_input_pointer_wheel_y(engine),
            }),
            previousButtons: module._tmath_input_pointer_previous_buttons(engine) >>> 0,
            buttons: module._tmath_input_pointer_buttons(engine) >>> 0,
            pressed: module._tmath_input_pointer_pressed(engine) >>> 0,
            released: module._tmath_input_pointer_released(engine) >>> 0,
            active: Boolean(flags & 2),
        });
    } : undefined;
    const actionMap = hasInputState
        ? () => createInputActionMap(readKeyState, pointerState)
        : undefined;
    const retainedRuntimeExports = [
        "_tmath_runtime_active",
        "_tmath_runtime_advance",
        "_tmath_runtime_time",
        "_tmath_runtime_dropped",
        "_tmath_runtime_tick",
        "_tmath_runtime_steps",
        "_tmath_runtime_interpolation",
    ];
    const hasRetainedRuntime = retainedRuntimeExports.every(
        (exportName) => typeof module[exportName] === "function",
    );
    const hasRuntimeSounds = typeof module._tmath_runtime_sound_count === "function"
        && typeof module._tmath_runtime_sound === "function";
    const runtimeSounds = () => {
        if (!hasRuntimeSounds) return Object.freeze([]);
        const count = module._tmath_runtime_sound_count(engine) >>> 0;
        if (!count) return Object.freeze([]);
        if (count > 64) throw new Error("Retained runtime returned too many sound events");
        const buffer = module._malloc(272);
        if (!buffer) throw new Error("Unable to allocate retained runtime sound output");
        const assetPtr = buffer;
        const busPtr = buffer + 256;
        const gainPtr = buffer + 260;
        const ratePtr = buffer + 264;
        const loopPtr = buffer + 268;
        const buses = ["music", "effect", "ui"];
        const sounds = [];
        try {
            for (let index = 0; index < count; index += 1) {
                const result = module._tmath_runtime_sound(
                    engine, index, assetPtr, 256,
                    busPtr, gainPtr, ratePtr, loopPtr,
                );
                if (result !== 0) {
                    throw new Error(`Retained runtime sound query failed (${result})`);
                }
                const bus = new Uint32Array(module.HEAPU8.buffer, busPtr, 1)[0];
                sounds.push(Object.freeze({
                    asset: module.UTF8ToString(assetPtr),
                    bus: buses[bus] ?? "effect",
                    gain: new Float32Array(module.HEAPU8.buffer, gainPtr, 1)[0],
                    rate: new Float32Array(module.HEAPU8.buffer, ratePtr, 1)[0],
                    loop: module.HEAPU8[loopPtr] !== 0,
                }));
            }
        } finally {
            module._free(buffer);
        }
        return Object.freeze(sounds);
    };
    const retainedLua = () => {
        assertAlive();
        return hasRetainedRuntime && module._tmath_runtime_active(engine) !== 0;
    };
    const advanceRuntime = hasRetainedRuntime ? (elapsed) => {
        assertAlive();
        const nativeElapsed = Math.fround(elapsed);
        if (!Number.isFinite(elapsed) || elapsed < 0 || !Number.isFinite(nativeElapsed)) {
            throw new RangeError("Retained runtime elapsed time must be finite, non-negative, and representable as float32");
        }
        if (!retainedLua()) return null;
        const result = module._tmath_runtime_advance(engine, nativeElapsed);
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine))
                || `Retained runtime advance failed (${result})`);
        }
        return Object.freeze({
            time: module._tmath_runtime_time(engine),
            dropped: module._tmath_runtime_dropped(engine),
            tick: module._tmath_runtime_tick(engine),
            steps: module._tmath_runtime_steps(engine) >>> 0,
            interpolation: module._tmath_runtime_interpolation(engine),
            sounds: runtimeSounds(),
        });
    } : undefined;
    const hostTheme = (palette) => {
        assertAlive();
        if (!palette || typeof palette !== "object" || typeof palette.dark !== "boolean") {
            throw new TypeError("Host theme must include a boolean dark value and color strings");
        }
        if (!Array.isArray(palette.objects) || !palette.objects.length || palette.objects.length > 10) {
            throw new TypeError("Host theme objects must contain 1 to 10 colors");
        }
        const objectColors = palette.objects.map((color, index) =>
            rgba(color, `Host theme object color ${index + 1}`));
        const objectsPtr = module._malloc(objectColors.length * 4);
        if (!objectsPtr) throw new Error("Unable to allocate WASM host theme palette");
        let result;
        try {
            new Uint32Array(module.HEAPU8.buffer, objectsPtr, objectColors.length).set(objectColors);
            result = module._tmath_host_theme(
                engine,
                palette.dark ? 1 : 0,
                rgba(palette.background, "Host theme background"),
                rgba(palette.foreground, "Host theme foreground"),
                rgba(palette.muted, "Host theme muted color"),
                rgba(palette.accent, "Host theme accent"),
                rgba(palette.secondary, "Host theme secondary color"),
                rgba(palette.success, "Host theme success color"),
                rgba(palette.warning, "Host theme warning color"),
                rgba(palette.danger, "Host theme danger color"),
                rgba(palette.info, "Host theme info color"),
                rgba(palette.surface, "Host theme surface color"),
                rgba(palette.line, "Host theme line color"),
                rgba(palette.result, "Host theme result color"),
                rgba(palette.focus, "Host theme focus color"),
                objectsPtr,
                objectColors.length,
            );
        } finally {
            module._free(objectsPtr);
        }
        if (result !== 0) {
            throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Host theme failed (${result})`);
        }
    };

    return {
        get duration() {
            assertAlive();
            return module._tmath_duration(engine);
        },
        get renderEngine() {
            assertAlive();
            return renderEngine;
        },
        get loop() {
            assertAlive();
            return module._tmath_loop(engine) !== 0;
        },
        get cameraMode() {
            assertAlive();
            return module._tmath_camera_mode(engine) === 1 ? "interactive" : "fixed";
        },
        get cameraView() {
            assertAlive();
            return module._tmath_camera_view(engine) === 1 ? "3d" : "2d";
        },
        get adaptiveTheme() {
            assertAlive();
            return module._tmath_adaptive_theme(engine) !== 0;
        },
        get retainedLua() {
            return retainedLua();
        },
        get runtimeTime() {
            assertAlive();
            return retainedLua() ? module._tmath_runtime_time(engine) : 0;
        },
        load,
        loadLua,
        loadScene,
        render,
        lottie,
        bounds,
        intersects,
        layoutReport,
        font,
        asset,
        ...(audio ? {audio} : {}),
        camera,
        ...(input ? {input} : {}),
        ...(hasInputState ? {
            beginInputFrame,
            releaseInput,
            keyState,
            pointerState,
            actionMap,
        } : {}),
        ...(advanceRuntime ? {advanceRuntime} : {}),
        hostTheme,
        draw(canvas, time, pixelRatio = 1) {
            assertAlive();
            const logicalWidth = module._tmath_width(engine);
            const logicalHeight = module._tmath_height(engine);
            if (!Number.isInteger(pixelRatio) || pixelRatio < 1 || pixelRatio > 0xffffffff
                || logicalWidth > Math.floor(0xffffffff / pixelRatio)
                || logicalHeight > Math.floor(0xffffffff / pixelRatio)) {
                throw new Error("Pixel ratio must be a positive integer within the render size limit");
            }
            const width = logicalWidth * pixelRatio;
            const height = logicalHeight * pixelRatio;
            if (height > Math.floor(67108864 / width)) {
                throw new Error("Rendered canvas must contain at most 67108864 pixels");
            }
            if (canvas.width !== width) canvas.width = width;
            if (canvas.height !== height) canvas.height = height;
            canvas.getContext("2d").putImageData(
                new ImageData(renderFrame(time, false, pixelRatio), width, height),
                0,
                0,
            );
        },
        size() {
            assertAlive();
            return [module._tmath_width(engine), module._tmath_height(engine)];
        },
        resize(width, height) {
            assertAlive();
            if (!Number.isInteger(width) || !Number.isInteger(height) || width <= 0 || height <= 0 ||
                width > 0xffffffff || height > Math.floor(67108864 / width)) {
                throw new Error("Size must be positive integers with at most 67108864 pixels");
            }
            const result = module._tmath_resize(engine, width, height);
            if (result !== 0) throw new Error(module.UTF8ToString(module._tmath_last_error(engine)) || `Resize failed (${result})`);
        },
        destroy() {
            if (!engine) return;
            module._tmath_destroy(engine);
            engine = 0;
        },
    };
}
