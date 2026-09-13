const OBJECTS = [
    "point",
    "line",
    "arrow",
    "vector",
    "circle",
    "rectangle",
    "polygon",
    "plot",
    "route",
    "path",
    "curve",
    "surface",
    "text",
    "ruler",
    "svg",
    "image",
    "cell",
];

const FACTORIES = ["group", "space", ...OBJECTS];
const PLAY_PROPERTIES = ["shift", "transform", "opacity", "stroke", "fill", "dash_offset", "tail", "tip"];
const CREATE_DIRECTIONS = new Set(["forward", "reverse", "clockwise", "counterclockwise"]);
const GROWTH_EDGES = new Set(["left", "right", "bottom", "top"]);
const STYLE_CHANNELS = new Set(["stroke", "fill", "both"]);
const AUDIO_BUSES = new Set(["music", "effect", "ui"]);
const ANIM_CURVE_PRESETS = new Set([
    "linear",
    "smooth",
    "ease_in",
    "ease_out",
    "ease_in_out",
    "gentle",
    "snappy",
    "back",
    "bounce",
    "elastic",
]);
const FADE_OPTIONS = Object.freeze({
    shift: [0, 0, 0],
    scale: 1,
    duration: 1,
    easing: "smooth",
});
const INDICATE_OPTIONS = Object.freeze({
    color: "focus",
    scale: 1.2,
    duration: 1,
    easing: "smooth",
});

const SCENE_OWNERS = new WeakMap();
const SCENE_SNAPSHOTS = new WeakMap();
const SCENE_STATES = new WeakMap();
const HANDLE_TYPES = new WeakMap();
const SPACE_RANGES = new WeakMap();

function _string(value) {
    if (value.includes("\0")) throw new TypeError("Strings cannot contain zero bytes");
    const escaped = value.replace(/[\\"\x01-\x1f\x7f]/g, (character) => {
        if (character === "\\") return "\\\\";
        if (character === '"') return '\\"';
        if (character === "\n") return "\\n";
        if (character === "\r") return "\\r";
        if (character === "\t") return "\\t";
        return `\\${character.charCodeAt(0).toString().padStart(3, "0")}`;
    });
    return `"${escaped}"`;
}

function _lua(value) {
    if (typeof value === "number") {
        if (!Number.isFinite(value)) throw new TypeError("Scene numbers must be finite");
        return Object.is(value, -0) ? "0" : String(value);
    }
    if (typeof value === "string") return _string(value);
    if (typeof value === "boolean") return value ? "true" : "false";
    if (Array.isArray(value)) return `{${value.map(_lua).join(",")}}`;
    if (value && (Object.getPrototypeOf(value) === Object.prototype || Object.getPrototypeOf(value) === null)) {
        return `{${Object.keys(value)
            .sort()
            .map((key) => `[${_string(key)}]=${_lua(value[key])}`)
            .join(",")}}`;
    }
    throw new TypeError("Scene values must be finite numbers, strings, booleans, arrays, or plain objects");
}

function _spaceRange(value, name) {
    if (value === undefined) return Object.freeze([-5, 5, 1]);
    let range;
    if (Array.isArray(value) && value.length === 3) range = value;
    else if (
        value &&
        (Object.getPrototypeOf(value) === Object.prototype || Object.getPrototypeOf(value) === null) &&
        Object.hasOwn(value, "min") &&
        Object.hasOwn(value, "max") &&
        Object.hasOwn(value, "step")
    ) {
        range = [value.min, value.max, value.step];
    } else {
        throw new TypeError(`${name} must contain min, max, and step`);
    }
    const normalized = range.map(Math.fround);
    if (!normalized.every(Number.isFinite) || normalized[0] > normalized[1] || normalized[2] <= 0) {
        throw new RangeError(`${name} must be finite with min <= max and step > 0`);
    }
    return Object.freeze(normalized);
}

function _spaceRanges(options) {
    return Object.freeze([
        _spaceRange(options.x, "Space x range"),
        _spaceRange(options.y, "Space y range"),
        _spaceRange(options.z, "Space z range"),
    ]);
}

function _sampleAxis(range, name) {
    const [minimum, maximum, step] = range;
    const exactStart = Math.ceil(minimum / step) * step;
    const count = Math.floor((maximum + step * 0.001 - exactStart) / step) + 1;
    if (!Number.isFinite(exactStart) || count < 1 || count > 4096) {
        throw new RangeError(`${name} range has no samples or exceeds 4096 samples per axis`);
    }
    return Object.freeze({start: Math.fround(exactStart), step, count});
}

function _sampleColor(value, name) {
    if (typeof value !== "string" || !/^#?(?:[0-9a-f]{3,4}|[0-9a-f]{6}|[0-9a-f]{8})$/i.test(value)) {
        throw new TypeError(`${name} callback must return a #rgb, #rgba, #rrggbb, or #rrggbbaa color`);
    }
    return value;
}

