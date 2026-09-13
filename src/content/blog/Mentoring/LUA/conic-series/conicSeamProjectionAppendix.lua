-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill.conicSeamProjectionAppendix.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, band = 12, mark = 20, arrow = 30, text = 40}
local transparent = "#00000000"
local C = {
    pixel = "info", seam = "danger", normal = "success",
    step = "accent", projection = "warning", kept = "result", excluded = "danger",
}
local vscodeTheme = {
    preset = "adaptive_vscode",
    text = {h1 = {font = "IBM Plex Sans KR"}, h2 = {font = "IBM Plex Sans KR"}},
}

local scene = tmath.scene {
    width = 960, height = 1280, fps = 30, loop = true, theme = vscodeTheme,
    camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 12.8},
}

local function txt(parent, id, value, x, y, role, align, color, layer)

    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["recurrence-boundary"]=true,["ray-conclusion-a"]=true,["ray-conclusion-b"]=true,["ray-title"]=true,["recurrence-title"]=true,["range-title"]=true,["branches-title"]=true}
    if blogHidden[id] then value = "" end
    local options = {
        id = id, text = value, point = {x, y}, role = role,
        align = align or {0, 0.5}, layer = layer or L.text,
    }
    if color then options.fill = color end
    return parent:text(options)
end

