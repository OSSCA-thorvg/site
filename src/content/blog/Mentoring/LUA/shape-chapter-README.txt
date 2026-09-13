CPU Engine - Shape
==================

Scope / source
- Article: ../07-3-CPU-Engine-Shape.mdx.
- ThorVG checkout6cf10d47fbe13b45040f2c56feeafa0711f53b2b; no engine source changes.
- CPU, SIMD/workers disabled. 24 independently constructed Shape inputs on a
  24x18 target, stride28, opaque ABGR8888 background. Actual public Canvas output
  equals per-span rasterShape/rasterStroke replay for every canonical/variant case.
- Source arrays, processed centerline contours, expanded stroke contours, tight
  path bounds, control-point bounds, render box, RLE and pixel data are recorded.
- Drawing colors are retained solely as validation inputs; color/gradient algorithms
  are referenced to existing Overview and Fill articles, not retaught here.

Files / reproduction (site root)
- shape-engine-trace.cpp -> shape-engine-trace.txt / shape-engine-variant.txt
- build-shape-scenes.mjs -> sw-shape-01...07.lua
- render-shape-scenes.mjs -> ../IMAGE/07-SW-Shape/*.mp4 / *.webp
- shape-scenes.txt: scene inventory; temp/shape-chapter/review.txt: renderer audits.

meson setup /tmp/thorvg-shape-build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C /tmp/thorvg-shape-build -j 6
c++ -std=c++17 -O2 -I /tmp/thorvg-shape-build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/shape-engine-trace.cpp /tmp/thorvg-shape-build/src/libthorvg-1.a -o /tmp/thorvg-shape-build/trace
/tmp/thorvg-shape-build/trace > src/content/blog/Mentoring/LUA/shape-engine-trace.txt
/tmp/thorvg-shape-build/trace variant > src/content/blog/Mentoring/LUA/shape-engine-variant.txt
node src/content/blog/Mentoring/LUA/build-shape-scenes.mjs
node src/content/blog/Mentoring/LUA/render-shape-scenes.mjs /absolute/path/to/tmath-skills/assets/wasm

Series / beat ledger
01 Path storage (11.15s)
- Question: How many coordinates does each path command consume?
- Opening MoveTo point; create LineTo; introduce two controls/end and cubic;
  copy coordinate tokens into pts; Close constructs edge without a new Point.
- Final: four commands /five Point values. Control-point x changes in variant.
02 Bezier (10.98s)
- Question: What do cubic control points mean?
- Fixed control polygon; animate three interpolation levels; reveal actual
  Bezier::at(t) samples; hold t=.5; draw two native Bezier::split half curves.
- Samples are a mathematical construction, not rasterizer tessellation records.
  Article explains adaptive RLE subdivision and distinct stroke cubic processing.
03 Bounds (9.70s)
- Question: Why can a render box be larger than the curve?
- Control hull bounds; curve-extrema bounds; translated path; viewport;
  rounded/clipped render box. Actual native values used for all rectangles.
04 Path to RLE (9.05s)
- Question: How does the same contour determine Surface coverage?
- Retain original path; reveal38 native spans with begin pixel/length line;
  complete preparation; select rows and write native Surface results (141 pixels).
05 Stroke (23.60s)
- Question: How do centerline, outline and pixels differ?
- Centerline; create actual expanded contour; show pixels; switch Butt/Square/Round
  caps; switch Miter/Round/Bevel joins. Source width3, variant3.5.
- Expanded round contours preserve cubic controls and implicit closing endpoints;
  not straight-line approximations of control points.
06 Dash (18.10s)
- Question: What changes when dash offset advances?
- Same gray cubic; actual on-contour fragments; raster result; offsets0...5.
  Pattern[4,2], variant[4.5,2]. No pixel erasing or screen-space distance claims.
07 Trim (15.60s)
- Question: Per-subpath percentage or percentage of total path length?
- Unequal18/9 subpaths; paired true/false; end .25/.5/.75/1; exact trimmed
  centerlines above, actual Surface results below. Variant short length9.5.

Common production / limitations
- 1920x1080,30fps, Pro White, Pretendard registered in CPU WASM.
- English semantic labels only; no video titles, subtitles or prose paragraphs.
- Source dimensions/layout/colors remain consistent across movies. Curved path
  storage, Bezier, bounds and RLE share one canonical cubic example.
- All Text is intentionally standalone, ID label_*. No backing Text rectangles.
- Layout/gaps checked for all2957 frames; minimum canvas clearance81.79px.
- 19,078 geometry/pixel checks, plus all-buffer native replay assertions and
  independent input perturbations. All7 decoded MP4s and MDX compile passed.
- Browser article playback, seeking and decoded final pixel comparisons are
  recorded in temp/shape-chapter/playback-review.txt.
- Motion pacing is pedagogical; no benchmark or per-instruction worker trace.
- No additional inline raster review: earlier thread image-review budget exhausted.
  Full-resolution review frames generated locally and checked without image payloads.
- Remove temporary native builds and review PNGs after export; keep small text audits.
