-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill.conicFwidthAppendix.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, band = 12, mark = 20, arrow = 30, text = 40}
local transparent = "#00000000"
local C = {
    pixel = "info", seam = "danger", normal = "success",
    xStep = "accent", yStep = "secondary", fwidth = "warning",
    localDistance = "info", pixelDistance = "result",
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
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["projection-caption"]=true,["restored-conclusion"]=true,["not-restored-conclusion"]=true,["footprint-title"]=true,["derivation-title"]=true,["normalization-title"]=true,["boundary-title"]=true}
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

local function verticalMatrix(x, y, height)
    return basisMatrix({1, 0}, {0, height}, x, y)
end

local function scaled(vector, amount)
    return {vector[1] * amount, vector[2] * amount}
end

local function dot(a, b)
    return a[1] * b[1] + a[2] * b[2]
end

local normal = {0, 1}
local seamY = 3.00
local footprintCenterX = 0.20
local pixelDistance = 0.25
local states = {
    {key = "a", xBasis = {0.72, 0.20}, yBasis = {0.18, 0.60}},
    {key = "b", xBasis = scaled({0.72, 0.20}, 3), yBasis = scaled({0.18, 0.60}, 3)},
}

for _, state in ipairs(states) do
    state.dFdx = dot(normal, state.xBasis)
    state.dFdy = dot(normal, state.yBasis)
    state.fwidth = math.abs(state.dFdx) + math.abs(state.dFdy)
    state.distance = state.fwidth * pixelDistance
    state.center = {footprintCenterX, seamY + state.distance}
    state.origin = {
        state.center[1] - 0.5 * (state.xBasis[1] + state.yBasis[1]),
        state.center[2] - 0.5 * (state.xBasis[2] + state.yBasis[2]),
    }
    state.footprint = basisMatrix(state.xBasis, state.yBasis, state.origin[1], state.origin[2])
    state.centerMatrix = translateMatrix(state.center[1], state.center[2])
    state.distanceMatrix = verticalMatrix(state.center[1], seamY, state.distance)
    state.dxBar = verticalMatrix(3.20, 2.20, math.abs(state.dFdx))
    state.dyBar = verticalMatrix(3.20, 2.20 + math.abs(state.dFdx), math.abs(state.dFdy))
    state.fwidthBar = verticalMatrix(3.70, 2.20, state.fwidth)
end

local dxBarZero = verticalMatrix(3.20, 2.20, 0.001)
local dyBarZero = verticalMatrix(3.20, 2.20, 0.001)
local fwidthBarZero = verticalMatrix(3.70, 2.20, 0.001)

txt(scene, "title", "Appendix A · why fwidth restores pixel scale", -4.30, 5.82, "h2")
txt(scene, "subtitle", "The local distance and its one-pixel ruler transform together.", -4.30, 5.45, "text")
rule("header-rule", 5.12)

txt(scene, "footprint-title", "ONE PIXEL -> ONE LOCAL FOOTPRINT", -4.30, 4.83, "h3")

local surfacePixel = scene:group {id = "appendix-surface-pixel"}
surfacePixel:rectangle {
    id = "appendix-surface-cell", center = {-3.70, 3.35}, size = {0.90, 0.90},
    fill = C.pixel, stroke = C.pixel, opacity = 0.22, width = 2.0, layer = L.base,
}
surfacePixel:point {
    id = "appendix-surface-center", point = {-3.70, 3.35}, radius = 5,
    fill = C.pixel, stroke = "surface", width = 1.5, layer = L.mark,
}
surfacePixel:arrow {
    id = "appendix-surface-ex", from = {-4.15, 2.76}, to = {-3.25, 2.76},
    stroke = C.xStep, width = 2.4, tip = 8, layer = L.arrow,
}
surfacePixel:arrow {
    id = "appendix-surface-ey", from = {-4.15, 2.76}, to = {-4.15, 3.66},
    stroke = C.yStep, width = 2.4, tip = 8, layer = L.arrow,
}
txt(scene, "surface-ex-label", "e_x · 1px", -3.70, 2.52, "code", {0.5, 0.5}, C.xStep)
txt(scene, "surface-ey-label", "e_y", -4.10, 3.88, "code", {0.5, 0.5}, C.yStep)
txt(scene, "surface-space-label", "Surface Space", -3.60, 2.15, "text", {0.5, 0.5})