function _viewportBounds(bounds) {
    if (!bounds || (Object.getPrototypeOf(bounds) !== Object.prototype && Object.getPrototypeOf(bounds) !== null)) {
        throw new TypeError("Viewport bounds must be a normalized rectangle");
    }
    const { x, y, width, height } = bounds;
    if (
        ![x, y, width, height].every(Number.isFinite) ||
        x < 0 ||
        y < 0 ||
        width <= 0 ||
        height <= 0 ||
        x + width > 1 ||
        y + height > 1
    ) {
        throw new RangeError("Viewport bounds must be finite, positive, and normalized within 0..1");
    }
    return { x, y, width, height };
}

function _direction(value) {
    if (!CREATE_DIRECTIONS.has(value)) {
        throw new TypeError("Create direction must be forward, reverse, clockwise, or counterclockwise");
    }
    return value;
}

function _growthEdge(value) {
    if (!GROWTH_EDGES.has(value)) {
        throw new TypeError("Growth edge must be left, right, bottom, or top");
    }
    return value;
}

function _curveStrength(value) {
    if (!Number.isFinite(value) || value < 0 || value > 2) {
        throw new RangeError("Animation curve strength must be a finite number between 0 and 2");
    }
    return value;
}

function _curvePreset(preset, strength = 1) {
    if (!ANIM_CURVE_PRESETS.has(preset)) {
        throw new TypeError(`Unknown animation curve preset: ${preset}`);
    }
    return Object.freeze({ preset, strength: _curveStrength(strength) });
}

function _cubicBezier(x1, y1, x2, y2, strength = 1) {
    if (
        ![x1, y1, x2, y2].every(Number.isFinite) ||
        x1 < 0 ||
        x1 > 1 ||
        x2 < 0 ||
        x2 > 1 ||
        y1 < -2 ||
        y1 > 2 ||
        y2 < -2 ||
        y2 > 2
    ) {
        throw new RangeError("Cubic Bezier controls require x in 0..1 and y in -2..2");
    }
    return Object.freeze({
        bezier: Object.freeze([x1, y1, x2, y2]),
        strength: _curveStrength(strength),
    });
}

function _reverseCurve(value) {
    let curve;
    if (typeof value === "string") {
        curve = _curvePreset(value);
    } else if (value && (Object.getPrototypeOf(value) === Object.prototype || Object.getPrototypeOf(value) === null)) {
        const unknown = Object.keys(value).filter(
            (key) => key !== "preset" && key !== "bezier" && key !== "strength" && key !== "reverse",
        );
        if (unknown.length) throw new TypeError(`Unknown animation curve option: ${unknown[0]}`);
        const hasPreset = Object.hasOwn(value, "preset");
        const hasBezier = Object.hasOwn(value, "bezier");
        if (hasPreset === hasBezier) throw new TypeError("Animation curve requires exactly one of preset or bezier");
        if (Object.hasOwn(value, "reverse") && typeof value.reverse !== "boolean") {
            throw new TypeError("Animation curve reverse must be a boolean");
        }
        if (hasPreset) curve = _curvePreset(value.preset, value.strength ?? 1);
        else if (Array.isArray(value.bezier) && value.bezier.length === 4) {
            curve = _cubicBezier(...value.bezier, value.strength ?? 1);
        } else {
            throw new TypeError("Animation curve bezier must contain four numbers");
        }
        if (value.reverse) curve = Object.freeze({...curve, reverse: true});
    } else {
        throw new TypeError("Animation curve must be a preset string or curve object");
    }
    if (!curve.reverse) return Object.freeze({...curve, reverse: true});
    const {reverse, ...forward} = curve;
    return Object.freeze(forward);
}

function _effectOptions(value, defaults, name, minimumScale) {
    if (!value || (Object.getPrototypeOf(value) !== Object.prototype && Object.getPrototypeOf(value) !== null)) {
        throw new TypeError(`${name} options must be a plain object`);
    }
    const unknown = Object.keys(value).filter((key) => !Object.hasOwn(defaults, key) && key !== "curve");
    if (unknown.length) throw new TypeError(`Unknown ${name} option: ${unknown[0]}`);
    if (Object.hasOwn(value, "easing") && Object.hasOwn(value, "curve")) {
        throw new TypeError(`${name} options must use either easing or curve, not both`);
    }
    const options = { ...defaults, ...value };
    if (Object.hasOwn(value, "curve")) delete options.easing;
    if (!Number.isFinite(options.scale) || options.scale <= minimumScale) {
        const comparison = minimumScale === 1 ? "greater than 1" : "positive";
        throw new RangeError(`${name} scale must be a finite ${comparison} number`);
    }
    return options;
}

function _snapshot(scene) {
    const existing = SCENE_SNAPSHOTS.get(scene);
    if (existing) return existing;
    const state = SCENE_STATES.get(scene);
    const snapshot = { config: state.config, lines: [] };
    SCENE_SNAPSHOTS.set(scene, snapshot);
    for (const line of state.lines) {
        if (typeof line === "function") snapshot.lines.push(line);
        else snapshot.lines.push(line);
    }
    Object.freeze(snapshot.lines);
    return Object.freeze(snapshot);
}