local function rule(id, y)
    return scene:line {
        id = id, from = {-4.30, y}, to = {4.30, y},
        stroke = "border", width = 1.1, layer = L.guide,
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

local function translateMatrix(x, y)
    return basisMatrix({1, 0}, {0, 1}, x, y)
end

local function segmentMatrix(from, to)
    return basisMatrix({to[1] - from[1], to[2] - from[2]}, {0, 1}, from[1], from[2])
end

local function added(a, b)
    return {a[1] + b[1], a[2] + b[2]}
end

local function scaled(vector, amount)
    return {vector[1] * amount, vector[2] * amount}
end

local function dot(a, b)
    return a[1] * b[1] + a[2] * b[2]
end

local function maximum(a, b)
    return a > b and a or b
end

local function minimum(a, b)
    return a < b and a or b
end

local function displayNumber(value)
    if math.abs(value) < 0.005 then return "0" end
    return string.format("%.2f", value)
end

local seam = {1, 0}
local normal = {0, 1}
local yStep = {0.18, 0.76}
local spanLength = 6
local plotOrigin = {-0.20, 3.35}
local plotScale = 1.65
local states = {
    {key = "a", q0 = {-1.44, -0.20}, xStep = {0.72, 0.04}},
    {key = "b", q0 = {1.44, -0.20}, xStep = {-0.72, 0.04}},
}

local function toWorld(point)
    return {
        plotOrigin[1] + point[1] * plotScale,
        plotOrigin[2] + point[2] * plotScale,
    }
end

for _, state in ipairs(states) do
    state.seamProjection = dot(state.q0, seam)
    state.seamProjectionDx = dot(seam, state.xStep)
    state.dFdx = dot(normal, state.xStep)
    state.dFdy = dot(normal, yStep)
    state.fwidth = math.abs(state.dFdx) + math.abs(state.dFdy)
    state.samples = {}
    for index = 0, spanLength - 1 do
        local q = added(state.q0, scaled(state.xStep, index))
        state.samples[index + 1] = {
            q = q,
            projection = dot(q, seam),
            distance = dot(q, normal) / state.fwidth,
            world = toWorld(q),
            projectionWorld = toWorld({dot(q, seam), 0}),
        }
    end

    state.beginIndex = 0
    state.endIndex = spanLength
    if state.seamProjectionDx > 0 then
        state.beginIndex = maximum(state.beginIndex,
            math.ceil(-state.seamProjection / state.seamProjectionDx))
    elseif state.seamProjectionDx < 0 then
        state.endIndex = minimum(state.endIndex,
            math.floor(-state.seamProjection / state.seamProjectionDx) + 1)
    elseif state.seamProjection < 0 then
        state.endIndex = 0
    end
end

txt(scene, "title", "Appendix B · why cache seamProjectionDx?", -4.30, 5.82, "h2")
txt(scene, "subtitle", "One cached dot turns the infinite AA band into the forward conic seam ray.", -4.30, 5.45, "text")
rule("header-rule", 5.12)

txt(scene, "ray-title", "INFINITE BAND -> FORWARD RAY", -4.30, 4.83, "h3")
txt(scene, "normal-band-label", "normal band · |D| < .5", -4.10, 4.43, "code", nil, C.normal)
txt(scene, "forward-ray-label", "forward ray · P >= 0", 0.32, 4.43, "code", nil, C.seam)

scene:rectangle {
    id = "ray-normal-band", center = {0, plotOrigin[2]}, size = {8.10, 1.32},
    fill = C.normal, stroke = transparent, opacity = 0.08, layer = L.base,
}
scene:line {
    id = "ray-infinite-line", from = {-4.05, plotOrigin[2]}, to = {4.05, plotOrigin[2]},
    stroke = "border", width = 1.4, dash = {6, 5}, layer = L.guide,
}
scene:line {
    id = "ray-back-half", from = {-4.05, plotOrigin[2]}, to = {plotOrigin[1], plotOrigin[2]},
    stroke = C.seam, width = 1.8, dash = {5, 5}, opacity = 0.45, layer = L.band,
}
scene:arrow {
    id = "ray-forward-half", from = plotOrigin, to = {4.05, plotOrigin[2]},
    stroke = C.seam, width = 2.8, tip = 10, layer = L.arrow,
}
scene:point {
    id = "ray-origin", point = plotOrigin, radius = 5,
    fill = C.seam, stroke = "surface", width = 1.5, layer = L.mark,
}
scene:arrow {
    id = "ray-normal", from = plotOrigin, to = {plotOrigin[1], 4.46},
    stroke = C.normal, width = 2.3, tip = 9, layer = L.arrow,
}
txt(scene, "ray-normal-label", "normal", plotOrigin[1] - 0.75, 4.02, "code", nil, C.normal)
txt(scene, "ray-back-label", "P < 0 · back half", -3.95, 2.47, "text", nil, "muted")
txt(scene, "ray-front-label", "P >= 0 · keep", 0.12, 2.47, "text", nil, C.kept)

local sampleOwners = {}
local excludedRings = {}
for index = 0, spanLength - 1 do
    local sampleState = states[1].samples[index + 1]
    local owner = scene:group {
        id = "ray-sample-owner-" .. index,
        matrix = translateMatrix(sampleState.world[1], sampleState.world[2]),
    }
    owner:point {
        id = "ray-sample-" .. index, point = {0, 0}, radius = 6,
        fill = C.pixel, stroke = "surface", width = 1.6, layer = L.mark,
    }
    excludedRings[index + 1] = owner:circle {
        id = "ray-excluded-ring-" .. index, center = {0, 0}, radius = 0.115,
        fill = transparent, stroke = C.excluded, width = 2.2,
        opacity = index < states[1].beginIndex and 1 or 0, layer = L.arrow,
    }
    sampleOwners[index + 1] = owner
end

local stepArrow = scene:group {
    id = "ray-xstep-owner",
    matrix = segmentMatrix(states[1].samples[1].world, states[1].samples[2].world),
}
stepArrow:arrow {
    id = "ray-xstep", from = {0, 0}, to = {1, 0},
    stroke = C.step, width = 2.8, tip = 9, layer = L.arrow,
}

local guide0 = scene:group {
    id = "ray-projection-guide-0",
    matrix = segmentMatrix(states[1].samples[1].world, states[1].samples[1].projectionWorld),
}
guide0:line {
    id = "ray-projection-guide-line-0", from = {0, 0}, to = {1, 0},
    stroke = C.projection, width = 1.3, dash = {4, 4}, opacity = 0.65, layer = L.guide,
}
local guide1 = scene:group {
    id = "ray-projection-guide-1",
    matrix = segmentMatrix(states[1].samples[2].world, states[1].samples[2].projectionWorld),
}
guide1:line {
    id = "ray-projection-guide-line-1", from = {0, 0}, to = {1, 0},
    stroke = C.projection, width = 1.3, dash = {4, 4}, opacity = 0.65, layer = L.guide,
}

local projectionStep = scene:group {
    id = "ray-projection-step-owner",
    matrix = segmentMatrix(states[1].samples[1].projectionWorld, states[1].samples[2].projectionWorld),
}
projectionStep:arrow {
    id = "ray-projection-step", from = {0, 0}, to = {1, 0},
    stroke = C.projection, width = 3.2, tip = 9, layer = L.arrow,
}
local projectionCursor = scene:group {
    id = "ray-projection-cursor-owner",
    matrix = translateMatrix(states[1].samples[1].projectionWorld[1], states[1].samples[1].projectionWorld[2]),
}
projectionCursor:point {
    id = "ray-projection-cursor", point = {0, 0}, radius = 7,
    fill = C.projection, stroke = "surface", width = 1.7, layer = L.mark,
}
txt(scene, "ray-step-caption", "surface +x step", -4.10, 2.17, "text", nil, C.step)
txt(scene, "ray-projection-caption", "projected delta", -1.95, 2.17, "text", nil, C.projection)

local stateAHeading = scene:group {id = "ray-state-a-heading-group"}
txt(stateAHeading, "state-a-ray-heading",
    "A · Pdx=" .. displayNumber(states[1].seamProjectionDx) .. " > 0",
    4.20, 4.80, "code", {1, 0.5}, C.projection)
txt(stateAHeading, "state-a-ray-result",
    "begin -> " .. states[1].beginIndex,
    4.20, 4.45, "code", {1, 0.5}, C.kept)
local stateBHeading = scene:group {id = "ray-state-b-heading-group", opacity = 0}
txt(stateBHeading, "state-b-ray-heading",
    "B · Pdx=" .. displayNumber(states[2].seamProjectionDx) .. " < 0",
    4.20, 4.80, "code", {1, 0.5}, C.projection)
txt(stateBHeading, "state-b-ray-result",
    "end -> " .. states[2].endIndex,
    4.20, 4.45, "code", {1, 0.5}, C.kept)

rule("ray-rule", 1.92)
txt(scene, "recurrence-title", "WHY THE DOT IS A PER-PIXEL DELTA", -4.30, 1.63, "h3")
txt(scene, "recurrence-q", "q_i = q_0 + i xStep", -4.12, 1.20, "code", nil, C.pixel)
txt(scene, "recurrence-p", "P_i = dot(q_i, seam)", -4.12, 0.80, "code", nil, C.seam)
txt(scene, "recurrence-delta", "P_(i+1) - P_i = dot(seam, xStep)", -4.12, 0.40, "code", nil, C.projection)
txt(scene, "recurrence-name", "= seamProjectionDx", 1.55, 0.40, "code", nil, C.projection)
txt(scene, "recurrence-boundary", "seam-axis delta · not the fwidth-normalized distance", -4.12, -0.03, "text", nil, "muted")

local recurrenceA = scene:group {id = "ray-recurrence-a"}
txt(recurrenceA, "state-a-recurrence-values",
    "A: P_i = " .. displayNumber(states[1].seamProjection) .. " + i·" .. displayNumber(states[1].seamProjectionDx),
    0.30, 1.20, "code", nil, C.projection)
txt(recurrenceA, "state-a-recurrence-result",
    "crosses P=0 at i=" .. states[1].beginIndex,
    0.30, 0.80, "code", nil, C.kept)
local recurrenceB = scene:group {id = "ray-recurrence-b", opacity = 0}
txt(recurrenceB, "state-b-recurrence-values",
    "B: P_i = " .. displayNumber(states[2].seamProjection) .. " + i·(" .. displayNumber(states[2].seamProjectionDx) .. ")",
    0.30, 1.20, "code", nil, C.projection)
txt(recurrenceB, "state-b-recurrence-result",
    "leaves P>=0 after i=" .. (states[2].endIndex - 1),
    0.30, 0.80, "code", nil, C.kept)

rule("recurrence-rule", -0.42)
txt(scene, "range-title", "ONE DIVIDE CLIPS THE WHOLE HALF-OPEN SPAN", -4.30, -0.71, "h3")

local rowLeft, cellWidth, cellY = -3.90, 1.25, -1.60
local positiveCellOverlays = {}
local negativeCellOverlays = {}
local rangeValuesA = scene:group {id = "ray-range-values-a"}
local rangeValuesB = scene:group {id = "ray-range-values-b", opacity = 0}
for index = 0, spanLength - 1 do
    local centerX = rowLeft + cellWidth * (index + 0.5)
    scene:rectangle {
        id = "ray-range-cell-" .. index, center = {centerX, cellY}, size = {cellWidth, 0.66},
        fill = "surface", stroke = "border", width = 1.0, layer = L.base,
    }
    positiveCellOverlays[index + 1] = scene:rectangle {
        id = "ray-positive-excluded-cell-" .. index, center = {centerX, cellY}, size = {cellWidth, 0.66},
        fill = C.excluded, stroke = C.excluded, width = 1.0,
        opacity = index < states[1].beginIndex and 0.20 or 0, layer = L.band,
    }
    negativeCellOverlays[index + 1] = scene:rectangle {
        id = "ray-negative-excluded-cell-" .. index, center = {centerX, cellY}, size = {cellWidth, 0.66},
        fill = C.excluded, stroke = C.excluded, width = 1.0,
        opacity = 0, layer = L.band,
    }
    txt(scene, "ray-range-index-" .. index, "i" .. index, centerX, -1.16, "code", {0.5, 0.5})
    txt(rangeValuesA, "state-a-range-value-" .. index,
        displayNumber(states[1].samples[index + 1].projection), centerX, cellY, "code", {0.5, 0.5},
        index < states[1].beginIndex and C.excluded or C.kept)
    txt(rangeValuesB, "state-b-range-value-" .. index,
        displayNumber(states[2].samples[index + 1].projection), centerX, cellY, "code", {0.5, 0.5},
        index >= states[2].endIndex and C.excluded or C.kept)
end

local function rangeMatrix(beginIndex, endIndex)
    return basisMatrix(
        {(endIndex - beginIndex) * cellWidth, 0}, {0, 1},
        rowLeft + beginIndex * cellWidth, -2.12
    )
end

local rangeBracket = scene:group {
    id = "ray-range-bracket", matrix = rangeMatrix(states[1].beginIndex, states[1].endIndex),
}
rangeBracket:line {
    id = "ray-range-bracket-line", from = {0, 0}, to = {1, 0},
    stroke = C.kept, width = 3.0, layer = L.mark,
}
rangeBracket:line {
    id = "ray-range-bracket-begin", from = {0, -0.13}, to = {0, 0.13},
    stroke = C.kept, width = 2.2, layer = L.mark,
}
rangeBracket:line {
    id = "ray-range-bracket-end", from = {1, -0.13}, to = {1, 0.13},
    stroke = C.kept, width = 2.2, layer = L.mark,
}

local rangeA = scene:group {id = "ray-range-a"}
txt(rangeA, "state-a-range-formula",
    "Pdx>0: begin=max(begin, ceil(-P0/Pdx))=" .. states[1].beginIndex,
    -4.02, -2.49, "code", nil, C.kept)
txt(rangeA, "state-a-range-result",
    "result [" .. states[1].beginIndex .. "," .. states[1].endIndex .. ") · P=0 stays included",
    4.02, -2.49, "code", {1, 0.5}, C.kept)
local rangeB = scene:group {id = "ray-range-b", opacity = 0}
txt(rangeB, "state-b-range-formula",
    "Pdx<0: end=min(end, floor(-P0/Pdx)+1)=" .. states[2].endIndex,
    -4.02, -2.49, "code", nil, C.kept)
txt(rangeB, "state-b-range-result",
    "result [" .. states[2].beginIndex .. "," .. states[2].endIndex .. ") · P=0 stays included",
    4.02, -2.49, "code", {1, 0.5}, C.kept)
txt(scene, "range-candidate-label", "normal-distance candidate before this gate: [0,6)", 0, -2.86, "text", {0.5, 0.5}, "muted")

rule("range-rule", -3.16)
txt(scene, "branches-title", "THE SIGN CHOOSES WHICH BOUNDARY CAN MOVE", -4.30, -3.45, "h3")

local positiveFocus = scene:line {
    id = "ray-positive-focus", from = {-4.14, -4.08}, to = {4.14, -4.08},
    stroke = C.kept, width = 2.4, opacity = 1, layer = L.guide,
}
local negativeFocus = scene:line {
    id = "ray-negative-focus", from = {-4.14, -4.56}, to = {4.14, -4.56},
    stroke = C.kept, width = 2.4, opacity = 0, layer = L.guide,
}
local zeroFocus = scene:line {
    id = "ray-zero-focus", from = {-4.14, -5.04}, to = {4.14, -5.04},
    stroke = C.kept, width = 2.4, opacity = 0, layer = L.guide,
}
txt(scene, "branch-positive-sign", "Pdx > 0", -4.12, -3.91, "code", nil, C.projection)
txt(scene, "branch-positive-rule", "projection rises -> move begin", -2.80, -3.91, "text")
txt(scene, "branch-positive-result", "[2,6)", 4.10, -3.91, "code", {1, 0.5}, C.kept)
txt(scene, "branch-negative-sign", "Pdx < 0", -4.12, -4.39, "code", nil, C.projection)
txt(scene, "branch-negative-rule", "projection falls -> move end", -2.80, -4.39, "text")
txt(scene, "branch-negative-result", "[0,3)", 4.10, -4.39, "code", {1, 0.5}, C.kept)
txt(scene, "branch-zero-sign", "Pdx = 0", -4.12, -4.87, "code", nil, C.projection)
txt(scene, "branch-zero-rule", "projection is constant -> keep all or reject all", -2.80, -4.87, "text")
txt(scene, "branch-zero-result", "P0 decides", 4.10, -4.87, "code", {1, 0.5}, C.kept)

txt(scene, "ray-conclusion-a", "normal distance selects the infinite one-pixel band", -4.12, -5.38, "text", nil, C.normal)
txt(scene, "ray-conclusion-b", "seamProjectionDx clips that band to the forward conic ray", -4.12, -5.73, "text", nil, C.kept)

local fullRangeMatrix = rangeMatrix(0, spanLength)
local gentle = {preset = "gentle", strength = 0.86}
local reverseGentle = {preset = "gentle", strength = 0.86, reverse = true}

scene:wait(0.45)
local resetTargets = {
    {target = rangeBracket, transform = fullRangeMatrix},
    {target = positiveFocus, opacity = 0},
}
for index = 1, spanLength do
    resetTargets[#resetTargets + 1] = {target = excludedRings[index], opacity = 0}
    resetTargets[#resetTargets + 1] = {target = positiveCellOverlays[index], opacity = 0}
end
scene:play(resetTargets, 0.35, gentle, 0)

scene:play({{target = projectionCursor, transform = translateMatrix(
    states[1].samples[2].projectionWorld[1], states[1].samples[2].projectionWorld[2])}}, 0.55, gentle, 0)
scene:play({{target = projectionCursor, transform = translateMatrix(
    states[1].samples[3].projectionWorld[1], states[1].samples[3].projectionWorld[2])}}, 0.55, gentle, 0)
scene:wait(0.25)

local positiveClipTargets = {
    {target = rangeBracket, transform = rangeMatrix(states[1].beginIndex, states[1].endIndex)},
    {target = positiveFocus, opacity = 1},
}
for index = 1, spanLength do
    positiveClipTargets[#positiveClipTargets + 1] = {
        target = excludedRings[index], opacity = index <= states[1].beginIndex and 1 or 0,
    }
    positiveClipTargets[#positiveClipTargets + 1] = {
        target = positiveCellOverlays[index], opacity = index <= states[1].beginIndex and 0.20 or 0,
    }
end
scene:play(positiveClipTargets, 0.65, reverseGentle, 0)
scene:play({{target = projectionCursor, transform = translateMatrix(
    states[1].samples[1].projectionWorld[1], states[1].samples[1].projectionWorld[2])}}, 0.35, reverseGentle, 0)
scene:wait(0.25)

local negativeTargets = {
    {target = stepArrow, transform = segmentMatrix(states[2].samples[1].world, states[2].samples[2].world)},
    {target = guide0, transform = segmentMatrix(states[2].samples[1].world, states[2].samples[1].projectionWorld)},
    {target = guide1, transform = segmentMatrix(states[2].samples[2].world, states[2].samples[2].projectionWorld)},
    {target = projectionStep, transform = segmentMatrix(states[2].samples[1].projectionWorld, states[2].samples[2].projectionWorld)},
    {target = projectionCursor, transform = translateMatrix(states[2].samples[1].projectionWorld[1], states[2].samples[1].projectionWorld[2])},
    {target = rangeBracket, transform = rangeMatrix(states[2].beginIndex, states[2].endIndex)},
    {target = stateAHeading, opacity = 0}, {target = stateBHeading, opacity = 1},
    {target = recurrenceA, opacity = 0}, {target = recurrenceB, opacity = 1},
    {target = rangeValuesA, opacity = 0}, {target = rangeValuesB, opacity = 1},
    {target = rangeA, opacity = 0}, {target = rangeB, opacity = 1},
    {target = positiveFocus, opacity = 0}, {target = negativeFocus, opacity = 1},
}
for index = 1, spanLength do
    negativeTargets[#negativeTargets + 1] = {
        target = sampleOwners[index],
        transform = translateMatrix(states[2].samples[index].world[1], states[2].samples[index].world[2]),
    }
    negativeTargets[#negativeTargets + 1] = {
        target = excludedRings[index], opacity = index > states[2].endIndex and 1 or 0,
    }
    negativeTargets[#negativeTargets + 1] = {target = positiveCellOverlays[index], opacity = 0}
    negativeTargets[#negativeTargets + 1] = {
        target = negativeCellOverlays[index], opacity = index > states[2].endIndex and 0.20 or 0,
    }
end
scene:play(negativeTargets, 1.20, gentle, 0)
scene:wait(0.60)

scene:play({{target = negativeFocus, opacity = 0}, {target = zeroFocus, opacity = 1}}, 0.35, gentle, 0)
scene:wait(1.10)
scene:play({{target = zeroFocus, opacity = 0}, {target = negativeFocus, opacity = 1}}, 0.35, reverseGentle, 0)
scene:wait(0.35)

local positiveTargets = {
    {target = stepArrow, transform = segmentMatrix(states[1].samples[1].world, states[1].samples[2].world)},
    {target = guide0, transform = segmentMatrix(states[1].samples[1].world, states[1].samples[1].projectionWorld)},
    {target = guide1, transform = segmentMatrix(states[1].samples[2].world, states[1].samples[2].projectionWorld)},
    {target = projectionStep, transform = segmentMatrix(states[1].samples[1].projectionWorld, states[1].samples[2].projectionWorld)},
    {target = projectionCursor, transform = translateMatrix(states[1].samples[1].projectionWorld[1], states[1].samples[1].projectionWorld[2])},
    {target = rangeBracket, transform = rangeMatrix(states[1].beginIndex, states[1].endIndex)},
    {target = stateAHeading, opacity = 1}, {target = stateBHeading, opacity = 0},
    {target = recurrenceA, opacity = 1}, {target = recurrenceB, opacity = 0},
    {target = rangeValuesA, opacity = 1}, {target = rangeValuesB, opacity = 0},
    {target = rangeA, opacity = 1}, {target = rangeB, opacity = 0},
    {target = negativeFocus, opacity = 0}, {target = positiveFocus, opacity = 1},
}
for index = 1, spanLength do
    positiveTargets[#positiveTargets + 1] = {
        target = sampleOwners[index],
        transform = translateMatrix(states[1].samples[index].world[1], states[1].samples[index].world[2]),
    }
    positiveTargets[#positiveTargets + 1] = {
        target = excludedRings[index], opacity = index <= states[1].beginIndex and 1 or 0,
    }
    positiveTargets[#positiveTargets + 1] = {
        target = positiveCellOverlays[index], opacity = index <= states[1].beginIndex and 0.20 or 0,
    }
    positiveTargets[#positiveTargets + 1] = {target = negativeCellOverlays[index], opacity = 0}
end
scene:play(positiveTargets, 1.20, reverseGentle, 0)
scene:wait(12.00 - scene:duration())

return scene
