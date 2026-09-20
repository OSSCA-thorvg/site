B.2 continuation: circle clip followed by a second, slanted clip
=============================================================

Claim / continuity
- The first frame is pixel-identical to the exact final frame of
  sw-image-clip-tasks.lua, including Bitmap, circle, image RLE, Surface and labels.
- Same 2400x1400 canvas, Pretendard, Pro White, coordinates, colors and 8x6 Bitmap.
- Circle appearance is a visibility restriction; source Bitmap is not reshaped.
- A new clip B narrows visible image coverage; it does not modify clip A or source.

Actual engine evidence
- ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b CPU, no SIMD/workers.
- One retained scene, beige background Shape, Bitmap translated(2,1), target12x8
  stride16. Circle(center6,4 radius3.25) is attached to parent Scene.
- First draw: image task clips.count1, 26 spans /44 covered pixels. All pixels and
  RLE records match previous B.2, where the same circle was attached to Picture.
- Attach polygon(0,0),(9,0),(4,8),(0,8) to Picture, then update/draw/sync again.
- Task clips.count2; actual RenderData order asserted: Scene circle A, Picture B.
- imagePrepare/imageGenRle reconstruct6 spans; apply A ->26; apply B ->24 spans,
  30 covered pixels. Separate clip B has20 spans. Replayed final RLE matches task.
- Every rasterDirectRleImage span replay matches the second public Canvas buffer;
  padding and all outside-span pixels unchanged. Source stays byte-for-byte equal.
- Variant shifts polygon's slanted edge left0.5 (vertices8.5/3.5):21 final spans,
  26 covered pixels,12 output pixels changed. Unrelated geometry remains fixed.
- Paint::Impl::clip replaces a Paint's existing clip; parent/child attachment is
  intentional so both constraints are retained. No rotated-rectangle fast path.

Files
- image-nested-clip-trace.cpp / image-nested-clip-trace.txt / image-nested-clip-variant.txt
- build-image-nested-clip.mjs -> sw-image-nested-clip.lua
- render-image-nested-clip.mjs -> ../IMAGE/07-SW-Overview/image-nested-clip.mp4 / .webp
- The builder derives its initial skeleton from sw-image-clip-tasks.lua to enforce
  continuity. Regenerate the predecessor before regenerating this continuation.

Motion semantics
1. Hold the preceding animation's exact final frame for2 seconds.
2. Replace the left Clip A geometry/RLE with Clip B geometry/RLE.
3. Keep the current Image RLE (after A) in the middle and the old Surface right.
4. Intersect each row with B; replace the Image RLE in the same middle column.
5. Read original Bitmap colors and write the narrowed Surface on the right.
6. Hold active Clip B RLE, final Image RLE and rendered Surface.
- The native engine rebuilds the image footprint and reapplies A during Update.
  Those preparatory steps are omitted here: the captured post-A RLE is unchanged,
  and this continuation focuses on B applied to the current image coverage.
- Clip A data still exists in the engine; only its display is replaced by B.
- Prepare leaves Surface unchanged. Row scans cover only the two RLE lanes.
- Coverage uses grayscale; singleton spans have no length line/end cap.

Reproduce (site root)
meson setup /tmp/thorvg-nested-clip-build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C /tmp/thorvg-nested-clip-build -j 6
c++ -std=c++17 -O2 -I /tmp/thorvg-nested-clip-build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/image-nested-clip-trace.cpp /tmp/thorvg-nested-clip-build/src/libthorvg-1.a -o /tmp/thorvg-nested-clip-build/trace
/tmp/thorvg-nested-clip-build/trace > src/content/blog/Mentoring/LUA/image-nested-clip-trace.txt
/tmp/thorvg-nested-clip-build/trace 8.5 > src/content/blog/Mentoring/LUA/image-nested-clip-variant.txt
node src/content/blog/Mentoring/LUA/build-image-nested-clip.mjs
node src/content/blog/Mentoring/LUA/render-image-nested-clip.mjs /absolute/path/to/tmath-skills/assets/wasm

Validation
- Exact preceding-end / current-start continuity: zero changed RGBA channels.
- 919 frames, 2400x1400, 30fps, 30.56999s Lua duration.
- All-frame layout audit:43 labels, minimum margin62.34px.
- 5530 pixel checks: retained Bitmap/Surface, source copies,24 span commits,
  final pixels, coverage shades and an independent input variant.
- Active Clip B glyphs stay left, current Image RLE stays middle, and Clip A is
  hidden after replacement. Scan marks never visit an empty right RLE lane.
- Final coverage never exceeds the first circle-clipped coverage at any pixel.
- Generated Lua/WebP are used by the site; --video optionally exports MP4.
- Review frames are moved outside the source tree after validation.

RLE glyph update
- Coverage remains grayscale on the first pixel. Length segments connect first
  and last pixel centers: (len - 1) cell intervals. len = 1 has neither a segment
  nor an end cap. Geometry and coverage pixel samples are checked by the renderer.
