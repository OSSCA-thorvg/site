-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill._conicT.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, dot = 10, vector = 20, arrow = 30, text = 40}
local transparent = "#00000000"
local theme = {
    preset = "adaptive_vscode",
    text = {
        h1 = {font = "IBM Plex Sans KR"},
        h2 = {font = "IBM Plex Sans KR"},
    },
}

local scene = tmath.scene {
    width = 720,
    height = 1280,
    fps = 30,
    loop = true,
    theme = theme,
    camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 12.8},
}

local function text(parent, id, value, point, role, color, align)

    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["wrap-conclusion"]=true,["code-title"]=true}
    if blogHidden[id] then value = "" end
    local options = {
        id = id,
        text = value,
        point = point,
        role = role,
        align = align or {0, 0.5},
        layer = L.text,
    }
    if color then options.color = color end
    return parent:text(options)
end

local function hex(rgb)
    return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
end

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

local function wrap(t)
    return t - math.floor(t)
end

local title = scene:group {id = "opening-title"}
text(title, "title", "One ray becomes one color", {-3.08, 5.48}, "h2")
text(title, "hook", "angle -> wrapped turn -> LUT index", {-3.08, 4.98}, "text", "muted")
title:line {
    id = "opening-rule",
    from = {-3.08, 4.62},
    to = {3.08, 4.62},
    stroke = "border",
    width = 1.2,
    layer = L.guide,
}

local content = scene:group {id = "lookup-story"}

local center = {-0.82, 2.97}
local outerRadius = 1.55
local innerRadius = outerRadius * (0.90 / 2.14)
local sectorCount = 48
local ring = content:group {id = "conic-ring"}
local sectors = {}
for i = 0, sectorCount - 1 do
    local a0 = -2 * math.pi * i / sectorCount
    local a1 = -2 * math.pi * (i + 1) / sectorCount
    local color = tableColor(i / (sectorCount - 1))
    sectors[#sectors + 1] = ring:polygon {
        id = "ring-sector-" .. i,
        points = {
            {center[1] + innerRadius * math.cos(a0), center[2] + innerRadius * math.sin(a0)},
            {center[1] + outerRadius * math.cos(a0), center[2] + outerRadius * math.sin(a0)},
            {center[1] + outerRadius * math.cos(a1), center[2] + outerRadius * math.sin(a1)},
            {center[1] + innerRadius * math.cos(a1), center[2] + innerRadius * math.sin(a1)},
        },
        fill = color,
        stroke = color,
        width = 1,
        layer = L.base,
    }
end

local centerGroup = content:group {id = "center-state"}
local centerDot = centerGroup:point {
    id = "ring-center",
    point = center,
    radius = 7,
    fill = "foreground",
    stroke = "surface",
    width = 2,
    layer = L.dot,
}
text(centerGroup, "center-label", "center", {center[1] - 0.14, center[2] + 0.34}, "code", nil, {1, 0.5})

local seamGroup = content:group {id = "seam-state"}
seamGroup:arrow {
    id = "positive-x-seam",
    from = center,
    to = {center[1] + outerRadius + 0.28, center[2]},
    stroke = "danger",
    width = 3,
    tip = 12,
    layer = L.arrow,
}
text(seamGroup, "seam-label", "+x seam / t = 0", {0.80, 2.30}, "code", "danger")

local sampleRadius = outerRadius * (1.68 / 2.14)
local initialDegrees = 110
local function pointAt(degrees)
    local radians = degrees * math.pi / 180
    return {
        center[1] + sampleRadius * math.cos(radians),
        center[2] - sampleRadius * math.sin(radians),
    }
end

local sampleGroup = content:group {id = "ray-sample-state"}
local sampleDot = sampleGroup:point {
    id = "ray-sample",
    point = pointAt(initialDegrees),
    radius = 8,
    fill = tableColor(initialDegrees / 360),
    stroke = "surface",
    width = 2,
    layer = L.dot,
}
local sampleRay = sampleGroup:connector {
    id = "sample-ray",
    from = centerDot,
    to = sampleDot,
    stroke = tableColor(initialDegrees / 360),
    width = 3,
    tip = 11,
    layer = L.arrow,
}

