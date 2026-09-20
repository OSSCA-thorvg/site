Appendix B.2: separate clip RLE, image RLE and Bitmap colors
=========================================================

Question / claim
- image.rle is an optional SwImage coverage/position list, not compressed colors.
- Without a remaining clip task (including viewport-fast-track rectangle), it is
  null. With a circle clip, SwImageTask generates the transformed image rectangle
  RLE, intersects it with the independently owned clip Shape RLE, then renders.
- rleClip builds out and moves it into image.rle->spans; clip RLE is unchanged.
- Source colors remain in image.buf32; no color is stored in SwSpan.

Source evidence
- Unmodified ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b CPU engine.
- Input Bitmap 8x6, translated (2,1), target 12x8 stride16, opaque ABGR8888.
- Three separate Canvas runs: no clip; rectangle(3,2,6,4); circle(6,4,r=3.25).
- Clip circle extends above/below image so its 32 spans differ from final image
  RLE: six image-area spans, intersection of 26 spans. Separate pointers asserted.
- Real imagePrepare/imageGenRle and clipTask->clip replay match actual task RLE.
- All per-span rasterDirectRleImage writes equal the complete public Canvas output;
  outside-span pixels and target padding remain unchanged.
- Variant moves circle center to x=5.5; 24 final Surface pixels change.
- image-clip-api.cpp: public API only, same sample, default 0-degree / optional
  30-degree rotation about image center. Both compile and run against CPU backend.
- Separate read-only inspection of that API program confirmed:
  angle=0 clips=1 image.rle.spans=26 direct=1 scaled=0
  angle=30 clips=1 image.rle.spans=30 direct=0 scaled=0
- Rotation + image RLE uses an intermediate texture-mapped buffer then Direct RLE
  compositing (SwRenderer::renderImage). The movie demonstrates Direct only.

Files
- image-clip-trace.cpp / image-clip-trace.txt / image-clip-variant.txt.
- image-clip-api.cpp: executable API usage, no private engine headers.
- build-image-clip.mjs -> sw-image-clip-tasks.lua.
- render-image-clip.mjs -> ../IMAGE/07-SW-Overview/image-clip-tasks.mp4 / .webp.

Reproduce (site root; keep temporary builds outside site media trees)
meson setup /tmp/thorvg-image-clip-build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C /tmp/thorvg-image-clip-build -j 6
c++ -std=c++17 -O2 -I /tmp/thorvg-image-clip-build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/image-clip-trace.cpp /tmp/thorvg-image-clip-build/src/libthorvg-1.a -o /tmp/thorvg-image-clip-build/trace
/tmp/thorvg-image-clip-build/trace > src/content/blog/Mentoring/LUA/image-clip-trace.txt
/tmp/thorvg-image-clip-build/trace 5.5 > src/content/blog/Mentoring/LUA/image-clip-variant.txt
c++ -std=c++17 -O2 -I thorvg/inc src/content/blog/Mentoring/LUA/image-clip-api.cpp /tmp/thorvg-image-clip-build/src/libthorvg-1.a -o /tmp/thorvg-image-clip-build/api
/tmp/thorvg-image-clip-build/api
/tmp/thorvg-image-clip-build/api rotate
node src/content/blog/Mentoring/LUA/build-image-clip.mjs
node src/content/blog/Mentoring/LUA/render-image-clip.mjs /absolute/path/to/tmath-skills/assets/wasm

Motion semantics
1. Start with the circle clip, retained Bitmap and blank Surface.
2. Reveal the left clip RLE, then done() and the middle raw Image RLE.
3. Compare rows and preview the intersection on the right; Surface stays blank.
4. Move the prepared result into the middle image.rle column.
5. Read Bitmap colors through those spans and write Surface pixels.
- No-clip and rectangle/viewport examples remain native fixtures only; neither
  appears in this animation. The blue outline is the labeled image boundary.
- Pixel shade encodes coverage; length connects first/last pixel centers.
  Single-pixel spans have no line or end cap.
- Reveals and copies explain captured data, not an instruction timing trace.

Validation
- 918 frames, 2400x1400, 30fps, 30.53999s Lua duration.
- All-frame layout audit: 42 labels, minimum margin62.34px.
- 5820 pixel checks: source retained, Prepare leaves Surface untouched, moving
  color copies, span writes, final output, coverage shade and independent variant.
- Opening contains the circle and no rectangle/no-clip example objects.
- Begin/length geometry and singleton suppression verified.
- Generated Lua and WebP are used by the site; --video optionally exports MP4.
- Review frames are moved outside the source tree after validation.

RLE glyph update
- Coverage remains grayscale on the first pixel. Length segments connect first
  and last pixel centers: (len - 1) cell intervals. len = 1 has neither a segment
  nor an end cap. Geometry and coverage pixel samples are checked by the renderer.
