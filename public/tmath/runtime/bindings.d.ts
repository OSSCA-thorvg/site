export type Color = string;
export type ThemeColorRole = "background" | "foreground" | "muted" | "accent" | "secondary" |
    "success" | "warning" | "danger" | "info" | "surface" | "border" | "result" | "focus";
export type Easing = "linear" | "smooth" | "ease_in" | "ease_out" | "ease_in_out";
export type AnimCurvePreset = Easing | "gentle" | "snappy" | "back" | "bounce" | "elastic";
export type AnimCurve = AnimCurvePreset |
    Readonly<{preset: AnimCurvePreset; strength: number; reverse?: boolean}> |
    Readonly<{bezier: readonly [number, number, number, number]; strength: number; reverse?: boolean}>;
export interface AnimCurveFactory {
    preset(preset: AnimCurvePreset, strength?: number): AnimCurve;
    cubicBezier(x1: number, y1: number, x2: number, y2: number, strength?: number): AnimCurve;
    reverse(curve: AnimCurve): AnimCurve;
}
export type AudioBus = "music" | "effect" | "ui";
export interface SoundOptions {
    asset: string;
    bus?: AudioBus;
    begin?: number;
    end?: number;
    gain?: number;
    loop?: boolean;
}
export type CreateDirection = "forward" | "reverse" | "clockwise" | "counterclockwise";
export type GrowthEdge = "left" | "right" | "bottom" | "top";
export type Vec2 = readonly [number, number] | {x: number; y: number};
export type Vec3 = readonly [number, number, number] | {x: number; y: number; z: number};
export type WorldVector = Vec2 | Vec3;
export type Range = readonly [number, number, number] | {min: number; max: number; step: number};
export type Mat4 = readonly [
    number, number, number, number,
    number, number, number, number,
    number, number, number, number,
    number, number, number, number,
];

export interface Camera {
    mode?: "fixed" | "interactive";
    view?: "2d" | "3d";
    target?: WorldVector;
    eye?: WorldVector;
    up?: WorldVector;
    height?: number;
    projection?: "perspective" | "orthographic";
    fov?: number;
    near?: number;
    far?: number;
}

export interface CameraTarget {
    view?: "2d" | "3d";
    eye?: WorldVector;
    target?: WorldVector;
    up?: WorldVector;
    height?: number;
    projection?: "perspective" | "orthographic";
    fov?: number;
    near?: number;
    far?: number;
}

export type ThemePreset = "3_blue_1_eyes" | "pro_white" | "pro_black" | "adaptive_vscode" | "pro";
export interface TextTheme {
    font?: string;
    size?: number;
    color?: Color;
}
export interface AxisTheme {
    x?: Color;
    y?: Color;
    z?: Color;
    grid?: Color;
    label?: Color;
}
export interface SemanticTheme {
    foreground?: Color;
    muted?: Color;
    accent?: Color;
    secondary?: Color;
    success?: Color;
    warning?: Color;
    danger?: Color;
    info?: Color;
    surface?: Color;
    border?: Color;
    result?: Color;
    focus?: Color;
}
export interface ThemeOptions {
    preset?: ThemePreset;
    background?: Color;
    text?: {
        h1?: TextTheme;
        h2?: TextTheme;
        h3?: TextTheme;
        text?: TextTheme;
        code?: TextTheme;
    };
    objects?: readonly Color[];
    object_width?: number;
    gradient?: boolean;
    end_gradient_stop?: Color;
    axis?: AxisTheme;
    colors?: SemanticTheme;
}

export interface SceneConfig {
    width?: number;
    height?: number;
    fps?: number;
    background?: Color;
    camera?: Camera;
    antialiasing?: boolean;
    loop?: boolean;
    theme?: ThemePreset | ThemeOptions;
}

export interface ViewportBounds {
    x: number;
    y: number;
    width: number;
    height: number;
}

export type StrokeDash =
    | readonly [number]
    | readonly [number, number]
    | readonly [number, number, number]
    | readonly [number, number, number, number];

interface SceneTransitionBaseOptions {
    duration?: number;
    hold?: number;
    viewport?: ViewportBounds;
}
export type SceneTransitionOptions = SceneTransitionBaseOptions & (
    {easing?: AnimCurve; curve?: never} | {easing?: never; curve: AnimCurve}
);

export interface Style {
    id?: string;
    color?: Color;
    stroke?: Color;
    fill?: Color;
    gradient?: boolean | Color;
    width?: number;
    radius?: number;
    dash?: StrokeDash;
    dash_offset?: number;
    opacity?: number;
    progress?: number;
    layer?: number;
}

