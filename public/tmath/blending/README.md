# CPU Blending overview

Source revision: `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad`.
English diagram labels, Pretendard; 1440 × 3880, 30 fps,
eight-second automatic loop and a completed WebP poster.

## One example through the pipeline

Two opaque rounded rectangle Shapes on a transparent 18×13 ABGR8888 target:
blue destination at (2,1), orange source at (6,4), both 9×7 with radius 1.5.
The source uses Multiply. Normal and Screen reuse the same geometry for the
fixed comparison at the bottom. The checkerboard is display-only.

`native-trace.mjs` records public Canvas update/draw/sync output, SwShapeTask
clipBox/curBox/opacity/clips/fastTrack, and actual SwRle/SwSpan records. Separate
native destination-only and source-only executions supply the inputs and
intermediate destination buffer. Every mode renders independently. A plain
rectangle control proves that axis-aligned rectangles can take fastTrack with
no SwRle. The variant changes source RGB and x position, including its partial
coverage, overlap corner sample and output pixels.

`model.mjs` independently checks all native pixels using scalar CPU integer
MULTIPLY, ALPHA_BLEND and INTERPOLATE behavior. Source fill alpha is 255;
destination alpha includes transparent and partially covered pixels. Multiply
includes the pinned destination unpremultiplication and premultiplication
branches. It is not a general blend-mode emulator.

## Seven persistent sections

Solid scopes contain Canvas update and draw on the left. Numbered explanations
remain on the right. Every section has its own repeating mechanism and phase;
all explanatory labels are present from frame zero.

| Section | Local mechanism |
| --- | --- |
| 01 API | Construct the two input paths; retained order is d then s |
| 02 Update | Materialize both native RLEs from their prepared tasks |
| 03 Draw d | Populate the cleared target with the blue Shape |
| 04 Draw s | Bind Multiply to the Surface blender; show alternative raster paths |
| 05 Read / blend | Calculate RGB channel lengths for a full overlap pixel |
| 06 Coverage | Interpolate original D toward B at a native rounded-corner pixel |
| 07 Write | Accumulate d then s in place; keep final mode comparisons fixed |

Prepare work may run on workers. The scheduling branch and postUpdate return
are separate; renderShape calls task->done() before consuming its data.
Path/Transform/Clip changes generate geometry; a Blend-only change can reuse
it. Rounded solid Shapes take _rasterBlendingRle in this example. Rect,
gradient, stroke and image alternatives are shown separately, along with the
solid RLE dispatch priority for compositing / custom blend / normal drawing.
The article disclosure covers general image transforms and composited Scenes.

RLE convention matches the other ETC overviews: coverage is the first pixel's
shade; len > 1 is a segment joining the first and last pixel centers;
len = 1 has no segment or end cap. RGB bars demonstrate arithmetic in place.
There are no finishing transforms. Completed writes hold until their local
loop restarts. All three final native comparison grids remain fixed.

Pixel fields use exact rectangular cells to avoid nearest-image sampling
shifts when magnified. The camera is fixed at 100 pixels/world unit. Routes
use 3.5 px strokes; text is above pixels and spans. Every label has a standalone
or owner containment policy. The separate poster shows completed mechanisms.

## Reproduce

Use a static CPU-only build, with SIMD and threads disabled, for the oracle:

```sh
meson setup /tmp/thorvg-blending-build thorvg \
  -Ddefault_library=static -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= \
  -Dtests=false -Dsimd=false -Dextra= -Dthreads=false
meson compile -C /tmp/thorvg-blending-build
c++ -std=c++17 -O2 -ffp-contract=off -fno-access-control \
  -I/tmp/thorvg-blending-build -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/blending-native.cpp /tmp/thorvg-blending-build/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-blending-native
node scripts/generate-blending-trace.mjs /tmp/thorvg-blending-native
node scripts/render-blending.mjs
node scripts/render-blending.mjs --variant
```

The existing `/tmp/thorvg-cpu-regions-build` with those settings can also be
reused. The harness includes the renderer implementation for read-only Task
inspection; it does not modify engine code.