scene:arrow {
    id = "appendix-inverse-arrow", from = {-3.02, 3.35}, to = {-1.45, 3.35},
    stroke = "foreground", width = 2.3, tip = 10, layer = L.arrow,
}
txt(scene, "appendix-inverse-label", "M^-1", -2.24, 3.67, "code", {0.5, 0.5})

local footprint = scene:group {id = "appendix-gradient-footprint", matrix = states[1].footprint}
footprint:polygon {
    id = "appendix-gradient-cell", points = {{0, 0}, {1, 0}, {1, 1}, {0, 1}},
    fill = C.pixel, stroke = C.pixel, opacity = 0.20, width = 2.2, layer = L.base,
}
footprint:arrow {
    id = "appendix-x-step", from = {0, 0}, to = {1, 0},
    stroke = C.xStep, width = 2.8, tip = 9, layer = L.arrow,
}
footprint:arrow {
    id = "appendix-y-step", from = {0, 0}, to = {0, 1},
    stroke = C.yStep, width = 2.8, tip = 9, layer = L.arrow,
}

local sample = scene:group {id = "appendix-local-sample", matrix = states[1].centerMatrix}
sample:point {
    id = "appendix-local-center", point = {0, 0}, radius = 6,
    fill = C.localDistance, stroke = "surface", width = 1.7, layer = L.mark,
}
local distance = scene:group {id = "appendix-local-distance", matrix = states[1].distanceMatrix}
distance:arrow {
    id = "appendix-local-distance-arrow", from = {0, 0}, to = {0, 1},
    stroke = C.localDistance, width = 3.0, tip = 8, layer = L.arrow,
}

scene:line {
    id = "appendix-seam", from = {-1.30, seamY}, to = {1.95, seamY},
    stroke = C.seam, width = 1.8, layer = L.band,
}
scene:arrow {
    id = "appendix-normal", from = {1.72, seamY}, to = {1.72, 4.48},
    stroke = C.normal, width = 2.3, tip = 9, layer = L.arrow,
}
txt(scene, "appendix-seam-label", "seam · F=0", -1.26, 2.72, "code", nil, C.seam)
txt(scene, "appendix-normal-label", "n", 1.92, 4.42, "code", nil, C.normal)
txt(scene, "gradient-space-label", "Gradient Space", 0.20, 1.78, "text", {0.5, 0.5})

