-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill.conicTitle.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, dot = 10, arrow = 30, text = 40}
local transparent = "#00000000"
local scene = tmath.scene {
    width = 720,
    height = 1280,
    fps = 30,
    loop = false,
    theme = {preset = "adaptive_vscode"},
    camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 12.8},
}

local function txt(parent, id, value, point, role, fill, align)

    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["wrap-note"]=true,["transform-title"]=true,["transform-note"]=true,["conclusion-title"]=true,["conclusion-flow"]=true,["conclusion-note"]=true}
    if blogHidden[id] then value = "" end
    local config = {
        id = id,
        text = value,
        point = point,
        role = role,
        align = align or {0.5, 0.5},
        layer = L.text,
    }
    if fill then config.fill = fill end
    return parent:text(config)
end

local function basisMatrix(xBasis, yBasis, x, y)
    return {
        xBasis[1], yBasis[1], 0, x,
        xBasis[2], yBasis[2], 0, y,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }
end

local function hex(rgb)
    return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
end

-- These literal stops are the subject evidence: the same cyclic order is used
-- by the existing conic lookup episode and the renderer's ColorTable.
local stops = {
    {offset = 0.00, rgb = {209, 55, 65}},
    {offset = 0.34, rgb = {234, 150, 42}},
    {offset = 0.68, rgb = {24, 158, 164}},
    {offset = 1.00, rgb = {42, 77, 173}},
}

