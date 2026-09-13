# Shape overview

One-shot, 1440 × 1850, 30 fps. The article loads `overview.lua` and uses
`overview.webp` as the settled poster. Edit `overview.mjs` and `model.mjs`.

```
node scripts/render-shape-overview.mjs --still
node scripts/render-shape-overview.mjs
```

## Evidence

`native-trace.mjs` records one 20 × 16 Shape with cubic curves, a concave notch,
and an inner contour using EvenOdd. A second fixture translates it by 0.25 px.
Source: ThorVG `cdc1c9596a5edebc159d5623d726febda7595896`,
`src/renderer/cpu_engine/tvgSwRle.cpp`. This animation's evidence revision is
explicitly separate from the older analysis revision mentioned in the article.

`scripts/generate-shape-overview-trace.mjs` instruments a temporary COPY of that
source and compiles `scripts/shape-overview-native.cpp` against a matching static
build. The original engine checkout is unchanged. To regenerate:

```
THORVG_BUILD=/path/to/matching/build node scripts/generate-shape-overview-trace.mjs
```

The probe records `_lineTo`, cumulative `_recordCell` updates, final sorted Cells,
Band success/failure, native RLE spans and ABGR8888 Canvas pixels. Coordinates
preserve 24.8 precision. A deliberately small 576-byte Cell pool produces five
successful bands: [0,4), [4,6), [6,8), [8,12), [12,16). Failed attempts remain
in the fixture but are omitted from playback. Band sizes are illustrative, not
production defaults. Assertions compare the entire RLE against the ordinary
pool and compare rasterized RLE against public Canvas output including stride.

`model.mjs` replays signed cover/area, row gaps, EvenOdd folding and adjacent-span
merges, asserting exact agreement with the native spans for both fixtures.
The Coverage grid is an explanatory view of Sweep output, NOT a temporary
bitmap that the engine subsequently compresses. Sweep builds RLE directly.

## Motion and notation

1. Commands consume indexed points and draw actual cubic/line segments.
2. Band boundaries move; each successful Band retraverses the Outline.
   Accepted native chords are vertically clipped for display; touched Cells
   appear in native recording order. Orange/teal distinguish negative/positive
   cover. These marks are not filled interior pixels or alpha values.
3. A left-to-right sweep reveals coverage with compact coordinate/value labels.
   First boundary/gap/zero/merge examples receive brief holds.
4. Coverage pixels and RLE append/merge updates appear together, Band by Band.
5. RLE storage accumulates while the working Cell buffer is reused.
6. After preparation, Draw traverses spans and reveals native Surface pixels.
7. The complete flow remains on screen at the exact endpoint.

Coverage uses white=0, black=255 in both grids. Each RLE span has ONE coverage
tile at (x,y). Its blue length marker starts at (x+0.5,y+0.5) and ends at
(x+0.5+len,y+0.5): precisely len pixel units from the start pixel's CENTER.
The blue line is a data marker, not encoded fill color or alpha. The final
Surface alone contains the solid blue paint composited onto white.

Timing is educational, not a CPU performance profile. Transform is identity;
Stroke/Dash/Trim, clip tasks, gradients and rectangle fast paths are not traced.

## Validation

The renderer registers the delivery Pretendard font in the site's CPU WASM
runtime. It audits every 30 fps frame plus the exact endpoint for text clipping,
4 px separation, and explicit text ownership policies. Still builds skip
the requirement that transient numeric readouts appear in a sampled frame.
Beat rasters and audit JSON are disposable `temp/` artifacts. Native assertions
are executed during trace generation; the renderer also replays the variant.

Presentation uses the Overview palette: neutral gray background, black node
labels and thin connectors. All visible labels are English; explanatory prose
and sweep formulas are omitted. Geometry and trace timing are unchanged.
