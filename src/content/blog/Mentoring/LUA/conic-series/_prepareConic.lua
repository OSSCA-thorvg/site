-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill._prepareConic.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, mark = 20, arrow = 30, text = 40}
local transparent = "#00000000"
-- Semantic identity ledger. Each vector and every Text object that names it
-- share the same adaptive VS Code Theme token.
local C = {
    neutral = "foreground",
    muted = "muted",
    a = "accent",
    b = "secondary",
    seam = "accent",
    normal = "success",
    xStep = "accent",
    yStep = "secondary",
    derivativeNormal = "success",
    dFdx = "accent",
    dFdy = "secondary",
    scalarResult = "warning",
    fwidth = "warning",
    point = "info",
}
local vscodeTheme = {
    preset = "adaptive_vscode",
    text = {
        h1 = {font = "IBM Plex Sans KR"},
        h2 = {font = "IBM Plex Sans KR"},
    },
}

local scene = tmath.scene {
    width = 960,
    height = 1280,
    fps = 30,
    loop = true,
    theme = vscodeTheme,
    camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 12.8},
}

local function txt(parent, id, value, x, y, role, align, fill)

    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["state-legend"]=true,["normal-caption"]=true,["matrix-caption"]=true,["derivative-state-note"]=true,["source-title"]=true,["dot-cross-title"]=true,["normal-title"]=true,["matrix-title"]=true,["derivative-title"]=true}
    if blogHidden[id] then value = "" end
    local config = {
        id = id,
        text = value,
        point = {x, y},
        role = role,
        align = align or {0, 0.5},
        layer = L.text,
    }
    if fill then config.fill = fill end
    return parent:text(config)
end

local function rule(id, y)
    return scene:line {
        id = id,
        from = {-4.30, y},
        to = {4.30, y},
        stroke = "border",
        width = 1.1,
        layer = L.guide,
    }
end

local function affine(degrees, x, y)
    local radians = degrees * math.pi / 180
    local c, s = math.cos(radians), math.sin(radians)
    return {
        c, -s, 0, x,
        s, c, 0, y,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }
end

local function basisMatrix(xBasis, yBasis, x, y)
    return {
        xBasis[1], yBasis[1], 0, x,
        xBasis[2], yBasis[2], 0, y,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }
end

local function scaled(value, amount)
    return {value[1] * amount, value[2] * amount}
end

local function added(origin, value)
    return {origin[1] + value[1], origin[2] + value[2]}
end

local function segmentMatrix(from, to)
    local direction = {to[1] - from[1], to[2] - from[2]}
    return basisMatrix(direction, {-direction[2], direction[1]}, from[1], from[2])
end

txt(scene, "title", "Basic Math.", -4.30, 5.82, "h2")
txt(scene, "state-legend", "b: A -> B -> A    M^-1: A -> B -> A", 4.28, 5.82, "code", {1, 0.5}, C.muted)
rule("header-rule", 5.58)

txt(scene, "source-title", "Prepare dataflow", -4.30, 5.30, "h3")
txt(scene, "source-transform", "M = pTransform * conicTransform; inverse(M) -> M^-1", -4.18, 4.94, "code", nil, C.neutral)
txt(scene, "source-seam", "seam", -4.18, 4.60, "code", nil, C.seam)
txt(scene, "source-arrow-normal", "->", -3.70, 4.60, "code", nil, C.neutral)
txt(scene, "source-normal", "normal", -3.44, 4.60, "code", nil, C.normal)
txt(scene, "source-arrow-x-step", "->", -2.74, 4.60, "code", nil, C.neutral)
txt(scene, "source-x-step", "xStep", -2.48, 4.60, "code", nil, C.xStep)
txt(scene, "source-slash-y-step", "/", -1.90, 4.60, "code", nil, C.neutral)
txt(scene, "source-y-step", "yStep", -1.72, 4.60, "code", nil, C.yStep)
txt(scene, "source-arrow-dfdx", "->", -1.16, 4.60, "code", nil, C.neutral)
txt(scene, "source-dfdx", "dFdx", -0.90, 4.60, "code", nil, C.dFdx)
txt(scene, "source-slash-dfdy", "/", -0.38, 4.60, "code", nil, C.neutral)
txt(scene, "source-dfdy", "dFdy", -0.20, 4.60, "code", nil, C.dFdy)
txt(scene, "source-arrow-inv-fwidth", "->", 0.32, 4.60, "code", nil, C.neutral)
txt(scene, "source-inv-fwidth", "invFwidth", 0.58, 4.60, "code", nil, C.fwidth)
rule("source-rule", 4.30)

