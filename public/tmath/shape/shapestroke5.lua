-- Imported from gitpage/animations/scenes-on-thorvg/shapestroke5.lua.
-- Constant data is grouped to fit the browser Lua local-variable limit.
local importedData = {}
-- One tvg::Shape with a fill and a stroke, taken through the ThorVG CPU engine, in the order the
-- engine runs it (thorvg checkout 117901f3):
--   SwShapeTask::run                                                       tvgSwRenderer.cpp:131
--     shapeGenRle (tvgSwRenderer.cpp:142)                                  tvgSwShape.cpp:419-440
--       _genOutline: moveTo / lineTo / cubicTo -> SwOutline                tvgSwShape.cpp:348-397
--       rleRender(outline) -> shape.rle                                    tvgSwShape.cpp:438
--     shapeGenStrokeRle (tvgSwRenderer.cpp:155)                            tvgSwShape.cpp:490-511
--       strokeParseOutline(shape.outline) -> borders                       tvgSwShape.cpp:501
--       strokeExportOutline -> one outline                                 tvgSwShape.cpp:504
--       rleRender(outline) -> shape.strokeRle                              tvgSwShape.cpp:508
--   SwRenderer::renderShape: fill, then stroke (strokeFirst() is false)    tvgSwRenderer.cpp:465-472
--     rasterShape (shape.rle), rasterStroke (shape.strokeRle)              tvgSwRaster.cpp:1602, 1613
--
-- Every number below the data line was produced by ThorVG itself (thorvg checkout 117901f3):
-- a harness called shapeGenRle / shapeGenStrokeRle on this path and printed the SwSpan arrays,
-- the stroker's border writes (a copy of tvgSwStroke.cpp that prints each _borderLineTo,
-- _borderCubicTo, _borderClose and _addReverseLeft call), and the ARGB pixels that SwCanvas
-- produced for the fill alone and for fill + stroke over a #fdfcfa background.
-- The spans were checked against cov/shapestroke_decode.cpp (SVG -> SwCanvas alpha): 0 mismatches.
-- RLE_FILL / RLE_STROKE come from a copy of tvgSwRle.cpp that prints every line given to _lineTo,
-- every _recordCell (cell area / cover), and every _sweep step and _horizLine call for row RLE_ROW.
importedData.FONT = "CMUTypewriter-Regular"
local scene = tmath.scene {width = 800, height = 450, fps = 25, loop = true,
  theme = {preset = "adaptive_vscode", background = "#ffffff",
    text = {h1 = {font = importedData.FONT}, h2 = {font = importedData.FONT}, h3 = {font = importedData.FONT}, text = {font = importedData.FONT}, code = {font = importedData.FONT}}},
  camera = {mode = "fixed", view = "2d", target = {0, 0}, height = 4.5}}

