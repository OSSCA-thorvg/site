-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill.conicAARangeGatesAppendix.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, band = 12, mark = 20, arrow = 30, text = 40}
local transparent = "#00000000"
local C = {
    pixel = "info", normal = "success", seam = "warning",
    rejected = "danger", kept = "result", focus = "focus",
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
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["normal-conclusion"]=true,["seam-conclusion"]=true,["final-conclusion"]=true,["row-title"]=true,["normal-title"]=true,["seam-title"]=true,["intersection-title"]=true}
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

local function displayRange(beginIndex, endIndex)
    return "[" .. beginIndex .. "," .. endIndex .. ")"
end

local normal = {0, 1}
local seam = {normal[2], -normal[1]}
local q0 = {-1.15, -0.54}
local xStep = {0.40, 0.18}
local yStep = {0.15, 0.57}
local len = 8

local dFdx = dot(normal, xStep)
local dFdy = dot(normal, yStep)
local fwidth = math.abs(dFdx) + math.abs(dFdy)
local invFwidth = 1 / fwidth
local distance = dot(normal, q0) * invFwidth
local distanceDx = dFdx * invFwidth
local seamProjection = dot(q0, seam)
local seamProjectionDx = dot(seam, xStep)

local normalBegin = 0
local normalEnd = len
local first = 0
local last = 0
if math.abs(distanceDx) < 0.00001 then
    if distance <= -0.5 or distance >= 0.5 then normalEnd = 0 end
else
    first = (-0.5 - distance) / distanceDx
    last = (0.5 - distance) / distanceDx
    if first > last then first, last = last, first end
    normalBegin = maximum(normalBegin, math.floor(first) + 1)
    normalEnd = minimum(normalEnd, math.ceil(last))
end

local seamBegin = 0
local seamEnd = len
if math.abs(seamProjectionDx) < 0.00001 then
    if seamProjection < 0 then seamEnd = 0 end
elseif seamProjectionDx > 0 then
    seamBegin = maximum(seamBegin, math.ceil(-seamProjection / seamProjectionDx))
else
    seamEnd = minimum(seamEnd, math.floor(-seamProjection / seamProjectionDx) + 1)
end

local finalBegin = normalBegin
local finalEnd = normalEnd
if math.abs(seamProjectionDx) < 0.00001 then
    if seamProjection < 0 then finalEnd = 0 end
elseif seamProjectionDx > 0 then
    finalBegin = maximum(finalBegin, math.ceil(-seamProjection / seamProjectionDx))
else
    finalEnd = minimum(finalEnd, math.floor(-seamProjection / seamProjectionDx) + 1)
end

local samples = {}
for index = 0, len - 1 do
    local q = added(q0, scaled(xStep, index))
    local d = dot(normal, q) * invFwidth
    local p = dot(q, seam)
    samples[index + 1] = {
        index = index,
        q = q,
        distance = d,
        projection = p,
        normalInside = d > -0.5 and d < 0.5,
        seamInside = p >= 0,
        finalInside = d > -0.5 and d < 0.5 and p >= 0,
    }
end

local rangeDistance = distance + finalBegin * distanceDx
local summaryIndex = finalBegin

txt(scene, "title", "Appendix C · two gates make one finite seam range", -4.30, 5.82, "h2")
txt(scene, "subtitle", "One q0 and two cached row deltas solve every pixel before the fill loop begins.", -4.30, 5.45, "text")
rule("header-rule", 5.12)

txt(scene, "row-title", "ROW INPUT · RECONSTRUCTED FROM THE REAL LOOP", -4.30, 4.82, "h3")
txt(scene, "row-recurrence", "q_i=(rx_i,ry_i)=q0+i·xStep   ·   q0=(-1.15,-.54)", -4.12, 4.43, "code", nil, C.pixel)
txt(scene, "row-step", "xStep=(a11,a21)=(.40,.18)", 4.12, 4.43, "code", {1, 0.5}, C.pixel)
txt(scene, "row-loop", "fillConic loop:  rx += a11;  ry += a21", 0, 4.05, "code", {0.5, 0.5}, "muted")