txt(scene, "dot-cross-title", "Move one operand; recompute dot and cross", -4.30, 4.04, "h3")
txt(scene, "dot-prefix", "dot(", -4.12, 3.66, "code", nil, C.neutral)
txt(scene, "dot-term-a", "a", -3.72, 3.66, "code", nil, C.a)
txt(scene, "dot-comma", ",", -3.58, 3.66, "code", nil, C.neutral)
txt(scene, "dot-term-b", "b", -3.46, 3.66, "code", nil, C.b)
txt(scene, "dot-result", ") = projection", -3.32, 3.66, "code", nil, C.scalarResult)
txt(scene, "cross-prefix", "cross(", 0.18, 3.66, "code", nil, C.neutral)
txt(scene, "cross-term-a", "a", 0.76, 3.66, "code", nil, C.a)
txt(scene, "cross-comma", ",", 0.90, 3.66, "code", nil, C.neutral)
txt(scene, "cross-term-b", "b", 1.02, 3.66, "code", nil, C.b)
txt(scene, "cross-result", ") = signed area", 1.16, 3.66, "code", nil, C.scalarResult)

local dotOrigin = {-3.82, 2.66}
local dotA = scaled({6.25, 0.75}, 0.18)
local dotBStates = {
    scaled({-1.00, 4.00}, 0.18),
    scaled({4.00, 1.00}, 0.18),
}
local function dotGeometry(b)
    local denominator = dotA[1] * dotA[1] + dotA[2] * dotA[2]
    local scalar = (dotA[1] * b[1] + dotA[2] * b[2]) / denominator
    local foot = added(dotOrigin, scaled(dotA, scalar))
    local endpoint = added(dotOrigin, b)
    return endpoint, foot
end
local dotBEndA, dotFootA = dotGeometry(dotBStates[1])
local dotBEndB, dotFootB = dotGeometry(dotBStates[2])

scene:vector {
    id = "dot-a", origin = dotOrigin, value = dotA,
    stroke = C.a, width = 2.7, tip = 10, layer = L.arrow,
}
txt(scene, "dot-a-label", "a", -2.63, 2.94, "code", nil, C.a)

local dotB = scene:group {id = "dot-b-group", matrix = segmentMatrix(dotOrigin, dotBEndA)}
dotB:arrow {
    id = "dot-b", from = {0, 0}, to = {1, 0},
    stroke = C.b, width = 2.7, tip = 10, layer = L.arrow,
}
local dotDrop = scene:group {id = "dot-drop-group", matrix = segmentMatrix(dotBEndA, dotFootA)}
dotDrop:line {
    id = "dot-drop", from = {0, 0}, to = {1, 0},
    stroke = "border", width = 1.2, dash = {5, 4}, layer = L.guide,
}
local dotProjection = scene:group {id = "dot-projection-group", matrix = segmentMatrix(dotOrigin, dotFootA)}
dotProjection:line {
    id = "dot-projection", from = {0, 0}, to = {1, 0},
    -- The measured projection intentionally overlays a when both are collinear.
    stroke = C.scalarResult, width = 3.6, layer = L.arrow + 2,
}

