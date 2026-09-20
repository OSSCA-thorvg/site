# CPU Engine · Mask / Clipping / Viewport

Three portable tmath overviews, backed by unmodified ThorVG CPU execution at
`4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad` (`site/thorvg`).

## Existing Overview analysis and layout

- `update/overview.mjs`: caller spine, inherited Paint context, separate Shape /
  Image preparation, RenderData artifacts, and the Draw `done()` boundary.
- `raster/dispatch.mjs` / Raster dispatch: persistent aligned branches, separate
  geometry/coverage and color inputs, independent demonstrations, explicit
  Image RLE and compositor alternatives.
- `postprocessing/overview.mjs`: white control nodes versus dark pixel-processing
  nodes, offscreen snapshots, saved/restored Surface context, real output pixels.

All three overviews use six top-to-bottom bands on a 1440 × 3260 canvas.
Numbered explanations sit on the right of a detailed caller pipeline with solid
Canvas and Scene boundaries. Within a band, inputs and outputs read left-to-right.
Each page follows one avatar Scene containing a photo Picture and a badge Shape.
The API band shows setup and inputs; rendered output appears in later bands.

`overview.mjs` dispatches to the three feature builders. `overview-kit.mjs` shares
layout, typography, pixel grids, RLE glyphs, routes and local animation helpers.
Clipping's compiled Lua is unchanged by extracting these helpers.

| Overview | 01 | 02 | 03 | 04 | 05 | 06 |
| --- | --- | --- | --- | --- | --- | --- |
| Mask | Paint::mask example | Mask source / target / method | Target then child preparation | Grayscale8 mask storage | Photo and badge group Surface | Group through mask; restore context |
| Clipping | Paint::clip example | Shape reference / CPU task | Shared child clip context | SwRle / SwSpan | Child RLE intersections | Accumulated Draw |
| Viewport | Canvas::viewport example | RenderRegion | Child task clipBox capture | Image bounds / Shape spans | Whole-target clear policy | Accumulated Draw |

All sections remain visible. Six local clocks have phases 0.4, 1.5, 2.6, 3.7,
4.8 and 6.0 seconds in an eight-second period. Motion demonstrates copying
references or bounds, scanning retained coordinates, revealing native RLE,
clearing storage and writing pixels. Final result grids stay fixed. There is no
global entrance or sequential section reveal. The complete poster contains the
whole explanation, with only transient working overlays hidden.

Mask's final group/composite writes and Clipping/Viewport's final photo/Shape
writes keep their completed row images until the next local loop. They do not
fade back to the full bitmap after completion, avoiding a visible sampling shift.

The pipeline describes source-grounded calls and data dependencies. Task
submission is distinct from worker completion: worker preparation nodes explain
the respective Image and Shape work, not a required relative scheduling order.
Draw waits at each task's done() boundary; sync follows Draw. The native harness
uses synchronous task execution. Review times are 0, 0.8, 2.4, 4.6, 6, 7.6 and
exact loop end; local phases are not a global execution schedule.

Layers: static pixels 10, working buffer 20, writes 25, grid 35, routes 50,
region borders 55, cursors 65, text 80. Source details live in an optional page
disclosure. Page and animation text are English.

## Native evidence and limitations

`scripts/cpu-regions-native.cpp` includes the pinned `tvgSwRenderer.cpp` for
Task inspection and links the same engine library. Public update/draw/sync
produces all outputs. No engine file is edited. Fixtures record source and
clip RLE coverage, task clipBox/curBox, restored viewport, clip count,
FastTrack, compositor allocation count, saved mask bytes and output pixels.

The displayed fixtures use a 16×12 avatar photo and a green circular badge:

- `maskAvatar`: an Alpha mask on the Scene, circle center (8, 5.5), radius 5,
  fill alpha 160. The harness captures Mask ownership, both child tasks, mask
  geometry RLE, Grayscale8 bytes, the assembled color group, final pixels and
  restored context. It asserts two compositor buffers and child opacity 255.
  The variant moves the mask center to x=7.25 and changes alpha to 96; group
  pixels remain unchanged. Mask coverage scales fill alpha, then the stored
  mask byte scales the premultiplied group pixel during composition.
- `avatar`: one circular Scene clip, shared by photo and badge. See below.
- `viewportAvatar`: viewport (4, 2, 8, 7), moved to x=5 in the variant. Both
  tasks capture the same clipBox. The image uses direct bounds with null RLE;
  the badge's native spans stop at the viewport. Original pixel coordinates
  remain unchanged. Both Prepare grids show the same viewport boundary and
  scan only its rows/columns; RLE row reveals follow that scan. Baseline badge
  spans all have len=1, so no length segments are drawn. The shifted variant
  also exercises len=2 segments. Separate first draws capture photo-only and full Scene
  output with clear=false and clear=true. No compositor is allocated.

