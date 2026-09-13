# Glyphs → one Shape

## Article overview

`overview.mjs` adds a 1280×2080 overview above the Font article's first section.
It matches the Fill/Picture caller spine, section dividers, thin neutral arrows,
black key nodes and Pretendard font. Six beats cover input, font loading, glyph
accumulation, Shape Prepare, Draw delegation and Surface output. Glyphs appear at
their placed coordinates; pixel rows are revealed in place. All earlier glyphs
remain in the same path, and the finished diagram remains visible.

The map was checked against local `b4471844`: `tvgText.h` constructor and
`TextImpl::load/update/render`, `tvgSfntLoader.cpp` `_build` (191), `request` (263),
`wrapNone` (276), `get` (559), and the shared Shape/SwRenderer prepare/render path.
The example is Public Sans ABC, no wrapping, solid fill. Other text layout modes
and font formats are outside this overview. `SwShapeTask` is the retained
RenderData object; the arrow order does not claim task execution finishes before
Prepare returns. Draw uses `done()` before consuming the prepared data.

It reuses the existing native path and baseline RLE/pixel fixtures below.
The unchanged `font-delegation-native-trace.cpp` executable was replayed for x=5
and x=8.5 using its pinned cdc1c959 build. The first exactly matches the published
baseline; the second is stored in `overview-translated.mjs`. Both native runs
assert the same internal Shape/task survives Update and Draw, Update leaves the
Canvas untouched, and an ordinary Shape produces the identical Canvas. The
translated variant keeps the glyph commands/points and changes both RLE and pixels.

```sh
node scripts/render-font-overview.mjs
node scripts/render-font-overview.mjs --variant
```

The script verifies the ABC/BAC path construction and native record invariants,
audits every frame's text bounds/containment and route gaps, and exports Lua plus
a final WebP. `--variant` writes review images only. Opaque display pixels are
computed by placing the captured premultiplied output on white. There is no new
font rasterizer, invented glyph shape or font binary in this overview.

## Glyph accumulation detail

`glyphs.mjs` animates the actual Public Sans outlines for `ABC`. Each glyph's
copy moves to `point + cursor + offset`; the original cached outline stays put.
The committed output preserves all earlier contours in one semantic Shape owner.
The two array strips append the same glyph's command and point ranges. Cursor
advance follows the append. Default wrapping, alignment and spacing are used;
these three glyphs have zero positioning offsets.

Native evidence: `scripts/font-glyphs-native-trace.cpp` includes the unmodified
`tvgSfntLoader.cpp`, replays `_build()` with native glyph metrics and positioning,
and compares every prefix with the actual `TextImpl::shape` path. The local
checkout is `cdc1c9596a5edebc159d5623d726febda7595896`. `_build()` and `wrapNone()`
are unchanged from the article's v1.1.1 baseline. The native checkout is unmodified.

Font: `thorvg/test/resources/PublicSans-Regular.ttf`, SHA256
`b577e9bc9887284e90aae5ad0699689ce36b5cd96207efbec68f77f8aed88379`.
Only extracted path coordinates are embedded; no additional font binary is shipped.

| Append | cursor before → after | Cumulative commands | Cumulative points |
| --- | --- | --- | --- |
| A | 0 → 1420 | 13 | 11 |
| B | 1420 → 2761 | 42 | 71 |
| C | 2761 → 4138 | 65 | 131 |

`native-trace.mjs` stores ABC plus a BAC perturbation: B first advances to 1341
and appends 29 commands / 60 points. The generator replays both fixtures before
authoring. Point addition uses float32 at each step, matching C++ `Point`; every
replayed point must equal the recorded native float exactly.

The portable tmath Path API supports one contour per graphical object. Each
native contour is therefore drawn with its exact MoveTo/LineTo/CubicTo/Close
coordinates, under the common RenderPath owner. A new prefix is revealed over
identical earlier geometry during append and the old proxy is removed at commit.
This is a vector path accumulation animation, with no rasterization or boolean
union. It preserves counters and the inner contours of A and B. Motion is an
educational visualization of copying coordinates, not an engine execution timing.

The camera is fixed, Y-up, 1280×860; the coordinate conversion preserves the
native font's Y-down coordinates. Font units are scaled by 0.135 display pixels.
Source copies move as whole groups. Drawing layers separate structure, outlines,
moving copies, and labels. Text uses the site's Pretendard and a 4px gap ledger.

Regenerate the Lua and final-frame WebP:

```sh
node scripts/render-font-glyphs.mjs --still
node scripts/render-font-glyphs.mjs
```

The still is a camera/layout smoke test. The animated generator audits all 30fps
frames and the exact endpoint, then renders decisive beats under `temp/` for
review. The one-shot timeline is 16.9 seconds. Remove disposable `temp/` files
before building/publishing the site.