local crossOrigin = {0.42, 2.66}
local crossA = scaled({5.65, 0.55}, 0.18)
local crossB = scaled({-1.00, 4.00}, 0.18)
local crossSmall = scaled({4.00, 1.00}, 0.18)
scene:vector {
    id = "cross-a", origin = crossOrigin, value = crossA,
    stroke = C.a, width = 2.7, tip = 10, layer = L.arrow,
}
txt(scene, "cross-a-label", "a", 1.53, 2.91, "code", nil, C.a)
local crossSummary = basisMatrix(crossA, crossB, crossOrigin[1], crossOrigin[2])
local crossSmallState = basisMatrix(crossA, crossSmall, crossOrigin[1], crossOrigin[2])
local crossArea = scene:group {id = "cross-area", matrix = crossSummary}
local crossParallelogram = crossArea:polygon {
    id = "cross-parallelogram", points = {{0, 0}, {1, 0}, {1, 1}, {0, 1}},
    fill = C.scalarResult, stroke = C.scalarResult, opacity = 0.20, width = 1.4, layer = L.base,
}
crossArea:arrow {
    id = "cross-b", from = {0, 0}, to = {0, 1},
    stroke = C.b, width = 2.7, tip = 10, layer = L.arrow,
}

rule("dot-cross-rule", 2.26)

txt(scene, "normal-title", "Rotate the seam 90° to get the normal", -4.30, 2.02, "h3")
txt(scene, "normal-formula", "alpha=30°", -4.12, 1.68, "code", nil, C.neutral)
txt(scene, "normal-seam-formula", "seam=(cos alpha,sin alpha)", -3.16, 1.68, "code", nil, C.seam)
txt(scene, "normal-vector-formula", "normal=(-sy,sx)", -0.66, 1.68, "code", nil, C.normal)
txt(scene, "normal-dot-formula", "dot(", 0.98, 1.68, "code", nil, C.neutral)
txt(scene, "normal-dot-seam", "seam", 1.36, 1.68, "code", nil, C.seam)
txt(scene, "normal-dot-comma", ",", 1.83, 1.68, "code", nil, C.neutral)
txt(scene, "normal-dot-normal", "normal", 1.94, 1.68, "code", nil, C.normal)
txt(scene, "normal-dot-result", ")=0", 2.58, 1.68, "code", nil, C.scalarResult)

local normalOrigin = {-2.62, 1.12}
local seamLength = 1.72
local normalLength = 1.05
local seamAngle = -30
local normalAngle = -120
local seamEnd = {
    normalOrigin[1] + seamLength * math.cos(math.pi / 6),
    normalOrigin[2] - seamLength * math.sin(math.pi / 6),
}
local normalEnd = {
    normalOrigin[1] - normalLength * math.sin(math.pi / 6),
    normalOrigin[2] - normalLength * math.cos(math.pi / 6),
}
scene:arrow {
    id = "normal-axis-x",
    from = {normalOrigin[1] - 0.22, normalOrigin[2]},
    to = {normalOrigin[1] + 2.05, normalOrigin[2]},
    stroke = "border",
    width = 1.2,
    tip = 8,
    layer = L.guide,
}
scene:arrow {
    id = "normal-axis-y",
    from = normalOrigin,
    to = {normalOrigin[1], normalOrigin[2] - 0.82},
    stroke = "border",
    width = 1.2,
    tip = 8,
    layer = L.guide,
}
scene:arrow {
    id = "seam-vector",
    from = normalOrigin,
    to = seamEnd,
    stroke = C.seam,
    width = 3.0,
    tip = 11,
    layer = L.arrow,
}
scene:arrow {
    id = "normal-vector",
    from = normalOrigin,
    to = normalEnd,
    stroke = C.normal,
    width = 3.0,
    tip = 11,
    opacity = 0.62,
    layer = L.arrow,
}
local rightAngleFrame = scene:group {id = "right-angle-frame", matrix = affine(seamAngle, normalOrigin[1], normalOrigin[2])}
rightAngleFrame:plot {
    id = "right-angle",
    points = {{0.25, 0}, {0.25, -0.25}, {0, -0.25}},
    stroke = C.normal,
    width = 1.7,
    layer = L.mark,
}
local normalProbeSummary = affine(normalAngle, normalOrigin[1], normalOrigin[2])
local normalProbeSource = affine(seamAngle, normalOrigin[1], normalOrigin[2])
local normalProbe = scene:group {id = "normal-construction", matrix = normalProbeSummary}
normalProbe:arrow {
    id = "normal-construction-arrow",
    from = {0, 0},
    to = {normalLength, 0},
    stroke = "warning",
    width = 2.2,
    tip = 9,
    layer = L.arrow,
}
txt(scene, "normal-seam-label", "seam", -0.78, 0.96, "code", nil, C.seam)
txt(scene, "normal-vector-label", "normal", -3.72, 0.68, "code", nil, C.normal)
txt(scene, "normal-caption", "In y-down space, positive alpha is clockwise; the basis stays perpendicular.", -4.30, -0.06, "text")
rule("normal-rule", -0.32)