`model.mjs` validates spans, mask bytes, premultiplied output channels,
context restoration, group stability, viewport bounds and outside pixels.
Scan conversion is observed from the engine, not synthesized in JavaScript.
The prior Alpha, InvAlpha, Luma, rectangular fast-path, curved Clip, Rect Clip
and viewport fixtures remain as regression coverage; they are not the new
Overview's example. Other mask methods, Image Texmap and later dirty-region
updates are outside these displayed paths.

Premultiplied pixels are flattened over a checkerboard. Coverage grayscale
encodes 255 as black. Region outlines denote bounds, not framebuffer writes.
The changed inputs update dependent cells and labels without changing the photo
or badge geometry. Whole-target clear is separate from viewport-restricted
rendering; the keep/clear comparison uses independent first draws.

## Reproduce

```sh
meson setup /tmp/thorvg-cpu-4d5810cf-build thorvg \
  -Ddefault_library=static -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= \
  -Dtests=false -Dsimd=false -Dextra= -Dthreads=false
meson compile -C /tmp/thorvg-cpu-4d5810cf-build
c++ -std=c++17 -O2 -ffp-contract=off -fno-access-control \
  -I/tmp/thorvg-cpu-4d5810cf-build -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/cpu-regions-native.cpp /tmp/thorvg-cpu-4d5810cf-build/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-cpu-regions-native-4d5810cf
node scripts/generate-cpu-regions-trace.mjs /tmp/thorvg-cpu-regions-native-4d5810cf
node scripts/render-cpu-regions.mjs
node scripts/render-cpu-regions.mjs --variant
```

The renderer audits text at every 30fps frame, explicit text policies, canvas
bounds, pairwise text clearance, exact decoded loop seam, local motion in
every section and every completed grid-cell center against model display bytes.
`--quick` uses sparse layout samples for iteration and never publishes assets.
Move the source-local `temp/` review directory outside `public/` before site
builds. Published assets are the three Lua sources and completed WebP posters.

## Clipping: one native avatar Scene

`clipping-overview.mjs` is selected by `buildOverview('clipping')`. All six
sections use `trace.avatar`: background Shape, avatar Scene with photo Picture
and badge Shape, and a circular roundClip Shape.
The first section contains public API setup and unmodified inputs only. Purple
always denotes the roundClip reference/task; the photo bitmap and green badge are
explicitly labeled Picture and Shape inputs. Completed pixels appear in Draw.

The harness asserts that Paint::clip stores a Shape pointer before a CPU task
exists. Update creates one SwShapeTask with clipper=true; both child tasks keep
that same handle. It captures native clip/photo/
badge spans, unmodified badge coverage, the photo-only draw and final Scene draw.
`avatarModel` expands spans, checks both intersections and that the Shape draw changes only badge pixels.
The variant moves circle center x from 8 to 7.25; it does not replace the example.

Six local phases: 0.4, 1.5, 2.6, 3.7, 4.8 and 6.0 seconds. Pixel writes use row
images to stay within the portable runtime's scene object limit. Scene source,
posters and every rendered cell are verified by the existing render audit.

RLE display convention
- Coverage is the grayscale intensity of the span's first pixel.
- A len > 1 span connects its first and last pixel centers; the displayed
  segment covers len - 1 cell intervals. A len = 1 span has no line or end cap.
- Overview sections 04/05 use native SwSpan records, including the unclipped
  badge spans. Rows reveal those records, not expanded filled pixel runs.
- The Image RLE pair shares the spanGlyph implementation through its existing
  seed builder and uses the same convention. The final Draw result stays fixed.

Draw overview: background -> photo rendered -> shape rendered -> result.
These are accumulated snapshots of the same Main Surface, not separate buffers.
Photo and Shape steps reveal pixel writes without scan cursors; Result stays
fixed. The RLE section uses the general coverage formula without sample outlines.

## Revision migration

The native oracle was rebuilt against `4d5810cf` with scalar CPU / zero worker threads. Both complete baseline and asymmetric variant records are deeply equal to the preceding fixture, including clip task identity predicates, regions, spans, intermediate pixels, final pixels and compositor state. Image/Shape outlines now consume RenderPath commands; these public-operation traces need no adapter. Paint parent context now propagates recursively through nested clips/masks; the ownership regression is documented in `../paint-lifetime/`. The regional rendering call flow is unchanged.