local rowLeft = -3.85
local rowStep = 1.10
local rowY = 3.55
local function rowX(index)
    return rowLeft + index * rowStep
end

scene:line {
    id = "row-track", from = {rowX(0), rowY}, to = {rowX(len - 1), rowY},
    stroke = "border", width = 1.6, layer = L.guide,
}
for index = 0, len - 1 do
    scene:point {
        id = "row-sample-" .. index, point = {rowX(index), rowY}, radius = 5,
        fill = C.pixel, stroke = "surface", width = 1.4, layer = L.mark,
    }
    txt(scene, "row-index-" .. index, "i" .. index, rowX(index), 3.27, "code", {0.5, 0.5})
end

local rowCursor = scene:group {
    id = "row-cursor-owner", matrix = translateMatrix(rowX(summaryIndex), rowY),
}
rowCursor:circle {
    id = "row-cursor", center = {0, 0}, radius = 0.20,
    fill = transparent, stroke = C.focus, width = 2.4, layer = L.arrow,
}

scene:route {
    id = "row-to-normal", points = {{-0.08, 3.19}, {-1.30, 2.98}, {-2.20, 2.82}},
    stroke = C.normal, width = 1.4, tip = 7, opacity = 0.55, layer = L.guide,
}
scene:route {
    id = "row-to-seam", points = {{0.08, 3.19}, {1.30, 2.98}, {2.20, 2.82}},
    stroke = C.seam, width = 1.4, tip = 7, opacity = 0.55, layer = L.guide,
}

scene:line {
    id = "panel-divider", from = {0, 2.86}, to = {0, -0.86},
    stroke = "border", width = 1.0, layer = L.guide,
}

txt(scene, "normal-title", "1 · NORMAL DISTANCE", -4.28, 2.76, "h3")
txt(scene, "normal-formula", "D_i=dot(normal,q_i)·invFwidth", -4.12, 2.39, "code", nil, C.normal)
txt(scene, "normal-values", "D_i=" .. displayNumber(distance) .. "+i·" .. displayNumber(distanceDx), -4.12, 2.05, "code", nil, C.normal)

txt(scene, "seam-title", "2 · SEAM PROJECTION", 0.28, 2.76, "h3")
txt(scene, "seam-formula", "P_i=dot(q_i,seam)", 0.44, 2.39, "code", nil, C.seam)
txt(scene, "seam-values", "P_i=" .. displayNumber(seamProjection) .. "+i·" .. displayNumber(seamProjectionDx), 0.44, 2.05, "code", nil, C.seam)

local leftCenterX = -2.20
local rightCenterX = 2.20
local plotCenterY = 0.85
local plotScaleX = 0.75
local plotScaleY = 1.45
local normalAxisX = -3.78

local function leftQPoint(sample)
    return {
        leftCenterX + sample.q[1] * plotScaleX,
        plotCenterY + sample.q[2] * plotScaleY,
    }
end

local function leftProjectionPoint(sample)
    return {normalAxisX, plotCenterY + sample.q[2] * plotScaleY}
end

local function rightQPoint(sample)
    return {
        rightCenterX + sample.q[1] * plotScaleX,
        plotCenterY + sample.q[2] * plotScaleY,
    }
end

local function rightProjectionPoint(sample)
    return {rightCenterX + sample.projection * plotScaleX, plotCenterY}
end

local rawHalfWidth = 0.5 / invFwidth
scene:rectangle {
    id = "normal-band", center = {leftCenterX, plotCenterY},
    size = {3.62, rawHalfWidth * 2 * plotScaleY},
    fill = C.normal, stroke = transparent, opacity = 0.10, layer = L.base,
}
scene:line {
    id = "normal-boundary-line", from = {-4.02, plotCenterY}, to = {-0.38, plotCenterY},
    stroke = "border", width = 1.7, dash = {6, 5}, layer = L.guide,
}
scene:arrow {
    id = "normal-axis", from = {normalAxisX, -0.02}, to = {normalAxisX, 1.94},
    stroke = C.normal, width = 2.1, tip = 8, layer = L.arrow,
}
txt(scene, "normal-upper-bound", "+.5", -4.05, plotCenterY + rawHalfWidth * plotScaleY, "code", {1, 0.5}, C.normal)
txt(scene, "normal-lower-bound", "-.5", -4.05, plotCenterY - rawHalfWidth * plotScaleY, "code", {1, 0.5}, C.normal)