export interface GroupOptions extends Style {matrix?: Mat4}
export interface LineOptions extends Style {from: WorldVector; to: WorldVector}
export interface ArrowOptions extends LineOptions {tail?: number; tip?: number}
export interface PointOptions extends Style {point: WorldVector}
export interface TextOptions extends Style {
    text: string;
    point?: WorldVector;
    size?: number;
    align?: Vec2;
    font?: string;
    orientation?: "billboard" | "plane";
    role?: "h1" | "h2" | "h3" | "text" | "code";
}
export interface VectorOptions extends Style {value: WorldVector; origin?: WorldVector; tail?: number; tip?: number}
export interface SpaceOptions extends Style {
    x?: Range;
    y?: Range;
    z?: Range;
    matrix?: Mat4;
    axis_x?: Color;
    axis_y?: Color;
    axis_z?: Color;
    numbers?: boolean;
    number_mode?: "fixed" | "relative";
    number_size?: number;
    number_color?: Color;
}
export type CellSampler = (x: number, y: number, time: number) => Color;
export type VoxelSampler = (x: number, y: number, z: number, time: number) => Color;
export interface CellSampleOptions {
    mode?: "full" | "padd";
    padding?: number;
    duration?: number;
    fps?: number;
}
export interface VoxelSampleOptions extends CellSampleOptions {}
export interface CircleOptions extends Style {center?: WorldVector; radius?: number}
export interface RectangleOptions extends Style {center?: WorldVector; size?: Vec2; corner?: number}
export interface PolygonOptions extends Style {points: readonly WorldVector[]}
export interface PlotOptions extends Style {points: readonly WorldVector[]}
export interface RouteOptions extends Style {
    points: readonly WorldVector[];
    tail?: number;
    tip?: number;
}
export type PathCommand =
    {type: "move" | "line"; to: WorldVector} |
    {type: "quadratic"; control: WorldVector; to: WorldVector} |
    {type: "cubic"; control1: WorldVector; control2: WorldVector; to: WorldVector} |
    {type: "close"};
export interface PathOptions extends Style {commands: readonly PathCommand[]; samples?: number}
export interface CurveOptions extends Style {
    from: WorldVector;
    control1: WorldVector;
    control2: WorldVector;
    to: WorldVector;
    samples?: number;
}
export interface SurfaceOptions extends Style {
    points: readonly WorldVector[];
    size: readonly [number, number];
    mode?: "solid" | "mesh" | "solid_mesh";
    shading?: boolean;
}
export interface RulerOptions extends Style {from: WorldVector; to: WorldVector; step?: number; tick?: number}
export interface ConnectorOptions extends Style {padding?: number; tail?: number; tip?: number}
export type SvgOptions = Omit<Style, "color" | "stroke" | "fill" | "radius"> & {
    path: string;
    center?: WorldVector;
    width?: number;
};
export type ImageOptions = Omit<Style, "color" | "stroke" | "fill" | "radius"> & ({
    asset: string;
    pixels?: never;
    size?: never;
} | {
    asset?: never;
    pixels: readonly Color[];
    size: readonly [number, number];
}) & {
    center?: WorldVector;
    width?: number;
    filter?: "bilinear" | "nearest";
};
export type CellRegion = readonly [number, number, number, number] | {
    x: number;
    y: number;
    width: number;
    height: number;
};
export type CellOptions = Omit<Style, "stroke" | "fill" | "radius"> & {
    origin?: WorldVector;
    size: readonly [number, number];
    mode?: "full" | "padd";
    padding?: number;
    depth?: number;
    texture?: string;
    source?: CellRegion;
    destination?: CellRegion;
    patches?: readonly {region: CellRegion; color: Color}[];
};

declare const handle: unique symbol;
export interface Handle {readonly [handle]: true}
export interface ObjectFactory {
    group(options?: GroupOptions): GroupHandle;
    space(options?: SpaceOptions): SpaceHandle;
    point(options: PointOptions): ObjectHandle;
    line(options: LineOptions): ObjectHandle;
    arrow(options: ArrowOptions): ObjectHandle;
    vector(options: VectorOptions): ObjectHandle;
    circle(options?: CircleOptions): ObjectHandle;
    rectangle(options?: RectangleOptions): ObjectHandle;
    polygon(options: PolygonOptions): ObjectHandle;
    plot(options: PlotOptions): ObjectHandle;
    route(options: RouteOptions): ObjectHandle;
    path(options: PathOptions): ObjectHandle;
    curve(options: CurveOptions): ObjectHandle;
    surface(options: SurfaceOptions): ObjectHandle;
    text(options: TextOptions): ObjectHandle;
    ruler(options: RulerOptions): ObjectHandle;
    svg(options: SvgOptions): ObjectHandle;
    image(options: ImageOptions): ObjectHandle;
    cell(options: CellOptions): ObjectHandle;
    connector(from: ObjectHandle, to: ObjectHandle, options?: ConnectorOptions): ObjectHandle;
}

export interface ObjectHandle extends Handle, ObjectFactory {
    label(options: TextOptions): ObjectHandle;
    moveTo(point: WorldVector): this;
    nextTo(target: ObjectHandle, direction: WorldVector, gap?: number): this;
    alignTo(target: ObjectHandle, direction: WorldVector): this;
}

