Appendix A: Shape color sources: solid / gradient
==========================================================

Claim
- SwSpan controls destination coverage; source colors are supplied separately.
- Same x/y/len/coverage can produce uniform solid color, position-dependent gradient,
  with coverage and source color as independent inputs.
- The movie shows actual CPU raster results, not a runtime benchmark.

Source evidence
- ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b, unmodified engine source.
- rle-color-trace.cpp includes the renderer translation unit to inspect task data.
- Two independent public SwCanvas runs, w12/h8/stride16, ABGR8888,
  background 0xffdef0fa, Normal blend, opaque sources, no SIMD/worker threads.
- Solid uses the existing polygon and fill(32,120,220,255).
- Linear Gradient uses (0,0) -> (12,0) with stops at 0/.5/1:
  (32,120,220), (145,80,200), (245,158,55), alpha255.
- Both engine-generated arrays have the exact same 29 span records.
- Per-span calls to rasterShape and rasterGradientShape assert
  unchanged memory outside the span; full replay equals public Canvas output.
- Gradient source view samples actual fillLinear at pixel positions. It is not
  the physical ctable memory layout. Full-coverage outputs match these samples.
- Variant repeats the actual engine run with polygon's first vertex x=2.0.

Files
- rle-color-trace.cpp / .txt / rle-color-variant.txt: evidence and independent variant.
- build-rle-color.mjs -> sw-rle-color-sources.lua: standalone portable tmath scene.
- render-rle-color.mjs: CPU WASM audits, pixel checks, WebP poster and MP4 export.
- ../IMAGE/07-SW-Overview/rle-color-sources.mp4 and .webp: article media.

Reproduce from site root
meson setup src/content/blog/Mentoring/LUA/temp/rle-color/build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C src/content/blog/Mentoring/LUA/temp/rle-color/build -j 6
c++ -std=c++17 -O2 -I src/content/blog/Mentoring/LUA/temp/rle-color/build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/rle-color-trace.cpp src/content/blog/Mentoring/LUA/temp/rle-color/build/src/libthorvg-1.a -o src/content/blog/Mentoring/LUA/temp/rle-color/trace
src/content/blog/Mentoring/LUA/temp/rle-color/trace > src/content/blog/Mentoring/LUA/rle-color-trace.txt
src/content/blog/Mentoring/LUA/temp/rle-color/trace 2.0 > src/content/blog/Mentoring/LUA/rle-color-variant.txt
node src/content/blog/Mentoring/LUA/build-rle-color.mjs
node src/content/blog/Mentoring/LUA/render-rle-color.mjs /absolute/path/to/tmath-skills/assets/wasm

Beat ledger and meaning
1. Initial: retained color sources above two blank beige target buffers.
2. Read: orange outlines select source/output spans; copies retain source color.
3. Coverage: copied colors reach the begin-pixel/length-line reference, then preview
   the real composition with the destination. RLE itself never stores color.
4. Write: copies move to the destination row; exact output values commit there.
5. Repeat all actual spans, keeping prior pixels visible; no reset between records.
6. Final: retain the longest common span across all two complete surfaces.
- All lanes run together only for comparison, not to depict scheduler parallelism.
- Coordinates use explicit pixel-to-world mapping, fixed 1800x1600 canvas.
- Moving squares are value copies, not moved/deleted source pixels or RLE records.
- Coverage line starts at begin pixel center and has len cell pitches; end exclusive.
- Linear Gradient only; no Radial or transformed-image sampling motion is claimed.

Validation
- Every encoded frame: paint bounds, Text/Text gaps, 64 standalone Text identities.
- No opaque Text backing rectangles. Selection outlines are transient geometry.
- Source and output cells checked initially, after each of 29 writes, and at final.
- Moving samples checked before and after coverage at every span in both lanes.
- Independent variant output checked against its actual engine values.
- 12,272 rendered pixel checks, 29 equal spans per lane, all Canvas comparisons pass.
- MP4: 1800x1600, 30fps, 1246 frames / 41.533333 seconds; full decode passed.
- All 1246 frames pass layout checks; minimum canvas margin 96.5px.
- MDX compile passed; all seven previous videos and both images preserved.
- Detailed audit record: temp/rle-color/review.txt.
- No additional inline raster review or manual 1x playback: the thread's raster
  review budget was exhausted earlier. Non-inline audits remain the verification.

Investigation note
- The local solid gradient rectangle wrapper writes pixels but returns false after
  its call (tvgSwRaster.cpp _rasterLinearGradientRect). For the source sample view,
  the harness calls fillLinear directly, matching the actual position lookup.
  The two final outputs are still verified against public Canvas rendering.
- Last-span to longest-span focus uses successive fades to avoid overlapping text.

Cleanup
- Remove temporary build, trace executable and review PNGs after export; the site's
  recursive media copier would otherwise include build JSON and temporary images.
- Preserve the small text audit record. No engine modifications are required.