function _compile(config, lines, scene, depth) {
    const indent = "    ".repeat(depth);
    const output = [`${indent}local ${scene} = tmath.scene ${config}`];
    for (const line of lines) {
        if (typeof line === "function") {
            output.push(`${indent}${line(scene)}`);
            continue;
        }
        output.push(`${indent}do`);
        if (line.kind === "viewport") {
            const child = `viewportScene${depth + 1}`;
            output.push(..._compile(line.snapshot.config, line.snapshot.lines, child, depth + 1));
            output.push(`${indent}    ${scene}:viewport(${child},${line.rect})`);
        } else {
            const stages = [];
            for (let index = 0; index < line.snapshots.length; index++) {
                const child = `transitionScene${depth + 1}_${index + 1}`;
                const snapshot = line.snapshots[index];
                stages.push(child);
                output.push(..._compile(snapshot.config, snapshot.lines, child, depth + 1));
            }
            output.push(`${indent}    ${scene}:scene_transition({${stages.join(",")}},${line.options})`);
        }
        output.push(`${indent}end`);
    }
    return output;
}

class Handle {
    constructor(owner, name, type = "object") {
        this.owner = owner;
        this.name = name;
        HANDLE_TYPES.set(this, type);
        Object.freeze(this);
    }

    _object(method, options) {
        return this.owner._object(method, options, this);
    }

    connector(from, to, options = {}) {
        return this.owner._connector(from, to, options, this);
    }

    moveTo(point) {
        this.owner._assertMutable();
        const value = _lua(point);
        SCENE_STATES.get(this.owner).lines.push(() => `${this.name}:move_to(${value})`);
        return this;
    }

    nextTo(target, direction, gap = 0.25) {
        this.owner._assertMutable();
        const targetName = this.owner._handle(target);
        const directionValue = _lua(direction);
        const gapValue = _lua(gap);
        SCENE_STATES.get(this.owner).lines.push(
            () => `${this.name}:next_to(${targetName},${directionValue},${gapValue})`,
        );
        return this;
    }

    alignTo(target, direction) {
        this.owner._assertMutable();
        const targetName = this.owner._handle(target);
        const directionValue = _lua(direction);
        SCENE_STATES.get(this.owner).lines.push(() => `${this.name}:align_to(${targetName},${directionValue})`);
        return this;
    }
}

export class StyleGroupHandle {
    constructor(owner, name) {
        this.owner = owner;
        this.name = name;
        Object.freeze(this);
    }
}

export class AudioCueHandle {
    constructor(owner, name) {
        this.owner = owner;
        this.name = name;
        Object.freeze(this);
    }

    gain(value, begin, duration = 1, curve = "smooth") {
        this.owner._assertMutable();
        if (!Number.isFinite(value) || value < 0 || value > 4) {
            throw new RangeError("Audio gain must be finite and between 0 and 4");
        }
        if (!Number.isFinite(begin) || begin < 0) {
            throw new RangeError("Audio gain begin must be finite and non-negative");
        }
        if (!Number.isFinite(duration) || duration <= 0) {
            throw new RangeError("Audio gain duration must be finite and positive");
        }
        const values = [value, begin, duration, curve].map(_lua).join(",");
        SCENE_STATES.get(this.owner).lines.push(() => `${this.name}:gain(${values})`);
        return this;
    }
}

class GroupHandle extends Handle {
    arrange(direction = [1, 0, 0], gap = 0.25) {
        this.owner._assertMutable();
        const directionValue = _lua(direction);
        const gapValue = _lua(gap);
        SCENE_STATES.get(this.owner).lines.push(() => `${this.name}:arrange(${directionValue},${gapValue})`);
        return this;
    }

    arrangeGrid(columns, columnGap = 0.25, rowGap = 0.25) {
        this.owner._assertMutable();
        const columnsValue = _lua(columns);
        const columnGapValue = _lua(columnGap);
        const rowGapValue = _lua(rowGap);
        SCENE_STATES.get(this.owner).lines.push(
            () => `${this.name}:arrange_grid(${columnsValue},${columnGapValue},${rowGapValue})`,
        );
        return this;
    }
}

