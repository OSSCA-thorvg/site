# Fill overview

`overview.mjs` is the authoring source; `overview.lua` and `overview.webp` are the
player assets. The 1280×1780 scene uses the same caller spine, horizontal bands,
black key nodes, neutral outlines and Pretendard font as the CPU overviews.

```sh
node scripts/render-fill-overview.mjs
node scripts/render-fill-overview.mjs --variant
```

The six beats introduce Fill types, enter Prepare, expose SwFill data, select a
Draw lookup, show independent color/coverage inputs, and write the example pixels.
Only visibility and destination pixels change. Both Gradient types are alternatives
at the same x coordinate and width; they do not execute together. The final frame
retains the full diagram. The ordinary Gradient path is the scope; solid-color
fallback, masking and special blending modes remain in the detailed articles.

## Evidence

The relationship map was checked against local ThorVG `b4471844`:

| Claim | Source |
| --- | --- |
| Shape attaches a Fill; Linear/Radial share its settings | `inc/thorvg.h`, `src/renderer/tvgShape.cpp` |
| Task prepares fill after relevant update flags | `src/renderer/cpu_engine/tvgSwRenderer.cpp`, `SwShapeTask::run`, lines 135–158 |
| Fill creation delegates to color/geometry preparation | `tvgSwShape.cpp`, `shapeGenFillColors`, line 513 |
| Geometry is prepared by type; table refresh is conditional | `tvgSwFill.cpp`, `fillGenColorTable`, line 774 |
| Color stops produce a premultiplied 1024-entry table | `tvgSwFill.cpp`, `_updateColorTable`, line 124 |
| Linear/Radial turn coordinates into spread-aware color lookup | `tvgSwFill.cpp`, `fillLinear`, line 660; `fillRadial`, line 364 |
| Draw selects Rect or RLE and Gradient type | `tvgSwRaster.cpp`, `rasterGradientShape`, line 1684 |

The small Linear+RLE example uses the existing `raster/native-trace.mjs` fixture
captured at `cdc1c959`. `traceGradient()` replays that table, fixed-point lookup,
span coverage and output byte arithmetic. Table strips sample that exact table;
span glyphs and final pixels come from the same records. Radial is a relationship
branch, not an invented numerical simulation. The coverage glyph consists of a
start marker and a thin line spanning `len` pixel pitches.

The render script checks every example pixel against the native fixture and audits
all frames for text visibility, canvas bounds, containment and route/text gaps.
`--variant` permutes RGB channels in the input table: output colors must change by
the same permutation while RLE coverage stays fixed. It exports review frames
only, without replacing the published baseline. Temporary renders live in `temp/`.