The renderer audits every 30 fps frame plus the loop endpoint: explanatory
text visibility, canvas/owner containment, text gaps and route/text/grid
clearance. Native pixel and RLE probes verify the completed poster; motion
probes check the destination and source writes against their native buffers.
It also verifies span endpoints, singleton rules, channel-bar geometry,
independent motion in all sections, an exact decoded loop seam and fixed final
comparison grids. Both baseline and changed-input fixtures must pass.
`--quick` is a sparse review and never publishes assets.

Source-local `temp/` contains PNG reviews and audit JSON; move it outside public
before site builds. The variant never replaces published assets. Browser review
covers automatic looping, pause/seek/resume, both players and mobile width.

## Full BlendMethod gallery

`gallery/` adds 17 color modes × four inputs (68 lossless native CPU previews).
`Composition = 255` is explained separately in the article as an intermediate
composition setting. It is not presented as a color mode.

Example reference: sibling `thorvg.example/src/Blending.cpp` and
`SceneBlending.cpp`, revision `8df10a059239b033f82961af9294b3f9bea0a350`.
The original example has six input columns: opaque Solid, half-transparent
Solid, Gradient, Bitmap, SVG Picture, half-transparent SVG Picture.
Our gallery reconstructs the first three at 128×128 and adds midtone Solid to
discriminate modes. It does not claim to capture the original Bitmap/SVG columns.
The page retains the mode table and comparison gallery; the longer example walkthrough has been removed.

`blending-gallery-native.cpp` uses public Canvas APIs with the pinned engine.
Rounded rectangles are at (12,12)/(32,32), size 80×80, radius 8, over transparent
storage. Per-mode output is independent. See the article for colors/stops.
`manifest.json` keeps native premultiplied RGBA at overlap pixel (60,60).
The generator flattens premultiplied pixels over a display-only checkerboard;
the checkerboard is not part of the native destination Paint. All channels
in previews are preserved by lossless WebP. The selector changes the input of
all 17 previews together; captions expose native values before flattening.

```sh
c++ -std=c++17 -O2 -I/tmp/thorvg-cpu-regions-build -Ithorvg/inc \
  scripts/blending-gallery-native.cpp /tmp/thorvg-cpu-regions-build/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-blending-gallery-native
node scripts/render-blending-gallery.mjs
```

Raw review buffers go to `gallery/temp/`; move them outside `public/` before
building. Tests check all 68 fixtures, independent opaque color expectations,
all preview overlap pixels and transparent-exterior display backgrounds.

## 17-mode animation

`modes.mjs` / `modes-model.mjs` → `modes.lua` / `modes.webp`.
1280×1360, 30 fps, six-second loop. All 17 diagrams and labels remain visible.
A shared source translation makes the comparison simultaneous. Destination
stays fixed; the overlap rectangle is derived from the same source displacement.
Colors remain the exact native opaque RGB samples rather than interpolating
between BlendMethods. The RGB label denotes the full overlap color even while
shapes are separated. Rectangles are schematic: no rounded corners or AA claim.

| Time | State |
| --- | --- |
| 0–0.8 | All modes overlap; fixed native result colors |
| 0.8–2.6 | All sources translate right; intersections shrink to zero |
| 2.6–3.4 | All sources are separate; destination remains intact |
| 3.4–5.2 | All sources return; intersections expand |
| 5.2–6 | Initial overlaps restored; exact decoded loop seam |

Main input: midtone; variant: yellow/cyan. Every mode uses one native manifest
record for its color and label. The 17-mode gallery and CPU implementation
excerpts remain on the page.

```sh
node scripts/render-blending-modes.mjs
node scripts/render-blending-modes.mjs --variant
```

Audits cover 181 time samples per input, all text visibility/ownership, 17 final
result colors, 340 source/destination probes during motion and a decoded pixel
comparison between time 0 and 6. Review files go to `temp/`; move them outside
`public` before build. Browser review checks at least two full loop cycles.


## Revision revalidation

The native harness was rebuilt against the unmodified 4d5810cf scalar CPU library
with worker threads disabled. Baseline and geometry/alpha variants preserve all
prepared spans, intermediate bytes and final public-API pixels. Existing scene
geometry and timing therefore remain unchanged. New Gradient destination branches
are documented in Draw/Raster; these examples use 32-bit destinations.
The 68 lossless gallery images also match every byte of new native renders.
The manifest pin was updated without regenerating identical image files.