scene:line {
    id = "seam-back-half", from = {0.38, plotCenterY}, to = {rightCenterX, plotCenterY},
    stroke = C.rejected, width = 1.8, dash = {5, 5}, opacity = 0.55, layer = L.guide,
}
scene:arrow {
    id = "seam-forward-half", from = {rightCenterX, plotCenterY}, to = {4.04, plotCenterY},
    stroke = C.seam, width = 2.6, tip = 9, layer = L.arrow,
}
scene:point {
    id = "seam-origin", point = {rightCenterX, plotCenterY}, radius = 5,
    fill = C.seam, stroke = "surface", width = 1.5, layer = L.mark,
}

local leftPathPoints = {}
local rightPathPoints = {}
for index = 1, len do
    leftPathPoints[index] = leftQPoint(samples[index])
    rightPathPoints[index] = rightQPoint(samples[index])
end
scene:route {
    id = "normal-q-path", points = leftPathPoints,
    stroke = C.pixel, width = 1.5, opacity = 0.55, layer = L.guide,
}
scene:route {
    id = "seam-q-path", points = rightPathPoints,
    stroke = C.pixel, width = 1.5, opacity = 0.55, layer = L.guide,
}

for index = 0, len - 1 do
    local sample = samples[index + 1]
    scene:point {
        id = "normal-q-sample-" .. index, point = leftQPoint(sample), radius = 4,
        fill = sample.normalInside and C.normal or "muted",
        stroke = "surface", width = 1.2, layer = L.mark,
    }
    scene:point {
        id = "seam-q-sample-" .. index, point = rightQPoint(sample), radius = 4,
        fill = sample.seamInside and C.seam or C.rejected,
        stroke = "surface", width = 1.2, layer = L.mark,
    }
end

local normalQCursor = scene:group {
    id = "normal-q-cursor-owner", matrix = translateMatrix(
        leftQPoint(samples[summaryIndex + 1])[1], leftQPoint(samples[summaryIndex + 1])[2]),
}
normalQCursor:circle {
    id = "normal-q-cursor", center = {0, 0}, radius = 0.13,
    fill = transparent, stroke = C.focus, width = 2.2, layer = L.arrow,
}
local normalGuide = scene:group {
    id = "normal-dot-guide-owner", matrix = segmentMatrix(
        leftQPoint(samples[summaryIndex + 1]), leftProjectionPoint(samples[summaryIndex + 1])),
}
normalGuide:line {
    id = "normal-dot-guide", from = {0, 0}, to = {1, 0},
    stroke = C.normal, width = 1.5, dash = {4, 4}, layer = L.guide,
}
local normalProjectionCursor = scene:group {
    id = "normal-projection-cursor-owner", matrix = translateMatrix(
        leftProjectionPoint(samples[summaryIndex + 1])[1], leftProjectionPoint(samples[summaryIndex + 1])[2]),
}
normalProjectionCursor:point {
    id = "normal-projection-cursor", point = {0, 0}, radius = 7,
    fill = C.normal, stroke = "surface", width = 1.5, layer = L.mark,
}

local seamQCursor = scene:group {
    id = "seam-q-cursor-owner", matrix = translateMatrix(
        rightQPoint(samples[summaryIndex + 1])[1], rightQPoint(samples[summaryIndex + 1])[2]),
}
seamQCursor:circle {
    id = "seam-q-cursor", center = {0, 0}, radius = 0.13,
    fill = transparent, stroke = C.focus, width = 2.2, layer = L.arrow,
}
local seamGuide = scene:group {
    id = "seam-dot-guide-owner", matrix = segmentMatrix(
        rightQPoint(samples[summaryIndex + 1]), rightProjectionPoint(samples[summaryIndex + 1])),
}
seamGuide:line {
    id = "seam-dot-guide", from = {0, 0}, to = {1, 0},
    stroke = C.seam, width = 1.5, dash = {4, 4}, layer = L.guide,
}
local seamProjectionCursor = scene:group {
    id = "seam-projection-cursor-owner", matrix = translateMatrix(
        rightProjectionPoint(samples[summaryIndex + 1])[1], rightProjectionPoint(samples[summaryIndex + 1])[2]),
}
seamProjectionCursor:point {
    id = "seam-projection-cursor", point = {0, 0}, radius = 7,
    fill = C.seam, stroke = "surface", width = 1.5, layer = L.mark,
}