function _sampleField(handle, callback, options, spatial) {
    handle.owner._assertMutable();
    const name = spatial ? "voxel" : "cell";
    if (typeof callback !== "function") throw new TypeError(`${name} callback must be a function`);
    if (!options || (Object.getPrototypeOf(options) !== Object.prototype && Object.getPrototypeOf(options) !== null)) {
        throw new TypeError(`${name} options must be a plain object`);
    }
    const unknown = Object.keys(options).filter(
        (key) => key !== "mode" && key !== "padding" && key !== "duration" && key !== "fps",
    );
    if (unknown.length) throw new TypeError(`Unknown ${name} option: ${unknown[0]}`);
    const mode = options.mode ?? "padd";
    const padding = options.padding ?? 0.05;
    const durationValue = options.duration ?? 0;
    const fps = options.fps ?? 30;
    if (mode !== "full" && mode !== "padd") {
        throw new TypeError(`${name} mode must be full or padd`);
    }
    if (!Number.isFinite(padding) || padding < 0 || padding >= 0.5) {
        throw new RangeError(`${name} padding must be finite and between 0 and 0.5`);
    }
    if (!Number.isFinite(durationValue) || durationValue < 0) {
        throw new RangeError(`${name} duration must be a finite non-negative number`);
    }
    const duration = Math.fround(durationValue);
    if (!Number.isFinite(duration)) {
        throw new RangeError(`${name} duration exceeds the native number range`);
    }
    if (!Number.isInteger(fps) || fps <= 0 || fps > 0xffffffff) {
        throw new RangeError(`${name} fps must be a positive 32-bit integer`);
    }
    const dimensions = spatial ? 3 : 2;
    const axes = SPACE_RANGES.get(handle).slice(0, dimensions).map((range) => _sampleAxis(range, name));
    const slice = axes[0].count * axes[1].count;
    const depth = spatial ? axes[2].count : 1;
    if (slice > 16384 || slice * depth > 65536) {
        throw new RangeError(`${name} exceeds the 16384-cell slice or 65536-voxel limit`);
    }
    const intervals = duration === 0 ? 0 : Math.ceil(duration * fps);
    if (intervals > 4095) {
        throw new RangeError(`${name} exceeds the 4096-frame limit`);
    }
    const frames = intervals + 1;
    if (slice * depth * frames > 262144) {
        throw new RangeError(`${name} exceeds the 262144-color sample limit`);
    }
    const state = SCENE_STATES.get(handle.owner);
    const colors = [];
    state.sampleActive = true;
    try {
        for (let frame = 0; frame < frames; frame++) {
            const time = frames > 1 ? Math.fround(duration * frame / (frames - 1)) : 0;
            for (let iz = 0; iz < depth; iz++) {
                const z = spatial ? Math.fround(axes[2].start + Math.fround(iz * axes[2].step)) : 0;
                for (let iy = 0; iy < axes[1].count; iy++) {
                    const y = Math.fround(axes[1].start + Math.fround(iy * axes[1].step));
                    for (let ix = 0; ix < axes[0].count; ix++) {
                        const x = Math.fround(axes[0].start + Math.fround(ix * axes[0].step));
                        colors.push(_sampleColor(
                            spatial ? callback(x, y, z, time) : callback(x, y, time),
                            name,
                        ));
                    }
                }
            }
        }
    } finally {
        state.sampleActive = false;
    }
    const object = `object${++state.handles}`;
    const colorName = `${object}Colors`;
    const indexName = `${object}Index`;
    const settings = `{mode=${_string(mode)},padding=${_lua(padding)},duration=${_lua(duration)},fps=${fps}}`;
    const values = _lua(colors);
    const parameters = spatial ? "x,y,z,time" : "x,y,time";
    state.lines.push(() =>
        `local ${colorName}=${values};local ${indexName}=0;local ${object}=${handle.name}:${name}(function(${parameters}) ${indexName}=${indexName}+1;return ${colorName}[${indexName}] end,${settings})`,
    );
    return new GroupHandle(handle.owner, object, "group");
}

class SpaceHandle extends Handle {
    constructor(owner, name, type, ranges) {
        super(owner, name, type);
        SPACE_RANGES.set(this, ranges);
    }

    cell(value = {}, options = {}) {
        if (typeof value === "function") return _sampleField(this, value, options, false);
        return this._object("cell", value);
    }

    voxel(callback, options = {}) {
        return _sampleField(this, callback, options, true);
    }
}

for (const method of FACTORIES) {
    Handle.prototype[method] = function (options = {}) {
        return this._object(method, options);
    };
}

Handle.prototype.label = function (options = {}) {
    return this._object("label", options);
};

function _makeHandle(owner, name, method, options) {
    if (method === "group") return new GroupHandle(owner, name, method);
    if (method === "space") return new SpaceHandle(owner, name, method, _spaceRanges(options));
    return new Handle(owner, name, method);
}

export class SceneBuilder {
    constructor(config = {}) {
        SCENE_STATES.set(this, {
            config: _lua(config), lines: [], handles: 0, styles: 0, audio: 0,
            transition: false, sampleActive: false,
        });
        Object.freeze(this);
    }

    _assertMutable() {
        if (SCENE_OWNERS.has(this)) throw new TypeError("Viewport child scene is sealed");
        if (SCENE_STATES.get(this).sampleActive) {
            throw new TypeError("Scene authoring is unavailable inside a sampling callback");
        }
    }

    _object(method, options, parent = null) {
        this._assertMutable();
        const state = SCENE_STATES.get(this);
        const name = `object${++state.handles}`;
        const value = _lua(options);
        state.lines.push((scene) => `local ${name} = ${parent ? parent.name : scene}:${method} ${value}`);
        return _makeHandle(this, name, method, options);
    }