txt(scene, "matrix-title", "Map affine points; map linear differentials", -4.30, -0.56, "h3")
txt(scene, "matrix-point", "point:", -4.12, -0.92, "code", nil, C.neutral)
txt(scene, "matrix-point-value", "q = M^-1 [x+.5, y+.5, 1]^T - center", -3.52, -0.92, "code", nil, C.point)
txt(scene, "matrix-point-note", "translation applies", 0.34, -0.92, "code", nil, C.neutral)
txt(scene, "matrix-steps", "steps:", -4.12, -1.26, "code", nil, C.neutral)
txt(scene, "matrix-x-step-value", "xStep=(1,-.26)", -3.52, -1.26, "code", nil, C.xStep)
txt(scene, "matrix-y-step-value", "yStep=(.28,.82)", -1.94, -1.26, "code", nil, C.yStep)
txt(scene, "matrix-step-note", "translation cancels", 0.02, -1.26, "code", nil, C.neutral)

local screenCenter = {-3.34, -1.90}
local screenCell = 0.31
for row = -1, 1 do
    for column = -1, 1 do
        scene:rectangle {
            id = "screen-cell-" .. row .. "-" .. column,
            center = {screenCenter[1] + column * screenCell, screenCenter[2] + row * screenCell},
            size = {screenCell, screenCell},
            fill = row == 0 and column == 0 and "info" or "surface",
            stroke = "border",
            opacity = row == 0 and column == 0 and 0.34 or 1,
            width = 1.0,
            layer = L.base,
        }
    end
end
scene:arrow {
    id = "inverse-map",
    from = {-2.60, -1.90},
    to = {0.14, -1.90},
    stroke = "foreground",
    width = 2.0,
    tip = 10,
    layer = L.arrow,
}
txt(scene, "inverse-map-label", "M^-1", -1.23, -1.56, "code", {0.5, 0.5})

local xStep = {1.00, -0.26}
local yStep = {0.28, 0.82}
local footprintScale = 0.34
local xBasis = scaled(xStep, footprintScale)
local yBasis = scaled(yStep, footprintScale)
local localOrigin = {1.38, -2.08}
for row = -1, 1 do
    for column = -1, 1 do
        if row ~= 0 or column ~= 0 then
            local cellOrigin = added(localOrigin, added(scaled(xBasis, column), scaled(yBasis, row)))
            scene:polygon {
                id = "local-cell-" .. row .. "-" .. column,
                points = {
                    cellOrigin,
                    added(cellOrigin, xBasis),
                    added(added(cellOrigin, xBasis), yBasis),
                    added(cellOrigin, yBasis),
                },
                fill = "surface",
                stroke = "border",
                width = 1.0,
                layer = L.base,
            }
        end
    end