Refresh native fixtures from the site root:

```sh
meson setup /tmp/thorvg-font-native-cdc1c959 thorvg \
  -Dengines=cpu -Dloaders=ttf -Dsavers= -Dbindings= -Dextra= \
  -Dthreads=true -Dsimd=false -Ddefault_library=static -Dtests=false -Dbuildtype=debug
meson compile -C /tmp/thorvg-font-native-cdc1c959
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I/tmp/thorvg-font-native-cdc1c959 -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/loaders/sfnt \
  scripts/font-glyphs-native-trace.cpp /tmp/thorvg-font-native-cdc1c959/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-font-native-cdc1c959/trace
/tmp/thorvg-font-native-cdc1c959/trace thorvg/test/resources/PublicSans-Regular.ttf ABC
/tmp/thorvg-font-native-cdc1c959/trace thorvg/test/resources/PublicSans-Regular.ttf BAC
```

Place the resulting JSON records under the ABC/BAC keys of `native-trace.mjs`.

## Text → Shape delegation

`delegation.mjs` follows `TextImpl::update()` / `render()` through Paint dispatch
to the same `ShapeImpl`, then `SwRenderer::prepare()` / `renderShape(rd)`.
The retained Shape path is the ABC fixture above. Update stores the Shape task
in `ShapeImpl::impl.rd`; Draw waits with `task->done()` before using its data.
The scene's native example uses a solid fill with no outline, mask or effect.

`scripts/font-delegation-native-trace.cpp` records the actual RLE and a 96×48
ABGR8888 Canvas. It asserts that Update leaves pixels untouched, that Text keeps
the same internal Shape and the same Shape task across Update/Draw, and that a
separate public Shape with the same path and effective transform produces an
identical pixel buffer. Both x=5 and x=8.5 pass; their RLE and pixels differ.
The local build/revision and Public Sans font match the native trace above.

RLE marks use the series' start-pixel marker plus a len-pixel line. Colors encode
native coverage. The Canvas image composites premultiplied native bytes onto
white for display. Arrows are call/data relationships; reveal times do not
represent execution time or worker scheduling (the native fixture uses 0 workers).

```sh
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I/tmp/thorvg-font-native-cdc1c959 -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/font-delegation-native-trace.cpp /tmp/thorvg-font-native-cdc1c959/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-font-native-cdc1c959/delegation-trace
/tmp/thorvg-font-native-cdc1c959/delegation-trace
/tmp/thorvg-font-native-cdc1c959/delegation-trace translated
node scripts/render-font-glyphs.mjs --delegation --still
node scripts/render-font-glyphs.mjs --delegation
```

The baseline JSON is stored in `delegation-trace.mjs`. Six beats cover the retained
Shape, loading its glyph path, Update delegation, preparing/storing rd, Draw
delegation, and the shared raster output. Production size is 1280×1040.

## TTF quadratic → CubicTo

`curves.mjs` demonstrates degree elevation on a real Public Sans B segment,
then the implicit midpoint between consecutive off-curve points. Each example
uses one rotation and uniform scale to make its endpoint chord horizontal.
The input points, glyph inset, control geometry and output paths all come from
`curves-trace.mjs`; this is geometric construction, not loader execution timing.

`scripts/font-curves-native-trace.cpp` reads native TTF points/ON_CURVE flags
and calls the unmodified `TtfReader::convert()`. `curves-model.mjs` replays all
simple contours for B and C, including closure, and compares every output command
and float32 point to native output. Across 1,001 parameter samples per segment,
the maximum quadratic/cubic difference is below 0.00004 font units (float32
rounding). B and C provide different contour counts, consecutive controls and
closure cases; the scene uses B's explicit control at raw index 12 and consecutive
controls at indices 3 and 4. No font binary or engine changes are added.

```sh
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I/tmp/thorvg-font-native-cdc1c959 -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/loaders/sfnt \
  scripts/font-curves-native-trace.cpp /tmp/thorvg-font-native-cdc1c959/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-font-native-cdc1c959/curves-trace
/tmp/thorvg-font-native-cdc1c959/curves-trace B
/tmp/thorvg-font-native-cdc1c959/curves-trace C
node scripts/render-font-glyphs.mjs --curves --still
node scripts/render-font-glyphs.mjs --curves
```

Store native JSON under B/C keys in `curves-trace.mjs`. Six beats cover the
quadratic input, C1 at 2/3 from P0 toward Q, C2 at 2/3 from P2 toward Q, the
coincident cubic, implicit midpoint M, and two cubic segments meeting at M.
Production size is 1280×1080; final-frame WebP and Lua accompany the source.