txt(scene, "normal-band-rule", "strict:  -.5 < D_i < .5", -4.12, -0.06, "code", nil, C.normal)
txt(scene, "normal-range-math",
    "first=" .. displayNumber(first) .. " · last=" .. displayNumber(last) .. " -> " .. displayRange(normalBegin, normalEnd),
    -4.12, -0.39, "code", nil, C.normal)
txt(scene, "normal-zero-note", "Ddx=0 -> test D0 once", -4.12, -0.69, "text", nil, "muted")

txt(scene, "seam-ray-rule", "forward ray:  P_i >= 0", 0.44, -0.06, "code", nil, C.seam)
txt(scene, "seam-range-math",
    "ceil(-P0/Pdx)=" .. seamBegin .. " -> " .. displayRange(seamBegin, seamEnd),
    0.44, -0.39, "code", nil, C.seam)
txt(scene, "seam-zero-note", "Pdx=0 -> test P0 once", 0.44, -0.69, "text", nil, "muted")

local normalFocus = scene:line {
    id = "normal-gate-focus", from = {-4.14, 2.20}, to = {-0.34, 2.20},
    stroke = C.normal, width = 2.2, opacity = 0, layer = L.guide,
}
local seamFocus = scene:line {
    id = "seam-gate-focus", from = {0.34, 2.20}, to = {4.14, 2.20},
    stroke = C.seam, width = 2.2, opacity = 0, layer = L.guide,
}

rule("gate-rule", -0.92)
txt(scene, "intersection-title", "INTERSECTION · BOTH TESTS MUST PASS", -4.30, -1.19, "h3")

local tableLeft = -3.25
local cellWidth = 0.90
local tableRows = {normal = -2.04, seam = -2.77, final = -3.50}
local function cellCenterX(index)
    return tableLeft + cellWidth * (index + 0.5)
end

txt(scene, "normal-row-label", "normal D", -4.20, tableRows.normal, "code", nil, C.normal)
txt(scene, "seam-row-label", "seam P", -4.20, tableRows.seam, "code", nil, C.seam)
txt(scene, "final-row-label", "AA range", -4.20, tableRows.final, "code", nil, C.kept)

local normalKeepOverlays = {}
local seamKeepOverlays = {}
local finalKeepOverlays = {}
for index = 0, len - 1 do
    local x = cellCenterX(index)
    local sample = samples[index + 1]
    txt(scene, "range-index-" .. index, "i" .. index, x, -1.55, "code", {0.5, 0.5}, C.pixel)

    scene:rectangle {
        id = "normal-range-cell-" .. index, center = {x, tableRows.normal}, size = {0.86, 0.54},
        fill = "surface", stroke = "border", width = 1.0, layer = L.base,
    }
    scene:rectangle {
        id = "seam-range-cell-" .. index, center = {x, tableRows.seam}, size = {0.86, 0.54},
        fill = "surface", stroke = "border", width = 1.0, layer = L.base,
    }
    scene:rectangle {
        id = "final-range-cell-" .. index, center = {x, tableRows.final}, size = {0.86, 0.54},
        fill = "surface", stroke = "border", width = 1.0, layer = L.base,
    }

    normalKeepOverlays[index + 1] = scene:rectangle {
        id = "normal-keep-cell-" .. index, center = {x, tableRows.normal}, size = {0.86, 0.54},
        fill = C.normal, stroke = transparent,
        opacity = sample.normalInside and 0.22 or 0, layer = L.band,
    }
    seamKeepOverlays[index + 1] = scene:rectangle {
        id = "seam-keep-cell-" .. index, center = {x, tableRows.seam}, size = {0.86, 0.54},
        fill = C.seam, stroke = transparent,
        opacity = sample.seamInside and 0.22 or 0, layer = L.band,
    }
    finalKeepOverlays[index + 1] = scene:rectangle {
        id = "final-keep-cell-" .. index, center = {x, tableRows.final}, size = {0.86, 0.54},
        fill = C.kept, stroke = transparent,
        opacity = sample.finalInside and 0.26 or 0, layer = L.band,
    }

    txt(scene, "normal-range-value-" .. index, displayNumber(sample.distance),
        x, tableRows.normal, "code", {0.5, 0.5})
    txt(scene, "seam-range-value-" .. index, displayNumber(sample.projection),
        x, tableRows.seam, "code", {0.5, 0.5})
    txt(scene, "final-range-value-" .. index, sample.finalInside and "AA" or "NO",
        x, tableRows.final, "code", {0.5, 0.5}, sample.finalInside and C.kept or "muted")
