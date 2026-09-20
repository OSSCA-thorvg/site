# CPU Renderer — Draw/Raster

The article and executable models use ThorVG
`cdc1c9596a5edebc159d5623d726febda7595896` from the local `site/thorvg`
checkout. `model.mjs` ports the selected algorithms. `native-trace.mjs` is
generated evidence, not a list of invented animation outcomes.

## Source and numerical scope

| Model | Pinned source |
| --- | --- |
| Image dispatch | `tvgSwImage.cpp:imagePrepare`, `tvgSwRenderer.cpp:renderImage` |
| Gradient rectangle/span writes | `tvgSwRaster.cpp:rasterGradientShape`, `_rasterSolidGradientRect`, `_rasterSolidGradientRle`; `tvgSwFill.cpp:fillLinear` |
| Rectangle and span writes | `tvgSwRaster.cpp:_rasterSolidRect`, `_rasterSolidRle`, `rasterShape` |
| Direct image | `tvgSwRaster.cpp:rasterDirectImage`, `_rasterDirectImage`; `tvgSwRasterC.h:cRasterTranslucentPixels` |
| Nearest / bilinear / downsample | `tvgSwRaster.cpp:_interpNoScaler`, `_interpUpScaler`, `_interpDownScaler`, `_scaleMethod`, `SCALED_IMAGE_RANGE_X/Y` |
| Texture triangles | `tvgSwRasterTexmap.h:rasterTexmapPolygon`, `_rasterPolygonImage`, `_rasterPolygonImageSegment32`, `_modf`, `_feathering` |
| Byte composition | `tvgSwCommon.h:ALPHA_BLEND`, `INTERPOLATE`; `tvgRender.h:MULTIPLY` |
| Float predicates and edge AA | `tvgMath.h:zero`, `scaling`, `rightAngle`; `tvgMath.cpp:atan2` |

`model.mjs` emits destination coordinates, source coordinates, sampled texels,
nominal weights, intermediate colors and final premultiplied RGBA for each
write. Animation timings, magnification and movement of visual pixel copies
are presentation choices. Input pixels, shapes and matrices are fixtures;
sample positions, coverage, contributions and outputs are computed.

The port covers positive uniform axis-aligned scales, translation, the shown
affine texture case and solid shape writes on a 32-bit premultiplied surface,
with Normal composition, `alphaIgnored=false`, no compositor and no custom
blender. Classification also identifies RLE image variants, but the image
detail scenes do not implement image clipping, masking, custom blend modes,
grayscale, SIMD or multi-thread scheduling. Detailed gradient mathematics belongs
to the separate Fill article; the overview demonstrates its Rect/RLE writes. The model is an educational executable port,
not a replacement renderer for arbitrary inputs.

The texture port preserves the sorted triangle vertices, short/long edge
choice, upper/lower segments, float32 increments, XY/UV pre-step, row order,
two-stage interpolation and feathering. The affine example uses both triangles
`[0,1,3]` and `[1,2,3]`, not an inverse-transform substitute. `Math.fround`
preserves intermediate C++ float operations. The native harness uses
`-ffp-contract=off` for repeatable rounding in the included raster translation
unit. No CPU source file is modified.

Coverage for the ellipse is read from actual `SwShapeTask::shape.rle` after
public `Canvas::update()`. The model replays those native spans; it does not
pretend to port the preceding path-to-RLE scan conversion. Rectangle row
spans are a presentation view of its actual bounding-box loop. Both final
shape surfaces match public `Canvas::draw()` / `sync()`.

Gradient examples use an opaque LinearGradient from `(2,1)` to `(8,6)` with
three stops. The native harness captures the prepared 1024-entry Color Table, linear coefficients and `fillLinear()` samples at each actual
span start and length before coverage, and separately records the public Canvas
output. The replay ports the float32 initial position, fixed-point increments, rounding and Pad lookup into that table; every looked-up color matches the independently captured native sample. It applies `INTERPOLATE(sample, 0, coverage)` for partial Gradient
RLE spans (not the solid-fill `ALPHA_BLEND` path). Full-coverage rows preserve each
sample. Both 90-pixel surfaces match native output, including a second run that
changes a stop color and ellipse position. The overview displays Color/Color Table separately from the gray geometry/coverage grid. Actual lookup indices highlight the table, then coverage and color combine into writes. Stroke fixtures use the native strokeRle, including a transparent interior. The table strip samples real entries at display resolution; lookup markers and color bands use the exact addressed entries.

## Byte arithmetic