export interface GroupHandle extends ObjectHandle {
    arrange(direction?: WorldVector, gap?: number): this;
    arrangeGrid(columns: number, columnGap?: number, rowGap?: number): this;
}

export interface SpaceHandle extends ObjectHandle {
    cell(options: CellOptions): ObjectHandle;
    cell(callback: CellSampler, options?: CellSampleOptions): GroupHandle;
    voxel(callback: VoxelSampler, options?: VoxelSampleOptions): GroupHandle;
}

declare const styleGroupHandle: unique symbol;
export interface StyleGroupHandle {readonly [styleGroupHandle]: true}
export type StyleChannel = "stroke" | "fill" | "both";
export interface StyleGroupOptions {
    color?: Color;
    members: readonly {target: ObjectHandle; channel?: StyleChannel}[];
}

declare const audioCueHandle: unique symbol;
export interface AudioCueHandle {
    readonly [audioCueHandle]: true;
    gain(value: number, begin: number, duration?: number, curve?: AnimCurve): this;
}

interface FadeEffectOptions {
    shift?: WorldVector;
    scale?: number;
    duration?: number;
}
export type FadeOptions = FadeEffectOptions & (
    {easing?: AnimCurve; curve?: never} | {easing?: never; curve: AnimCurve}
);

interface IndicateEffectOptions {
    color?: Color;
    scale?: number;
    duration?: number;
}
export type IndicateOptions = IndicateEffectOptions & (
    {easing?: AnimCurve; curve?: never} | {easing?: never; curve: AnimCurve}
);

interface AnimationProperties {
    shift: WorldVector;
    transform: Mat4;
    opacity: number;
    stroke: Color;
    fill: Color;
    dash_offset: number;
    tail: number;
    tip: number;
}

type AtLeastOne<T> = {
    [Key in keyof T]: Required<Pick<T, Key>> & Partial<Omit<T, Key>>
}[keyof T];

export type AnimationSpec = {target: ObjectHandle} & AtLeastOne<AnimationProperties> & (
    {shift?: WorldVector; transform?: never} |
    {shift?: never; transform?: Mat4}
);

export interface SceneBuilder extends ObjectFactory {}
export class SceneBuilder {
    constructor(config?: SceneConfig);
    viewport(child: SceneBuilder, bounds: ViewportBounds): this;
    sceneTransition(stages: readonly SceneBuilder[], options?: SceneTransitionOptions): this;
    sound(options: SoundOptions): AudioCueHandle;
    styleGroup(options: StyleGroupOptions): StyleGroupHandle;
    styleBind(group: StyleGroupHandle, target: ObjectHandle, channel?: StyleChannel): this;
    style(group: StyleGroupHandle, color: Color, duration?: number, curve?: AnimCurve): this;
    create(target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number, direction?: CreateDirection): this;
    uncreate(target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number, direction?: CreateDirection): this;
    fillReveal(target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number): this;
    drawBorderThenFill(target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number, direction?: CreateDirection): this;
    write(target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number, direction?: CreateDirection): this;
    fadeIn(target: Handle, options?: FadeOptions): this;
    fadeOut(target: Handle, options?: FadeOptions): this;
    growFromCenter(target: Handle, duration?: number, curve?: AnimCurve): this;
    growFromEdge(target: Handle, edge: GrowthEdge, duration?: number, curve?: AnimCurve): this;
    shrinkToCenter(target: Handle, duration?: number, curve?: AnimCurve): this;
    indicate(target: Handle, options?: IndicateOptions): this;
    morph(source: Handle | readonly Handle[], target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number): this;
    replacementTransform(source: Handle | readonly Handle[], target: Handle | readonly Handle[], duration?: number, curve?: AnimCurve, lag?: number): this;
    fadeTransform(source: Handle, target: Handle, duration?: number, curve?: AnimCurve): this;
    shift(target: Handle, by: WorldVector, duration?: number, curve?: AnimCurve): this;
    transform(target: Handle, matrix: Mat4, duration?: number, curve?: AnimCurve): this;
    fade(target: Handle, opacity: number, duration?: number, curve?: AnimCurve): this;
    transition(from: Handle | readonly Handle[], to: Handle | readonly Handle[], duration?: number, curve?: AnimCurve): this;
    stroke(target: Handle, color: Color, duration?: number, curve?: AnimCurve): this;
    fill(target: Handle, color: Color, duration?: number, curve?: AnimCurve): this;
    play(specification: AnimationSpec | readonly AnimationSpec[], duration?: number, curve?: AnimCurve, lag?: number): this;
    look(camera: CameraTarget, duration?: number, curve?: AnimCurve): this;
    wait(duration?: number): this;
    remove(target: Handle): this;
    compile(): string;
}

export const tmath: Readonly<{
    animCurve: Readonly<AnimCurveFactory>;
    scene(config?: SceneConfig): SceneBuilder;
}>;
export function compileScene(scene: SceneBuilder): string;
export function evaluateScene(source: string, name?: string): SceneBuilder;