local projectionStage = scene:group {id = "appendix-projection-stage"}
local dxBar = projectionStage:group {id = "appendix-dfdx-bar", matrix = states[1].dxBar}
dxBar:rectangle {
    id = "appendix-dfdx-fill", center = {0, 0.5}, size = {0.13, 1},
    fill = C.xStep, stroke = C.xStep, width = 1.0, layer = L.mark,
}
local dyBar = projectionStage:group {id = "appendix-dfdy-bar", matrix = states[1].dyBar}
dyBar:rectangle {
    id = "appendix-dfdy-fill", center = {0, 0.5}, size = {0.13, 1},
    fill = C.yStep, stroke = C.yStep, width = 1.0, layer = L.mark,
}
local fwidthBar = projectionStage:group {id = "appendix-fwidth-bracket", matrix = states[1].fwidthBar}
fwidthBar:line {
    id = "appendix-fwidth-line", from = {0, 0}, to = {0, 1},
    stroke = C.fwidth, width = 2.4, layer = L.mark,
}
fwidthBar:line {
    id = "appendix-fwidth-bottom", from = {-0.10, 0}, to = {0.10, 0},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
fwidthBar:line {
    id = "appendix-fwidth-top", from = {-0.10, 1}, to = {0.10, 1},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
txt(scene, "projection-caption", "normal span of one pixel", 4.18, 1.83, "text", {1, 0.5}, C.fwidth)

local stateA = scene:group {id = "appendix-state-a"}
txt(stateA, "state-a-heading", "A · compact", 2.45, 4.74, "code", nil, C.pixel)
txt(stateA, "state-a-measure", "F=.2    fwidth=.8", 2.45, 4.38, "code", nil, C.fwidth)
local stateB = scene:group {id = "appendix-state-b", opacity = 0}
txt(stateB, "state-b-heading", "B · q=3q_A", 2.45, 4.74, "code", nil, C.pixel)
txt(stateB, "state-b-measure", "F=.6    fwidth=2.4", 2.45, 4.38, "code", nil, C.fwidth)

local proxySource = basisMatrix({0.90, 0}, {0, 0.90}, -4.15, 2.90)
local pixelProxy = scene:group {
    id = "appendix-pixel-proxy", matrix = states[1].footprint, opacity = 0,
}
pixelProxy:polygon {
    id = "appendix-pixel-proxy-cell", points = {{0, 0}, {1, 0}, {1, 1}, {0, 1}},
    fill = C.pixel, stroke = C.pixel, opacity = 0.28, width = 2.2, layer = L.mark,
}
pixelProxy:point {
    id = "appendix-pixel-proxy-center", point = {0.5, 0.5}, radius = 5,
    fill = C.pixel, stroke = "surface", width = 1.5, layer = L.arrow,
}

rule("footprint-rule", 1.48)
txt(scene, "derivation-title", "WHY FWIDTH CHANGES IN THE SAME PROPORTION", -4.30, 1.19, "h3")
txt(scene, "formula-q", "q(p) = A p + b", -4.12, 0.76, "code", nil, C.pixel)
txt(scene, "formula-f", "F(p) = n · q(p)", -4.12, 0.36, "code", nil, C.localDistance)
txt(scene, "formula-dfdx", "dFdx = n · xStep", 0.26, 0.76, "code", nil, C.xStep)
txt(scene, "formula-dfdy", "dFdy = n · yStep", 0.26, 0.36, "code", nil, C.yStep)
txt(scene, "formula-step", "xStep=A e_x,  yStep=A e_y", -4.12, -0.06, "code")
txt(scene, "formula-fwidth", "fwidth(F) = |dFdx| + |dFdy|", 0.26, -0.06, "code", nil, C.fwidth)
txt(scene, "formula-proportion", "q -> 3q   =>   F -> 3F,   fwidth -> 3fwidth", -4.12, -0.48, "code", nil, C.pixelDistance)

rule("derivation-rule", -0.76)
txt(scene, "normalization-title", "DIVISION REMOVES THE LOCAL RULER", -4.30, -1.05, "h3")

local rulerAY = -1.60
local rulerAStart, rulerAWidth = -4.05, 1.20
local rawAX = rulerAStart + rulerAWidth * pixelDistance
scene:line {
    id = "appendix-ruler-a", from = {rulerAStart, rulerAY}, to = {rulerAStart + rulerAWidth, rulerAY},
    stroke = C.fwidth, width = 5.0, layer = L.guide,
}
scene:line {
    id = "appendix-ruler-a-start", from = {rulerAStart, rulerAY - 0.12}, to = {rulerAStart, rulerAY + 0.12},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
scene:line {
    id = "appendix-ruler-a-end", from = {rulerAStart + rulerAWidth, rulerAY - 0.12}, to = {rulerAStart + rulerAWidth, rulerAY + 0.12},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
txt(scene, "ruler-a-title", "A · one px = .8 local", -4.05, -1.31, "code", nil, C.fwidth)
txt(scene, "ruler-a-value", "F=.2", rawAX, -1.91, "code", {0.5, 0.5}, C.localDistance)

local rulerBY = -1.60
local rulerBStart, rulerBWidth = 0.45, 3.60
local rawBX = rulerBStart + rulerBWidth * pixelDistance
scene:line {
    id = "appendix-ruler-b", from = {rulerBStart, rulerBY}, to = {rulerBStart + rulerBWidth, rulerBY},
    stroke = C.fwidth, width = 5.0, layer = L.guide,
}
scene:line {
    id = "appendix-ruler-b-start", from = {rulerBStart, rulerBY - 0.12}, to = {rulerBStart, rulerBY + 0.12},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
scene:line {
    id = "appendix-ruler-b-end", from = {rulerBStart + rulerBWidth, rulerBY - 0.12}, to = {rulerBStart + rulerBWidth, rulerBY + 0.12},
    stroke = C.fwidth, width = 2.0, layer = L.mark,
}
txt(scene, "ruler-b-title", "B · one px = 2.4 local", 0.45, -1.31, "code", nil, C.fwidth)
txt(scene, "ruler-b-value", "F=.6", rawBX, -1.91, "code", {0.5, 0.5}, C.localDistance)

txt(scene, "ruler-a-inverse", "× 1/.8", -3.45, -2.20, "code", {0.5, 0.5}, C.fwidth)
txt(scene, "ruler-b-inverse", "× 1/2.4", 2.25, -2.20, "code", {0.5, 0.5}, C.fwidth)

local normalizedY = -2.80
local normalizedLeft, normalizedRight = -1.20, 1.20
local normalizedX = normalizedLeft + (normalizedRight - normalizedLeft) * pixelDistance
scene:line {
    id = "appendix-normalized-ruler", from = {normalizedLeft, normalizedY}, to = {normalizedRight, normalizedY},
    stroke = C.pixelDistance, width = 5.0, layer = L.guide,
}
scene:line {
    id = "appendix-normalized-start", from = {normalizedLeft, normalizedY - 0.12}, to = {normalizedLeft, normalizedY + 0.12},
    stroke = C.pixelDistance, width = 2.0, layer = L.mark,
}
scene:line {
    id = "appendix-normalized-end", from = {normalizedRight, normalizedY - 0.12}, to = {normalizedRight, normalizedY + 0.12},
    stroke = C.pixelDistance, width = 2.0, layer = L.mark,
}
txt(scene, "normalized-ruler-label", "one surface-pixel ruler", 0, -2.48, "text", {0.5, 0.5})
scene:circle {
    id = "appendix-normalized-target", center = {normalizedX, normalizedY}, radius = 0.085,
    fill = transparent, stroke = C.pixelDistance, width = 2.2, layer = L.mark,
}
local tokenA = scene:point {
    id = "appendix-token-a", point = {rawAX, rulerAY}, radius = 6,
    fill = C.localDistance, stroke = "surface", width = 1.6, layer = L.arrow,
}
local tokenB = scene:point {
    id = "appendix-token-b", point = {rawBX, rulerBY}, radius = 6,
    fill = C.localDistance, stroke = "surface", width = 1.6, layer = L.arrow,
}
local tokenAShift = {normalizedX - rawAX, normalizedY - rulerAY}
local tokenBShift = {normalizedX - rawBX, normalizedY - rulerBY}
txt(scene, "normalization-result", ".2/.8 = .6/2.4 = .25 surface px", 0, -3.23, "code", {0.5, 0.5}, C.pixelDistance)

rule("normalization-rule", -3.50)
txt(scene, "boundary-title", "WHAT IS ACTUALLY RESTORED", -4.30, -3.79, "h3")

local bandLeft, bandRight, bandY = -4.05, 0.55, -4.47
scene:line {
    id = "appendix-normalized-band", from = {bandLeft, bandY}, to = {bandRight, bandY},
    stroke = C.pixelDistance, width = 5.0, layer = L.guide,
}
local function bandX(value)
    return bandLeft + (value + 0.5) * (bandRight - bandLeft)
end
for _, tick in ipairs({-0.5, 0, 0.5}) do
    local x = bandX(tick)
    scene:line {
        id = "appendix-band-tick-" .. tostring(tick), from = {x, bandY - 0.18}, to = {x, bandY + 0.18},
        stroke = tick == 0 and C.seam or "foreground", width = tick == 0 and 2.4 or 1.4, layer = L.mark,
    }
    txt(scene, "appendix-band-label-" .. tostring(tick), tick == 0.5 and "+.5" or tostring(tick),
        x, -4.82, "code", {0.5, 0.5}, tick == 0 and C.seam or nil)
end
local normalizedMarkerX = bandX(pixelDistance)
scene:point {
    id = "appendix-normalized-marker", point = {normalizedMarkerX, bandY}, radius = 7,
    fill = C.pixelDistance, stroke = "surface", width = 1.8, layer = L.mark,
}
txt(scene, "appendix-normalized-marker-label", "D=.25", normalizedMarkerX, -4.10, "code", {0.5, 0.5}, C.pixelDistance)

txt(scene, "boundary-distance", "D = F / fwidth(F)", 1.18, -4.15, "code", nil, C.pixelDistance)
txt(scene, "boundary-unit", "fwidth(D) = 1", 1.18, -4.55, "code", nil, C.fwidth)
txt(scene, "boundary-l1", "one L1 pixel footprint", 1.18, -4.91, "text", nil, "muted")
local proofFocus = scene:line {
    id = "appendix-proof-focus", from = {1.18, -4.76}, to = {3.45, -4.76},
    stroke = C.pixelDistance, width = 2.2, opacity = 0, layer = L.band,
}

txt(scene, "restored-conclusion", "Restored: signed seam distance in surface-pixel units", -4.12, -5.35, "text", nil, C.pixelDistance)
txt(scene, "not-restored-conclusion", "Not restored: q -> p or the full surface position (x, y)", -4.12, -5.72, "text", nil, "muted")

local gentle = {preset = "gentle", strength = 0.86}
local reverseGentle = {preset = "gentle", strength = 0.86, reverse = true}

scene:wait(0.45)
scene:play({
    {target = footprint, opacity = 0.12},
    {target = sample, opacity = 0.12},
    {target = distance, opacity = 0.12},
    {target = projectionStage, opacity = 0.12},
    {target = dxBar, transform = dxBarZero},
    {target = dyBar, transform = dyBarZero},
    {target = fwidthBar, transform = fwidthBarZero},
}, 0.30, gentle, 0)
scene:play({{target = pixelProxy, transform = proxySource}}, 0.10, gentle, 0)
scene:fade(pixelProxy, 1, 0.20, reverseGentle)
scene:play({{target = pixelProxy, transform = states[1].footprint}}, 1.10, gentle, 0)
scene:play({
    {target = pixelProxy, opacity = 0},
    {target = footprint, opacity = 1},
    {target = sample, opacity = 1},
    {target = distance, opacity = 1},
}, 0.25, reverseGentle, 0)

scene:fade(projectionStage, 1, 0.18, reverseGentle)
scene:play({{target = dxBar, transform = states[1].dxBar}}, 0.26, reverseGentle, 0)
scene:play({{target = dyBar, transform = states[1].dyBar}}, 0.34, reverseGentle, 0)
scene:play({{target = fwidthBar, transform = states[1].fwidthBar}}, 0.42, reverseGentle, 0)
scene:wait(0.20)

scene:play({
    {target = footprint, transform = states[2].footprint},
    {target = sample, transform = states[2].centerMatrix},
    {target = distance, transform = states[2].distanceMatrix},
    {target = dxBar, transform = states[2].dxBar},
    {target = dyBar, transform = states[2].dyBar},
    {target = fwidthBar, transform = states[2].fwidthBar},
    {target = stateA, opacity = 0},
    {target = stateB, opacity = 1},
}, 1.20, gentle, 0)
scene:wait(0.35)

scene:play({
    {target = tokenA, shift = tokenAShift, fill = C.pixelDistance},
    {target = tokenB, shift = tokenBShift, fill = C.pixelDistance},
}, 0.70, gentle, 0)
scene:fade(proofFocus, 1, 0.30, reverseGentle)
scene:wait(0.35)
scene:fade(proofFocus, 0, 0.30, gentle)
scene:play({
    {target = tokenA, shift = {-tokenAShift[1], -tokenAShift[2]}, fill = C.localDistance},
    {target = tokenB, shift = {-tokenBShift[1], -tokenBShift[2]}, fill = C.localDistance},
}, 0.55, reverseGentle, 0)

scene:play({
    {target = footprint, transform = states[1].footprint},
    {target = sample, transform = states[1].centerMatrix},
    {target = distance, transform = states[1].distanceMatrix},
    {target = dxBar, transform = states[1].dxBar},
    {target = dyBar, transform = states[1].dyBar},
    {target = fwidthBar, transform = states[1].fwidthBar},
    {target = stateA, opacity = 1},
    {target = stateB, opacity = 0},
}, 1.20, reverseGentle, 0)
scene:wait(12.00 - scene:duration())

return scene
