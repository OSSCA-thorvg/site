RLE / Surface — actual ThorVG evidence
=====================================

Scope
- Overview 2.1 / 2.2 now use actual engine spans and output values.
- Source revision: thorvg 6cf10d47fbe13b45040f2c56feeafa0711f53b2b (clean checkout).
- No engine source files were modified. rle-engine-trace.cpp includes the unmodified
  tvgSwRenderer.cpp translation unit to inspect SwShapeTask for this evidence harness.
- CPU, SIMD disabled, worker threads disabled, no loaders, no gradient/mask/effects.
- Shape: (1.25,1.25) → (9.5,2.75) → (8.25,6.5) → (2.25,5.75), closed.
- Solid fill RGBA (32,120,220,255), opacity 255, Normal, ABGR8888.
- Target w=12, h=8, stride=16. Initial packed destination 0xFFDEF0FA, draw(false).
- 29 actual spans. No supersampling/polygon-area replacement of ThorVG coverage.

Evidence files
- rle-engine-trace.cpp: public Canvas render, prepared RLE extraction, per-span replay.
- rle-engine-trace.txt: JSON-formatted actual spans and all 128 packed memory values.
- rle-engine-variant.txt: independent engine run with first vertex x=2.0.
- build-rle-scenes.mjs: embeds actual trace into two portable standalone Lua scenes.
- sw-rle-creation.lua: SwRle.spans and spatial begin/length glyphs; array window of 10.
- sw-rle-surface.lua: array pointer, stride-based address, coverage branch, buffer write.
- render-rle-detail.mjs: frame audit, exact output checks, export.

Reproduce evidence (site root)
meson setup src/content/blog/Mentoring/LUA/temp/rle-engine/build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C src/content/blog/Mentoring/LUA/temp/rle-engine/build -j 6
c++ -std=c++17 -O2 -I src/content/blog/Mentoring/LUA/temp/rle-engine/build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/rle-engine-trace.cpp src/content/blog/Mentoring/LUA/temp/rle-engine/build/src/libthorvg-1.a -o src/content/blog/Mentoring/LUA/temp/rle-engine/trace
src/content/blog/Mentoring/LUA/temp/rle-engine/trace > src/content/blog/Mentoring/LUA/rle-engine-trace.txt
src/content/blog/Mentoring/LUA/temp/rle-engine/trace 2.0 > src/content/blog/Mentoring/LUA/rle-engine-variant.txt
node src/content/blog/Mentoring/LUA/build-rle-scenes.mjs
node src/content/blog/Mentoring/LUA/render-rle-detail.mjs /absolute/path/to/tmath-skills/assets/wasm

Verification
- Harness asserts each span's replay through actual rasterShape changes only its range.
- Packed output equals real ALPHA_BLEND/opaque source result for every written element.
- Whole buffer (including padding) equals public SwCanvas::draw(false) output byte-for-byte.
- RLE video: checks all 29 span begin positions, line lengths, and coverage markers.
- Surface video: checks initial buffer, all 29 span-commit states, final buffer: 3968 cells.
- Variant input changes actual engine output and both diagrams; variant Surface also
  matches its independent engine run at all 128 memory locations.
- All 592 + 840 exported frames checked for text gaps and canvas bounds.
- Short label_* text is standalone. Rectangle outlines around table rows are transient
  selection marks, not opaque text backing cards. Minimum canvas margin >82px.
- Total Text objects across time: creation 155, surface 441; only one array page and
  current operation's labels are displayed at once.
- Videos: 2400×1400, 30fps, Pro White, Pretendard, no loop.
- rle-creation.mp4: 592 frames, 19.733333 seconds.
- rle-surface.mp4: 840 frames, 28 seconds.
- Final WebP posters are lossless. Full MP4 decode and MDX compile pass.

Interpretation limits
- Creation video reveals the completed Prepare result; it does not instrument the
  individual _horizLine calls or intermediate span merges.
- Surface video commits one completed span per beat, not individual CPU instruction
  timing. The solid branch can dispatch to SIMD in other build configurations.
- Starts are pixel markers; the center-to-end line measures len cell pitches.
  End x+len is exclusive. The line is not a new raster path or an actual stored line.
- Padding is real buffer storage, hatched to distinguish it from the visible width.
- No additional generated raster was loaded inline or played back manually at 1x;
  the thread's inline generated-raster review budget was exhausted earlier.

Temporary material
- Disposable builds, executables, PNGs and logs live under LUA/temp/rle-engine.
- Remove build directory after verification: it contains Meson JSON that the site's
  recursive media copy would otherwise include. Keep only review.txt evidence there.
- Existing RenderMethod remains a single PNG. CLAA TODO and deferred sections unchanged.

API → Surface overview integration
- build-rle-scenes.mjs also generates sw-overview-api-rle-surface.lua from the same actual trace.
- Export only overview: render-rle-detail.mjs <wasm-bundle> --overview-only.
- 1159 frames, 2400x1400, 38.633333 encoded seconds; 139 total Text objects across time.
- API calls construct the trace polygon; Prepare leaves the buffer untouched.
- 4096 cell comparisons cover initial, pre-draw, 29 span commits and final buffer.
- Variant Surface matches all 128 elements from the independent engine run.