end
scene:polygon {
    id = "local-footprint",
    points = {
        localOrigin,
        added(localOrigin, xBasis),
        added(added(localOrigin, xBasis), yBasis),
        added(localOrigin, yBasis),
    },
    fill = "info",
    stroke = "info",
    opacity = 0.22,
    width = 2.0,
    layer = L.base,
}
scene:arrow {
    id = "x-step",
    from = localOrigin,
    to = added(localOrigin, xBasis),
    stroke = C.xStep,
    width = 2.7,
    tip = 9,
    layer = L.arrow,
}
scene:arrow {
    id = "y-step",
    from = localOrigin,
    to = added(localOrigin, yBasis),
    stroke = C.yStep,
    width = 2.7,
    tip = 9,
    layer = L.arrow,
}
txt(scene, "screen-space-label", "screen", -3.34, -2.48, "text", {0.5, 0.5})
txt(scene, "local-space-label", "gradient local", 2.74, -1.90, "text")

local transferStart = basisMatrix({screenCell * 0.88, 0}, {0, screenCell * 0.88}, screenCenter[1], screenCenter[2])
local transferTarget = basisMatrix(
    xBasis,
    yBasis,
    localOrigin[1] + 0.5 * (xBasis[1] + yBasis[1]),
    localOrigin[2] + 0.5 * (xBasis[2] + yBasis[2])
)
local pixelTransfer = scene:group {id = "space-transfer", matrix = transferTarget}
for row = -1, 1 do
    for column = -1, 1 do
        pixelTransfer:rectangle {
            id = "space-transfer-cell-" .. row .. "-" .. column,
            center = {column, row},
            size = {0.88, 0.88},
            fill = row == 0 and column == 0 and "info" or transparent,
            stroke = row == 0 and column == 0 and "info" or "foreground",
            opacity = row == 0 and column == 0 and 0.34 or 0.42,
            width = row == 0 and column == 0 and 1.5 or 1.0,
            layer = L.mark,
        }
    end
end
txt(scene, "matrix-caption", "The affine point keeps tx,ty; the pixel footprint keeps only the inverse basis columns.", -4.30, -2.75, "text")
rule("matrix-rule", -2.98)

txt(scene, "derivative-title", "Change M^-1; recompute the footprint and fwidth", -4.30, -3.24, "h3")
txt(scene, "derivative-values", "normal n", -4.12, -3.60, "code", nil, C.derivativeNormal)
txt(scene, "derivative-dfdx-formula", "dFdx =", -3.18, -3.60, "code", nil, C.dFdx)
txt(scene, "derivative-dfdx-normal", "n", -2.48, -3.60, "code", nil, C.derivativeNormal)
txt(scene, "derivative-dfdx-dot", "·", -2.33, -3.60, "code", nil, C.neutral)
txt(scene, "derivative-dfdx-column", "col1", -2.18, -3.60, "code", nil, C.dFdx)
txt(scene, "derivative-dfdy-formula", "dFdy =", -1.60, -3.60, "code", nil, C.dFdy)
txt(scene, "derivative-dfdy-normal", "n", -0.90, -3.60, "code", nil, C.derivativeNormal)
txt(scene, "derivative-dfdy-dot", "·", -0.75, -3.60, "code", nil, C.neutral)
txt(scene, "derivative-dfdy-column", "col2", -0.60, -3.60, "code", nil, C.dFdy)
txt(scene, "derivative-state", "M^-1: A -> B -> A", -4.00, -3.94, "code", nil, C.point)
txt(scene, "derivative-state-note", "xStep, yStep, projections, and fwidth update together", -2.18, -3.94, "text", nil, C.muted)

local derivativeNormal = {-0.60, 0.80}
local derivativeStates = {
    {x = {-0.40, 1.10}, y = {0.80, -0.20}},
    {x = {0.60, 0.20}, y = {-0.20, 0.50}},
}

