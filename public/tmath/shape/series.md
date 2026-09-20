# CPU Engine / Shape series

Source authority: ThorVG `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad`, read through `git archive` of the pinned
revision (the `./thorvg` checkout is only read). The site's first-H1 series metadata groups five pages in this order;
the Shape page and the Stroke, Dash, Trim and Fill Rule URLs are unchanged.

| Page / question | Lesson (six rows) | Native trace | Rows |
| --- | --- | --- | --- |
| Shape - 12: how does a path reach Surface pixels? | `cpu-lessons/shape-lesson.mjs` | `cpu-lessons/shape-trace/`, `shape/native-trace.mjs` | update flags pick the work · `utilExport()` 26.6 and `utilBBox()` · fast track for an axis-aligned rect · `rleRender()` bands and cells · `_sweep()` → `_horizLine()` · `renderShape()` → Surface |
| Stroke - 13: how does a centreline acquire width? | `cpu-lessons/stroke-lesson.mjs` | `cpu-lessons/stroke-trace/` | `strokeReset()` · `_lineTo()` borders · `_processCorner()` · `_cubicTo()` splits · `_endSubPath()` caps and one NonZero contour · transform after stroking, then RLE |
| Dash - 14: where does each painted fragment begin and end? | `cpu-lessons/dash-lesson.mjs` | `cpu-lessons/dash-trace/` | `shapeGenStrokeRle()` · `_genDashOutline()` pattern state · `_dashLineTo()` · `_dashCubicTo()` · `_dashClose()` leaves the pieces open · leftover thresholds |
| Trim - 15: which part of the path length is kept? | `cpu-lessons/trim-lesson.mjs` | `cpu-lessons/trim-trace/`, `trim/native-trace.mjs` | the outline sites that trim · `trim()` early returns and `_get()` · simultaneous · `_trimAt()` on lines · `_trimAt()` on cubics · begin ≥ end |
| Fill Rule - 16: how do contours become coverage? | `cpu-lessons/fill-rule-lesson.mjs` | `cpu-lessons/fill-rule-trace/`, `fill-rule/native-trace.mjs` | `fillRule()` → outline rule · signed cells · `_sweep()` cover · `_horizLine()` NonZero / EvenOdd · `rasterShape()` · CPU vs GL |

Each chapter uses its own fixture to isolate its question; they are not successive snapshots of one drawing. Stroke,
Dash and Trim reuse the GPU chapters' fixtures (`scripts/gpu-topic-example.h`, `scripts/gpu-stroke-path-example.h`) so
that their CPU results can be compared with the GL / WGPU captures; the shared comparison is
`cpu-lessons/compare-trace/`. The lessons follow the GPU lesson contract (`gpu-lessons/README.md`): every row keeps a
source-anchored left-hand flow and a local loop, and a separately settled poster shows every row complete.

Execution order differs from reading order. An enabled Trim cuts the path first: the fill trims in `_genOutline()`,
the stroke reuses that outline or trims itself, and a dashed stroke trims inside `_genDashOutline()` before dashing.
The trimmed path is not kept, so every outline rebuild (a `Path`, `Transform` or `Clip` update, and for the stroke
also a `Stroke` update) trims again.
Dash produces the open centreline pieces that the stroker reads. The stroker exports one NonZero outline, which
`utilExport()` transforms before RLE generation. An ordinary fill uses the rule selected by `fillRule()`, which
`_genOutline()` copies into the outline; `fillRule()` marks no update flag, so a rule change alone keeps the previous
RLE until another flag rebuilds the outline.

The Dash appendix contrasts the current seam behaviour with the reference repair proposal and the open ThorVG
PR #4838; the proposal and the PR are described from their text and diff, not executed.

The earlier chapter scenes (the overview players in `../stroke/`, `../dash/`, `../trim/` and `../fill-rule/`) are no
longer embedded; their native traces remain inputs of the new generators and lessons. The
Shape page keeps the earlier one-shot overview (`overview.lua`) as an appendix. Rebuild commands are in
`../cpu-lessons/README.md`.
