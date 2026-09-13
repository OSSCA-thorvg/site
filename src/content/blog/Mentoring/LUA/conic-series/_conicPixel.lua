-- Adapted from .vscode/tmath/conic-sw-fill/animations/tvgSwFill._conicPixel.lua
-- Only title/prose visibility differs. Geometry and timeline are upstream originals.
-- Export framing and optional final hold: manifest.json.
local L = {base = 0, guide = 5, band = 12, focus = 18, mark = 20, arrow = 30, text = 40}
local transparent = "#00000000"
local C = {
    neutral = "foreground",
    sample = "secondary",
    seam = "danger",
    normal = "success",
    fwidth = "warning",
}
local vscodeTheme = {
    preset = "adaptive_vscode",
}

local scene = tmath.scene {
    width = 720, height = 1280, fps = 30, loop = true,
    theme = vscodeTheme,
    camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 12.8},
}

local function txt(parent, id, value, x, y, role, align, fill)

    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.
    local blogHidden = {["title"]=true,["subtitle"]=true,["hook"]=true,["surface-caption"]=true,["math-caption"]=true,["band-caption"]=true,["color-caption"]=true,["surface-title"]=true,["math-title"]=true,["band-title"]=true,["color-title"]=true,["ordinary-title"]=true,["inside-title"]=true}
    if blogHidden[id] then value = "" end
    local config = {
        id = id, text = value, point = {x, y}, role = role,
        align = align or {0, 0.5}, layer = L.text,
    }
    if fill then config.fill = fill end
    return parent:text(config)
end

local function rule(id, y)
    return scene:line {
        id = id, from = {-3.05, y}, to = {3.05, y},
        stroke = "border", width = 1.1, layer = L.guide,
    }
end

