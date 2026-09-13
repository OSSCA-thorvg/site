RLE comparison (Overview 2.2.1)
==============================

Question: which work changes when using spans rather than a dense byte coverage array?
This is a data/traversal comparison, not a runtime benchmark or a ThorVG RLE-off mode.

Files
- build-rle-comparison.mjs: derives the comparison from rle-engine-trace.txt.
- sw-rle-comparison.lua: standalone portable tmath scene.
- render-rle-detail.mjs --comparison-only: validate and export this scene only.
- ../IMAGE/07-SW-Overview/rle-comparison.mp4 and lossless .webp.

Recreate (site root)
node src/content/blog/Mentoring/LUA/build-rle-comparison.mjs
node src/content/blog/Mentoring/LUA/render-rle-detail.mjs /absolute/path/to/tmath-skills/assets/wasm --comparison-only

Source facts
- Actual ThorVG 6cf10d4 spans and packed outputs from rle-engine-trace.cpp.
- Common coverage window [1,10) x [1,7): 54 coverage entries vs 29 spans.
- 10 zero entries have no corresponding RLE record.
- Both paths write 44 pixels: 19 full-coverage pixels, 25 partial-coverage pixels.
- The dense reference skips zero and directly stores full-coverage source;
  partial pixels use the same ALPHA_BLEND integer expression as ThorVG.
- SwSpan sizeof measured with the current headers on arm64: 16 bytes.
- Payloads only: 54 bytes dense vs 464 bytes span records. Reservation and allocator
  costs are excluded; rleRender() requests a 256-span reservation.
- RLE does not guarantee smaller memory or lower wall time for this small shape.
- cRasterPixels() aligns the destination then can write two 32-bit pixels per
  uint64_t store; rasterPixel32() can select SIMD with other build settings.

Motion meaning
- Independent action streams share an illustrative clock: one coverage read/decision
  or one pixel write takes one model slot (0.24 seconds). Not CPU instructions,
  cycle counts, a measured benchmark, or a claimed 98/73 runtime speedup.
- Dense: 54 reads/decisions + 44 writes = 98 actions, completed at model t=24.52.
- RLE: 29 reads/decisions + 44 writes = 73 actions, completed at model t=18.52.
- Orange cursor remains on one RLE span while its pixels are written. Dense must
  revisit coverage for each pixel, including 10 zero-coverage cells with no write.
- Upper strips accumulate orange read/decision tokens and blue write tokens.
  Token widths and slot durations are identical on both sides.
- Each lane reveals its completion label and total independently. RLE remains
  complete for six seconds while Dense continues. Final pixel values match.
- Memory payload comparisons remain in MDX; final movie labels emphasize action
  totals and identical 44 writes. RLE construction, cache, and SIMD costs omitted.
- Input/output grids show the common crop, not the full stride-sized allocation.

Beat ledger
1. t=0: same coverage data as dense cells and begin-pixel/length spans; blank outputs.
2. t=1: both action streams begin; orange read and blue write tokens accumulate.
3. t=4.84: long-span work shows consecutive RLE writes without re-reading coverage.
4. t=18.52: RLE is complete; Dense still has outstanding writes and continues.
5. t=24.52 through 27.64: both complete; same pixels, different action totals.

Checks
- Independent dense integer raster result equals the actual engine's full buffer.
- Independent JS action replay checks initial, all 98 settled steps, and final:
  10800 output cell checks with a separate progressive memory state per lane.
- At RLE completion, all RLE output pixels match the engine, Dense still has
  outstanding writes, and only RLE's completion label is visible.
- All 54 input coverage cells, 29 begin/len glyphs, and 171 final action tokens
  checked against engine records and independently constructed model actions.
- Cursor identity counts: 54 dense entries and 29 span reads.
- Independent engine variant first vertex x=2.0 updates both outputs correctly.
- All 831 frames audited for Text/Text gaps and canvas bounds; 15 standalone labels.
- Canvas margin minimum 77.81px. Theme Pro White, Pretendard, 2400x1500, 30fps.
- Duration 27.64 seconds; MP4 831 frames (27.7 sec); full decode passed.
- Target MDX compile passed with zero messages.
- No additional inline generated-raster review or manual 1x playback: the thread's
  inline raster review budget was exhausted in earlier work.

Temporary PNGs are written under LUA/temp/rle-engine and removed after checking.
The sizeof probe source/output are kept under LUA/temp/rle-compare as text evidence.
