Appendix B: clip-free Bitmap paths
==================================

Question
- Does moving/scaling/rotating a Bitmap create SwImage.rle without a clip task?
- Actual ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b answer: no.
- A no-clip example cannot truthfully be called an image-RLE generation example.
- The MDX gives the actual generation condition, and the movie demonstrates the
  requested clip-free paths. The clipped image lane was removed from Appendix A.

Evidence
- image-path-trace.cpp: public Picture/SwCanvas calls with internal read-only task
  inspection by inclusion of the unmodified renderer translation unit.
- Opaque ABGR8888 pixel-art Bitmap, 12x8. Target w24/h20/stride28, beige background.
- The beige background is an actual retained Shape added before the Picture;
  it is redrawn after partial-render dirty-region clearing. User-memory prefill
  alone is insufficient. Both engine traces and the exporter assert opaque
  output for every visible Surface cell, including anti-aliased rotation edges.
- CPU build, SIMD/threads disabled, no file loaders required (raw bitmap input).
- One retained Picture, with successive absolute transform matrices:
  Direct: translation(3,3).
  Scale: 1.5x with translation(2,2).
  Rotation: 30 degrees with translation(7,2).
- Each task asserts valid, clips.count==0, image.rle==nullptr before draw; RLE
  remains null after draw/sync. Direct/scaled/general classification also asserted.
- Each stage records the actual transformed quad and the whole public Canvas buffer.
- Buffer padding remains unchanged. Independent variant uses 45 degrees.
- No clip(), mask(), or synthetic RLE is used in this harness or movie.

Files
- image-path-trace.cpp, image-path-trace.txt, image-path-variant.txt.
- build-image-paths.mjs -> sw-image-paths.lua.
- render-image-paths.mjs: CPU WASM frame/pixel audits and MP4/WebP exports.
- ../IMAGE/07-SW-Overview/image-direct-scale-rotation.mp4 and image-paths.webp.

Reproduce (site root)
meson setup src/content/blog/Mentoring/LUA/temp/image-paths/build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C src/content/blog/Mentoring/LUA/temp/image-paths/build -j 6
c++ -std=c++17 -O2 -I src/content/blog/Mentoring/LUA/temp/image-paths/build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/image-path-trace.cpp src/content/blog/Mentoring/LUA/temp/image-paths/build/src/libthorvg-1.a -o src/content/blog/Mentoring/LUA/temp/image-paths/trace
src/content/blog/Mentoring/LUA/temp/image-paths/trace > src/content/blog/Mentoring/LUA/image-path-trace.txt
src/content/blog/Mentoring/LUA/temp/image-paths/trace 45 > src/content/blog/Mentoring/LUA/image-path-variant.txt
node src/content/blog/Mentoring/LUA/build-image-paths.mjs
node src/content/blog/Mentoring/LUA/render-image-paths.mjs /absolute/path/to/tmath-skills/assets/wasm

Motion / beat ledger
1. Original bitmap retained on left; right destination initially blank.
2. Show a transformed boundary and selected raster method; no RLE is created.
3. Direct/Scale: hide guide and reveal completed Canvas output row by row.
4. Hold Direct result, reset target; repeat Scale. Rotation splits the source and
   transformed quad on diagonal1-3. Highlight source/destination T1(0,1,3), then
   reveal actual first triangle result. T2(1,2,3) follows and retains T1 pixels.
5. Final: rotation result plus image.rle=nullptr and clips.count=0 labels.
- Row reveal is a presentation of completed output, not an instrumented sequence
  of engine writes, a span traversal, or a claim of CPU execution timing.
- The boundary is a guide only; its preview does not write destination pixels.

Checks
- All 768 encoded frames: bounds and Text/Text gap audit, 12 standalone labels.
- Minimum paint clearance 68.58px; no Text backed by opaque rectangles.
- 32,736 pixel comparisons across initial, reset, all 52 row commits, final,
  retained source and independent 45-degree output (111 changed output pixels).
- 1800x1100, 30fps, 768 frames; encoded duration 25.6 seconds.
- Full MP4 decode and target MDX compilation passed; main Overview unchanged.
- No additional inline raster review or manual 1x playback: the thread raster
  review budget was exhausted earlier. Non-inline audits provide verification.

Cleanup
Remove the temporary build, executable and review PNGs after export. Preserve the
small review.txt audit record; build JSON must not enter the site's media copier.

Playback fix: the original live URL resolved to /@fs/IMAGE/... (404). A fresh
asset filename now resolves correctly; actual browser play/seek results are in
temp/image-paths/playback-review.txt. No site configuration changes were needed.

Rotation background fix
- Previously SwRenderer::preRender() cleared dirty regions to transparent zero.
  The movie's RGB cell conversion ignored alpha, displaying these cells as black
  and partially transparent premultiplied edge colors as dark pixels.
- A retained background Shape fixes the scene setup at the actual engine input;
  exported colors remain exact Canvas output rather than patched video pixels.
- The opacity assertion fails on the original trace at Rotation pixel (2,2).
  After the fix all Surface pixels in all three stages are opaque in both runs;
  171 canonical / 217 variant pixel values changed, source data unchanged.
- Browser playback at 95%: all 480 Surface cells matched the engine trace
  within 12 RGB levels after H.264 encoding; formerly black cell is beige
  (252,240,223). Full MP4 decode and target MDX compilation passed.

Texmap triangle correction
- image-path-trace.cpp includes unmodified tvgSwRaster.cpp to call the internal
  _rasterPolygonImage separately, using the exact vertex indices, transformed
  XY, source UV, context, bounding box and needAA condition of rasterTexmapPolygon.
- triangles[0].pixels is the true buffer after T1; triangles[1].pixels after T2.
  Final replay equals public Canvas output for both 30 and45 degrees. All previous
  final output pixels, including the corrected beige background, are unchanged.
- B.1 explains Y-sorted triangle segment scan conversion, UV increments, source
  sampling, filter and AA. These horizontal segments are not a stored image RLE.
- The movie reveals each captured triangle result by changed rows (6+6 rows at
  30 degrees). This is not a per-instruction/per-pixel execution trace. T1 before
  T2 is the actual function call order; source and destination outlines match.
- Data covers completed triangle states; individual UV samples are explained by
  source code, not presented as instrumented moving UV sample points.
