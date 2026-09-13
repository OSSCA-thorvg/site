local refs = {}
local scene = tmath.scene {["camera"]={["height"]=10.4,["mode"]="fixed",["view"]="2d"},["fps"]=30,["height"]=1040,["loop"]=false,["theme"]={["background"]="#f1f1f1",["preset"]="pro_white"},["width"]=1280}
refs[1] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-0",["layer"]=40,["point"]={-5.92,4.77},["role"]="text",["size"]=30,["text"]="Surface operations"}
refs[2] = scene:text {["align"]={1,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-1",["layer"]=40,["point"]={5.92,4.77},["role"]="text",["size"]=22,["text"]="CPU Engine"}
refs[3] = scene:line {["from"]={-5.92,4.23},["id"]="surface-rule-2",["layer"]=5,["stroke"]="#cccccc",["to"]={5.92,4.23},["width"]=1}
refs[4] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-3",["layer"]=40,["point"]={-5.92,3.88},["role"]="text",["size"]=25,["text"]="Initialize surface"}
refs[5] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-4",["layer"]=40,["point"]={-5.92,3.52},["role"]="text",["size"]=19,["text"]="rasterClear()"}
refs[6] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-5",["layer"]=40,["point"]={-5.92,3.2},["role"]="text",["size"]=19,["text"]="rasterCompositor()"}
refs[7] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-6",["layer"]=40,["point"]={-5.92,2.85},["role"]="text",["size"]=18,["text"]="Clear region · configure color / alpha helpers"}
refs[8] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-7",["layer"]=40,["point"]={0.9,3.89},["role"]="text",["size"]=19,["text"]="Existing pixels"}
refs[9] = scene:arrow {["from"]={2.18,3.23},["id"]="surface-arrow-8",["layer"]=20,["stroke"]="#191919",["tip"]=10,["to"]={3.18,3.23},["width"]=2}
refs[10] = scene:group {["id"]="surface-result-9",["opacity"]=0}
refs[11] = scene:group {["id"]="surface-caption-10",["opacity"]=0}
refs[12] = refs[11]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-11",["layer"]=40,["point"]={4.5,3.89},["role"]="text",["size"]=19,["text"]="Cleared region · zero"}
refs[13] = scene:rectangle {["center"]={0.3,3.53},["fill"]="#42647d",["id"]="surface-pixel-12",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[14] = scene:rectangle {["center"]={0.6,3.53},["fill"]="#68869b",["id"]="surface-pixel-13",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[15] = scene:rectangle {["center"]={0.9,3.53},["fill"]="#b4c8d5",["id"]="surface-pixel-14",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[16] = scene:rectangle {["center"]={1.2,3.53},["fill"]="#719b90",["id"]="surface-pixel-15",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[17] = scene:rectangle {["center"]={1.5,3.53},["fill"]="#b2c9b4",["id"]="surface-pixel-16",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[18] = scene:rectangle {["center"]={0.3,3.23},["fill"]="#c4a26b",["id"]="surface-pixel-17",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[19] = scene:rectangle {["center"]={0.6,3.23},["fill"]="#42647d",["id"]="surface-pixel-18",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[20] = scene:rectangle {["center"]={0.9,3.23},["fill"]="#68869b",["id"]="surface-pixel-19",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[21] = scene:rectangle {["center"]={1.2,3.23},["fill"]="#b4c8d5",["id"]="surface-pixel-20",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[22] = scene:rectangle {["center"]={1.5,3.23},["fill"]="#719b90",["id"]="surface-pixel-21",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[23] = scene:rectangle {["center"]={0.3,2.93},["fill"]="#b2c9b4",["id"]="surface-pixel-22",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[24] = scene:rectangle {["center"]={0.6,2.93},["fill"]="#c4a26b",["id"]="surface-pixel-23",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[25] = scene:rectangle {["center"]={0.9,2.93},["fill"]="#42647d",["id"]="surface-pixel-24",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[26] = scene:rectangle {["center"]={1.2,2.93},["fill"]="#68869b",["id"]="surface-pixel-25",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[27] = scene:rectangle {["center"]={1.5,2.93},["fill"]="#b4c8d5",["id"]="surface-pixel-26",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[28] = refs[10]:rectangle {["center"]={3.9,3.53},["fill"]="#42647d",["id"]="surface-pixel-27",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[29] = refs[10]:rectangle {["center"]={4.2,3.53},["fill"]="#68869b",["id"]="surface-pixel-28",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[30] = refs[10]:rectangle {["center"]={4.5,3.53},["fill"]="#b4c8d5",["id"]="surface-pixel-29",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[31] = refs[10]:rectangle {["center"]={4.8,3.53},["fill"]="#719b90",["id"]="surface-pixel-30",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[32] = refs[10]:rectangle {["center"]={5.1,3.53},["fill"]="#b2c9b4",["id"]="surface-pixel-31",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[33] = refs[10]:rectangle {["center"]={3.9,3.23},["fill"]="#c4a26b",["id"]="surface-pixel-32",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[34] = refs[10]:rectangle {["center"]={4.2,3.23},["fill"]="#42647d",["id"]="surface-pixel-33",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[35] = refs[10]:rectangle {["center"]={4.5,3.23},["fill"]="#68869b",["id"]="surface-pixel-34",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[36] = refs[10]:rectangle {["center"]={4.8,3.23},["fill"]="#b4c8d5",["id"]="surface-pixel-35",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[37] = refs[10]:rectangle {["center"]={5.1,3.23},["fill"]="#719b90",["id"]="surface-pixel-36",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[38] = refs[10]:rectangle {["center"]={3.9,2.93},["fill"]="#b2c9b4",["id"]="surface-pixel-37",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[39] = refs[10]:rectangle {["center"]={4.2,2.93},["fill"]="#c4a26b",["id"]="surface-pixel-38",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[40] = refs[10]:rectangle {["center"]={4.5,2.93},["fill"]="#42647d",["id"]="surface-pixel-39",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[41] = refs[10]:rectangle {["center"]={4.8,2.93},["fill"]="#68869b",["id"]="surface-pixel-40",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[42] = refs[10]:rectangle {["center"]={5.1,2.93},["fill"]="#b4c8d5",["id"]="surface-pixel-41",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[43] = scene:line {["from"]={-5.92,2.43},["id"]="surface-rule-42",["layer"]=5,["stroke"]="#cccccc",["to"]={5.92,2.43},["width"]=1}
refs[44] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-43",["layer"]=40,["point"]={-5.92,2.08},["role"]="text",["size"]=25,["text"]="Prepare input"}
refs[45] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-44",["layer"]=40,["point"]={-5.92,1.72},["role"]="text",["size"]=19,["text"]="rasterConvertCS()"}
refs[46] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-45",["layer"]=40,["point"]={-5.92,1.4},["role"]="text",["size"]=19,["text"]="rasterPremultiply()"}
refs[47] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-46",["layer"]=40,["point"]={-5.92,1.05},["role"]="text",["size"]=18,["text"]="Image preparation · channel order and alpha"}
refs[48] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-47",["layer"]=40,["point"]={0.9,2.09},["role"]="text",["size"]=19,["text"]="ABGR · straight"}
refs[49] = scene:arrow {["from"]={2.18,1.43},["id"]="surface-arrow-48",["layer"]=20,["stroke"]="#191919",["tip"]=10,["to"]={3.18,1.43},["width"]=2}
refs[50] = scene:group {["id"]="surface-result-49",["opacity"]=0}
refs[51] = scene:group {["id"]="surface-caption-50",["opacity"]=0}
refs[52] = refs[51]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-51",["layer"]=40,["point"]={4.5,2.09},["role"]="text",["size"]=19,["text"]="ARGB · premultiplied"}
refs[53] = scene:group {["id"]="surface-channel-52"}
refs[54] = refs[53]:rectangle {["center"]={0.18,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-53",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[55] = refs[53]:rectangle {["center"]={0.18,1.315529411764706},["fill"]="#606060",["id"]="surface-pixel-54",["layer"]=18,["size"]={0.32,0.27105882352941174},["stroke"]="#00000000",["width"]=0}
refs[56] = refs[53]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-55",["layer"]=40,["point"]={0.18,0.99},["role"]="text",["size"]=18,["text"]="A"}
refs[57] = scene:group {["id"]="surface-channel-56"}
refs[58] = refs[57]:rectangle {["center"]={0.66,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-57",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[59] = refs[57]:rectangle {["center"]={0.66,1.243529411764706},["fill"]="#688ca8",["id"]="surface-pixel-58",["layer"]=18,["size"]={0.32,0.12705882352941175},["stroke"]="#00000000",["width"]=0}
refs[60] = refs[57]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-59",["layer"]=40,["point"]={0.66,0.99},["role"]="text",["size"]=18,["text"]="B"}
refs[61] = scene:group {["id"]="surface-channel-60"}
refs[62] = refs[61]:rectangle {["center"]={1.14,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-61",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[63] = refs[61]:rectangle {["center"]={1.14,1.3070588235294116},["fill"]="#648b72",["id"]="surface-pixel-62",["layer"]=18,["size"]={0.32,0.2541176470588235},["stroke"]="#00000000",["width"]=0}
refs[64] = refs[61]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-63",["layer"]=40,["point"]={1.14,0.99},["role"]="text",["size"]=18,["text"]="G"}
refs[65] = scene:group {["id"]="surface-channel-64"}
refs[66] = refs[65]:rectangle {["center"]={1.62,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-65",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[67] = refs[65]:rectangle {["center"]={1.62,1.4341176470588237},["fill"]="#b06c66",["id"]="surface-pixel-66",["layer"]=18,["size"]={0.32,0.508235294117647},["stroke"]="#00000000",["width"]=0}
refs[68] = refs[65]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-67",["layer"]=40,["point"]={1.62,0.99},["role"]="text",["size"]=18,["text"]="R"}
refs[69] = refs[50]:group {["id"]="surface-channel-68"}
refs[70] = refs[69]:rectangle {["center"]={3.78,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-69",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[71] = refs[69]:rectangle {["center"]={3.78,1.315529411764706},["fill"]="#606060",["id"]="surface-pixel-70",["layer"]=18,["size"]={0.32,0.27105882352941174},["stroke"]="#00000000",["width"]=0}
refs[72] = refs[50]:group {["id"]="surface-channel-71"}
refs[73] = refs[72]:rectangle {["center"]={4.26,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-72",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[74] = refs[72]:rectangle {["center"]={4.26,1.243529411764706},["fill"]="#688ca8",["id"]="surface-pixel-73",["layer"]=18,["size"]={0.32,0.12705882352941175},["stroke"]="#00000000",["width"]=0}
refs[75] = refs[50]:group {["id"]="surface-channel-74"}
refs[76] = refs[75]:rectangle {["center"]={4.74,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-75",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[77] = refs[75]:rectangle {["center"]={4.74,1.3070588235294116},["fill"]="#648b72",["id"]="surface-pixel-76",["layer"]=18,["size"]={0.32,0.2541176470588235},["stroke"]="#00000000",["width"]=0}
refs[78] = refs[50]:group {["id"]="surface-channel-77"}
refs[79] = refs[78]:rectangle {["center"]={5.22,1.45},["fill"]="#e0e0e0",["id"]="surface-pixel-78",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[80] = refs[78]:rectangle {["center"]={5.22,1.4341176470588237},["fill"]="#b06c66",["id"]="surface-pixel-79",["layer"]=18,["size"]={0.32,0.508235294117647},["stroke"]="#00000000",["width"]=0}
refs[81] = refs[51]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-80",["layer"]=40,["point"]={3.78,0.99},["role"]="text",["size"]=18,["text"]="A"}
refs[82] = refs[51]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-81",["layer"]=40,["point"]={4.26,0.99},["role"]="text",["size"]=18,["text"]="R"}
refs[83] = refs[51]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-82",["layer"]=40,["point"]={4.74,0.99},["role"]="text",["size"]=18,["text"]="G"}
refs[84] = refs[51]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-83",["layer"]=40,["point"]={5.22,0.99},["role"]="text",["size"]=18,["text"]="B"}
refs[85] = scene:line {["from"]={-5.92,0.63},["id"]="surface-rule-84",["layer"]=5,["stroke"]="#cccccc",["to"]={5.92,0.63},["width"]=1}
refs[86] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-85",["layer"]=40,["point"]={-5.92,0.28},["role"]="text",["size"]=25,["text"]="Write pixels"}
refs[87] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-86",["layer"]=40,["point"]={-5.92,-0.08},["role"]="text",["size"]=19,["text"]="rasterPixel32() · rasterGrayscale8()"}
refs[88] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-87",["layer"]=40,["point"]={-5.92,-0.4},["role"]="text",["size"]=19,["text"]="rasterTranslucentPixel32()"}
refs[89] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-88",["layer"]=40,["point"]={-5.92,-0.75},["role"]="text",["size"]=18,["text"]="Draw · 32-bit color / 8-bit value"}
refs[90] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-89",["layer"]=40,["point"]={0.9,0.29},["role"]="text",["size"]=19,["text"]="Destination"}
refs[91] = scene:arrow {["from"]={2.18,-0.37},["id"]="surface-arrow-90",["layer"]=20,["stroke"]="#191919",["tip"]=10,["to"]={3.18,-0.37},["width"]=2}
refs[92] = scene:group {["id"]="surface-result-91",["opacity"]=0}
refs[93] = scene:group {["id"]="surface-caption-92",["opacity"]=0}
refs[94] = refs[93]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-93",["layer"]=40,["point"]={4.5,0.29},["role"]="text",["size"]=19,["text"]="Written span"}
refs[95] = scene:rectangle {["center"]={0.3,-0.07},["fill"]="#dedede",["id"]="surface-pixel-94",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[96] = scene:rectangle {["center"]={0.6,-0.07},["fill"]="#dedede",["id"]="surface-pixel-95",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[97] = scene:rectangle {["center"]={0.9,-0.07},["fill"]="#dedede",["id"]="surface-pixel-96",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[98] = scene:rectangle {["center"]={1.2,-0.07},["fill"]="#dedede",["id"]="surface-pixel-97",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[99] = scene:rectangle {["center"]={1.5,-0.07},["fill"]="#dedede",["id"]="surface-pixel-98",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[100] = scene:rectangle {["center"]={0.3,-0.37},["fill"]="#dedede",["id"]="surface-pixel-99",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[101] = scene:rectangle {["center"]={0.6,-0.37},["fill"]="#dedede",["id"]="surface-pixel-100",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[102] = scene:rectangle {["center"]={0.9,-0.37},["fill"]="#dedede",["id"]="surface-pixel-101",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[103] = scene:rectangle {["center"]={1.2,-0.37},["fill"]="#dedede",["id"]="surface-pixel-102",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[104] = scene:rectangle {["center"]={1.5,-0.37},["fill"]="#dedede",["id"]="surface-pixel-103",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[105] = scene:rectangle {["center"]={0.3,-0.67},["fill"]="#dedede",["id"]="surface-pixel-104",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[106] = scene:rectangle {["center"]={0.6,-0.67},["fill"]="#dedede",["id"]="surface-pixel-105",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[107] = scene:rectangle {["center"]={0.9,-0.67},["fill"]="#dedede",["id"]="surface-pixel-106",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[108] = scene:rectangle {["center"]={1.2,-0.67},["fill"]="#dedede",["id"]="surface-pixel-107",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[109] = scene:rectangle {["center"]={1.5,-0.67},["fill"]="#dedede",["id"]="surface-pixel-108",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[110] = refs[92]:rectangle {["center"]={3.9,-0.07},["fill"]="#dedede",["id"]="surface-pixel-109",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[111] = refs[92]:rectangle {["center"]={4.2,-0.07},["fill"]="#dedede",["id"]="surface-pixel-110",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[112] = refs[92]:rectangle {["center"]={4.5,-0.07},["fill"]="#dedede",["id"]="surface-pixel-111",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[113] = refs[92]:rectangle {["center"]={4.8,-0.07},["fill"]="#dedede",["id"]="surface-pixel-112",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[114] = refs[92]:rectangle {["center"]={5.1,-0.07},["fill"]="#dedede",["id"]="surface-pixel-113",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[115] = refs[92]:rectangle {["center"]={3.9,-0.37},["fill"]="#dedede",["id"]="surface-pixel-114",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[116] = refs[92]:rectangle {["center"]={4.2,-0.37},["fill"]="#dedede",["id"]="surface-pixel-115",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[117] = refs[92]:rectangle {["center"]={4.5,-0.37},["fill"]="#dedede",["id"]="surface-pixel-116",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[118] = refs[92]:rectangle {["center"]={4.8,-0.37},["fill"]="#dedede",["id"]="surface-pixel-117",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[119] = refs[92]:rectangle {["center"]={5.1,-0.37},["fill"]="#dedede",["id"]="surface-pixel-118",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[120] = refs[92]:rectangle {["center"]={3.9,-0.67},["fill"]="#dedede",["id"]="surface-pixel-119",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[121] = refs[92]:rectangle {["center"]={4.2,-0.67},["fill"]="#dedede",["id"]="surface-pixel-120",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[122] = refs[92]:rectangle {["center"]={4.5,-0.67},["fill"]="#dedede",["id"]="surface-pixel-121",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[123] = refs[92]:rectangle {["center"]={4.8,-0.67},["fill"]="#dedede",["id"]="surface-pixel-122",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[124] = refs[92]:rectangle {["center"]={5.1,-0.67},["fill"]="#dedede",["id"]="surface-pixel-123",["layer"]=18,["size"]={0.27,0.27},["stroke"]="#00000000",["width"]=0}
refs[125] = scene:line {["from"]={-5.92,-1.17},["id"]="surface-rule-124",["layer"]=5,["stroke"]="#cccccc",["to"]={5.92,-1.17},["width"]=1}
refs[126] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-125",["layer"]=40,["point"]={-5.92,-1.52},["role"]="text",["size"]=25,["text"]="Rearrange buffer"}
refs[127] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-126",["layer"]=40,["point"]={-5.92,-1.88},["role"]="text",["size"]=19,["text"]="rasterXYFlip()"}
refs[128] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-127",["layer"]=40,["point"]={-5.92,-2.55},["role"]="text",["size"]=18,["text"]="Effects · transpose for the other axis"}
refs[129] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-128",["layer"]=40,["point"]={0.9,-1.51},["role"]="text",["size"]=19,["text"]="3 columns × 2 rows"}
refs[130] = scene:arrow {["from"]={2.18,-2.17},["id"]="surface-arrow-129",["layer"]=20,["stroke"]="#191919",["tip"]=10,["to"]={3.18,-2.17},["width"]=2}
refs[131] = scene:group {["id"]="surface-result-130",["opacity"]=0}
refs[132] = scene:group {["id"]="surface-caption-131",["opacity"]=0}
refs[133] = refs[132]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-132",["layer"]=40,["point"]={4.5,-1.51},["role"]="text",["size"]=19,["text"]="2 columns × 3 rows"}
refs[134] = scene:rectangle {["center"]={0.58,-2.01},["fill"]="#42647d",["id"]="surface-pixel-133",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[135] = scene:rectangle {["center"]={0.9,-2.01},["fill"]="#68869b",["id"]="surface-pixel-134",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[136] = scene:rectangle {["center"]={1.22,-2.01},["fill"]="#b4c8d5",["id"]="surface-pixel-135",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[137] = scene:rectangle {["center"]={0.58,-2.33},["fill"]="#719b90",["id"]="surface-pixel-136",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[138] = scene:rectangle {["center"]={0.9,-2.33},["fill"]="#b2c9b4",["id"]="surface-pixel-137",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[139] = scene:rectangle {["center"]={1.22,-2.33},["fill"]="#c4a26b",["id"]="surface-pixel-138",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[140] = refs[131]:rectangle {["center"]={4.18,-2.01},["fill"]="#42647d",["id"]="surface-pixel-139",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[141] = refs[131]:rectangle {["center"]={4.5,-2.01},["fill"]="#68869b",["id"]="surface-pixel-140",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[142] = refs[131]:rectangle {["center"]={4.82,-2.01},["fill"]="#b4c8d5",["id"]="surface-pixel-141",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[143] = refs[131]:rectangle {["center"]={4.18,-2.33},["fill"]="#719b90",["id"]="surface-pixel-142",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[144] = refs[131]:rectangle {["center"]={4.5,-2.33},["fill"]="#b2c9b4",["id"]="surface-pixel-143",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[145] = refs[131]:rectangle {["center"]={4.82,-2.33},["fill"]="#c4a26b",["id"]="surface-pixel-144",["layer"]=18,["size"]={0.29,0.29},["stroke"]="#00000000",["width"]=0}
refs[146] = scene:line {["from"]={-5.92,-2.97},["id"]="surface-rule-145",["layer"]=5,["stroke"]="#cccccc",["to"]={5.92,-2.97},["width"]=1}
refs[147] = scene:text {["align"]={0,0.5},["fill"]="#191919",["font"]="Pretendard",["id"]="surface-text-146",["layer"]=40,["point"]={-5.92,-3.32},["role"]="text",["size"]=25,["text"]="Convert output"}
refs[148] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-147",["layer"]=40,["point"]={-5.92,-3.68},["role"]="text",["size"]=19,["text"]="rasterUnpremultiply()"}
refs[149] = scene:text {["align"]={0,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-148",["layer"]=40,["point"]={-5.92,-4.35},["role"]="text",["size"]=18,["text"]="postRender() · only for straight-alpha targets"}
refs[150] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-149",["layer"]=40,["point"]={0.9,-3.31},["role"]="text",["size"]=19,["text"]="Premultiplied"}
refs[151] = scene:arrow {["from"]={2.18,-3.97},["id"]="surface-arrow-150",["layer"]=20,["stroke"]="#191919",["tip"]=10,["to"]={3.18,-3.97},["width"]=2}
refs[152] = scene:group {["id"]="surface-result-151",["opacity"]=0}
refs[153] = scene:group {["id"]="surface-caption-152",["opacity"]=0}
refs[154] = refs[153]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-153",["layer"]=40,["point"]={4.5,-3.31},["role"]="text",["size"]=19,["text"]="Straight alpha"}
refs[155] = scene:group {["id"]="surface-channel-154"}
refs[156] = refs[155]:rectangle {["center"]={0.18,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-155",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[157] = refs[155]:rectangle {["center"]={0.18,-4.084470588235295},["fill"]="#606060",["id"]="surface-pixel-156",["layer"]=18,["size"]={0.32,0.27105882352941174},["stroke"]="#00000000",["width"]=0}
refs[158] = refs[155]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-157",["layer"]=40,["point"]={0.18,-4.41},["role"]="text",["size"]=18,["text"]="A"}
refs[159] = scene:group {["id"]="surface-channel-158"}
refs[160] = refs[159]:rectangle {["center"]={0.66,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-159",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[161] = refs[159]:rectangle {["center"]={0.66,-4.092941176470588},["fill"]="#b06c66",["id"]="surface-pixel-160",["layer"]=18,["size"]={0.32,0.2541176470588235},["stroke"]="#00000000",["width"]=0}
refs[162] = refs[159]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-161",["layer"]=40,["point"]={0.66,-4.41},["role"]="text",["size"]=18,["text"]="R"}
refs[163] = scene:group {["id"]="surface-channel-162"}
refs[164] = refs[163]:rectangle {["center"]={1.14,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-163",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[165] = refs[163]:rectangle {["center"]={1.14,-4.156470588235294},["fill"]="#648b72",["id"]="surface-pixel-164",["layer"]=18,["size"]={0.32,0.12705882352941175},["stroke"]="#00000000",["width"]=0}
refs[166] = refs[163]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-165",["layer"]=40,["point"]={1.14,-4.41},["role"]="text",["size"]=18,["text"]="G"}
refs[167] = scene:group {["id"]="surface-channel-166"}
refs[168] = refs[167]:rectangle {["center"]={1.62,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-167",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[169] = refs[167]:rectangle {["center"]={1.62,-4.188235294117647},["fill"]="#688ca8",["id"]="surface-pixel-168",["layer"]=18,["size"]={0.32,0.06352941176470588},["stroke"]="#00000000",["width"]=0}
refs[170] = refs[167]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-169",["layer"]=40,["point"]={1.62,-4.41},["role"]="text",["size"]=18,["text"]="B"}
refs[171] = refs[152]:group {["id"]="surface-channel-170"}
refs[172] = refs[171]:rectangle {["center"]={3.78,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-171",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[173] = refs[171]:rectangle {["center"]={3.78,-4.084470588235295},["fill"]="#606060",["id"]="surface-pixel-172",["layer"]=18,["size"]={0.32,0.27105882352941174},["stroke"]="#00000000",["width"]=0}
refs[174] = refs[171]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-173",["layer"]=40,["point"]={3.78,-4.41},["role"]="text",["size"]=18,["text"]="A"}
refs[175] = refs[152]:group {["id"]="surface-channel-174"}
refs[176] = refs[175]:rectangle {["center"]={4.26,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-175",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[177] = refs[175]:rectangle {["center"]={4.26,-4.092941176470588},["fill"]="#b06c66",["id"]="surface-pixel-176",["layer"]=18,["size"]={0.32,0.2541176470588235},["stroke"]="#00000000",["width"]=0}
refs[178] = refs[175]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-177",["layer"]=40,["point"]={4.26,-4.41},["role"]="text",["size"]=18,["text"]="R"}
refs[179] = refs[152]:group {["id"]="surface-channel-178"}
refs[180] = refs[179]:rectangle {["center"]={4.74,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-179",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[181] = refs[179]:rectangle {["center"]={4.74,-4.156470588235294},["fill"]="#648b72",["id"]="surface-pixel-180",["layer"]=18,["size"]={0.32,0.12705882352941175},["stroke"]="#00000000",["width"]=0}
refs[182] = refs[179]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-181",["layer"]=40,["point"]={4.74,-4.41},["role"]="text",["size"]=18,["text"]="G"}
refs[183] = refs[152]:group {["id"]="surface-channel-182"}
refs[184] = refs[183]:rectangle {["center"]={5.22,-3.95},["fill"]="#e0e0e0",["id"]="surface-pixel-183",["layer"]=18,["size"]={0.32,0.54},["stroke"]="#00000000",["width"]=0}
refs[185] = refs[183]:rectangle {["center"]={5.22,-4.188235294117647},["fill"]="#688ca8",["id"]="surface-pixel-184",["layer"]=18,["size"]={0.32,0.06352941176470588},["stroke"]="#00000000",["width"]=0}
refs[186] = refs[183]:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-185",["layer"]=40,["point"]={5.22,-4.41},["role"]="text",["size"]=18,["text"]="B"}
refs[187] = scene:text {["align"]={0.5,0.5},["fill"]="#686868",["font"]="Pretendard",["id"]="surface-text-186",["layer"]=40,["point"]={0,-4.88},["role"]="text",["size"]=19,["text"]="Independent examples · each operation runs where needed"}
scene:wait(0.6)
scene:play({{target=refs[10],opacity=1}},0.2,"smooth",0)
scene:play({{target=refs[34],fill="#dedede"},{target=refs[35],fill="#dedede"},{target=refs[36],fill="#dedede"},{target=refs[39],fill="#dedede"},{target=refs[40],fill="#dedede"},{target=refs[41],fill="#dedede"}},0.85,"ease_in_out",0)
scene:play({{target=refs[11],opacity=1}},0.2,"smooth",0)
scene:wait(1)
scene:play({{target=refs[50],opacity=1}},0.2,"smooth",0)
scene:play({{target=refs[69],shift={0,0}},{target=refs[72],shift={0.96,0}},{target=refs[75],shift={0,0}},{target=refs[78],shift={-0.96,0}}},0.85,"ease_in_out",0)
scene:play({{target=refs[71],transform={1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}},{target=refs[74],transform={1,0,0,0,0,0.5,0,0.59,0,0,1,0,0,0,0,1}},{target=refs[77],transform={1,0,0,0,0,0.5,0,0.59,0,0,1,0,0,0,0,1}},{target=refs[80],transform={1,0,0,0,0,0.5,0,0.59,0,0,1,0,0,0,0,1}}},0.6,"ease_in_out",0)
scene:play({{target=refs[51],opacity=1}},0.2,"smooth",0)
scene:wait(1)
scene:play({{target=refs[92],opacity=1}},0.2,"smooth",0)
scene:play({{target=refs[115],fill="#42647d"},{target=refs[116],fill="#42647d"},{target=refs[117],fill="#42647d"},{target=refs[118],fill="#42647d"},{target=refs[119],fill="#42647d"}},0.85,"ease_in_out",0)
scene:play({{target=refs[93],opacity=1}},0.2,"smooth",0)
scene:wait(1)
scene:play({{target=refs[131],opacity=1}},0.2,"smooth",0)
scene:play({{target=refs[140],shift={0.16,0.16}},{target=refs[141],shift={-0.16,-0.16}},{target=refs[142],shift={-0.48,-0.48}},{target=refs[143],shift={0.48,0.48}},{target=refs[144],shift={0.16,0.16}},{target=refs[145],shift={-0.16,-0.16}}},0.85,"ease_in_out",0)
scene:play({{target=refs[132],opacity=1}},0.2,"smooth",0)
scene:wait(1)
scene:play({{target=refs[152],opacity=1}},0.2,"smooth",0)
scene:play({{target=refs[173],transform={1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}},{target=refs[177],transform={1,0,0,0,0,1.9916666666666667,0,4.184833333333334,0,0,1,0,0,0,0,1}},{target=refs[181],transform={1,0,0,0,0,1.9833333333333334,0,4.149666666666667,0,0,1,0,0,0,0,1}},{target=refs[185],transform={1,0,0,0,0,1.9666666666666666,0,4.079333333333333,0,0,1,0,0,0,0,1}}},0.85,"ease_in_out",0)
scene:play({{target=refs[153],opacity=1}},0.2,"smooth",0)
scene:wait(1)
scene:wait(1.5)
return scene
