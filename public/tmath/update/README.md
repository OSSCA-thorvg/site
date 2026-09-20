# Update / Prepare scenes

Source baseline: ThorVG `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad`.
The neighboring engine checkout and the reference worktree are read-only.

These scenes explain preparation, from API changes and Scene traversal to reusable
Shape/Image data. Diagram reveals illustrate dependencies, not worker scheduling or
measured CPU time. Canvas rasterization belongs to the following Draw/Raster article.

| Scene | Authoring source | Question |
| --- | --- | --- |
| `overview` | `overview.mjs` | How do API updates reach prepare tasks and Draw's completion barrier? |
| `tasks` | `tasks.mjs` | How do Shape/Image tasks own RenderData, run, complete and survive for reuse? |
| `render-data` | `render-data.mjs`, `render-data-model.mjs` | What do Shape, Text, bitmap and Gradient retain for Draw? |
| `bitmap-data` | `bitmap-data.mjs`, `bitmap-native.mjs` | Which actual members distinguish Direct, Scaled, general affine and clipped bitmap preparation? |
| `first-frame` | `prepare.mjs`, `prepare-model.mjs` | How do new A/B Shapes acquire the data retained for the next frame? |
| `invalidation` | `prepare.mjs` | Which inherited flags and inputs cause preparation or reuse? |
| `shape` | `prepare.mjs` | When are Rect bounds, fill/stroke RLE and gradient data prepared? |
| `image` | `prepare.mjs` | What does Picture/Image prepare before sampling? |
| `cells` | `rle.mjs` | How does an outline accumulate band-local cover and area? |
| `sweep` | `rle.mjs` | How do cell accumulators become coverage spans? |
| `pool` | `rle.mjs` | Which memory is temporary, and what happens when a band cannot fit? |

Edit the authoring modules, then regenerate the standalone Lua and matching final-frame
WebP posters. Do not hand-edit generated `.lua` files.

```sh
node scripts/render-update-scenes.mjs
```

Pass scene IDs to render a subset, e.g. `node scripts/render-update-scenes.mjs overview`.
The generator reloads each compiled Lua into the delivered CPU WASM runtime, checks
text visibility, bounds, spacing and declared containment at every 30fps frame plus the
exact final time, and renders each recorded beat. It publishes scenes/posters only
when layout checks pass. Review files go to the OS temporary directory under
`thorvg-update-review`; override with `TMATH_UPDATE_REVIEW_DIR`.

All screen copy uses short English labels. Pro White, Pretendard, thin monochrome
structures, and orange/blue input identities are shared across the series.
The Overview's triangle spans come from the existing native postprocessing trace;
the source colors in its 2×2 image are input data, not sampled Canvas output.

`first-frame` precedes `invalidation` with matching A/B identities and prepared-data
slots. Path and solid fill APIs mark `Path | Color`; `SceneImpl::insert()` marks
`Transform` on each added Paint, including the parent Scene added to the Canvas.
Both new tasks therefore receive `Path | Color | Transform`. A native two-frame
probe verified those flags, null initial RenderData, two distinct allocated tasks,
and an untouched Canvas buffer after Update. After Draw/Sync, translating A by
`(2, 1)` or `(-1, 3)` preserves both task pointers, schedules only A with `Transform`,
and preserves B's bounds and every RLE span. The five-bar output glyphs match the
existing next-frame scene; they represent retained data without encoding RLE values.

The RenderData comparison uses the same native triangle spans. Like the Shape
article's `sw-rle-creation`, each span is a starting pixel at `(x + .5, y + .5)`
with alpha `coverage / 255`, followed by a line of `len` grid steps from its center.
The line ends at the excluded end position; it does not add another covered pixel.
White pixel backings prevent underlying length lines from darkening the coverage
marks. Rows reveal their starting pixels before their length lines grow.
Its glyph outline
comes from `../font/native-trace.mjs` (Public Sans A); it shows Text's internal Shape
delegation without substituting triangle spans for glyph coverage. The four bitmap
cells display the source pixels directly. Its opaque two-stop Pad gradient ports
`tvgSwFill.cpp::_updateColorTable`, including byte interpolation and the final-stop
override. All 1,024 RGB entries were compared with the pinned native function for
the displayed stops and an asymmetric alternate pair. The displayed table has
overlapping subpixel strips to keep antialiasing from washing out its colors.