- Premultiplication (`MULTIPLY`): `(channel * alpha + 255) >> 8`.
- Opacity / coverage (`ALPHA_BLEND`): `(channel * (alpha + 1)) >> 8`.
- Interpolation: `floor((source * a + destination * (256 - a)) / 256)`.
- Source-over: attenuate source by opacity, then add destination attenuated by
  the inverse of the resulting source alpha.
- Scaled bilinear `dx/dy`: truncate `fraction * 255`; horizontal interpolation
  is truncated before vertical interpolation. Displayed tap weights express
  the product coefficients. They do not replace the staged byte operations.
- Texture bilinear `ar/ab`: `255 - (int(uv * 256) & 255)`, with separately
  truncated horizontal/vertical interpolation and native feathering.
- Downsample: `n=max(1,int(0.5/scale))`; sample a clipped `2n × 2n` window in
  increments of `int(n/2)+1`, then integer-divide each channel by tap count.
  It is a sparse mean kernel, not exact area resampling. The Y center uses
  `nearbyint` (ties to even), whereas the X center truncates.

## Fixtures and API

`buildScenarios()` returns objects keyed by the following names. Every object
has `source`, `initial`, `target` (`{width,height,pixels:[RGBA]}`), `steps`,
`matrix`, `filter`, `branch` and `sampler`. Step coordinates are zero-based.

| Key | Input / destination | Writes |
| --- | --- | --- |
| `direct` | 6×6 landscape, translation (2,1), 9×8 destination | 36 |
| `nearest` | same image, 2× scale, 12×12 destination | 144 |
| `bilinear` | same image, 2× scale, 12×12 destination | 144 |
| `downscale` | same image, 0.25× scale, 2×2 destination | 4 |
| `texmap` | matrix `[1.15,-0.35,3,0.45,1.1,1]`, 11×11 destination | 50 |
| `solidRect` | rectangle (2,2), size 6×5, 10×9 destination | 30 |
| `solidRle` | ellipse center (5.2,4.4), radii (3.1,2.7), 10×9 destination | 39 |
| `gradientRect` | same rectangle; opaque LinearGradient, native fixed-point samples | 30 |
| `gradientRle` | same ellipse; same gradient, native partial-coverage spans | 39 |
| `strokeSolid` | native ellipse stroke, width 1.5; independent strokeRle | native spans |
| `strokeGradient` | same stroke with LinearGradient | native spans |
| `composition` | premultiplied red overlay, opacity 160, landscape destination | 36 |

Sampling steps contain `x,y,sx,sy,taps,sample,rgba,before`. Each tap contains
`x,y,weight,rgba`. Downsample adds `kernel:{minx,maxx,miny,maxy,n,inc}`;
texture adds `triangle`, `scanline`, `dudx`, `dvdx`, `ar`, `ab`, `feather` and
`unfeathered`. Shape steps add `coverage` and `spanIndex`; `spans` and
`geometry` are also on the scenario. Composition steps include `source` and
`destination` for the two integer source-over contributions.

The downsample final pixel reads exactly `(1,2), (3,2), (1,4), (3,4)` from
window `[1,5) × [2,6)`, using `n=2` and `inc=2`. The gaps between samples
therefore remain visible in the scene. The source landscape has blue sky,
an off-center yellow sun, green terrain and water; the different colors and
asymmetry make wrong row order, axes and interpolation weights observable.

## Native reproduction

From the site root with Meson, a C++17 compiler and the pinned local checkout:

```sh
meson setup /tmp/thorvg-raster-native thorvg \
  -Ddefault_library=static -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= \
  -Dtests=false -Dsimd=false -Dextra= -Dthreads=false
meson compile -C /tmp/thorvg-raster-native
c++ -std=c++17 -O2 -ffp-contract=off -fno-access-control \
  -I/tmp/thorvg-raster-native -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/raster-native-trace.cpp /tmp/thorvg-raster-native/src/libthorvg-1.a \
  -o /tmp/thorvg-raster-native/trace
node scripts/generate-raster-trace.mjs /tmp/thorvg-raster-native/trace
```

The harness includes the unmodified `tvgSwRenderer.cpp` and `tvgSwRaster.cpp`
translation units and links the rest of the native static library. It calls
the real direct/scaled/texture entry points and packed byte helpers. Public
Canvas calls generate the RLE and final shape pixels. The scene does not
sample screenshots or use a different rasterizer to manufacture evidence.

Generation validates every channel of all twelve surfaces before writing the
fixture. A second native execution changes source texel `(3,2)` and moves the
ellipse center from `5.2` to `5.55`; tests require the corresponding outputs
and spans to change, and compare them to the recomputed model. Additional
native helper checks cover negative-edge coordinates, interpolation boundaries,
four downsample scales and 64 deterministic premultiplied byte pairs with
different opacity (416 helper result comparisons across the two runs).

