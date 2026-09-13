local refs = {}
local scene = tmath.scene {["camera"]={["height"]=6,["mode"]="fixed",["view"]="2d"},["fps"]=30,["height"]=600,["loop"]=false,["theme"]="pro_white",["width"]=960}
refs[1] = scene:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#f5f7fa",["id"]="downscale-source-back-0",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[2] = scene:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#3585cbff",["id"]="downscale-source-pixel-0",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[3] = scene:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#e8edf2",["id"]="downscale-source-back-1",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[4] = scene:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#3e85c7ff",["id"]="downscale-source-pixel-1",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[5] = scene:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#f5f7fa",["id"]="downscale-source-back-2",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[6] = scene:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#4785c3ff",["id"]="downscale-source-pixel-2",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[7] = scene:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#e8edf2",["id"]="downscale-source-back-3",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[8] = scene:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#5085bfff",["id"]="downscale-source-pixel-3",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[9] = scene:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#f5f7fa",["id"]="downscale-source-back-4",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[10] = scene:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#fad635ff",["id"]="downscale-source-pixel-4",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[11] = scene:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#e8edf2",["id"]="downscale-source-back-5",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[12] = scene:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#fada35ff",["id"]="downscale-source-pixel-5",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[13] = scene:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-6",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[14] = scene:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#358ecbff",["id"]="downscale-source-pixel-6",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[15] = scene:rectangle {["center"]={-3.525,0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-7",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[16] = scene:rectangle {["center"]={-3.525,0.775},["fill"]="#3e8ec7ff",["id"]="downscale-source-pixel-7",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[17] = scene:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-8",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[18] = scene:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#478ec3ff",["id"]="downscale-source-pixel-8",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[19] = scene:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-9",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[20] = scene:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#508ebfff",["id"]="downscale-source-pixel-9",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[21] = scene:rectangle {["center"]={-1.975,0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-10",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[22] = scene:rectangle {["center"]={-1.975,0.775},["fill"]="#fad63eff",["id"]="downscale-source-pixel-10",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[23] = scene:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-11",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[24] = scene:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#fada3eff",["id"]="downscale-source-pixel-11",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[25] = scene:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#f5f7fa",["id"]="downscale-source-back-12",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[26] = scene:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#3597cbff",["id"]="downscale-source-pixel-12",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[27] = scene:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#e8edf2",["id"]="downscale-source-back-13",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[28] = scene:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#3e97c7ff",["id"]="downscale-source-pixel-13",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[29] = scene:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#f5f7fa",["id"]="downscale-source-back-14",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[30] = scene:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#4797c3ff",["id"]="downscale-source-pixel-14",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[31] = scene:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#e8edf2",["id"]="downscale-source-back-15",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[32] = scene:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#5097bfff",["id"]="downscale-source-pixel-15",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[33] = scene:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#f5f7fa",["id"]="downscale-source-back-16",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[34] = scene:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#5997bbff",["id"]="downscale-source-pixel-16",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[35] = scene:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#e8edf2",["id"]="downscale-source-back-17",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[36] = scene:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#6297b7ff",["id"]="downscale-source-pixel-17",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[37] = scene:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#e8edf2",["id"]="downscale-source-back-18",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[38] = scene:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#35a0cbff",["id"]="downscale-source-pixel-18",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[39] = scene:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="downscale-source-back-19",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[40] = scene:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#3ea0c7ff",["id"]="downscale-source-pixel-19",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[41] = scene:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#e8edf2",["id"]="downscale-source-back-20",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[42] = scene:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#47a0c3ff",["id"]="downscale-source-pixel-20",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[43] = scene:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="downscale-source-back-21",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[44] = scene:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#50a0bfff",["id"]="downscale-source-pixel-21",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[45] = scene:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#e8edf2",["id"]="downscale-source-back-22",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[46] = scene:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#399d5cff",["id"]="downscale-source-pixel-22",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[47] = scene:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="downscale-source-back-23",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[48] = scene:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#3e9d5fff",["id"]="downscale-source-pixel-23",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[49] = scene:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-24",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[50] = scene:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#2191b5ff",["id"]="downscale-source-pixel-24",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[51] = scene:rectangle {["center"]={-3.525,-0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-25",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[52] = scene:rectangle {["center"]={-3.525,-0.775},["fill"]="#2991beff",["id"]="downscale-source-pixel-25",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[53] = scene:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-26",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[54] = scene:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#2fa556ff",["id"]="downscale-source-pixel-26",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[55] = scene:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-27",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[56] = scene:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#34a559ff",["id"]="downscale-source-pixel-27",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[57] = scene:rectangle {["center"]={-1.975,-0.775},["fill"]="#f5f7fa",["id"]="downscale-source-back-28",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[58] = scene:rectangle {["center"]={-1.975,-0.775},["fill"]="#39a55cff",["id"]="downscale-source-pixel-28",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[59] = scene:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#e8edf2",["id"]="downscale-source-back-29",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[60] = scene:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#3ea55fff",["id"]="downscale-source-pixel-29",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[61] = scene:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#e8edf2",["id"]="downscale-source-back-30",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[62] = scene:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#219cb5ff",["id"]="downscale-source-pixel-30",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[63] = scene:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="downscale-source-back-31",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[64] = scene:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#299cbeff",["id"]="downscale-source-pixel-31",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[65] = scene:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#e8edf2",["id"]="downscale-source-back-32",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[66] = scene:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#2fad56ff",["id"]="downscale-source-pixel-32",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[67] = scene:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="downscale-source-back-33",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[68] = scene:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#34ad59ff",["id"]="downscale-source-pixel-33",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[69] = scene:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#e8edf2",["id"]="downscale-source-back-34",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[70] = scene:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#39ad5cff",["id"]="downscale-source-pixel-34",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[71] = scene:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="downscale-source-back-35",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[72] = scene:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#3ead5fff",["id"]="downscale-source-pixel-35",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[73] = scene:rectangle {["center"]={-2.75,0},["fill"]="#00000000",["id"]="downscale-source-border",["layer"]=15,["opacity"]=1,["size"]={3.1,3.1},["stroke"]="#afbbc8",["width"]=1}
refs[74] = scene:rectangle {["center"]={1.875,0.775},["fill"]="#f5f7fa",["id"]="downscale-surface-back-0",["layer"]=4,["opacity"]=1,["size"]={1.55,1.55},["stroke"]="#00000000",["width"]=0}
refs[75] = scene:rectangle {["center"]={3.425,0.775},["fill"]="#e8edf2",["id"]="downscale-surface-back-1",["layer"]=4,["opacity"]=1,["size"]={1.55,1.55},["stroke"]="#00000000",["width"]=0}
refs[76] = scene:rectangle {["center"]={1.875,-0.775},["fill"]="#e8edf2",["id"]="downscale-surface-back-2",["layer"]=4,["opacity"]=1,["size"]={1.55,1.55},["stroke"]="#00000000",["width"]=0}
refs[77] = scene:rectangle {["center"]={3.425,-0.775},["fill"]="#f5f7fa",["id"]="downscale-surface-back-3",["layer"]=4,["opacity"]=1,["size"]={1.55,1.55},["stroke"]="#00000000",["width"]=0}
refs[78] = scene:rectangle {["center"]={2.65,0},["fill"]="#00000000",["id"]="downscale-surface-border",["layer"]=15,["opacity"]=1,["size"]={3.1,3.1},["stroke"]="#afbbc8",["width"]=1}
refs[79] = scene:text {["fill"]="#263447",["font"]="Pretendard",["id"]="downscale-source-label",["layer"]=40,["opacity"]=1,["point"]={-2.75,1.98},["role"]="text",["size"]=22,["text"]="Source"}
refs[80] = scene:text {["fill"]="#263447",["font"]="Pretendard",["id"]="downscale-surface-label",["layer"]=40,["opacity"]=1,["point"]={2.65,1.98},["role"]="text",["size"]=22,["text"]="Surface"}
refs[81] = scene:arrow {["from"]={-0.78,1.75},["id"]="downscale-sampling-arrow",["layer"]=5,["stroke"]="#dbe2e9",["tip"]=10,["to"]={0.68,1.75},["width"]=2}
refs[82] = scene:group {["id"]="downscale-read-0",["opacity"]=0}
refs[83] = refs[82]:rectangle {["center"]={-3.7833333333333337,1.0333333333333334},["fill"]="#00000000",["id"]="downscale-kernel-0",["layer"]=21,["opacity"]=1,["size"]={1.0333333333333332,1.0333333333333332},["stroke"]="#263447",["width"]=2}
refs[84] = refs[82]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-0-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[85] = refs[82]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-ink-0-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[86] = refs[82]:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="downscale-weight-0-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.92},["stroke"]="#00000000",["width"]=0}
refs[87] = refs[82]:line {["from"]={-4.364833338260651,1.5448333382606507},["id"]="downscale-sample-h-0",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,1.5448333382606507},["width"]=2}
refs[88] = refs[82]:line {["from"]={-4.29483333826065,1.6148333382606506},["id"]="downscale-sample-v-0",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,1.4748333382606507},["width"]=2}
refs[89] = refs[82]:rectangle {["center"]={1.875,0.775},["fill"]="#00000000",["id"]="downscale-destination-0",["layer"]=27,["opacity"]=1,["size"]={1.53,1.53},["stroke"]="#eb8c28",["width"]=3}
refs[90] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="downscale-computed-0",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[91] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="downscale-write-0",["layer"]=35,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#ffffff",["width"]=1}
refs[92] = scene:rectangle {["center"]={1.875,0.775},["fill"]="#3585cbff",["id"]="downscale-committed-0",["layer"]=11,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#00000000",["width"]=0}
refs[93] = scene:group {["id"]="downscale-read-1",["opacity"]=0}
refs[94] = refs[93]:rectangle {["center"]={-2.75,1.0333333333333334},["fill"]="#00000000",["id"]="downscale-kernel-1",["layer"]=21,["opacity"]=1,["size"]={2.0666666666666664,1.0333333333333332},["stroke"]="#263447",["width"]=2}
refs[95] = refs[93]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-1-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[96] = refs[93]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-ink-1-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[97] = refs[93]:rectangle {["center"]={-0.05,0.23},["fill"]="#3e85c7ff",["id"]="downscale-weight-1-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.46},["stroke"]="#00000000",["width"]=0}
refs[98] = refs[93]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-1-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[99] = refs[93]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="downscale-tap-ink-1-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[100] = refs[93]:rectangle {["center"]={-0.05,-0.23},["fill"]="#5085bfff",["id"]="downscale-weight-1-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.46},["stroke"]="#00000000",["width"]=0}
refs[101] = refs[93]:line {["from"]={-2.298166671593984,1.5448333382606507},["id"]="downscale-sample-h-1",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,1.5448333382606507},["width"]=2}
refs[102] = refs[93]:line {["from"]={-2.2281666715939843,1.6148333382606506},["id"]="downscale-sample-v-1",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,1.4748333382606507},["width"]=2}
refs[103] = refs[93]:rectangle {["center"]={3.425,0.775},["fill"]="#00000000",["id"]="downscale-destination-1",["layer"]=27,["opacity"]=1,["size"]={1.53,1.53},["stroke"]="#eb8c28",["width"]=3}
refs[104] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c3ff",["id"]="downscale-computed-1",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[105] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c3ff",["id"]="downscale-write-1",["layer"]=35,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#ffffff",["width"]=1}
refs[106] = scene:rectangle {["center"]={3.425,0.775},["fill"]="#4785c3ff",["id"]="downscale-committed-1",["layer"]=11,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#00000000",["width"]=0}
refs[107] = scene:group {["id"]="downscale-read-2",["opacity"]=0}
refs[108] = refs[107]:rectangle {["center"]={-3.7833333333333337,-0.5166666666666663},["fill"]="#00000000",["id"]="downscale-kernel-2",["layer"]=21,["opacity"]=1,["size"]={1.0333333333333332,2.0666666666666664},["stroke"]="#263447",["width"]=2}
refs[109] = refs[107]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-2-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[110] = refs[107]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-ink-2-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[111] = refs[107]:rectangle {["center"]={-0.05,0.23},["fill"]="#3597cbff",["id"]="downscale-weight-2-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.46},["stroke"]="#00000000",["width"]=0}
refs[112] = refs[107]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="downscale-tap-2-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[113] = refs[107]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="downscale-tap-ink-2-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[114] = refs[107]:rectangle {["center"]={-0.05,-0.23},["fill"]="#2191b5ff",["id"]="downscale-weight-2-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.46},["stroke"]="#00000000",["width"]=0}
refs[115] = refs[107]:line {["from"]={-4.364833338260651,-0.5218333284060157},["id"]="downscale-sample-h-2",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-0.5218333284060157},["width"]=2}
refs[116] = refs[107]:line {["from"]={-4.29483333826065,-0.45183332840601564},["id"]="downscale-sample-v-2",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-0.5918333284060157},["width"]=2}
refs[117] = refs[107]:rectangle {["center"]={1.875,-0.775},["fill"]="#00000000",["id"]="downscale-destination-2",["layer"]=27,["opacity"]=1,["size"]={1.53,1.53},["stroke"]="#eb8c28",["width"]=3}
refs[118] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2b94c0ff",["id"]="downscale-computed-2",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[119] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2b94c0ff",["id"]="downscale-write-2",["layer"]=35,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#ffffff",["width"]=1}
refs[120] = scene:rectangle {["center"]={1.875,-0.775},["fill"]="#2b94c0ff",["id"]="downscale-committed-2",["layer"]=11,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#00000000",["width"]=0}
refs[121] = scene:group {["id"]="downscale-read-3",["opacity"]=0}
refs[122] = refs[121]:rectangle {["center"]={-2.75,-0.5166666666666663},["fill"]="#00000000",["id"]="downscale-kernel-3",["layer"]=21,["opacity"]=1,["size"]={2.0666666666666664,2.0666666666666664},["stroke"]="#263447",["width"]=2}
refs[123] = refs[121]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-3-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[124] = refs[121]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-ink-3-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[125] = refs[121]:rectangle {["center"]={-0.05,0.345},["fill"]="#3e97c7ff",["id"]="downscale-weight-3-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.23},["stroke"]="#00000000",["width"]=0}
refs[126] = refs[121]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-3-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[127] = refs[121]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="downscale-tap-ink-3-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[128] = refs[121]:rectangle {["center"]={-0.05,0.115},["fill"]="#5097bfff",["id"]="downscale-weight-3-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.23},["stroke"]="#00000000",["width"]=0}
refs[129] = refs[121]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="downscale-tap-3-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[130] = refs[121]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="downscale-tap-ink-3-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[131] = refs[121]:rectangle {["center"]={-0.05,-0.115},["fill"]="#2991beff",["id"]="downscale-weight-3-2",["layer"]=22,["opacity"]=1,["size"]={0.72,0.23},["stroke"]="#00000000",["width"]=0}
refs[132] = refs[121]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="downscale-tap-3-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[133] = refs[121]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="downscale-tap-ink-3-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[134] = refs[121]:rectangle {["center"]={-0.05,-0.345},["fill"]="#34a559ff",["id"]="downscale-weight-3-3",["layer"]=22,["opacity"]=1,["size"]={0.72,0.23},["stroke"]="#00000000",["width"]=0}
refs[135] = refs[121]:line {["from"]={-2.298166671593984,-0.5218333284060157},["id"]="downscale-sample-h-3",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-0.5218333284060157},["width"]=2}
refs[136] = refs[121]:line {["from"]={-2.2281666715939843,-0.45183332840601564},["id"]="downscale-sample-v-3",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-0.5918333284060157},["width"]=2}
refs[137] = refs[121]:rectangle {["center"]={3.425,-0.775},["fill"]="#00000000",["id"]="downscale-destination-3",["layer"]=27,["opacity"]=1,["size"]={1.53,1.53},["stroke"]="#eb8c28",["width"]=3}
refs[138] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3a99a7ff",["id"]="downscale-computed-3",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[139] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3a99a7ff",["id"]="downscale-write-3",["layer"]=35,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#ffffff",["width"]=1}
refs[140] = scene:rectangle {["center"]={3.425,-0.775},["fill"]="#3a99a7ff",["id"]="downscale-committed-3",["layer"]=11,["opacity"]=0,["size"]={1.54,1.54},["stroke"]="#00000000",["width"]=0}
scene:wait(0.5)
scene:fade(refs[82],1,0.45,"linear")
scene:fade(refs[90],1,0.55,"linear")
scene:play({{target=refs[90],opacity=0},{target=refs[91],opacity=1}},0.04,"linear",0)
scene:shift(refs[91],{1.925,0.775},0.65,"ease_in_out")
scene:play({{target=refs[91],opacity=0},{target=refs[92],opacity=1}},0.01,"linear",0)
scene:fade(refs[82],0,0.01,"linear")
scene:fade(refs[93],1,0.12,"linear")
scene:fade(refs[104],1,0.12,"linear")
scene:play({{target=refs[104],opacity=0},{target=refs[105],opacity=1}},0.04,"linear",0)
scene:shift(refs[105],{3.475,0.775},0.3,"ease_in_out")
scene:play({{target=refs[105],opacity=0},{target=refs[106],opacity=1}},0.01,"linear",0)
scene:fade(refs[93],0,0.01,"linear")
scene:fade(refs[107],1,0.12,"linear")
scene:fade(refs[118],1,0.12,"linear")
scene:play({{target=refs[118],opacity=0},{target=refs[119],opacity=1}},0.04,"linear",0)
scene:shift(refs[119],{1.925,-0.775},0.3,"ease_in_out")
scene:play({{target=refs[119],opacity=0},{target=refs[120],opacity=1}},0.01,"linear",0)
scene:fade(refs[107],0,0.01,"linear")
scene:fade(refs[121],1,0.45,"linear")
scene:wait(0.65)
scene:fade(refs[138],1,0.55,"linear")
scene:play({{target=refs[138],opacity=0},{target=refs[139],opacity=1}},0.04,"linear",0)
scene:shift(refs[139],{3.475,-0.775},0.65,"ease_in_out")
scene:play({{target=refs[139],opacity=0},{target=refs[140],opacity=1}},0.01,"linear",0)
scene:wait(1.4)
return scene