    connector(from, to, options = {}) {
        return this._connector(from, to, options);
    }

    sound(options) {
        this._assertMutable();
        if (!options || (Object.getPrototypeOf(options) !== Object.prototype
            && Object.getPrototypeOf(options) !== null)) {
            throw new TypeError("Sound options must be a plain object");
        }
        const fields = new Set(["asset", "bus", "begin", "end", "gain", "loop"]);
        const unknown = Object.keys(options).find((key) => !fields.has(key));
        if (unknown) throw new TypeError(`Unknown Sound option: ${unknown}`);
        if (typeof options.asset !== "string" || !options.asset.length
            || options.asset.includes("\0")
            || new TextEncoder().encode(options.asset).length > 255) {
            throw new TypeError("Sound asset must be 1 to 255 UTF-8 bytes without zero bytes");
        }
        const bus = options.bus ?? "effect";
        const begin = options.begin ?? 0;
        const end = options.end ?? 0;
        const gain = options.gain ?? 1;
        const loop = options.loop ?? false;
        if (!AUDIO_BUSES.has(bus)) throw new TypeError("Sound bus must be music, effect, or ui");
        if (!Number.isFinite(begin) || begin < 0) {
            throw new RangeError("Sound begin must be finite and non-negative");
        }
        if (!Number.isFinite(end) || (end !== 0 && end <= begin)) {
            throw new RangeError("Sound end must be zero or greater than begin");
        }
        if (!Number.isFinite(gain) || gain < 0 || gain > 4) {
            throw new RangeError("Sound gain must be finite and between 0 and 4");
        }
        if (typeof loop !== "boolean") throw new TypeError("Sound loop must be boolean");
        const state = SCENE_STATES.get(this);
        const name = `audio${++state.audio}`;
        const value = _lua({asset: options.asset, bus, begin, end, gain, loop});
        state.lines.push((scene) => `local ${name}=tmath.audio.cue(${scene},${value})`);
        return new AudioCueHandle(this, name);
    }

    _connector(from, to, options, parent = null) {
        this._assertMutable();
        const fromName = this._handle(from);
        const toName = this._handle(to);
        if (
            !options ||
            (Object.getPrototypeOf(options) !== Object.prototype && Object.getPrototypeOf(options) !== null)
        ) {
            throw new TypeError("Connector options must be a plain object");
        }
        if (Object.hasOwn(options, "from") || Object.hasOwn(options, "to")) {
            throw new TypeError("Connector endpoints must be passed as handles");
        }
        const fields = Object.keys(options)
            .sort()
            .map((key) => `[${_string(key)}]=${_lua(options[key])}`);
        const state = SCENE_STATES.get(this);
        const name = `object${++state.handles}`;
        const value = `{from=${fromName},to=${toName}${fields.length ? `,${fields.join(",")}` : ""}}`;
        state.lines.push((scene) => `local ${name} = ${parent ? parent.name : scene}:connector ${value}`);
        return new Handle(this, name, "connector");
    }

    viewport(child, bounds) {
        if (!(child instanceof SceneBuilder)) throw new TypeError("Viewport child must be a tmath JS scene");
        if (child === this) throw new TypeError("A scene cannot be its own viewport child");
        for (let parent = this; parent; parent = SCENE_OWNERS.get(parent)) {
            if (parent === child) throw new TypeError("Viewport scenes cannot form a cycle");
        }
        this._assertMutable();
        if (SCENE_OWNERS.has(child)) throw new TypeError("Viewport child scene is already owned");
        const rect = _lua(_viewportBounds(bounds));
        const snapshot = _snapshot(child);
        SCENE_OWNERS.set(child, this);
        SCENE_STATES.get(this).lines.push(Object.freeze({ kind: "viewport", snapshot, rect }));
        return this;
    }