-- ------------------------------------------------------------------ data (from ThorVG)
local COLS, ROWS = 24, 14
importedData.STROKE_WIDTH = 1.8
importedData.CMDS = {
  {name = "moveTo", pts = {{4.5, 12.5}}},
  {name = "lineTo", pts = {{11.5, 2.5}}},
  {name = "cubicTo", pts = {{14, 7}, {21.5, 9}, {20.5, 12.5}}},
  {name = "lineTo", pts = {{8.5, 12.5}}},
}
importedData.FILL_SPANS = {  -- {x, y, len, coverage}
  {11, 2, 1, 46}, {10, 3, 1, 56}, {11, 3, 1, 249}, {12, 3, 1, 61}, {9, 4, 1, 12}, {10, 4, 1, 220}, {11, 4, 1, 255}, {12, 4, 1, 234},
  {13, 4, 1, 46}, {9, 5, 1, 155}, {10, 5, 3, 255}, {13, 5, 1, 238}, {14, 5, 1, 64}, {8, 6, 1, 78}, {9, 6, 5, 255}, {14, 6, 1, 253},
  {15, 6, 1, 124}, {16, 6, 1, 3}, {7, 7, 1, 23}, {8, 7, 1, 234}, {9, 7, 7, 255}, {16, 7, 1, 186}, {17, 7, 1, 22}, {6, 8, 1, 1},
  {7, 8, 1, 180}, {8, 8, 9, 255}, {17, 8, 1, 229}, {18, 8, 1, 59}, {6, 9, 1, 103}, {7, 9, 11, 255}, {18, 9, 1, 250}, {19, 9, 1, 76},
  {5, 10, 1, 38}, {6, 10, 1, 245}, {7, 10, 12, 255}, {19, 10, 1, 248}, {20, 10, 1, 31}, {4, 11, 1, 5}, {5, 11, 1, 202}, {6, 11, 14, 255},
  {20, 11, 1, 124}, {4, 12, 1, 42}, {5, 12, 15, 128}, {20, 12, 1, 64},
}
importedData.STROKE_SPANS = {  -- {x, y, len, coverage}
  {11, 0, 1, 6}, {10, 1, 1, 12}, {11, 1, 1, 199}, {12, 1, 1, 14}, {10, 2, 1, 162}, {11, 2, 1, 255}, {12, 2, 1, 153}, {9, 3, 1, 81},
  {10, 3, 3, 255}, {13, 3, 1, 95}, {8, 4, 1, 24}, {9, 4, 1, 235}, {10, 4, 1, 251}, {11, 4, 1, 101}, {12, 4, 1, 243}, {13, 4, 1, 253},
  {14, 4, 1, 104}, {8, 5, 1, 182}, {9, 5, 1, 255}, {10, 5, 1, 126}, {12, 5, 1, 57}, {13, 5, 1, 240}, {14, 5, 1, 255}, {15, 5, 1, 157},
  {16, 5, 1, 9}, {7, 6, 1, 107}, {8, 6, 1, 255}, {9, 6, 1, 199}, {10, 6, 1, 3}, {13, 6, 1, 44}, {14, 6, 1, 216}, {15, 6, 1, 255},
  {16, 6, 1, 210}, {17, 6, 1, 39}, {6, 7, 1, 40}, {7, 7, 1, 246}, {8, 7, 1, 243}, {9, 7, 1, 35}, {14, 7, 1, 11}, {15, 7, 1, 162},
  {16, 7, 1, 255}, {17, 7, 1, 243}, {18, 7, 1, 88}, {5, 8, 1, 5}, {6, 8, 1, 205}, {7, 8, 1, 255}, {8, 8, 1, 100}, {16, 8, 1, 98},
  {17, 8, 1, 249}, {18, 8, 1, 255}, {19, 8, 1, 135}, {5, 9, 1, 133}, {6, 9, 1, 255}, {7, 9, 1, 177}, {17, 9, 1, 62}, {18, 9, 1, 238},
  {19, 9, 1, 255}, {20, 9, 1, 125}, {4, 10, 1, 60}, {5, 10, 1, 252}, {6, 10, 1, 232}, {7, 10, 1, 21}, {18, 10, 1, 40}, {19, 10, 1, 231},
  {20, 10, 1, 248}, {21, 10, 1, 30}, {3, 11, 1, 13}, {4, 11, 1, 222}, {5, 11, 1, 255}, {6, 11, 1, 75}, {7, 11, 1, 7}, {8, 11, 1, 90},
  {9, 11, 10, 104}, {19, 11, 1, 217}, {20, 11, 1, 255}, {21, 11, 1, 92}, {3, 12, 1, 80}, {4, 12, 1, 255}, {5, 12, 1, 151}, {7, 12, 1, 77},
  {8, 12, 13, 255}, {21, 12, 1, 89}, {3, 13, 1, 6}, {4, 13, 1, 75}, {5, 13, 1, 5}, {7, 13, 1, 6}, {8, 13, 1, 86}, {9, 13, 12, 100},
  {21, 13, 1, 22},
}
importedData.STROKER = {
  {"lineTo", 11.5, 2.5},
  {"first", 4.5, 12.5},
  {"M", 0},
  {"L", 0, 5.2374, 13.016, 0},
  {"M", 1},
  {"L", 1, 3.7626, 11.984, 0},
  {"L", 0, 12.2374, 3.016, 1},
  {"L", 1, 10.7626, 1.984, 1},
  {"cubicTo", 20.5, 12.5},
  {"corner", 2.024, 11.5, 2.5},
  {"inside", 0},
  {"L", 0, 10.7132, 2.937, 0},
  {"outside", 1, 0},
  {"S", 1, 11.5878, 0.8047},
  {"L", 1, 12.2868, 2.063, 0},
  {"arc", 11.5, 2.5, 12.125, 3.625, 13.0625, 4.5938, 14.1016, 5.4688},
  {"C", 0, 11.3958, 4.1657, 12.4477, 5.2526, 13.5218, 6.1571},
  {"C", 1, 12.8542, 3.0843, 13.6773, 3.9349, 14.6813, 4.7804},
  {"arc", 14.1016, 5.4688, 15.1406, 6.3438, 16.2812, 7.125, 17.3125, 7.875},
  {"C", 0, 14.5952, 7.061, 15.7623, 7.8604, 16.7832, 8.6029},
  {"C", 1, 15.6861, 5.6265, 16.8002, 6.3896, 17.8418, 7.1471},
  {"arc", 17.3125, 7.875, 18.3438, 8.625, 19.2656, 9.3438, 19.8672, 10.0938},
  {"C", 0, 17.8023, 9.3441, 18.6293, 9.9889, 19.1651, 10.6568},
  {"C", 1, 18.8852, 7.9059, 19.9019, 8.6986, 20.5693, 9.5307},
  {"arc", 19.8672, 10.0938, 20.168, 10.4688, 20.3887, 10.8516, 20.5029, 11.25},
  {"C", 0, 19.4227, 10.978, 19.5539, 11.2056, 19.6378, 11.4981},
  {"C", 1, 20.9132, 9.9595, 21.2234, 10.4975, 21.368, 11.0019},
  {"arc", 20.5029, 11.25, 20.6172, 11.6484, 20.625, 12.0625, 20.5, 12.5},
  {"C", 0, 19.7196, 11.7833, 19.7226, 11.9448, 19.6346, 12.2527},
  {"C", 1, 21.5148, 11.5136, 21.5274, 12.1802, 21.3654, 12.7473},
  {"lineTo", 8.5, 12.5},
  {"corner", 1.2924, 20.5, 12.5},
  {"inside", 0},
  {"L", 0, 20.5, 11.6, 0},
  {"outside", 1, 0},
  {"L", 1, 21.1788, 13.4, 0},
  {"L", 0, 8.5, 11.6, 1},
  {"L", 1, 8.5, 13.4, 1},
  {"end", 0},
  {"cap", 0, 3.1416, 8.5, 12.5},
  {"C", 0, 8.0029, 11.6, 7.6, 12.0029, 7.6, 12.5},
  {"C", 0, 7.6, 12.9971, 8.0029, 13.4, 8.5, 13.4},
  {"R", 20},
  {"cap", 0, 2.1814, 4.5, 12.5},
  {"C", 0, 3.4776, 12.3912, 3.5767, 12.9524, 3.984, 13.2374},
  {"C", 0, 4.3912, 13.5224, 4.9524, 13.4233, 5.2374, 13.016},
  {"X", 0, 0},
}
importedData.PX_FILL = {
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#eceae9","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#e8e6e5","#a09f9b","#e6e5e3","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#f9f7f5","#abaaa7","#9e9d99","#a6a5a1","#eceae9","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#c3c2bf","#9e9d99","#9e9d99","#9e9d99","#a4a39f","#e5e4e1","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#dfdfdc","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#cfcdca","#fcfbf9","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#f4f3f1","#a6a5a1","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#b8b6b3","#f5f4f1","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#bab9b6","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#a7a7a3","#e7e5e3","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#d7d5d3","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9f9e9b","#e0e0dd","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#efedeb","#a1a09d","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#a09f9b","#f1f0ee","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fbfaf8","#b2b1ad","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#cfcdca","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#edece9","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#cdcdca","#e5e4e1","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
}
importedData.PX_FINAL = {
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#f7f6f4","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#f2f1ef","#4d4c49","#f0efed","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#6d6c6a","#1b1a18","#757472","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#b4b4b1","#1b1a18","#1b1a18","#1b1a18","#a9a7a6","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#e7e6e4","#2c2b2a","#1d1c1a","#696965","#21201e","#1c1b19","#a19f9d","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#5c5a59","#1b1a18","#5d5b58","#9e9d99","#807f7b","#23221f","#1b1a18","#71716e","#f5f4f1","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#9e9c9b","#1b1a18","#383634","#9c9b97","#9e9d99","#9e9d99","#868682","#2e2e2b","#1b1a18","#43423f","#dad9d6","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#d9d8d5","#232220","#21201e","#8b8a87","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#989793","#4b4947","#1b1a18","#252422","#afaeac","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#f8f7f5","#474644","#1b1a18","#6a6966","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#6b6a67","#1e1d1b","#1b1a18","#858482","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#878684","#1b1a18","#42423f","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#7d7c78","#242320","#1b1a18","#8e8c8a","#fdfcfa","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#fdfcfa","#c7c6c4","#1d1c1a","#272623","#93928e","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#9e9d99","#898884","#272624","#21201e","#e2e1de","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#f1f0ee","#383734","#1b1a18","#777673","#999894","#6f6e6b","#686763","#686763","#686763","#686763","#686763","#686763","#686763","#686763","#686763","#686763","#2e2d2b","#1b1a18","#abaaa8","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#b5b5b2","#1b1a18","#646360","#cdcdca","#979694","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#1b1a18","#aeadab","#fdfcfa","#fdfcfa",
  "#fdfcfa","#fdfcfa","#fdfcfa","#f7f6f4","#bab9b7","#f8f7f5","#fdfcfa","#f7f6f4","#b1afae","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#a4a3a1","#e9e8e6","#fdfcfa","#fdfcfa",
}
importedData.RLE_ROW = 6
importedData.RLE_FILL = {
  lines = {{4.5, 12.5, 11.5, 2.5}, {11.5, 2.5, 12.64453, 4.07812}, {12.64453, 4.07812, 14.10156, 5.46875}, {14.10156, 5.46875, 17.3125, 7.875}, {17.3125, 7.875, 18.75, 8.98438}, {18.75, 8.98438, 19.86719, 10.09375}, {19.86719, 10.09375, 20.5, 11.25}, {20.5, 11.25, 20.5, 12.5}, {20.5, 12.5, 8.5, 12.5}, {8.5, 12.5, 4.5, 12.5}},
  rec = {{1, 8, -82110, -238}, {1, 9, -216, -18}, {4, 14, 16668, 36}, {4, 15, 49152, 192}, {4, 16, 1036, 28}},
  sweep = {{"cell", 8, -238, -82110, -238, -39746}, {"append", 78, 8, 1, -39746}, {"cell", 9, -18, -216, -256, -130856}, {"append", 255, 9, 1, -130856}, {"run", 10, 4, -256}, {"merge", 255, 9, 5, -131072}, {"cell", 14, 36, 16668, -220, -129308}, {"append", 253, 14, 1, -129308}, {"cell", 15, 192, 49152, -28, -63488}, {"append", 124, 15, 1, -63488}, {"cell", 16, 28, 1036, 0, -1036}, {"append", 3, 16, 1, -1036}},
}
importedData.RLE_STROKE = {
  lines = {{5.23438, 13.01562, 12.23438, 3.01562}, {12.23438, 3.01562, 10.70312, 2.92188}, {10.70312, 2.92188, 11.96094, 4.66016}, {11.96094, 4.66016, 13.51562, 6.15625}, {13.51562, 6.15625, 16.78125, 8.59375}, {16.78125, 8.59375, 19.15625, 10.65625}, {19.15625, 10.65625, 19.625, 11.48438}, {19.625, 11.48438, 19.625, 12.25}, {19.625, 12.25, 20.5, 11.59375}, {20.5, 11.59375, 8.5, 11.59375}, {8.5, 11.59375, 7.85938, 11.85938}, {7.85938, 11.85938, 7.59375, 12.5}, {7.59375, 12.5, 7.85938, 13.125}, {7.85938, 13.125, 8.5, 13.39062}, {8.5, 13.39062, 8.5, 13.39062}, {8.5, 13.39062, 21.17188, 13.39062}, {21.17188, 13.39062, 21.35938, 12.73438}, {21.35938, 12.73438, 21.35938, 11}, {21.35938, 11, 20.5625, 9.51562}, {20.5625, 9.51562, 19.33594, 8.29688}, {19.33594, 8.29688, 17.82812, 7.14062}, {17.82812, 7.14062, 14.67188, 4.76562}, {14.67188, 4.76562, 13.3125, 3.47656}, {13.3125, 3.47656, 12.28125, 2.0625}, {12.28125, 2.0625, 11.57812, 0.79688}, {11.57812, 0.79688, 3.75, 11.96875}, {3.75, 11.96875, 3.60156, 12.64844}, {3.60156, 12.64844, 3.96875, 13.23438}, {3.96875, 13.23438, 4.64844, 13.38281}, {4.64844, 13.38281, 5.23438, 13.01562}, {5.23438, 13.01562, 5.23438, 13.01562}},
  rec = {{1, 9, -74907, -203}, {1, 10, -1961, -53}, {5, 13, 44576, 132}, {5, 14, 20460, 124}, {22, 17, -20336, -124}, {22, 16, -44220, -132}, {26, 7, 76032, 256}},
  sweep = {{"cell", 7, 256, 76032, 256, 55040}, {"append", 107, 7, 1, 55040}, {"run", 8, 1, 256}, {"append", 255, 8, 1, 131072}, {"cell", 9, -203, -74907, 53, 102043}, {"append", 199, 9, 1, 102043}, {"cell", 10, -53, -1961, 0, 1961}, {"append", 3, 10, 1, 1961}, {"cell", 13, 132, 44576, 132, 23008}, {"append", 44, 13, 1, 23008}, {"cell", 14, 124, 20460, 256, 110612}, {"append", 216, 14, 1, 110612}, {"run", 15, 1, 256}, {"append", 255, 15, 1, 131072}, {"cell", 16, -132, -44220, 124, 107708}, {"append", 210, 16, 1, 107708}, {"cell", 17, -124, -20336, 0, 20336}, {"append", 39, 17, 1, 20336}},
}