local angleState = content:group {id = "angle-state"}
text(angleState, "angle-flow", "theta -> t -> index", {0.75, 4.08}, "h3")
text(angleState, "turn-110", "110 deg  ->  t = .306", {0.75, 3.65}, "code")
text(angleState, "turn-350", "350 deg  ->  t = .972", {0.75, 3.29}, "code")
text(angleState, "turn-wrap", "375 deg  ->  t = .042", {0.75, 2.72}, "code", "danger")

local code = content:group {id = "verified-code"}
text(code, "code-title", "The renderer performs three steps", {-3.08, 1.15}, "h3")
text(code, "code-l67-a", "L67  auto t = atan2f(ry, rx) * (0.5f / MATH_PI)", {-3.08, 0.77}, "code", "accent")
text(code, "code-l67-b", "     + fill->conic.offset;", {-3.08, 0.45}, "code", "accent")
text(code, "code-l68", "L68  return t - floorf(t);", {-3.08, 0.11}, "code", "danger")
text(code, "code-l354", "L354 pos * (SW_COLOR_TABLE - 1) + 0.5f", {-3.08, -0.23}, "code", "info")

local tableCount = 64
local tableStart = -2.90
local tableWidth = 5.80
local tableStep = tableWidth / tableCount
local tableY = -1.19
local table = content:group {id = "color-table"}
text(table, "table-title", "LUT[0 ... 1023]", {-3.08, -0.66}, "h3")
for i = 0, tableCount - 1 do
    local color = tableColor(i / (tableCount - 1))
    table:rectangle {
        id = "table-cell-" .. i,
        center = {tableStart + (i + 0.5) * tableStep, tableY},
        size = {tableStep * 1.04, 0.60},
        corner = 0,
        fill = color,
        stroke = color,
        width = 0.5,
        layer = L.base,
    }
end
table:rectangle {
    id = "linear-buffer-outline",
    center = {tableStart + tableWidth * 0.5, tableY},
    size = {tableWidth + 0.04, 0.64},
    corner = 0.025,
    fill = transparent,
    stroke = "border",
    width = 1.5,
    layer = L.guide,
}
text(table, "table-zero", "[0]", {tableStart, -1.62}, "code", "muted", {0, 0.5})
text(table, "table-last", "[1023]", {tableStart + tableWidth, -1.62}, "code", "muted", {1, 0.5})

local function selectorX(t)
    return tableStart + tableStep * 0.5 + (tableWidth - tableStep) * t
end

local initialT = initialDegrees / 360
local selectorState = content:group {id = "selector-state"}
local selector = selectorState:rectangle {
    id = "table-selector",
    center = {selectorX(initialT), tableY},
    size = {0.15, 0.80},
    corner = 0.025,
    fill = transparent,
    stroke = tableColor(initialT),
    width = 2.6,
    layer = L.arrow,
}
local selectorLabel = text(selectorState, "selector-label", "index", {selectorX(initialT), -1.90}, "code", tableColor(initialT), {0.5, 0.5})

local swatchState = content:group {id = "swatch-state"}
local sampledColor = swatchState:rectangle {
    id = "sampled-color",
    center = {0, -2.51},
    size = {2.44, 0.72},
    corner = 0.07,
    fill = tableColor(initialT),
    stroke = "border",
    width = 1.5,
    layer = L.dot,
}
local sampledLabel = text(swatchState, "sampled-label", "LUT[index]", {0, -2.99}, "code", tableColor(initialT), {0.5, 0.5})

local wrapState = content:group {id = "wrap-state", opacity = 0}
text(wrapState, "wrap-title", "fract wrap: 1023 -> 0", {0, -3.69}, "h3", "danger", {0.5, 0.5})
text(wrapState, "wrap-conclusion", "The ray, selector, and sampled color share the same t.", {0, -4.15}, "text", "muted", {0.5, 0.5})

