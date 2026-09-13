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

Seven beats
1. Hold exact previous final frame for2 seconds.
2. Introduce teal slanted clip B on the same clip grid; task count1 ->2.
3. Prepare B RLE in the right lower column. Prior Surface still unchanged.
4. Rebuild image rectangle6 spans; apply circle A to recover26 spans.
5. Compare rows with B and reveal final24 spans in the same image.rle location.
6. Rendering: repaint background and read original Bitmap colors through the
   final RLE. Color copies travel directly from source to Surface.
7. Hold both clip shapes/RLEs, original Bitmap and narrowed final Surface.
- Prepare does not erase the prior Surface; rendering redraws it after preparation.
- Row transitions describe captured RLE results, not per-instruction writes to a
  live span array or CPU timing. There is no RLE-driven pixel eraser or new bitmap.
- Begin pixel plus center-origin length line retained; coverage is grayscale.

Reproduce (site root)
meson setup /tmp/thorvg-nested-clip-build thorvg -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= -Dsimd=false -Dthreads=false -Ddefault_library=static -Dtests=false
meson compile -C /tmp/thorvg-nested-clip-build -j 6
c++ -std=c++17 -O2 -I /tmp/thorvg-nested-clip-build -I thorvg/inc -I thorvg/src/common -I thorvg/src/renderer -I thorvg/src/renderer/cpu_engine src/content/blog/Mentoring/LUA/image-nested-clip-trace.cpp /tmp/thorvg-nested-clip-build/src/libthorvg-1.a -o /tmp/thorvg-nested-clip-build/trace
/tmp/thorvg-nested-clip-build/trace > src/content/blog/Mentoring/LUA/image-nested-clip-trace.txt
/tmp/thorvg-nested-clip-build/trace 8.5 > src/content/blog/Mentoring/LUA/image-nested-clip-variant.txt
node src/content/blog/Mentoring/LUA/build-image-nested-clip.mjs
node src/content/blog/Mentoring/LUA/render-image-nested-clip.mjs /absolute/path/to/tmath-skills/assets/wasm

Validation
- Exact uncompressed continuity: zero changed RGBA channels across previous end /
  next start (13,440,000 channels); source and clip A records also equal.
- All991 frames:44 standalone Text labels, no text overlap, minimum margin61.21px.
- 5742 pixel checks: prior Surface retained through Prepare, all row intersections,
  original source unchanged, moving source copies,24 span commits, final Surface,
  independent input variant. Span begin and line-length geometry verified.
- Final coverage never exceeds first circle-clipped coverage at any pixel.
- Lua32.969978s / encoded33.033333s,30fps. Details:temp/image-nested-clip/review.txt.
- MP4 decode, MDX compilation, real article playback/seek and final pixel checks.
- No inline generated raster review: thread review budget already exhausted.

Cleanup
Remove temporary native builds and review PNGs, keep small audit records. Existing
B.2 video is retained; this is a separately embedded continuation with its initial
state as poster.