end

local function rangeWindow(id, beginIndex, endIndex, y, color)
    local width = (endIndex - beginIndex) * cellWidth
    return scene:rectangle {
        id = id,
        center = {tableLeft + beginIndex * cellWidth + width * 0.5, y},
        size = {width, 0.62}, fill = transparent, stroke = color,
        width = 2.2, layer = L.mark,
    }
end

local normalWindow = rangeWindow("normal-range-window", normalBegin, normalEnd, tableRows.normal, C.normal)
local seamWindow = rangeWindow("seam-range-window", seamBegin, seamEnd, tableRows.seam, C.seam)
local finalWindow = rangeWindow("final-range-window", finalBegin, finalEnd, tableRows.final, C.kept)

local columnCursor = scene:group {
    id = "range-column-cursor-owner", matrix = translateMatrix(cellCenterX(summaryIndex), 0), opacity = 0,
}
columnCursor:rectangle {
    id = "range-column-cursor", center = {0, -2.77}, size = {0.91, 2.33},
    fill = transparent, stroke = C.focus, width = 2.1, layer = L.arrow,
}

local criticalFocus = scene:group {
    id = "critical-column-focus-owner", matrix = translateMatrix(cellCenterX(2), 0), opacity = 0,
}
criticalFocus:rectangle {
    id = "critical-column-focus", center = {0, -2.405}, size = {0.91, 1.34},
    fill = transparent, stroke = C.rejected, width = 2.4, layer = L.arrow,
}

txt(scene, "critical-normal", "i2: D=-.24 is inside", -4.12, -4.03, "code", nil, C.normal)
txt(scene, "critical-seam", "i2: P=-.35 is behind", 4.12, -4.03, "code", {1, 0.5}, C.rejected)
txt(scene, "intersection-indices",
    "begin=max(" .. normalBegin .. "," .. seamBegin .. ")=" .. finalBegin
        .. "   ·   end=min(" .. normalEnd .. "," .. seamEnd .. ")=" .. finalEnd,
    0, -4.42, "code", {0.5, 0.5}, C.kept)
txt(scene, "range-distance",
    "range=" .. displayRange(finalBegin, finalEnd)
        .. "   ·   range.distance=" .. displayNumber(distance) .. "+" .. finalBegin
        .. "·" .. displayNumber(distanceDx) .. "=" .. displayNumber(rangeDistance),
    0, -4.81, "code", {0.5, 0.5}, C.kept)
txt(scene, "normal-conclusion", "normal gate -> one-pixel thickness", -4.12, -5.20, "text", nil, C.normal)
txt(scene, "seam-conclusion", "seam gate -> forward direction", 4.12, -5.20, "text", {1, 0.5}, C.seam)
txt(scene, "final-conclusion", "intersection -> finite seam segment " .. displayRange(finalBegin, finalEnd),
    0, -5.59, "text", {0.5, 0.5}, C.kept)
local intersectionFocus = scene:line {
    id = "intersection-focus", from = {-2.02, -5.78}, to = {2.02, -5.78},
    stroke = C.kept, width = 2.5, opacity = 1, layer = L.guide,
}