local function derivativeValue(state)
    local dx = derivativeNormal[1] * state.x[1] + derivativeNormal[2] * state.x[2]
    local dy = derivativeNormal[1] * state.y[1] + derivativeNormal[2] * state.y[2]
    return dx, dy, math.abs(dx) + math.abs(dy)
end

local function projectionMatrix(distance, x, y)
    return basisMatrix(
        scaled(derivativeNormal, distance),
        {-derivativeNormal[2] * 0.12, derivativeNormal[1] * 0.12},
        x,
        y
    )
end

local function barMatrix(value, x, y)
    return basisMatrix({math.abs(value) * 1.48, 0}, {0, 0.16}, x, y)
end

local surfacePixel = scene:space {
    id = "derivative-surface-space",
    x = {-0.5, 1.5, 1}, y = {-0.5, 1.5, 1}, numbers = false,
    matrix = basisMatrix({0.56, 0}, {0, 0.56}, -3.86, -5.15),
}
surfacePixel:rectangle {
    id = "derivative-surface-pixel",
    center = {0.5, 0.5}, size = {1, 1},
    fill = "info", stroke = "info", opacity = 0.22, width = 2.0, layer = L.base,
}
surfacePixel:point {
    id = "derivative-surface-center", point = {0.5, 0.5}, radius = 4,
    fill = "foreground", stroke = "surface", width = 1.5, layer = L.mark,
}
txt(scene, "derivative-surface-label", "Surface Space", -3.58, -5.66, "text", {0.5, 0.5})
scene:arrow {
    id = "derivative-pullback", from = {-3.12, -4.88}, to = {-2.62, -4.88},
    stroke = "foreground", width = 2.0, tip = 9, layer = L.arrow,
}
txt(scene, "derivative-pullback-label", "M^-1", -2.87, -4.55, "code", {0.5, 0.5})

local derivativeOrigin = {-2.40, -5.15}
local derivativeMatrices = {}
for index, state in ipairs(derivativeStates) do
    derivativeMatrices[index] = basisMatrix(state.x, state.y, derivativeOrigin[1], derivativeOrigin[2])
end
local derivativeSpace = scene:group {
    id = "derivative-gradient-space",
    matrix = derivativeMatrices[1],
}
derivativeSpace:polygon {
    id = "derivative-gradient-footprint",
    points = {{0, 0}, {1, 0}, {1, 1}, {0, 1}},
    fill = "info", stroke = "info", opacity = 0.22, width = 2.0, layer = L.base,
}
derivativeSpace:arrow {
    id = "derivative-x-step", from = {0, 0}, to = {1, 0},
    stroke = C.dFdx, width = 2.7, tip = 9, layer = L.arrow,
}
derivativeSpace:arrow {
    id = "derivative-y-step", from = {0, 0}, to = {0, 1},
    stroke = C.dFdy, width = 2.7, tip = 9, layer = L.arrow,
}
txt(scene, "derivative-gradient-label", "Gradient Space", -1.86, -5.66, "text", {0.5, 0.5})

local dxValues, dyValues, fwidthValues = {}, {}, {}
local dxProjectionMatrices, dyProjectionMatrices = {}, {}
local dxBarMatrices, dyBarMatrices, fwidthBarMatrices = {}, {}, {}
for index, state in ipairs(derivativeStates) do
    local dx, dy, width = derivativeValue(state)
    dxValues[index], dyValues[index], fwidthValues[index] = dx, dy, width
    dxProjectionMatrices[index] = projectionMatrix(dx, -0.76, -4.58)
    dyProjectionMatrices[index] = projectionMatrix(dy, -0.76, -5.08)
    dxBarMatrices[index] = barMatrix(dx, 1.12, -4.62)
    dyBarMatrices[index] = barMatrix(dy, 1.12, -5.02)
    fwidthBarMatrices[index] = barMatrix(width, 1.12, -5.43)
end

