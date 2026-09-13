local refs = {}
local scene = tmath.scene {["camera"]={["height"]=6,["mode"]="fixed",["view"]="2d"},["fps"]=30,["height"]=600,["loop"]=false,["theme"]="pro_white",["width"]=960}
refs[1] = scene:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#f5f7fa",["id"]="bilinear-source-back-0",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[2] = scene:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#3585cbff",["id"]="bilinear-source-pixel-0",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[3] = scene:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#e8edf2",["id"]="bilinear-source-back-1",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[4] = scene:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#3e85c7ff",["id"]="bilinear-source-pixel-1",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[5] = scene:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#f5f7fa",["id"]="bilinear-source-back-2",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[6] = scene:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#4785c3ff",["id"]="bilinear-source-pixel-2",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[7] = scene:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#e8edf2",["id"]="bilinear-source-back-3",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[8] = scene:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#5085bfff",["id"]="bilinear-source-pixel-3",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[9] = scene:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#f5f7fa",["id"]="bilinear-source-back-4",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[10] = scene:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#fad635ff",["id"]="bilinear-source-pixel-4",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[11] = scene:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#e8edf2",["id"]="bilinear-source-back-5",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[12] = scene:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#fada35ff",["id"]="bilinear-source-pixel-5",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[13] = scene:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-6",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[14] = scene:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#358ecbff",["id"]="bilinear-source-pixel-6",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[15] = scene:rectangle {["center"]={-3.525,0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-7",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[16] = scene:rectangle {["center"]={-3.525,0.775},["fill"]="#3e8ec7ff",["id"]="bilinear-source-pixel-7",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[17] = scene:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-8",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[18] = scene:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#478ec3ff",["id"]="bilinear-source-pixel-8",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[19] = scene:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-9",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[20] = scene:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#508ebfff",["id"]="bilinear-source-pixel-9",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[21] = scene:rectangle {["center"]={-1.975,0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-10",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[22] = scene:rectangle {["center"]={-1.975,0.775},["fill"]="#fad63eff",["id"]="bilinear-source-pixel-10",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[23] = scene:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-11",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[24] = scene:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#fada3eff",["id"]="bilinear-source-pixel-11",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[25] = scene:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#f5f7fa",["id"]="bilinear-source-back-12",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[26] = scene:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#3597cbff",["id"]="bilinear-source-pixel-12",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[27] = scene:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#e8edf2",["id"]="bilinear-source-back-13",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[28] = scene:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#3e97c7ff",["id"]="bilinear-source-pixel-13",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[29] = scene:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#f5f7fa",["id"]="bilinear-source-back-14",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[30] = scene:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#4797c3ff",["id"]="bilinear-source-pixel-14",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[31] = scene:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#e8edf2",["id"]="bilinear-source-back-15",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[32] = scene:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#5097bfff",["id"]="bilinear-source-pixel-15",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[33] = scene:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#f5f7fa",["id"]="bilinear-source-back-16",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[34] = scene:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#5997bbff",["id"]="bilinear-source-pixel-16",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[35] = scene:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#e8edf2",["id"]="bilinear-source-back-17",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[36] = scene:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#6297b7ff",["id"]="bilinear-source-pixel-17",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[37] = scene:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#e8edf2",["id"]="bilinear-source-back-18",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[38] = scene:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#35a0cbff",["id"]="bilinear-source-pixel-18",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[39] = scene:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="bilinear-source-back-19",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[40] = scene:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#3ea0c7ff",["id"]="bilinear-source-pixel-19",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[41] = scene:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#e8edf2",["id"]="bilinear-source-back-20",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[42] = scene:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#47a0c3ff",["id"]="bilinear-source-pixel-20",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[43] = scene:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="bilinear-source-back-21",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[44] = scene:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#50a0bfff",["id"]="bilinear-source-pixel-21",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[45] = scene:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#e8edf2",["id"]="bilinear-source-back-22",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[46] = scene:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#399d5cff",["id"]="bilinear-source-pixel-22",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[47] = scene:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#f5f7fa",["id"]="bilinear-source-back-23",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[48] = scene:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#3e9d5fff",["id"]="bilinear-source-pixel-23",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[49] = scene:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-24",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[50] = scene:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#2191b5ff",["id"]="bilinear-source-pixel-24",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[51] = scene:rectangle {["center"]={-3.525,-0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-25",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[52] = scene:rectangle {["center"]={-3.525,-0.775},["fill"]="#2991beff",["id"]="bilinear-source-pixel-25",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[53] = scene:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-26",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[54] = scene:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#2fa556ff",["id"]="bilinear-source-pixel-26",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[55] = scene:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-27",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[56] = scene:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#34a559ff",["id"]="bilinear-source-pixel-27",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[57] = scene:rectangle {["center"]={-1.975,-0.775},["fill"]="#f5f7fa",["id"]="bilinear-source-back-28",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[58] = scene:rectangle {["center"]={-1.975,-0.775},["fill"]="#39a55cff",["id"]="bilinear-source-pixel-28",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[59] = scene:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#e8edf2",["id"]="bilinear-source-back-29",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[60] = scene:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#3ea55fff",["id"]="bilinear-source-pixel-29",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[61] = scene:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#e8edf2",["id"]="bilinear-source-back-30",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[62] = scene:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#219cb5ff",["id"]="bilinear-source-pixel-30",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[63] = scene:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="bilinear-source-back-31",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[64] = scene:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#299cbeff",["id"]="bilinear-source-pixel-31",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[65] = scene:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#e8edf2",["id"]="bilinear-source-back-32",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[66] = scene:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#2fad56ff",["id"]="bilinear-source-pixel-32",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[67] = scene:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="bilinear-source-back-33",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[68] = scene:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#34ad59ff",["id"]="bilinear-source-pixel-33",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[69] = scene:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#e8edf2",["id"]="bilinear-source-back-34",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[70] = scene:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#39ad5cff",["id"]="bilinear-source-pixel-34",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[71] = scene:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#f5f7fa",["id"]="bilinear-source-back-35",["layer"]=4,["opacity"]=1,["size"]={0.5166666666666666,0.5166666666666666},["stroke"]="#00000000",["width"]=0}
refs[72] = scene:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#3ead5fff",["id"]="bilinear-source-pixel-35",["layer"]=10,["opacity"]=1,["size"]={0.5066666666666666,0.5066666666666666},["stroke"]="#00000000",["width"]=0}
refs[73] = scene:rectangle {["center"]={-2.75,0},["fill"]="#00000000",["id"]="bilinear-source-border",["layer"]=15,["opacity"]=1,["size"]={3.1,3.1},["stroke"]="#afbbc8",["width"]=1}
refs[74] = scene:rectangle {["center"]={1.2291666666666663,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-0",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[75] = scene:rectangle {["center"]={1.4875,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-1",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[76] = scene:rectangle {["center"]={1.7458333333333338,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-2",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[77] = scene:rectangle {["center"]={2.0041666666666664,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-3",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[78] = scene:rectangle {["center"]={2.2625,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-4",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[79] = scene:rectangle {["center"]={2.5208333333333326,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-5",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[80] = scene:rectangle {["center"]={2.7791666666666663,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-6",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[81] = scene:rectangle {["center"]={3.0375,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-7",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[82] = scene:rectangle {["center"]={3.2958333333333325,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-8",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[83] = scene:rectangle {["center"]={3.5541666666666663,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-9",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[84] = scene:rectangle {["center"]={3.8125,1.4208333333333334},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-10",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[85] = scene:rectangle {["center"]={4.070833333333333,1.4208333333333334},["fill"]="#e8edf2",["id"]="bilinear-surface-back-11",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[86] = scene:rectangle {["center"]={1.2291666666666663,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-12",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[87] = scene:rectangle {["center"]={1.4875,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-13",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[88] = scene:rectangle {["center"]={1.7458333333333338,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-14",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[89] = scene:rectangle {["center"]={2.0041666666666664,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-15",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[90] = scene:rectangle {["center"]={2.2625,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-16",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[91] = scene:rectangle {["center"]={2.5208333333333326,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-17",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[92] = scene:rectangle {["center"]={2.7791666666666663,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-18",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[93] = scene:rectangle {["center"]={3.0375,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-19",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[94] = scene:rectangle {["center"]={3.2958333333333325,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-20",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[95] = scene:rectangle {["center"]={3.5541666666666663,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-21",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[96] = scene:rectangle {["center"]={3.8125,1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-22",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[97] = scene:rectangle {["center"]={4.070833333333333,1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-23",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[98] = scene:rectangle {["center"]={1.2291666666666663,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-24",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[99] = scene:rectangle {["center"]={1.4875,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-25",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[100] = scene:rectangle {["center"]={1.7458333333333338,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-26",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[101] = scene:rectangle {["center"]={2.0041666666666664,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-27",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[102] = scene:rectangle {["center"]={2.2625,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-28",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[103] = scene:rectangle {["center"]={2.5208333333333326,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-29",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[104] = scene:rectangle {["center"]={2.7791666666666663,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-30",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[105] = scene:rectangle {["center"]={3.0375,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-31",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[106] = scene:rectangle {["center"]={3.2958333333333325,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-32",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[107] = scene:rectangle {["center"]={3.5541666666666663,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-33",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[108] = scene:rectangle {["center"]={3.8125,0.9041666666666669},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-34",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[109] = scene:rectangle {["center"]={4.070833333333333,0.9041666666666669},["fill"]="#e8edf2",["id"]="bilinear-surface-back-35",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[110] = scene:rectangle {["center"]={1.2291666666666663,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-36",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[111] = scene:rectangle {["center"]={1.4875,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-37",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[112] = scene:rectangle {["center"]={1.7458333333333338,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-38",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[113] = scene:rectangle {["center"]={2.0041666666666664,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-39",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[114] = scene:rectangle {["center"]={2.2625,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-40",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[115] = scene:rectangle {["center"]={2.5208333333333326,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-41",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[116] = scene:rectangle {["center"]={2.7791666666666663,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-42",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[117] = scene:rectangle {["center"]={3.0375,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-43",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[118] = scene:rectangle {["center"]={3.2958333333333325,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-44",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[119] = scene:rectangle {["center"]={3.5541666666666663,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-45",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[120] = scene:rectangle {["center"]={3.8125,0.6458333333333335},["fill"]="#e8edf2",["id"]="bilinear-surface-back-46",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[121] = scene:rectangle {["center"]={4.070833333333333,0.6458333333333335},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-47",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[122] = scene:rectangle {["center"]={1.2291666666666663,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-48",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[123] = scene:rectangle {["center"]={1.4875,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-49",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[124] = scene:rectangle {["center"]={1.7458333333333338,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-50",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[125] = scene:rectangle {["center"]={2.0041666666666664,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-51",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[126] = scene:rectangle {["center"]={2.2625,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-52",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[127] = scene:rectangle {["center"]={2.5208333333333326,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-53",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[128] = scene:rectangle {["center"]={2.7791666666666663,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-54",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[129] = scene:rectangle {["center"]={3.0375,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-55",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[130] = scene:rectangle {["center"]={3.2958333333333325,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-56",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[131] = scene:rectangle {["center"]={3.5541666666666663,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-57",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[132] = scene:rectangle {["center"]={3.8125,0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-58",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[133] = scene:rectangle {["center"]={4.070833333333333,0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-59",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[134] = scene:rectangle {["center"]={1.2291666666666663,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-60",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[135] = scene:rectangle {["center"]={1.4875,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-61",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[136] = scene:rectangle {["center"]={1.7458333333333338,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-62",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[137] = scene:rectangle {["center"]={2.0041666666666664,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-63",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[138] = scene:rectangle {["center"]={2.2625,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-64",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[139] = scene:rectangle {["center"]={2.5208333333333326,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-65",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[140] = scene:rectangle {["center"]={2.7791666666666663,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-66",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[141] = scene:rectangle {["center"]={3.0375,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-67",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[142] = scene:rectangle {["center"]={3.2958333333333325,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-68",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[143] = scene:rectangle {["center"]={3.5541666666666663,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-69",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[144] = scene:rectangle {["center"]={3.8125,0.12916666666666685},["fill"]="#e8edf2",["id"]="bilinear-surface-back-70",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[145] = scene:rectangle {["center"]={4.070833333333333,0.12916666666666685},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-71",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[146] = scene:rectangle {["center"]={1.2291666666666663,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-72",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[147] = scene:rectangle {["center"]={1.4875,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-73",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[148] = scene:rectangle {["center"]={1.7458333333333338,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-74",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[149] = scene:rectangle {["center"]={2.0041666666666664,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-75",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[150] = scene:rectangle {["center"]={2.2625,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-76",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[151] = scene:rectangle {["center"]={2.5208333333333326,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-77",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[152] = scene:rectangle {["center"]={2.7791666666666663,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-78",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[153] = scene:rectangle {["center"]={3.0375,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-79",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[154] = scene:rectangle {["center"]={3.2958333333333325,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-80",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[155] = scene:rectangle {["center"]={3.5541666666666663,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-81",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[156] = scene:rectangle {["center"]={3.8125,-0.1291666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-82",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[157] = scene:rectangle {["center"]={4.070833333333333,-0.1291666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-83",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[158] = scene:rectangle {["center"]={1.2291666666666663,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-84",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[159] = scene:rectangle {["center"]={1.4875,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-85",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[160] = scene:rectangle {["center"]={1.7458333333333338,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-86",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[161] = scene:rectangle {["center"]={2.0041666666666664,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-87",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[162] = scene:rectangle {["center"]={2.2625,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-88",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[163] = scene:rectangle {["center"]={2.5208333333333326,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-89",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[164] = scene:rectangle {["center"]={2.7791666666666663,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-90",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[165] = scene:rectangle {["center"]={3.0375,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-91",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[166] = scene:rectangle {["center"]={3.2958333333333325,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-92",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[167] = scene:rectangle {["center"]={3.5541666666666663,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-93",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[168] = scene:rectangle {["center"]={3.8125,-0.3875},["fill"]="#e8edf2",["id"]="bilinear-surface-back-94",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[169] = scene:rectangle {["center"]={4.070833333333333,-0.3875},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-95",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[170] = scene:rectangle {["center"]={1.2291666666666663,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-96",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[171] = scene:rectangle {["center"]={1.4875,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-97",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[172] = scene:rectangle {["center"]={1.7458333333333338,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-98",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[173] = scene:rectangle {["center"]={2.0041666666666664,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-99",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[174] = scene:rectangle {["center"]={2.2625,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-100",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[175] = scene:rectangle {["center"]={2.5208333333333326,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-101",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[176] = scene:rectangle {["center"]={2.7791666666666663,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-102",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[177] = scene:rectangle {["center"]={3.0375,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-103",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[178] = scene:rectangle {["center"]={3.2958333333333325,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-104",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[179] = scene:rectangle {["center"]={3.5541666666666663,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-105",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[180] = scene:rectangle {["center"]={3.8125,-0.6458333333333331},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-106",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[181] = scene:rectangle {["center"]={4.070833333333333,-0.6458333333333331},["fill"]="#e8edf2",["id"]="bilinear-surface-back-107",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[182] = scene:rectangle {["center"]={1.2291666666666663,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-108",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[183] = scene:rectangle {["center"]={1.4875,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-109",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[184] = scene:rectangle {["center"]={1.7458333333333338,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-110",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[185] = scene:rectangle {["center"]={2.0041666666666664,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-111",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[186] = scene:rectangle {["center"]={2.2625,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-112",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[187] = scene:rectangle {["center"]={2.5208333333333326,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-113",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[188] = scene:rectangle {["center"]={2.7791666666666663,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-114",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[189] = scene:rectangle {["center"]={3.0375,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-115",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[190] = scene:rectangle {["center"]={3.2958333333333325,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-116",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[191] = scene:rectangle {["center"]={3.5541666666666663,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-117",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[192] = scene:rectangle {["center"]={3.8125,-0.9041666666666663},["fill"]="#e8edf2",["id"]="bilinear-surface-back-118",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[193] = scene:rectangle {["center"]={4.070833333333333,-0.9041666666666663},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-119",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[194] = scene:rectangle {["center"]={1.2291666666666663,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-120",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[195] = scene:rectangle {["center"]={1.4875,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-121",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[196] = scene:rectangle {["center"]={1.7458333333333338,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-122",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[197] = scene:rectangle {["center"]={2.0041666666666664,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-123",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[198] = scene:rectangle {["center"]={2.2625,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-124",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[199] = scene:rectangle {["center"]={2.5208333333333326,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-125",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[200] = scene:rectangle {["center"]={2.7791666666666663,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-126",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[201] = scene:rectangle {["center"]={3.0375,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-127",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[202] = scene:rectangle {["center"]={3.2958333333333325,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-128",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[203] = scene:rectangle {["center"]={3.5541666666666663,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-129",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[204] = scene:rectangle {["center"]={3.8125,-1.1625},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-130",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[205] = scene:rectangle {["center"]={4.070833333333333,-1.1625},["fill"]="#e8edf2",["id"]="bilinear-surface-back-131",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[206] = scene:rectangle {["center"]={1.2291666666666663,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-132",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[207] = scene:rectangle {["center"]={1.4875,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-133",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[208] = scene:rectangle {["center"]={1.7458333333333338,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-134",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[209] = scene:rectangle {["center"]={2.0041666666666664,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-135",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[210] = scene:rectangle {["center"]={2.2625,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-136",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[211] = scene:rectangle {["center"]={2.5208333333333326,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-137",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[212] = scene:rectangle {["center"]={2.7791666666666663,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-138",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[213] = scene:rectangle {["center"]={3.0375,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-139",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[214] = scene:rectangle {["center"]={3.2958333333333325,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-140",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[215] = scene:rectangle {["center"]={3.5541666666666663,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-141",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[216] = scene:rectangle {["center"]={3.8125,-1.4208333333333332},["fill"]="#e8edf2",["id"]="bilinear-surface-back-142",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[217] = scene:rectangle {["center"]={4.070833333333333,-1.4208333333333332},["fill"]="#f5f7fa",["id"]="bilinear-surface-back-143",["layer"]=4,["opacity"]=1,["size"]={0.2583333333333333,0.2583333333333333},["stroke"]="#00000000",["width"]=0}
refs[218] = scene:rectangle {["center"]={2.65,0},["fill"]="#00000000",["id"]="bilinear-surface-border",["layer"]=15,["opacity"]=1,["size"]={3.1,3.1},["stroke"]="#afbbc8",["width"]=1}
refs[219] = scene:text {["fill"]="#263447",["font"]="Pretendard",["id"]="bilinear-source-label",["layer"]=40,["opacity"]=1,["point"]={-2.75,1.98},["role"]="text",["size"]=22,["text"]="Source"}
refs[220] = scene:text {["fill"]="#263447",["font"]="Pretendard",["id"]="bilinear-surface-label",["layer"]=40,["opacity"]=1,["point"]={2.65,1.98},["role"]="text",["size"]=22,["text"]="Surface"}
refs[221] = scene:arrow {["from"]={-0.78,1.75},["id"]="bilinear-sampling-arrow",["layer"]=5,["stroke"]="#dbe2e9",["tip"]=10,["to"]={0.68,1.75},["width"]=2}
refs[222] = scene:group {["id"]="bilinear-read-0",["opacity"]=0}
refs[223] = refs[222]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-0-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[224] = refs[222]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-0-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[225] = refs[222]:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-weight-0-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.92},["stroke"]="#00000000",["width"]=0}
refs[226] = refs[222]:group {["id"]="bilinear-horizontal-0",["opacity"]=0}
refs[227] = refs[226]:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-top-mix-0",["layer"]=23,["opacity"]=1,["size"]={0.72,0.92},["stroke"]="#00000000",["width"]=0}
refs[228] = refs[222]:line {["from"]={-4.364833338260651,1.5448333382606507},["id"]="bilinear-sample-h-0",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,1.5448333382606507},["width"]=2}
refs[229] = refs[222]:line {["from"]={-4.29483333826065,1.6148333382606506},["id"]="bilinear-sample-v-0",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,1.4748333382606507},["width"]=2}
refs[230] = refs[222]:rectangle {["center"]={1.2291666666666663,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-0",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[231] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-computed-0",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[232] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-write-0",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[233] = scene:rectangle {["center"]={1.2291666666666663,1.4208333333333334},["fill"]="#3585cbff",["id"]="bilinear-committed-0",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[234] = scene:group {["id"]="bilinear-read-1",["opacity"]=0}
refs[235] = refs[234]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-1-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[236] = refs[234]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-1-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[237] = refs[234]:rectangle {["center"]={-0.0528125,0},["fill"]="#3585cbff",["id"]="bilinear-weight-1-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[238] = refs[234]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-1-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[239] = refs[234]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-1-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[240] = refs[234]:rectangle {["center"]={0.3071875,0},["fill"]="#3e85c7ff",["id"]="bilinear-weight-1-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[241] = refs[234]:line {["from"]={-4.106500004927318,1.5448333382606507},["id"]="bilinear-sample-h-1",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,1.5448333382606507},["width"]=2}
refs[242] = refs[234]:line {["from"]={-4.036500004927317,1.6148333382606506},["id"]="bilinear-sample-v-1",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,1.4748333382606507},["width"]=2}
refs[243] = refs[234]:rectangle {["center"]={1.4875,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-1",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[244] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585caff",["id"]="bilinear-computed-1",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[245] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585caff",["id"]="bilinear-write-1",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[246] = scene:rectangle {["center"]={1.4875,1.4208333333333334},["fill"]="#3585caff",["id"]="bilinear-committed-1",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[247] = scene:group {["id"]="bilinear-read-2",["opacity"]=0}
refs[248] = refs[247]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-2-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[249] = refs[247]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-2-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[250] = refs[247]:rectangle {["center"]={-0.2328125,0},["fill"]="#3585cbff",["id"]="bilinear-weight-2-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.92},["stroke"]="#00000000",["width"]=0}
refs[251] = refs[247]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-2-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[252] = refs[247]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-2-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[253] = refs[247]:rectangle {["center"]={0.1271875,0},["fill"]="#3e85c7ff",["id"]="bilinear-weight-2-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.92},["stroke"]="#00000000",["width"]=0}
refs[254] = refs[247]:line {["from"]={-3.8481666715939844,1.5448333382606507},["id"]="bilinear-sample-h-2",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,1.5448333382606507},["width"]=2}
refs[255] = refs[247]:line {["from"]={-3.7781666715939846,1.6148333382606506},["id"]="bilinear-sample-v-2",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,1.4748333382606507},["width"]=2}
refs[256] = refs[247]:rectangle {["center"]={1.7458333333333338,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-2",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[257] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3985c8ff",["id"]="bilinear-computed-2",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[258] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3985c8ff",["id"]="bilinear-write-2",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[259] = scene:rectangle {["center"]={1.7458333333333338,1.4208333333333334},["fill"]="#3985c8ff",["id"]="bilinear-committed-2",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[260] = scene:group {["id"]="bilinear-read-3",["opacity"]=0}
refs[261] = refs[260]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-3-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[262] = refs[260]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-3-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[263] = refs[260]:rectangle {["center"]={-0.0528125,0},["fill"]="#3e85c7ff",["id"]="bilinear-weight-3-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[264] = refs[260]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-3-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[265] = refs[260]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-3-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[266] = refs[260]:rectangle {["center"]={0.3071875,0},["fill"]="#4785c3ff",["id"]="bilinear-weight-3-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[267] = refs[260]:line {["from"]={-3.5898333382606507,1.5448333382606507},["id"]="bilinear-sample-h-3",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,1.5448333382606507},["width"]=2}
refs[268] = refs[260]:line {["from"]={-3.519833338260651,1.6148333382606506},["id"]="bilinear-sample-v-3",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,1.4748333382606507},["width"]=2}
refs[269] = refs[260]:rectangle {["center"]={2.0041666666666664,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-3",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[270] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e85c6ff",["id"]="bilinear-computed-3",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[271] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e85c6ff",["id"]="bilinear-write-3",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[272] = scene:rectangle {["center"]={2.0041666666666664,1.4208333333333334},["fill"]="#3e85c6ff",["id"]="bilinear-committed-3",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[273] = scene:group {["id"]="bilinear-read-4",["opacity"]=0}
refs[274] = refs[273]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-4-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[275] = refs[273]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-4-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[276] = refs[273]:rectangle {["center"]={-0.2328125,0},["fill"]="#3e85c7ff",["id"]="bilinear-weight-4-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.92},["stroke"]="#00000000",["width"]=0}
refs[277] = refs[273]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-4-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[278] = refs[273]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-4-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[279] = refs[273]:rectangle {["center"]={0.1271875,0},["fill"]="#4785c3ff",["id"]="bilinear-weight-4-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.92},["stroke"]="#00000000",["width"]=0}
refs[280] = refs[273]:line {["from"]={-3.3315000049273173,1.5448333382606507},["id"]="bilinear-sample-h-4",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,1.5448333382606507},["width"]=2}
refs[281] = refs[273]:line {["from"]={-3.2615000049273175,1.6148333382606506},["id"]="bilinear-sample-v-4",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,1.4748333382606507},["width"]=2}
refs[282] = refs[273]:rectangle {["center"]={2.2625,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-4",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[283] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4285c4ff",["id"]="bilinear-computed-4",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[284] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4285c4ff",["id"]="bilinear-write-4",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[285] = scene:rectangle {["center"]={2.2625,1.4208333333333334},["fill"]="#4285c4ff",["id"]="bilinear-committed-4",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[286] = scene:group {["id"]="bilinear-read-5",["opacity"]=0}
refs[287] = refs[286]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-5-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[288] = refs[286]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-5-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[289] = refs[286]:rectangle {["center"]={-0.0528125,0},["fill"]="#4785c3ff",["id"]="bilinear-weight-5-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[290] = refs[286]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-5-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[291] = refs[286]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-5-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[292] = refs[286]:rectangle {["center"]={0.3071875,0},["fill"]="#5085bfff",["id"]="bilinear-weight-5-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[293] = refs[286]:line {["from"]={-3.0731666715939845,1.5448333382606507},["id"]="bilinear-sample-h-5",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,1.5448333382606507},["width"]=2}
refs[294] = refs[286]:line {["from"]={-3.003166671593984,1.6148333382606506},["id"]="bilinear-sample-v-5",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,1.4748333382606507},["width"]=2}
refs[295] = refs[286]:rectangle {["center"]={2.5208333333333326,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-5",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[296] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c2ff",["id"]="bilinear-computed-5",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[297] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c2ff",["id"]="bilinear-write-5",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[298] = scene:rectangle {["center"]={2.5208333333333326,1.4208333333333334},["fill"]="#4785c2ff",["id"]="bilinear-committed-5",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[299] = scene:group {["id"]="bilinear-read-6",["opacity"]=0}
refs[300] = refs[299]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-6-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[301] = refs[299]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-6-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[302] = refs[299]:rectangle {["center"]={-0.2328125,0},["fill"]="#4785c3ff",["id"]="bilinear-weight-6-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.92},["stroke"]="#00000000",["width"]=0}
refs[303] = refs[299]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-6-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[304] = refs[299]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-6-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[305] = refs[299]:rectangle {["center"]={0.1271875,0},["fill"]="#5085bfff",["id"]="bilinear-weight-6-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.92},["stroke"]="#00000000",["width"]=0}
refs[306] = refs[299]:line {["from"]={-2.8148333382606507,1.5448333382606507},["id"]="bilinear-sample-h-6",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,1.5448333382606507},["width"]=2}
refs[307] = refs[299]:line {["from"]={-2.7448333382606505,1.6148333382606506},["id"]="bilinear-sample-v-6",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,1.4748333382606507},["width"]=2}
refs[308] = refs[299]:rectangle {["center"]={2.7791666666666663,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-6",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[309] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b85c0ff",["id"]="bilinear-computed-6",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[310] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b85c0ff",["id"]="bilinear-write-6",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[311] = scene:rectangle {["center"]={2.7791666666666663,1.4208333333333334},["fill"]="#4b85c0ff",["id"]="bilinear-committed-6",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[312] = scene:group {["id"]="bilinear-read-7",["opacity"]=0}
refs[313] = refs[312]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-7-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[314] = refs[312]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-7-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[315] = refs[312]:rectangle {["center"]={-0.0528125,0},["fill"]="#5085bfff",["id"]="bilinear-weight-7-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[316] = refs[312]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-7-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[317] = refs[312]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-7-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[318] = refs[312]:rectangle {["center"]={0.3071875,0},["fill"]="#fad635ff",["id"]="bilinear-weight-7-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[319] = refs[312]:line {["from"]={-2.5565000049273174,1.5448333382606507},["id"]="bilinear-sample-h-7",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,1.5448333382606507},["width"]=2}
refs[320] = refs[312]:line {["from"]={-2.4865000049273176,1.6148333382606506},["id"]="bilinear-sample-v-7",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,1.4748333382606507},["width"]=2}
refs[321] = refs[312]:rectangle {["center"]={3.0375,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-7",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[322] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5185bdff",["id"]="bilinear-computed-7",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[323] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5185bdff",["id"]="bilinear-write-7",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[324] = scene:rectangle {["center"]={3.0375,1.4208333333333334},["fill"]="#5185bdff",["id"]="bilinear-committed-7",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[325] = scene:group {["id"]="bilinear-read-8",["opacity"]=0}
refs[326] = refs[325]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-8-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[327] = refs[325]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-8-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[328] = refs[325]:rectangle {["center"]={-0.2328125,0},["fill"]="#5085bfff",["id"]="bilinear-weight-8-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.92},["stroke"]="#00000000",["width"]=0}
refs[329] = refs[325]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-8-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[330] = refs[325]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-8-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[331] = refs[325]:rectangle {["center"]={0.1271875,0},["fill"]="#fad635ff",["id"]="bilinear-weight-8-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.92},["stroke"]="#00000000",["width"]=0}
refs[332] = refs[325]:line {["from"]={-2.298166671593984,1.5448333382606507},["id"]="bilinear-sample-h-8",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,1.5448333382606507},["width"]=2}
refs[333] = refs[325]:line {["from"]={-2.2281666715939843,1.6148333382606506},["id"]="bilinear-sample-v-8",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,1.4748333382606507},["width"]=2}
refs[334] = refs[325]:rectangle {["center"]={3.2958333333333325,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-8",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[335] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6ae78ff",["id"]="bilinear-computed-8",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[336] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6ae78ff",["id"]="bilinear-write-8",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[337] = scene:rectangle {["center"]={3.2958333333333325,1.4208333333333334},["fill"]="#a6ae78ff",["id"]="bilinear-committed-8",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[338] = scene:group {["id"]="bilinear-read-9",["opacity"]=0}
refs[339] = refs[338]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-9-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[340] = refs[338]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-9-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[341] = refs[338]:rectangle {["center"]={-0.0528125,0},["fill"]="#fad635ff",["id"]="bilinear-weight-9-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[342] = refs[338]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-9-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[343] = refs[338]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-9-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[344] = refs[338]:rectangle {["center"]={0.3071875,0},["fill"]="#fada35ff",["id"]="bilinear-weight-9-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[345] = refs[338]:line {["from"]={-2.0398332150777185,1.5448333382606507},["id"]="bilinear-sample-h-9",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,1.5448333382606507},["width"]=2}
refs[346] = refs[338]:line {["from"]={-1.9698332150777185,1.6148333382606506},["id"]="bilinear-sample-v-9",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,1.4748333382606507},["width"]=2}
refs[347] = refs[338]:rectangle {["center"]={3.5541666666666663,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-9",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[348] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad635ff",["id"]="bilinear-computed-9",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[349] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad635ff",["id"]="bilinear-write-9",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[350] = scene:rectangle {["center"]={3.5541666666666663,1.4208333333333334},["fill"]="#fad635ff",["id"]="bilinear-committed-9",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[351] = scene:group {["id"]="bilinear-read-10",["opacity"]=0}
refs[352] = refs[351]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-10-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[353] = refs[351]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-10-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[354] = refs[351]:rectangle {["center"]={-0.2328125,0},["fill"]="#fad635ff",["id"]="bilinear-weight-10-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.92},["stroke"]="#00000000",["width"]=0}
refs[355] = refs[351]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-10-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[356] = refs[351]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-10-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[357] = refs[351]:rectangle {["center"]={0.1271875,0},["fill"]="#fada35ff",["id"]="bilinear-weight-10-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.92},["stroke"]="#00000000",["width"]=0}
refs[358] = refs[351]:line {["from"]={-1.7814998817443848,1.5448333382606507},["id"]="bilinear-sample-h-10",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,1.5448333382606507},["width"]=2}
refs[359] = refs[351]:line {["from"]={-1.7114998817443847,1.6148333382606506},["id"]="bilinear-sample-v-10",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,1.4748333382606507},["width"]=2}
refs[360] = refs[351]:rectangle {["center"]={3.8125,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-10",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[361] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad835ff",["id"]="bilinear-computed-10",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[362] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad835ff",["id"]="bilinear-write-10",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[363] = scene:rectangle {["center"]={3.8125,1.4208333333333334},["fill"]="#fad835ff",["id"]="bilinear-committed-10",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[364] = scene:group {["id"]="bilinear-read-11",["opacity"]=0}
refs[365] = refs[364]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-11-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[366] = refs[364]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-11-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[367] = refs[364]:rectangle {["center"]={-0.0528125,0},["fill"]="#fada35ff",["id"]="bilinear-weight-11-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.92},["stroke"]="#00000000",["width"]=0}
refs[368] = refs[364]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-11-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[369] = refs[364]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-11-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[370] = refs[364]:rectangle {["center"]={0.3071875,0},["fill"]="#fada35ff",["id"]="bilinear-weight-11-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.92},["stroke"]="#00000000",["width"]=0}
refs[371] = refs[364]:line {["from"]={-1.5231665484110517,1.5448333382606507},["id"]="bilinear-sample-h-11",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,1.5448333382606507},["width"]=2}
refs[372] = refs[364]:line {["from"]={-1.4531665484110516,1.6148333382606506},["id"]="bilinear-sample-v-11",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,1.4748333382606507},["width"]=2}
refs[373] = refs[364]:rectangle {["center"]={4.070833333333333,1.4208333333333334},["fill"]="#00000000",["id"]="bilinear-destination-11",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[374] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada35ff",["id"]="bilinear-computed-11",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[375] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada35ff",["id"]="bilinear-write-11",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[376] = scene:rectangle {["center"]={4.070833333333333,1.4208333333333334},["fill"]="#fada35ff",["id"]="bilinear-committed-11",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[377] = scene:group {["id"]="bilinear-read-12",["opacity"]=0}
refs[378] = refs[377]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-12-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[379] = refs[377]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-12-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[380] = refs[377]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#3585cbff",["id"]="bilinear-weight-12-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[381] = refs[377]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-12-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[382] = refs[377]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-12-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[383] = refs[377]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#358ecbff",["id"]="bilinear-weight-12-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[384] = refs[377]:line {["from"]={-4.364833338260651,1.2865000049273172},["id"]="bilinear-sample-h-12",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,1.2865000049273172},["width"]=2}
refs[385] = refs[377]:line {["from"]={-4.29483333826065,1.3565000049273173},["id"]="bilinear-sample-v-12",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,1.2165000049273171},["width"]=2}
refs[386] = refs[377]:rectangle {["center"]={1.2291666666666663,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-12",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[387] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-computed-12",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[388] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585cbff",["id"]="bilinear-write-12",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[389] = scene:rectangle {["center"]={1.2291666666666663,1.1625},["fill"]="#3585cbff",["id"]="bilinear-committed-12",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[390] = scene:group {["id"]="bilinear-read-13",["opacity"]=0}
refs[391] = refs[390]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-13-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[392] = refs[390]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-13-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[393] = refs[390]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3585cbff",["id"]="bilinear-weight-13-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[394] = refs[390]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-13-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[395] = refs[390]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-13-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[396] = refs[390]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-13-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[397] = refs[390]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-13-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[398] = refs[390]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-13-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[399] = refs[390]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#358ecbff",["id"]="bilinear-weight-13-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[400] = refs[390]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-13-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[401] = refs[390]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-13-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[402] = refs[390]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-13-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[403] = refs[390]:line {["from"]={-4.106500004927318,1.2865000049273172},["id"]="bilinear-sample-h-13",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,1.2865000049273172},["width"]=2}
refs[404] = refs[390]:line {["from"]={-4.036500004927317,1.3565000049273173},["id"]="bilinear-sample-v-13",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,1.2165000049273171},["width"]=2}
refs[405] = refs[390]:rectangle {["center"]={1.4875,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-13",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[406] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585caff",["id"]="bilinear-computed-13",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[407] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3585caff",["id"]="bilinear-write-13",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[408] = scene:rectangle {["center"]={1.4875,1.1625},["fill"]="#3585caff",["id"]="bilinear-committed-13",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[409] = scene:group {["id"]="bilinear-read-14",["opacity"]=0}
refs[410] = refs[409]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-14-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[411] = refs[409]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-14-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[412] = refs[409]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3585cbff",["id"]="bilinear-weight-14-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[413] = refs[409]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-14-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[414] = refs[409]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-14-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[415] = refs[409]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-14-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[416] = refs[409]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-14-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[417] = refs[409]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-14-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[418] = refs[409]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#358ecbff",["id"]="bilinear-weight-14-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[419] = refs[409]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-14-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[420] = refs[409]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-14-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[421] = refs[409]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-14-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[422] = refs[409]:line {["from"]={-3.8481666715939844,1.2865000049273172},["id"]="bilinear-sample-h-14",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,1.2865000049273172},["width"]=2}
refs[423] = refs[409]:line {["from"]={-3.7781666715939846,1.3565000049273173},["id"]="bilinear-sample-v-14",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,1.2165000049273171},["width"]=2}
refs[424] = refs[409]:rectangle {["center"]={1.7458333333333338,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-14",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[425] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3985c8ff",["id"]="bilinear-computed-14",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[426] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3985c8ff",["id"]="bilinear-write-14",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[427] = scene:rectangle {["center"]={1.7458333333333338,1.1625},["fill"]="#3985c8ff",["id"]="bilinear-committed-14",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[428] = scene:group {["id"]="bilinear-read-15",["opacity"]=0}
refs[429] = refs[428]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-15-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[430] = refs[428]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-15-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[431] = refs[428]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-15-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[432] = refs[428]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-15-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[433] = refs[428]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-15-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[434] = refs[428]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-15-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[435] = refs[428]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-15-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[436] = refs[428]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-15-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[437] = refs[428]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-15-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[438] = refs[428]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-15-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[439] = refs[428]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-15-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[440] = refs[428]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-15-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[441] = refs[428]:line {["from"]={-3.5898333382606507,1.2865000049273172},["id"]="bilinear-sample-h-15",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,1.2865000049273172},["width"]=2}
refs[442] = refs[428]:line {["from"]={-3.519833338260651,1.3565000049273173},["id"]="bilinear-sample-v-15",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,1.2165000049273171},["width"]=2}
refs[443] = refs[428]:rectangle {["center"]={2.0041666666666664,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-15",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[444] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e85c6ff",["id"]="bilinear-computed-15",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[445] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e85c6ff",["id"]="bilinear-write-15",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[446] = scene:rectangle {["center"]={2.0041666666666664,1.1625},["fill"]="#3e85c6ff",["id"]="bilinear-committed-15",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[447] = scene:group {["id"]="bilinear-read-16",["opacity"]=0}
refs[448] = refs[447]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-16-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[449] = refs[447]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-16-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[450] = refs[447]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-16-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[451] = refs[447]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-16-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[452] = refs[447]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-16-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[453] = refs[447]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-16-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[454] = refs[447]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-16-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[455] = refs[447]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-16-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[456] = refs[447]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-16-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[457] = refs[447]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-16-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[458] = refs[447]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-16-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[459] = refs[447]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-16-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[460] = refs[447]:line {["from"]={-3.3315000049273173,1.2865000049273172},["id"]="bilinear-sample-h-16",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,1.2865000049273172},["width"]=2}
refs[461] = refs[447]:line {["from"]={-3.2615000049273175,1.3565000049273173},["id"]="bilinear-sample-v-16",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,1.2165000049273171},["width"]=2}
refs[462] = refs[447]:rectangle {["center"]={2.2625,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-16",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[463] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4285c4ff",["id"]="bilinear-computed-16",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[464] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4285c4ff",["id"]="bilinear-write-16",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[465] = scene:rectangle {["center"]={2.2625,1.1625},["fill"]="#4285c4ff",["id"]="bilinear-committed-16",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[466] = scene:group {["id"]="bilinear-read-17",["opacity"]=0}
refs[467] = refs[466]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-17-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[468] = refs[466]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-17-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[469] = refs[466]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-17-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[470] = refs[466]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-17-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[471] = refs[466]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-17-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[472] = refs[466]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#5085bfff",["id"]="bilinear-weight-17-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[473] = refs[466]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-17-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[474] = refs[466]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-17-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[475] = refs[466]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-17-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[476] = refs[466]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-17-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[477] = refs[466]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-17-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[478] = refs[466]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#508ebfff",["id"]="bilinear-weight-17-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[479] = refs[466]:line {["from"]={-3.0731666715939845,1.2865000049273172},["id"]="bilinear-sample-h-17",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,1.2865000049273172},["width"]=2}
refs[480] = refs[466]:line {["from"]={-3.003166671593984,1.3565000049273173},["id"]="bilinear-sample-v-17",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,1.2165000049273171},["width"]=2}
refs[481] = refs[466]:rectangle {["center"]={2.5208333333333326,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-17",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[482] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c2ff",["id"]="bilinear-computed-17",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[483] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4785c2ff",["id"]="bilinear-write-17",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[484] = scene:rectangle {["center"]={2.5208333333333326,1.1625},["fill"]="#4785c2ff",["id"]="bilinear-committed-17",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[485] = scene:group {["id"]="bilinear-read-18",["opacity"]=0}
refs[486] = refs[485]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-18-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[487] = refs[485]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-18-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[488] = refs[485]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-18-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[489] = refs[485]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-18-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[490] = refs[485]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-18-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[491] = refs[485]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#5085bfff",["id"]="bilinear-weight-18-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[492] = refs[485]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-18-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[493] = refs[485]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-18-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[494] = refs[485]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-18-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[495] = refs[485]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-18-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[496] = refs[485]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-18-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[497] = refs[485]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#508ebfff",["id"]="bilinear-weight-18-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[498] = refs[485]:line {["from"]={-2.8148333382606507,1.2865000049273172},["id"]="bilinear-sample-h-18",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,1.2865000049273172},["width"]=2}
refs[499] = refs[485]:line {["from"]={-2.7448333382606505,1.3565000049273173},["id"]="bilinear-sample-v-18",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,1.2165000049273171},["width"]=2}
refs[500] = refs[485]:rectangle {["center"]={2.7791666666666663,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-18",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[501] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b85c0ff",["id"]="bilinear-computed-18",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[502] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b85c0ff",["id"]="bilinear-write-18",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[503] = scene:rectangle {["center"]={2.7791666666666663,1.1625},["fill"]="#4b85c0ff",["id"]="bilinear-committed-18",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[504] = scene:group {["id"]="bilinear-read-19",["opacity"]=0}
refs[505] = refs[504]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-19-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[506] = refs[504]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-19-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[507] = refs[504]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#5085bfff",["id"]="bilinear-weight-19-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[508] = refs[504]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-19-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[509] = refs[504]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-19-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[510] = refs[504]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fad635ff",["id"]="bilinear-weight-19-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[511] = refs[504]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-19-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[512] = refs[504]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-19-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[513] = refs[504]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#508ebfff",["id"]="bilinear-weight-19-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[514] = refs[504]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-19-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[515] = refs[504]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-19-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[516] = refs[504]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#fad63eff",["id"]="bilinear-weight-19-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[517] = refs[504]:line {["from"]={-2.5565000049273174,1.2865000049273172},["id"]="bilinear-sample-h-19",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,1.2865000049273172},["width"]=2}
refs[518] = refs[504]:line {["from"]={-2.4865000049273176,1.3565000049273173},["id"]="bilinear-sample-v-19",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,1.2165000049273171},["width"]=2}
refs[519] = refs[504]:rectangle {["center"]={3.0375,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-19",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[520] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5185bdff",["id"]="bilinear-computed-19",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[521] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5185bdff",["id"]="bilinear-write-19",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[522] = scene:rectangle {["center"]={3.0375,1.1625},["fill"]="#5185bdff",["id"]="bilinear-committed-19",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[523] = scene:group {["id"]="bilinear-read-20",["opacity"]=0}
refs[524] = refs[523]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-20-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[525] = refs[523]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-20-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[526] = refs[523]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#5085bfff",["id"]="bilinear-weight-20-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[527] = refs[523]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-20-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[528] = refs[523]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-20-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[529] = refs[523]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#fad635ff",["id"]="bilinear-weight-20-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[530] = refs[523]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-20-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[531] = refs[523]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-20-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[532] = refs[523]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#508ebfff",["id"]="bilinear-weight-20-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[533] = refs[523]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-20-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[534] = refs[523]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-20-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[535] = refs[523]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#fad63eff",["id"]="bilinear-weight-20-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[536] = refs[523]:line {["from"]={-2.298166671593984,1.2865000049273172},["id"]="bilinear-sample-h-20",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,1.2865000049273172},["width"]=2}
refs[537] = refs[523]:line {["from"]={-2.2281666715939843,1.3565000049273173},["id"]="bilinear-sample-v-20",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,1.2165000049273171},["width"]=2}
refs[538] = refs[523]:rectangle {["center"]={3.2958333333333325,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-20",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[539] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6ae78ff",["id"]="bilinear-computed-20",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[540] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6ae78ff",["id"]="bilinear-write-20",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[541] = scene:rectangle {["center"]={3.2958333333333325,1.1625},["fill"]="#a6ae78ff",["id"]="bilinear-committed-20",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[542] = scene:group {["id"]="bilinear-read-21",["opacity"]=0}
refs[543] = refs[542]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-21-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[544] = refs[542]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-21-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[545] = refs[542]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#fad635ff",["id"]="bilinear-weight-21-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[546] = refs[542]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-21-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[547] = refs[542]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-21-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[548] = refs[542]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fada35ff",["id"]="bilinear-weight-21-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[549] = refs[542]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-21-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[550] = refs[542]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-21-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[551] = refs[542]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#fad63eff",["id"]="bilinear-weight-21-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[552] = refs[542]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-21-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[553] = refs[542]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-21-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[554] = refs[542]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#fada3eff",["id"]="bilinear-weight-21-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[555] = refs[542]:line {["from"]={-2.0398332150777185,1.2865000049273172},["id"]="bilinear-sample-h-21",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,1.2865000049273172},["width"]=2}
refs[556] = refs[542]:line {["from"]={-1.9698332150777185,1.3565000049273173},["id"]="bilinear-sample-v-21",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,1.2165000049273171},["width"]=2}
refs[557] = refs[542]:rectangle {["center"]={3.5541666666666663,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-21",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[558] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad635ff",["id"]="bilinear-computed-21",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[559] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad635ff",["id"]="bilinear-write-21",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[560] = scene:rectangle {["center"]={3.5541666666666663,1.1625},["fill"]="#fad635ff",["id"]="bilinear-committed-21",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[561] = scene:group {["id"]="bilinear-read-22",["opacity"]=0}
refs[562] = refs[561]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-22-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[563] = refs[561]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-22-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[564] = refs[561]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#fad635ff",["id"]="bilinear-weight-22-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[565] = refs[561]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-22-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[566] = refs[561]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-22-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[567] = refs[561]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#fada35ff",["id"]="bilinear-weight-22-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[568] = refs[561]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-22-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[569] = refs[561]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-22-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[570] = refs[561]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#fad63eff",["id"]="bilinear-weight-22-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[571] = refs[561]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-22-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[572] = refs[561]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-22-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[573] = refs[561]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#fada3eff",["id"]="bilinear-weight-22-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[574] = refs[561]:line {["from"]={-1.7814998817443848,1.2865000049273172},["id"]="bilinear-sample-h-22",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,1.2865000049273172},["width"]=2}
refs[575] = refs[561]:line {["from"]={-1.7114998817443847,1.3565000049273173},["id"]="bilinear-sample-v-22",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,1.2165000049273171},["width"]=2}
refs[576] = refs[561]:rectangle {["center"]={3.8125,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-22",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[577] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad835ff",["id"]="bilinear-computed-22",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[578] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad835ff",["id"]="bilinear-write-22",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[579] = scene:rectangle {["center"]={3.8125,1.1625},["fill"]="#fad835ff",["id"]="bilinear-committed-22",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[580] = scene:group {["id"]="bilinear-read-23",["opacity"]=0}
refs[581] = refs[580]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-23-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[582] = refs[580]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-23-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[583] = refs[580]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#fada35ff",["id"]="bilinear-weight-23-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[584] = refs[580]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-23-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[585] = refs[580]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-23-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[586] = refs[580]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fada35ff",["id"]="bilinear-weight-23-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[587] = refs[580]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-23-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[588] = refs[580]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-23-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[589] = refs[580]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#fada3eff",["id"]="bilinear-weight-23-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[590] = refs[580]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-23-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[591] = refs[580]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-23-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[592] = refs[580]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#fada3eff",["id"]="bilinear-weight-23-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[593] = refs[580]:line {["from"]={-1.5231665484110517,1.2865000049273172},["id"]="bilinear-sample-h-23",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,1.2865000049273172},["width"]=2}
refs[594] = refs[580]:line {["from"]={-1.4531665484110516,1.3565000049273173},["id"]="bilinear-sample-v-23",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,1.2165000049273171},["width"]=2}
refs[595] = refs[580]:rectangle {["center"]={4.070833333333333,1.1625},["fill"]="#00000000",["id"]="bilinear-destination-23",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[596] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada35ff",["id"]="bilinear-computed-23",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[597] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada35ff",["id"]="bilinear-write-23",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[598] = scene:rectangle {["center"]={4.070833333333333,1.1625},["fill"]="#fada35ff",["id"]="bilinear-committed-23",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[599] = scene:group {["id"]="bilinear-read-24",["opacity"]=0}
refs[600] = refs[599]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-24-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[601] = refs[599]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-24-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[602] = refs[599]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#3585cbff",["id"]="bilinear-weight-24-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[603] = refs[599]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-24-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[604] = refs[599]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-24-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[605] = refs[599]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#358ecbff",["id"]="bilinear-weight-24-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[606] = refs[599]:line {["from"]={-4.364833338260651,1.0281666715939841},["id"]="bilinear-sample-h-24",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,1.0281666715939841},["width"]=2}
refs[607] = refs[599]:line {["from"]={-4.29483333826065,1.098166671593984},["id"]="bilinear-sample-v-24",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,0.958166671593984},["width"]=2}
refs[608] = refs[599]:rectangle {["center"]={1.2291666666666663,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-24",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[609] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3589cbff",["id"]="bilinear-computed-24",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[610] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3589cbff",["id"]="bilinear-write-24",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[611] = scene:rectangle {["center"]={1.2291666666666663,0.9041666666666669},["fill"]="#3589cbff",["id"]="bilinear-committed-24",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[612] = scene:group {["id"]="bilinear-read-25",["opacity"]=0}
refs[613] = refs[612]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-25-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[614] = refs[612]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-25-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[615] = refs[612]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3585cbff",["id"]="bilinear-weight-25-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[616] = refs[612]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-25-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[617] = refs[612]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-25-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[618] = refs[612]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-25-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[619] = refs[612]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-25-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[620] = refs[612]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-25-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[621] = refs[612]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#358ecbff",["id"]="bilinear-weight-25-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[622] = refs[612]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-25-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[623] = refs[612]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-25-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[624] = refs[612]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-25-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[625] = refs[612]:line {["from"]={-4.106500004927318,1.0281666715939841},["id"]="bilinear-sample-h-25",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,1.0281666715939841},["width"]=2}
refs[626] = refs[612]:line {["from"]={-4.036500004927317,1.098166671593984},["id"]="bilinear-sample-v-25",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,0.958166671593984},["width"]=2}
refs[627] = refs[612]:rectangle {["center"]={1.4875,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-25",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[628] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3589caff",["id"]="bilinear-computed-25",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[629] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3589caff",["id"]="bilinear-write-25",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[630] = scene:rectangle {["center"]={1.4875,0.9041666666666669},["fill"]="#3589caff",["id"]="bilinear-committed-25",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[631] = scene:group {["id"]="bilinear-read-26",["opacity"]=0}
refs[632] = refs[631]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-26-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[633] = refs[631]:rectangle {["center"]={-4.041666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-26-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[634] = refs[631]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3585cbff",["id"]="bilinear-weight-26-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[635] = refs[631]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-26-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[636] = refs[631]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-26-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[637] = refs[631]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-26-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[638] = refs[631]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-26-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[639] = refs[631]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-26-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[640] = refs[631]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#358ecbff",["id"]="bilinear-weight-26-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[641] = refs[631]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-26-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[642] = refs[631]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-26-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[643] = refs[631]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-26-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[644] = refs[631]:line {["from"]={-3.8481666715939844,1.0281666715939841},["id"]="bilinear-sample-h-26",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,1.0281666715939841},["width"]=2}
refs[645] = refs[631]:line {["from"]={-3.7781666715939846,1.098166671593984},["id"]="bilinear-sample-v-26",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,0.958166671593984},["width"]=2}
refs[646] = refs[631]:rectangle {["center"]={1.7458333333333338,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-26",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[647] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3989c8ff",["id"]="bilinear-computed-26",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[648] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3989c8ff",["id"]="bilinear-write-26",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[649] = scene:rectangle {["center"]={1.7458333333333338,0.9041666666666669},["fill"]="#3989c8ff",["id"]="bilinear-committed-26",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[650] = scene:group {["id"]="bilinear-read-27",["opacity"]=0}
refs[651] = refs[650]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-27-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[652] = refs[650]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-27-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[653] = refs[650]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-27-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[654] = refs[650]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-27-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[655] = refs[650]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-27-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[656] = refs[650]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-27-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[657] = refs[650]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-27-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[658] = refs[650]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-27-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[659] = refs[650]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-27-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[660] = refs[650]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-27-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[661] = refs[650]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-27-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[662] = refs[650]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-27-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[663] = refs[650]:line {["from"]={-3.5898333382606507,1.0281666715939841},["id"]="bilinear-sample-h-27",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,1.0281666715939841},["width"]=2}
refs[664] = refs[650]:line {["from"]={-3.519833338260651,1.098166671593984},["id"]="bilinear-sample-v-27",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,0.958166671593984},["width"]=2}
refs[665] = refs[650]:rectangle {["center"]={2.0041666666666664,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-27",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[666] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e89c6ff",["id"]="bilinear-computed-27",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[667] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e89c6ff",["id"]="bilinear-write-27",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[668] = scene:rectangle {["center"]={2.0041666666666664,0.9041666666666669},["fill"]="#3e89c6ff",["id"]="bilinear-committed-27",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[669] = scene:group {["id"]="bilinear-read-28",["opacity"]=0}
refs[670] = refs[669]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-28-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[671] = refs[669]:rectangle {["center"]={-3.525,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-28-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[672] = refs[669]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3e85c7ff",["id"]="bilinear-weight-28-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[673] = refs[669]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-28-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[674] = refs[669]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-28-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[675] = refs[669]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-28-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[676] = refs[669]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-28-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[677] = refs[669]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-28-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[678] = refs[669]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-28-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[679] = refs[669]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-28-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[680] = refs[669]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-28-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[681] = refs[669]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-28-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[682] = refs[669]:line {["from"]={-3.3315000049273173,1.0281666715939841},["id"]="bilinear-sample-h-28",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,1.0281666715939841},["width"]=2}
refs[683] = refs[669]:line {["from"]={-3.2615000049273175,1.098166671593984},["id"]="bilinear-sample-v-28",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,0.958166671593984},["width"]=2}
refs[684] = refs[669]:rectangle {["center"]={2.2625,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-28",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[685] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4289c4ff",["id"]="bilinear-computed-28",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[686] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4289c4ff",["id"]="bilinear-write-28",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[687] = scene:rectangle {["center"]={2.2625,0.9041666666666669},["fill"]="#4289c4ff",["id"]="bilinear-committed-28",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[688] = scene:group {["id"]="bilinear-read-29",["opacity"]=0}
refs[689] = refs[688]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-29-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[690] = refs[688]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-29-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[691] = refs[688]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-29-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[692] = refs[688]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-29-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[693] = refs[688]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-29-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[694] = refs[688]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#5085bfff",["id"]="bilinear-weight-29-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[695] = refs[688]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-29-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[696] = refs[688]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-29-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[697] = refs[688]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-29-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[698] = refs[688]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-29-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[699] = refs[688]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-29-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[700] = refs[688]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#508ebfff",["id"]="bilinear-weight-29-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[701] = refs[688]:line {["from"]={-3.0731666715939845,1.0281666715939841},["id"]="bilinear-sample-h-29",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,1.0281666715939841},["width"]=2}
refs[702] = refs[688]:line {["from"]={-3.003166671593984,1.098166671593984},["id"]="bilinear-sample-v-29",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,0.958166671593984},["width"]=2}
refs[703] = refs[688]:rectangle {["center"]={2.5208333333333326,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-29",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[704] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4789c2ff",["id"]="bilinear-computed-29",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[705] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4789c2ff",["id"]="bilinear-write-29",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[706] = scene:rectangle {["center"]={2.5208333333333326,0.9041666666666669},["fill"]="#4789c2ff",["id"]="bilinear-committed-29",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[707] = scene:group {["id"]="bilinear-read-30",["opacity"]=0}
refs[708] = refs[707]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-30-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[709] = refs[707]:rectangle {["center"]={-3.0083333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-30-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[710] = refs[707]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#4785c3ff",["id"]="bilinear-weight-30-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[711] = refs[707]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-30-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[712] = refs[707]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-30-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[713] = refs[707]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#5085bfff",["id"]="bilinear-weight-30-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[714] = refs[707]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-30-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[715] = refs[707]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-30-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[716] = refs[707]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#478ec3ff",["id"]="bilinear-weight-30-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[717] = refs[707]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-30-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[718] = refs[707]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-30-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[719] = refs[707]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#508ebfff",["id"]="bilinear-weight-30-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[720] = refs[707]:line {["from"]={-2.8148333382606507,1.0281666715939841},["id"]="bilinear-sample-h-30",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,1.0281666715939841},["width"]=2}
refs[721] = refs[707]:line {["from"]={-2.7448333382606505,1.098166671593984},["id"]="bilinear-sample-v-30",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,0.958166671593984},["width"]=2}
refs[722] = refs[707]:rectangle {["center"]={2.7791666666666663,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-30",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[723] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b89c0ff",["id"]="bilinear-computed-30",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[724] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b89c0ff",["id"]="bilinear-write-30",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[725] = scene:rectangle {["center"]={2.7791666666666663,0.9041666666666669},["fill"]="#4b89c0ff",["id"]="bilinear-committed-30",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[726] = scene:group {["id"]="bilinear-read-31",["opacity"]=0}
refs[727] = refs[726]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-31-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[728] = refs[726]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-31-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[729] = refs[726]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#5085bfff",["id"]="bilinear-weight-31-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[730] = refs[726]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-31-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[731] = refs[726]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-31-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[732] = refs[726]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fad635ff",["id"]="bilinear-weight-31-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[733] = refs[726]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-31-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[734] = refs[726]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-31-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[735] = refs[726]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#508ebfff",["id"]="bilinear-weight-31-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[736] = refs[726]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-31-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[737] = refs[726]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-31-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[738] = refs[726]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#fad63eff",["id"]="bilinear-weight-31-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[739] = refs[726]:line {["from"]={-2.5565000049273174,1.0281666715939841},["id"]="bilinear-sample-h-31",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,1.0281666715939841},["width"]=2}
refs[740] = refs[726]:line {["from"]={-2.4865000049273176,1.098166671593984},["id"]="bilinear-sample-v-31",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,0.958166671593984},["width"]=2}
refs[741] = refs[726]:rectangle {["center"]={3.0375,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-31",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[742] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5189bdff",["id"]="bilinear-computed-31",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[743] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5189bdff",["id"]="bilinear-write-31",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[744] = scene:rectangle {["center"]={3.0375,0.9041666666666669},["fill"]="#5189bdff",["id"]="bilinear-committed-31",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[745] = scene:group {["id"]="bilinear-read-32",["opacity"]=0}
refs[746] = refs[745]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-32-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[747] = refs[745]:rectangle {["center"]={-2.4916666666666667,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-32-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[748] = refs[745]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#5085bfff",["id"]="bilinear-weight-32-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[749] = refs[745]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-32-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[750] = refs[745]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-32-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[751] = refs[745]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#fad635ff",["id"]="bilinear-weight-32-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[752] = refs[745]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-32-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[753] = refs[745]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-32-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[754] = refs[745]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#508ebfff",["id"]="bilinear-weight-32-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[755] = refs[745]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-32-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[756] = refs[745]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-32-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[757] = refs[745]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#fad63eff",["id"]="bilinear-weight-32-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[758] = refs[745]:group {["id"]="bilinear-horizontal-32",["opacity"]=0}
refs[759] = refs[758]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#a6ae78ff",["id"]="bilinear-top-mix-32",["layer"]=23,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[760] = refs[758]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#a6b27dff",["id"]="bilinear-bottom-mix-32",["layer"]=23,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[761] = refs[745]:line {["from"]={-2.298166671593984,1.0281666715939841},["id"]="bilinear-sample-h-32",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,1.0281666715939841},["width"]=2}
refs[762] = refs[745]:line {["from"]={-2.2281666715939843,1.098166671593984},["id"]="bilinear-sample-v-32",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,0.958166671593984},["width"]=2}
refs[763] = refs[745]:rectangle {["center"]={3.2958333333333325,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-32",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[764] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6b07aff",["id"]="bilinear-computed-32",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[765] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a6b07aff",["id"]="bilinear-write-32",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[766] = scene:rectangle {["center"]={3.2958333333333325,0.9041666666666669},["fill"]="#a6b07aff",["id"]="bilinear-committed-32",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[767] = scene:group {["id"]="bilinear-read-33",["opacity"]=0}
refs[768] = refs[767]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-33-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[769] = refs[767]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-33-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[770] = refs[767]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#fad635ff",["id"]="bilinear-weight-33-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[771] = refs[767]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-33-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[772] = refs[767]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-33-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[773] = refs[767]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fada35ff",["id"]="bilinear-weight-33-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[774] = refs[767]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-33-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[775] = refs[767]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-33-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[776] = refs[767]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#fad63eff",["id"]="bilinear-weight-33-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[777] = refs[767]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-33-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[778] = refs[767]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-33-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[779] = refs[767]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#fada3eff",["id"]="bilinear-weight-33-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[780] = refs[767]:line {["from"]={-2.0398332150777185,1.0281666715939841},["id"]="bilinear-sample-h-33",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,1.0281666715939841},["width"]=2}
refs[781] = refs[767]:line {["from"]={-1.9698332150777185,1.098166671593984},["id"]="bilinear-sample-v-33",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,0.958166671593984},["width"]=2}
refs[782] = refs[767]:rectangle {["center"]={3.5541666666666663,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-33",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[783] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad639ff",["id"]="bilinear-computed-33",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[784] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad639ff",["id"]="bilinear-write-33",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[785] = scene:rectangle {["center"]={3.5541666666666663,0.9041666666666669},["fill"]="#fad639ff",["id"]="bilinear-committed-33",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[786] = scene:group {["id"]="bilinear-read-34",["opacity"]=0}
refs[787] = refs[786]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-34-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[788] = refs[786]:rectangle {["center"]={-1.975,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-34-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[789] = refs[786]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#fad635ff",["id"]="bilinear-weight-34-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[790] = refs[786]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-34-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[791] = refs[786]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-34-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[792] = refs[786]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#fada35ff",["id"]="bilinear-weight-34-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[793] = refs[786]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-34-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[794] = refs[786]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-34-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[795] = refs[786]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#fad63eff",["id"]="bilinear-weight-34-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[796] = refs[786]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-34-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[797] = refs[786]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-34-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[798] = refs[786]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#fada3eff",["id"]="bilinear-weight-34-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[799] = refs[786]:line {["from"]={-1.7814998817443848,1.0281666715939841},["id"]="bilinear-sample-h-34",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,1.0281666715939841},["width"]=2}
refs[800] = refs[786]:line {["from"]={-1.7114998817443847,1.098166671593984},["id"]="bilinear-sample-v-34",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,0.958166671593984},["width"]=2}
refs[801] = refs[786]:rectangle {["center"]={3.8125,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-34",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[802] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad839ff",["id"]="bilinear-computed-34",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[803] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fad839ff",["id"]="bilinear-write-34",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[804] = scene:rectangle {["center"]={3.8125,0.9041666666666669},["fill"]="#fad839ff",["id"]="bilinear-committed-34",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[805] = scene:group {["id"]="bilinear-read-35",["opacity"]=0}
refs[806] = refs[805]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-35-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[807] = refs[805]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-35-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[808] = refs[805]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#fada35ff",["id"]="bilinear-weight-35-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[809] = refs[805]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-35-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[810] = refs[805]:rectangle {["center"]={-1.4583333333333337,1.2916666666666665},["fill"]="#00000000",["id"]="bilinear-tap-ink-35-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[811] = refs[805]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fada35ff",["id"]="bilinear-weight-35-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[812] = refs[805]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-35-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[813] = refs[805]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-35-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[814] = refs[805]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#fada3eff",["id"]="bilinear-weight-35-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[815] = refs[805]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-35-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[816] = refs[805]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-35-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[817] = refs[805]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#fada3eff",["id"]="bilinear-weight-35-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[818] = refs[805]:line {["from"]={-1.5231665484110517,1.0281666715939841},["id"]="bilinear-sample-h-35",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,1.0281666715939841},["width"]=2}
refs[819] = refs[805]:line {["from"]={-1.4531665484110516,1.098166671593984},["id"]="bilinear-sample-v-35",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,0.958166671593984},["width"]=2}
refs[820] = refs[805]:rectangle {["center"]={4.070833333333333,0.9041666666666669},["fill"]="#00000000",["id"]="bilinear-destination-35",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[821] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada39ff",["id"]="bilinear-computed-35",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[822] = scene:rectangle {["center"]={-0.05,0},["fill"]="#fada39ff",["id"]="bilinear-write-35",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[823] = scene:rectangle {["center"]={4.070833333333333,0.9041666666666669},["fill"]="#fada39ff",["id"]="bilinear-committed-35",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[824] = scene:group {["id"]="bilinear-read-36",["opacity"]=0}
refs[825] = refs[824]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-36-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[826] = refs[824]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-36-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[827] = refs[824]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#358ecbff",["id"]="bilinear-weight-36-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[828] = refs[824]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-36-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[829] = refs[824]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-36-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[830] = refs[824]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#3597cbff",["id"]="bilinear-weight-36-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[831] = refs[824]:line {["from"]={-4.364833338260651,0.7698333382606506},["id"]="bilinear-sample-h-36",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,0.7698333382606506},["width"]=2}
refs[832] = refs[824]:line {["from"]={-4.29483333826065,0.8398333382606507},["id"]="bilinear-sample-v-36",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,0.6998333382606506},["width"]=2}
refs[833] = refs[824]:rectangle {["center"]={1.2291666666666663,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-36",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[834] = scene:rectangle {["center"]={-0.05,0},["fill"]="#358ecbff",["id"]="bilinear-computed-36",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[835] = scene:rectangle {["center"]={-0.05,0},["fill"]="#358ecbff",["id"]="bilinear-write-36",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[836] = scene:rectangle {["center"]={1.2291666666666663,0.6458333333333335},["fill"]="#358ecbff",["id"]="bilinear-committed-36",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[837] = scene:group {["id"]="bilinear-read-37",["opacity"]=0}
refs[838] = refs[837]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-37-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[839] = refs[837]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-37-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[840] = refs[837]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#358ecbff",["id"]="bilinear-weight-37-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[841] = refs[837]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-37-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[842] = refs[837]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-37-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[843] = refs[837]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-37-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[844] = refs[837]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-37-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[845] = refs[837]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-37-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[846] = refs[837]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3597cbff",["id"]="bilinear-weight-37-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[847] = refs[837]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-37-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[848] = refs[837]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-37-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[849] = refs[837]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-37-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[850] = refs[837]:line {["from"]={-4.106500004927318,0.7698333382606506},["id"]="bilinear-sample-h-37",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,0.7698333382606506},["width"]=2}
refs[851] = refs[837]:line {["from"]={-4.036500004927317,0.8398333382606507},["id"]="bilinear-sample-v-37",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,0.6998333382606506},["width"]=2}
refs[852] = refs[837]:rectangle {["center"]={1.4875,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-37",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[853] = scene:rectangle {["center"]={-0.05,0},["fill"]="#358ecaff",["id"]="bilinear-computed-37",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[854] = scene:rectangle {["center"]={-0.05,0},["fill"]="#358ecaff",["id"]="bilinear-write-37",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[855] = scene:rectangle {["center"]={1.4875,0.6458333333333335},["fill"]="#358ecaff",["id"]="bilinear-committed-37",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[856] = scene:group {["id"]="bilinear-read-38",["opacity"]=0}
refs[857] = refs[856]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-38-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[858] = refs[856]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-38-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[859] = refs[856]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#358ecbff",["id"]="bilinear-weight-38-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[860] = refs[856]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-38-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[861] = refs[856]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-38-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[862] = refs[856]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-38-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[863] = refs[856]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-38-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[864] = refs[856]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-38-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[865] = refs[856]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#3597cbff",["id"]="bilinear-weight-38-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[866] = refs[856]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-38-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[867] = refs[856]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-38-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[868] = refs[856]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-38-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[869] = refs[856]:line {["from"]={-3.8481666715939844,0.7698333382606506},["id"]="bilinear-sample-h-38",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,0.7698333382606506},["width"]=2}
refs[870] = refs[856]:line {["from"]={-3.7781666715939846,0.8398333382606507},["id"]="bilinear-sample-v-38",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,0.6998333382606506},["width"]=2}
refs[871] = refs[856]:rectangle {["center"]={1.7458333333333338,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-38",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[872] = scene:rectangle {["center"]={-0.05,0},["fill"]="#398ec8ff",["id"]="bilinear-computed-38",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[873] = scene:rectangle {["center"]={-0.05,0},["fill"]="#398ec8ff",["id"]="bilinear-write-38",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[874] = scene:rectangle {["center"]={1.7458333333333338,0.6458333333333335},["fill"]="#398ec8ff",["id"]="bilinear-committed-38",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[875] = scene:group {["id"]="bilinear-read-39",["opacity"]=0}
refs[876] = refs[875]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-39-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[877] = refs[875]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-39-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[878] = refs[875]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-39-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[879] = refs[875]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-39-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[880] = refs[875]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-39-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[881] = refs[875]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-39-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[882] = refs[875]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-39-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[883] = refs[875]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-39-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[884] = refs[875]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-39-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[885] = refs[875]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-39-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[886] = refs[875]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-39-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[887] = refs[875]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-39-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[888] = refs[875]:line {["from"]={-3.5898333382606507,0.7698333382606506},["id"]="bilinear-sample-h-39",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,0.7698333382606506},["width"]=2}
refs[889] = refs[875]:line {["from"]={-3.519833338260651,0.8398333382606507},["id"]="bilinear-sample-v-39",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,0.6998333382606506},["width"]=2}
refs[890] = refs[875]:rectangle {["center"]={2.0041666666666664,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-39",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[891] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e8ec6ff",["id"]="bilinear-computed-39",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[892] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e8ec6ff",["id"]="bilinear-write-39",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[893] = scene:rectangle {["center"]={2.0041666666666664,0.6458333333333335},["fill"]="#3e8ec6ff",["id"]="bilinear-committed-39",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[894] = scene:group {["id"]="bilinear-read-40",["opacity"]=0}
refs[895] = refs[894]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-40-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[896] = refs[894]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-40-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[897] = refs[894]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-40-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[898] = refs[894]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-40-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[899] = refs[894]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-40-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[900] = refs[894]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-40-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[901] = refs[894]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-40-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[902] = refs[894]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-40-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[903] = refs[894]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-40-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[904] = refs[894]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-40-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[905] = refs[894]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-40-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[906] = refs[894]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-40-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[907] = refs[894]:line {["from"]={-3.3315000049273173,0.7698333382606506},["id"]="bilinear-sample-h-40",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,0.7698333382606506},["width"]=2}
refs[908] = refs[894]:line {["from"]={-3.2615000049273175,0.8398333382606507},["id"]="bilinear-sample-v-40",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,0.6998333382606506},["width"]=2}
refs[909] = refs[894]:rectangle {["center"]={2.2625,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-40",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[910] = scene:rectangle {["center"]={-0.05,0},["fill"]="#428ec4ff",["id"]="bilinear-computed-40",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[911] = scene:rectangle {["center"]={-0.05,0},["fill"]="#428ec4ff",["id"]="bilinear-write-40",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[912] = scene:rectangle {["center"]={2.2625,0.6458333333333335},["fill"]="#428ec4ff",["id"]="bilinear-committed-40",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[913] = scene:group {["id"]="bilinear-read-41",["opacity"]=0}
refs[914] = refs[913]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-41-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[915] = refs[913]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-41-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[916] = refs[913]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-41-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[917] = refs[913]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-41-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[918] = refs[913]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-41-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[919] = refs[913]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#508ebfff",["id"]="bilinear-weight-41-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[920] = refs[913]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-41-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[921] = refs[913]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-41-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[922] = refs[913]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-41-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[923] = refs[913]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-41-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[924] = refs[913]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-41-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[925] = refs[913]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#5097bfff",["id"]="bilinear-weight-41-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[926] = refs[913]:line {["from"]={-3.0731666715939845,0.7698333382606506},["id"]="bilinear-sample-h-41",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,0.7698333382606506},["width"]=2}
refs[927] = refs[913]:line {["from"]={-3.003166671593984,0.8398333382606507},["id"]="bilinear-sample-v-41",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,0.6998333382606506},["width"]=2}
refs[928] = refs[913]:rectangle {["center"]={2.5208333333333326,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-41",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[929] = scene:rectangle {["center"]={-0.05,0},["fill"]="#478ec2ff",["id"]="bilinear-computed-41",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[930] = scene:rectangle {["center"]={-0.05,0},["fill"]="#478ec2ff",["id"]="bilinear-write-41",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[931] = scene:rectangle {["center"]={2.5208333333333326,0.6458333333333335},["fill"]="#478ec2ff",["id"]="bilinear-committed-41",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[932] = scene:group {["id"]="bilinear-read-42",["opacity"]=0}
refs[933] = refs[932]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-42-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[934] = refs[932]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-42-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[935] = refs[932]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-42-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[936] = refs[932]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-42-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[937] = refs[932]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-42-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[938] = refs[932]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#508ebfff",["id"]="bilinear-weight-42-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[939] = refs[932]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-42-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[940] = refs[932]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-42-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[941] = refs[932]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-42-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[942] = refs[932]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-42-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[943] = refs[932]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-42-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[944] = refs[932]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#5097bfff",["id"]="bilinear-weight-42-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[945] = refs[932]:line {["from"]={-2.8148333382606507,0.7698333382606506},["id"]="bilinear-sample-h-42",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,0.7698333382606506},["width"]=2}
refs[946] = refs[932]:line {["from"]={-2.7448333382606505,0.8398333382606507},["id"]="bilinear-sample-v-42",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,0.6998333382606506},["width"]=2}
refs[947] = refs[932]:rectangle {["center"]={2.7791666666666663,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-42",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[948] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b8ec0ff",["id"]="bilinear-computed-42",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[949] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b8ec0ff",["id"]="bilinear-write-42",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[950] = scene:rectangle {["center"]={2.7791666666666663,0.6458333333333335},["fill"]="#4b8ec0ff",["id"]="bilinear-committed-42",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[951] = scene:group {["id"]="bilinear-read-43",["opacity"]=0}
refs[952] = refs[951]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-43-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[953] = refs[951]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-43-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[954] = refs[951]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#508ebfff",["id"]="bilinear-weight-43-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[955] = refs[951]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-43-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[956] = refs[951]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-43-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[957] = refs[951]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fad63eff",["id"]="bilinear-weight-43-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[958] = refs[951]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-43-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[959] = refs[951]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-43-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[960] = refs[951]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#5097bfff",["id"]="bilinear-weight-43-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[961] = refs[951]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-43-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[962] = refs[951]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-43-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[963] = refs[951]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#5997bbff",["id"]="bilinear-weight-43-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[964] = refs[951]:line {["from"]={-2.5565000049273174,0.7698333382606506},["id"]="bilinear-sample-h-43",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,0.7698333382606506},["width"]=2}
refs[965] = refs[951]:line {["from"]={-2.4865000049273176,0.8398333382606507},["id"]="bilinear-sample-v-43",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,0.6998333382606506},["width"]=2}
refs[966] = refs[951]:rectangle {["center"]={3.0375,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-43",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[967] = scene:rectangle {["center"]={-0.05,0},["fill"]="#508ebdff",["id"]="bilinear-computed-43",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[968] = scene:rectangle {["center"]={-0.05,0},["fill"]="#508ebdff",["id"]="bilinear-write-43",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[969] = scene:rectangle {["center"]={3.0375,0.6458333333333335},["fill"]="#508ebdff",["id"]="bilinear-committed-43",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[970] = scene:group {["id"]="bilinear-read-44",["opacity"]=0}
refs[971] = refs[970]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-44-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[972] = refs[970]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-44-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[973] = refs[970]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#508ebfff",["id"]="bilinear-weight-44-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[974] = refs[970]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-44-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[975] = refs[970]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-44-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[976] = refs[970]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#fad63eff",["id"]="bilinear-weight-44-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[977] = refs[970]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-44-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[978] = refs[970]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-44-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[979] = refs[970]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#5097bfff",["id"]="bilinear-weight-44-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[980] = refs[970]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-44-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[981] = refs[970]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-44-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[982] = refs[970]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#5997bbff",["id"]="bilinear-weight-44-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[983] = refs[970]:line {["from"]={-2.298166671593984,0.7698333382606506},["id"]="bilinear-sample-h-44",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,0.7698333382606506},["width"]=2}
refs[984] = refs[970]:line {["from"]={-2.2281666715939843,0.8398333382606507},["id"]="bilinear-sample-v-44",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,0.6998333382606506},["width"]=2}
refs[985] = refs[970]:rectangle {["center"]={3.2958333333333325,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-44",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[986] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a5b17dff",["id"]="bilinear-computed-44",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[987] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a5b17dff",["id"]="bilinear-write-44",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[988] = scene:rectangle {["center"]={3.2958333333333325,0.6458333333333335},["fill"]="#a5b17dff",["id"]="bilinear-committed-44",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[989] = scene:group {["id"]="bilinear-read-45",["opacity"]=0}
refs[990] = refs[989]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-45-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[991] = refs[989]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-45-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[992] = refs[989]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#fad63eff",["id"]="bilinear-weight-45-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[993] = refs[989]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-45-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[994] = refs[989]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-45-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[995] = refs[989]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fada3eff",["id"]="bilinear-weight-45-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[996] = refs[989]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-45-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[997] = refs[989]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-45-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[998] = refs[989]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#5997bbff",["id"]="bilinear-weight-45-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[999] = refs[989]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-45-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1000] = refs[989]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-45-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1001] = refs[989]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-45-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1002] = refs[989]:line {["from"]={-2.0398332150777185,0.7698333382606506},["id"]="bilinear-sample-h-45",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,0.7698333382606506},["width"]=2}
refs[1003] = refs[989]:line {["from"]={-1.9698332150777185,0.8398333382606507},["id"]="bilinear-sample-v-45",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,0.6998333382606506},["width"]=2}
refs[1004] = refs[989]:rectangle {["center"]={3.5541666666666663,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-45",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1005] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d53eff",["id"]="bilinear-computed-45",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1006] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d53eff",["id"]="bilinear-write-45",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1007] = scene:rectangle {["center"]={3.5541666666666663,0.6458333333333335},["fill"]="#f8d53eff",["id"]="bilinear-committed-45",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1008] = scene:group {["id"]="bilinear-read-46",["opacity"]=0}
refs[1009] = refs[1008]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-46-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1010] = refs[1008]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-46-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1011] = refs[1008]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#fad63eff",["id"]="bilinear-weight-46-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1012] = refs[1008]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-46-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1013] = refs[1008]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-46-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1014] = refs[1008]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#fada3eff",["id"]="bilinear-weight-46-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1015] = refs[1008]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-46-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1016] = refs[1008]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-46-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1017] = refs[1008]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#5997bbff",["id"]="bilinear-weight-46-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1018] = refs[1008]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-46-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1019] = refs[1008]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-46-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1020] = refs[1008]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-46-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1021] = refs[1008]:line {["from"]={-1.7814998817443848,0.7698333382606506},["id"]="bilinear-sample-h-46",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,0.7698333382606506},["width"]=2}
refs[1022] = refs[1008]:line {["from"]={-1.7114998817443847,0.8398333382606507},["id"]="bilinear-sample-v-46",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,0.6998333382606506},["width"]=2}
refs[1023] = refs[1008]:rectangle {["center"]={3.8125,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-46",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1024] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d73eff",["id"]="bilinear-computed-46",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1025] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d73eff",["id"]="bilinear-write-46",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1026] = scene:rectangle {["center"]={3.8125,0.6458333333333335},["fill"]="#f8d73eff",["id"]="bilinear-committed-46",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1027] = scene:group {["id"]="bilinear-read-47",["opacity"]=0}
refs[1028] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-47-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1029] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-47-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1030] = refs[1027]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#fada3eff",["id"]="bilinear-weight-47-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1031] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-47-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1032] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-47-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1033] = refs[1027]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#fada3eff",["id"]="bilinear-weight-47-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1034] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-47-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1035] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-47-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1036] = refs[1027]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-47-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1037] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-47-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1038] = refs[1027]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-47-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1039] = refs[1027]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-47-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1040] = refs[1027]:line {["from"]={-1.5231665484110517,0.7698333382606506},["id"]="bilinear-sample-h-47",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,0.7698333382606506},["width"]=2}
refs[1041] = refs[1027]:line {["from"]={-1.4531665484110516,0.8398333382606507},["id"]="bilinear-sample-v-47",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,0.6998333382606506},["width"]=2}
refs[1042] = refs[1027]:rectangle {["center"]={4.070833333333333,0.6458333333333335},["fill"]="#00000000",["id"]="bilinear-destination-47",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1043] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d93eff",["id"]="bilinear-computed-47",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1044] = scene:rectangle {["center"]={-0.05,0},["fill"]="#f8d93eff",["id"]="bilinear-write-47",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1045] = scene:rectangle {["center"]={4.070833333333333,0.6458333333333335},["fill"]="#f8d93eff",["id"]="bilinear-committed-47",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1046] = scene:group {["id"]="bilinear-read-48",["opacity"]=0}
refs[1047] = refs[1046]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-48-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1048] = refs[1046]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-48-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1049] = refs[1046]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#358ecbff",["id"]="bilinear-weight-48-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1050] = refs[1046]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-48-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1051] = refs[1046]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-48-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1052] = refs[1046]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#3597cbff",["id"]="bilinear-weight-48-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1053] = refs[1046]:line {["from"]={-4.364833338260651,0.5115000049273175},["id"]="bilinear-sample-h-48",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,0.5115000049273175},["width"]=2}
refs[1054] = refs[1046]:line {["from"]={-4.29483333826065,0.5815000049273175},["id"]="bilinear-sample-v-48",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,0.4415000049273175},["width"]=2}
refs[1055] = refs[1046]:rectangle {["center"]={1.2291666666666663,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-48",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1056] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3592cbff",["id"]="bilinear-computed-48",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1057] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3592cbff",["id"]="bilinear-write-48",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1058] = scene:rectangle {["center"]={1.2291666666666663,0.3875},["fill"]="#3592cbff",["id"]="bilinear-committed-48",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1059] = scene:group {["id"]="bilinear-read-49",["opacity"]=0}
refs[1060] = refs[1059]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-49-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1061] = refs[1059]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-49-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1062] = refs[1059]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#358ecbff",["id"]="bilinear-weight-49-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1063] = refs[1059]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-49-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1064] = refs[1059]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-49-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1065] = refs[1059]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-49-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1066] = refs[1059]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-49-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1067] = refs[1059]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-49-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1068] = refs[1059]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3597cbff",["id"]="bilinear-weight-49-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1069] = refs[1059]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-49-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1070] = refs[1059]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-49-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1071] = refs[1059]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-49-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1072] = refs[1059]:line {["from"]={-4.106500004927318,0.5115000049273175},["id"]="bilinear-sample-h-49",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,0.5115000049273175},["width"]=2}
refs[1073] = refs[1059]:line {["from"]={-4.036500004927317,0.5815000049273175},["id"]="bilinear-sample-v-49",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,0.4415000049273175},["width"]=2}
refs[1074] = refs[1059]:rectangle {["center"]={1.4875,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-49",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1075] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3592caff",["id"]="bilinear-computed-49",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1076] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3592caff",["id"]="bilinear-write-49",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1077] = scene:rectangle {["center"]={1.4875,0.3875},["fill"]="#3592caff",["id"]="bilinear-committed-49",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1078] = scene:group {["id"]="bilinear-read-50",["opacity"]=0}
refs[1079] = refs[1078]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-50-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1080] = refs[1078]:rectangle {["center"]={-4.041666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-50-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1081] = refs[1078]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#358ecbff",["id"]="bilinear-weight-50-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1082] = refs[1078]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-50-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1083] = refs[1078]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-50-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1084] = refs[1078]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-50-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1085] = refs[1078]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-50-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1086] = refs[1078]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-50-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1087] = refs[1078]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#3597cbff",["id"]="bilinear-weight-50-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1088] = refs[1078]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-50-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1089] = refs[1078]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-50-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1090] = refs[1078]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-50-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1091] = refs[1078]:line {["from"]={-3.8481666715939844,0.5115000049273175},["id"]="bilinear-sample-h-50",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,0.5115000049273175},["width"]=2}
refs[1092] = refs[1078]:line {["from"]={-3.7781666715939846,0.5815000049273175},["id"]="bilinear-sample-v-50",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,0.4415000049273175},["width"]=2}
refs[1093] = refs[1078]:rectangle {["center"]={1.7458333333333338,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-50",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1094] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3992c8ff",["id"]="bilinear-computed-50",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1095] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3992c8ff",["id"]="bilinear-write-50",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1096] = scene:rectangle {["center"]={1.7458333333333338,0.3875},["fill"]="#3992c8ff",["id"]="bilinear-committed-50",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1097] = scene:group {["id"]="bilinear-read-51",["opacity"]=0}
refs[1098] = refs[1097]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-51-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1099] = refs[1097]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-51-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1100] = refs[1097]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-51-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1101] = refs[1097]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-51-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1102] = refs[1097]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-51-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1103] = refs[1097]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-51-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1104] = refs[1097]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-51-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1105] = refs[1097]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-51-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1106] = refs[1097]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-51-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1107] = refs[1097]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-51-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1108] = refs[1097]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-51-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1109] = refs[1097]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-51-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1110] = refs[1097]:line {["from"]={-3.5898333382606507,0.5115000049273175},["id"]="bilinear-sample-h-51",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,0.5115000049273175},["width"]=2}
refs[1111] = refs[1097]:line {["from"]={-3.519833338260651,0.5815000049273175},["id"]="bilinear-sample-v-51",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,0.4415000049273175},["width"]=2}
refs[1112] = refs[1097]:rectangle {["center"]={2.0041666666666664,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-51",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1113] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e92c6ff",["id"]="bilinear-computed-51",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1114] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e92c6ff",["id"]="bilinear-write-51",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1115] = scene:rectangle {["center"]={2.0041666666666664,0.3875},["fill"]="#3e92c6ff",["id"]="bilinear-committed-51",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1116] = scene:group {["id"]="bilinear-read-52",["opacity"]=0}
refs[1117] = refs[1116]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-52-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1118] = refs[1116]:rectangle {["center"]={-3.525,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-52-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1119] = refs[1116]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3e8ec7ff",["id"]="bilinear-weight-52-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1120] = refs[1116]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-52-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1121] = refs[1116]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-52-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1122] = refs[1116]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-52-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1123] = refs[1116]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-52-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1124] = refs[1116]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-52-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1125] = refs[1116]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#3e97c7ff",["id"]="bilinear-weight-52-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1126] = refs[1116]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-52-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1127] = refs[1116]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-52-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1128] = refs[1116]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-52-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1129] = refs[1116]:line {["from"]={-3.3315000049273173,0.5115000049273175},["id"]="bilinear-sample-h-52",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,0.5115000049273175},["width"]=2}
refs[1130] = refs[1116]:line {["from"]={-3.2615000049273175,0.5815000049273175},["id"]="bilinear-sample-v-52",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,0.4415000049273175},["width"]=2}
refs[1131] = refs[1116]:rectangle {["center"]={2.2625,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-52",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1132] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4292c4ff",["id"]="bilinear-computed-52",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1133] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4292c4ff",["id"]="bilinear-write-52",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1134] = scene:rectangle {["center"]={2.2625,0.3875},["fill"]="#4292c4ff",["id"]="bilinear-committed-52",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1135] = scene:group {["id"]="bilinear-read-53",["opacity"]=0}
refs[1136] = refs[1135]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-53-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1137] = refs[1135]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-53-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1138] = refs[1135]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-53-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1139] = refs[1135]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-53-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1140] = refs[1135]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-53-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1141] = refs[1135]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#508ebfff",["id"]="bilinear-weight-53-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1142] = refs[1135]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-53-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1143] = refs[1135]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-53-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1144] = refs[1135]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-53-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1145] = refs[1135]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-53-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1146] = refs[1135]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-53-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1147] = refs[1135]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#5097bfff",["id"]="bilinear-weight-53-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1148] = refs[1135]:line {["from"]={-3.0731666715939845,0.5115000049273175},["id"]="bilinear-sample-h-53",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,0.5115000049273175},["width"]=2}
refs[1149] = refs[1135]:line {["from"]={-3.003166671593984,0.5815000049273175},["id"]="bilinear-sample-v-53",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,0.4415000049273175},["width"]=2}
refs[1150] = refs[1135]:rectangle {["center"]={2.5208333333333326,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-53",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1151] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4792c2ff",["id"]="bilinear-computed-53",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1152] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4792c2ff",["id"]="bilinear-write-53",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1153] = scene:rectangle {["center"]={2.5208333333333326,0.3875},["fill"]="#4792c2ff",["id"]="bilinear-committed-53",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1154] = scene:group {["id"]="bilinear-read-54",["opacity"]=0}
refs[1155] = refs[1154]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-54-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1156] = refs[1154]:rectangle {["center"]={-3.0083333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-54-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1157] = refs[1154]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#478ec3ff",["id"]="bilinear-weight-54-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1158] = refs[1154]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-54-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1159] = refs[1154]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-54-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1160] = refs[1154]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#508ebfff",["id"]="bilinear-weight-54-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1161] = refs[1154]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-54-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1162] = refs[1154]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-54-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1163] = refs[1154]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#4797c3ff",["id"]="bilinear-weight-54-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1164] = refs[1154]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-54-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1165] = refs[1154]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-54-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1166] = refs[1154]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#5097bfff",["id"]="bilinear-weight-54-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1167] = refs[1154]:line {["from"]={-2.8148333382606507,0.5115000049273175},["id"]="bilinear-sample-h-54",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,0.5115000049273175},["width"]=2}
refs[1168] = refs[1154]:line {["from"]={-2.7448333382606505,0.5815000049273175},["id"]="bilinear-sample-v-54",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,0.4415000049273175},["width"]=2}
refs[1169] = refs[1154]:rectangle {["center"]={2.7791666666666663,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-54",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1170] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b92c0ff",["id"]="bilinear-computed-54",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1171] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b92c0ff",["id"]="bilinear-write-54",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1172] = scene:rectangle {["center"]={2.7791666666666663,0.3875},["fill"]="#4b92c0ff",["id"]="bilinear-committed-54",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1173] = scene:group {["id"]="bilinear-read-55",["opacity"]=0}
refs[1174] = refs[1173]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-55-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1175] = refs[1173]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-55-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1176] = refs[1173]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#508ebfff",["id"]="bilinear-weight-55-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1177] = refs[1173]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-55-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1178] = refs[1173]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-55-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1179] = refs[1173]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fad63eff",["id"]="bilinear-weight-55-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1180] = refs[1173]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-55-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1181] = refs[1173]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-55-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1182] = refs[1173]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#5097bfff",["id"]="bilinear-weight-55-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1183] = refs[1173]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-55-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1184] = refs[1173]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-55-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1185] = refs[1173]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#5997bbff",["id"]="bilinear-weight-55-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1186] = refs[1173]:line {["from"]={-2.5565000049273174,0.5115000049273175},["id"]="bilinear-sample-h-55",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,0.5115000049273175},["width"]=2}
refs[1187] = refs[1173]:line {["from"]={-2.4865000049273176,0.5815000049273175},["id"]="bilinear-sample-v-55",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,0.4415000049273175},["width"]=2}
refs[1188] = refs[1173]:rectangle {["center"]={3.0375,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-55",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1189] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5092bdff",["id"]="bilinear-computed-55",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1190] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5092bdff",["id"]="bilinear-write-55",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1191] = scene:rectangle {["center"]={3.0375,0.3875},["fill"]="#5092bdff",["id"]="bilinear-committed-55",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1192] = scene:group {["id"]="bilinear-read-56",["opacity"]=0}
refs[1193] = refs[1192]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-56-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1194] = refs[1192]:rectangle {["center"]={-2.4916666666666667,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-56-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1195] = refs[1192]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#508ebfff",["id"]="bilinear-weight-56-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1196] = refs[1192]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-56-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1197] = refs[1192]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-56-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1198] = refs[1192]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#fad63eff",["id"]="bilinear-weight-56-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1199] = refs[1192]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-56-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1200] = refs[1192]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-56-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1201] = refs[1192]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#5097bfff",["id"]="bilinear-weight-56-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1202] = refs[1192]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-56-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1203] = refs[1192]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-56-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1204] = refs[1192]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#5997bbff",["id"]="bilinear-weight-56-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1205] = refs[1192]:line {["from"]={-2.298166671593984,0.5115000049273175},["id"]="bilinear-sample-h-56",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,0.5115000049273175},["width"]=2}
refs[1206] = refs[1192]:line {["from"]={-2.2281666715939843,0.5815000049273175},["id"]="bilinear-sample-v-56",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,0.4415000049273175},["width"]=2}
refs[1207] = refs[1192]:rectangle {["center"]={3.2958333333333325,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-56",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1208] = scene:rectangle {["center"]={-0.05,0},["fill"]="#7ca49cff",["id"]="bilinear-computed-56",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1209] = scene:rectangle {["center"]={-0.05,0},["fill"]="#7ca49cff",["id"]="bilinear-write-56",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1210] = scene:rectangle {["center"]={3.2958333333333325,0.3875},["fill"]="#7ca49cff",["id"]="bilinear-committed-56",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1211] = scene:group {["id"]="bilinear-read-57",["opacity"]=0}
refs[1212] = refs[1211]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-57-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1213] = refs[1211]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-57-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1214] = refs[1211]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#fad63eff",["id"]="bilinear-weight-57-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1215] = refs[1211]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-57-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1216] = refs[1211]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-57-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1217] = refs[1211]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fada3eff",["id"]="bilinear-weight-57-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1218] = refs[1211]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-57-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1219] = refs[1211]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-57-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1220] = refs[1211]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#5997bbff",["id"]="bilinear-weight-57-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1221] = refs[1211]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-57-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1222] = refs[1211]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-57-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1223] = refs[1211]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-57-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1224] = refs[1211]:line {["from"]={-2.0398332150777185,0.5115000049273175},["id"]="bilinear-sample-h-57",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,0.5115000049273175},["width"]=2}
refs[1225] = refs[1211]:line {["from"]={-1.9698332150777185,0.5815000049273175},["id"]="bilinear-sample-v-57",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,0.4415000049273175},["width"]=2}
refs[1226] = refs[1211]:rectangle {["center"]={3.5541666666666663,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-57",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1227] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a8b67cff",["id"]="bilinear-computed-57",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1228] = scene:rectangle {["center"]={-0.05,0},["fill"]="#a8b67cff",["id"]="bilinear-write-57",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1229] = scene:rectangle {["center"]={3.5541666666666663,0.3875},["fill"]="#a8b67cff",["id"]="bilinear-committed-57",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1230] = scene:group {["id"]="bilinear-read-58",["opacity"]=0}
refs[1231] = refs[1230]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-58-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1232] = refs[1230]:rectangle {["center"]={-1.975,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-58-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1233] = refs[1230]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#fad63eff",["id"]="bilinear-weight-58-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1234] = refs[1230]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-58-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1235] = refs[1230]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-58-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1236] = refs[1230]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#fada3eff",["id"]="bilinear-weight-58-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1237] = refs[1230]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-58-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1238] = refs[1230]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-58-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1239] = refs[1230]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#5997bbff",["id"]="bilinear-weight-58-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1240] = refs[1230]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-58-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1241] = refs[1230]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-58-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1242] = refs[1230]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-58-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1243] = refs[1230]:line {["from"]={-1.7814998817443848,0.5115000049273175},["id"]="bilinear-sample-h-58",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,0.5115000049273175},["width"]=2}
refs[1244] = refs[1230]:line {["from"]={-1.7114998817443847,0.5815000049273175},["id"]="bilinear-sample-v-58",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,0.4415000049273175},["width"]=2}
refs[1245] = refs[1230]:rectangle {["center"]={3.8125,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-58",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1246] = scene:rectangle {["center"]={-0.05,0},["fill"]="#aab67bff",["id"]="bilinear-computed-58",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1247] = scene:rectangle {["center"]={-0.05,0},["fill"]="#aab67bff",["id"]="bilinear-write-58",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1248] = scene:rectangle {["center"]={3.8125,0.3875},["fill"]="#aab67bff",["id"]="bilinear-committed-58",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1249] = scene:group {["id"]="bilinear-read-59",["opacity"]=0}
refs[1250] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-59-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1251] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-59-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1252] = refs[1249]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#fada3eff",["id"]="bilinear-weight-59-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1253] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-59-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1254] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-59-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1255] = refs[1249]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#fada3eff",["id"]="bilinear-weight-59-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1256] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-59-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1257] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-59-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1258] = refs[1249]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-59-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1259] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-59-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1260] = refs[1249]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-59-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1261] = refs[1249]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#6297b7ff",["id"]="bilinear-weight-59-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1262] = refs[1249]:line {["from"]={-1.5231665484110517,0.5115000049273175},["id"]="bilinear-sample-h-59",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,0.5115000049273175},["width"]=2}
refs[1263] = refs[1249]:line {["from"]={-1.4531665484110516,0.5815000049273175},["id"]="bilinear-sample-v-59",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,0.4415000049273175},["width"]=2}
refs[1264] = refs[1249]:rectangle {["center"]={4.070833333333333,0.3875},["fill"]="#00000000",["id"]="bilinear-destination-59",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1265] = scene:rectangle {["center"]={-0.05,0},["fill"]="#acb77bff",["id"]="bilinear-computed-59",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1266] = scene:rectangle {["center"]={-0.05,0},["fill"]="#acb77bff",["id"]="bilinear-write-59",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1267] = scene:rectangle {["center"]={4.070833333333333,0.3875},["fill"]="#acb77bff",["id"]="bilinear-committed-59",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1268] = scene:group {["id"]="bilinear-read-60",["opacity"]=0}
refs[1269] = refs[1268]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-60-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1270] = refs[1268]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-60-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1271] = refs[1268]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#3597cbff",["id"]="bilinear-weight-60-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1272] = refs[1268]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-60-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1273] = refs[1268]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-60-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1274] = refs[1268]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-60-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1275] = refs[1268]:line {["from"]={-4.364833338260651,0.25316667159398437},["id"]="bilinear-sample-h-60",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,0.25316667159398437},["width"]=2}
refs[1276] = refs[1268]:line {["from"]={-4.29483333826065,0.3231666715939843},["id"]="bilinear-sample-v-60",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,0.18316667159398434},["width"]=2}
refs[1277] = refs[1268]:rectangle {["center"]={1.2291666666666663,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-60",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1278] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3597cbff",["id"]="bilinear-computed-60",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1279] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3597cbff",["id"]="bilinear-write-60",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1280] = scene:rectangle {["center"]={1.2291666666666663,0.12916666666666685},["fill"]="#3597cbff",["id"]="bilinear-committed-60",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1281] = scene:group {["id"]="bilinear-read-61",["opacity"]=0}
refs[1282] = refs[1281]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-61-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1283] = refs[1281]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-61-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1284] = refs[1281]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3597cbff",["id"]="bilinear-weight-61-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1285] = refs[1281]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-61-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1286] = refs[1281]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-61-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1287] = refs[1281]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-61-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1288] = refs[1281]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-61-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1289] = refs[1281]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-61-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1290] = refs[1281]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-61-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1291] = refs[1281]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-61-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1292] = refs[1281]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-61-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1293] = refs[1281]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-61-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1294] = refs[1281]:line {["from"]={-4.106500004927318,0.25316667159398437},["id"]="bilinear-sample-h-61",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,0.25316667159398437},["width"]=2}
refs[1295] = refs[1281]:line {["from"]={-4.036500004927317,0.3231666715939843},["id"]="bilinear-sample-v-61",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,0.18316667159398434},["width"]=2}
refs[1296] = refs[1281]:rectangle {["center"]={1.4875,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-61",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1297] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3597caff",["id"]="bilinear-computed-61",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1298] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3597caff",["id"]="bilinear-write-61",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1299] = scene:rectangle {["center"]={1.4875,0.12916666666666685},["fill"]="#3597caff",["id"]="bilinear-committed-61",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1300] = scene:group {["id"]="bilinear-read-62",["opacity"]=0}
refs[1301] = refs[1300]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-62-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1302] = refs[1300]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-62-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1303] = refs[1300]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3597cbff",["id"]="bilinear-weight-62-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1304] = refs[1300]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-62-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1305] = refs[1300]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-62-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1306] = refs[1300]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-62-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1307] = refs[1300]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-62-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1308] = refs[1300]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-62-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1309] = refs[1300]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-62-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1310] = refs[1300]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-62-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1311] = refs[1300]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-62-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1312] = refs[1300]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-62-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1313] = refs[1300]:line {["from"]={-3.8481666715939844,0.25316667159398437},["id"]="bilinear-sample-h-62",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,0.25316667159398437},["width"]=2}
refs[1314] = refs[1300]:line {["from"]={-3.7781666715939846,0.3231666715939843},["id"]="bilinear-sample-v-62",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,0.18316667159398434},["width"]=2}
refs[1315] = refs[1300]:rectangle {["center"]={1.7458333333333338,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-62",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1316] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3997c8ff",["id"]="bilinear-computed-62",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1317] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3997c8ff",["id"]="bilinear-write-62",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1318] = scene:rectangle {["center"]={1.7458333333333338,0.12916666666666685},["fill"]="#3997c8ff",["id"]="bilinear-committed-62",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1319] = scene:group {["id"]="bilinear-read-63",["opacity"]=0}
refs[1320] = refs[1319]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-63-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1321] = refs[1319]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-63-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1322] = refs[1319]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-63-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1323] = refs[1319]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-63-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1324] = refs[1319]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-63-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1325] = refs[1319]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-63-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1326] = refs[1319]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-63-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1327] = refs[1319]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-63-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1328] = refs[1319]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-63-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1329] = refs[1319]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-63-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1330] = refs[1319]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-63-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1331] = refs[1319]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-63-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1332] = refs[1319]:line {["from"]={-3.5898333382606507,0.25316667159398437},["id"]="bilinear-sample-h-63",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,0.25316667159398437},["width"]=2}
refs[1333] = refs[1319]:line {["from"]={-3.519833338260651,0.3231666715939843},["id"]="bilinear-sample-v-63",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,0.18316667159398434},["width"]=2}
refs[1334] = refs[1319]:rectangle {["center"]={2.0041666666666664,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-63",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1335] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e97c6ff",["id"]="bilinear-computed-63",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1336] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e97c6ff",["id"]="bilinear-write-63",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1337] = scene:rectangle {["center"]={2.0041666666666664,0.12916666666666685},["fill"]="#3e97c6ff",["id"]="bilinear-committed-63",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1338] = scene:group {["id"]="bilinear-read-64",["opacity"]=0}
refs[1339] = refs[1338]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-64-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1340] = refs[1338]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-64-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1341] = refs[1338]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-64-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1342] = refs[1338]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-64-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1343] = refs[1338]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-64-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1344] = refs[1338]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-64-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1345] = refs[1338]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-64-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1346] = refs[1338]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-64-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1347] = refs[1338]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-64-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1348] = refs[1338]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-64-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1349] = refs[1338]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-64-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1350] = refs[1338]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-64-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1351] = refs[1338]:line {["from"]={-3.3315000049273173,0.25316667159398437},["id"]="bilinear-sample-h-64",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,0.25316667159398437},["width"]=2}
refs[1352] = refs[1338]:line {["from"]={-3.2615000049273175,0.3231666715939843},["id"]="bilinear-sample-v-64",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,0.18316667159398434},["width"]=2}
refs[1353] = refs[1338]:rectangle {["center"]={2.2625,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-64",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1354] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4297c4ff",["id"]="bilinear-computed-64",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1355] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4297c4ff",["id"]="bilinear-write-64",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1356] = scene:rectangle {["center"]={2.2625,0.12916666666666685},["fill"]="#4297c4ff",["id"]="bilinear-committed-64",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1357] = scene:group {["id"]="bilinear-read-65",["opacity"]=0}
refs[1358] = refs[1357]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-65-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1359] = refs[1357]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-65-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1360] = refs[1357]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-65-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1361] = refs[1357]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-65-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1362] = refs[1357]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-65-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1363] = refs[1357]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#5097bfff",["id"]="bilinear-weight-65-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1364] = refs[1357]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-65-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1365] = refs[1357]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-65-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1366] = refs[1357]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-65-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1367] = refs[1357]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-65-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1368] = refs[1357]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-65-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1369] = refs[1357]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-65-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1370] = refs[1357]:line {["from"]={-3.0731666715939845,0.25316667159398437},["id"]="bilinear-sample-h-65",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,0.25316667159398437},["width"]=2}
refs[1371] = refs[1357]:line {["from"]={-3.003166671593984,0.3231666715939843},["id"]="bilinear-sample-v-65",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,0.18316667159398434},["width"]=2}
refs[1372] = refs[1357]:rectangle {["center"]={2.5208333333333326,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-65",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1373] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4797c2ff",["id"]="bilinear-computed-65",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1374] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4797c2ff",["id"]="bilinear-write-65",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1375] = scene:rectangle {["center"]={2.5208333333333326,0.12916666666666685},["fill"]="#4797c2ff",["id"]="bilinear-committed-65",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1376] = scene:group {["id"]="bilinear-read-66",["opacity"]=0}
refs[1377] = refs[1376]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-66-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1378] = refs[1376]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-66-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1379] = refs[1376]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-66-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1380] = refs[1376]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-66-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1381] = refs[1376]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-66-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1382] = refs[1376]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#5097bfff",["id"]="bilinear-weight-66-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1383] = refs[1376]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-66-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1384] = refs[1376]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-66-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1385] = refs[1376]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-66-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1386] = refs[1376]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-66-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1387] = refs[1376]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-66-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1388] = refs[1376]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-66-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1389] = refs[1376]:line {["from"]={-2.8148333382606507,0.25316667159398437},["id"]="bilinear-sample-h-66",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,0.25316667159398437},["width"]=2}
refs[1390] = refs[1376]:line {["from"]={-2.7448333382606505,0.3231666715939843},["id"]="bilinear-sample-v-66",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,0.18316667159398434},["width"]=2}
refs[1391] = refs[1376]:rectangle {["center"]={2.7791666666666663,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-66",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1392] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b97c0ff",["id"]="bilinear-computed-66",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1393] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b97c0ff",["id"]="bilinear-write-66",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1394] = scene:rectangle {["center"]={2.7791666666666663,0.12916666666666685},["fill"]="#4b97c0ff",["id"]="bilinear-committed-66",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1395] = scene:group {["id"]="bilinear-read-67",["opacity"]=0}
refs[1396] = refs[1395]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-67-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1397] = refs[1395]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-67-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1398] = refs[1395]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#5097bfff",["id"]="bilinear-weight-67-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1399] = refs[1395]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-67-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1400] = refs[1395]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-67-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1401] = refs[1395]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#5997bbff",["id"]="bilinear-weight-67-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1402] = refs[1395]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-67-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1403] = refs[1395]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-67-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1404] = refs[1395]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-67-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1405] = refs[1395]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-67-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1406] = refs[1395]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-67-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1407] = refs[1395]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#399d5cff",["id"]="bilinear-weight-67-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1408] = refs[1395]:line {["from"]={-2.5565000049273174,0.25316667159398437},["id"]="bilinear-sample-h-67",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,0.25316667159398437},["width"]=2}
refs[1409] = refs[1395]:line {["from"]={-2.4865000049273176,0.3231666715939843},["id"]="bilinear-sample-v-67",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,0.18316667159398434},["width"]=2}
refs[1410] = refs[1395]:rectangle {["center"]={3.0375,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-67",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1411] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f97beff",["id"]="bilinear-computed-67",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1412] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f97beff",["id"]="bilinear-write-67",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1413] = scene:rectangle {["center"]={3.0375,0.12916666666666685},["fill"]="#4f97beff",["id"]="bilinear-committed-67",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1414] = scene:group {["id"]="bilinear-read-68",["opacity"]=0}
refs[1415] = refs[1414]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-68-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1416] = refs[1414]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-68-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1417] = refs[1414]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#5097bfff",["id"]="bilinear-weight-68-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1418] = refs[1414]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-68-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1419] = refs[1414]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-68-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1420] = refs[1414]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#5997bbff",["id"]="bilinear-weight-68-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1421] = refs[1414]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-68-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1422] = refs[1414]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-68-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1423] = refs[1414]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-68-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1424] = refs[1414]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-68-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1425] = refs[1414]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-68-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1426] = refs[1414]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#399d5cff",["id"]="bilinear-weight-68-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1427] = refs[1414]:line {["from"]={-2.298166671593984,0.25316667159398437},["id"]="bilinear-sample-h-68",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,0.25316667159398437},["width"]=2}
refs[1428] = refs[1414]:line {["from"]={-2.2281666715939843,0.3231666715939843},["id"]="bilinear-sample-v-68",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,0.18316667159398434},["width"]=2}
refs[1429] = refs[1414]:rectangle {["center"]={3.2958333333333325,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-68",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1430] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5397bbff",["id"]="bilinear-computed-68",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1431] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5397bbff",["id"]="bilinear-write-68",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1432] = scene:rectangle {["center"]={3.2958333333333325,0.12916666666666685},["fill"]="#5397bbff",["id"]="bilinear-committed-68",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1433] = scene:group {["id"]="bilinear-read-69",["opacity"]=0}
refs[1434] = refs[1433]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-69-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1435] = refs[1433]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-69-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1436] = refs[1433]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#5997bbff",["id"]="bilinear-weight-69-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1437] = refs[1433]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-69-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1438] = refs[1433]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-69-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1439] = refs[1433]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-69-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1440] = refs[1433]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-69-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1441] = refs[1433]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-69-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1442] = refs[1433]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#399d5cff",["id"]="bilinear-weight-69-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1443] = refs[1433]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-69-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1444] = refs[1433]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-69-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1445] = refs[1433]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-69-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1446] = refs[1433]:line {["from"]={-2.0398332150777185,0.25316667159398437},["id"]="bilinear-sample-h-69",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,0.25316667159398437},["width"]=2}
refs[1447] = refs[1433]:line {["from"]={-1.9698332150777185,0.3231666715939843},["id"]="bilinear-sample-v-69",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,0.18316667159398434},["width"]=2}
refs[1448] = refs[1433]:rectangle {["center"]={3.5541666666666663,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-69",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1449] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5897b9ff",["id"]="bilinear-computed-69",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1450] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5897b9ff",["id"]="bilinear-write-69",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1451] = scene:rectangle {["center"]={3.5541666666666663,0.12916666666666685},["fill"]="#5897b9ff",["id"]="bilinear-committed-69",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1452] = scene:group {["id"]="bilinear-read-70",["opacity"]=0}
refs[1453] = refs[1452]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-70-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1454] = refs[1452]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-70-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1455] = refs[1452]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#5997bbff",["id"]="bilinear-weight-70-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1456] = refs[1452]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-70-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1457] = refs[1452]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-70-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1458] = refs[1452]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-70-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1459] = refs[1452]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-70-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1460] = refs[1452]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-70-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1461] = refs[1452]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#399d5cff",["id"]="bilinear-weight-70-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1462] = refs[1452]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-70-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1463] = refs[1452]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-70-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1464] = refs[1452]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-70-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1465] = refs[1452]:line {["from"]={-1.7814998817443848,0.25316667159398437},["id"]="bilinear-sample-h-70",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,0.25316667159398437},["width"]=2}
refs[1466] = refs[1452]:line {["from"]={-1.7114998817443847,0.3231666715939843},["id"]="bilinear-sample-v-70",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,0.18316667159398434},["width"]=2}
refs[1467] = refs[1452]:rectangle {["center"]={3.8125,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-70",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1468] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5c97b7ff",["id"]="bilinear-computed-70",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1469] = scene:rectangle {["center"]={-0.05,0},["fill"]="#5c97b7ff",["id"]="bilinear-write-70",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1470] = scene:rectangle {["center"]={3.8125,0.12916666666666685},["fill"]="#5c97b7ff",["id"]="bilinear-committed-70",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1471] = scene:group {["id"]="bilinear-read-71",["opacity"]=0}
refs[1472] = refs[1471]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-71-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1473] = refs[1471]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-71-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1474] = refs[1471]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-71-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1475] = refs[1471]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-71-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1476] = refs[1471]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-71-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1477] = refs[1471]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-71-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1478] = refs[1471]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-71-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1479] = refs[1471]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-71-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1480] = refs[1471]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-71-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1481] = refs[1471]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-71-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1482] = refs[1471]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-71-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1483] = refs[1471]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-71-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1484] = refs[1471]:line {["from"]={-1.5231665484110517,0.25316667159398437},["id"]="bilinear-sample-h-71",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,0.25316667159398437},["width"]=2}
refs[1485] = refs[1471]:line {["from"]={-1.4531665484110516,0.3231666715939843},["id"]="bilinear-sample-v-71",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,0.18316667159398434},["width"]=2}
refs[1486] = refs[1471]:rectangle {["center"]={4.070833333333333,0.12916666666666685},["fill"]="#00000000",["id"]="bilinear-destination-71",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1487] = scene:rectangle {["center"]={-0.05,0},["fill"]="#6197b6ff",["id"]="bilinear-computed-71",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1488] = scene:rectangle {["center"]={-0.05,0},["fill"]="#6197b6ff",["id"]="bilinear-write-71",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1489] = scene:rectangle {["center"]={4.070833333333333,0.12916666666666685},["fill"]="#6197b6ff",["id"]="bilinear-committed-71",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1490] = scene:group {["id"]="bilinear-read-72",["opacity"]=0}
refs[1491] = refs[1490]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-72-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1492] = refs[1490]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-72-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1493] = refs[1490]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#3597cbff",["id"]="bilinear-weight-72-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1494] = refs[1490]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-72-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1495] = refs[1490]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-72-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1496] = refs[1490]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-72-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1497] = refs[1490]:line {["from"]={-4.364833338260651,-0.005166661739349365},["id"]="bilinear-sample-h-72",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-0.005166661739349365},["width"]=2}
refs[1498] = refs[1490]:line {["from"]={-4.29483333826065,0.06483333826065063},["id"]="bilinear-sample-v-72",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-0.07516666173934937},["width"]=2}
refs[1499] = refs[1490]:rectangle {["center"]={1.2291666666666663,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-72",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1500] = scene:rectangle {["center"]={-0.05,0},["fill"]="#359bcbff",["id"]="bilinear-computed-72",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1501] = scene:rectangle {["center"]={-0.05,0},["fill"]="#359bcbff",["id"]="bilinear-write-72",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1502] = scene:rectangle {["center"]={1.2291666666666663,-0.1291666666666663},["fill"]="#359bcbff",["id"]="bilinear-committed-72",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1503] = scene:group {["id"]="bilinear-read-73",["opacity"]=0}
refs[1504] = refs[1503]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-73-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1505] = refs[1503]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-73-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1506] = refs[1503]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3597cbff",["id"]="bilinear-weight-73-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1507] = refs[1503]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-73-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1508] = refs[1503]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-73-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1509] = refs[1503]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-73-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1510] = refs[1503]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-73-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1511] = refs[1503]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-73-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1512] = refs[1503]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-73-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1513] = refs[1503]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-73-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1514] = refs[1503]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-73-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1515] = refs[1503]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-73-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1516] = refs[1503]:line {["from"]={-4.106500004927318,-0.005166661739349365},["id"]="bilinear-sample-h-73",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-0.005166661739349365},["width"]=2}
refs[1517] = refs[1503]:line {["from"]={-4.036500004927317,0.06483333826065063},["id"]="bilinear-sample-v-73",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-0.07516666173934937},["width"]=2}
refs[1518] = refs[1503]:rectangle {["center"]={1.4875,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-73",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1519] = scene:rectangle {["center"]={-0.05,0},["fill"]="#359bcaff",["id"]="bilinear-computed-73",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1520] = scene:rectangle {["center"]={-0.05,0},["fill"]="#359bcaff",["id"]="bilinear-write-73",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1521] = scene:rectangle {["center"]={1.4875,-0.1291666666666663},["fill"]="#359bcaff",["id"]="bilinear-committed-73",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1522] = scene:group {["id"]="bilinear-read-74",["opacity"]=0}
refs[1523] = refs[1522]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-74-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1524] = refs[1522]:rectangle {["center"]={-4.041666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-74-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1525] = refs[1522]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3597cbff",["id"]="bilinear-weight-74-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1526] = refs[1522]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-74-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1527] = refs[1522]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-74-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1528] = refs[1522]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-74-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1529] = refs[1522]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-74-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1530] = refs[1522]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-74-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1531] = refs[1522]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#35a0cbff",["id"]="bilinear-weight-74-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1532] = refs[1522]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-74-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1533] = refs[1522]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-74-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1534] = refs[1522]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-74-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1535] = refs[1522]:line {["from"]={-3.8481666715939844,-0.005166661739349365},["id"]="bilinear-sample-h-74",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-0.005166661739349365},["width"]=2}
refs[1536] = refs[1522]:line {["from"]={-3.7781666715939846,0.06483333826065063},["id"]="bilinear-sample-v-74",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-0.07516666173934937},["width"]=2}
refs[1537] = refs[1522]:rectangle {["center"]={1.7458333333333338,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-74",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1538] = scene:rectangle {["center"]={-0.05,0},["fill"]="#399bc8ff",["id"]="bilinear-computed-74",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1539] = scene:rectangle {["center"]={-0.05,0},["fill"]="#399bc8ff",["id"]="bilinear-write-74",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1540] = scene:rectangle {["center"]={1.7458333333333338,-0.1291666666666663},["fill"]="#399bc8ff",["id"]="bilinear-committed-74",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1541] = scene:group {["id"]="bilinear-read-75",["opacity"]=0}
refs[1542] = refs[1541]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-75-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1543] = refs[1541]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-75-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1544] = refs[1541]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-75-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1545] = refs[1541]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-75-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1546] = refs[1541]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-75-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1547] = refs[1541]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-75-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1548] = refs[1541]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-75-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1549] = refs[1541]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-75-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1550] = refs[1541]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-75-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1551] = refs[1541]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-75-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1552] = refs[1541]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-75-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1553] = refs[1541]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-75-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1554] = refs[1541]:line {["from"]={-3.5898333382606507,-0.005166661739349365},["id"]="bilinear-sample-h-75",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-0.005166661739349365},["width"]=2}
refs[1555] = refs[1541]:line {["from"]={-3.519833338260651,0.06483333826065063},["id"]="bilinear-sample-v-75",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-0.07516666173934937},["width"]=2}
refs[1556] = refs[1541]:rectangle {["center"]={2.0041666666666664,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-75",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1557] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e9bc6ff",["id"]="bilinear-computed-75",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1558] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e9bc6ff",["id"]="bilinear-write-75",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1559] = scene:rectangle {["center"]={2.0041666666666664,-0.1291666666666663},["fill"]="#3e9bc6ff",["id"]="bilinear-committed-75",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1560] = scene:group {["id"]="bilinear-read-76",["opacity"]=0}
refs[1561] = refs[1560]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-76-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1562] = refs[1560]:rectangle {["center"]={-3.525,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-76-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1563] = refs[1560]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3e97c7ff",["id"]="bilinear-weight-76-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1564] = refs[1560]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-76-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1565] = refs[1560]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-76-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1566] = refs[1560]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-76-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1567] = refs[1560]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-76-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1568] = refs[1560]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-76-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1569] = refs[1560]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-76-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1570] = refs[1560]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-76-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1571] = refs[1560]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-76-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1572] = refs[1560]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-76-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1573] = refs[1560]:line {["from"]={-3.3315000049273173,-0.005166661739349365},["id"]="bilinear-sample-h-76",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-0.005166661739349365},["width"]=2}
refs[1574] = refs[1560]:line {["from"]={-3.2615000049273175,0.06483333826065063},["id"]="bilinear-sample-v-76",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-0.07516666173934937},["width"]=2}
refs[1575] = refs[1560]:rectangle {["center"]={2.2625,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-76",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1576] = scene:rectangle {["center"]={-0.05,0},["fill"]="#429bc4ff",["id"]="bilinear-computed-76",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1577] = scene:rectangle {["center"]={-0.05,0},["fill"]="#429bc4ff",["id"]="bilinear-write-76",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1578] = scene:rectangle {["center"]={2.2625,-0.1291666666666663},["fill"]="#429bc4ff",["id"]="bilinear-committed-76",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1579] = scene:group {["id"]="bilinear-read-77",["opacity"]=0}
refs[1580] = refs[1579]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-77-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1581] = refs[1579]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-77-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1582] = refs[1579]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-77-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1583] = refs[1579]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-77-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1584] = refs[1579]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-77-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1585] = refs[1579]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#5097bfff",["id"]="bilinear-weight-77-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1586] = refs[1579]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-77-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1587] = refs[1579]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-77-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1588] = refs[1579]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-77-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1589] = refs[1579]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-77-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1590] = refs[1579]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-77-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1591] = refs[1579]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-77-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1592] = refs[1579]:line {["from"]={-3.0731666715939845,-0.005166661739349365},["id"]="bilinear-sample-h-77",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-0.005166661739349365},["width"]=2}
refs[1593] = refs[1579]:line {["from"]={-3.003166671593984,0.06483333826065063},["id"]="bilinear-sample-v-77",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-0.07516666173934937},["width"]=2}
refs[1594] = refs[1579]:rectangle {["center"]={2.5208333333333326,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-77",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1595] = scene:rectangle {["center"]={-0.05,0},["fill"]="#479bc2ff",["id"]="bilinear-computed-77",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1596] = scene:rectangle {["center"]={-0.05,0},["fill"]="#479bc2ff",["id"]="bilinear-write-77",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1597] = scene:rectangle {["center"]={2.5208333333333326,-0.1291666666666663},["fill"]="#479bc2ff",["id"]="bilinear-committed-77",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1598] = scene:group {["id"]="bilinear-read-78",["opacity"]=0}
refs[1599] = refs[1598]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-78-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1600] = refs[1598]:rectangle {["center"]={-3.0083333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-78-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1601] = refs[1598]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#4797c3ff",["id"]="bilinear-weight-78-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1602] = refs[1598]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-78-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1603] = refs[1598]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-78-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1604] = refs[1598]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#5097bfff",["id"]="bilinear-weight-78-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1605] = refs[1598]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-78-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1606] = refs[1598]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-78-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1607] = refs[1598]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#47a0c3ff",["id"]="bilinear-weight-78-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1608] = refs[1598]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-78-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1609] = refs[1598]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-78-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1610] = refs[1598]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-78-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1611] = refs[1598]:line {["from"]={-2.8148333382606507,-0.005166661739349365},["id"]="bilinear-sample-h-78",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-0.005166661739349365},["width"]=2}
refs[1612] = refs[1598]:line {["from"]={-2.7448333382606505,0.06483333826065063},["id"]="bilinear-sample-v-78",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-0.07516666173934937},["width"]=2}
refs[1613] = refs[1598]:rectangle {["center"]={2.7791666666666663,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-78",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1614] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9bc0ff",["id"]="bilinear-computed-78",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1615] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9bc0ff",["id"]="bilinear-write-78",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1616] = scene:rectangle {["center"]={2.7791666666666663,-0.1291666666666663},["fill"]="#4b9bc0ff",["id"]="bilinear-committed-78",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1617] = scene:group {["id"]="bilinear-read-79",["opacity"]=0}
refs[1618] = refs[1617]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-79-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1619] = refs[1617]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-79-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1620] = refs[1617]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#5097bfff",["id"]="bilinear-weight-79-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1621] = refs[1617]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-79-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1622] = refs[1617]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-79-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1623] = refs[1617]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#5997bbff",["id"]="bilinear-weight-79-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1624] = refs[1617]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-79-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1625] = refs[1617]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-79-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1626] = refs[1617]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-79-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1627] = refs[1617]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-79-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1628] = refs[1617]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-79-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1629] = refs[1617]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#399d5cff",["id"]="bilinear-weight-79-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1630] = refs[1617]:line {["from"]={-2.5565000049273174,-0.005166661739349365},["id"]="bilinear-sample-h-79",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-0.005166661739349365},["width"]=2}
refs[1631] = refs[1617]:line {["from"]={-2.4865000049273176,0.06483333826065063},["id"]="bilinear-sample-v-79",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-0.07516666173934937},["width"]=2}
refs[1632] = refs[1617]:rectangle {["center"]={3.0375,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-79",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1633] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f9bbeff",["id"]="bilinear-computed-79",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1634] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f9bbeff",["id"]="bilinear-write-79",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1635] = scene:rectangle {["center"]={3.0375,-0.1291666666666663},["fill"]="#4f9bbeff",["id"]="bilinear-committed-79",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1636] = scene:group {["id"]="bilinear-read-80",["opacity"]=0}
refs[1637] = refs[1636]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-80-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1638] = refs[1636]:rectangle {["center"]={-2.4916666666666667,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-80-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1639] = refs[1636]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#5097bfff",["id"]="bilinear-weight-80-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1640] = refs[1636]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-80-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1641] = refs[1636]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-80-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1642] = refs[1636]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#5997bbff",["id"]="bilinear-weight-80-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1643] = refs[1636]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-80-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1644] = refs[1636]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-80-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1645] = refs[1636]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#50a0bfff",["id"]="bilinear-weight-80-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1646] = refs[1636]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-80-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1647] = refs[1636]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-80-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1648] = refs[1636]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#399d5cff",["id"]="bilinear-weight-80-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1649] = refs[1636]:line {["from"]={-2.298166671593984,-0.005166661739349365},["id"]="bilinear-sample-h-80",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-0.005166661739349365},["width"]=2}
refs[1650] = refs[1636]:line {["from"]={-2.2281666715939843,0.06483333826065063},["id"]="bilinear-sample-v-80",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-0.07516666173934937},["width"]=2}
refs[1651] = refs[1636]:rectangle {["center"]={3.2958333333333325,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-80",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1652] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9aa3ff",["id"]="bilinear-computed-80",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1653] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9aa3ff",["id"]="bilinear-write-80",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1654] = scene:rectangle {["center"]={3.2958333333333325,-0.1291666666666663},["fill"]="#4b9aa3ff",["id"]="bilinear-committed-80",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1655] = scene:group {["id"]="bilinear-read-81",["opacity"]=0}
refs[1656] = refs[1655]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-81-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1657] = refs[1655]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-81-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1658] = refs[1655]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#5997bbff",["id"]="bilinear-weight-81-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1659] = refs[1655]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-81-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1660] = refs[1655]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-81-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1661] = refs[1655]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-81-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1662] = refs[1655]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-81-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1663] = refs[1655]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-81-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1664] = refs[1655]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#399d5cff",["id"]="bilinear-weight-81-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1665] = refs[1655]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-81-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1666] = refs[1655]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-81-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1667] = refs[1655]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-81-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1668] = refs[1655]:line {["from"]={-2.0398332150777185,-0.005166661739349365},["id"]="bilinear-sample-h-81",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-0.005166661739349365},["width"]=2}
refs[1669] = refs[1655]:line {["from"]={-1.9698332150777185,0.06483333826065063},["id"]="bilinear-sample-v-81",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-0.07516666173934937},["width"]=2}
refs[1670] = refs[1655]:rectangle {["center"]={3.5541666666666663,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-81",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1671] = scene:rectangle {["center"]={-0.05,0},["fill"]="#489a8aff",["id"]="bilinear-computed-81",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1672] = scene:rectangle {["center"]={-0.05,0},["fill"]="#489a8aff",["id"]="bilinear-write-81",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1673] = scene:rectangle {["center"]={3.5541666666666663,-0.1291666666666663},["fill"]="#489a8aff",["id"]="bilinear-committed-81",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1674] = scene:group {["id"]="bilinear-read-82",["opacity"]=0}
refs[1675] = refs[1674]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-82-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1676] = refs[1674]:rectangle {["center"]={-1.975,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-82-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1677] = refs[1674]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#5997bbff",["id"]="bilinear-weight-82-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1678] = refs[1674]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-82-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1679] = refs[1674]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-82-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1680] = refs[1674]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-82-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1681] = refs[1674]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-82-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1682] = refs[1674]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-82-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1683] = refs[1674]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#399d5cff",["id"]="bilinear-weight-82-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1684] = refs[1674]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-82-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1685] = refs[1674]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-82-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1686] = refs[1674]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-82-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1687] = refs[1674]:line {["from"]={-1.7814998817443848,-0.005166661739349365},["id"]="bilinear-sample-h-82",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-0.005166661739349365},["width"]=2}
refs[1688] = refs[1674]:line {["from"]={-1.7114998817443847,0.06483333826065063},["id"]="bilinear-sample-v-82",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-0.07516666173934937},["width"]=2}
refs[1689] = refs[1674]:rectangle {["center"]={3.8125,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-82",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1690] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9a89ff",["id"]="bilinear-computed-82",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1691] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4b9a89ff",["id"]="bilinear-write-82",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1692] = scene:rectangle {["center"]={3.8125,-0.1291666666666663},["fill"]="#4b9a89ff",["id"]="bilinear-committed-82",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1693] = scene:group {["id"]="bilinear-read-83",["opacity"]=0}
refs[1694] = refs[1693]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-83-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1695] = refs[1693]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-83-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1696] = refs[1693]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-83-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1697] = refs[1693]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-83-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1698] = refs[1693]:rectangle {["center"]={-1.4583333333333337,0.2583333333333337},["fill"]="#00000000",["id"]="bilinear-tap-ink-83-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1699] = refs[1693]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#6297b7ff",["id"]="bilinear-weight-83-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1700] = refs[1693]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-83-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1701] = refs[1693]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-83-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1702] = refs[1693]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-83-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1703] = refs[1693]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-83-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1704] = refs[1693]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-83-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1705] = refs[1693]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3e9d5fff",["id"]="bilinear-weight-83-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1706] = refs[1693]:line {["from"]={-1.5231665484110517,-0.005166661739349365},["id"]="bilinear-sample-h-83",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-0.005166661739349365},["width"]=2}
refs[1707] = refs[1693]:line {["from"]={-1.4531665484110516,0.06483333826065063},["id"]="bilinear-sample-v-83",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-0.07516666173934937},["width"]=2}
refs[1708] = refs[1693]:rectangle {["center"]={4.070833333333333,-0.1291666666666663},["fill"]="#00000000",["id"]="bilinear-destination-83",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1709] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f9a8aff",["id"]="bilinear-computed-83",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1710] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4f9a8aff",["id"]="bilinear-write-83",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1711] = scene:rectangle {["center"]={4.070833333333333,-0.1291666666666663},["fill"]="#4f9a8aff",["id"]="bilinear-committed-83",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1712] = scene:group {["id"]="bilinear-read-84",["opacity"]=0}
refs[1713] = refs[1712]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-84-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1714] = refs[1712]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-84-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1715] = refs[1712]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-84-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1716] = refs[1712]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-84-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1717] = refs[1712]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-84-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1718] = refs[1712]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-84-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1719] = refs[1712]:line {["from"]={-4.364833338260651,-0.2634999950726825},["id"]="bilinear-sample-h-84",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-0.2634999950726825},["width"]=2}
refs[1720] = refs[1712]:line {["from"]={-4.29483333826065,-0.1934999950726825},["id"]="bilinear-sample-v-84",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-0.3334999950726825},["width"]=2}
refs[1721] = refs[1712]:rectangle {["center"]={1.2291666666666663,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-84",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1722] = scene:rectangle {["center"]={-0.05,0},["fill"]="#349fcaff",["id"]="bilinear-computed-84",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1723] = scene:rectangle {["center"]={-0.05,0},["fill"]="#349fcaff",["id"]="bilinear-write-84",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1724] = scene:rectangle {["center"]={1.2291666666666663,-0.3875},["fill"]="#349fcaff",["id"]="bilinear-committed-84",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1725] = scene:group {["id"]="bilinear-read-85",["opacity"]=0}
refs[1726] = refs[1725]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-85-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1727] = refs[1725]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-85-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1728] = refs[1725]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-85-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1729] = refs[1725]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-85-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1730] = refs[1725]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-85-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1731] = refs[1725]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-85-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1732] = refs[1725]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-85-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1733] = refs[1725]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-85-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1734] = refs[1725]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-85-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1735] = refs[1725]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-85-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1736] = refs[1725]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-85-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1737] = refs[1725]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#2991beff",["id"]="bilinear-weight-85-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1738] = refs[1725]:line {["from"]={-4.106500004927318,-0.2634999950726825},["id"]="bilinear-sample-h-85",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-0.2634999950726825},["width"]=2}
refs[1739] = refs[1725]:line {["from"]={-4.036500004927317,-0.1934999950726825},["id"]="bilinear-sample-v-85",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-0.3334999950726825},["width"]=2}
refs[1740] = refs[1725]:rectangle {["center"]={1.4875,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-85",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1741] = scene:rectangle {["center"]={-0.05,0},["fill"]="#349fc9ff",["id"]="bilinear-computed-85",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1742] = scene:rectangle {["center"]={-0.05,0},["fill"]="#349fc9ff",["id"]="bilinear-write-85",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1743] = scene:rectangle {["center"]={1.4875,-0.3875},["fill"]="#349fc9ff",["id"]="bilinear-committed-85",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1744] = scene:group {["id"]="bilinear-read-86",["opacity"]=0}
refs[1745] = refs[1744]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-86-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1746] = refs[1744]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-86-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1747] = refs[1744]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-86-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1748] = refs[1744]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-86-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1749] = refs[1744]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-86-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1750] = refs[1744]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-86-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1751] = refs[1744]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-86-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1752] = refs[1744]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-86-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1753] = refs[1744]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-86-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1754] = refs[1744]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-86-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1755] = refs[1744]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-86-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1756] = refs[1744]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#2991beff",["id"]="bilinear-weight-86-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1757] = refs[1744]:line {["from"]={-3.8481666715939844,-0.2634999950726825},["id"]="bilinear-sample-h-86",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-0.2634999950726825},["width"]=2}
refs[1758] = refs[1744]:line {["from"]={-3.7781666715939846,-0.1934999950726825},["id"]="bilinear-sample-v-86",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-0.3334999950726825},["width"]=2}
refs[1759] = refs[1744]:rectangle {["center"]={1.7458333333333338,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-86",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1760] = scene:rectangle {["center"]={-0.05,0},["fill"]="#389fc7ff",["id"]="bilinear-computed-86",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1761] = scene:rectangle {["center"]={-0.05,0},["fill"]="#389fc7ff",["id"]="bilinear-write-86",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1762] = scene:rectangle {["center"]={1.7458333333333338,-0.3875},["fill"]="#389fc7ff",["id"]="bilinear-committed-86",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1763] = scene:group {["id"]="bilinear-read-87",["opacity"]=0}
refs[1764] = refs[1763]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-87-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1765] = refs[1763]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-87-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1766] = refs[1763]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-87-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1767] = refs[1763]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-87-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1768] = refs[1763]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-87-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1769] = refs[1763]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-87-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1770] = refs[1763]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-87-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1771] = refs[1763]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-87-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1772] = refs[1763]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#2991beff",["id"]="bilinear-weight-87-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1773] = refs[1763]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-87-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1774] = refs[1763]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-87-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1775] = refs[1763]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-87-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1776] = refs[1763]:line {["from"]={-3.5898333382606507,-0.2634999950726825},["id"]="bilinear-sample-h-87",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-0.2634999950726825},["width"]=2}
refs[1777] = refs[1763]:line {["from"]={-3.519833338260651,-0.1934999950726825},["id"]="bilinear-sample-v-87",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-0.3334999950726825},["width"]=2}
refs[1778] = refs[1763]:rectangle {["center"]={2.0041666666666664,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-87",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1779] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3d9fc5ff",["id"]="bilinear-computed-87",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1780] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3d9fc5ff",["id"]="bilinear-write-87",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1781] = scene:rectangle {["center"]={2.0041666666666664,-0.3875},["fill"]="#3d9fc5ff",["id"]="bilinear-committed-87",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1782] = scene:group {["id"]="bilinear-read-88",["opacity"]=0}
refs[1783] = refs[1782]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-88-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1784] = refs[1782]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-88-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1785] = refs[1782]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-88-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1786] = refs[1782]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-88-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1787] = refs[1782]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-88-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1788] = refs[1782]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-88-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1789] = refs[1782]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-88-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1790] = refs[1782]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-88-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1791] = refs[1782]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#2991beff",["id"]="bilinear-weight-88-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1792] = refs[1782]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-88-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1793] = refs[1782]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-88-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1794] = refs[1782]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-88-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1795] = refs[1782]:line {["from"]={-3.3315000049273173,-0.2634999950726825},["id"]="bilinear-sample-h-88",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-0.2634999950726825},["width"]=2}
refs[1796] = refs[1782]:line {["from"]={-3.2615000049273175,-0.1934999950726825},["id"]="bilinear-sample-v-88",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-0.3334999950726825},["width"]=2}
refs[1797] = refs[1782]:rectangle {["center"]={2.2625,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-88",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1798] = scene:rectangle {["center"]={-0.05,0},["fill"]="#419fc3ff",["id"]="bilinear-computed-88",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1799] = scene:rectangle {["center"]={-0.05,0},["fill"]="#419fc3ff",["id"]="bilinear-write-88",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1800] = scene:rectangle {["center"]={2.2625,-0.3875},["fill"]="#419fc3ff",["id"]="bilinear-committed-88",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1801] = scene:group {["id"]="bilinear-read-89",["opacity"]=0}
refs[1802] = refs[1801]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-89-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1803] = refs[1801]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-89-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1804] = refs[1801]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-89-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1805] = refs[1801]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-89-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1806] = refs[1801]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-89-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1807] = refs[1801]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-89-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1808] = refs[1801]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-89-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1809] = refs[1801]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-89-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1810] = refs[1801]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-89-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1811] = refs[1801]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-89-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1812] = refs[1801]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-89-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1813] = refs[1801]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#34a559ff",["id"]="bilinear-weight-89-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1814] = refs[1801]:line {["from"]={-3.0731666715939845,-0.2634999950726825},["id"]="bilinear-sample-h-89",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-0.2634999950726825},["width"]=2}
refs[1815] = refs[1801]:line {["from"]={-3.003166671593984,-0.1934999950726825},["id"]="bilinear-sample-v-89",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-0.3334999950726825},["width"]=2}
refs[1816] = refs[1801]:rectangle {["center"]={2.5208333333333326,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-89",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1817] = scene:rectangle {["center"]={-0.05,0},["fill"]="#46a0c1ff",["id"]="bilinear-computed-89",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1818] = scene:rectangle {["center"]={-0.05,0},["fill"]="#46a0c1ff",["id"]="bilinear-write-89",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1819] = scene:rectangle {["center"]={2.5208333333333326,-0.3875},["fill"]="#46a0c1ff",["id"]="bilinear-committed-89",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1820] = scene:group {["id"]="bilinear-read-90",["opacity"]=0}
refs[1821] = refs[1820]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-90-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1822] = refs[1820]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-90-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1823] = refs[1820]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-90-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1824] = refs[1820]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-90-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1825] = refs[1820]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-90-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1826] = refs[1820]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-90-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1827] = refs[1820]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-90-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1828] = refs[1820]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-90-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1829] = refs[1820]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-90-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1830] = refs[1820]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-90-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1831] = refs[1820]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-90-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1832] = refs[1820]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#34a559ff",["id"]="bilinear-weight-90-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1833] = refs[1820]:line {["from"]={-2.8148333382606507,-0.2634999950726825},["id"]="bilinear-sample-h-90",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-0.2634999950726825},["width"]=2}
refs[1834] = refs[1820]:line {["from"]={-2.7448333382606505,-0.1934999950726825},["id"]="bilinear-sample-v-90",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-0.3334999950726825},["width"]=2}
refs[1835] = refs[1820]:rectangle {["center"]={2.7791666666666663,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-90",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1836] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4aa0bfff",["id"]="bilinear-computed-90",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1837] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4aa0bfff",["id"]="bilinear-write-90",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1838] = scene:rectangle {["center"]={2.7791666666666663,-0.3875},["fill"]="#4aa0bfff",["id"]="bilinear-committed-90",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1839] = scene:group {["id"]="bilinear-read-91",["opacity"]=0}
refs[1840] = refs[1839]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-91-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1841] = refs[1839]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-91-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1842] = refs[1839]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-91-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1843] = refs[1839]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-91-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1844] = refs[1839]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-91-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1845] = refs[1839]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#399d5cff",["id"]="bilinear-weight-91-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1846] = refs[1839]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-91-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1847] = refs[1839]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-91-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1848] = refs[1839]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#34a559ff",["id"]="bilinear-weight-91-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1849] = refs[1839]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-91-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1850] = refs[1839]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-91-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1851] = refs[1839]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#39a55cff",["id"]="bilinear-weight-91-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1852] = refs[1839]:line {["from"]={-2.5565000049273174,-0.2634999950726825},["id"]="bilinear-sample-h-91",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-0.2634999950726825},["width"]=2}
refs[1853] = refs[1839]:line {["from"]={-2.4865000049273176,-0.1934999950726825},["id"]="bilinear-sample-v-91",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-0.3334999950726825},["width"]=2}
refs[1854] = refs[1839]:rectangle {["center"]={3.0375,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-91",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1855] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4e9fbdff",["id"]="bilinear-computed-91",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1856] = scene:rectangle {["center"]={-0.05,0},["fill"]="#4e9fbdff",["id"]="bilinear-write-91",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1857] = scene:rectangle {["center"]={3.0375,-0.3875},["fill"]="#4e9fbdff",["id"]="bilinear-committed-91",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1858] = scene:group {["id"]="bilinear-read-92",["opacity"]=0}
refs[1859] = refs[1858]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-92-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1860] = refs[1858]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-92-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1861] = refs[1858]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-92-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1862] = refs[1858]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-92-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1863] = refs[1858]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-92-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1864] = refs[1858]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#399d5cff",["id"]="bilinear-weight-92-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1865] = refs[1858]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-92-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1866] = refs[1858]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-92-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1867] = refs[1858]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#34a559ff",["id"]="bilinear-weight-92-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1868] = refs[1858]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-92-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1869] = refs[1858]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-92-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1870] = refs[1858]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#39a55cff",["id"]="bilinear-weight-92-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1871] = refs[1858]:line {["from"]={-2.298166671593984,-0.2634999950726825},["id"]="bilinear-sample-h-92",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-0.2634999950726825},["width"]=2}
refs[1872] = refs[1858]:line {["from"]={-2.2281666715939843,-0.1934999950726825},["id"]="bilinear-sample-v-92",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-0.3334999950726825},["width"]=2}
refs[1873] = refs[1858]:rectangle {["center"]={3.2958333333333325,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-92",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1874] = scene:rectangle {["center"]={-0.05,0},["fill"]="#439e8bff",["id"]="bilinear-computed-92",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1875] = scene:rectangle {["center"]={-0.05,0},["fill"]="#439e8bff",["id"]="bilinear-write-92",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1876] = scene:rectangle {["center"]={3.2958333333333325,-0.3875},["fill"]="#439e8bff",["id"]="bilinear-committed-92",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1877] = scene:group {["id"]="bilinear-read-93",["opacity"]=0}
refs[1878] = refs[1877]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-93-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1879] = refs[1877]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-93-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1880] = refs[1877]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#399d5cff",["id"]="bilinear-weight-93-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1881] = refs[1877]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-93-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1882] = refs[1877]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-93-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1883] = refs[1877]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-93-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1884] = refs[1877]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-93-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1885] = refs[1877]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-93-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1886] = refs[1877]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#39a55cff",["id"]="bilinear-weight-93-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1887] = refs[1877]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-93-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1888] = refs[1877]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-93-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1889] = refs[1877]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-93-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1890] = refs[1877]:line {["from"]={-2.0398332150777185,-0.2634999950726825},["id"]="bilinear-sample-h-93",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-0.2634999950726825},["width"]=2}
refs[1891] = refs[1877]:line {["from"]={-1.9698332150777185,-0.1934999950726825},["id"]="bilinear-sample-v-93",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-0.3334999950726825},["width"]=2}
refs[1892] = refs[1877]:rectangle {["center"]={3.5541666666666663,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-93",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1893] = scene:rectangle {["center"]={-0.05,0},["fill"]="#399d5cff",["id"]="bilinear-computed-93",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1894] = scene:rectangle {["center"]={-0.05,0},["fill"]="#399d5cff",["id"]="bilinear-write-93",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1895] = scene:rectangle {["center"]={3.5541666666666663,-0.3875},["fill"]="#399d5cff",["id"]="bilinear-committed-93",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1896] = scene:group {["id"]="bilinear-read-94",["opacity"]=0}
refs[1897] = refs[1896]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-94-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1898] = refs[1896]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-94-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1899] = refs[1896]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#399d5cff",["id"]="bilinear-weight-94-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1900] = refs[1896]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-94-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1901] = refs[1896]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-94-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1902] = refs[1896]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-94-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1903] = refs[1896]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-94-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1904] = refs[1896]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-94-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1905] = refs[1896]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#39a55cff",["id"]="bilinear-weight-94-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1906] = refs[1896]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-94-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1907] = refs[1896]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-94-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1908] = refs[1896]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-94-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1909] = refs[1896]:line {["from"]={-1.7814998817443848,-0.2634999950726825},["id"]="bilinear-sample-h-94",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-0.2634999950726825},["width"]=2}
refs[1910] = refs[1896]:line {["from"]={-1.7114998817443847,-0.1934999950726825},["id"]="bilinear-sample-v-94",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-0.3334999950726825},["width"]=2}
refs[1911] = refs[1896]:rectangle {["center"]={3.8125,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-94",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1912] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3b9d5dff",["id"]="bilinear-computed-94",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1913] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3b9d5dff",["id"]="bilinear-write-94",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1914] = scene:rectangle {["center"]={3.8125,-0.3875},["fill"]="#3b9d5dff",["id"]="bilinear-committed-94",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1915] = scene:group {["id"]="bilinear-read-95",["opacity"]=0}
refs[1916] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-95-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1917] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-95-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1918] = refs[1915]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-95-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1919] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-95-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1920] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-95-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1921] = refs[1915]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-95-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[1922] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-95-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1923] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-95-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1924] = refs[1915]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-95-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1925] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-95-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1926] = refs[1915]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-95-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1927] = refs[1915]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-95-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[1928] = refs[1915]:line {["from"]={-1.5231665484110517,-0.2634999950726825},["id"]="bilinear-sample-h-95",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-0.2634999950726825},["width"]=2}
refs[1929] = refs[1915]:line {["from"]={-1.4531665484110516,-0.1934999950726825},["id"]="bilinear-sample-v-95",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-0.3334999950726825},["width"]=2}
refs[1930] = refs[1915]:rectangle {["center"]={4.070833333333333,-0.3875},["fill"]="#00000000",["id"]="bilinear-destination-95",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1931] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e9d5fff",["id"]="bilinear-computed-95",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1932] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3e9d5fff",["id"]="bilinear-write-95",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1933] = scene:rectangle {["center"]={4.070833333333333,-0.3875},["fill"]="#3e9d5fff",["id"]="bilinear-committed-95",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1934] = scene:group {["id"]="bilinear-read-96",["opacity"]=0}
refs[1935] = refs[1934]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-96-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1936] = refs[1934]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-96-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1937] = refs[1934]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-96-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1938] = refs[1934]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-96-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1939] = refs[1934]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-96-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1940] = refs[1934]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-96-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1941] = refs[1934]:line {["from"]={-4.364833338260651,-0.5218333284060157},["id"]="bilinear-sample-h-96",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-0.5218333284060157},["width"]=2}
refs[1942] = refs[1934]:line {["from"]={-4.29483333826065,-0.45183332840601564},["id"]="bilinear-sample-v-96",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-0.5918333284060157},["width"]=2}
refs[1943] = refs[1934]:rectangle {["center"]={1.2291666666666663,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-96",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1944] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2a98bfff",["id"]="bilinear-computed-96",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1945] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2a98bfff",["id"]="bilinear-write-96",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1946] = scene:rectangle {["center"]={1.2291666666666663,-0.6458333333333331},["fill"]="#2a98bfff",["id"]="bilinear-committed-96",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1947] = scene:group {["id"]="bilinear-read-97",["opacity"]=0}
refs[1948] = refs[1947]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-97-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1949] = refs[1947]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-97-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1950] = refs[1947]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-97-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1951] = refs[1947]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-97-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1952] = refs[1947]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-97-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1953] = refs[1947]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-97-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1954] = refs[1947]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-97-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1955] = refs[1947]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-97-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1956] = refs[1947]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-97-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1957] = refs[1947]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-97-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1958] = refs[1947]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-97-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1959] = refs[1947]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#2991beff",["id"]="bilinear-weight-97-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1960] = refs[1947]:line {["from"]={-4.106500004927318,-0.5218333284060157},["id"]="bilinear-sample-h-97",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-0.5218333284060157},["width"]=2}
refs[1961] = refs[1947]:line {["from"]={-4.036500004927317,-0.45183332840601564},["id"]="bilinear-sample-v-97",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-0.5918333284060157},["width"]=2}
refs[1962] = refs[1947]:rectangle {["center"]={1.4875,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-97",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1963] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2a98bfff",["id"]="bilinear-computed-97",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1964] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2a98bfff",["id"]="bilinear-write-97",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1965] = scene:rectangle {["center"]={1.4875,-0.6458333333333331},["fill"]="#2a98bfff",["id"]="bilinear-committed-97",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1966] = scene:group {["id"]="bilinear-read-98",["opacity"]=0}
refs[1967] = refs[1966]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-98-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1968] = refs[1966]:rectangle {["center"]={-4.041666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-98-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1969] = refs[1966]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#35a0cbff",["id"]="bilinear-weight-98-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1970] = refs[1966]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-98-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1971] = refs[1966]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-98-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1972] = refs[1966]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-98-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1973] = refs[1966]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-98-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1974] = refs[1966]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-98-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1975] = refs[1966]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#2191b5ff",["id"]="bilinear-weight-98-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1976] = refs[1966]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-98-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1977] = refs[1966]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-98-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1978] = refs[1966]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#2991beff",["id"]="bilinear-weight-98-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1979] = refs[1966]:line {["from"]={-3.8481666715939844,-0.5218333284060157},["id"]="bilinear-sample-h-98",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-0.5218333284060157},["width"]=2}
refs[1980] = refs[1966]:line {["from"]={-3.7781666715939846,-0.45183332840601564},["id"]="bilinear-sample-v-98",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-0.5918333284060157},["width"]=2}
refs[1981] = refs[1966]:rectangle {["center"]={1.7458333333333338,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-98",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[1982] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2e98c0ff",["id"]="bilinear-computed-98",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[1983] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2e98c0ff",["id"]="bilinear-write-98",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[1984] = scene:rectangle {["center"]={1.7458333333333338,-0.6458333333333331},["fill"]="#2e98c0ff",["id"]="bilinear-committed-98",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[1985] = scene:group {["id"]="bilinear-read-99",["opacity"]=0}
refs[1986] = refs[1985]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-99-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1987] = refs[1985]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-99-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1988] = refs[1985]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-99-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1989] = refs[1985]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-99-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1990] = refs[1985]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-99-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1991] = refs[1985]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-99-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[1992] = refs[1985]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-99-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1993] = refs[1985]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-99-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1994] = refs[1985]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#2991beff",["id"]="bilinear-weight-99-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1995] = refs[1985]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-99-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[1996] = refs[1985]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-99-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[1997] = refs[1985]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-99-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[1998] = refs[1985]:line {["from"]={-3.5898333382606507,-0.5218333284060157},["id"]="bilinear-sample-h-99",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-0.5218333284060157},["width"]=2}
refs[1999] = refs[1985]:line {["from"]={-3.519833338260651,-0.45183332840601564},["id"]="bilinear-sample-v-99",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-0.5918333284060157},["width"]=2}
refs[2000] = refs[1985]:rectangle {["center"]={2.0041666666666664,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-99",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2001] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3398c1ff",["id"]="bilinear-computed-99",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2002] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3398c1ff",["id"]="bilinear-write-99",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2003] = scene:rectangle {["center"]={2.0041666666666664,-0.6458333333333331},["fill"]="#3398c1ff",["id"]="bilinear-committed-99",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2004] = scene:group {["id"]="bilinear-read-100",["opacity"]=0}
refs[2005] = refs[2004]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-100-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2006] = refs[2004]:rectangle {["center"]={-3.525,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-100-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2007] = refs[2004]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#3ea0c7ff",["id"]="bilinear-weight-100-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2008] = refs[2004]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-100-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2009] = refs[2004]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-100-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2010] = refs[2004]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-100-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2011] = refs[2004]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-100-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2012] = refs[2004]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-100-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2013] = refs[2004]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#2991beff",["id"]="bilinear-weight-100-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2014] = refs[2004]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-100-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2015] = refs[2004]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-100-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2016] = refs[2004]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-100-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2017] = refs[2004]:line {["from"]={-3.3315000049273173,-0.5218333284060157},["id"]="bilinear-sample-h-100",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-0.5218333284060157},["width"]=2}
refs[2018] = refs[2004]:line {["from"]={-3.2615000049273175,-0.45183332840601564},["id"]="bilinear-sample-v-100",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-0.5918333284060157},["width"]=2}
refs[2019] = refs[2004]:rectangle {["center"]={2.2625,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-100",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2020] = scene:rectangle {["center"]={-0.05,0},["fill"]="#369da6ff",["id"]="bilinear-computed-100",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2021] = scene:rectangle {["center"]={-0.05,0},["fill"]="#369da6ff",["id"]="bilinear-write-100",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2022] = scene:rectangle {["center"]={2.2625,-0.6458333333333331},["fill"]="#369da6ff",["id"]="bilinear-committed-100",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2023] = scene:group {["id"]="bilinear-read-101",["opacity"]=0}
refs[2024] = refs[2023]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-101-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2025] = refs[2023]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-101-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2026] = refs[2023]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-101-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2027] = refs[2023]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-101-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2028] = refs[2023]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-101-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2029] = refs[2023]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-101-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2030] = refs[2023]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-101-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2031] = refs[2023]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-101-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2032] = refs[2023]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-101-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2033] = refs[2023]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-101-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2034] = refs[2023]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-101-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2035] = refs[2023]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#34a559ff",["id"]="bilinear-weight-101-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2036] = refs[2023]:line {["from"]={-3.0731666715939845,-0.5218333284060157},["id"]="bilinear-sample-h-101",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-0.5218333284060157},["width"]=2}
refs[2037] = refs[2023]:line {["from"]={-3.003166671593984,-0.45183332840601564},["id"]="bilinear-sample-v-101",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-0.5918333284060157},["width"]=2}
refs[2038] = refs[2023]:rectangle {["center"]={2.5208333333333326,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-101",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2039] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3aa28bff",["id"]="bilinear-computed-101",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2040] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3aa28bff",["id"]="bilinear-write-101",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2041] = scene:rectangle {["center"]={2.5208333333333326,-0.6458333333333331},["fill"]="#3aa28bff",["id"]="bilinear-committed-101",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2042] = scene:group {["id"]="bilinear-read-102",["opacity"]=0}
refs[2043] = refs[2042]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-102-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2044] = refs[2042]:rectangle {["center"]={-3.0083333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-102-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2045] = refs[2042]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#47a0c3ff",["id"]="bilinear-weight-102-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2046] = refs[2042]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-102-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2047] = refs[2042]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-102-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2048] = refs[2042]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-102-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2049] = refs[2042]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-102-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2050] = refs[2042]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-102-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2051] = refs[2042]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#2fa556ff",["id"]="bilinear-weight-102-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2052] = refs[2042]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-102-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2053] = refs[2042]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-102-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2054] = refs[2042]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#34a559ff",["id"]="bilinear-weight-102-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2055] = refs[2042]:line {["from"]={-2.8148333382606507,-0.5218333284060157},["id"]="bilinear-sample-h-102",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-0.5218333284060157},["width"]=2}
refs[2056] = refs[2042]:line {["from"]={-2.7448333382606505,-0.45183332840601564},["id"]="bilinear-sample-v-102",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-0.5918333284060157},["width"]=2}
refs[2057] = refs[2042]:rectangle {["center"]={2.7791666666666663,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-102",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2058] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3da28aff",["id"]="bilinear-computed-102",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2059] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3da28aff",["id"]="bilinear-write-102",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2060] = scene:rectangle {["center"]={2.7791666666666663,-0.6458333333333331},["fill"]="#3da28aff",["id"]="bilinear-committed-102",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2061] = scene:group {["id"]="bilinear-read-103",["opacity"]=0}
refs[2062] = refs[2061]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-103-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2063] = refs[2061]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-103-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2064] = refs[2061]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-103-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2065] = refs[2061]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-103-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2066] = refs[2061]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-103-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2067] = refs[2061]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#399d5cff",["id"]="bilinear-weight-103-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2068] = refs[2061]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-103-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2069] = refs[2061]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-103-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2070] = refs[2061]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#34a559ff",["id"]="bilinear-weight-103-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2071] = refs[2061]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-103-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2072] = refs[2061]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-103-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2073] = refs[2061]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#39a55cff",["id"]="bilinear-weight-103-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2074] = refs[2061]:line {["from"]={-2.5565000049273174,-0.5218333284060157},["id"]="bilinear-sample-h-103",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-0.5218333284060157},["width"]=2}
refs[2075] = refs[2061]:line {["from"]={-2.4865000049273176,-0.45183332840601564},["id"]="bilinear-sample-v-103",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-0.5918333284060157},["width"]=2}
refs[2076] = refs[2061]:rectangle {["center"]={3.0375,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-103",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2077] = scene:rectangle {["center"]={-0.05,0},["fill"]="#41a28aff",["id"]="bilinear-computed-103",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2078] = scene:rectangle {["center"]={-0.05,0},["fill"]="#41a28aff",["id"]="bilinear-write-103",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2079] = scene:rectangle {["center"]={3.0375,-0.6458333333333331},["fill"]="#41a28aff",["id"]="bilinear-committed-103",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2080] = scene:group {["id"]="bilinear-read-104",["opacity"]=0}
refs[2081] = refs[2080]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-104-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2082] = refs[2080]:rectangle {["center"]={-2.4916666666666667,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-104-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2083] = refs[2080]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#50a0bfff",["id"]="bilinear-weight-104-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2084] = refs[2080]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-104-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2085] = refs[2080]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-104-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2086] = refs[2080]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#399d5cff",["id"]="bilinear-weight-104-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2087] = refs[2080]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-104-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2088] = refs[2080]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-104-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2089] = refs[2080]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#34a559ff",["id"]="bilinear-weight-104-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2090] = refs[2080]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-104-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2091] = refs[2080]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-104-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2092] = refs[2080]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#39a55cff",["id"]="bilinear-weight-104-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2093] = refs[2080]:line {["from"]={-2.298166671593984,-0.5218333284060157},["id"]="bilinear-sample-h-104",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-0.5218333284060157},["width"]=2}
refs[2094] = refs[2080]:line {["from"]={-2.2281666715939843,-0.45183332840601564},["id"]="bilinear-sample-v-104",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-0.5918333284060157},["width"]=2}
refs[2095] = refs[2080]:rectangle {["center"]={3.2958333333333325,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-104",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2096] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ca172ff",["id"]="bilinear-computed-104",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2097] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ca172ff",["id"]="bilinear-write-104",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2098] = scene:rectangle {["center"]={3.2958333333333325,-0.6458333333333331},["fill"]="#3ca172ff",["id"]="bilinear-committed-104",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2099] = scene:group {["id"]="bilinear-read-105",["opacity"]=0}
refs[2100] = refs[2099]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-105-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2101] = refs[2099]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-105-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2102] = refs[2099]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#399d5cff",["id"]="bilinear-weight-105-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2103] = refs[2099]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-105-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2104] = refs[2099]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-105-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2105] = refs[2099]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-105-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2106] = refs[2099]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-105-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2107] = refs[2099]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-105-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2108] = refs[2099]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#39a55cff",["id"]="bilinear-weight-105-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2109] = refs[2099]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-105-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2110] = refs[2099]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-105-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2111] = refs[2099]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-105-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2112] = refs[2099]:line {["from"]={-2.0398332150777185,-0.5218333284060157},["id"]="bilinear-sample-h-105",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-0.5218333284060157},["width"]=2}
refs[2113] = refs[2099]:line {["from"]={-1.9698332150777185,-0.45183332840601564},["id"]="bilinear-sample-v-105",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-0.5918333284060157},["width"]=2}
refs[2114] = refs[2099]:rectangle {["center"]={3.5541666666666663,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-105",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2115] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a15cff",["id"]="bilinear-computed-105",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2116] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a15cff",["id"]="bilinear-write-105",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2117] = scene:rectangle {["center"]={3.5541666666666663,-0.6458333333333331},["fill"]="#39a15cff",["id"]="bilinear-committed-105",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2118] = scene:group {["id"]="bilinear-read-106",["opacity"]=0}
refs[2119] = refs[2118]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-106-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2120] = refs[2118]:rectangle {["center"]={-1.975,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-106-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2121] = refs[2118]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#399d5cff",["id"]="bilinear-weight-106-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2122] = refs[2118]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-106-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2123] = refs[2118]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-106-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2124] = refs[2118]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-106-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2125] = refs[2118]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-106-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2126] = refs[2118]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-106-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2127] = refs[2118]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#39a55cff",["id"]="bilinear-weight-106-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2128] = refs[2118]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-106-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2129] = refs[2118]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-106-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2130] = refs[2118]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-106-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2131] = refs[2118]:line {["from"]={-1.7814998817443848,-0.5218333284060157},["id"]="bilinear-sample-h-106",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-0.5218333284060157},["width"]=2}
refs[2132] = refs[2118]:line {["from"]={-1.7114998817443847,-0.45183332840601564},["id"]="bilinear-sample-v-106",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-0.5918333284060157},["width"]=2}
refs[2133] = refs[2118]:rectangle {["center"]={3.8125,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-106",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2134] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba15dff",["id"]="bilinear-computed-106",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2135] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba15dff",["id"]="bilinear-write-106",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2136] = scene:rectangle {["center"]={3.8125,-0.6458333333333331},["fill"]="#3ba15dff",["id"]="bilinear-committed-106",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2137] = scene:group {["id"]="bilinear-read-107",["opacity"]=0}
refs[2138] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-107-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2139] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-107-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2140] = refs[2137]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-107-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2141] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-107-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2142] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.25833333333333314},["fill"]="#00000000",["id"]="bilinear-tap-ink-107-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2143] = refs[2137]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3e9d5fff",["id"]="bilinear-weight-107-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2144] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-107-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2145] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-107-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2146] = refs[2137]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-107-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2147] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-107-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2148] = refs[2137]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-107-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2149] = refs[2137]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3ea55fff",["id"]="bilinear-weight-107-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2150] = refs[2137]:line {["from"]={-1.5231665484110517,-0.5218333284060157},["id"]="bilinear-sample-h-107",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-0.5218333284060157},["width"]=2}
refs[2151] = refs[2137]:line {["from"]={-1.4531665484110516,-0.45183332840601564},["id"]="bilinear-sample-v-107",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-0.5918333284060157},["width"]=2}
refs[2152] = refs[2137]:rectangle {["center"]={4.070833333333333,-0.6458333333333331},["fill"]="#00000000",["id"]="bilinear-destination-107",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2153] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea15fff",["id"]="bilinear-computed-107",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2154] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea15fff",["id"]="bilinear-write-107",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2155] = scene:rectangle {["center"]={4.070833333333333,-0.6458333333333331},["fill"]="#3ea15fff",["id"]="bilinear-committed-107",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2156] = scene:group {["id"]="bilinear-read-108",["opacity"]=0}
refs[2157] = refs[2156]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-108-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2158] = refs[2156]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-108-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2159] = refs[2156]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-108-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2160] = refs[2156]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-108-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2161] = refs[2156]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-108-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2162] = refs[2156]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-108-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2163] = refs[2156]:line {["from"]={-4.364833338260651,-0.7801667849222815},["id"]="bilinear-sample-h-108",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-0.7801667849222815},["width"]=2}
refs[2164] = refs[2156]:line {["from"]={-4.29483333826065,-0.7101667849222815},["id"]="bilinear-sample-v-108",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-0.8501667849222815},["width"]=2}
refs[2165] = refs[2156]:rectangle {["center"]={1.2291666666666663,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-108",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2166] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2191b5ff",["id"]="bilinear-computed-108",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2167] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2191b5ff",["id"]="bilinear-write-108",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2168] = scene:rectangle {["center"]={1.2291666666666663,-0.9041666666666663},["fill"]="#2191b5ff",["id"]="bilinear-committed-108",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2169] = scene:group {["id"]="bilinear-read-109",["opacity"]=0}
refs[2170] = refs[2169]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-109-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2171] = refs[2169]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-109-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2172] = refs[2169]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-109-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2173] = refs[2169]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-109-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2174] = refs[2169]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-109-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2175] = refs[2169]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#2991beff",["id"]="bilinear-weight-109-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2176] = refs[2169]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-109-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2177] = refs[2169]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-109-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2178] = refs[2169]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-109-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2179] = refs[2169]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-109-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2180] = refs[2169]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-109-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2181] = refs[2169]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-109-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2182] = refs[2169]:line {["from"]={-4.106500004927318,-0.7801667849222815},["id"]="bilinear-sample-h-109",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-0.7801667849222815},["width"]=2}
refs[2183] = refs[2169]:line {["from"]={-4.036500004927317,-0.7101667849222815},["id"]="bilinear-sample-v-109",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-0.8501667849222815},["width"]=2}
refs[2184] = refs[2169]:rectangle {["center"]={1.4875,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-109",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2185] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2191b5ff",["id"]="bilinear-computed-109",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2186] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2191b5ff",["id"]="bilinear-write-109",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2187] = scene:rectangle {["center"]={1.4875,-0.9041666666666663},["fill"]="#2191b5ff",["id"]="bilinear-committed-109",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2188] = scene:group {["id"]="bilinear-read-110",["opacity"]=0}
refs[2189] = refs[2188]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-110-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2190] = refs[2188]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-110-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2191] = refs[2188]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-110-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2192] = refs[2188]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-110-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2193] = refs[2188]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-110-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2194] = refs[2188]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#2991beff",["id"]="bilinear-weight-110-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2195] = refs[2188]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-110-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2196] = refs[2188]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-110-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2197] = refs[2188]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-110-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2198] = refs[2188]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-110-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2199] = refs[2188]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-110-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2200] = refs[2188]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-110-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2201] = refs[2188]:line {["from"]={-3.8481666715939844,-0.7801667849222815},["id"]="bilinear-sample-h-110",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-0.7801667849222815},["width"]=2}
refs[2202] = refs[2188]:line {["from"]={-3.7781666715939846,-0.7101667849222815},["id"]="bilinear-sample-v-110",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-0.8501667849222815},["width"]=2}
refs[2203] = refs[2188]:rectangle {["center"]={1.7458333333333338,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-110",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2204] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2591b9ff",["id"]="bilinear-computed-110",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2205] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2591b9ff",["id"]="bilinear-write-110",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2206] = scene:rectangle {["center"]={1.7458333333333338,-0.9041666666666663},["fill"]="#2591b9ff",["id"]="bilinear-committed-110",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2207] = scene:group {["id"]="bilinear-read-111",["opacity"]=0}
refs[2208] = refs[2207]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-111-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2209] = refs[2207]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-111-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2210] = refs[2207]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#2991beff",["id"]="bilinear-weight-111-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2211] = refs[2207]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-111-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2212] = refs[2207]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-111-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2213] = refs[2207]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-111-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2214] = refs[2207]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-111-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2215] = refs[2207]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-111-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2216] = refs[2207]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-111-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2217] = refs[2207]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-111-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2218] = refs[2207]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-111-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2219] = refs[2207]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-111-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2220] = refs[2207]:line {["from"]={-3.5898333382606507,-0.7801667849222815},["id"]="bilinear-sample-h-111",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-0.7801667849222815},["width"]=2}
refs[2221] = refs[2207]:line {["from"]={-3.519833338260651,-0.7101667849222815},["id"]="bilinear-sample-v-111",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-0.8501667849222815},["width"]=2}
refs[2222] = refs[2207]:rectangle {["center"]={2.0041666666666664,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-111",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2223] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2991bdff",["id"]="bilinear-computed-111",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2224] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2991bdff",["id"]="bilinear-write-111",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2225] = scene:rectangle {["center"]={2.0041666666666664,-0.9041666666666663},["fill"]="#2991bdff",["id"]="bilinear-committed-111",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2226] = scene:group {["id"]="bilinear-read-112",["opacity"]=0}
refs[2227] = refs[2226]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-112-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2228] = refs[2226]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-112-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2229] = refs[2226]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#2991beff",["id"]="bilinear-weight-112-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2230] = refs[2226]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-112-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2231] = refs[2226]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-112-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2232] = refs[2226]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-112-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2233] = refs[2226]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-112-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2234] = refs[2226]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-112-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2235] = refs[2226]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-112-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2236] = refs[2226]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-112-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2237] = refs[2226]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-112-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2238] = refs[2226]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-112-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2239] = refs[2226]:line {["from"]={-3.3315000049273173,-0.7801667849222815},["id"]="bilinear-sample-h-112",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-0.7801667849222815},["width"]=2}
refs[2240] = refs[2226]:line {["from"]={-3.2615000049273175,-0.7101667849222815},["id"]="bilinear-sample-v-112",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-0.8501667849222815},["width"]=2}
refs[2241] = refs[2226]:rectangle {["center"]={2.2625,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-112",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2242] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2c9b89ff",["id"]="bilinear-computed-112",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2243] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2c9b89ff",["id"]="bilinear-write-112",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2244] = scene:rectangle {["center"]={2.2625,-0.9041666666666663},["fill"]="#2c9b89ff",["id"]="bilinear-committed-112",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2245] = scene:group {["id"]="bilinear-read-113",["opacity"]=0}
refs[2246] = refs[2245]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-113-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2247] = refs[2245]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-113-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2248] = refs[2245]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-113-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2249] = refs[2245]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-113-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2250] = refs[2245]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-113-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2251] = refs[2245]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#34a559ff",["id"]="bilinear-weight-113-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2252] = refs[2245]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-113-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2253] = refs[2245]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-113-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2254] = refs[2245]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-113-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2255] = refs[2245]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-113-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2256] = refs[2245]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-113-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2257] = refs[2245]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-113-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2258] = refs[2245]:line {["from"]={-3.0731666715939845,-0.7801667849222815},["id"]="bilinear-sample-h-113",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-0.7801667849222815},["width"]=2}
refs[2259] = refs[2245]:line {["from"]={-3.003166671593984,-0.7101667849222815},["id"]="bilinear-sample-v-113",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-0.8501667849222815},["width"]=2}
refs[2260] = refs[2245]:rectangle {["center"]={2.5208333333333326,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-113",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2261] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fa556ff",["id"]="bilinear-computed-113",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2262] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fa556ff",["id"]="bilinear-write-113",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2263] = scene:rectangle {["center"]={2.5208333333333326,-0.9041666666666663},["fill"]="#2fa556ff",["id"]="bilinear-committed-113",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2264] = scene:group {["id"]="bilinear-read-114",["opacity"]=0}
refs[2265] = refs[2264]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-114-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2266] = refs[2264]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-114-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2267] = refs[2264]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-114-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2268] = refs[2264]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-114-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2269] = refs[2264]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-114-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2270] = refs[2264]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#34a559ff",["id"]="bilinear-weight-114-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2271] = refs[2264]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-114-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2272] = refs[2264]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-114-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2273] = refs[2264]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-114-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2274] = refs[2264]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-114-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2275] = refs[2264]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-114-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2276] = refs[2264]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-114-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2277] = refs[2264]:line {["from"]={-2.8148333382606507,-0.7801667849222815},["id"]="bilinear-sample-h-114",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-0.7801667849222815},["width"]=2}
refs[2278] = refs[2264]:line {["from"]={-2.7448333382606505,-0.7101667849222815},["id"]="bilinear-sample-v-114",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-0.8501667849222815},["width"]=2}
refs[2279] = refs[2264]:rectangle {["center"]={2.7791666666666663,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-114",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2280] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31a557ff",["id"]="bilinear-computed-114",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2281] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31a557ff",["id"]="bilinear-write-114",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2282] = scene:rectangle {["center"]={2.7791666666666663,-0.9041666666666663},["fill"]="#31a557ff",["id"]="bilinear-committed-114",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2283] = scene:group {["id"]="bilinear-read-115",["opacity"]=0}
refs[2284] = refs[2283]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-115-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2285] = refs[2283]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-115-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2286] = refs[2283]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#34a559ff",["id"]="bilinear-weight-115-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2287] = refs[2283]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-115-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2288] = refs[2283]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-115-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2289] = refs[2283]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#39a55cff",["id"]="bilinear-weight-115-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2290] = refs[2283]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-115-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2291] = refs[2283]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-115-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2292] = refs[2283]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-115-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2293] = refs[2283]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-115-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2294] = refs[2283]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-115-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2295] = refs[2283]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-115-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2296] = refs[2283]:line {["from"]={-2.5565000049273174,-0.7801667849222815},["id"]="bilinear-sample-h-115",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-0.7801667849222815},["width"]=2}
refs[2297] = refs[2283]:line {["from"]={-2.4865000049273176,-0.7101667849222815},["id"]="bilinear-sample-v-115",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-0.8501667849222815},["width"]=2}
refs[2298] = refs[2283]:rectangle {["center"]={3.0375,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-115",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2299] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34a559ff",["id"]="bilinear-computed-115",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2300] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34a559ff",["id"]="bilinear-write-115",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2301] = scene:rectangle {["center"]={3.0375,-0.9041666666666663},["fill"]="#34a559ff",["id"]="bilinear-committed-115",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2302] = scene:group {["id"]="bilinear-read-116",["opacity"]=0}
refs[2303] = refs[2302]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-116-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2304] = refs[2302]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-116-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2305] = refs[2302]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#34a559ff",["id"]="bilinear-weight-116-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2306] = refs[2302]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-116-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2307] = refs[2302]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-116-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2308] = refs[2302]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#39a55cff",["id"]="bilinear-weight-116-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2309] = refs[2302]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-116-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2310] = refs[2302]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-116-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2311] = refs[2302]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-116-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2312] = refs[2302]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-116-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2313] = refs[2302]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-116-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2314] = refs[2302]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-116-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2315] = refs[2302]:line {["from"]={-2.298166671593984,-0.7801667849222815},["id"]="bilinear-sample-h-116",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-0.7801667849222815},["width"]=2}
refs[2316] = refs[2302]:line {["from"]={-2.2281666715939843,-0.7101667849222815},["id"]="bilinear-sample-v-116",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-0.8501667849222815},["width"]=2}
refs[2317] = refs[2302]:rectangle {["center"]={3.2958333333333325,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-116",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2318] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36a55aff",["id"]="bilinear-computed-116",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2319] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36a55aff",["id"]="bilinear-write-116",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2320] = scene:rectangle {["center"]={3.2958333333333325,-0.9041666666666663},["fill"]="#36a55aff",["id"]="bilinear-committed-116",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2321] = scene:group {["id"]="bilinear-read-117",["opacity"]=0}
refs[2322] = refs[2321]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-117-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2323] = refs[2321]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-117-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2324] = refs[2321]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#39a55cff",["id"]="bilinear-weight-117-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2325] = refs[2321]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-117-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2326] = refs[2321]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-117-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2327] = refs[2321]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-117-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2328] = refs[2321]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-117-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2329] = refs[2321]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-117-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2330] = refs[2321]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-117-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2331] = refs[2321]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-117-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2332] = refs[2321]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-117-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2333] = refs[2321]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-117-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2334] = refs[2321]:line {["from"]={-2.0398332150777185,-0.7801667849222815},["id"]="bilinear-sample-h-117",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-0.7801667849222815},["width"]=2}
refs[2335] = refs[2321]:line {["from"]={-1.9698332150777185,-0.7101667849222815},["id"]="bilinear-sample-v-117",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-0.8501667849222815},["width"]=2}
refs[2336] = refs[2321]:rectangle {["center"]={3.5541666666666663,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-117",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2337] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a55cff",["id"]="bilinear-computed-117",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2338] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a55cff",["id"]="bilinear-write-117",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2339] = scene:rectangle {["center"]={3.5541666666666663,-0.9041666666666663},["fill"]="#39a55cff",["id"]="bilinear-committed-117",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2340] = scene:group {["id"]="bilinear-read-118",["opacity"]=0}
refs[2341] = refs[2340]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-118-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2342] = refs[2340]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-118-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2343] = refs[2340]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#39a55cff",["id"]="bilinear-weight-118-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2344] = refs[2340]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-118-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2345] = refs[2340]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-118-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2346] = refs[2340]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-118-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2347] = refs[2340]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-118-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2348] = refs[2340]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-118-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2349] = refs[2340]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-118-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2350] = refs[2340]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-118-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2351] = refs[2340]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-118-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2352] = refs[2340]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-118-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2353] = refs[2340]:line {["from"]={-1.7814998817443848,-0.7801667849222815},["id"]="bilinear-sample-h-118",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-0.7801667849222815},["width"]=2}
refs[2354] = refs[2340]:line {["from"]={-1.7114998817443847,-0.7101667849222815},["id"]="bilinear-sample-v-118",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-0.8501667849222815},["width"]=2}
refs[2355] = refs[2340]:rectangle {["center"]={3.8125,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-118",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2356] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba55dff",["id"]="bilinear-computed-118",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2357] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba55dff",["id"]="bilinear-write-118",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2358] = scene:rectangle {["center"]={3.8125,-0.9041666666666663},["fill"]="#3ba55dff",["id"]="bilinear-committed-118",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2359] = scene:group {["id"]="bilinear-read-119",["opacity"]=0}
refs[2360] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-119-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2361] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-119-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2362] = refs[2359]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-119-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2363] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-119-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2364] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-119-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2365] = refs[2359]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-119-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2366] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-119-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2367] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-119-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2368] = refs[2359]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-119-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2369] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-119-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2370] = refs[2359]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-119-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2371] = refs[2359]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-119-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2372] = refs[2359]:line {["from"]={-1.5231665484110517,-0.7801667849222815},["id"]="bilinear-sample-h-119",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-0.7801667849222815},["width"]=2}
refs[2373] = refs[2359]:line {["from"]={-1.4531665484110516,-0.7101667849222815},["id"]="bilinear-sample-v-119",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-0.8501667849222815},["width"]=2}
refs[2374] = refs[2359]:rectangle {["center"]={4.070833333333333,-0.9041666666666663},["fill"]="#00000000",["id"]="bilinear-destination-119",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2375] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea55fff",["id"]="bilinear-computed-119",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2376] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea55fff",["id"]="bilinear-write-119",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2377] = scene:rectangle {["center"]={4.070833333333333,-0.9041666666666663},["fill"]="#3ea55fff",["id"]="bilinear-committed-119",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2378] = scene:group {["id"]="bilinear-read-120",["opacity"]=0}
refs[2379] = refs[2378]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-120-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2380] = refs[2378]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-120-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2381] = refs[2378]:rectangle {["center"]={-0.05,0.23359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-120-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2382] = refs[2378]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-120-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2383] = refs[2378]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-120-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2384] = refs[2378]:rectangle {["center"]={-0.05,-0.22640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-120-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2385] = refs[2378]:line {["from"]={-4.364833338260651,-1.0385001182556153},["id"]="bilinear-sample-h-120",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-1.0385001182556153},["width"]=2}
refs[2386] = refs[2378]:line {["from"]={-4.29483333826065,-0.9685001182556152},["id"]="bilinear-sample-v-120",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-1.1085001182556153},["width"]=2}
refs[2387] = refs[2378]:rectangle {["center"]={1.2291666666666663,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-120",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2388] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2196b5ff",["id"]="bilinear-computed-120",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2389] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2196b5ff",["id"]="bilinear-write-120",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2390] = scene:rectangle {["center"]={1.2291666666666663,-1.1625},["fill"]="#2196b5ff",["id"]="bilinear-committed-120",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2391] = scene:group {["id"]="bilinear-read-121",["opacity"]=0}
refs[2392] = refs[2391]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-121-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2393] = refs[2391]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-121-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2394] = refs[2391]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-121-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2395] = refs[2391]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-121-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2396] = refs[2391]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-121-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2397] = refs[2391]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#2991beff",["id"]="bilinear-weight-121-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2398] = refs[2391]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-121-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2399] = refs[2391]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-121-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2400] = refs[2391]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-121-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2401] = refs[2391]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-121-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2402] = refs[2391]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-121-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2403] = refs[2391]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#299cbeff",["id"]="bilinear-weight-121-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2404] = refs[2391]:line {["from"]={-4.106500004927318,-1.0385001182556153},["id"]="bilinear-sample-h-121",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-1.0385001182556153},["width"]=2}
refs[2405] = refs[2391]:line {["from"]={-4.036500004927317,-0.9685001182556152},["id"]="bilinear-sample-v-121",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-1.1085001182556153},["width"]=2}
refs[2406] = refs[2391]:rectangle {["center"]={1.4875,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-121",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2407] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2196b5ff",["id"]="bilinear-computed-121",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2408] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2196b5ff",["id"]="bilinear-write-121",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2409] = scene:rectangle {["center"]={1.4875,-1.1625},["fill"]="#2196b5ff",["id"]="bilinear-committed-121",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2410] = scene:group {["id"]="bilinear-read-122",["opacity"]=0}
refs[2411] = refs[2410]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-122-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2412] = refs[2410]:rectangle {["center"]={-4.041666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-122-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2413] = refs[2410]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#2191b5ff",["id"]="bilinear-weight-122-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2414] = refs[2410]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-122-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2415] = refs[2410]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-122-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2416] = refs[2410]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#2991beff",["id"]="bilinear-weight-122-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2417] = refs[2410]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-122-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2418] = refs[2410]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-122-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2419] = refs[2410]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-122-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2420] = refs[2410]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-122-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2421] = refs[2410]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-122-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2422] = refs[2410]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#299cbeff",["id"]="bilinear-weight-122-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2423] = refs[2410]:line {["from"]={-3.8481666715939844,-1.0385001182556153},["id"]="bilinear-sample-h-122",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-1.0385001182556153},["width"]=2}
refs[2424] = refs[2410]:line {["from"]={-3.7781666715939846,-0.9685001182556152},["id"]="bilinear-sample-v-122",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-1.1085001182556153},["width"]=2}
refs[2425] = refs[2410]:rectangle {["center"]={1.7458333333333338,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-122",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2426] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2596b9ff",["id"]="bilinear-computed-122",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2427] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2596b9ff",["id"]="bilinear-write-122",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2428] = scene:rectangle {["center"]={1.7458333333333338,-1.1625},["fill"]="#2596b9ff",["id"]="bilinear-committed-122",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2429] = scene:group {["id"]="bilinear-read-123",["opacity"]=0}
refs[2430] = refs[2429]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-123-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2431] = refs[2429]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-123-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2432] = refs[2429]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#2991beff",["id"]="bilinear-weight-123-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2433] = refs[2429]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-123-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2434] = refs[2429]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-123-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2435] = refs[2429]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-123-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2436] = refs[2429]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-123-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2437] = refs[2429]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-123-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2438] = refs[2429]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#299cbeff",["id"]="bilinear-weight-123-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2439] = refs[2429]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-123-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2440] = refs[2429]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-123-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2441] = refs[2429]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-123-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2442] = refs[2429]:line {["from"]={-3.5898333382606507,-1.0385001182556153},["id"]="bilinear-sample-h-123",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-1.0385001182556153},["width"]=2}
refs[2443] = refs[2429]:line {["from"]={-3.519833338260651,-0.9685001182556152},["id"]="bilinear-sample-v-123",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-1.1085001182556153},["width"]=2}
refs[2444] = refs[2429]:rectangle {["center"]={2.0041666666666664,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-123",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2445] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2996bdff",["id"]="bilinear-computed-123",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2446] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2996bdff",["id"]="bilinear-write-123",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2447] = scene:rectangle {["center"]={2.0041666666666664,-1.1625},["fill"]="#2996bdff",["id"]="bilinear-committed-123",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2448] = scene:group {["id"]="bilinear-read-124",["opacity"]=0}
refs[2449] = refs[2448]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-124-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2450] = refs[2448]:rectangle {["center"]={-3.525,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-124-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2451] = refs[2448]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#2991beff",["id"]="bilinear-weight-124-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2452] = refs[2448]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-124-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2453] = refs[2448]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-124-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2454] = refs[2448]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-124-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2455] = refs[2448]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-124-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2456] = refs[2448]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-124-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2457] = refs[2448]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#299cbeff",["id"]="bilinear-weight-124-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2458] = refs[2448]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-124-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2459] = refs[2448]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-124-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2460] = refs[2448]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-124-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2461] = refs[2448]:line {["from"]={-3.3315000049273173,-1.0385001182556153},["id"]="bilinear-sample-h-124",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-1.0385001182556153},["width"]=2}
refs[2462] = refs[2448]:line {["from"]={-3.2615000049273175,-0.9685001182556152},["id"]="bilinear-sample-v-124",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-1.1085001182556153},["width"]=2}
refs[2463] = refs[2448]:rectangle {["center"]={2.2625,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-124",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2464] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2c9f89ff",["id"]="bilinear-computed-124",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2465] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2c9f89ff",["id"]="bilinear-write-124",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2466] = scene:rectangle {["center"]={2.2625,-1.1625},["fill"]="#2c9f89ff",["id"]="bilinear-committed-124",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2467] = scene:group {["id"]="bilinear-read-125",["opacity"]=0}
refs[2468] = refs[2467]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-125-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2469] = refs[2467]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-125-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2470] = refs[2467]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-125-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2471] = refs[2467]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-125-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2472] = refs[2467]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-125-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2473] = refs[2467]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#34a559ff",["id"]="bilinear-weight-125-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2474] = refs[2467]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-125-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2475] = refs[2467]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-125-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2476] = refs[2467]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-125-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2477] = refs[2467]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-125-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2478] = refs[2467]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-125-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2479] = refs[2467]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-125-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2480] = refs[2467]:line {["from"]={-3.0731666715939845,-1.0385001182556153},["id"]="bilinear-sample-h-125",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-1.0385001182556153},["width"]=2}
refs[2481] = refs[2467]:line {["from"]={-3.003166671593984,-0.9685001182556152},["id"]="bilinear-sample-v-125",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-1.1085001182556153},["width"]=2}
refs[2482] = refs[2467]:rectangle {["center"]={2.5208333333333326,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-125",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2483] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fa956ff",["id"]="bilinear-computed-125",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2484] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fa956ff",["id"]="bilinear-write-125",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2485] = scene:rectangle {["center"]={2.5208333333333326,-1.1625},["fill"]="#2fa956ff",["id"]="bilinear-committed-125",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2486] = scene:group {["id"]="bilinear-read-126",["opacity"]=0}
refs[2487] = refs[2486]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-126-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2488] = refs[2486]:rectangle {["center"]={-3.0083333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-126-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2489] = refs[2486]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#2fa556ff",["id"]="bilinear-weight-126-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2490] = refs[2486]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-126-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2491] = refs[2486]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-126-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2492] = refs[2486]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#34a559ff",["id"]="bilinear-weight-126-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2493] = refs[2486]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-126-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2494] = refs[2486]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-126-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2495] = refs[2486]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-126-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2496] = refs[2486]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-126-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2497] = refs[2486]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-126-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2498] = refs[2486]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-126-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2499] = refs[2486]:line {["from"]={-2.8148333382606507,-1.0385001182556153},["id"]="bilinear-sample-h-126",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-1.0385001182556153},["width"]=2}
refs[2500] = refs[2486]:line {["from"]={-2.7448333382606505,-0.9685001182556152},["id"]="bilinear-sample-v-126",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-1.1085001182556153},["width"]=2}
refs[2501] = refs[2486]:rectangle {["center"]={2.7791666666666663,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-126",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2502] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31a957ff",["id"]="bilinear-computed-126",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2503] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31a957ff",["id"]="bilinear-write-126",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2504] = scene:rectangle {["center"]={2.7791666666666663,-1.1625},["fill"]="#31a957ff",["id"]="bilinear-committed-126",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2505] = scene:group {["id"]="bilinear-read-127",["opacity"]=0}
refs[2506] = refs[2505]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-127-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2507] = refs[2505]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-127-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2508] = refs[2505]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#34a559ff",["id"]="bilinear-weight-127-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2509] = refs[2505]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-127-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2510] = refs[2505]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-127-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2511] = refs[2505]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#39a55cff",["id"]="bilinear-weight-127-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2512] = refs[2505]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-127-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2513] = refs[2505]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-127-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2514] = refs[2505]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-127-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2515] = refs[2505]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-127-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2516] = refs[2505]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-127-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2517] = refs[2505]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-127-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2518] = refs[2505]:line {["from"]={-2.5565000049273174,-1.0385001182556153},["id"]="bilinear-sample-h-127",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-1.0385001182556153},["width"]=2}
refs[2519] = refs[2505]:line {["from"]={-2.4865000049273176,-0.9685001182556152},["id"]="bilinear-sample-v-127",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-1.1085001182556153},["width"]=2}
refs[2520] = refs[2505]:rectangle {["center"]={3.0375,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-127",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2521] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34a959ff",["id"]="bilinear-computed-127",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2522] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34a959ff",["id"]="bilinear-write-127",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2523] = scene:rectangle {["center"]={3.0375,-1.1625},["fill"]="#34a959ff",["id"]="bilinear-committed-127",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2524] = scene:group {["id"]="bilinear-read-128",["opacity"]=0}
refs[2525] = refs[2524]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-128-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2526] = refs[2524]:rectangle {["center"]={-2.4916666666666667,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-128-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2527] = refs[2524]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#34a559ff",["id"]="bilinear-weight-128-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2528] = refs[2524]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-128-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2529] = refs[2524]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-128-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2530] = refs[2524]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#39a55cff",["id"]="bilinear-weight-128-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2531] = refs[2524]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-128-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2532] = refs[2524]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-128-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2533] = refs[2524]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-128-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2534] = refs[2524]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-128-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2535] = refs[2524]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-128-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2536] = refs[2524]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-128-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2537] = refs[2524]:line {["from"]={-2.298166671593984,-1.0385001182556153},["id"]="bilinear-sample-h-128",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-1.0385001182556153},["width"]=2}
refs[2538] = refs[2524]:line {["from"]={-2.2281666715939843,-0.9685001182556152},["id"]="bilinear-sample-v-128",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-1.1085001182556153},["width"]=2}
refs[2539] = refs[2524]:rectangle {["center"]={3.2958333333333325,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-128",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2540] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36a95aff",["id"]="bilinear-computed-128",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2541] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36a95aff",["id"]="bilinear-write-128",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2542] = scene:rectangle {["center"]={3.2958333333333325,-1.1625},["fill"]="#36a95aff",["id"]="bilinear-committed-128",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2543] = scene:group {["id"]="bilinear-read-129",["opacity"]=0}
refs[2544] = refs[2543]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-129-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2545] = refs[2543]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-129-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2546] = refs[2543]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#39a55cff",["id"]="bilinear-weight-129-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2547] = refs[2543]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-129-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2548] = refs[2543]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-129-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2549] = refs[2543]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-129-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2550] = refs[2543]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-129-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2551] = refs[2543]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-129-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2552] = refs[2543]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-129-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2553] = refs[2543]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-129-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2554] = refs[2543]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-129-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2555] = refs[2543]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-129-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2556] = refs[2543]:line {["from"]={-2.0398332150777185,-1.0385001182556153},["id"]="bilinear-sample-h-129",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-1.0385001182556153},["width"]=2}
refs[2557] = refs[2543]:line {["from"]={-1.9698332150777185,-0.9685001182556152},["id"]="bilinear-sample-v-129",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-1.1085001182556153},["width"]=2}
refs[2558] = refs[2543]:rectangle {["center"]={3.5541666666666663,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-129",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2559] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a95cff",["id"]="bilinear-computed-129",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2560] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39a95cff",["id"]="bilinear-write-129",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2561] = scene:rectangle {["center"]={3.5541666666666663,-1.1625},["fill"]="#39a95cff",["id"]="bilinear-committed-129",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2562] = scene:group {["id"]="bilinear-read-130",["opacity"]=0}
refs[2563] = refs[2562]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-130-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2564] = refs[2562]:rectangle {["center"]={-1.975,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-130-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2565] = refs[2562]:rectangle {["center"]={-0.2328125,0.23359375},["fill"]="#39a55cff",["id"]="bilinear-weight-130-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2566] = refs[2562]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-130-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2567] = refs[2562]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-130-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2568] = refs[2562]:rectangle {["center"]={0.1271875,0.23359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-130-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2569] = refs[2562]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-130-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2570] = refs[2562]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-130-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2571] = refs[2562]:rectangle {["center"]={-0.2328125,-0.22640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-130-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2572] = refs[2562]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-130-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2573] = refs[2562]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-130-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2574] = refs[2562]:rectangle {["center"]={0.1271875,-0.22640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-130-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2575] = refs[2562]:line {["from"]={-1.7814998817443848,-1.0385001182556153},["id"]="bilinear-sample-h-130",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-1.0385001182556153},["width"]=2}
refs[2576] = refs[2562]:line {["from"]={-1.7114998817443847,-0.9685001182556152},["id"]="bilinear-sample-v-130",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-1.1085001182556153},["width"]=2}
refs[2577] = refs[2562]:rectangle {["center"]={3.8125,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-130",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2578] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba95dff",["id"]="bilinear-computed-130",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2579] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ba95dff",["id"]="bilinear-write-130",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2580] = scene:rectangle {["center"]={3.8125,-1.1625},["fill"]="#3ba95dff",["id"]="bilinear-committed-130",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2581] = scene:group {["id"]="bilinear-read-131",["opacity"]=0}
refs[2582] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-131-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2583] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-131-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2584] = refs[2581]:rectangle {["center"]={-0.0528125,0.23359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-131-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2585] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-131-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2586] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-0.775},["fill"]="#00000000",["id"]="bilinear-tap-ink-131-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2587] = refs[2581]:rectangle {["center"]={0.3071875,0.23359375},["fill"]="#3ea55fff",["id"]="bilinear-weight-131-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4528125},["stroke"]="#00000000",["width"]=0}
refs[2588] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-131-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2589] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-131-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2590] = refs[2581]:rectangle {["center"]={-0.0528125,-0.22640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-131-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2591] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-131-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2592] = refs[2581]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-131-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2593] = refs[2581]:rectangle {["center"]={0.3071875,-0.22640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-131-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.4671875},["stroke"]="#00000000",["width"]=0}
refs[2594] = refs[2581]:line {["from"]={-1.5231665484110517,-1.0385001182556153},["id"]="bilinear-sample-h-131",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-1.0385001182556153},["width"]=2}
refs[2595] = refs[2581]:line {["from"]={-1.4531665484110516,-0.9685001182556152},["id"]="bilinear-sample-v-131",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-1.1085001182556153},["width"]=2}
refs[2596] = refs[2581]:rectangle {["center"]={4.070833333333333,-1.1625},["fill"]="#00000000",["id"]="bilinear-destination-131",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2597] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea95fff",["id"]="bilinear-computed-131",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2598] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ea95fff",["id"]="bilinear-write-131",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2599] = scene:rectangle {["center"]={4.070833333333333,-1.1625},["fill"]="#3ea95fff",["id"]="bilinear-committed-131",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2600] = scene:group {["id"]="bilinear-read-132",["opacity"]=0}
refs[2601] = refs[2600]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-132-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2602] = refs[2600]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-132-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2603] = refs[2600]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#219cb5ff",["id"]="bilinear-weight-132-0",["layer"]=22,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2604] = refs[2600]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-132-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2605] = refs[2600]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-132-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2606] = refs[2600]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-132-1",["layer"]=22,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2607] = refs[2600]:line {["from"]={-4.364833338260651,-1.2968334515889484},["id"]="bilinear-sample-h-132",["layer"]=30,["stroke"]="#263447",["to"]={-4.224833338260651,-1.2968334515889484},["width"]=2}
refs[2608] = refs[2600]:line {["from"]={-4.29483333826065,-1.2268334515889483},["id"]="bilinear-sample-v-132",["layer"]=30,["stroke"]="#263447",["to"]={-4.29483333826065,-1.3668334515889484},["width"]=2}
refs[2609] = refs[2600]:rectangle {["center"]={1.2291666666666663,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-132",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2610] = scene:rectangle {["center"]={-0.05,0},["fill"]="#219cb5ff",["id"]="bilinear-computed-132",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2611] = scene:rectangle {["center"]={-0.05,0},["fill"]="#219cb5ff",["id"]="bilinear-write-132",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2612] = scene:rectangle {["center"]={1.2291666666666663,-1.4208333333333332},["fill"]="#219cb5ff",["id"]="bilinear-committed-132",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2613] = scene:group {["id"]="bilinear-read-133",["opacity"]=0}
refs[2614] = refs[2613]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-133-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2615] = refs[2613]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-133-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2616] = refs[2613]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#219cb5ff",["id"]="bilinear-weight-133-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2617] = refs[2613]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-133-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2618] = refs[2613]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-133-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2619] = refs[2613]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#299cbeff",["id"]="bilinear-weight-133-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2620] = refs[2613]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-133-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2621] = refs[2613]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-133-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2622] = refs[2613]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-133-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2623] = refs[2613]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-133-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2624] = refs[2613]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-133-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2625] = refs[2613]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-133-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2626] = refs[2613]:line {["from"]={-4.106500004927318,-1.2968334515889484},["id"]="bilinear-sample-h-133",["layer"]=30,["stroke"]="#263447",["to"]={-3.9665000049273176,-1.2968334515889484},["width"]=2}
refs[2627] = refs[2613]:line {["from"]={-4.036500004927317,-1.2268334515889483},["id"]="bilinear-sample-v-133",["layer"]=30,["stroke"]="#263447",["to"]={-4.036500004927317,-1.3668334515889484},["width"]=2}
refs[2628] = refs[2613]:rectangle {["center"]={1.4875,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-133",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2629] = scene:rectangle {["center"]={-0.05,0},["fill"]="#219cb5ff",["id"]="bilinear-computed-133",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2630] = scene:rectangle {["center"]={-0.05,0},["fill"]="#219cb5ff",["id"]="bilinear-write-133",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2631] = scene:rectangle {["center"]={1.4875,-1.4208333333333332},["fill"]="#219cb5ff",["id"]="bilinear-committed-133",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2632] = scene:group {["id"]="bilinear-read-134",["opacity"]=0}
refs[2633] = refs[2632]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-134-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2634] = refs[2632]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-134-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2635] = refs[2632]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#219cb5ff",["id"]="bilinear-weight-134-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2636] = refs[2632]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-134-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2637] = refs[2632]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-134-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2638] = refs[2632]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#299cbeff",["id"]="bilinear-weight-134-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2639] = refs[2632]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-134-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2640] = refs[2632]:rectangle {["center"]={-4.041666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-134-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2641] = refs[2632]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#219cb5ff",["id"]="bilinear-weight-134-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2642] = refs[2632]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-134-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2643] = refs[2632]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-134-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2644] = refs[2632]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-134-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2645] = refs[2632]:line {["from"]={-3.8481666715939844,-1.2968334515889484},["id"]="bilinear-sample-h-134",["layer"]=30,["stroke"]="#263447",["to"]={-3.7081666715939843,-1.2968334515889484},["width"]=2}
refs[2646] = refs[2632]:line {["from"]={-3.7781666715939846,-1.2268334515889483},["id"]="bilinear-sample-v-134",["layer"]=30,["stroke"]="#263447",["to"]={-3.7781666715939846,-1.3668334515889484},["width"]=2}
refs[2647] = refs[2632]:rectangle {["center"]={1.7458333333333338,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-134",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2648] = scene:rectangle {["center"]={-0.05,0},["fill"]="#259cb9ff",["id"]="bilinear-computed-134",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2649] = scene:rectangle {["center"]={-0.05,0},["fill"]="#259cb9ff",["id"]="bilinear-write-134",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2650] = scene:rectangle {["center"]={1.7458333333333338,-1.4208333333333332},["fill"]="#259cb9ff",["id"]="bilinear-committed-134",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2651] = scene:group {["id"]="bilinear-read-135",["opacity"]=0}
refs[2652] = refs[2651]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-135-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2653] = refs[2651]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-135-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2654] = refs[2651]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#299cbeff",["id"]="bilinear-weight-135-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2655] = refs[2651]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-135-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2656] = refs[2651]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-135-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2657] = refs[2651]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#2fad56ff",["id"]="bilinear-weight-135-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2658] = refs[2651]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-135-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2659] = refs[2651]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-135-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2660] = refs[2651]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-135-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2661] = refs[2651]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-135-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2662] = refs[2651]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-135-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2663] = refs[2651]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-135-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2664] = refs[2651]:line {["from"]={-3.5898333382606507,-1.2968334515889484},["id"]="bilinear-sample-h-135",["layer"]=30,["stroke"]="#263447",["to"]={-3.4498333382606505,-1.2968334515889484},["width"]=2}
refs[2665] = refs[2651]:line {["from"]={-3.519833338260651,-1.2268334515889483},["id"]="bilinear-sample-v-135",["layer"]=30,["stroke"]="#263447",["to"]={-3.519833338260651,-1.3668334515889484},["width"]=2}
refs[2666] = refs[2651]:rectangle {["center"]={2.0041666666666664,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-135",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2667] = scene:rectangle {["center"]={-0.05,0},["fill"]="#299cbdff",["id"]="bilinear-computed-135",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2668] = scene:rectangle {["center"]={-0.05,0},["fill"]="#299cbdff",["id"]="bilinear-write-135",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2669] = scene:rectangle {["center"]={2.0041666666666664,-1.4208333333333332},["fill"]="#299cbdff",["id"]="bilinear-committed-135",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2670] = scene:group {["id"]="bilinear-read-136",["opacity"]=0}
refs[2671] = refs[2670]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-136-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2672] = refs[2670]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-136-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2673] = refs[2670]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#299cbeff",["id"]="bilinear-weight-136-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2674] = refs[2670]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-136-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2675] = refs[2670]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-136-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2676] = refs[2670]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#2fad56ff",["id"]="bilinear-weight-136-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2677] = refs[2670]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-136-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2678] = refs[2670]:rectangle {["center"]={-3.525,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-136-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2679] = refs[2670]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#299cbeff",["id"]="bilinear-weight-136-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2680] = refs[2670]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-136-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2681] = refs[2670]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-136-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2682] = refs[2670]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-136-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2683] = refs[2670]:line {["from"]={-3.3315000049273173,-1.2968334515889484},["id"]="bilinear-sample-h-136",["layer"]=30,["stroke"]="#263447",["to"]={-3.1915000049273177,-1.2968334515889484},["width"]=2}
refs[2684] = refs[2670]:line {["from"]={-3.2615000049273175,-1.2268334515889483},["id"]="bilinear-sample-v-136",["layer"]=30,["stroke"]="#263447",["to"]={-3.2615000049273175,-1.3668334515889484},["width"]=2}
refs[2685] = refs[2670]:rectangle {["center"]={2.2625,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-136",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2686] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2ca489ff",["id"]="bilinear-computed-136",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2687] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2ca489ff",["id"]="bilinear-write-136",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2688] = scene:rectangle {["center"]={2.2625,-1.4208333333333332},["fill"]="#2ca489ff",["id"]="bilinear-committed-136",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2689] = scene:group {["id"]="bilinear-read-137",["opacity"]=0}
refs[2690] = refs[2689]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-137-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2691] = refs[2689]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-137-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2692] = refs[2689]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#2fad56ff",["id"]="bilinear-weight-137-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2693] = refs[2689]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-137-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2694] = refs[2689]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-137-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2695] = refs[2689]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#34ad59ff",["id"]="bilinear-weight-137-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2696] = refs[2689]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-137-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2697] = refs[2689]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-137-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2698] = refs[2689]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-137-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2699] = refs[2689]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-137-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2700] = refs[2689]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-137-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2701] = refs[2689]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-137-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2702] = refs[2689]:line {["from"]={-3.0731666715939845,-1.2968334515889484},["id"]="bilinear-sample-h-137",["layer"]=30,["stroke"]="#263447",["to"]={-2.9331666715939844,-1.2968334515889484},["width"]=2}
refs[2703] = refs[2689]:line {["from"]={-3.003166671593984,-1.2268334515889483},["id"]="bilinear-sample-v-137",["layer"]=30,["stroke"]="#263447",["to"]={-3.003166671593984,-1.3668334515889484},["width"]=2}
refs[2704] = refs[2689]:rectangle {["center"]={2.5208333333333326,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-137",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2705] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fad56ff",["id"]="bilinear-computed-137",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2706] = scene:rectangle {["center"]={-0.05,0},["fill"]="#2fad56ff",["id"]="bilinear-write-137",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2707] = scene:rectangle {["center"]={2.5208333333333326,-1.4208333333333332},["fill"]="#2fad56ff",["id"]="bilinear-committed-137",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2708] = scene:group {["id"]="bilinear-read-138",["opacity"]=0}
refs[2709] = refs[2708]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-138-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2710] = refs[2708]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-138-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2711] = refs[2708]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#2fad56ff",["id"]="bilinear-weight-138-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2712] = refs[2708]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-138-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2713] = refs[2708]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-138-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2714] = refs[2708]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#34ad59ff",["id"]="bilinear-weight-138-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2715] = refs[2708]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-138-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2716] = refs[2708]:rectangle {["center"]={-3.0083333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-138-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2717] = refs[2708]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#2fad56ff",["id"]="bilinear-weight-138-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2718] = refs[2708]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-138-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2719] = refs[2708]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-138-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2720] = refs[2708]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-138-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2721] = refs[2708]:line {["from"]={-2.8148333382606507,-1.2968334515889484},["id"]="bilinear-sample-h-138",["layer"]=30,["stroke"]="#263447",["to"]={-2.6748333382606506,-1.2968334515889484},["width"]=2}
refs[2722] = refs[2708]:line {["from"]={-2.7448333382606505,-1.2268334515889483},["id"]="bilinear-sample-v-138",["layer"]=30,["stroke"]="#263447",["to"]={-2.7448333382606505,-1.3668334515889484},["width"]=2}
refs[2723] = refs[2708]:rectangle {["center"]={2.7791666666666663,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-138",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2724] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31ad57ff",["id"]="bilinear-computed-138",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2725] = scene:rectangle {["center"]={-0.05,0},["fill"]="#31ad57ff",["id"]="bilinear-write-138",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2726] = scene:rectangle {["center"]={2.7791666666666663,-1.4208333333333332},["fill"]="#31ad57ff",["id"]="bilinear-committed-138",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2727] = scene:group {["id"]="bilinear-read-139",["opacity"]=0}
refs[2728] = refs[2727]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-139-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2729] = refs[2727]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-139-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2730] = refs[2727]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#34ad59ff",["id"]="bilinear-weight-139-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2731] = refs[2727]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-139-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2732] = refs[2727]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-139-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2733] = refs[2727]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#39ad5cff",["id"]="bilinear-weight-139-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2734] = refs[2727]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-139-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2735] = refs[2727]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-139-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2736] = refs[2727]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-139-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2737] = refs[2727]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-139-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2738] = refs[2727]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-139-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2739] = refs[2727]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-139-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2740] = refs[2727]:line {["from"]={-2.5565000049273174,-1.2968334515889484},["id"]="bilinear-sample-h-139",["layer"]=30,["stroke"]="#263447",["to"]={-2.4165000049273173,-1.2968334515889484},["width"]=2}
refs[2741] = refs[2727]:line {["from"]={-2.4865000049273176,-1.2268334515889483},["id"]="bilinear-sample-v-139",["layer"]=30,["stroke"]="#263447",["to"]={-2.4865000049273176,-1.3668334515889484},["width"]=2}
refs[2742] = refs[2727]:rectangle {["center"]={3.0375,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-139",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2743] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34ad59ff",["id"]="bilinear-computed-139",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2744] = scene:rectangle {["center"]={-0.05,0},["fill"]="#34ad59ff",["id"]="bilinear-write-139",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2745] = scene:rectangle {["center"]={3.0375,-1.4208333333333332},["fill"]="#34ad59ff",["id"]="bilinear-committed-139",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2746] = scene:group {["id"]="bilinear-read-140",["opacity"]=0}
refs[2747] = refs[2746]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-140-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2748] = refs[2746]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-140-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2749] = refs[2746]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#34ad59ff",["id"]="bilinear-weight-140-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2750] = refs[2746]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-140-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2751] = refs[2746]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-140-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2752] = refs[2746]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#39ad5cff",["id"]="bilinear-weight-140-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2753] = refs[2746]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-140-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2754] = refs[2746]:rectangle {["center"]={-2.4916666666666667,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-140-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2755] = refs[2746]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#34ad59ff",["id"]="bilinear-weight-140-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2756] = refs[2746]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-140-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2757] = refs[2746]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-140-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2758] = refs[2746]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-140-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2759] = refs[2746]:line {["from"]={-2.298166671593984,-1.2968334515889484},["id"]="bilinear-sample-h-140",["layer"]=30,["stroke"]="#263447",["to"]={-2.1581666715939845,-1.2968334515889484},["width"]=2}
refs[2760] = refs[2746]:line {["from"]={-2.2281666715939843,-1.2268334515889483},["id"]="bilinear-sample-v-140",["layer"]=30,["stroke"]="#263447",["to"]={-2.2281666715939843,-1.3668334515889484},["width"]=2}
refs[2761] = refs[2746]:rectangle {["center"]={3.2958333333333325,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-140",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2762] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36ad5aff",["id"]="bilinear-computed-140",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2763] = scene:rectangle {["center"]={-0.05,0},["fill"]="#36ad5aff",["id"]="bilinear-write-140",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2764] = scene:rectangle {["center"]={3.2958333333333325,-1.4208333333333332},["fill"]="#36ad5aff",["id"]="bilinear-committed-140",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2765] = scene:group {["id"]="bilinear-read-141",["opacity"]=0}
refs[2766] = refs[2765]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-141-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2767] = refs[2765]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-141-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2768] = refs[2765]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#39ad5cff",["id"]="bilinear-weight-141-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2769] = refs[2765]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-141-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2770] = refs[2765]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-141-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2771] = refs[2765]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3ead5fff",["id"]="bilinear-weight-141-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2772] = refs[2765]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-141-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2773] = refs[2765]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-141-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2774] = refs[2765]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-141-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2775] = refs[2765]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-141-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2776] = refs[2765]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-141-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2777] = refs[2765]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-141-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2778] = refs[2765]:line {["from"]={-2.0398332150777185,-1.2968334515889484},["id"]="bilinear-sample-h-141",["layer"]=30,["stroke"]="#263447",["to"]={-1.8998332150777184,-1.2968334515889484},["width"]=2}
refs[2779] = refs[2765]:line {["from"]={-1.9698332150777185,-1.2268334515889483},["id"]="bilinear-sample-v-141",["layer"]=30,["stroke"]="#263447",["to"]={-1.9698332150777185,-1.3668334515889484},["width"]=2}
refs[2780] = refs[2765]:rectangle {["center"]={3.5541666666666663,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-141",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2781] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39ad5cff",["id"]="bilinear-computed-141",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2782] = scene:rectangle {["center"]={-0.05,0},["fill"]="#39ad5cff",["id"]="bilinear-write-141",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2783] = scene:rectangle {["center"]={3.5541666666666663,-1.4208333333333332},["fill"]="#39ad5cff",["id"]="bilinear-committed-141",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2784] = scene:group {["id"]="bilinear-read-142",["opacity"]=0}
refs[2785] = refs[2784]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-142-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2786] = refs[2784]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-142-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2787] = refs[2784]:rectangle {["center"]={-0.2328125,0.00359375},["fill"]="#39ad5cff",["id"]="bilinear-weight-142-0",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2788] = refs[2784]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-142-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2789] = refs[2784]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-142-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2790] = refs[2784]:rectangle {["center"]={0.1271875,0.00359375},["fill"]="#3ead5fff",["id"]="bilinear-weight-142-1",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2791] = refs[2784]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-142-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2792] = refs[2784]:rectangle {["center"]={-1.975,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-142-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2793] = refs[2784]:rectangle {["center"]={-0.2328125,-0.45640625},["fill"]="#39ad5cff",["id"]="bilinear-weight-142-2",["layer"]=22,["opacity"]=1,["size"]={0.354375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2794] = refs[2784]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-142-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2795] = refs[2784]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-142-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2796] = refs[2784]:rectangle {["center"]={0.1271875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-142-3",["layer"]=22,["opacity"]=1,["size"]={0.365625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2797] = refs[2784]:line {["from"]={-1.7814998817443848,-1.2968334515889484},["id"]="bilinear-sample-h-142",["layer"]=30,["stroke"]="#263447",["to"]={-1.6414998817443847,-1.2968334515889484},["width"]=2}
refs[2798] = refs[2784]:line {["from"]={-1.7114998817443847,-1.2268334515889483},["id"]="bilinear-sample-v-142",["layer"]=30,["stroke"]="#263447",["to"]={-1.7114998817443847,-1.3668334515889484},["width"]=2}
refs[2799] = refs[2784]:rectangle {["center"]={3.8125,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-142",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2800] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3bad5dff",["id"]="bilinear-computed-142",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2801] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3bad5dff",["id"]="bilinear-write-142",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2802] = scene:rectangle {["center"]={3.8125,-1.4208333333333332},["fill"]="#3bad5dff",["id"]="bilinear-committed-142",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
refs[2803] = scene:group {["id"]="bilinear-read-143",["opacity"]=0}
refs[2804] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-143-0",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2805] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-143-0",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2806] = refs[2803]:rectangle {["center"]={-0.0528125,0.00359375},["fill"]="#3ead5fff",["id"]="bilinear-weight-143-0",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2807] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-143-1",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2808] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-143-1",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2809] = refs[2803]:rectangle {["center"]={0.3071875,0.00359375},["fill"]="#3ead5fff",["id"]="bilinear-weight-143-1",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2810] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-143-2",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2811] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-143-2",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2812] = refs[2803]:rectangle {["center"]={-0.0528125,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-143-2",["layer"]=22,["opacity"]=1,["size"]={0.714375,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2813] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-143-3",["layer"]=25,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#ffffff",["width"]=5}
refs[2814] = refs[2803]:rectangle {["center"]={-1.4583333333333337,-1.2916666666666663},["fill"]="#00000000",["id"]="bilinear-tap-ink-143-3",["layer"]=26,["opacity"]=1,["size"]={0.48666666666666664,0.48666666666666664},["stroke"]="#009d91",["width"]=2}
refs[2815] = refs[2803]:rectangle {["center"]={0.3071875,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-weight-143-3",["layer"]=22,["opacity"]=1,["size"]={0.005625,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2816] = refs[2803]:group {["id"]="bilinear-horizontal-143",["opacity"]=0}
refs[2817] = refs[2816]:rectangle {["center"]={-0.05,0.00359375},["fill"]="#3ead5fff",["id"]="bilinear-top-mix-143",["layer"]=23,["opacity"]=1,["size"]={0.72,0.9128125},["stroke"]="#00000000",["width"]=0}
refs[2818] = refs[2816]:rectangle {["center"]={-0.05,-0.45640625},["fill"]="#3ead5fff",["id"]="bilinear-bottom-mix-143",["layer"]=23,["opacity"]=1,["size"]={0.72,0.0071875},["stroke"]="#00000000",["width"]=0}
refs[2819] = refs[2803]:line {["from"]={-1.5231665484110517,-1.2968334515889484},["id"]="bilinear-sample-h-143",["layer"]=30,["stroke"]="#263447",["to"]={-1.3831665484110516,-1.2968334515889484},["width"]=2}
refs[2820] = refs[2803]:line {["from"]={-1.4531665484110516,-1.2268334515889483},["id"]="bilinear-sample-v-143",["layer"]=30,["stroke"]="#263447",["to"]={-1.4531665484110516,-1.3668334515889484},["width"]=2}
refs[2821] = refs[2803]:rectangle {["center"]={4.070833333333333,-1.4208333333333332},["fill"]="#00000000",["id"]="bilinear-destination-143",["layer"]=27,["opacity"]=1,["size"]={0.2383333333333333,0.2383333333333333},["stroke"]="#eb8c28",["width"]=3}
refs[2822] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ead5fff",["id"]="bilinear-computed-143",["layer"]=29,["opacity"]=0,["size"]={0.72,0.92},["stroke"]="#ffffff",["width"]=1}
refs[2823] = scene:rectangle {["center"]={-0.05,0},["fill"]="#3ead5fff",["id"]="bilinear-write-143",["layer"]=35,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#ffffff",["width"]=1}
refs[2824] = scene:rectangle {["center"]={4.070833333333333,-1.4208333333333332},["fill"]="#3ead5fff",["id"]="bilinear-committed-143",["layer"]=11,["opacity"]=0,["size"]={0.24833333333333332,0.24833333333333332},["stroke"]="#00000000",["width"]=0}
scene:wait(0.5)
scene:fade(refs[222],1,0.45,"linear")
scene:fade(refs[226],1,0.5,"linear")
scene:fade(refs[231],1,0.55,"linear")
scene:play({{target=refs[231],opacity=0},{target=refs[232],opacity=1}},0.04,"linear",0)
scene:shift(refs[232],{1.2791666666666663,1.4208333333333334},0.65,"ease_in_out")
scene:play({{target=refs[232],opacity=0},{target=refs[233],opacity=1}},0.01,"linear",0)
scene:fade(refs[222],0,0.01,"linear")
scene:fade(refs[234],1,0.12,"linear")
scene:fade(refs[244],1,0.12,"linear")
scene:play({{target=refs[244],opacity=0},{target=refs[245],opacity=1}},0.04,"linear",0)
scene:shift(refs[245],{1.5375,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[245],opacity=0},{target=refs[246],opacity=1}},0.01,"linear",0)
scene:fade(refs[234],0,0.01,"linear")
scene:fade(refs[247],1,0.12,"linear")
scene:fade(refs[257],1,0.12,"linear")
scene:play({{target=refs[257],opacity=0},{target=refs[258],opacity=1}},0.04,"linear",0)
scene:shift(refs[258],{1.7958333333333336,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[258],opacity=0},{target=refs[259],opacity=1}},0.01,"linear",0)
scene:fade(refs[247],0,0.01,"linear")
scene:fade(refs[260],1,0.12,"linear")
scene:fade(refs[270],1,0.12,"linear")
scene:play({{target=refs[270],opacity=0},{target=refs[271],opacity=1}},0.04,"linear",0)
scene:shift(refs[271],{2.0541666666666663,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[271],opacity=0},{target=refs[272],opacity=1}},0.01,"linear",0)
scene:fade(refs[260],0,0.01,"linear")
scene:fade(refs[273],1,0.12,"linear")
scene:fade(refs[283],1,0.12,"linear")
scene:play({{target=refs[283],opacity=0},{target=refs[284],opacity=1}},0.04,"linear",0)
scene:shift(refs[284],{2.3125,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[284],opacity=0},{target=refs[285],opacity=1}},0.01,"linear",0)
scene:fade(refs[273],0,0.01,"linear")
scene:fade(refs[286],1,0.12,"linear")
scene:fade(refs[296],1,0.12,"linear")
scene:play({{target=refs[296],opacity=0},{target=refs[297],opacity=1}},0.04,"linear",0)
scene:shift(refs[297],{2.5708333333333324,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[297],opacity=0},{target=refs[298],opacity=1}},0.01,"linear",0)
scene:fade(refs[286],0,0.01,"linear")
scene:fade(refs[299],1,0.12,"linear")
scene:fade(refs[309],1,0.12,"linear")
scene:play({{target=refs[309],opacity=0},{target=refs[310],opacity=1}},0.04,"linear",0)
scene:shift(refs[310],{2.829166666666666,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[310],opacity=0},{target=refs[311],opacity=1}},0.01,"linear",0)
scene:fade(refs[299],0,0.01,"linear")
scene:fade(refs[312],1,0.12,"linear")
scene:fade(refs[322],1,0.12,"linear")
scene:play({{target=refs[322],opacity=0},{target=refs[323],opacity=1}},0.04,"linear",0)
scene:shift(refs[323],{3.0875,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[323],opacity=0},{target=refs[324],opacity=1}},0.01,"linear",0)
scene:fade(refs[312],0,0.01,"linear")
scene:fade(refs[325],1,0.12,"linear")
scene:fade(refs[335],1,0.12,"linear")
scene:play({{target=refs[335],opacity=0},{target=refs[336],opacity=1}},0.04,"linear",0)
scene:shift(refs[336],{3.3458333333333328,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[336],opacity=0},{target=refs[337],opacity=1}},0.01,"linear",0)
scene:fade(refs[325],0,0.01,"linear")
scene:fade(refs[338],1,0.12,"linear")
scene:fade(refs[348],1,0.12,"linear")
scene:play({{target=refs[348],opacity=0},{target=refs[349],opacity=1}},0.04,"linear",0)
scene:shift(refs[349],{3.604166666666666,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[349],opacity=0},{target=refs[350],opacity=1}},0.01,"linear",0)
scene:fade(refs[338],0,0.01,"linear")
scene:fade(refs[351],1,0.12,"linear")
scene:fade(refs[361],1,0.12,"linear")
scene:play({{target=refs[361],opacity=0},{target=refs[362],opacity=1}},0.04,"linear",0)
scene:shift(refs[362],{3.8625,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[362],opacity=0},{target=refs[363],opacity=1}},0.01,"linear",0)
scene:fade(refs[351],0,0.01,"linear")
scene:fade(refs[364],1,0.12,"linear")
scene:fade(refs[374],1,0.12,"linear")
scene:play({{target=refs[374],opacity=0},{target=refs[375],opacity=1}},0.04,"linear",0)
scene:shift(refs[375],{4.120833333333333,1.4208333333333334},0.3,"ease_in_out")
scene:play({{target=refs[375],opacity=0},{target=refs[376],opacity=1}},0.01,"linear",0)
scene:fade(refs[364],0,0.01,"linear")
scene:fade(refs[377],1,0.12,"linear")
scene:fade(refs[387],1,0.12,"linear")
scene:play({{target=refs[387],opacity=0},{target=refs[388],opacity=1}},0.04,"linear",0)
scene:shift(refs[388],{1.2791666666666663,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[388],opacity=0},{target=refs[389],opacity=1}},0.01,"linear",0)
scene:fade(refs[377],0,0.01,"linear")
scene:fade(refs[390],1,0.12,"linear")
scene:fade(refs[406],1,0.12,"linear")
scene:play({{target=refs[406],opacity=0},{target=refs[407],opacity=1}},0.04,"linear",0)
scene:shift(refs[407],{1.5375,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[407],opacity=0},{target=refs[408],opacity=1}},0.01,"linear",0)
scene:fade(refs[390],0,0.01,"linear")
scene:fade(refs[409],1,0.12,"linear")
scene:fade(refs[425],1,0.12,"linear")
scene:play({{target=refs[425],opacity=0},{target=refs[426],opacity=1}},0.04,"linear",0)
scene:shift(refs[426],{1.7958333333333336,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[426],opacity=0},{target=refs[427],opacity=1}},0.01,"linear",0)
scene:fade(refs[409],0,0.01,"linear")
scene:fade(refs[428],1,0.12,"linear")
scene:fade(refs[444],1,0.12,"linear")
scene:play({{target=refs[444],opacity=0},{target=refs[445],opacity=1}},0.04,"linear",0)
scene:shift(refs[445],{2.0541666666666663,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[445],opacity=0},{target=refs[446],opacity=1}},0.01,"linear",0)
scene:fade(refs[428],0,0.01,"linear")
scene:fade(refs[447],1,0.12,"linear")
scene:fade(refs[463],1,0.12,"linear")
scene:play({{target=refs[463],opacity=0},{target=refs[464],opacity=1}},0.04,"linear",0)
scene:shift(refs[464],{2.3125,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[464],opacity=0},{target=refs[465],opacity=1}},0.01,"linear",0)
scene:fade(refs[447],0,0.01,"linear")
scene:fade(refs[466],1,0.12,"linear")
scene:fade(refs[482],1,0.12,"linear")
scene:play({{target=refs[482],opacity=0},{target=refs[483],opacity=1}},0.04,"linear",0)
scene:shift(refs[483],{2.5708333333333324,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[483],opacity=0},{target=refs[484],opacity=1}},0.01,"linear",0)
scene:fade(refs[466],0,0.01,"linear")
scene:fade(refs[485],1,0.12,"linear")
scene:fade(refs[501],1,0.12,"linear")
scene:play({{target=refs[501],opacity=0},{target=refs[502],opacity=1}},0.04,"linear",0)
scene:shift(refs[502],{2.829166666666666,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[502],opacity=0},{target=refs[503],opacity=1}},0.01,"linear",0)
scene:fade(refs[485],0,0.01,"linear")
scene:fade(refs[504],1,0.12,"linear")
scene:fade(refs[520],1,0.12,"linear")
scene:play({{target=refs[520],opacity=0},{target=refs[521],opacity=1}},0.04,"linear",0)
scene:shift(refs[521],{3.0875,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[521],opacity=0},{target=refs[522],opacity=1}},0.01,"linear",0)
scene:fade(refs[504],0,0.01,"linear")
scene:fade(refs[523],1,0.12,"linear")
scene:fade(refs[539],1,0.12,"linear")
scene:play({{target=refs[539],opacity=0},{target=refs[540],opacity=1}},0.04,"linear",0)
scene:shift(refs[540],{3.3458333333333328,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[540],opacity=0},{target=refs[541],opacity=1}},0.01,"linear",0)
scene:fade(refs[523],0,0.01,"linear")
scene:fade(refs[542],1,0.12,"linear")
scene:fade(refs[558],1,0.12,"linear")
scene:play({{target=refs[558],opacity=0},{target=refs[559],opacity=1}},0.04,"linear",0)
scene:shift(refs[559],{3.604166666666666,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[559],opacity=0},{target=refs[560],opacity=1}},0.01,"linear",0)
scene:fade(refs[542],0,0.01,"linear")
scene:fade(refs[561],1,0.12,"linear")
scene:fade(refs[577],1,0.12,"linear")
scene:play({{target=refs[577],opacity=0},{target=refs[578],opacity=1}},0.04,"linear",0)
scene:shift(refs[578],{3.8625,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[578],opacity=0},{target=refs[579],opacity=1}},0.01,"linear",0)
scene:fade(refs[561],0,0.01,"linear")
scene:fade(refs[580],1,0.12,"linear")
scene:fade(refs[596],1,0.12,"linear")
scene:play({{target=refs[596],opacity=0},{target=refs[597],opacity=1}},0.04,"linear",0)
scene:shift(refs[597],{4.120833333333333,1.1625},0.3,"ease_in_out")
scene:play({{target=refs[597],opacity=0},{target=refs[598],opacity=1}},0.01,"linear",0)
scene:fade(refs[580],0,0.01,"linear")
scene:fade(refs[599],1,0.12,"linear")
scene:fade(refs[609],1,0.12,"linear")
scene:play({{target=refs[609],opacity=0},{target=refs[610],opacity=1}},0.04,"linear",0)
scene:shift(refs[610],{1.2791666666666663,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[610],opacity=0},{target=refs[611],opacity=1}},0.01,"linear",0)
scene:fade(refs[599],0,0.01,"linear")
scene:fade(refs[612],1,0.12,"linear")
scene:fade(refs[628],1,0.12,"linear")
scene:play({{target=refs[628],opacity=0},{target=refs[629],opacity=1}},0.04,"linear",0)
scene:shift(refs[629],{1.5375,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[629],opacity=0},{target=refs[630],opacity=1}},0.01,"linear",0)
scene:fade(refs[612],0,0.01,"linear")
scene:fade(refs[631],1,0.12,"linear")
scene:fade(refs[647],1,0.12,"linear")
scene:play({{target=refs[647],opacity=0},{target=refs[648],opacity=1}},0.04,"linear",0)
scene:shift(refs[648],{1.7958333333333336,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[648],opacity=0},{target=refs[649],opacity=1}},0.01,"linear",0)
scene:fade(refs[631],0,0.01,"linear")
scene:fade(refs[650],1,0.12,"linear")
scene:fade(refs[666],1,0.12,"linear")
scene:play({{target=refs[666],opacity=0},{target=refs[667],opacity=1}},0.04,"linear",0)
scene:shift(refs[667],{2.0541666666666663,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[667],opacity=0},{target=refs[668],opacity=1}},0.01,"linear",0)
scene:fade(refs[650],0,0.01,"linear")
scene:fade(refs[669],1,0.12,"linear")
scene:fade(refs[685],1,0.12,"linear")
scene:play({{target=refs[685],opacity=0},{target=refs[686],opacity=1}},0.04,"linear",0)
scene:shift(refs[686],{2.3125,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[686],opacity=0},{target=refs[687],opacity=1}},0.01,"linear",0)
scene:fade(refs[669],0,0.01,"linear")
scene:fade(refs[688],1,0.12,"linear")
scene:fade(refs[704],1,0.12,"linear")
scene:play({{target=refs[704],opacity=0},{target=refs[705],opacity=1}},0.04,"linear",0)
scene:shift(refs[705],{2.5708333333333324,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[705],opacity=0},{target=refs[706],opacity=1}},0.01,"linear",0)
scene:fade(refs[688],0,0.01,"linear")
scene:fade(refs[707],1,0.12,"linear")
scene:fade(refs[723],1,0.12,"linear")
scene:play({{target=refs[723],opacity=0},{target=refs[724],opacity=1}},0.04,"linear",0)
scene:shift(refs[724],{2.829166666666666,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[724],opacity=0},{target=refs[725],opacity=1}},0.01,"linear",0)
scene:fade(refs[707],0,0.01,"linear")
scene:fade(refs[726],1,0.12,"linear")
scene:fade(refs[742],1,0.12,"linear")
scene:play({{target=refs[742],opacity=0},{target=refs[743],opacity=1}},0.04,"linear",0)
scene:shift(refs[743],{3.0875,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[743],opacity=0},{target=refs[744],opacity=1}},0.01,"linear",0)
scene:fade(refs[726],0,0.01,"linear")
scene:fade(refs[745],1,0.45,"linear")
scene:wait(0.65)
scene:fade(refs[758],1,0.5,"linear")
scene:fade(refs[764],1,0.55,"linear")
scene:play({{target=refs[764],opacity=0},{target=refs[765],opacity=1}},0.04,"linear",0)
scene:shift(refs[765],{3.3458333333333328,0.9041666666666669},0.65,"ease_in_out")
scene:play({{target=refs[765],opacity=0},{target=refs[766],opacity=1}},0.01,"linear",0)
scene:fade(refs[745],0,0.01,"linear")
scene:fade(refs[767],1,0.12,"linear")
scene:fade(refs[783],1,0.12,"linear")
scene:play({{target=refs[783],opacity=0},{target=refs[784],opacity=1}},0.04,"linear",0)
scene:shift(refs[784],{3.604166666666666,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[784],opacity=0},{target=refs[785],opacity=1}},0.01,"linear",0)
scene:fade(refs[767],0,0.01,"linear")
scene:fade(refs[786],1,0.12,"linear")
scene:fade(refs[802],1,0.12,"linear")
scene:play({{target=refs[802],opacity=0},{target=refs[803],opacity=1}},0.04,"linear",0)
scene:shift(refs[803],{3.8625,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[803],opacity=0},{target=refs[804],opacity=1}},0.01,"linear",0)
scene:fade(refs[786],0,0.01,"linear")
scene:fade(refs[805],1,0.12,"linear")
scene:fade(refs[821],1,0.12,"linear")
scene:play({{target=refs[821],opacity=0},{target=refs[822],opacity=1}},0.04,"linear",0)
scene:shift(refs[822],{4.120833333333333,0.9041666666666669},0.3,"ease_in_out")
scene:play({{target=refs[822],opacity=0},{target=refs[823],opacity=1}},0.01,"linear",0)
scene:fade(refs[805],0,0.01,"linear")
scene:fade(refs[824],1,0.12,"linear")
scene:fade(refs[834],1,0.12,"linear")
scene:play({{target=refs[834],opacity=0},{target=refs[835],opacity=1}},0.04,"linear",0)
scene:shift(refs[835],{1.2791666666666663,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[835],opacity=0},{target=refs[836],opacity=1}},0.01,"linear",0)
scene:fade(refs[824],0,0.01,"linear")
scene:fade(refs[837],1,0.12,"linear")
scene:fade(refs[853],1,0.12,"linear")
scene:play({{target=refs[853],opacity=0},{target=refs[854],opacity=1}},0.04,"linear",0)
scene:shift(refs[854],{1.5375,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[854],opacity=0},{target=refs[855],opacity=1}},0.01,"linear",0)
scene:fade(refs[837],0,0.01,"linear")
scene:fade(refs[856],1,0.12,"linear")
scene:fade(refs[872],1,0.12,"linear")
scene:play({{target=refs[872],opacity=0},{target=refs[873],opacity=1}},0.04,"linear",0)
scene:shift(refs[873],{1.7958333333333336,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[873],opacity=0},{target=refs[874],opacity=1}},0.01,"linear",0)
scene:fade(refs[856],0,0.01,"linear")
scene:fade(refs[875],1,0.12,"linear")
scene:fade(refs[891],1,0.12,"linear")
scene:play({{target=refs[891],opacity=0},{target=refs[892],opacity=1}},0.04,"linear",0)
scene:shift(refs[892],{2.0541666666666663,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[892],opacity=0},{target=refs[893],opacity=1}},0.01,"linear",0)
scene:fade(refs[875],0,0.01,"linear")
scene:fade(refs[894],1,0.12,"linear")
scene:fade(refs[910],1,0.12,"linear")
scene:play({{target=refs[910],opacity=0},{target=refs[911],opacity=1}},0.04,"linear",0)
scene:shift(refs[911],{2.3125,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[911],opacity=0},{target=refs[912],opacity=1}},0.01,"linear",0)
scene:fade(refs[894],0,0.01,"linear")
scene:fade(refs[913],1,0.12,"linear")
scene:fade(refs[929],1,0.12,"linear")
scene:play({{target=refs[929],opacity=0},{target=refs[930],opacity=1}},0.04,"linear",0)
scene:shift(refs[930],{2.5708333333333324,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[930],opacity=0},{target=refs[931],opacity=1}},0.01,"linear",0)
scene:fade(refs[913],0,0.01,"linear")
scene:fade(refs[932],1,0.12,"linear")
scene:fade(refs[948],1,0.12,"linear")
scene:play({{target=refs[948],opacity=0},{target=refs[949],opacity=1}},0.04,"linear",0)
scene:shift(refs[949],{2.829166666666666,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[949],opacity=0},{target=refs[950],opacity=1}},0.01,"linear",0)
scene:fade(refs[932],0,0.01,"linear")
scene:fade(refs[951],1,0.12,"linear")
scene:fade(refs[967],1,0.12,"linear")
scene:play({{target=refs[967],opacity=0},{target=refs[968],opacity=1}},0.04,"linear",0)
scene:shift(refs[968],{3.0875,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[968],opacity=0},{target=refs[969],opacity=1}},0.01,"linear",0)
scene:fade(refs[951],0,0.01,"linear")
scene:fade(refs[970],1,0.12,"linear")
scene:fade(refs[986],1,0.12,"linear")
scene:play({{target=refs[986],opacity=0},{target=refs[987],opacity=1}},0.04,"linear",0)
scene:shift(refs[987],{3.3458333333333328,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[987],opacity=0},{target=refs[988],opacity=1}},0.01,"linear",0)
scene:fade(refs[970],0,0.01,"linear")
scene:fade(refs[989],1,0.12,"linear")
scene:fade(refs[1005],1,0.12,"linear")
scene:play({{target=refs[1005],opacity=0},{target=refs[1006],opacity=1}},0.04,"linear",0)
scene:shift(refs[1006],{3.604166666666666,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[1006],opacity=0},{target=refs[1007],opacity=1}},0.01,"linear",0)
scene:fade(refs[989],0,0.01,"linear")
scene:fade(refs[1008],1,0.12,"linear")
scene:fade(refs[1024],1,0.12,"linear")
scene:play({{target=refs[1024],opacity=0},{target=refs[1025],opacity=1}},0.04,"linear",0)
scene:shift(refs[1025],{3.8625,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[1025],opacity=0},{target=refs[1026],opacity=1}},0.01,"linear",0)
scene:fade(refs[1008],0,0.01,"linear")
scene:fade(refs[1027],1,0.12,"linear")
scene:fade(refs[1043],1,0.12,"linear")
scene:play({{target=refs[1043],opacity=0},{target=refs[1044],opacity=1}},0.04,"linear",0)
scene:shift(refs[1044],{4.120833333333333,0.6458333333333335},0.3,"ease_in_out")
scene:play({{target=refs[1044],opacity=0},{target=refs[1045],opacity=1}},0.01,"linear",0)
scene:fade(refs[1027],0,0.01,"linear")
scene:fade(refs[1046],1,0.12,"linear")
scene:fade(refs[1056],1,0.12,"linear")
scene:play({{target=refs[1056],opacity=0},{target=refs[1057],opacity=1}},0.04,"linear",0)
scene:shift(refs[1057],{1.2791666666666663,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1057],opacity=0},{target=refs[1058],opacity=1}},0.01,"linear",0)
scene:fade(refs[1046],0,0.01,"linear")
scene:fade(refs[1059],1,0.12,"linear")
scene:fade(refs[1075],1,0.12,"linear")
scene:play({{target=refs[1075],opacity=0},{target=refs[1076],opacity=1}},0.04,"linear",0)
scene:shift(refs[1076],{1.5375,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1076],opacity=0},{target=refs[1077],opacity=1}},0.01,"linear",0)
scene:fade(refs[1059],0,0.01,"linear")
scene:fade(refs[1078],1,0.12,"linear")
scene:fade(refs[1094],1,0.12,"linear")
scene:play({{target=refs[1094],opacity=0},{target=refs[1095],opacity=1}},0.04,"linear",0)
scene:shift(refs[1095],{1.7958333333333336,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1095],opacity=0},{target=refs[1096],opacity=1}},0.01,"linear",0)
scene:fade(refs[1078],0,0.01,"linear")
scene:fade(refs[1097],1,0.12,"linear")
scene:fade(refs[1113],1,0.12,"linear")
scene:play({{target=refs[1113],opacity=0},{target=refs[1114],opacity=1}},0.04,"linear",0)
scene:shift(refs[1114],{2.0541666666666663,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1114],opacity=0},{target=refs[1115],opacity=1}},0.01,"linear",0)
scene:fade(refs[1097],0,0.01,"linear")
scene:fade(refs[1116],1,0.12,"linear")
scene:fade(refs[1132],1,0.12,"linear")
scene:play({{target=refs[1132],opacity=0},{target=refs[1133],opacity=1}},0.04,"linear",0)
scene:shift(refs[1133],{2.3125,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1133],opacity=0},{target=refs[1134],opacity=1}},0.01,"linear",0)
scene:fade(refs[1116],0,0.01,"linear")
scene:fade(refs[1135],1,0.12,"linear")
scene:fade(refs[1151],1,0.12,"linear")
scene:play({{target=refs[1151],opacity=0},{target=refs[1152],opacity=1}},0.04,"linear",0)
scene:shift(refs[1152],{2.5708333333333324,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1152],opacity=0},{target=refs[1153],opacity=1}},0.01,"linear",0)
scene:fade(refs[1135],0,0.01,"linear")
scene:fade(refs[1154],1,0.12,"linear")
scene:fade(refs[1170],1,0.12,"linear")
scene:play({{target=refs[1170],opacity=0},{target=refs[1171],opacity=1}},0.04,"linear",0)
scene:shift(refs[1171],{2.829166666666666,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1171],opacity=0},{target=refs[1172],opacity=1}},0.01,"linear",0)
scene:fade(refs[1154],0,0.01,"linear")
scene:fade(refs[1173],1,0.12,"linear")
scene:fade(refs[1189],1,0.12,"linear")
scene:play({{target=refs[1189],opacity=0},{target=refs[1190],opacity=1}},0.04,"linear",0)
scene:shift(refs[1190],{3.0875,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1190],opacity=0},{target=refs[1191],opacity=1}},0.01,"linear",0)
scene:fade(refs[1173],0,0.01,"linear")
scene:fade(refs[1192],1,0.12,"linear")
scene:fade(refs[1208],1,0.12,"linear")
scene:play({{target=refs[1208],opacity=0},{target=refs[1209],opacity=1}},0.04,"linear",0)
scene:shift(refs[1209],{3.3458333333333328,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1209],opacity=0},{target=refs[1210],opacity=1}},0.01,"linear",0)
scene:fade(refs[1192],0,0.01,"linear")
scene:fade(refs[1211],1,0.12,"linear")
scene:fade(refs[1227],1,0.12,"linear")
scene:play({{target=refs[1227],opacity=0},{target=refs[1228],opacity=1}},0.04,"linear",0)
scene:shift(refs[1228],{3.604166666666666,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1228],opacity=0},{target=refs[1229],opacity=1}},0.01,"linear",0)
scene:fade(refs[1211],0,0.01,"linear")
scene:fade(refs[1230],1,0.12,"linear")
scene:fade(refs[1246],1,0.12,"linear")
scene:play({{target=refs[1246],opacity=0},{target=refs[1247],opacity=1}},0.04,"linear",0)
scene:shift(refs[1247],{3.8625,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1247],opacity=0},{target=refs[1248],opacity=1}},0.01,"linear",0)
scene:fade(refs[1230],0,0.01,"linear")
scene:fade(refs[1249],1,0.12,"linear")
scene:fade(refs[1265],1,0.12,"linear")
scene:play({{target=refs[1265],opacity=0},{target=refs[1266],opacity=1}},0.04,"linear",0)
scene:shift(refs[1266],{4.120833333333333,0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1266],opacity=0},{target=refs[1267],opacity=1}},0.01,"linear",0)
scene:fade(refs[1249],0,0.01,"linear")
scene:fade(refs[1268],1,0.12,"linear")
scene:fade(refs[1278],1,0.12,"linear")
scene:play({{target=refs[1278],opacity=0},{target=refs[1279],opacity=1}},0.04,"linear",0)
scene:shift(refs[1279],{1.2791666666666663,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1279],opacity=0},{target=refs[1280],opacity=1}},0.01,"linear",0)
scene:fade(refs[1268],0,0.01,"linear")
scene:fade(refs[1281],1,0.12,"linear")
scene:fade(refs[1297],1,0.12,"linear")
scene:play({{target=refs[1297],opacity=0},{target=refs[1298],opacity=1}},0.04,"linear",0)
scene:shift(refs[1298],{1.5375,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1298],opacity=0},{target=refs[1299],opacity=1}},0.01,"linear",0)
scene:fade(refs[1281],0,0.01,"linear")
scene:fade(refs[1300],1,0.12,"linear")
scene:fade(refs[1316],1,0.12,"linear")
scene:play({{target=refs[1316],opacity=0},{target=refs[1317],opacity=1}},0.04,"linear",0)
scene:shift(refs[1317],{1.7958333333333336,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1317],opacity=0},{target=refs[1318],opacity=1}},0.01,"linear",0)
scene:fade(refs[1300],0,0.01,"linear")
scene:fade(refs[1319],1,0.12,"linear")
scene:fade(refs[1335],1,0.12,"linear")
scene:play({{target=refs[1335],opacity=0},{target=refs[1336],opacity=1}},0.04,"linear",0)
scene:shift(refs[1336],{2.0541666666666663,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1336],opacity=0},{target=refs[1337],opacity=1}},0.01,"linear",0)
scene:fade(refs[1319],0,0.01,"linear")
scene:fade(refs[1338],1,0.12,"linear")
scene:fade(refs[1354],1,0.12,"linear")
scene:play({{target=refs[1354],opacity=0},{target=refs[1355],opacity=1}},0.04,"linear",0)
scene:shift(refs[1355],{2.3125,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1355],opacity=0},{target=refs[1356],opacity=1}},0.01,"linear",0)
scene:fade(refs[1338],0,0.01,"linear")
scene:fade(refs[1357],1,0.12,"linear")
scene:fade(refs[1373],1,0.12,"linear")
scene:play({{target=refs[1373],opacity=0},{target=refs[1374],opacity=1}},0.04,"linear",0)
scene:shift(refs[1374],{2.5708333333333324,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1374],opacity=0},{target=refs[1375],opacity=1}},0.01,"linear",0)
scene:fade(refs[1357],0,0.01,"linear")
scene:fade(refs[1376],1,0.12,"linear")
scene:fade(refs[1392],1,0.12,"linear")
scene:play({{target=refs[1392],opacity=0},{target=refs[1393],opacity=1}},0.04,"linear",0)
scene:shift(refs[1393],{2.829166666666666,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1393],opacity=0},{target=refs[1394],opacity=1}},0.01,"linear",0)
scene:fade(refs[1376],0,0.01,"linear")
scene:fade(refs[1395],1,0.12,"linear")
scene:fade(refs[1411],1,0.12,"linear")
scene:play({{target=refs[1411],opacity=0},{target=refs[1412],opacity=1}},0.04,"linear",0)
scene:shift(refs[1412],{3.0875,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1412],opacity=0},{target=refs[1413],opacity=1}},0.01,"linear",0)
scene:fade(refs[1395],0,0.01,"linear")
scene:fade(refs[1414],1,0.12,"linear")
scene:fade(refs[1430],1,0.12,"linear")
scene:play({{target=refs[1430],opacity=0},{target=refs[1431],opacity=1}},0.04,"linear",0)
scene:shift(refs[1431],{3.3458333333333328,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1431],opacity=0},{target=refs[1432],opacity=1}},0.01,"linear",0)
scene:fade(refs[1414],0,0.01,"linear")
scene:fade(refs[1433],1,0.12,"linear")
scene:fade(refs[1449],1,0.12,"linear")
scene:play({{target=refs[1449],opacity=0},{target=refs[1450],opacity=1}},0.04,"linear",0)
scene:shift(refs[1450],{3.604166666666666,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1450],opacity=0},{target=refs[1451],opacity=1}},0.01,"linear",0)
scene:fade(refs[1433],0,0.01,"linear")
scene:fade(refs[1452],1,0.12,"linear")
scene:fade(refs[1468],1,0.12,"linear")
scene:play({{target=refs[1468],opacity=0},{target=refs[1469],opacity=1}},0.04,"linear",0)
scene:shift(refs[1469],{3.8625,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1469],opacity=0},{target=refs[1470],opacity=1}},0.01,"linear",0)
scene:fade(refs[1452],0,0.01,"linear")
scene:fade(refs[1471],1,0.12,"linear")
scene:fade(refs[1487],1,0.12,"linear")
scene:play({{target=refs[1487],opacity=0},{target=refs[1488],opacity=1}},0.04,"linear",0)
scene:shift(refs[1488],{4.120833333333333,0.12916666666666685},0.3,"ease_in_out")
scene:play({{target=refs[1488],opacity=0},{target=refs[1489],opacity=1}},0.01,"linear",0)
scene:fade(refs[1471],0,0.01,"linear")
scene:fade(refs[1490],1,0.12,"linear")
scene:fade(refs[1500],1,0.12,"linear")
scene:play({{target=refs[1500],opacity=0},{target=refs[1501],opacity=1}},0.04,"linear",0)
scene:shift(refs[1501],{1.2791666666666663,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1501],opacity=0},{target=refs[1502],opacity=1}},0.01,"linear",0)
scene:fade(refs[1490],0,0.01,"linear")
scene:fade(refs[1503],1,0.12,"linear")
scene:fade(refs[1519],1,0.12,"linear")
scene:play({{target=refs[1519],opacity=0},{target=refs[1520],opacity=1}},0.04,"linear",0)
scene:shift(refs[1520],{1.5375,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1520],opacity=0},{target=refs[1521],opacity=1}},0.01,"linear",0)
scene:fade(refs[1503],0,0.01,"linear")
scene:fade(refs[1522],1,0.12,"linear")
scene:fade(refs[1538],1,0.12,"linear")
scene:play({{target=refs[1538],opacity=0},{target=refs[1539],opacity=1}},0.04,"linear",0)
scene:shift(refs[1539],{1.7958333333333336,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1539],opacity=0},{target=refs[1540],opacity=1}},0.01,"linear",0)
scene:fade(refs[1522],0,0.01,"linear")
scene:fade(refs[1541],1,0.12,"linear")
scene:fade(refs[1557],1,0.12,"linear")
scene:play({{target=refs[1557],opacity=0},{target=refs[1558],opacity=1}},0.04,"linear",0)
scene:shift(refs[1558],{2.0541666666666663,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1558],opacity=0},{target=refs[1559],opacity=1}},0.01,"linear",0)
scene:fade(refs[1541],0,0.01,"linear")
scene:fade(refs[1560],1,0.12,"linear")
scene:fade(refs[1576],1,0.12,"linear")
scene:play({{target=refs[1576],opacity=0},{target=refs[1577],opacity=1}},0.04,"linear",0)
scene:shift(refs[1577],{2.3125,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1577],opacity=0},{target=refs[1578],opacity=1}},0.01,"linear",0)
scene:fade(refs[1560],0,0.01,"linear")
scene:fade(refs[1579],1,0.12,"linear")
scene:fade(refs[1595],1,0.12,"linear")
scene:play({{target=refs[1595],opacity=0},{target=refs[1596],opacity=1}},0.04,"linear",0)
scene:shift(refs[1596],{2.5708333333333324,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1596],opacity=0},{target=refs[1597],opacity=1}},0.01,"linear",0)
scene:fade(refs[1579],0,0.01,"linear")
scene:fade(refs[1598],1,0.12,"linear")
scene:fade(refs[1614],1,0.12,"linear")
scene:play({{target=refs[1614],opacity=0},{target=refs[1615],opacity=1}},0.04,"linear",0)
scene:shift(refs[1615],{2.829166666666666,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1615],opacity=0},{target=refs[1616],opacity=1}},0.01,"linear",0)
scene:fade(refs[1598],0,0.01,"linear")
scene:fade(refs[1617],1,0.12,"linear")
scene:fade(refs[1633],1,0.12,"linear")
scene:play({{target=refs[1633],opacity=0},{target=refs[1634],opacity=1}},0.04,"linear",0)
scene:shift(refs[1634],{3.0875,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1634],opacity=0},{target=refs[1635],opacity=1}},0.01,"linear",0)
scene:fade(refs[1617],0,0.01,"linear")
scene:fade(refs[1636],1,0.12,"linear")
scene:fade(refs[1652],1,0.12,"linear")
scene:play({{target=refs[1652],opacity=0},{target=refs[1653],opacity=1}},0.04,"linear",0)
scene:shift(refs[1653],{3.3458333333333328,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1653],opacity=0},{target=refs[1654],opacity=1}},0.01,"linear",0)
scene:fade(refs[1636],0,0.01,"linear")
scene:fade(refs[1655],1,0.12,"linear")
scene:fade(refs[1671],1,0.12,"linear")
scene:play({{target=refs[1671],opacity=0},{target=refs[1672],opacity=1}},0.04,"linear",0)
scene:shift(refs[1672],{3.604166666666666,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1672],opacity=0},{target=refs[1673],opacity=1}},0.01,"linear",0)
scene:fade(refs[1655],0,0.01,"linear")
scene:fade(refs[1674],1,0.12,"linear")
scene:fade(refs[1690],1,0.12,"linear")
scene:play({{target=refs[1690],opacity=0},{target=refs[1691],opacity=1}},0.04,"linear",0)
scene:shift(refs[1691],{3.8625,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1691],opacity=0},{target=refs[1692],opacity=1}},0.01,"linear",0)
scene:fade(refs[1674],0,0.01,"linear")
scene:fade(refs[1693],1,0.12,"linear")
scene:fade(refs[1709],1,0.12,"linear")
scene:play({{target=refs[1709],opacity=0},{target=refs[1710],opacity=1}},0.04,"linear",0)
scene:shift(refs[1710],{4.120833333333333,-0.1291666666666663},0.3,"ease_in_out")
scene:play({{target=refs[1710],opacity=0},{target=refs[1711],opacity=1}},0.01,"linear",0)
scene:fade(refs[1693],0,0.01,"linear")
scene:fade(refs[1712],1,0.12,"linear")
scene:fade(refs[1722],1,0.12,"linear")
scene:play({{target=refs[1722],opacity=0},{target=refs[1723],opacity=1}},0.04,"linear",0)
scene:shift(refs[1723],{1.2791666666666663,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1723],opacity=0},{target=refs[1724],opacity=1}},0.01,"linear",0)
scene:fade(refs[1712],0,0.01,"linear")
scene:fade(refs[1725],1,0.12,"linear")
scene:fade(refs[1741],1,0.12,"linear")
scene:play({{target=refs[1741],opacity=0},{target=refs[1742],opacity=1}},0.04,"linear",0)
scene:shift(refs[1742],{1.5375,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1742],opacity=0},{target=refs[1743],opacity=1}},0.01,"linear",0)
scene:fade(refs[1725],0,0.01,"linear")
scene:fade(refs[1744],1,0.12,"linear")
scene:fade(refs[1760],1,0.12,"linear")
scene:play({{target=refs[1760],opacity=0},{target=refs[1761],opacity=1}},0.04,"linear",0)
scene:shift(refs[1761],{1.7958333333333336,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1761],opacity=0},{target=refs[1762],opacity=1}},0.01,"linear",0)
scene:fade(refs[1744],0,0.01,"linear")
scene:fade(refs[1763],1,0.12,"linear")
scene:fade(refs[1779],1,0.12,"linear")
scene:play({{target=refs[1779],opacity=0},{target=refs[1780],opacity=1}},0.04,"linear",0)
scene:shift(refs[1780],{2.0541666666666663,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1780],opacity=0},{target=refs[1781],opacity=1}},0.01,"linear",0)
scene:fade(refs[1763],0,0.01,"linear")
scene:fade(refs[1782],1,0.12,"linear")
scene:fade(refs[1798],1,0.12,"linear")
scene:play({{target=refs[1798],opacity=0},{target=refs[1799],opacity=1}},0.04,"linear",0)
scene:shift(refs[1799],{2.3125,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1799],opacity=0},{target=refs[1800],opacity=1}},0.01,"linear",0)
scene:fade(refs[1782],0,0.01,"linear")
scene:fade(refs[1801],1,0.12,"linear")
scene:fade(refs[1817],1,0.12,"linear")
scene:play({{target=refs[1817],opacity=0},{target=refs[1818],opacity=1}},0.04,"linear",0)
scene:shift(refs[1818],{2.5708333333333324,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1818],opacity=0},{target=refs[1819],opacity=1}},0.01,"linear",0)
scene:fade(refs[1801],0,0.01,"linear")
scene:fade(refs[1820],1,0.12,"linear")
scene:fade(refs[1836],1,0.12,"linear")
scene:play({{target=refs[1836],opacity=0},{target=refs[1837],opacity=1}},0.04,"linear",0)
scene:shift(refs[1837],{2.829166666666666,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1837],opacity=0},{target=refs[1838],opacity=1}},0.01,"linear",0)
scene:fade(refs[1820],0,0.01,"linear")
scene:fade(refs[1839],1,0.12,"linear")
scene:fade(refs[1855],1,0.12,"linear")
scene:play({{target=refs[1855],opacity=0},{target=refs[1856],opacity=1}},0.04,"linear",0)
scene:shift(refs[1856],{3.0875,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1856],opacity=0},{target=refs[1857],opacity=1}},0.01,"linear",0)
scene:fade(refs[1839],0,0.01,"linear")
scene:fade(refs[1858],1,0.12,"linear")
scene:fade(refs[1874],1,0.12,"linear")
scene:play({{target=refs[1874],opacity=0},{target=refs[1875],opacity=1}},0.04,"linear",0)
scene:shift(refs[1875],{3.3458333333333328,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1875],opacity=0},{target=refs[1876],opacity=1}},0.01,"linear",0)
scene:fade(refs[1858],0,0.01,"linear")
scene:fade(refs[1877],1,0.12,"linear")
scene:fade(refs[1893],1,0.12,"linear")
scene:play({{target=refs[1893],opacity=0},{target=refs[1894],opacity=1}},0.04,"linear",0)
scene:shift(refs[1894],{3.604166666666666,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1894],opacity=0},{target=refs[1895],opacity=1}},0.01,"linear",0)
scene:fade(refs[1877],0,0.01,"linear")
scene:fade(refs[1896],1,0.12,"linear")
scene:fade(refs[1912],1,0.12,"linear")
scene:play({{target=refs[1912],opacity=0},{target=refs[1913],opacity=1}},0.04,"linear",0)
scene:shift(refs[1913],{3.8625,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1913],opacity=0},{target=refs[1914],opacity=1}},0.01,"linear",0)
scene:fade(refs[1896],0,0.01,"linear")
scene:fade(refs[1915],1,0.12,"linear")
scene:fade(refs[1931],1,0.12,"linear")
scene:play({{target=refs[1931],opacity=0},{target=refs[1932],opacity=1}},0.04,"linear",0)
scene:shift(refs[1932],{4.120833333333333,-0.3875},0.3,"ease_in_out")
scene:play({{target=refs[1932],opacity=0},{target=refs[1933],opacity=1}},0.01,"linear",0)
scene:fade(refs[1915],0,0.01,"linear")
scene:fade(refs[1934],1,0.12,"linear")
scene:fade(refs[1944],1,0.12,"linear")
scene:play({{target=refs[1944],opacity=0},{target=refs[1945],opacity=1}},0.04,"linear",0)
scene:shift(refs[1945],{1.2791666666666663,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[1945],opacity=0},{target=refs[1946],opacity=1}},0.01,"linear",0)
scene:fade(refs[1934],0,0.01,"linear")
scene:fade(refs[1947],1,0.12,"linear")
scene:fade(refs[1963],1,0.12,"linear")
scene:play({{target=refs[1963],opacity=0},{target=refs[1964],opacity=1}},0.04,"linear",0)
scene:shift(refs[1964],{1.5375,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[1964],opacity=0},{target=refs[1965],opacity=1}},0.01,"linear",0)
scene:fade(refs[1947],0,0.01,"linear")
scene:fade(refs[1966],1,0.12,"linear")
scene:fade(refs[1982],1,0.12,"linear")
scene:play({{target=refs[1982],opacity=0},{target=refs[1983],opacity=1}},0.04,"linear",0)
scene:shift(refs[1983],{1.7958333333333336,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[1983],opacity=0},{target=refs[1984],opacity=1}},0.01,"linear",0)
scene:fade(refs[1966],0,0.01,"linear")
scene:fade(refs[1985],1,0.12,"linear")
scene:fade(refs[2001],1,0.12,"linear")
scene:play({{target=refs[2001],opacity=0},{target=refs[2002],opacity=1}},0.04,"linear",0)
scene:shift(refs[2002],{2.0541666666666663,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2002],opacity=0},{target=refs[2003],opacity=1}},0.01,"linear",0)
scene:fade(refs[1985],0,0.01,"linear")
scene:fade(refs[2004],1,0.12,"linear")
scene:fade(refs[2020],1,0.12,"linear")
scene:play({{target=refs[2020],opacity=0},{target=refs[2021],opacity=1}},0.04,"linear",0)
scene:shift(refs[2021],{2.3125,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2021],opacity=0},{target=refs[2022],opacity=1}},0.01,"linear",0)
scene:fade(refs[2004],0,0.01,"linear")
scene:fade(refs[2023],1,0.12,"linear")
scene:fade(refs[2039],1,0.12,"linear")
scene:play({{target=refs[2039],opacity=0},{target=refs[2040],opacity=1}},0.04,"linear",0)
scene:shift(refs[2040],{2.5708333333333324,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2040],opacity=0},{target=refs[2041],opacity=1}},0.01,"linear",0)
scene:fade(refs[2023],0,0.01,"linear")
scene:fade(refs[2042],1,0.12,"linear")
scene:fade(refs[2058],1,0.12,"linear")
scene:play({{target=refs[2058],opacity=0},{target=refs[2059],opacity=1}},0.04,"linear",0)
scene:shift(refs[2059],{2.829166666666666,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2059],opacity=0},{target=refs[2060],opacity=1}},0.01,"linear",0)
scene:fade(refs[2042],0,0.01,"linear")
scene:fade(refs[2061],1,0.12,"linear")
scene:fade(refs[2077],1,0.12,"linear")
scene:play({{target=refs[2077],opacity=0},{target=refs[2078],opacity=1}},0.04,"linear",0)
scene:shift(refs[2078],{3.0875,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2078],opacity=0},{target=refs[2079],opacity=1}},0.01,"linear",0)
scene:fade(refs[2061],0,0.01,"linear")
scene:fade(refs[2080],1,0.12,"linear")
scene:fade(refs[2096],1,0.12,"linear")
scene:play({{target=refs[2096],opacity=0},{target=refs[2097],opacity=1}},0.04,"linear",0)
scene:shift(refs[2097],{3.3458333333333328,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2097],opacity=0},{target=refs[2098],opacity=1}},0.01,"linear",0)
scene:fade(refs[2080],0,0.01,"linear")
scene:fade(refs[2099],1,0.12,"linear")
scene:fade(refs[2115],1,0.12,"linear")
scene:play({{target=refs[2115],opacity=0},{target=refs[2116],opacity=1}},0.04,"linear",0)
scene:shift(refs[2116],{3.604166666666666,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2116],opacity=0},{target=refs[2117],opacity=1}},0.01,"linear",0)
scene:fade(refs[2099],0,0.01,"linear")
scene:fade(refs[2118],1,0.12,"linear")
scene:fade(refs[2134],1,0.12,"linear")
scene:play({{target=refs[2134],opacity=0},{target=refs[2135],opacity=1}},0.04,"linear",0)
scene:shift(refs[2135],{3.8625,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2135],opacity=0},{target=refs[2136],opacity=1}},0.01,"linear",0)
scene:fade(refs[2118],0,0.01,"linear")
scene:fade(refs[2137],1,0.12,"linear")
scene:fade(refs[2153],1,0.12,"linear")
scene:play({{target=refs[2153],opacity=0},{target=refs[2154],opacity=1}},0.04,"linear",0)
scene:shift(refs[2154],{4.120833333333333,-0.6458333333333331},0.3,"ease_in_out")
scene:play({{target=refs[2154],opacity=0},{target=refs[2155],opacity=1}},0.01,"linear",0)
scene:fade(refs[2137],0,0.01,"linear")
scene:fade(refs[2156],1,0.12,"linear")
scene:fade(refs[2166],1,0.12,"linear")
scene:play({{target=refs[2166],opacity=0},{target=refs[2167],opacity=1}},0.04,"linear",0)
scene:shift(refs[2167],{1.2791666666666663,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2167],opacity=0},{target=refs[2168],opacity=1}},0.01,"linear",0)
scene:fade(refs[2156],0,0.01,"linear")
scene:fade(refs[2169],1,0.12,"linear")
scene:fade(refs[2185],1,0.12,"linear")
scene:play({{target=refs[2185],opacity=0},{target=refs[2186],opacity=1}},0.04,"linear",0)
scene:shift(refs[2186],{1.5375,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2186],opacity=0},{target=refs[2187],opacity=1}},0.01,"linear",0)
scene:fade(refs[2169],0,0.01,"linear")
scene:fade(refs[2188],1,0.12,"linear")
scene:fade(refs[2204],1,0.12,"linear")
scene:play({{target=refs[2204],opacity=0},{target=refs[2205],opacity=1}},0.04,"linear",0)
scene:shift(refs[2205],{1.7958333333333336,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2205],opacity=0},{target=refs[2206],opacity=1}},0.01,"linear",0)
scene:fade(refs[2188],0,0.01,"linear")
scene:fade(refs[2207],1,0.12,"linear")
scene:fade(refs[2223],1,0.12,"linear")
scene:play({{target=refs[2223],opacity=0},{target=refs[2224],opacity=1}},0.04,"linear",0)
scene:shift(refs[2224],{2.0541666666666663,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2224],opacity=0},{target=refs[2225],opacity=1}},0.01,"linear",0)
scene:fade(refs[2207],0,0.01,"linear")
scene:fade(refs[2226],1,0.12,"linear")
scene:fade(refs[2242],1,0.12,"linear")
scene:play({{target=refs[2242],opacity=0},{target=refs[2243],opacity=1}},0.04,"linear",0)
scene:shift(refs[2243],{2.3125,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2243],opacity=0},{target=refs[2244],opacity=1}},0.01,"linear",0)
scene:fade(refs[2226],0,0.01,"linear")
scene:fade(refs[2245],1,0.12,"linear")
scene:fade(refs[2261],1,0.12,"linear")
scene:play({{target=refs[2261],opacity=0},{target=refs[2262],opacity=1}},0.04,"linear",0)
scene:shift(refs[2262],{2.5708333333333324,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2262],opacity=0},{target=refs[2263],opacity=1}},0.01,"linear",0)
scene:fade(refs[2245],0,0.01,"linear")
scene:fade(refs[2264],1,0.12,"linear")
scene:fade(refs[2280],1,0.12,"linear")
scene:play({{target=refs[2280],opacity=0},{target=refs[2281],opacity=1}},0.04,"linear",0)
scene:shift(refs[2281],{2.829166666666666,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2281],opacity=0},{target=refs[2282],opacity=1}},0.01,"linear",0)
scene:fade(refs[2264],0,0.01,"linear")
scene:fade(refs[2283],1,0.12,"linear")
scene:fade(refs[2299],1,0.12,"linear")
scene:play({{target=refs[2299],opacity=0},{target=refs[2300],opacity=1}},0.04,"linear",0)
scene:shift(refs[2300],{3.0875,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2300],opacity=0},{target=refs[2301],opacity=1}},0.01,"linear",0)
scene:fade(refs[2283],0,0.01,"linear")
scene:fade(refs[2302],1,0.12,"linear")
scene:fade(refs[2318],1,0.12,"linear")
scene:play({{target=refs[2318],opacity=0},{target=refs[2319],opacity=1}},0.04,"linear",0)
scene:shift(refs[2319],{3.3458333333333328,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2319],opacity=0},{target=refs[2320],opacity=1}},0.01,"linear",0)
scene:fade(refs[2302],0,0.01,"linear")
scene:fade(refs[2321],1,0.12,"linear")
scene:fade(refs[2337],1,0.12,"linear")
scene:play({{target=refs[2337],opacity=0},{target=refs[2338],opacity=1}},0.04,"linear",0)
scene:shift(refs[2338],{3.604166666666666,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2338],opacity=0},{target=refs[2339],opacity=1}},0.01,"linear",0)
scene:fade(refs[2321],0,0.01,"linear")
scene:fade(refs[2340],1,0.12,"linear")
scene:fade(refs[2356],1,0.12,"linear")
scene:play({{target=refs[2356],opacity=0},{target=refs[2357],opacity=1}},0.04,"linear",0)
scene:shift(refs[2357],{3.8625,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2357],opacity=0},{target=refs[2358],opacity=1}},0.01,"linear",0)
scene:fade(refs[2340],0,0.01,"linear")
scene:fade(refs[2359],1,0.12,"linear")
scene:fade(refs[2375],1,0.12,"linear")
scene:play({{target=refs[2375],opacity=0},{target=refs[2376],opacity=1}},0.04,"linear",0)
scene:shift(refs[2376],{4.120833333333333,-0.9041666666666663},0.3,"ease_in_out")
scene:play({{target=refs[2376],opacity=0},{target=refs[2377],opacity=1}},0.01,"linear",0)
scene:fade(refs[2359],0,0.01,"linear")
scene:fade(refs[2378],1,0.12,"linear")
scene:fade(refs[2388],1,0.12,"linear")
scene:play({{target=refs[2388],opacity=0},{target=refs[2389],opacity=1}},0.04,"linear",0)
scene:shift(refs[2389],{1.2791666666666663,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2389],opacity=0},{target=refs[2390],opacity=1}},0.01,"linear",0)
scene:fade(refs[2378],0,0.01,"linear")
scene:fade(refs[2391],1,0.12,"linear")
scene:fade(refs[2407],1,0.12,"linear")
scene:play({{target=refs[2407],opacity=0},{target=refs[2408],opacity=1}},0.04,"linear",0)
scene:shift(refs[2408],{1.5375,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2408],opacity=0},{target=refs[2409],opacity=1}},0.01,"linear",0)
scene:fade(refs[2391],0,0.01,"linear")
scene:fade(refs[2410],1,0.12,"linear")
scene:fade(refs[2426],1,0.12,"linear")
scene:play({{target=refs[2426],opacity=0},{target=refs[2427],opacity=1}},0.04,"linear",0)
scene:shift(refs[2427],{1.7958333333333336,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2427],opacity=0},{target=refs[2428],opacity=1}},0.01,"linear",0)
scene:fade(refs[2410],0,0.01,"linear")
scene:fade(refs[2429],1,0.12,"linear")
scene:fade(refs[2445],1,0.12,"linear")
scene:play({{target=refs[2445],opacity=0},{target=refs[2446],opacity=1}},0.04,"linear",0)
scene:shift(refs[2446],{2.0541666666666663,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2446],opacity=0},{target=refs[2447],opacity=1}},0.01,"linear",0)
scene:fade(refs[2429],0,0.01,"linear")
scene:fade(refs[2448],1,0.12,"linear")
scene:fade(refs[2464],1,0.12,"linear")
scene:play({{target=refs[2464],opacity=0},{target=refs[2465],opacity=1}},0.04,"linear",0)
scene:shift(refs[2465],{2.3125,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2465],opacity=0},{target=refs[2466],opacity=1}},0.01,"linear",0)
scene:fade(refs[2448],0,0.01,"linear")
scene:fade(refs[2467],1,0.12,"linear")
scene:fade(refs[2483],1,0.12,"linear")
scene:play({{target=refs[2483],opacity=0},{target=refs[2484],opacity=1}},0.04,"linear",0)
scene:shift(refs[2484],{2.5708333333333324,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2484],opacity=0},{target=refs[2485],opacity=1}},0.01,"linear",0)
scene:fade(refs[2467],0,0.01,"linear")
scene:fade(refs[2486],1,0.12,"linear")
scene:fade(refs[2502],1,0.12,"linear")
scene:play({{target=refs[2502],opacity=0},{target=refs[2503],opacity=1}},0.04,"linear",0)
scene:shift(refs[2503],{2.829166666666666,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2503],opacity=0},{target=refs[2504],opacity=1}},0.01,"linear",0)
scene:fade(refs[2486],0,0.01,"linear")
scene:fade(refs[2505],1,0.12,"linear")
scene:fade(refs[2521],1,0.12,"linear")
scene:play({{target=refs[2521],opacity=0},{target=refs[2522],opacity=1}},0.04,"linear",0)
scene:shift(refs[2522],{3.0875,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2522],opacity=0},{target=refs[2523],opacity=1}},0.01,"linear",0)
scene:fade(refs[2505],0,0.01,"linear")
scene:fade(refs[2524],1,0.12,"linear")
scene:fade(refs[2540],1,0.12,"linear")
scene:play({{target=refs[2540],opacity=0},{target=refs[2541],opacity=1}},0.04,"linear",0)
scene:shift(refs[2541],{3.3458333333333328,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2541],opacity=0},{target=refs[2542],opacity=1}},0.01,"linear",0)
scene:fade(refs[2524],0,0.01,"linear")
scene:fade(refs[2543],1,0.12,"linear")
scene:fade(refs[2559],1,0.12,"linear")
scene:play({{target=refs[2559],opacity=0},{target=refs[2560],opacity=1}},0.04,"linear",0)
scene:shift(refs[2560],{3.604166666666666,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2560],opacity=0},{target=refs[2561],opacity=1}},0.01,"linear",0)
scene:fade(refs[2543],0,0.01,"linear")
scene:fade(refs[2562],1,0.12,"linear")
scene:fade(refs[2578],1,0.12,"linear")
scene:play({{target=refs[2578],opacity=0},{target=refs[2579],opacity=1}},0.04,"linear",0)
scene:shift(refs[2579],{3.8625,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2579],opacity=0},{target=refs[2580],opacity=1}},0.01,"linear",0)
scene:fade(refs[2562],0,0.01,"linear")
scene:fade(refs[2581],1,0.12,"linear")
scene:fade(refs[2597],1,0.12,"linear")
scene:play({{target=refs[2597],opacity=0},{target=refs[2598],opacity=1}},0.04,"linear",0)
scene:shift(refs[2598],{4.120833333333333,-1.1625},0.3,"ease_in_out")
scene:play({{target=refs[2598],opacity=0},{target=refs[2599],opacity=1}},0.01,"linear",0)
scene:fade(refs[2581],0,0.01,"linear")
scene:fade(refs[2600],1,0.12,"linear")
scene:fade(refs[2610],1,0.12,"linear")
scene:play({{target=refs[2610],opacity=0},{target=refs[2611],opacity=1}},0.04,"linear",0)
scene:shift(refs[2611],{1.2791666666666663,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2611],opacity=0},{target=refs[2612],opacity=1}},0.01,"linear",0)
scene:fade(refs[2600],0,0.01,"linear")
scene:fade(refs[2613],1,0.12,"linear")
scene:fade(refs[2629],1,0.12,"linear")
scene:play({{target=refs[2629],opacity=0},{target=refs[2630],opacity=1}},0.04,"linear",0)
scene:shift(refs[2630],{1.5375,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2630],opacity=0},{target=refs[2631],opacity=1}},0.01,"linear",0)
scene:fade(refs[2613],0,0.01,"linear")
scene:fade(refs[2632],1,0.12,"linear")
scene:fade(refs[2648],1,0.12,"linear")
scene:play({{target=refs[2648],opacity=0},{target=refs[2649],opacity=1}},0.04,"linear",0)
scene:shift(refs[2649],{1.7958333333333336,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2649],opacity=0},{target=refs[2650],opacity=1}},0.01,"linear",0)
scene:fade(refs[2632],0,0.01,"linear")
scene:fade(refs[2651],1,0.12,"linear")
scene:fade(refs[2667],1,0.12,"linear")
scene:play({{target=refs[2667],opacity=0},{target=refs[2668],opacity=1}},0.04,"linear",0)
scene:shift(refs[2668],{2.0541666666666663,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2668],opacity=0},{target=refs[2669],opacity=1}},0.01,"linear",0)
scene:fade(refs[2651],0,0.01,"linear")
scene:fade(refs[2670],1,0.12,"linear")
scene:fade(refs[2686],1,0.12,"linear")
scene:play({{target=refs[2686],opacity=0},{target=refs[2687],opacity=1}},0.04,"linear",0)
scene:shift(refs[2687],{2.3125,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2687],opacity=0},{target=refs[2688],opacity=1}},0.01,"linear",0)
scene:fade(refs[2670],0,0.01,"linear")
scene:fade(refs[2689],1,0.12,"linear")
scene:fade(refs[2705],1,0.12,"linear")
scene:play({{target=refs[2705],opacity=0},{target=refs[2706],opacity=1}},0.04,"linear",0)
scene:shift(refs[2706],{2.5708333333333324,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2706],opacity=0},{target=refs[2707],opacity=1}},0.01,"linear",0)
scene:fade(refs[2689],0,0.01,"linear")
scene:fade(refs[2708],1,0.12,"linear")
scene:fade(refs[2724],1,0.12,"linear")
scene:play({{target=refs[2724],opacity=0},{target=refs[2725],opacity=1}},0.04,"linear",0)
scene:shift(refs[2725],{2.829166666666666,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2725],opacity=0},{target=refs[2726],opacity=1}},0.01,"linear",0)
scene:fade(refs[2708],0,0.01,"linear")
scene:fade(refs[2727],1,0.12,"linear")
scene:fade(refs[2743],1,0.12,"linear")
scene:play({{target=refs[2743],opacity=0},{target=refs[2744],opacity=1}},0.04,"linear",0)
scene:shift(refs[2744],{3.0875,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2744],opacity=0},{target=refs[2745],opacity=1}},0.01,"linear",0)
scene:fade(refs[2727],0,0.01,"linear")
scene:fade(refs[2746],1,0.12,"linear")
scene:fade(refs[2762],1,0.12,"linear")
scene:play({{target=refs[2762],opacity=0},{target=refs[2763],opacity=1}},0.04,"linear",0)
scene:shift(refs[2763],{3.3458333333333328,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2763],opacity=0},{target=refs[2764],opacity=1}},0.01,"linear",0)
scene:fade(refs[2746],0,0.01,"linear")
scene:fade(refs[2765],1,0.12,"linear")
scene:fade(refs[2781],1,0.12,"linear")
scene:play({{target=refs[2781],opacity=0},{target=refs[2782],opacity=1}},0.04,"linear",0)
scene:shift(refs[2782],{3.604166666666666,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2782],opacity=0},{target=refs[2783],opacity=1}},0.01,"linear",0)
scene:fade(refs[2765],0,0.01,"linear")
scene:fade(refs[2784],1,0.12,"linear")
scene:fade(refs[2800],1,0.12,"linear")
scene:play({{target=refs[2800],opacity=0},{target=refs[2801],opacity=1}},0.04,"linear",0)
scene:shift(refs[2801],{3.8625,-1.4208333333333332},0.3,"ease_in_out")
scene:play({{target=refs[2801],opacity=0},{target=refs[2802],opacity=1}},0.01,"linear",0)
scene:fade(refs[2784],0,0.01,"linear")
scene:fade(refs[2803],1,0.45,"linear")
scene:fade(refs[2816],1,0.5,"linear")
scene:fade(refs[2822],1,0.55,"linear")
scene:play({{target=refs[2822],opacity=0},{target=refs[2823],opacity=1}},0.04,"linear",0)
scene:shift(refs[2823],{4.120833333333333,-1.4208333333333332},0.65,"ease_in_out")
scene:play({{target=refs[2823],opacity=0},{target=refs[2824],opacity=1}},0.01,"linear",0)
scene:wait(1.4)
return scene