    sceneTransition(stages, options = {}) {
        this._assertMutable();
        if (!Array.isArray(stages) || stages.length < 2) {
            throw new TypeError("Scene transition requires at least two stage scenes");
        }
        if (stages.length > 16) throw new RangeError("Scene transition supports at most 16 stages");
        const state = SCENE_STATES.get(this);
        if (state.transition) throw new TypeError("A scene can own only one scene transition");
        if (
            !options ||
            (Object.getPrototypeOf(options) !== Object.prototype && Object.getPrototypeOf(options) !== null)
        ) {
            throw new TypeError("Scene transition options must be a plain object");
        }
        const allowed = new Set(["duration", "hold", "easing", "curve", "viewport"]);
        const unknown = Object.keys(options).find((key) => !allowed.has(key));
        if (unknown) throw new TypeError(`Unknown scene transition option: ${unknown}`);
        if (Object.hasOwn(options, "easing") && Object.hasOwn(options, "curve")) {
            throw new TypeError("Scene transition options must use either easing or curve, not both");
        }
        const normalized = { ...options };
        if (!Object.hasOwn(normalized, "duration")) normalized.duration = 1;
        if (!Object.hasOwn(normalized, "hold")) normalized.hold = 0;
        if (!Object.hasOwn(normalized, "easing") && !Object.hasOwn(normalized, "curve")) {
            normalized.easing = "smooth";
        }
        if (!Number.isFinite(normalized.duration) || normalized.duration <= 0) {
            throw new RangeError("Scene transition duration must be a finite positive number");
        }
        if (!Number.isFinite(normalized.hold) || normalized.hold < 0) {
            throw new RangeError("Scene transition hold must be a finite non-negative number");
        }
        if (Object.hasOwn(normalized, "viewport")) {
            normalized.viewport = _viewportBounds(normalized.viewport);
        }

        const unique = new Set();
        for (const child of stages) {
            if (!(child instanceof SceneBuilder)) {
                throw new TypeError("Scene transition stages must be tmath JS scenes");
            }
            if (child === this) throw new TypeError("A scene cannot transition to itself");
            if (unique.has(child)) throw new TypeError("Scene transition stages must be unique");
            unique.add(child);
            for (let parent = this; parent; parent = SCENE_OWNERS.get(parent)) {
                if (parent === child) throw new TypeError("Scene transitions cannot form a cycle");
            }
            if (SCENE_OWNERS.has(child)) throw new TypeError("Scene transition stage is already owned");
        }
        const compiledOptions = _lua(normalized);
        const snapshots = Object.freeze(stages.map(_snapshot));
        for (const child of stages) SCENE_OWNERS.set(child, this);
        state.lines.push(
            Object.freeze({
                kind: "transition",
                snapshots,
                options: compiledOptions,
            }),
        );
        state.transition = true;
        return this;
    }

    _target(value) {
        if (value instanceof Handle && value.owner === this) return value.name;
        if (Array.isArray(value) && value.length) return `{${value.map((item) => this._target(item)).join(",")}}`;
        throw new TypeError("Animation targets must be handles from the same scene");
    }

    _handle(value) {
        if (value instanceof Handle && value.owner === this) return value.name;
        throw new TypeError("Object references must be handles from the same scene");
    }

    _styleHandle(value) {
        if (value instanceof StyleGroupHandle && value.owner === this) return value.name;
        throw new TypeError("Style group must be a handle from the same scene");
    }

    styleGroup(options) {
        this._assertMutable();
        if (!options || (Object.getPrototypeOf(options) !== Object.prototype
            && Object.getPrototypeOf(options) !== null)) {
            throw new TypeError("Style group options must be a plain object");
        }
        const unknown = Object.keys(options).find((key) => key !== "color" && key !== "members");
        if (unknown) throw new TypeError(`Unknown StyleGroup option: ${unknown}`);
        if (!Array.isArray(options.members) || !options.members.length) {
            throw new TypeError("Style group requires at least one member");
        }
        const members = options.members.map((member) => {
            if (!member || (Object.getPrototypeOf(member) !== Object.prototype
                && Object.getPrototypeOf(member) !== null)) {
                throw new TypeError("Style group members must be plain objects");
            }
            const memberUnknown = Object.keys(member).find((key) => key !== "target" && key !== "channel");
            if (memberUnknown) throw new TypeError(`Unknown StyleGroup member option: ${memberUnknown}`);
            const target = this._handle(member.target);
            const channel = member.channel ?? "both";
            if (!STYLE_CHANNELS.has(channel)) {
                throw new TypeError("Style channel must be stroke, fill, or both");
            }
            return `{target=${target},channel=${_lua(channel)}}`;
        });
        const state = SCENE_STATES.get(this);
        const name = `style${++state.styles}`;
        const color = Object.hasOwn(options, "color") ? `color=${_lua(options.color)},` : "";
        state.lines.push((scene) =>
            `local ${name}=${scene}:style_group{${color}members={${members.join(",")}}}`,
        );
        return new StyleGroupHandle(this, name);
    }

