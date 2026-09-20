# Fill overview

`overview.mjs` is the authoring source; `overview.lua` and `overview.webp` are the
player assets. The 1280×2000 scene uses the same caller spine, horizontal bands,
black key nodes, neutral outlines and Pretendard font as the CPU overviews.

```sh
node scripts/render-fill-overview.mjs
node scripts/render-fill-overview.mjs --variant
```

The six beats introduce Fill types, enter Prepare, expose SwFill data, select a
Draw lookup, show independent color/coverage inputs, and write the example pixels.
Only visibility and destination pixels change. Both Gradient types are alternatives
at the same x coordinate and width; they do not execute together. The final frame
retains the full diagram. The non-solid table path and the one-stop / degenerate solid shortcut remain visible.
The canvas includes 240 pixels of bottom space for mobile player controls.
Masking and special blending modes are covered by the detailed Raster articles.

## Evidence

The relationship map was checked against local ThorVG `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad`:

| Claim | Source |
| --- | --- |
| Shape attaches a Fill; Linear/Radial share its settings | `inc/thorvg.h`, `src/renderer/tvgShape.cpp` |
| Task prepares fill after relevant update flags | `src/renderer/cpu_engine/tvgSwRenderer.cpp`, `SwShapeTask::run` |
| Allocate/reset SwFill and prepare color/geometry | `tvgSwFill.cpp`, `fillPrepare`, line 808 |
| One stop returns before geometry; degenerate geometry uses the final stop | `tvgSwFill.cpp`, `fillPrepare`, `fillFetchSolid`, lines 820, 841 |
| Color stops produce a premultiplied 1024-entry table | `tvgSwFill.cpp`, `_updateColorTable`, line 188 |
| Linear/Radial turn coordinates into spread-aware color lookup | `tvgSwFill.cpp`, `fillLinear`; `fillRadial` |
| Draw selects Rect or RLE and Gradient type | `tvgSwRaster.cpp`, `rasterGradientShape`, line 1538 |

The small Linear+RLE example uses the existing `raster/native-trace.mjs` fixture
regenerated at `4d5810cf`. `traceGradient()` replays that table, fixed-point lookup,
span coverage and output byte arithmetic. Table strips sample that exact table;
span glyphs and final pixels come from the same records. Radial is a relationship
branch, not an invented numerical simulation. The coverage glyph consists of a
start marker and a thin line spanning `len` pixel pitches.

The render script checks every example pixel against the native fixture and audits
all frames for text visibility, canvas bounds, containment and route/text gaps.
`--variant` permutes RGB channels in the input table: output colors must change by
the same permutation while RLE coverage stays fixed. It exports review frames
only, without replacing the published baseline. Temporary renders are moved outside public after review.

Revision validation: baseline and channel-permuted variant each pass 351 frame
checks at 30 fps, duration 11.66 s. The separate native gradient regression covers
no-Fill allocation, single-stop Linear/Radial with singular transforms, degenerate
geometry, ordinary geometry, and multi-stop singular-transform rejection.
See `../raster/gradient-regression.mjs` and the reproduction command there.