local gentle = {preset = "gentle", strength = 0.86}
local reverseGentle = {preset = "gentle", strength = 0.86, reverse = true}

local function cursorTargets(index, columnOpacity)
    local sample = samples[index + 1]
    local leftQ = leftQPoint(sample)
    local leftP = leftProjectionPoint(sample)
    local rightQ = rightQPoint(sample)
    local rightP = rightProjectionPoint(sample)
    return {
        {target = rowCursor, transform = translateMatrix(rowX(index), rowY)},
        {target = normalQCursor, transform = translateMatrix(leftQ[1], leftQ[2])},
        {target = normalGuide, transform = segmentMatrix(leftQ, leftP)},
        {target = normalProjectionCursor, transform = translateMatrix(leftP[1], leftP[2])},
        {target = seamQCursor, transform = translateMatrix(rightQ[1], rightQ[2])},
        {target = seamGuide, transform = segmentMatrix(rightQ, rightP)},
        {target = seamProjectionCursor, transform = translateMatrix(rightP[1], rightP[2])},
        {
            target = columnCursor,
            transform = translateMatrix(cellCenterX(index), 0),
            opacity = columnOpacity,
        },
    }
end

scene:wait(0.45)
local resetTargets = cursorTargets(0, 1)
resetTargets[#resetTargets + 1] = {target = normalFocus, opacity = 1}
resetTargets[#resetTargets + 1] = {target = seamFocus, opacity = 1}
resetTargets[#resetTargets + 1] = {target = intersectionFocus, opacity = 0}
resetTargets[#resetTargets + 1] = {target = normalWindow, opacity = 0}
resetTargets[#resetTargets + 1] = {target = seamWindow, opacity = 0}
resetTargets[#resetTargets + 1] = {target = finalWindow, opacity = 0}
for index = 1, len do
    resetTargets[#resetTargets + 1] = {target = normalKeepOverlays[index], opacity = 0}
    resetTargets[#resetTargets + 1] = {target = seamKeepOverlays[index], opacity = 0}
    resetTargets[#resetTargets + 1] = {target = finalKeepOverlays[index], opacity = 0}
end
scene:play(resetTargets, 0.45, gentle, 0)
scene:wait(0.25)

for index = 1, len - 1 do
    local sample = samples[index + 1]
    local targets = cursorTargets(index)
    if sample.normalInside then
        targets[#targets + 1] = {target = normalKeepOverlays[index + 1], opacity = 0.22}
    end
    if sample.seamInside then
        targets[#targets + 1] = {target = seamKeepOverlays[index + 1], opacity = 0.22}
    end
    scene:play(targets, 0.42, gentle, 0)
    if index == 1 then scene:wait(0.18) end
    if index == 3 then scene:wait(0.28) end
    if index == 6 then scene:wait(0.18) end
end

scene:play({
    {target = normalWindow, opacity = 1},
    {target = seamWindow, opacity = 1},
}, 0.55, reverseGentle, 0)
scene:wait(0.40)

local criticalTargets = cursorTargets(2, 0)
criticalTargets[#criticalTargets + 1] = {target = criticalFocus, opacity = 1}
scene:play(criticalTargets, 0.55, gentle, 0)
scene:wait(0.65)

local finalTargets = {}
for index = finalBegin, finalEnd - 1 do
    finalTargets[#finalTargets + 1] = {target = finalKeepOverlays[index + 1], opacity = 0.26}
end
scene:play(finalTargets, 0.50, reverseGentle, 0.10)
scene:play({
    {target = finalWindow, opacity = 1},
    {target = criticalFocus, opacity = 0},
    {target = normalFocus, opacity = 0},
    {target = seamFocus, opacity = 0},
    {target = intersectionFocus, opacity = 1},
}, 0.45, reverseGentle, 0)
scene:wait(0.60)

local restoreTargets = cursorTargets(summaryIndex, 0)
restoreTargets[#restoreTargets + 1] = {target = criticalFocus, opacity = 0}
scene:play(restoreTargets, 0.55, reverseGentle, 0)
scene:wait(12.00 - scene:duration())

return scene