scene:arrow {
    id = "derivative-normal-guide",
    from = {-0.40, -5.55}, to = {-1.26, -4.40},
    stroke = C.derivativeNormal, width = 1.8, tip = 8, opacity = 0.50, layer = L.guide,
}
scene:arrow {
    id = "derivative-seam-guide",
    from = {-0.40, -5.55}, to = {0.55, -4.84},
    stroke = "border", width = 1.5, tip = 7, opacity = 0.55, layer = L.guide,
}

local dxProjection = scene:group {id = "dfdx-projection", matrix = dxProjectionMatrices[1]}
dxProjection:arrow {
    id = "dfdx-projection-arrow", from = {0, 0}, to = {1, 0},
    stroke = C.dFdx, width = 2.7, tip = 8, layer = L.arrow,
}
local dyProjection = scene:group {id = "dfdy-projection", matrix = dyProjectionMatrices[1]}
dyProjection:arrow {
    id = "dfdy-projection-arrow", from = {0, 0}, to = {1, 0},
    stroke = C.dFdy, width = 2.7, tip = 8, layer = L.arrow,
}
txt(scene, "dfdx-label", "dFdx", -0.35, -4.62, "code", {1, 0.5}, C.dFdx)
txt(scene, "dfdy-label", "dFdy", -0.35, -5.10, "code", {1, 0.5}, C.dFdy)

local function contribution(id, matrix, color)
    local group = scene:group {id = id, matrix = matrix}
    group:rectangle {
        id = id .. "-bar", center = {0.5, 0}, size = {1, 1},
        fill = color, stroke = color, width = 1, layer = L.mark,
    }
    return group
end

local dxContribution = contribution("dfdx-contribution", dxBarMatrices[1], C.dFdx)
local dyContribution = contribution("dfdy-contribution", dyBarMatrices[1], C.dFdy)
local fwidthContribution = contribution("fwidth-contribution", fwidthBarMatrices[1], C.fwidth)
txt(scene, "dfdx-bar-label", "|dFdx|", 0.26, -4.62, "code", nil, C.dFdx)
txt(scene, "dfdy-bar-label", "+ |dFdy|", 0.26, -5.02, "code", nil, C.dFdy)
txt(scene, "fwidth-bar-label", "= fwidth", 0.26, -5.43, "code", nil, C.fwidth)

local gentle = {preset = "gentle", strength = 0.82}
local reverseGentle = {preset = "gentle", strength = 0.82, reverse = true}
local function stateTargets(index)
    local dotEnd, dotFoot = index == 1 and dotBEndA or dotBEndB,
        index == 1 and dotFootA or dotFootB
    return {
        {target = dotB, transform = segmentMatrix(dotOrigin, dotEnd)},
        {target = dotDrop, transform = segmentMatrix(dotEnd, dotFoot)},
        {target = dotProjection, transform = segmentMatrix(dotOrigin, dotFoot)},
        {target = crossArea, transform = index == 1 and crossSummary or crossSmallState},
        {target = derivativeSpace, transform = derivativeMatrices[index]},
        {target = dxProjection, transform = dxProjectionMatrices[index]},
        {target = dyProjection, transform = dyProjectionMatrices[index]},
        {target = dxContribution, transform = dxBarMatrices[index]},
        {target = dyContribution, transform = dyBarMatrices[index]},
        {target = fwidthContribution, transform = fwidthBarMatrices[index]},
    }
end

scene:wait(0.55)
scene:play(stateTargets(2), 1.15, gentle, 0)
scene:wait(0.55)
scene:play({
    {target = normalProbe, transform = normalProbeSource},
    {target = pixelTransfer, transform = transferStart},
}, 0.82, gentle, 0)
scene:wait(0.20)
scene:play({
    {target = normalProbe, transform = normalProbeSummary},
    {target = pixelTransfer, transform = transferTarget},
}, 0.96, reverseGentle, 0)
scene:wait(0.42)
scene:play(stateTargets(1), 1.15, reverseGentle, 0)
scene:wait(8.00 - scene:duration())

return scene