local function tableColor(t)
    local value = math.max(0, math.min(1, t))
    local left, right = stops[1], stops[#stops]
    for i = 1, #stops - 1 do
        if value <= stops[i + 1].offset then
            left, right = stops[i], stops[i + 1]
            break
        end
    end
    local span = right.offset - left.offset
    local amount = span == 0 and 0 or (value - left.offset) / span
    local rgb = {}
    for i = 1, 3 do
        rgb[i] = math.floor(left.rgb[i] + (right.rgb[i] - left.rgb[i]) * amount + 0.5)
    end
    return hex(rgb)
end

local function pointAt(radius, degrees)
    local radians = degrees * math.pi / 180
    return {radius * math.cos(radians), -radius * math.sin(radians)}
end

txt(scene, "title", "Conic paints by angle.", {0, 5.52}, "h2")
txt(scene, "hook", "One center. Every direction. A color.", {0, 5.05}, "text", "muted")
scene:line {
    id = "title-rule",
    opacity = 0,
    from = {-2.95, 4.68},
    to = {2.95, 4.68},
    stroke = "border",
    width = 1.2,
    layer = L.guide,
}

local wheelA = basisMatrix({1, 0}, {0, 1}, 0, 1.35)
local wheelB = basisMatrix({1.08, 0.24}, {-0.28, 0.82}, 0, 1.22)
local wheel = scene:group {id = "conic-wheel", matrix = wheelA}
local radius = 2.12
local sectorCount = 60
local sectors = {}

wheel:circle {
    id = "wheel-guide",
    center = {0, 0},
    radius = radius,
    fill = transparent,
    stroke = "border",
    width = 1.5,
    layer = L.guide,
}

for i = 0, sectorCount - 1 do
    local a0 = -2 * math.pi * i / sectorCount
    local a1 = -2 * math.pi * (i + 1) / sectorCount
    local color = tableColor(i / (sectorCount - 1))
    sectors[i + 1] = wheel:polygon {
        id = "paint-sector-" .. i,
        points = {
            {0, 0},
            {radius * math.cos(a0), radius * math.sin(a0)},
            {radius * math.cos(a1), radius * math.sin(a1)},
        },
        fill = color,
        stroke = color,
        opacity = i == 0 and 1 or 0.055,
        width = 0.8,
        layer = L.base,
    }
end

local centerDot = wheel:point {
    id = "conic-center",
    point = {0, 0},
    radius = 8,
    fill = "foreground",
    stroke = "surface",
    width = 2,
    -- This point is a deliberate terminal cap and must cover both ray shafts.
    layer = L.arrow + 2,
}
wheel:circle {
    id = "center-orbit",
    center = {0, 0},
    radius = 0.24,
    fill = transparent,
    stroke = "foreground",
    width = 1.4,
    opacity = 0.65,
    layer = L.guide,
}

local initialPoint = pointAt(radius * 0.92, 3)
local rayEnd = wheel:circle {
    id = "ray-end",
    center = initialPoint,
    radius = 0.085,
    fill = tableColor(0),
    stroke = "foreground",
    width = 2,
    layer = L.arrow + 2,
}
wheel:connector {
    id = "paint-ray-underlay",
    from = centerDot,
    to = rayEnd,
    stroke = "foreground",
    width = 6.0,
    tip = 12,
    opacity = 0.72,
    layer = L.arrow - 1,
}
local ray = wheel:connector {
    id = "paint-ray",
    from = centerDot,
    to = rayEnd,
    stroke = tableColor(0),
    width = 3.2,
    tip = 11,
    layer = L.arrow,
}
local seamArrow = wheel:arrow {
    id = "positive-x-seam",
    from = {0, 0},
    to = {radius + 0.36, 0},
    stroke = "danger",
    width = 2.3,
    tip = 10,
    layer = L.arrow,
}
local seamPulse = wheel:point {
    id = "seam-wrap-pulse",
    point = {radius + 0.18, 0},
    radius = 12,
    fill = "danger",
    stroke = "surface",
    width = 2,
    opacity = 0,
    layer = L.arrow,
}
txt(scene, "seam-label", "+x seam", {2.38, 1.02}, "code", "danger")

local wrapCaption = scene:group {id = "wrap-caption", opacity = 0}
txt(wrapCaption, "wrap-title", "360 deg -> 0 deg", {0, -1.28}, "h3", "danger")
txt(wrapCaption, "wrap-note", "the color order closes at the seam", {0, -1.68}, "text", "muted")

local transformCaption = scene:group {id = "transform-caption", opacity = 0}
txt(transformCaption, "transform-title", "Transform the space.", {0, -2.38}, "h3", "accent")
txt(transformCaption, "transform-note", "The cyclic color order stays attached to the gradient.", {0, -2.80}, "text", "muted")

local conclusion = scene:group {id = "conclusion", opacity = 0}
txt(conclusion, "conclusion-title", "Direction becomes color.", {0, -3.48}, "h3", "foreground")
txt(conclusion, "conclusion-flow", "angle -> wrap -> sample -> fill", {0, -3.92}, "code", "accent")
txt(conclusion, "conclusion-note", "That is the conic fill.", {0, -4.42}, "text", "muted")

local linear = {preset = "linear", strength = 1.0}
local enter = {preset = "ease_out", strength = 0.82}
local change = {preset = "ease_in_out", strength = 0.86}
local accent = {preset = "snappy", strength = 0.72}

scene:wait(0.55)
scene:indicate(centerDot, {scale = 1.08, duration = 0.40, curve = accent})
scene:wait(0.15)

-- The moving ray deposits one angular slice per beat. Its point, connector,
-- and new sector always share the selected ColorTable identity.
local previousPoint = initialPoint
for i = 1, sectorCount - 1 do
    local degrees = (i + 0.5) * 360 / sectorCount
    local point = pointAt(radius * 0.92, degrees)
    local color = tableColor(i / (sectorCount - 1))
    scene:play({
        {target = sectors[i + 1], opacity = 1},
        {target = rayEnd, shift = {point[1] - previousPoint[1], point[2] - previousPoint[2]}, fill = color},
        {target = ray, stroke = color},
    }, 0.05, linear, 0)
    previousPoint = point
end
scene:wait(0.25)

-- Crossing +x performs the same cyclic wrap as _conicT.
local seamPoint = pointAt(radius * 0.92, 0)
scene:play({
    {target = rayEnd, shift = {seamPoint[1] - previousPoint[1], seamPoint[2] - previousPoint[2]}, fill = tableColor(0)},
    {target = ray, stroke = tableColor(0)},
    {target = seamPulse, opacity = 1},
    {target = wrapCaption, opacity = 1},
}, 0.40, change, 0)
previousPoint = seamPoint
scene:indicate(seamArrow, {scale = 1.045, duration = 0.38, curve = accent})
scene:wait(0.45)

-- The completed wheel flexes as one affine object. This is not a decorative
-- wobble: it previews the gradient-space transform used by the fill path.
scene:play({
    {target = wheel, transform = wheelB},
    {target = seamPulse, opacity = 0},
    {target = wrapCaption, opacity = 0.34},
    {target = transformCaption, opacity = 1},
}, 1.05, change, 0)
scene:wait(0.25)

for degrees = 10, 120, 10 do
    local point = pointAt(radius * 0.92, degrees)
    local color = tableColor(degrees / 360)
    scene:play({
        {target = rayEnd, shift = {point[1] - previousPoint[1], point[2] - previousPoint[2]}, fill = color},
        {target = ray, stroke = color},
    }, 0.07, linear, 0)
    previousPoint = point
end
scene:wait(0.35)

scene:play({
    {target = wheel, transform = wheelA},
    {target = wrapCaption, opacity = 0},
    {target = transformCaption, opacity = 0},
}, 0.95, change, 0)
scene:play({{target = conclusion, opacity = 1}}, 0.50, enter, 0)
scene:wait(12.00 - scene:duration())

return scene
