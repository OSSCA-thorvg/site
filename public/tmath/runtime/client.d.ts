import type {AudioBus, SceneBuilder} from "./bindings.js";

export {compileScene, evaluateScene, SceneBuilder, tmath} from "./bindings.js";
export type * from "./bindings.js";

export type RenderEngine = "cpu" | "gl";

export interface TMathModuleOptions {
    readonly renderEngine?: RenderEngine;
    readonly [option: string]: unknown;
}

export interface BBox {
    readonly x: number;
    readonly y: number;
    readonly width: number;
    readonly height: number;
}

export interface LayoutSceneInfo {
    readonly index: number;
    readonly path: string;
    readonly kind: "root" | "viewport" | "transition";
    readonly parent: number | null;
    readonly depth: number;
    readonly bounds: BBox;
    readonly clipBounds: BBox;
    readonly scale: Readonly<{x: number; y: number}>;
    readonly clipped: boolean;
    readonly stretched: boolean;
}

export interface LayoutObjectInfo {
    readonly index: number;
    readonly scene: number;
    readonly scenePath: string;
    readonly handle: number;
    readonly id: string | null;
    readonly parent: number | null;
    readonly type: string;
    readonly layer: number;
    readonly paintBounds: BBox | null;
    readonly familyBounds: BBox | null;
    readonly visibleBounds: BBox | null;
    readonly visibleFamilyBounds: BBox | null;
    readonly clipBounds: BBox;
    readonly visible: boolean;
    readonly familyVisible: boolean;
    readonly clipped: boolean;
    readonly familyClipped: boolean;
    readonly outside: boolean;
    readonly familyOutside: boolean;
}

export interface LayoutCollisionInfo {
    readonly first: number;
    readonly second: number;
    readonly kind: "overlap" | "insufficient-gap";
    readonly overlap: BBox | null;
    readonly clearance: Readonly<{x: number; y: number}>;
    readonly separation: Readonly<{x: number; y: number}>;
}

export interface LayoutContainmentInfo {
    readonly container: number;
    readonly content: number;
    readonly depth: number;
    readonly inset: number;
    readonly contained: boolean;
    readonly overflow: Readonly<{left: number; top: number; right: number; bottom: number}>;
}

export interface LayoutReport {
    readonly time: number;
    readonly padding: number;
    readonly width: number;
    readonly height: number;
    readonly scenes: readonly LayoutSceneInfo[];
    readonly objects: readonly LayoutObjectInfo[];
    readonly collisions: readonly LayoutCollisionInfo[];
    readonly containments: readonly LayoutContainmentInfo[];
}

export interface HostThemePalette {
    readonly dark: boolean;
    readonly background: string;
    readonly foreground: string;
    readonly muted: string;
    readonly accent: string;
    readonly secondary: string;
    readonly success: string;
    readonly warning: string;
    readonly danger: string;
    readonly info: string;
    readonly surface: string;
    readonly line: string;
    readonly result: string;
    readonly focus: string;
    readonly objects: readonly string[];
}

export type TMathInputType = "pointerdown" | "pointermove" | "pointerup" | "pointercancel" | "wheel" | "keydown" | "keyup";

export interface TMathInputEvent {
    readonly type: TMathInputType;
    /** Logical Scene coordinates; passive pointermove uses the same space as captured drag. */
    readonly x: number;
    readonly y: number;
    /** Logical Scene-coordinate movement since the previous event for this pointer. */
    readonly dx: number;
    readonly dy: number;
    readonly wheelX: number;
    readonly wheelY: number;
    /**
     * Pointer button, or a keydown action:
     * ArrowLeft=0, ArrowRight=1, ArrowUp=2, ArrowDown=3, ZoomIn=4,
     * ZoomOut=5, Reset=6, View2D=7, View3D=8.
     */
    readonly button: number;
    readonly buttons: number;
    /** Shift, Ctrl, Alt, and Meta use bits 0 through 3. */
    readonly modifiers: number;
    readonly pointerId: number;
    /** Logical key name; required for keydown/keyup: ArrowLeft, Space, Enter, Escape, Shift, Tab, A-Z, 0-9, Plus, or Minus. */
    readonly key?: string;
    /** True for an auto-repeated keydown event; retained Input state ignores repeats. */
    readonly repeat?: boolean;
    readonly time: number;
}

export interface TMathInputResult {
    readonly handled: boolean;
    readonly redraw: boolean;
    readonly capture: boolean;
    readonly release: boolean;
    /** Present only when a SampleArea completes a successful primary-pointer sample. */
    readonly sample?: TMathInputSample;
    /** Present when a handled input operation could not be completed. */
    readonly error?: string;
}

export interface TMathDigitalState {
    readonly begin: number;
    readonly end: number;
    readonly previous: boolean;
    readonly down: boolean;
    readonly pressed: boolean;
    readonly released: boolean;
}

export interface TMathPointerState {
    readonly pointerId: number;
    readonly position: Readonly<{x: number; y: number}>;
    readonly delta: Readonly<{x: number; y: number}>;
    readonly wheel: Readonly<{x: number; y: number}>;
    readonly previousButtons: number;
    readonly buttons: number;
    readonly pressed: number;
    readonly released: number;
    readonly active: boolean;
}

export interface TMathActionState {
    readonly previous: Readonly<{x: number; y: number}>;
    readonly value: Readonly<{x: number; y: number}>;
    readonly delta: Readonly<{x: number; y: number}>;
    readonly down: boolean;
    readonly pressed: boolean;
    readonly released: boolean;
}