Validation completed on macOS arm64, Apple Clang 21, the generic C CPU path.
The nine Node tests cover branch predicates, complete native outputs, changed
inputs, sampler/byte helpers, event replay, texture tap/triangle invariants,
display coordinate alignment, and characteristic overview sample selection.

## Scene generation and review

`node scripts/render-raster.mjs` compiles the scene builders to portable Lua
and renders the exact final frame as each player's WebP poster. Optional scene
ID selects one episode. The browser fetches the Lua only on play; playback
starts at zero and the shared player retains pause, seek, speed and fullscreen.

| Episode | Visible evidence | Motion beats |
| --- | --- | --- |
| dispatch | Aligned leaves with eleven dedicated native-checked row previews | Read independent samples; compute; show output correspondence; reset and repeat |
| solid-rle | Native grayscale coverage and computed target | Read native span; show coverage; commit span colors; retain complete bitmap |
| direct | Equal-size source/destination texels | Read one source texel; copy its computed value; commit offset destination; complete rows |
| nearest | One tap per inverse-mapped sample | Select integer texel; copy; revisit it for adjacent destination samples; complete bitmap |
| bilinear | Four tap areas, two horizontal intermediates, result | Read four taps; show their weight areas; merge horizontal pairs; merge vertical pair; commit |
| downscale | Kernel extent, sparse actual taps, average | Show kernel; select stepped samples; average; commit four destination pixels |
| texmap | Native triangles, scanline interval, UV taps, feathered result | Select triangle; advance row; interpolate UV; read taps; commit feathered sample |
| composition | Original source/destination and exact RGB contributions | Read same coordinate; show S′ and D′; add channels; commit to output |

Independent subject state is exclusively the model trace. Grid placement, copied
sample travel and timings are presentation choices. Ordinary sampling writes take
0.6 seconds per pixel, with longer holds on detailed samples; source-over writes
take 0.73 seconds and RLE spans take 1.1 seconds. The order and values are unchanged.
The high-contrast bilinear sample used for a
longer hold is selected from its tap colors, not an authored result.

The overview has eleven persistent demonstration rows: four Shape Fill paths,
two Stroke paths, and five Image sampling paths. All leaves share one column.
Geometry and Color/Color Table remain separate inputs to Fill/Stroke writes;
only Image uses the source-bitmap-to-destination layout. Each row loops its
characteristic query. Stroke uses its own native strokeRle, not the Fill region.

Below them, source-grounded static maps cover Image RLE clipping (including the
Texmap temporary-surface route), compositor/matting/masking/blending alternatives,
and Surface helpers: color conversion, premultiplication, clear, compositor
accessor setup, 32/8-bit buffer operations, XY flip and unpremultiplication.
These independent groups do not imply a sequential execution of every operation.
The optional Matting-to-Blend edge represents supported combined image paths.
They map the entry points declared in `tvgSwCommon.h:514–532` and implemented in
`tvgSwRaster.cpp` / `tvgSwRasterTexmap.h`; pixel animations remain the native-checked
32-bit examples, not fabricated simulations of every mask mode or SIMD backend.
The encoded loop returns to the exact opening RGBA frame.

All scenes use a fixed Y-up camera and convert pixel layout coordinates explicitly.
Texture scan conversion pre-steps to `(x+1,y+1)` before writing slot `(x,y)`.
Triangle/scanline overlays therefore subtract half a cell when mapping into the
displayed pixel-center frame. Source sample markers use texel centers for both
texture UV and scaled sampling (after the engine's -0.49 offset). This corrects
the earlier half-cell overlay displacement, without changing any output byte.
Every transparent pixel center is outside the corrected triangle interiors in
the fixture; fresh native execution also matches all 121 texture RGBA pixels.
Text is restricted to object/condition names
and values and has an explicit standalone policy. The scene generator reviews
every encoded frame and the exact endpoint for text bounds and pairwise clearance;
review rasters and the report remain in the ignored source-local `temp/` directory.
The large compiled traces store generated handles in a Lua table to avoid Lua's
200-local limit without changing the builder's objects or timeline.

The colored patches below Source-over are opaque displays of each RGB byte
contribution; they are not independently alpha-composited surfaces. The original
source grid still displays alpha over a checkerboard.

The final rendered sampling scenes were also checked against their model data:
all 485 Surface cell interiors and 15 asymmetric Source samples matched their
expected displayed RGBA bytes exactly. This check accounts for preview
premultiplication over the checkerboard and chooses interior locations away
from the known texture triangle/scanline overlays; it excludes no Surface cells.
Browser review covered complete 1× playback, final-frame posters, keyboard seek,
all scene/font/WASM resources, and a 390px-wide page without horizontal overflow.