local function affine(x, y)
    return {
        1, 0, 0, x,
        0, 1, 0, y,
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
    local u = span == 0 and 0 or (value - left.offset) / span
    local rgb = {}
    for i = 1, 3 do
        rgb[i] = math.floor(left.rgb[i] + (right.rgb[i] - left.rgb[i]) * u + 0.5)
    end
    return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
end

local function parseColor(value)
    return {
        tonumber(string.sub(value, 2, 3), 16),
        tonumber(string.sub(value, 4, 5), 16),
        tonumber(string.sub(value, 6, 7), 16),
    }
end

local function mixColor(first, second, amount)
    local a, b = parseColor(first), parseColor(second)
    local rgb = {}
    for i = 1, 3 do
        rgb[i] = math.floor(a[i] + (b[i] - a[i]) * amount + 0.5)
    end
    return string.format("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
end

local function wrap(t)
    return t - math.floor(t)
end

txt(scene, "title", "Conic seam AA · full surface fill", -3.05, 5.82, "h2")
txt(scene, "subtitle", "Only the first pixel of each case opens the full pipeline.", -3.05, 5.43, "text")
rule("header-rule", 5.08)

txt(scene, "surface-title", "FULL SURFACE · 48 PIXELS", -3.05, 4.80, "h3")
txt(scene, "surface-caption", "first NORMAL / AA / NO AA stops · repeated cases run fast", -3.05, 4.47, "text")

-- Maintained A04 geometry: angle=-.31 rad, strict normalized band, forward ray.
local angle = -0.31
local seam = {math.cos(angle), math.sin(angle)}
local normal = {-seam[2], seam[1]}
local fwidth = math.abs(normal[1]) + math.abs(normal[2])
local lastColor = tableColor(1)
local firstColor = tableColor(0)
local columns, rows = 8, 6
local cell = 0.55
local gridLeft = -0.5 * (columns - 1) * cell
local gridTop = 4.08
local outputCells, rowOutlines, rangeOverlays, rangeFocuses, rangeStatusMarks = {}, {}, {}, {}, {}
local rowData = {}
local surfaceContext = scene:group {id = "surface-context"}

for row = 0, rows - 1 do
    local iy = row - 2
    local y = gridTop - row * cell
    local accepted = {}
    rowData[row + 1] = {y = y, iy = iy, cells = {}}
    for column = 0, columns - 1 do
        local ix = column - 4
        local x = gridLeft + column * cell
        local q = ix * seam[1] + iy * seam[2]
        local distance = (ix * normal[1] + iy * normal[2]) / fwidth
        local t = wrap((math.atan(iy, ix) - angle) / (2 * math.pi))
        local tableIndex = math.floor(t * 1023 + 0.5)
        local color = tableColor(tableIndex / 1023)
        local inBand = distance > -0.5 and distance < 0.5
        local kind = not inBand and "normal" or (q >= 0 and "aa" or "no-aa")
        local inside = kind == "aa"
        if inside then
            accepted[#accepted + 1] = column
            color = mixColor(lastColor, firstColor, distance + 0.5)
        end
        surfaceContext:rectangle {
            id = "surface-base-" .. row .. "-" .. column,
            center = {x, y}, size = {cell * 0.92, cell * 0.92}, corner = 0.028,
            fill = "surface", stroke = "border", width = 1.0, layer = L.base,
        }
        local output = surfaceContext:rectangle {
            id = "surface-output-" .. row .. "-" .. column,
            center = {x, y}, size = {cell * 0.92, cell * 0.92}, corner = 0.028,
            fill = color, stroke = "surface", width = 1.0, opacity = 0, layer = L.mark,
        }
        outputCells[#outputCells + 1] = output
        rowData[row + 1].cells[column + 1] = {
            x = x, y = y, ix = ix, iy = iy, distance = distance,
            inside = inside, kind = kind, color = color, tableIndex = tableIndex, output = output,
        }
    end

    local beginIndex = #accepted > 0 and accepted[1] or 0
    local endIndex = #accepted > 0 and accepted[#accepted] + 1 or 0
    rowData[row + 1].beginIndex = beginIndex
    rowData[row + 1].endIndex = endIndex
    rowData[row + 1].hasRange = #accepted > 0

    rowOutlines[row + 1] = surfaceContext:rectangle {
        id = "row-outline-" .. row,
        center = {0, y}, size = {columns * cell + 0.10, cell + 0.08}, corner = 0.035,
        fill = transparent, stroke = "accent", width = 2.2, opacity = 0, layer = L.arrow,
    }

    if #accepted > 0 then
        local firstX = gridLeft + beginIndex * cell
        local lastX = gridLeft + (endIndex - 1) * cell
        local rangeCenter = 0.5 * (firstX + lastX)
        local rangeWidth = (endIndex - beginIndex) * cell + 0.04
        rangeOverlays[row + 1] = surfaceContext:rectangle {
            id = "aa-range-" .. row, center = {rangeCenter, y},
            size = {rangeWidth, cell + 0.04}, corner = 0.035,
            fill = "success", stroke = "success", width = 1.7, opacity = 0.08, layer = L.band,
        }
        rangeFocuses[row + 1] = scene:rectangle {
            id = "aa-range-focus-" .. row, center = {rangeCenter, y},
            size = {rangeWidth + 0.13, cell + 0.13}, corner = 0.05,
            fill = transparent, stroke = "foreground", width = 3.2, opacity = 0, layer = L.arrow,
        }
    else
        rangeOverlays[row + 1] = surfaceContext:line {
            id = "empty-range-" .. row,
            from = {2.23, y}, to = {2.39, y},
            stroke = "muted", width = 2.0, opacity = 0.08, layer = L.band,
        }
    end

    txt(surfaceContext, "surface-row-label-" .. row, "y" .. row, -2.48, y, "code", {1, 0.5})
    local status = #accepted > 0 and ("[" .. beginIndex .. "," .. endIndex .. ")") or "empty"
    txt(surfaceContext, "range-status-label-" .. row, status, 2.50, y, "code")
    rangeStatusMarks[row + 1] = surfaceContext:rectangle {
        id = "range-status-mark-" .. row, center = {2.39, y}, size = {0.07, 0.22},
        fill = #accepted > 0 and "success" or "muted",
        stroke = transparent, opacity = 0.12, layer = L.mark,
    }
end

local originX = gridLeft + 4 * cell
local originY = gridTop - 2 * cell
local displaySeam = {seam[1], -seam[2]}
local displayNormal = {normal[1], -normal[2]}
local halfBand = 0.5 * fwidth * cell
local bandExtent = 2.22
for _, sign in ipairs({-1, 1}) do
    surfaceContext:line {
        id = sign < 0 and "lower-band-boundary" or "upper-band-boundary",
        from = {
            originX + displayNormal[1] * halfBand * sign - displaySeam[1] * bandExtent,
            originY + displayNormal[2] * halfBand * sign - displaySeam[2] * bandExtent,
        },
        to = {
            originX + displayNormal[1] * halfBand * sign + displaySeam[1] * bandExtent,
            originY + displayNormal[2] * halfBand * sign + displaySeam[2] * bandExtent,
        },
        stroke = "warning", width = 1.4, dash = {6, 4}, opacity = 0.72, layer = L.band,
    }
end
surfaceContext:arrow {
    id = "forward-seam", from = {originX, originY},
    to = {originX + displaySeam[1] * bandExtent, originY + displaySeam[2] * bandExtent},
    stroke = C.seam, width = 2.4, tip = 10, layer = L.arrow,
}
surfaceContext:point {
    id = "surface-origin", point = {originX, originY}, radius = 5,
    fill = "foreground", stroke = "surface", width = 1.7, layer = L.mark,
}
local cursor = scene:group {
    id = "surface-pixel-cursor",
    matrix = affine(rowData[1].cells[1].x, rowData[1].cells[1].y), opacity = 0,
}
cursor:rectangle {
    id = "surface-pixel-cursor-box", center = {0, 0},
    size = {cell + 0.08, cell + 0.08}, corner = 0.035,
    fill = transparent, stroke = "foreground", width = 2.5, layer = L.arrow,
}
local surfaceFocus = scene:group {
    id = "surface-case-focus",
    matrix = affine(rowData[1].cells[1].x, rowData[1].cells[1].y), opacity = 0,
}
local surfaceFocusEcho = surfaceFocus:rectangle {
    id = "surface-focus-echo", center = {0, 0},
    size = {cell * 0.92, cell * 0.92}, corner = 0.028,
    fill = "surface", stroke = "surface", width = 1.0, layer = L.mark,
}

rule("surface-rule", 0.98)
txt(scene, "math-title", "FROM SURFACE PIXEL TO SEAM TEST", -3.05, 0.70, "h3")
txt(scene, "math-caption", "Same sample; M^-1 changes q_s coordinates into q_g.", -3.05, 0.36, "text")

local function caseLabel(id, value, color)
    return scene:text {
        id = id, text = value, point = {3.00, 0.70}, role = "code",
        align = {1, 0.5}, fill = color, opacity = 0, layer = L.text,
    }
end
local caseLabels = {
    normal = caseLabel("case-normal-label", "NORMAL", "accent"),
    aa = caseLabel("case-aa-label", "AA", "success"),
    ["no-aa"] = caseLabel("case-no-aa-label", "NO AA", "warning"),
}

local surfaceMatrix = basisMatrix({0.54, 0}, {0, 0.54}, -2.55, -0.35)
local gradientMatrix = basisMatrix({0.58, -0.15}, {0.18, 0.46}, -0.45, -0.35)
local surfaceSpace = scene:space {
    id = "focus-surface-space", x = {-1, 1, 1}, y = {-1, 1, 1}, numbers = false,
    matrix = surfaceMatrix,
}
surfaceSpace:rectangle {
    id = "focus-surface-pixel", center = {0, 0}, size = {1, 1},
    fill = "info", stroke = "info", width = 2.0, opacity = 0.18, layer = L.base,
}
local surfaceSampleTarget = surfaceSpace:group {id = "surface-sample-focus-target"}
surfaceSampleTarget:point {
    id = "focus-surface-sample", point = {0, 0}, radius = 5,
    fill = C.sample, stroke = "surface", width = 1.5, layer = L.mark,
}
txt(scene, "surface-space-label", "q_s · sample", -2.55, -0.85, "code", {0.5, 0.5}, C.sample)
scene:arrow {
    id = "inverse-map-arrow", from = {-2.10, -0.35}, to = {-1.20, -0.35},
    stroke = "foreground", width = 1.8, tip = 8, layer = L.arrow,
}
txt(scene, "inverse-map-label", "M^-1", -1.65, -0.08, "code", {0.5, 0.5})

local gradientSpace = scene:space {
    id = "focus-gradient-space", x = {-1, 1, 1}, y = {-1, 1, 1}, numbers = false,
    matrix = gradientMatrix,
}
local gradientFootprintTarget = gradientSpace:group {id = "gradient-footprint-focus-target"}
gradientFootprintTarget:rectangle {
    id = "focus-gradient-footprint", center = {0, 0}, size = {1, 1},
    fill = "info", stroke = "accent", width = 2.0, opacity = 0.18, layer = L.base,
}
gradientFootprintTarget:line {
    id = "focus-gradient-q-vector", from = {0, 0}, to = {0.52, 0.20},
    stroke = "border", width = 1.5, dash = {5, 4}, layer = L.guide,
}
gradientFootprintTarget:point {
    id = "focus-gradient-q", point = {0.52, 0.20}, radius = 5,
    fill = C.sample, stroke = "surface", width = 1.5, layer = L.mark,
}
txt(scene, "gradient-space-label", "q_g · same sample", -0.45, -0.85, "code", {0.5, 0.5}, C.sample)

local function focusMatrix(width, height, x, y)
    return basisMatrix({width, 0}, {0, height}, x, y)
end

-- Union of renderer family bounds in the dark and light VS Code palettes, converted
-- back to world units. The review audit re-measures these semantic target Groups.
local focusPadding = 0.09
local focusBounds = {
    surfacePixel = {x = 0, y = 0, width = 0.516, height = 0.516},
    surfaceSample = {x = -2.55, y = -0.35, width = 0.115, height = 0.115},
    gradientFootprint = {x = -0.45, y = -0.35, width = 0.780, height = 0.630},
    carrier = {x = 0, y = 0, width = 0.312, height = 0.312},
    source = {x = 0.36, y = -4.92477, width = 0.577, height = 0.76654},
    destination = {x = 2.03, y = -4.91977, width = 0.637, height = 0.77654},
    probe = {
        normal = {x = -2.42, y = -2.286, width = 0.136, height = 0.308},
        ["no-aa"] = {x = -2.42, y = -2.611, width = 0.136, height = 0.198},
        aa = {x = -0.72, y = -2.789, width = 0.136, height = 0.198},
    },
    condition = {
        normal = {x = 1.59, y = -2.18, width = 2.83, height = 0.29},
        ["no-aa"] = {x = 1.59, y = -2.62, width = 2.83, height = 0.29},
        aa = {x = 1.59, y = -3.06, width = 2.83, height = 0.29},
    },
    branch = {
        normal = {x = -0.975, y = -4.53, width = 1.60, height = 0.41},
        ["no-aa"] = {x = -0.975, y = -4.53, width = 1.60, height = 0.41},
        aa = {x = -1.37811, y = -5.14, width = 2.18922, height = 0.58},
    },
}

local function focusFromBounds(bounds, x, y)
    return focusMatrix(
        bounds.width + 2 * focusPadding,
        bounds.height + 2 * focusPadding,
        x or bounds.x,
        y or bounds.y
    )
end

local function carrierFocus(x, y)
    return focusFromBounds(focusBounds.carrier, x, y)
end

-- One persistent focus outline carries the selected pixel through every section.
local pipelineFocus = scene:group {
    id = "pipeline-focus",
    matrix = focusFromBounds(focusBounds.surfacePixel, rowData[1].cells[1].x, rowData[1].cells[1].y),
    opacity = 0,
}
pipelineFocus:rectangle {
    id = "pipeline-focus-outline", center = {0, 0}, size = {1, 1}, corner = 0.10,
    fill = transparent, stroke = "foreground", width = 3.2, layer = L.focus,
}

local normalDistanceText = scene:group {id = "normal-distance"}
txt(normalDistanceText, "normal-distance-prefix", "d = dot(", 0.62, -0.16, "code", nil, C.neutral)
txt(normalDistanceText, "normal-distance-n", "n", 1.30, -0.16, "code", nil, C.normal)
txt(normalDistanceText, "normal-distance-comma", ",", 1.42, -0.16, "code", nil, C.neutral)
txt(normalDistanceText, "normal-distance-qg", "q_g", 1.53, -0.16, "code", nil, C.sample)
txt(normalDistanceText, "normal-distance-divide", ") /", 1.90, -0.16, "code", nil, C.neutral)
txt(normalDistanceText, "normal-distance-fwidth", "fwidth", 2.21, -0.16, "code", nil, C.fwidth)
local seamProjectionText = scene:group {id = "seam-projection"}
txt(seamProjectionText, "seam-projection-prefix", "p = dot(", 0.62, -0.54, "code", nil, C.neutral)
txt(seamProjectionText, "seam-projection-s", "s", 1.30, -0.54, "code", nil, C.seam)
txt(seamProjectionText, "seam-projection-comma", ",", 1.42, -0.54, "code", nil, C.neutral)
txt(seamProjectionText, "seam-projection-qg", "q_g", 1.53, -0.54, "code", nil, C.sample)
txt(seamProjectionText, "seam-projection-close", ")", 1.90, -0.54, "code", nil, C.neutral)
local seamPredicateText = txt(scene, "seam-predicate", "AA: |d| < .5 and p >= 0", 0.62, -0.92, "code")

rule("math-rule", -1.24)
txt(scene, "band-title", "THE INFINITE BAND IS NOT YET THE SEAM", -3.05, -1.52, "h3")
txt(scene, "band-caption", "s is the forward seam; n=(-s.y,s.x) is its 90° normal.", -3.05, -1.86, "text")

local frameOrigin = {-1.55, -2.70}
scene:rectangle {
    id = "infinite-band", center = {frameOrigin[1], frameOrigin[2]}, size = {2.86, 0.54},
    fill = "warning", stroke = transparent, opacity = 0.07, layer = L.band,
}
scene:rectangle {
    id = "forward-band", center = {-0.89, frameOrigin[2]}, size = {1.32, 0.54},
    fill = "success", stroke = transparent, opacity = 0.09, layer = L.band,
}
for _, sign in ipairs({-1, 1}) do
    scene:line {
        id = sign < 0 and "frame-band-lower" or "frame-band-upper",
        from = {-2.98, frameOrigin[2] + sign * 0.27},
        to = {-0.12, frameOrigin[2] + sign * 0.27},
        stroke = "warning", width = 1.5, dash = {6, 4}, layer = L.band,
    }
end
scene:arrow {
    id = "frame-seam-vector", from = frameOrigin, to = {-0.18, frameOrigin[2]},
    stroke = C.seam, width = 2.3, tip = 9, layer = L.arrow,
}
scene:arrow {
    id = "frame-normal-vector", from = frameOrigin, to = {frameOrigin[1], -2.10},
    stroke = C.normal, width = 2.0, tip = 8, layer = L.arrow,
}
scene:point {
    id = "frame-origin", point = frameOrigin, radius = 5,
    fill = "foreground", stroke = "surface", width = 1.5, layer = L.mark,
}
txt(scene, "frame-s-label", "s · seam", -0.60, -2.52, "code", {0.5, 0.5}, C.seam)
txt(scene, "frame-n-label", "n · normal", -1.68, -2.16, "code", {1, 0.5}, C.normal)

local rejectedProbe = scene:group {id = "band-rejected-probe", matrix = affine(-2.42, -2.58), opacity = 0.28}
rejectedProbe:line {
    id = "band-rejected-normal-projection", from = {0, 0}, to = {0, -0.12},
    stroke = "danger", width = 2.0, dash = {4, 3}, layer = L.guide,
}
rejectedProbe:point {
    id = "band-rejected-point", point = {0, 0}, radius = 6,
    fill = "danger", stroke = "surface", width = 1.6, layer = L.mark,
}

local normalProbe = scene:group {id = "band-normal-probe", matrix = affine(-2.42, -2.20), opacity = 0.28}
normalProbe:line {
    id = "band-normal-projection", from = {0, 0}, to = {0, -0.23},
    stroke = "accent", width = 2.0, dash = {4, 3}, layer = L.guide,
}
normalProbe:point {
    id = "band-normal-point", point = {0, 0}, radius = 6,
    fill = "accent", stroke = "surface", width = 1.6, layer = L.mark,
}

local acceptedProbe = scene:group {id = "band-accepted-probe", matrix = affine(-0.72, -2.82), opacity = 0.28}
acceptedProbe:line {
    id = "band-accepted-normal-projection", from = {0, 0}, to = {0, 0.12},
    stroke = "success", width = 2.0, dash = {4, 3}, layer = L.guide,
}
acceptedProbe:point {
    id = "band-accepted-point", point = {0, 0}, radius = 6,
    fill = "success", stroke = "surface", width = 1.6, layer = L.mark,
}

local conditionGroups = {
    normal = scene:group {id = "normal-condition-group"},
    ["no-aa"] = scene:group {id = "no-aa-condition-group"},
    aa = scene:group {id = "aa-condition-group"},
}
local conditionHighlights = {
    normal = conditionGroups.normal:rectangle {
        id = "normal-condition-focus", center = {1.59, -2.18}, size = {2.83, 0.29},
        fill = "accent", stroke = transparent, opacity = 0.025, layer = L.base,
    },
    ["no-aa"] = conditionGroups["no-aa"]:rectangle {
        id = "no-aa-condition-focus", center = {1.59, -2.62}, size = {2.83, 0.29},
        fill = "warning", stroke = transparent, opacity = 0.025, layer = L.base,
    },
    aa = conditionGroups.aa:rectangle {
        id = "aa-condition-focus", center = {1.59, -3.06}, size = {2.83, 0.29},
        fill = "success", stroke = transparent, opacity = 0.025, layer = L.base,
    },
}
txt(conditionGroups.normal, "normal-condition", "NORMAL  |d| >= .5 -> table", 0.22, -2.18, "code")
txt(conditionGroups["no-aa"], "rejected-condition", "NO AA   |d| < .5, p < 0 -> table", 0.22, -2.62, "code")
txt(conditionGroups.aa, "accepted-condition", "AA      |d| < .5, p >= 0 -> mix", 0.22, -3.06, "code")
txt(scene, "intersection-condition", "p >= 0 keeps the forward half", 0.30, -3.48, "code")

rule("band-rule", -3.82)
txt(scene, "color-title", "COLOR FOR THE FOCUSED PIXEL", -3.05, -4.10, "h3")

local ordinaryBranch = scene:group {id = "ordinary-color-branch", opacity = 0.42}
txt(ordinaryBranch, "ordinary-title", "NORMAL", -3.00, -4.53, "h3")
local ordinaryLookupTarget = ordinaryBranch:group {id = "ordinary-lookup-focus-target"}
local tableCells = {}
local tableCellX = -1.65
local tableCellStep = 0.27
for index = 0, 5 do
    local tableCell = ordinaryLookupTarget:rectangle {
        id = "ordinary-table-cell-" .. index,
        center = {tableCellX + index * tableCellStep, -4.53}, size = {0.24, 0.32},
        fill = tableColor(index / 5), stroke = "border", width = 1.0, layer = L.base,
    }
    tableCells[index + 1] = tableCell
end
local ordinarySelector = ordinaryLookupTarget:group {
    id = "ordinary-table-selector", matrix = affine(tableCellX, -4.53), opacity = 0.35,
}
local ordinarySelectorBox = ordinarySelector:rectangle {
    id = "ordinary-table-selector-box", center = {0, 0}, size = {0.31, 0.39},
    fill = transparent, stroke = "foreground", width = 2.0, layer = L.arrow,
}

local insideBranch = scene:group {id = "inside-color-branch", opacity = 0.42}
txt(insideBranch, "inside-title", "AA", -3.00, -5.13, "h3")
local aaLookupTarget = insideBranch:group {id = "aa-lookup-focus-target"}
txt(aaLookupTarget, "last-endpoint-label", "LUT[-1]", -2.48, -4.98, "code", nil, lastColor)
txt(aaLookupTarget, "first-endpoint-label", "LUT[0]", -2.48, -5.30, "code", nil, firstColor)
aaLookupTarget:rectangle {
    id = "last-endpoint", center = {-1.15, -4.98}, size = {0.32, 0.25},
    fill = lastColor, stroke = "border", width = 1.0, layer = L.base,
}
aaLookupTarget:rectangle {
    id = "first-endpoint", center = {-1.15, -5.30}, size = {0.32, 0.25},
    fill = firstColor, stroke = "border", width = 1.0, layer = L.base,
}
aaLookupTarget:arrow {
    id = "endpoint-mix-arrow", from = {-0.91, -5.14}, to = {-0.69, -5.14},
    stroke = "foreground", width = 1.6, tip = 7, layer = L.arrow,
}
local canonicalMix = mixColor(lastColor, firstColor, 0.75)
local endpointMix = aaLookupTarget:rectangle {
    id = "endpoint-mix", center = {-0.48, -5.14}, size = {0.38, 0.36},
    fill = canonicalMix, stroke = canonicalMix, width = 1.3, layer = L.mark,
}

scene:arrow {
    id = "ordinary-to-source", from = {-0.12, -4.53}, to = {0.02, -4.76},
    stroke = "border", width = 1.5, tip = 7, layer = L.arrow,
}
scene:arrow {
    id = "inside-to-source", from = {-0.24, -5.14}, to = {0.02, -4.90},
    stroke = "border", width = 1.5, tip = 7, layer = L.arrow,
}
local sourceFocusTarget = scene:group {id = "source-focus-target"}
local sampleSwatch = sourceFocusTarget:rectangle {
    id = "sampled-source", center = {0.36, -4.83}, size = {0.56, 0.56}, corner = 0.04,
    fill = "surface", stroke = "foreground", width = 1.7, layer = L.mark,
}
local sampleSwatchLabel = txt(sourceFocusTarget, "sampled-source-label", "src", 0.36, -5.24, "code", {0.5, 0.5}, C.neutral)
local sourceToDestination = scene:arrow {
    id = "source-to-destination", from = {0.74, -4.83}, to = {1.61, -4.83},
    stroke = "foreground", width = 2.0, tip = 9, layer = L.arrow,
}
local destinationFocusTarget = scene:group {id = "destination-focus-target"}
local destinationPixel = destinationFocusTarget:rectangle {
    id = "destination-pixel", center = {2.03, -4.83}, size = {0.62, 0.58}, corner = 0.04,
    fill = "surface", stroke = "warning", width = 1.7, layer = L.mark,
}
local destinationLabel = txt(destinationFocusTarget, "destination-label", "dst", 2.03, -5.24, "code", {0.5, 0.5}, C.neutral)

local ordinaryCarrierPosition = {-0.30, -4.53}
local insideCarrierPosition = {-0.48, -5.14}
local sourcePosition = {0.36, -4.83}
local sourceCarrier = scene:group {
    id = "source-color-carrier", matrix = affine(ordinaryCarrierPosition[1], ordinaryCarrierPosition[2]), opacity = 0,
}
local sourceCarrierChip = sourceCarrier:rectangle {
    id = "source-color-carrier-chip", center = {0, 0}, size = {0.30, 0.30}, corner = 0.025,
    fill = canonicalMix, stroke = "foreground", width = 1.2, layer = L.arrow,
}
txt(scene, "color-caption", "NORMAL samples one LUT entry; AA mixes LUT[-1] and LUT[0].", -3.05, -5.70, "text")

local exact = {preset = "linear", strength = 1.0}
local gentle = {preset = "gentle", strength = 0.82}
local focusCurve = {preset = "ease_in_out", strength = 0.88}
local resetCurve = {preset = "gentle", strength = 0.82, reverse = true}

local branchFocus = {
    normal = focusFromBounds(focusBounds.branch.normal),
    ["no-aa"] = focusFromBounds(focusBounds.branch["no-aa"]),
    aa = focusFromBounds(focusBounds.branch.aa),
}
local sourceFocusMatrix = focusFromBounds(focusBounds.source)
local destinationFocusMatrix = focusFromBounds(focusBounds.destination)

local function selectorMatrix(tableIndex)
    local selected = math.floor((tableIndex / 1023) * 5 + 0.5)
    return affine(tableCellX + selected * tableCellStep, -4.53)
end

local function visitFast(pixel)
    local isAA = pixel.kind == "aa"
    scene:play({
        {target = cursor, transform = affine(pixel.x, pixel.y), opacity = 1},
        {target = pixel.output, opacity = 1},
        {target = sampleSwatch, fill = pixel.color, stroke = pixel.color},
        {target = sampleSwatchLabel, fill = pixel.color},
        {target = sourceToDestination, stroke = pixel.color},
        {target = destinationPixel, fill = pixel.color, stroke = pixel.color},
        {target = destinationLabel, fill = pixel.color},
        {target = ordinarySelector, transform = selectorMatrix(pixel.tableIndex), opacity = 0.72},
        {target = ordinarySelectorBox, stroke = pixel.color},
        {target = endpointMix, fill = isAA and pixel.color or canonicalMix, stroke = isAA and pixel.color or canonicalMix},
        {target = ordinaryBranch, opacity = isAA and 0.28 or 1},
        {target = insideBranch, opacity = isAA and 1 or 0.28},
    }, 0.075, exact, 0)
end

local function focusCase(pixel, row, kind)
    local isAA = kind == "aa"
    local isNoAA = kind == "no-aa"
    local isNormal = kind == "normal"
    local fadeTargets = {
        {target = surfaceContext, opacity = 0.22},
        {target = surfaceFocus, transform = affine(pixel.x, pixel.y), opacity = 1},
        {target = surfaceFocusEcho, fill = "surface"},
        {target = cursor, transform = affine(pixel.x, pixel.y), opacity = 1},
        {target = pipelineFocus, transform = focusFromBounds(focusBounds.surfacePixel, pixel.x, pixel.y), opacity = 1},
        {target = normalProbe, opacity = 0.12},
        {target = rejectedProbe, opacity = 0.12},
        {target = acceptedProbe, opacity = 0.12},
        {target = normalDistanceText, opacity = 0.38},
        {target = seamProjectionText, opacity = 0.38},
        {target = seamPredicateText, opacity = 0.24},
        {target = conditionGroups.normal, opacity = 0.30},
        {target = conditionGroups["no-aa"], opacity = 0.30},
        {target = conditionGroups.aa, opacity = 0.30},
        {target = conditionHighlights.normal, opacity = 0.015},
        {target = conditionHighlights["no-aa"], opacity = 0.015},
        {target = conditionHighlights.aa, opacity = 0.015},
        {target = caseLabels.normal, opacity = isNormal and 1 or 0},
        {target = caseLabels["no-aa"], opacity = isNoAA and 1 or 0},
        {target = caseLabels.aa, opacity = isAA and 1 or 0},
        {target = ordinaryBranch, opacity = 0.16},
        {target = insideBranch, opacity = 0.16},
        {target = sourceCarrier, opacity = 0},
        {target = sampleSwatch, fill = "surface", stroke = "foreground"},
        {target = sampleSwatchLabel, fill = C.neutral},
        {target = sourceToDestination, stroke = "foreground"},
        {target = destinationPixel, fill = "surface", stroke = "warning"},
        {target = destinationLabel, fill = C.neutral},
        {target = ordinarySelectorBox, stroke = "foreground"},
        {target = endpointMix, fill = canonicalMix, stroke = canonicalMix},
    }
    if isAA and rangeFocuses[row] then
        fadeTargets[#fadeTargets + 1] = {target = rangeFocuses[row], opacity = 1}
    end
    scene:play(fadeTargets, 0.50, gentle, 0)
    scene:wait(0.15)

    -- Surface sample -> point through M^-1 -> gradient-space footprint.
    local handoffTargets = {
        {target = pipelineFocus, transform = focusFromBounds(focusBounds.surfaceSample)},
        {target = cursor, opacity = 0.24},
        {target = surfaceFocus, opacity = 0.24},
    }
    if isAA and rangeFocuses[row] then
        handoffTargets[#handoffTargets + 1] = {target = rangeFocuses[row], opacity = 0.24}
    end
    scene:play(handoffTargets, 0.25, focusCurve, 0)
    scene:play({
        {target = pipelineFocus, transform = focusFromBounds(focusBounds.gradientFootprint)},
        {target = normalDistanceText, opacity = 1},
        {target = seamProjectionText, opacity = 0.40},
    }, 0.55, focusCurve, 0)
    scene:wait(0.20)

    -- The focus shrinks onto the tested probe, then opens on one predicate row.
    scene:play({
        {target = pipelineFocus, transform = focusFromBounds(focusBounds.probe[kind])},
        {target = normalProbe, opacity = isNormal and 1 or 0.12},
        {target = rejectedProbe, opacity = isNoAA and 1 or 0.12},
        {target = acceptedProbe, opacity = isAA and 1 or 0.12},
        {target = seamProjectionText, opacity = isNormal and 0.16 or 1},
        {target = seamPredicateText, opacity = isAA and 1 or (isNoAA and 0.48 or 0.16)},
    }, 0.30, focusCurve, 0)
    scene:wait(0.15)
    scene:play({
        {target = pipelineFocus, transform = focusFromBounds(focusBounds.condition[kind])},
        {target = conditionGroups.normal, opacity = isNormal and 1 or 0.16},
        {target = conditionGroups["no-aa"], opacity = isNoAA and 1 or 0.16},
        {target = conditionGroups.aa, opacity = isAA and 1 or 0.16},
        {target = conditionHighlights.normal, opacity = isNormal and 0.18 or 0.015},
        {target = conditionHighlights["no-aa"], opacity = isNoAA and 0.18 or 0.015},
        {target = conditionHighlights.aa, opacity = isAA and 0.18 or 0.015},
    }, 0.55, focusCurve, 0)
    scene:wait(0.40)

    local carrierPosition = isAA and insideCarrierPosition or ordinaryCarrierPosition
    scene:play({
        {target = pipelineFocus, transform = carrierFocus(carrierPosition[1], carrierPosition[2])},
        {target = sourceCarrier, transform = affine(carrierPosition[1], carrierPosition[2]), opacity = 1},
        {target = sourceCarrierChip, fill = pixel.color, stroke = pixel.color},
        {target = ordinarySelector, transform = selectorMatrix(pixel.tableIndex), opacity = isAA and 0.18 or 1},
        {target = ordinarySelectorBox, stroke = pixel.color},
        {target = endpointMix, fill = isAA and pixel.color or canonicalMix, stroke = isAA and pixel.color or canonicalMix},
        {target = ordinaryBranch, opacity = isAA and 0.16 or 1},
        {target = insideBranch, opacity = isAA and 1 or 0.16},
    }, 0.25, focusCurve, 0)
    scene:play({
        {target = pipelineFocus, transform = branchFocus[kind]},
    }, 0.50, focusCurve, 0)
    scene:wait(0.20)
    scene:play({
        {target = pipelineFocus, transform = sourceFocusMatrix},
        {target = sourceCarrier, transform = affine(sourcePosition[1], sourcePosition[2]), opacity = 1},
        {target = sampleSwatch, fill = pixel.color, stroke = pixel.color},
        {target = sampleSwatchLabel, fill = pixel.color},
        {target = sourceToDestination, stroke = pixel.color},
    }, 0.50, focusCurve, 0)
    scene:wait(0.20)
    scene:play({
        {target = pipelineFocus, transform = destinationFocusMatrix},
        {target = sourceCarrier, transform = affine(2.03, -4.83), opacity = 1},
        {target = destinationPixel, fill = pixel.color, stroke = pixel.color},
        {target = destinationLabel, fill = pixel.color},
        {target = surfaceFocusEcho, fill = pixel.color},
        {target = pixel.output, opacity = 1},
    }, 0.50, focusCurve, 0)
    scene:wait(0.55)

    local restoreTargets = {
        {target = surfaceContext, opacity = 1},
        {target = cursor, opacity = 1},
        {target = surfaceFocus, opacity = 0},
        {target = pipelineFocus, opacity = 0},
        {target = normalProbe, opacity = 0.28},
        {target = rejectedProbe, opacity = 0.28},
        {target = acceptedProbe, opacity = 0.28},
        {target = normalDistanceText, opacity = 1},
        {target = seamProjectionText, opacity = 1},
        {target = seamPredicateText, opacity = 1},
        {target = conditionGroups.normal, opacity = 1},
        {target = conditionGroups["no-aa"], opacity = 1},
        {target = conditionGroups.aa, opacity = 1},
        {target = conditionHighlights.normal, opacity = 0.025},
        {target = conditionHighlights["no-aa"], opacity = 0.025},
        {target = conditionHighlights.aa, opacity = 0.025},
        {target = caseLabels.normal, opacity = 0},
        {target = caseLabels["no-aa"], opacity = 0},
        {target = caseLabels.aa, opacity = 0},
        {target = ordinaryBranch, opacity = 0.42},
        {target = insideBranch, opacity = 0.42},
        {target = sourceCarrier, opacity = 0},
        {target = sampleSwatch, fill = "surface", stroke = "foreground"},
        {target = sampleSwatchLabel, fill = C.neutral},
        {target = sourceToDestination, stroke = "foreground"},
        {target = destinationPixel, fill = "surface", stroke = "warning"},
        {target = destinationLabel, fill = C.neutral},
        {target = ordinarySelectorBox, stroke = "foreground"},
        {target = endpointMix, fill = canonicalMix, stroke = canonicalMix},
        {target = sourceCarrierChip, fill = canonicalMix, stroke = "foreground"},
    }
    if isAA and rangeFocuses[row] then
        restoreTargets[#restoreTargets + 1] = {target = rangeFocuses[row], opacity = 0}
    end
    scene:play(restoreTargets, 0.45, gentle, 0)
end

scene:wait(0.65)
local taught = {normal = false, aa = false, ["no-aa"] = false}
for row = 1, rows do
    local data = rowData[row]
    scene:play({
        {target = rowOutlines[row], opacity = 1},
        {target = rangeOverlays[row], opacity = data.hasRange and 0.42 or 0.34},
        {target = rangeStatusMarks[row], opacity = 1},
        {target = cursor, transform = affine(data.cells[1].x, data.cells[1].y), opacity = 1},
    }, 0.20, gentle, 0)

    for column = 1, columns do
        local pixel = data.cells[column]
        if not taught[pixel.kind] then
            taught[pixel.kind] = true
            focusCase(pixel, row, pixel.kind)
        else
            visitFast(pixel)
        end
    end

    scene:play({
        {target = rowOutlines[row], opacity = 0.12},
        {target = rangeOverlays[row], opacity = 0.08},
        {target = rangeStatusMarks[row], opacity = 0.12},
    }, 0.12, gentle, 0)
end

local resetDuration = 0.95
local tailHold = 1.60
local hold = 30.0 - scene:duration() - resetDuration - tailHold
if hold > 0 then scene:wait(hold) end

local reset = {
    {target = surfaceContext, opacity = 1},
    {target = cursor, transform = affine(rowData[1].cells[1].x, rowData[1].cells[1].y), opacity = 0},
    {target = surfaceFocus, transform = affine(rowData[1].cells[1].x, rowData[1].cells[1].y), opacity = 0},
    {target = surfaceFocusEcho, fill = "surface"},
    {target = sampleSwatch, fill = "surface", stroke = "foreground"},
    {target = sampleSwatchLabel, fill = C.neutral},
    {target = sourceToDestination, stroke = "foreground"},
    {target = destinationPixel, fill = "surface", stroke = "warning"},
    {target = destinationLabel, fill = C.neutral},
    {target = endpointMix, fill = canonicalMix, stroke = canonicalMix},
    {target = ordinarySelector, transform = affine(tableCellX, -4.53), opacity = 0.35},
    {target = ordinarySelectorBox, stroke = "foreground"},
    {target = ordinaryBranch, opacity = 0.42},
    {target = insideBranch, opacity = 0.42},
    {target = sourceCarrier, transform = affine(ordinaryCarrierPosition[1], ordinaryCarrierPosition[2]), opacity = 0},
    {target = sourceCarrierChip, fill = canonicalMix, stroke = "foreground"},
    {target = pipelineFocus, transform = focusFromBounds(focusBounds.surfacePixel, rowData[1].cells[1].x, rowData[1].cells[1].y), opacity = 0},
    {target = normalProbe, opacity = 0.28},
    {target = rejectedProbe, opacity = 0.28},
    {target = acceptedProbe, opacity = 0.28},
    {target = normalDistanceText, opacity = 1},
    {target = seamProjectionText, opacity = 1},
    {target = seamPredicateText, opacity = 1},
    {target = conditionGroups.normal, opacity = 1},
    {target = conditionGroups["no-aa"], opacity = 1},
    {target = conditionGroups.aa, opacity = 1},
    {target = conditionHighlights.normal, opacity = 0.025},
    {target = conditionHighlights["no-aa"], opacity = 0.025},
    {target = conditionHighlights.aa, opacity = 0.025},
    {target = caseLabels.normal, opacity = 0},
    {target = caseLabels["no-aa"], opacity = 0},
    {target = caseLabels.aa, opacity = 0},
}
for _, output in ipairs(outputCells) do
    reset[#reset + 1] = {target = output, opacity = 0}
end
for row = 1, rows do
    reset[#reset + 1] = {target = rowOutlines[row], opacity = 0}
    reset[#reset + 1] = {target = rangeOverlays[row], opacity = 0.08}
    reset[#reset + 1] = {target = rangeStatusMarks[row], opacity = 0.12}
    if rangeFocuses[row] then reset[#reset + 1] = {target = rangeFocuses[row], opacity = 0} end
end
scene:play(reset, resetDuration, resetCurve, 0)
scene:wait(tailHold)

return scene