export interface TMathActionMap {
    readonly count: number;
    bindKey(action: string, key: string,
            value?: Readonly<{x: number; y: number}>): TMathActionMap;
    bindPointer(action: string, button: number,
                value?: Readonly<{x: number; y: number}>, pointerId?: number): TMathActionMap;
    remove(action: string): boolean;
    clear(): void;
    state(action: string): TMathActionState | null;
}

export interface TMathInputSample {
    /** Logical Scene pixel selected by the pointer. */
    readonly position: Readonly<{x: number; y: number}>;
    /** Normalized position inside the SampleArea region. */
    readonly value: Readonly<{x: number; y: number}>;
    /** Candidate-family composite in straight RGBA, isolated from background and non-family Objects. */
    readonly rgba: readonly [number, number, number, number];
    readonly object: TMathInputSampleObject;
}

export interface TMathInputSampleObject {
    /** Runtime Object handle. */
    readonly handle: number;
    /** Authored Object ID, or null when it has no ID. */
    readonly id: string | null;
    /** tmath Object type name. */
    readonly type: string;
}

export interface TMathRuntimeStep {
    /** Deterministic simulation time after this host advance. */
    readonly time: number;
    /** Total host time discarded by the bounded catch-up policy. */
    readonly dropped: number;
    readonly tick: number;
    /** Fixed updates completed by this host advance. */
    readonly steps: number;
    /** Remaining accumulator fraction in the inclusive range [0, 1]. */
    readonly interpolation: number;
    /** One-shot requests emitted by successful fixed steps in this host advance. */
    readonly sounds: readonly TMathRuntimeSound[];
}

export interface TMathRuntimeSound {
    readonly asset: string;
    readonly bus: "music" | "effect" | "ui";
    readonly gain: number;
    readonly rate: number;
    readonly loop: boolean;
}

export interface TMathAudioPlayback {
    readonly bus?: AudioBus;
    readonly gain?: number;
    /** Positive playback rate from 0.125 to 8; v1 changes pitch with speed. */
    readonly rate?: number;
    readonly loop?: boolean;
}

export interface TMathAudioTransport {
    readonly time: number;
    /** Positive playback rate from 0.125 to 8; v1 changes pitch with speed. */
    readonly rate?: number;
    readonly playing?: boolean;
    /** Set after a scrub, loop wrap, or other discontinuous timeline jump. */
    readonly seek?: boolean;
}

export interface TMathAudio {
    load(name: string, data: Uint8Array | ArrayBuffer): void;
    /** Call from a browser user gesture to satisfy the WebAudio autoplay policy. */
    start(): void;
    /** Starts an independent voice; repeated calls can play the same effect concurrently. */
    play(name: string, options?: TMathAudioPlayback): number;
    stop(voice: number): void;
    active(voice: number): boolean;
    masterGain(value: number): void;
    busGain(bus: AudioBus, value: number): void;
    /** Reconciles Scene-authored cues with the host animation player's atomic transport state. */
    transport(value: TMathAudioTransport): void;
}

export interface TMathScene {
    readonly renderEngine: RenderEngine;
    readonly duration: number;
    readonly loop: boolean;
    readonly cameraMode: "fixed" | "interactive";
    readonly cameraView: "2d" | "3d";
    readonly adaptiveTheme: boolean;
    /** True only when the loaded Scene explicitly declared tmath.runtime(...). */
    readonly retainedLua: boolean;
    readonly runtimeTime: number;
    /** Present only when the experimental audio module was compiled. */
    readonly audio?: TMathAudio;
    load(source: string | SceneBuilder, name?: string): number;
    loadLua(source: string, name?: string): number;
    loadScene(scene: SceneBuilder, name?: string): number;
    render(time: number, copy?: boolean): Uint8ClampedArray;
    lottie(fps?: number): Uint8Array;
    bounds(object: string, time?: number): BBox;
    intersects(first: string, second: string, time?: number, padding?: number): boolean;
    layoutReport(time?: number, padding?: number): LayoutReport;
    font(name: string, data: Uint8Array | ArrayBuffer, mime?: string): void;
    asset(name: string, data: Uint8Array | ArrayBuffer, mime: string): void;
    /** Returns false when the Scene is fixed or neither optional interactive module is present. */
    camera(action: "pan" | "orbit" | "zoom" | "reset" | "view2d" | "view3d", x?: number, y?: number): boolean;
    /** Available when UI or Input is compiled. UI consumes control events before Input receives unhandled events. */
    input?(event: TMathInputEvent): TMathInputResult;
    /** Starts one host/game frame and clears transient input edges, pointer delta, and wheel delta. */
    beginInputFrame?(time: number): void;
    /** Releases every retained key and pointer button, including focus-loss recovery. */
    releaseInput?(time: number): TMathInputResult;
    keyState?(key: string): TMathDigitalState;
    pointerState?(pointerId?: number): TMathPointerState | null;
    actionMap?(): TMathActionMap;
    /** Present only when the experimental retained Lua runtime was compiled. */
    advanceRuntime?(elapsed: number): TMathRuntimeStep | null;
    hostTheme(palette: HostThemePalette): void;
    draw(canvas: HTMLCanvasElement, time: number, pixelRatio?: number): void;
    size(): [number, number];
    resize(width: number, height: number): void;
    destroy(): void;
}

export function createTMath(
    source: string | SceneBuilder,
    name?: string,
    moduleOptions?: TMathModuleOptions,
): Promise<TMathScene>;