-- ------------------------------------------------------------------ palette and layers
importedData.PAPER = "#fdfcfa"
local HAIR_SOFT, HAIR = "border", "border"
local INK_FAINT, INK_SOFT, INK = "muted", "foreground", "foreground"
local ACCENT, ACCENT_LIGHT, ACCENT_WASH = "accent", "accent", "surface"

-- layer 1 (fill: shape.rle) draws below layer 2 (stroke: shape.strokeRle); span run line: layer + 1
local L_WASH, L_PIX, L_GRID, L_FSPAN, L_OUT, L_ODOT = 1, 2, 3, 4, 6, 7
local L_WASH2, L_PIX2, L_GRID2, L_SSPAN, L_TRAIL, L_BORDER, L_DOT, L_PEN = 10, 11, 12, 13, 15, 16, 18, 19
local L_PTR, L_TEXT, L_OVER, L_Z, L_ZTOP = 20, 21, 22, 23, 25

-- every duration below is multiplied by SL
local SL = 1.0

-- ------------------------------------------------------------------ surface pixel -> world
local S = 0.225                              -- one surface pixel = 22.5 screen px
local X0, Y0 = -3.68, ROWS * S / 2           -- world position of surface point (0, 0)
local function W(p) return {X0 + p[1] * S, Y0 - p[2] * S} end
local function rowY(r) return Y0 - (r + 0.5) * S end
local GRID_W = COLS * S

-- right column (screen y px = 225 - 100 * world y)
local PX = X0 + GRID_W + 0.14
local LABEL_Y, LABEL_DY = 1.83, 0.18
local CMD_Y, CMD_DY = 1.29, 0.18

local nid = 0
local function id(base) nid = nid + 1; return base .. "-" .. nid end
local function fmt(v) return string.format("%g", v) end

-- ------------------------------------------------------------------ geometry helpers
local function bez(p0, c1, c2, p1, t)
  local u = 1 - t
  local a, b, c, d = u * u * u, 3 * u * u * t, 3 * u * t * t, t * t * t
  return {a * p0[1] + b * c1[1] + c * c2[1] + d * p1[1], a * p0[2] + b * c1[2] + c * c2[2] + d * p1[2]}