local enter = {preset = "ease_out", strength = 0.82}
local change = {preset = "ease_in_out", strength = 0.82}
local gentle = {preset = "gentle", strength = 0.80}
local linear = {preset = "linear", strength = 1.00}

-- The complete lookup is the summary pose. Motion changes only the shared t.
local previousDegrees = initialDegrees
local previousPoint = pointAt(initialDegrees)
local function moveToDegrees(degrees, duration)
    local point = pointAt(degrees)
    local previousT = wrap(previousDegrees / 360)
    local t = wrap(degrees / 360)
    local selectedColor = tableColor(t)
    scene:play({
        {
            target = sampleDot,
            shift = {point[1] - previousPoint[1], point[2] - previousPoint[2]},
            fill = selectedColor,
        },
        {target = sampleRay, stroke = selectedColor},
        {target = selectorState, shift = {selectorX(t) - selectorX(previousT), 0}},
        {target = selector, stroke = selectedColor},
        {target = selectorLabel, fill = selectedColor},
        {target = sampledColor, fill = selectedColor},
        {target = sampledLabel, fill = selectedColor},
    }, duration, linear, 0)
    previousDegrees, previousPoint = degrees, point
end

scene:wait(0.65)
for degrees = 120, 180, 10 do moveToDegrees(degrees, 0.11) end
scene:wait(0.35)

local currentT = wrap(previousDegrees / 360)
local proxy = content:point {
    id = "sample-to-index-proxy",
    point = previousPoint,
    radius = 8,
    fill = tableColor(currentT),
    stroke = "surface",
    width = 2,
    layer = L.arrow,
}
scene:shift(proxy, {selectorX(currentT) - previousPoint[1], tableY - previousPoint[2]}, 0.80, gentle)
scene:indicate(selector, {scale = 1.05, duration = 0.40, curve = gentle})
scene:remove(proxy)
scene:wait(0.75)

-- Ray, selector, and swatch stay synchronized through the seam wrap.
for degrees = 190, 350, 10 do moveToDegrees(degrees, 0.105) end
scene:wait(0.65)

local nearDegrees = 359
moveToDegrees(nearDegrees, 0.35)
scene:wait(0.55)

local wrappedDegrees = 375
local wrappedT = 15 / 360
local wrappedPoint = pointAt(wrappedDegrees)
local wrappedColor = tableColor(wrappedT)
scene:play({
    {
        target = sampleDot,
        shift = {wrappedPoint[1] - previousPoint[1], wrappedPoint[2] - previousPoint[2]},
        fill = wrappedColor,
    },
    {target = sampleRay, stroke = wrappedColor},
    {target = selectorState, shift = {selectorX(wrappedT) - selectorX(wrap(previousDegrees / 360)), 0}},
    {target = selector, stroke = wrappedColor},
    {target = selectorLabel, fill = wrappedColor},
    {target = sampledColor, fill = wrappedColor},
    {target = sampledLabel, fill = wrappedColor},
    {target = wrapState, opacity = 1},
}, 0.70, change, 0)
previousDegrees, previousPoint = wrappedDegrees, wrappedPoint
scene:wait(1.30)
scene:indicate(sampledColor, {scale = 1.04, duration = 0.45, curve = gentle})
scene:wait(0.70)

-- Return to the same complete 110-degree pose, never to a blank frame.
for degrees = 385, 465, 10 do
    moveToDegrees(degrees, 0.085)
    if degrees == 385 then
        scene:play({
            {target = wrapState, opacity = 0},
        }, 0.30, enter, 0)
    end
end
scene:play({
    {
        target = sampleDot,
        transform = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        },
        fill = tableColor(initialT),
    },
    {target = sampleRay, stroke = tableColor(initialT)},
    {
        target = selectorState,
        transform = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        },
    },
    {target = selector, stroke = tableColor(initialT)},
    {target = selectorLabel, fill = tableColor(initialT)},
    {target = sampledColor, fill = tableColor(initialT)},
    {target = sampledLabel, fill = tableColor(initialT)},
}, 0.08, linear, 0)
scene:wait(12.00 - scene:duration())

return scene