The comparison names the actual members of `SwTask`, `SwShape`, `SwImage`, and
`SwFill`. The companion `bitmap-data` scene compares three independent Pictures
using the same 2×2 source, a 12×12 viewport, and Bilinear filtering. Colored cells
show the source geometry under each affine transform, not resampled Canvas output.
The Direct branch consumes `ox/oy`; `scale` is not initialized in that branch and
is deliberately absent. `scaled` is only assigned in the non-Direct branch and
does not imply a uniform scale. Transform and curBox belong to SwTask, filter to
SwImage. None of the unclipped cases retains an image RLE. The triangle Clip case
retains 27 native coverage spans, drawn using the same alpha/length convention as
the Shape comparison. All native cases prove the source-data alias and untouched
Canvas pixels after Update.

Refresh its recorded evidence with the static build described below:

```sh
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I"$thorvgBuild" -I"$thorvgSource/inc" -I"$thorvgSource/src/common" \
  -I"$thorvgSource/src/renderer" -I"$thorvgSource/src/renderer/cpu_engine" \
  scripts/update-bitmap-native-trace.cpp "$thorvgBuild/src/libthorvg-1.a" \
  -lpthread -o /tmp/update-bitmap-native
/tmp/update-bitmap-native
/tmp/update-bitmap-native translated
```

`bitmap-native.mjs` stores the first JSON result as its default export and the translated fixture as `variant`. `image-native.mjs` similarly records both Image preparation fixtures. Passing the
translated result to `buildBitmapData({trace})` shifts all source-derived geometry,
integer offsets, bounds, Clip points and spans without editing presentation values.

Native evidence can be refreshed against a CPU static build of the pinned ThorVG
revision. Set `thorvgSource` to that checkout and `thorvgBuild` to its build directory
(containing `config.h` and `src/libthorvg-1.a`). The probes read the original engine
translation units without changing them:

```sh
thorvgSource=./thorvg
thorvgBuild=/tmp/thorvg-cpu-4d5810cf-build

c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I"$thorvgBuild" -I"$thorvgSource/inc" -I"$thorvgSource/src/common" \
  -I"$thorvgSource/src/renderer" -I"$thorvgSource/src/renderer/cpu_engine" \
  scripts/update-image-native-trace.cpp "$thorvgBuild/src/libthorvg-1.a" \
  -lpthread -o /tmp/update-image-trace

node scripts/generate-update-prepare-trace.mjs
```

The image probe checks the baseline and an integer translation, compares internal
RLE spans with the public Picture API, and asserts that Update leaves Canvas pixels
untouched. The preparation tests also distinguish premultiplication from opacity
multiplication; their rounding rules differ.

```sh
c++ -std=c++17 -DTVG_STATIC \
  -I"$thorvgBuild" -I"$thorvgSource/inc" -I"$thorvgSource/src" \
  -I"$thorvgSource/src/renderer" -I"$thorvgSource/src/renderer/cpu_engine" \
  -I"$thorvgSource/src/common" scripts/update-rle-native.cpp \
  "$thorvgBuild/src/libthorvg-1.a" -o /tmp/update-rle-native
node scripts/update-rle-generate.mjs /tmp/update-rle-native
```

The RLE probe uses a curved path and a quarter-pixel translation. It compares the
recorded cells, accepted curve chords and spans with native RLE functions, and checks
that reduced-pool band retries produce the same result as the default pool. The
`[1,1,7,5]` domain and `[2,4)` focus band are selected for observation; the public
Shape API computes `[1,1,6,6]` for this path, with the same sixteen output spans.
The 192-byte pool demonstrates overflow; it is not the default allocation.

## RenderPath migration (4d5810cf)

- `SwOutline` now keeps `const RenderPath* path`, fixed `out`, and `fillRule`.
  Plain Shapes borrow `RenderShape::path`; trim/dash/stroke and Image rectangles
  construct paths in `SwMpool::paths`. RLE traverses commands and reads exported
  points. The RLE harness supplies this real command/point representation.
- `fillPrepare()` replaces the former Shape-level gradient helper. Prepared Fill,
  RLE, task completion and separate destination lifetimes remain unchanged.
- Source anchors and the native Shape/Image/Bitmap/RLE fixtures use the same pin.
- Run `node scripts/render-update-scenes.mjs --variant render-data bitmap-data image cells sweep pool`
  for full-frame alternate audits without replacing baseline exports. The single
  input translation changes geometry, bounds, offsets and recorded spans together.
- 6 targeted tests validate primitive/public Picture agreement, source aliases and
  distinct Bitmap branches, premultiplication, signed Cell sweep and reduced-pool
  capacity, and all 1,024 opaque Pad gradient RGB entries. The Fill variant changes both ColorStop swatches and the complete table. Native generators additionally assert untouched Canvas bytes after Update.