end
local function sampleCubic(p0, c1, c2, p1, n)
  local pts = {}
  for i = 0, n do pts[#pts + 1] = bez(p0, c1, c2, p1, i / n) end
  return pts
end
local function map(pts, f)
  local out = {}
  for i = 1, #pts do out[i] = f(pts[i]) end
  return out
end
local PAR = scene                            -- the layer group new drawings go into
local function pathObj(pts, style)
  local c = {{type = "move", to = pts[1]}}
  for i = 2, #pts do c[#c + 1] = {type = "line", to = pts[i]} end
  return PAR:path {commands = c, stroke = style.stroke, width = style.width, dash = style.dash,
    layer = style.layer, id = id(style.id or "p")}
end
local function routeObj(pts, style)
  return PAR:route {points = pts, stroke = style.stroke, width = style.width, tail = 0,
    tip = style.tip or 0, dash = style.dash, layer = style.layer, id = id(style.id or "r")}
end
-- tip-only route: an accent arrow tip drawn at the end of a route while it is created
local function penObj(pts)
  return routeObj(pts, {stroke = ACCENT, width = 1, tip = 10, dash = {0, 4000}, layer = L_PEN, id = "pen"})
end

-- ------------------------------------------------------------------ timeline helpers (durations x SL)
local function wait(d) scene:wait(d * SL) end
local function play(list, d, curve)
  if #list > 0 then scene:play(list, d * SL, curve or "linear") else scene:wait(d * SL) end
end
local function create(list, d, curve, lag) scene:create(list, d * SL, curve or "linear", (lag or 0) * SL) end
local function grow(o, d) scene:grow_from_center(o, d * SL, "ease_out") end
local function look(c, d) scene:look(c, d * SL, "ease_in_out") end
local function mark(n) scene:group {id = string.format("mark_%s_%.2f", n, scene:duration())} end
local function show(list, value)
  local out = {}
  for _, o in ipairs(list) do out[#out + 1] = {target = o, opacity = value} end
  return out
end
local function concat(a, b) for _, v in ipairs(b) do a[#a + 1] = v end return a end

-- ------------------------------------------------------------------ one SwSpan {x, y, len, coverage}
-- only the start pixel (x, y) is filled, as a whole cell; lightness = coverage:
-- paper + (ink - paper) * coverage / 255 per channel. len > 1: a line from the centre of pixel x
-- to the centre of pixel x+len-1, with a dot at that end; the pixels between are not filled.
-- The span being written draws its line in the accent; it turns ink-soft once the next one starts.
local function hexCh(h, i) return tonumber(h:sub(i, i + 1), 16) end
local function covColor(c)
  local out = "#"
  for _, i in ipairs({2, 4, 6}) do
    local p, k = hexCh(importedData.PAPER, i), hexCh("#1b1a18", i)
    out = out .. string.format("%02x", math.floor(p + (k - p) * c / 255 + 0.5))
  end
  return out
end
-- the run group is scaled in x about the start pixel's centre, so the line grows from x to x+len-1
local function growM(sx, xc) return {sx, 0, 0, xc * (1 - sx), 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1} end
local IDENT = growM(1, 0)
local PARTS = {}
local function spanObj(s, cy, layer, grown, visible, current)
  local xl = X0 + s[1] * S
  local xc = xl + 0.5 * S
  local g = PAR:group {opacity = visible and 1 or 0, id = id("span")}
  g:rectangle {center = {xc, cy}, size = {S, S}, fill = covColor(s[4]), layer = layer, id = id("spx")}
  local parts = {}
  if s[3] > 1 then
    local col = current and ACCENT or INK_SOFT
    local run = g:group {matrix = grown and IDENT or growM(0.001, xc), id = id("run")}
    local xe = xl + (s[3] - 0.5) * S
    parts.run = run
    parts.line = run:line {from = {xc, cy}, to = {xe, cy}, stroke = col, width = 2, layer = layer + 1, id = id("rl")}
    parts.dot = run:point {point = {xe, cy}, radius = 3, fill = col, layer = layer + 1, id = id("rd")}
  end
  PARTS[g] = parts
  return g
end
-- descriptors that show a span and grow its run line
local function reveal(g, list)
  list[#list + 1] = {target = g, opacity = 1}
  local p = PARTS[g]
  if p.run then list[#list + 1] = {target = p.run, transform = IDENT} end
  return list
end
-- descriptors that turn a written span's line from the accent to ink-soft
local function settle(g, list)
  local p = g and PARTS[g]
  if p and p.line then
    list[#list + 1] = {target = p.line, stroke = INK_SOFT}
    list[#list + 1] = {target = p.dot, fill = INK_SOFT}
  end
  return list
end

-- ------------------------------------------------------------------ oblique projection of the two layers
-- A surface point (u, v) (column, row) on a layer raised by h is drawn at
--   x = Ox + c * (u + a * d),  y = Oy + h + c * b * d,  d = ROWS - v (distance from the front edge)
-- an oblique parallel projection: rows stay horizontal, columns stay parallel. t = 0 is the flat
-- 2D view (c = S, a = 0, b = 1); t = 1 is the tilted view. Written as the layer group's matrix
-- acting on the flat world coordinates W(u, v).
local A1, B1, C1 = 0.4, 0.55, 0.183          -- skew, depth scale, world units per cell when tilted
local OY1 = -1.635                           -- front edge of layer 1 when tilted
local GAP = 1.86                             -- layer 2 is raised by this much (world units)
local function projM(t, h)
  local a, b, c = A1 * t, 1 + (B1 - 1) * t, S + (C1 - S) * t
  local oy = -Y0 + (OY1 + Y0) * t + h
  local m11, m12, m22 = c / S, c * a / S, c * b / S
  local tx = X0 - m11 * X0 + c * a * ROWS / 2
  local ty = oy + c * b * ROWS / 2
  return {m11, m12, 0, tx, 0, m22, 0, ty, 0, 0, 1, 0, 0, 0, 0, 1}
end
local function applyM(m, p) return {m[1] * p[1] + m[2] * p[2] + m[4], m[5] * p[1] + m[6] * p[2] + m[8]} end
local G1 = scene:group {matrix = projM(0, 0), id = "layer1"}
local G2 = scene:group {matrix = projM(0, 0), id = "layer2"}

-- ------------------------------------------------------------------ opening state: the finished surface
local function gridIn(g, layer, color)
  for x = 0, COLS do
    g:line {from = W({x, 0}), to = W({x, ROWS}), stroke = color, width = 1, layer = layer, id = id("gx")}
  end
  for y = 0, ROWS do
    g:line {from = W({0, y}), to = W({COLS, y}), stroke = color, width = 1, layer = layer, id = id("gy")}
  end
end
gridIn(G1, L_GRID, HAIR_SOFT)
local grid2 = G2:group {opacity = 0, id = "grid2"}
gridIn(grid2, L_GRID2, HAIR_SOFT)
-- a hairline frame around each layer while tilted
local function frameIn(g, layer)
  return g:rectangle {center = {X0 + GRID_W / 2, 0}, size = {GRID_W, ROWS * S}, fill = importedData.PAPER .. "00", stroke = HAIR,
    width = 1, layer = layer, opacity = 0, id = id("frame")}
end
local frame1, frame2 = frameIn(G1, L_GRID), frameIn(grid2, L_GRID2)

-- surface pixels on layer 1: final ARGB from SwCanvas; PX_FILL is the buffer after rasterShape alone
local pixRow = {}
for r = 0, ROWS - 1 do
  pixRow[r] = {}
  for c = 0, COLS - 1 do
    local i = r * COLS + c + 1
    if importedData.PX_FINAL[i] ~= importedData.PAPER or importedData.PX_FILL[i] ~= importedData.PAPER then
      local o = G1:rectangle {center = W({c + 0.5, r + 0.5}), size = {S, S}, fill = importedData.PX_FINAL[i],
        layer = L_PIX, id = id("px")}
      pixRow[r][#pixRow[r] + 1] = {obj = o, fill = importedData.PX_FILL[i], final = importedData.PX_FINAL[i], x = c}
    end
  end
end

-- command list (RenderPath commands, in path order)
local cmdText, line = {}, 0
for i, cmd in ipairs(importedData.CMDS) do
  cmdText[i] = {}
  for j, p in ipairs(cmd.pts) do
    local s = string.format("%-8s%s", j == 1 and cmd.name or "", fmt(p[1]) .. "," .. fmt(p[2]))
    cmdText[i][j] = scene:text {text = s, point = {PX, CMD_Y - line * CMD_DY}, align = {0, 0.5}, size = 14,
      font = importedData.FONT, fill = INK_FAINT, layer = L_TEXT, id = id("cmd")}
    line = line + 1
  end
end

-- the row being written or read, one marker per layer: accent-wash behind the row, a short accent rule left of it
local function rowMarker(g, layer)
  local m = {at = 0}
  m.wash = g:rectangle {center = {X0 + GRID_W / 2, rowY(0)}, size = {GRID_W, S}, fill = ACCENT_WASH,
    layer = layer, opacity = 0, id = id("wash")}
  m.ptr = g:line {from = {X0 - 0.26, rowY(0)}, to = {X0 - 0.06, rowY(0)}, stroke = ACCENT, width = 2,
    layer = L_PTR, opacity = 0, id = id("ptr")}
  return m
end
local MK1, MK2 = rowMarker(G1, L_WASH), rowMarker(G2, L_WASH2)
local function toRow(m, r, list, opacity)
  list[#list + 1] = {target = m.wash, shift = {0, -(r - m.at) * S}, opacity = opacity}
  list[#list + 1] = {target = m.ptr, shift = {0, -(r - m.at) * S}, opacity = opacity}
  m.at = r
  return list
end

local stage = nil
local function stageLabel(lines, hide, reveal2)
  if type(lines) == "string" then lines = {lines} end
  local t = {}
  for j, s in ipairs(lines) do
    t[j] = scene:text {text = s, point = {PX, LABEL_Y - (j - 1) * LABEL_DY}, align = {0, 0.5}, size = 14, font = importedData.FONT,
      fill = INK, layer = L_TEXT, opacity = 0, id = id("stage")}
  end
  -- the old label and everything it leaves go out first, then the new label and what it brings come in
  play(concat(show(stage or {}, 0), hide or {}), 0.16, "ease_in_out")
  play(concat(show(t, 1), reveal2 or {}), 0.16, "ease_in_out")
  stage = t
end
local lit = nil
local function light(i)
  local list = {}
  if lit then for _, o in ipairs(cmdText[lit]) do list[#list + 1] = {target = o, fill = INK} end end
  if i then for _, o in ipairs(cmdText[i]) do list[#list + 1] = {target = o, fill = ACCENT} end end
  play(list, 0.08)
  lit = i
end

PAR = G1
-- ------------------------------------------------------------------ 0. the surface is cleared for this frame
wait(0.3)
for r = 0, ROWS - 1 do
  play(show(map(pixRow[r], function(px) return px.obj end), 0), 0.03)
end

-- ------------------------------------------------------------------ 1. shapeGenRle -> _genOutline: RenderPath -> SwOutline
mark("outline")
stageLabel("_genOutline")
local P = {}                                  -- on-curve points P0..P3
local outline = {}                            -- centre-line routes, one per drawing command
local anchors, handles = {}, {}
local function anchor(p)
  local a = PAR:point {point = W(p), radius = 3, fill = INK, layer = L_ODOT, id = id("anchor")}
  anchors[#anchors + 1] = a
  return a
end

-- moveTo: an anchor dot at P0, no segment (tvgSwShape.cpp:48-55)
light(1)
P[0] = importedData.CMDS[1].pts[1]
grow(anchor(P[0]), 0.25)
wait(0.15)

local prevPen = nil
local function drawSegment(pts, dur)
  local route = routeObj(map(pts, W), {stroke = INK, width = 2, layer = L_OUT, id = "outline"})
  local pen = penObj(map(pts, W))
  if prevPen then scene:remove(prevPen) end
  create({route, pen}, dur)
  prevPen = pen
  outline[#outline + 1] = route
end

-- lineTo (tvgSwShape.cpp:57-61)
light(2)
P[1] = importedData.CMDS[2].pts[1]
drawSegment({P[0], P[1]}, 0.45)
grow(anchor(P[1]), 0.12)
wait(0.12)

-- cubicTo: ctrl1, ctrl2, to (tvgSwShape.cpp:63-71)
light(3)
local c1, c2 = importedData.CMDS[3].pts[1], importedData.CMDS[3].pts[2]
P[2] = importedData.CMDS[3].pts[3]
local h1 = PAR:line {from = W(P[1]), to = W(c1), stroke = HAIR, width = 1, layer = L_OUT, id = id("handle")}
local h2 = PAR:line {from = W(P[2]), to = W(c2), stroke = HAIR, width = 1, layer = L_OUT, id = id("handle")}
local k1 = PAR:point {point = W(c1), radius = 3, fill = "background", stroke = INK_FAINT, width = 1.2, layer = L_ODOT, id = id("ctrl")}
local k2 = PAR:point {point = W(c2), radius = 3, fill = "background", stroke = INK_FAINT, width = 1.2, layer = L_ODOT, id = id("ctrl")}
handles = {h1, h2, k1, k2}
create({h1, k1, h2, k2}, 0.18, "ease_out", 0.03)
drawSegment(sampleCubic(P[1], c1, c2, P[2], 48), 0.7)
grow(anchor(P[2]), 0.12)
wait(0.12)

-- lineTo
light(4)
P[3] = importedData.CMDS[4].pts[1]
drawSegment({P[2], P[3]}, 0.4)
grow(anchor(P[3]), 0.12)
scene:remove(prevPen); prevPen = nil
light(nil)
wait(0.15)

-- ------------------------------------------------------------------ span helpers
local function byRow(spans)
  local rows, lo, hi = {}, 1e9, -1
  for _, s in ipairs(spans) do
    local y = s[2]
    rows[y] = rows[y] or {}
    rows[y][#rows[y] + 1] = s
    if y < lo then lo = y end
    if y > hi then hi = y end
  end
  return rows, lo, hi
end
local fillRows, fLo, fHi = byRow(importedData.FILL_SPANS)
local strokeRows, sLo, sHi = byRow(importedData.STROKE_SPANS)

-- ------------------------------------------------------------------ rleRender, one row up close
local ZC = 64                                -- screen px per surface pixel while zoomed
local ZPPU = ZC / S                          -- screen px per world unit while zoomed
local HOME = {view = "2d", eye = {0, 0, 10}, target = {0, 0, 0}, height = 4.5}
local function camAt(cx, cy)
  local c = W({cx, cy})
  return {view = "2d", eye = {c[1], c[2], 10}, target = {c[1], c[2], 0}, height = 450 / ZPPU}
end

-- t range of segment a->b inside box [x0,x1]x[y0,y1] (Liang-Barsky)
local function clipT(a, b, x0, y0, x1, y1)
  local t0, t1 = 0, 1
  local dx, dy = b[1] - a[1], b[2] - a[2]
  local Pp = {-dx, dx, -dy, dy}
  local Q = {a[1] - x0, x1 - a[1], a[2] - y0, y1 - a[2]}
  for i = 1, 4 do
    if Pp[i] == 0 then
      if Q[i] < 0 then return nil end
    else
      local r = Q[i] / Pp[i]
      if Pp[i] < 0 then if r > t1 then return nil elseif r > t0 then t0 = r end
      else if r < t0 then return nil elseif r < t1 then t1 = r end end
    end
  end
  return t0, t1
end
local function lerp(a, b, t) return {a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t} end

-- D: RLE_FILL; (cx, cy): surface point at the screen centre; wx0..wx1: cells of the row kept clear
local function zoomRow(D, cx, cy, wx0, wx1)
  local R = importedData.RLE_ROW
  local function Z(px, py) local c = W({cx, cy}); return {c[1] + (px - 400) / ZPPU, c[2] - (py - 225) / ZPPU} end
  local function sx(x) return 400 + (x - cx) * ZC end
  local rowTop = 225 + (R - cy) * ZC
  local ACC_Y = rowTop + ZC + 28
  local SPAN_Y = rowTop + 2 * ZC + 56          -- centre of the rle->spans row
  local COV_Y = SPAN_Y + ZC / 2 + 18
  local spanCy = Z(0, SPAN_Y)[2]
  local zobj = {}
  local function keep(o) zobj[#zobj + 1] = o; return o end
  local function label(s, px, py, fill, ax)
    return keep(scene:text {text = s, point = Z(px, py), align = {ax or 0, 0.5}, size = 14, font = importedData.FONT,
      fill = fill or INK, layer = L_ZTOP, opacity = 0, id = id("z")})
  end

  -- everything outside row R, cells wx0..wx1, is covered by paper at 0.86
  local vx0, vx1, vy0, vy1 = cx - 7, cx + 7, cy - 4.2, cy + 4.2
  local over = {}
  local gx0, gx1, gy0, gy1 = -40, COLS + 40, -40, ROWS + 40
  for _, r in ipairs({{gx0, gy0, gx1, R}, {gx0, R + 1, gx1, gy1}, {gx0, R, wx0, R + 1}, {wx1 + 1, R, gx1, R + 1}}) do
    local a, b = W({r[1], r[2]}), W({r[3], r[4]})
    over[#over + 1] = keep(scene:rectangle {center = {(a[1] + b[1]) / 2, (a[2] + b[2]) / 2}, size = {math.abs(b[1] - a[1]), math.abs(b[2] - a[2])},
      fill = "background", stroke = "background", width = 0, layer = L_OVER, opacity = 0, id = id("over")})
  end
  local fn = label("_lineTo", 32, 40, INK)
  local names = {label("cell->cover", 32, rowTop + 20, INK_SOFT), label("cell->area", 32, rowTop + 44, INK_SOFT),
    label("cover", 32, ACC_Y, INK_SOFT), label("rle->spans", 32, SPAN_Y, INK_SOFT)}
  local o = {}
  for _, v in ipairs(over) do o[#o + 1] = {target = v, opacity = 0.86} end
  play(o, 0.15)
  look(camAt(cx, cy), 0.55)
  play(concat(show({fn}, 1), show(names, 1)), 0.12)
  wait(0.15)

  -- _lineTo walks each edge through the cells; _setCell -> _recordCell adds area / cover
  -- to the cell it leaves (tvgSwRle.cpp:494-620, 433-459, 420-430)
  local byPiece, order = {}, {}
  for _, rc in ipairs(D.rec) do
    if not byPiece[rc[1]] then byPiece[rc[1]] = {}; order[#order + 1] = rc[1] end
    local list = byPiece[rc[1]]
    list[#list + 1] = rc
  end
  local tints, edges = {}, {}
  for _, p in ipairs(order) do
    local ln = D.lines[p]
    local a, b = {ln[1], ln[2]}, {ln[3], ln[4]}
    local t0, t1 = clipT(a, b, vx0, vy0, vx1, vy1)
    local cuts = {}
    for _, rc in ipairs(byPiece[p]) do
      local _, te = clipT(a, b, rc[2], R, rc[2] + 1, R + 1)
      cuts[#cuts + 1] = {t = te or t0, rc = rc}
    end
    local tPrev = t0
    local function segTo(t, dur)
      if t - tPrev < 1e-4 then return end
      local seg = routeObj(map({lerp(a, b, tPrev), lerp(a, b, t)}, W), {stroke = INK, width = 1.6, layer = L_Z, id = "edge"})
      local pen = penObj(map({lerp(a, b, tPrev), lerp(a, b, t)}, W))
      keep(seg)
      edges[#edges + 1] = seg
      create({seg, pen}, dur)
      scene:remove(pen)
      tPrev = t
    end
    local span = t1 - t0
    for _, c in ipairs(cuts) do
      segTo(c.t, math.max(0.05, 0.4 * (c.t - tPrev) / span))
      local rc = c.rc
      local cc = W({rc[2] + 0.5, R + 0.5})
      local tint = keep(scene:rectangle {center = cc, size = {S, S}, fill = ACCENT_WASH, stroke = ACCENT_LIGHT, width = 1,
        layer = L_Z - 1, opacity = 0, id = id("cell")})
      tints[rc[2]] = tint
      local tc = label(tostring(rc[4]), sx(rc[2] + 0.5), rowTop + 20, INK, 0.5)
      local ta = label(tostring(rc[3]), sx(rc[2] + 0.5), rowTop + 44, INK_FAINT, 0.5)
      play(show({tint, tc, ta}, 1), 0.1)
      wait(0.06)
    end
    segTo(t1, math.max(0.05, 0.4 * (t1 - tPrev) / span))
  end
  wait(0.15)

  -- _sweep: left to right, cover accumulates; a cell gives cover*512 - cell->area,
  -- a gap between cells gives cover*512; _horizLine turns that into a coverage and
  -- appends a span or extends the last one (tvgSwRle.cpp:370-390, 314-367)
mark("sweep")
  local fn2 = label("_sweep", 32, 40, INK)
  local formula = label("coverage = min(255, |(cover*512 - cell->area) >> 9|)", 32, COV_Y + 40, INK_FAINT)
  local swap = concat(show({fn}, 0), show({fn2, formula}, 1))
  for _, e in ipairs(edges) do swap[#swap + 1] = {target = e, stroke = HAIR_SOFT} end
  play(swap, 0.15)
  local cur = keep(scene:line {from = Z(sx(wx0), rowTop - 10), to = Z(sx(wx0), SPAN_Y + ZC / 2 + 4), stroke = ACCENT, width = 1.5,
    layer = L_ZTOP, opacity = 0, id = id("cursor")})
  play(show({cur}, 1), 0.1)
  local at, spans, last, lastLabel, lastSpan = wx0, {}, nil, nil, nil
  for _, e in ipairs(D.sweep) do
    if e[1] == "cell" or e[1] == "run" then
      local x0, x1, cover = e[2], e[2] + 1, e[5]
      if e[1] == "run" then x1, cover = e[2] + e[3], e[4] end
      local list = settle(last and last.obj, {{target = cur, shift = {(x1 - at) * S, 0}}})
      last = nil
      local acc = label(tostring(cover), sx((x0 + x1) / 2), ACC_Y, e[1] == "run" and INK_FAINT or INK, 0.5)
      list[#list + 1] = {target = acc, opacity = 1}
      if e[1] == "cell" and tints[x0] then list[#list + 1] = {target = tints[x0], stroke = ACCENT} end
      play(list, e[1] == "run" and 0.3 or 0.2, "ease_in_out")
      wait(0.04)
      at = x1
    elseif e[1] == "append" then
      -- _horizLine appends a new span {x, y, len, coverage}
      local s = {e[3], R, e[4], e[2]}
      local g = keep(spanObj(s, spanCy, L_Z, false, false, true))
      local t = label(tostring(e[2]), sx(e[3] + e[4] / 2), COV_Y, INK, 0.5)
      play(settle(last and last.obj, reveal(g, {{target = t, opacity = 1}})), 0.16, "ease_out")
      wait(0.08)
      spans[#spans + 1] = s
      last, lastLabel, lastSpan = {obj = g}, t, g
    elseif e[1] == "merge" then
      -- same coverage, touching the last span on this row: its len grows (tvgSwRle.cpp:342-351)
      local s = {e[3], R, e[4], e[2]}
      local g = keep(spanObj(s, spanCy, L_Z, false, true, true))
      local t = label(tostring(e[2]), sx(e[3] + e[4] / 2), COV_Y, INK, 0.5)
      play(reveal(g, {{target = lastSpan, opacity = 0}, {target = lastLabel, opacity = 0}, {target = t, opacity = 1}}), 0.3, "ease_in_out")
      wait(0.08)
      spans[#spans] = s
      last, lastLabel, lastSpan = {obj = g}, t, g
    end
  end
  play(settle(last and last.obj, {}), 0.1)
  wait(0.25)

  -- zoom out: the row's spans move up into row R of the surface
  local zspans = {}
  for _, s in ipairs(spans) do
    local g = spanObj(s, spanCy, L_Z, true, true)   -- the finished spans of the row, drawn once more
    zspans[#zspans + 1] = g
  end
  local out = {}
  for _, v in ipairs(zobj) do out[#out + 1] = {target = v, opacity = 0} end
  play(out, 0.14)
mark("zoomout")
  look(HOME, 0.5)
  local up = {}
  for _, g in ipairs(zspans) do up[#up + 1] = {target = g, shift = {0, rowY(R) - spanCy}} end
  play(up, 0.3, "ease_in_out")
  -- same pixels, placed on the span layer of the surface
  local final = {}
  local sw = {}
  for _, s in ipairs(spans) do
    local g = spanObj(s, rowY(R), L_FSPAN, true, false)
    final[#final + 1] = g
    sw[#sw + 1] = {target = g, opacity = 1}
  end
  for _, g in ipairs(zspans) do sw[#sw + 1] = {target = g, opacity = 0} end
  play(sw, 0.04)
  return final
end

-- the rows of an rleRender result, top to bottom
local function allRows(m, rows, lo, hi, layer, have, rowT)
  local list = toRow(m, lo, {})
  play(list, 0.02)
  play(show({m.wash, m.ptr}, 1), 0.1)
  local objs, prev = {}, {}
  for r = lo, hi do
    list = (r > lo) and toRow(m, r, {}) or {}
    for _, g in ipairs(prev) do settle(g, list) end
    objs[r], prev = {}, {}
    if have and have[r] then
      objs[r] = have[r]
    else
      for _, s in ipairs(rows[r] or {}) do
        local g = spanObj(s, rowY(r), layer, false, false, true)
        objs[r][#objs[r] + 1] = g
        prev[#prev + 1] = g
        reveal(g, list)
      end
    end
    play(list, rowT, "ease_out")
  end
  local fin = show({m.wash, m.ptr}, 0)
  for _, g in ipairs(prev) do settle(g, fin) end
  play(fin, 0.1)
  return objs
end

-- ------------------------------------------------------------------ 2. shapeGenRle -> rleRender -> shape.rle
local fade = {}
for _, h in ipairs(handles) do fade[#fade + 1] = {target = h, opacity = 0} end
for _, o in ipairs(outline) do fade[#fade + 1] = {target = o, stroke = INK_SOFT} end
stageLabel({"shape.rle =", "  rleRender"}, fade)
-- _decomposeOutline closes every contour with a line back to its start (tvgSwRle.cpp:725-726)
local chord = routeObj(map({P[3], P[0]}, W), {stroke = INK_SOFT, width = 1.5, dash = {5, 4}, layer = L_OUT, id = "close"})
local chordPen = penObj(map({P[3], P[0]}, W))
create({chord, chordPen}, 0.4)
scene:remove(chordPen)
local rowFill = zoomRow(importedData.RLE_FILL, 11.75, 7.81, 8, 16)
local fillSpans = allRows(MK1, fillRows, fLo, fHi, L_FSPAN, {[importedData.RLE_ROW] = rowFill}, 0.12)
wait(0.3)

-- ------------------------------------------------------------------ 3. shapeGenStrokeRle -> strokeParseOutline
-- the stroker reuses shape.outline (tvgSwShape.cpp:499); shape.rle is kept for rasterShape.
-- The view tilts: layer 1 keeps the fill (outline, shape.rle); layer 2 rises above it for the stroke.
stageLabel("strokeParseOutline", {{target = chord, opacity = 0}})
local M1, M2 = projM(1, 0), projM(1, GAP)
local function layerLabel(s, m)
  local p = applyM(m, W({0, ROWS}))
  return scene:text {text = s, point = {p[1], p[2] - 0.16}, align = {0, 0.5}, size = 14, font = importedData.FONT,
    fill = INK_FAINT, layer = L_TEXT, opacity = 0, id = id("layer")}
end
local lab1, lab2 = layerLabel("shape.rle", M1), layerLabel("shape.strokeRle", M2)
local function smooth(t) return t * t * (3 - 2 * t) end
local TILT_STEPS = 10
local function tilt(t0, t1, h0, h1, dur, extra)
  for k = 1, TILT_STEPS do
    local t = t0 + (t1 - t0) * smooth(k / TILT_STEPS)
    local h = h0 + (h1 - h0) * smooth(k / TILT_STEPS)
    local list = {{target = G1, transform = projM(t, 0)}, {target = G2, transform = projM(t, h)}}
    if extra then extra(list, k / TILT_STEPS) end
    play(list, dur / TILT_STEPS)
  end
end
tilt(0, 1, 0, GAP, 1.5, function(list, f)
  list[#list + 1] = {target = frame1, opacity = f}
  list[#list + 1] = {target = grid2, opacity = f}
  list[#list + 1] = {target = frame2, opacity = f}
end)
play(show({lab1, lab2}, 1), 0.2, "ease_in_out")
wait(0.15)
PAR = G2

-- the two borders
local STYLE = {
  [0] = {stroke = INK, width = 1.6, layer = L_BORDER, id = "b0"},
  [1] = {stroke = INK_SOFT, width = 1.6, dash = {4, 3}, layer = L_BORDER, id = "b1"},
}
local DOTC = {[0] = INK, [1] = INK_SOFT}
local side = {[0] = {pts = {}, pieces = {}, samples = {}}, [1] = {pts = {}, pieces = {}, samples = {}}}
local borderObjs, dotObjs, trail = {}, {}, {}

local function newDot(s, p, list, hidden, color)
  local d = PAR:point {point = W(p), radius = color and 3.4 or 2.2, fill = color or DOTC[s], layer = L_DOT, opacity = hidden and 0 or 1, id = id("bdot")}
  dotObjs[#dotObjs + 1] = d
  list[#list + 1] = d
end
-- one border write: a line or cubic from the border's last point
local function newPiece(s, pts, movable, list)
  local main = pathObj(map(pts, W), STYLE[s])
  list[#list + 1] = main
  local st = side[s]
  if st.open then newDot(s, st.pts[#st.pts], list); st.open = false end
  st.pieces[#st.pieces + 1] = {main = main, from = pts[1]}
  st.pts[#st.pts + 1] = pts[#pts]
  for j = 2, #pts do st.samples[#st.samples + 1] = pts[j] end
  if movable then st.open = true else newDot(s, pts[#pts], list) end
end
local function pieceFromLast(s, to)
  local st = side[s]
  return {st.pts[#st.pts], to}
end
-- the centre line being walked: trail + accent arrow tip
local walkPen = nil
local function walk(pts, list)
  local t = routeObj(map(pts, W), {stroke = ACCENT_LIGHT, width = 3.5, layer = L_TRAIL, id = "walk"})
  trail[#trail + 1] = t
  list[#list + 1] = t
  if walkPen then scene:remove(walkPen) end
  walkPen = penObj(map(pts, W))
  list[#list + 1] = walkPen
end

local labels = {}
local firstDots = {}
local nextCmd = 2
local tag, center = nil, nil
local pendingSeg, pendingArc, arcPts = {}, {}, nil

for _, e in ipairs(importedData.STROKER) do
  local k = e[1]
  if k == "lineTo" or k == "cubicTo" then
    light(nextCmd)
    nextCmd = nextCmd + 1
    tag = k
    center = {e[2], e[3]}
  elseif k == "first" then
    tag = "first"
  elseif k == "corner" or k == "end" then
    tag = k
    if k == "end" and walkPen then scene:remove(walkPen); walkPen = nil end
  elseif k == "inside" or k == "outside" or k == "cap" then
    tag = k
  elseif k == "arc" then
    tag = "arc"
    arcPts = {{e[2], e[3]}, {e[4], e[5]}, {e[6], e[7]}, {e[8], e[9]}}
  elseif k == "M" then
    -- _borderMoveTo: a new sub-path starts on this border
  elseif k == "L" then
    local s, p, movable = e[2], {e[3], e[4]}, e[5] == 1
    if tag == "first" and not movable then
      -- _firstSubPath: both borders start at P0 +- width/2 (tvgSwStroke.cpp:310-323)
      side[s].pts[1] = p
      side[s].samples[1] = p
      newDot(s, p, firstDots, true)
      if s == 1 then
        -- name the two borders beside the first segment, on their own sides
        local d = {P[1][1] - P[0][1], P[1][2] - P[0][2]}
        local len = math.sqrt(d[1] * d[1] + d[2] * d[2])
        local n0 = {-d[2] / len, d[1] / len}          -- borders[0] side: direction rotated +90 deg
        local mid = {P[0][1] + 0.45 * d[1], P[0][2] + 0.45 * d[2]}
        -- placed on layer 2's projection, 2.4 cells out on each side
        local pa = applyM(M2, W({mid[1] + 2.4 * n0[1], mid[2] + 2.4 * n0[2]}))
        local pb = applyM(M2, W({mid[1] - 2.4 * n0[1], mid[2] - 2.4 * n0[2]}))
        labels[0] = scene:text {text = "borders[0]", point = pa,
          align = {0, 0.5}, size = 14, font = importedData.FONT, fill = INK, layer = L_TEXT, opacity = 0, id = id("lb0")}
        labels[1] = scene:text {text = "borders[1]", point = pb,
          align = {1, 0.5}, size = 14, font = importedData.FONT, fill = INK_SOFT, layer = L_TEXT, opacity = 0, id = id("lb1")}
        play(show(concat({labels[0], labels[1]}, firstDots), 1), 0.2)
        wait(0.15)
      end
    elseif movable then
      -- _lineTo: both borders get a movable end point (tvgSwStroke.cpp:353-359)
      local list = {}
      newPiece(s, pieceFromLast(s, p), true, list)
      pendingSeg[#pendingSeg + 1] = list
      if #pendingSeg == 2 then
        local all = {}
        for _, l in ipairs(pendingSeg) do for _, o in ipairs(l) do all[#all + 1] = o end end
        local from = (#trail == 0) and P[0] or P[2]
        walk({from, center}, all)
        create(all, 0.4)
        pendingSeg = {}
      end
    else
      -- corner writes: _inside (tvgSwStroke.cpp:263-294), _outside (209-261)
      local list = {}
      newPiece(s, pieceFromLast(s, p), false, list)
      create(list, 0.16)
    end
  elseif k == "S" then
    -- _borderLineTo on a movable end: the last point is moved, not added (tvgSwStroke.cpp:131-133)
    local s, p = e[2], {e[3], e[4]}
    local st = side[s]
    local last = st.pieces[#st.pieces]
    local newMain = pathObj(map({last.from, p}, W), STYLE[s])
    scene:morph({last.main}, {newMain}, 0.28 * SL, "ease_in_out")
    last.main = newMain
    st.pts[#st.pts] = p
    st.samples[#st.samples] = p
    local list = {}
    -- in _outside the moved point is the miter point: both offset lines of the outer border meet here
    newDot(s, p, list, false, tag == "outside" and ACCENT or nil)
    st.open = false
    grow(list[1], 0.12)
    wait(0.1)
  elseif k == "C" then
    local s = e[2]
    local st = side[s]
    local from = st.pts[#st.pts]
    local pts = sampleCubic(from, {e[3], e[4]}, {e[5], e[6]}, {e[7], e[8]}, 12)
    if tag == "arc" then
      -- _cubicTo: one small arc, offset on both sides (tvgSwStroke.cpp:490-553)
      local list = {}
      newPiece(s, pts, false, list)
      pendingArc[#pendingArc + 1] = list
      if #pendingArc == 2 then
        local all = {}
        for _, l in ipairs(pendingArc) do for _, o in ipairs(l) do all[#all + 1] = o end end
        walk(sampleCubic(arcPts[1], arcPts[2], arcPts[3], arcPts[4], 12), all)
        create(all, 0.13)
        pendingArc = {}
      end
    else
      -- round cap: _addCap -> _borderArcTo (tvgSwStroke.cpp:581-584, 155-207)
      local list = {}
      newPiece(s, pts, false, list)
      create(list, 0.12)
    end
  elseif k == "R" then
    -- _addReverseLeft: borders[1] is appended to borders[0] in reverse (tvgSwStroke.cpp:598-632)
    local poly = {}
    local sm = side[1].samples
    for j = #sm, 1, -1 do poly[#poly + 1] = sm[j] end
    local copy = routeObj(map(poly, W), {stroke = INK, width = 1.6, layer = L_BORDER + 1, id = "b1rev"})
    local pen = penObj(map(poly, W))
    borderObjs[#borderObjs + 1] = copy
    create({copy, pen}, 0.34)
    scene:remove(pen)
    side[0].pts[#side[0].pts + 1] = side[1].pts[1]
    play({{target = labels[1], opacity = 0}}, 0.1)
  elseif k == "X" then
    -- _borderClose: borders[0] is one closed contour (tvgSwStroke.cpp:68-110, 695)
  end
end
light(nil)
wait(0.2)

-- ------------------------------------------------------------------ strokeExportOutline: borders -> one SwOutline
local export = show({labels[0]}, 0)
if walkPen then export[#export + 1] = {target = walkPen, opacity = 0} end
for _, t in ipairs(trail) do export[#export + 1] = {target = t, opacity = 0} end
for _, d in ipairs(dotObjs) do export[#export + 1] = {target = d, opacity = 0} end
for s = 0, 1 do
  for _, pc in ipairs(side[s].pieces) do export[#export + 1] = {target = pc.main, stroke = INK} end
end
mark("export")
stageLabel("strokeExportOutline", export)
wait(0.2)

-- ------------------------------------------------------------------ 4. rleRender -> shape.strokeRle (layer 2)
local clear = {}
for _, o in ipairs(borderObjs) do clear[#clear + 1] = {target = o, stroke = HAIR} end
for s = 0, 1 do
  for _, pc in ipairs(side[s].pieces) do clear[#clear + 1] = {target = pc.main, stroke = HAIR} end
end
stageLabel({"shape.strokeRle =", "  rleRender"}, clear)
local strokeSpans = allRows(MK2, strokeRows, sLo, sHi, L_SSPAN, nil, 0.12)
wait(0.3)

-- ------------------------------------------------------------------ 5. renderShape: rasterShape, then rasterStroke
-- _rasterSolidRle: coverage 255 -> rasterPixel32, else color*cov + dst*(255-cov) (tvgSwRaster.cpp:600-610)
local function coveredIn(rows, r)
  local covered = {}
  for _, sp in ipairs(rows[r] or {}) do
    for x = sp[1], sp[1] + sp[3] - 1 do covered[x] = sp[4] end
  end
  return covered
end

-- stroke pixels on layer 2: stroke ink at alpha = coverage, every pixel of each span
local strokePix = {}
for r = sLo, sHi do
  strokePix[r] = {}
  for _, sp in ipairs(strokeRows[r] or {}) do
    for x = sp[1], sp[1] + sp[3] - 1 do
      strokePix[r][#strokePix[r] + 1] = G2:rectangle {center = W({x + 0.5, r + 0.5}), size = {S, S},
        fill = string.format("%s%02x", "#1b1a18", sp[4]), layer = L_PIX2, opacity = 0, id = id("spx2")}
    end
  end
end

-- rasterShape reads shape.rle on layer 1: the borders and the outline go
local gone = {}
for _, o in ipairs(borderObjs) do gone[#gone + 1] = {target = o, opacity = 0} end
for s = 0, 1 do
  for _, pc in ipairs(side[s].pieces) do gone[#gone + 1] = {target = pc.main, opacity = 0} end
end
for _, o in ipairs(outline) do gone[#gone + 1] = {target = o, opacity = 0} end
for _, o in ipairs(anchors) do gone[#gone + 1] = {target = o, opacity = 0} end
stageLabel("rasterShape", gone, toRow(MK1, fLo, {}, 1))
wait(0.2)
for r = fLo, fHi do
  local list = toRow(MK1, r, {})
  for _, g in ipairs(fillSpans[r] or {}) do list[#list + 1] = {target = g, opacity = 0} end
  local covered = coveredIn(fillRows, r)
  for _, px in ipairs(pixRow[r]) do
    if covered[px.x] then list[#list + 1] = {target = px.obj, opacity = 1, fill = px.fill} end
  end
  play(list, 0.14, "ease_in_out")
end
wait(0.2)

-- rasterStroke reads shape.strokeRle on layer 2
stageLabel("rasterStroke", show({MK1.wash, MK1.ptr}, 0), toRow(MK2, sLo, {}, 1))
wait(0.2)
for r = sLo, sHi do
  local list = toRow(MK2, r, {})
  for _, g in ipairs(strokeSpans[r] or {}) do list[#list + 1] = {target = g, opacity = 0} end
  for _, o in ipairs(strokePix[r]) do list[#list + 1] = {target = o, opacity = 1} end
  play(list, 0.14, "ease_in_out")
end
play(show({MK2.wash, MK2.ptr}, 0), 0.1)
wait(0.2)

-- layer 2 comes down onto layer 1: the stroke pixels land over the fill pixels
tilt(1, 1, GAP, 0, 0.8, function(list, f)
  list[#list + 1] = {target = grid2, opacity = 1 - f}
  list[#list + 1] = {target = lab2, opacity = 1 - f}
end)
-- the merged pixels are the SwCanvas buffer: PX_FINAL
local merge = {}
for r = sLo, sHi do
  for _, o in ipairs(strokePix[r]) do merge[#merge + 1] = {target = o, opacity = 0} end
  local covered = coveredIn(strokeRows, r)
  for _, px in ipairs(pixRow[r]) do
    if covered[px.x] then merge[#merge + 1] = {target = px.obj, opacity = 1, fill = px.final} end
  end
end
play(merge, 0.2)
wait(0.2)

-- back to the flat view
local fin = concat(show({lab1}, 0), show(stage, 0))
for _, l in ipairs(cmdText) do for _, t in ipairs(l) do fin[#fin + 1] = {target = t, fill = INK_FAINT} end end
play(fin, 0.25, "ease_in_out")
tilt(1, 0, 0, 0, 1.4, function(list, f) list[#list + 1] = {target = frame1, opacity = 1 - f} end)
wait(0.2)
return scene