    styleBind(group, target, channel = "both") {
        this._assertMutable();
        if (!STYLE_CHANNELS.has(channel)) throw new TypeError("Style channel must be stroke, fill, or both");
        const groupName = this._styleHandle(group);
        const targetName = this._handle(target);
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:style_bind(${groupName},${targetName},${_lua(channel)})`,
        );
        return this;
    }

    style(group, color, duration = 1, curve = "smooth") {
        this._assertMutable();
        const groupName = this._styleHandle(group);
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:style(${groupName},${_lua(color)},${_lua(duration)},${_lua(curve)})`,
        );
        return this;
    }

    _assertTransformable(value) {
        if (value instanceof Handle && value.owner === this) {
            if (HANDLE_TYPES.get(value) === "connector") {
                throw new TypeError("Connector geometry follows its endpoints and cannot be shifted or transformed");
            }
            return;
        }
        if (Array.isArray(value) && value.length) {
            for (const item of value) this._assertTransformable(item);
        }
    }

    _animate(method, target, values) {
        this._assertMutable();
        const targetName = this._target(target);
        const argumentsList = values.map(_lua).join(",");
        SCENE_STATES.get(this).lines.push((scene) => `${scene}:${method}(${targetName},${argumentsList})`);
        return this;
    }

    create(target, duration = 1, easing = "smooth", lag = 0, direction) {
        if (direction === undefined) return this._animate("create", target, [duration, easing, lag]);
        this._assertMutable();
        _direction(direction);
        return this._animate("create", target, [duration, easing, lag, direction]);
    }

    uncreate(target, duration = 1, easing = "smooth", lag = 0, direction = "forward") {
        this._assertMutable();
        _direction(direction);
        return this._animate("uncreate", target, [duration, easing, lag, direction]);
    }

    fillReveal(target, duration = 1, easing = "smooth", lag = 0) {
        return this._animate("fill_reveal", target, [duration, easing, lag]);
    }

    drawBorderThenFill(target, duration = 1, easing = "smooth", lag = 0, direction) {
        if (direction === undefined) {
            return this._animate("draw_border_then_fill", target, [duration, easing, lag]);
        }
        this._assertMutable();
        _direction(direction);
        return this._animate("draw_border_then_fill", target, [duration, easing, lag, direction]);
    }

    write(target, duration = 1, easing = "smooth", lag = 0, direction) {
        if (direction === undefined) return this._animate("write", target, [duration, easing, lag]);
        this._assertMutable();
        _direction(direction);
        return this._animate("write", target, [duration, easing, lag, direction]);
    }

    _effect(method, target, options, defaults, name, minimumScale) {
        this._assertMutable();
        const targetName = this._handle(target);
        const value = _lua(_effectOptions(options, defaults, name, minimumScale));
        SCENE_STATES.get(this).lines.push((scene) => `${scene}:${method}(${targetName},${value})`);
        return this;
    }

    fadeIn(target, options = {}) {
        return this._effect("fade_in", target, options, FADE_OPTIONS, "FadeIn", 0);
    }

    fadeOut(target, options = {}) {
        return this._effect("fade_out", target, options, FADE_OPTIONS, "FadeOut", 0);
    }

    growFromCenter(target, duration = 1, easing = "smooth") {
        return this._animate("grow_from_center", target, [duration, easing]);
    }

    growFromEdge(target, edge, duration = 1, easing = "smooth") {
        this._assertMutable();
        _growthEdge(edge);
        return this._animate("grow_from_edge", target, [edge, duration, easing]);
    }

    shrinkToCenter(target, duration = 1, easing = "smooth") {
        return this._animate("shrink_to_center", target, [duration, easing]);
    }

    indicate(target, options = {}) {
        return this._effect("indicate", target, options, INDICATE_OPTIONS, "Indicate", 1);
    }

    _morph(method, source, target, duration, easing, lag) {
        this._assertMutable();
        const sourceArray = Array.isArray(source);
        const targetArray = Array.isArray(target);
        if (sourceArray !== targetArray) {
            throw new TypeError("Morph source and target must both be handles or arrays");
        }
        if (sourceArray && (!source.length || source.length !== target.length)) {
            throw new TypeError("Morph arrays must be non-empty and equally sized");
        }
        const sources = sourceArray ? source : [source];
        const targets = targetArray ? target : [target];
        const handles = new Set();
        for (let index = 0; index < sources.length; ++index) {
            const sourceName = this._handle(sources[index]);
            const targetName = this._handle(targets[index]);
            if (sourceName === targetName) {
                throw new TypeError("Morph source and target must be distinct handles");
            }
            if (handles.has(sourceName) || handles.has(targetName)) {
                throw new TypeError("Morph handles must be distinct across all pairs");
            }
            handles.add(sourceName);
            handles.add(targetName);
        }
        const sourceName = this._target(source);
        const targetName = this._target(target);
        const durationValue = _lua(duration);
        const easingValue = _lua(easing);
        const lagValue = lag === undefined ? "" : `,${_lua(lag)}`;
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:${method}(${sourceName},${targetName},${durationValue},${easingValue}${lagValue})`,
        );
        return this;
    }

    morph(source, target, duration = 1, easing = "smooth", lag) {
        return this._morph("morph", source, target, duration, easing, lag);
    }

    replacementTransform(source, target, duration = 1, easing = "smooth", lag) {
        return this._morph("replacement_transform", source, target, duration, easing, lag);
    }

    fadeTransform(source, target, duration = 1, easing = "smooth") {
        this._assertMutable();
        const sourceName = this._handle(source);
        const targetName = this._handle(target);
        if (sourceName === targetName) {
            throw new TypeError("FadeTransform source and target must be distinct handles");
        }
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:fade_transform(${sourceName},${targetName},${_lua(duration)},${_lua(easing)})`,
        );
        return this;
    }

    shift(target, by, duration = 1, easing = "smooth") {
        this._assertTransformable(target);
        return this._animate("shift", target, [by, duration, easing]);
    }

    transform(target, matrix, duration = 1, easing = "smooth") {
        this._assertTransformable(target);
        return this._animate("transform", target, [matrix, duration, easing]);
    }

    fade(target, opacity, duration = 1, easing = "smooth") {
        return this._animate("fade", target, [opacity, duration, easing]);
    }

    transition(from, to, duration = 1, easing = "smooth") {
        this._assertMutable();
        const fromName = this._target(from);
        const toName = this._target(to);
        const durationValue = _lua(duration);
        const easingValue = _lua(easing);
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:transition(${fromName},${toName},${durationValue},${easingValue})`,
        );
        return this;
    }

    stroke(target, color, duration = 1, easing = "smooth") {
        return this._animate("stroke", target, [color, duration, easing]);
    }

    fill(target, color, duration = 1, easing = "smooth") {
        return this._animate("fill", target, [color, duration, easing]);
    }

    play(specification, duration = 1, easing = "smooth", lag = 0) {
        this._assertMutable();
        const specifications = Array.isArray(specification) ? specification : [specification];
        if (!specifications.length) throw new TypeError("Animation play requires at least one descriptor");

        const targets = new Set();
        const descriptors = specifications.map((descriptor) => {
            if (
                !descriptor ||
                (Object.getPrototypeOf(descriptor) !== Object.prototype && Object.getPrototypeOf(descriptor) !== null)
            ) {
                throw new TypeError("Animation descriptors must be plain objects");
            }
            const unknown = Object.keys(descriptor).filter((key) => key !== "target" && !PLAY_PROPERTIES.includes(key));
            if (unknown.length) throw new TypeError(`Unknown animation property: ${unknown[0]}`);
            const targetName = this._handle(descriptor.target);
            if (targets.has(targetName)) throw new TypeError("Animation play cannot contain duplicate targets");
            targets.add(targetName);

            const properties = PLAY_PROPERTIES.filter((key) => Object.hasOwn(descriptor, key));
            if (!properties.length) throw new TypeError("Animation descriptors require at least one property");
            if (Object.hasOwn(descriptor, "shift") && Object.hasOwn(descriptor, "transform")) {
                throw new TypeError("Animation descriptors cannot combine shift and transform");
            }
            if (
                (Object.hasOwn(descriptor, "shift") || Object.hasOwn(descriptor, "transform")) &&
                HANDLE_TYPES.get(descriptor.target) === "connector"
            ) {
                throw new TypeError("Connector geometry follows its endpoints and cannot be shifted or transformed");
            }
            const values = properties.map((key) => `${key}=${_lua(descriptor[key])}`);
            return `{target=${targetName},${values.join(",")}}`;
        });
        const durationValue = _lua(duration);
        const easingValue = _lua(easing);
        const lagValue = _lua(lag);
        SCENE_STATES.get(this).lines.push(
            (scene) => `${scene}:play({${descriptors.join(",")}},${durationValue},${easingValue},${lagValue})`,
        );
        return this;
    }

    look(camera, duration = 1, easing = "smooth") {
        this._assertMutable();
        const cameraValue = _lua(camera);
        const durationValue = _lua(duration);
        const easingValue = _lua(easing);
        SCENE_STATES.get(this).lines.push((scene) => `${scene}:look(${cameraValue},${durationValue},${easingValue})`);
        return this;
    }

    wait(duration = 1) {
        this._assertMutable();
        const value = _lua(duration);
        SCENE_STATES.get(this).lines.push((scene) => `${scene}:wait(${value})`);
        return this;
    }

    remove(target) {
        this._assertMutable();
        const targetName = this._target(target);
        SCENE_STATES.get(this).lines.push((scene) => `${scene}:remove(${targetName})`);
        return this;
    }

    _compile(scene, depth) {
        const state = SCENE_STATES.get(this);
        return _compile(state.config, state.lines, scene, depth);
    }

    compile() {
        this._assertMutable();
        return [...this._compile("scene", 0), "return scene", ""].join("\n");
    }
}

for (const method of FACTORIES) {
    SceneBuilder.prototype[method] = function (options = {}) {
        return this._object(method, options);
    };
}

export const tmath = Object.freeze({
    animCurve: Object.freeze({
        preset: _curvePreset,
        cubicBezier: _cubicBezier,
        reverse: _reverseCurve,
    }),
    scene(config = {}) {
        return new SceneBuilder(config);
    },
});

export function compileScene(scene) {
    if (!(scene instanceof SceneBuilder)) throw new TypeError("Expected a tmath JS scene");
    return scene.compile();
}

export function evaluateScene(source, name = "scene.js") {
    if (typeof source !== "string" || !source) throw new TypeError("JavaScript source must be a non-empty string");
    const sourceName = String(name).replace(/[^a-zA-Z0-9._/-]/g, "_");
    const scene = Function("tmath", `"use strict";\n${source}\n//# sourceURL=${sourceName}`)(tmath);
    if (!(scene instanceof SceneBuilder)) throw new TypeError(`${name} must return a tmath scene`);
    if (SCENE_OWNERS.has(scene)) throw new TypeError(`${name} must return an owning root tmath scene`);
    return scene;
}
