# CPU Renderer — Postprocessing

Source: ThorVG b4471844c3c2f849ce82e0825798e2696a4a2cad (2026-08-31).
Anchors: src/renderer/tvgCanvas.h, tvgScene.h, tvgRender.h,
src/renderer/cpu_engine/tvgSwRenderer.cpp, tvgSwPostEffect.cpp, tvgSwRaster.cpp.

## Article and scene structure

1. Overview follows API → Scene Update → child Task requests and Effect parameter
   preparation → Draw, with asynchronous Shape preparation beside the caller flow.
2. Effect Pipeline expands Draw · Effect Offscreen into target/beginComposite,
   child rasterization, ordered effects, endComposite, and postRender.
   Effect code excerpts live beside their corresponding stage.
3. Effect Details covers GaussianBlur (including Prepare), Tint, Tritone, Fill,
   and DropShadow. The former order comparison is now `order`, beside DropShadow;
   `chain` follows the actual GaussianBlur → Fill example.
4. The Appendix follows actual pixel writes through Effect Surfaces, magnifies
   the same leaf edge from two filtered images, corrects a straight reader by
   expanding RGB without changing alpha, and compares clear/retain target images.

Overview uses 1280×2230. Effect Pipeline uses 960×800; Raster uses 960×720 and Composite uses 960×920,
the other stage scenes use 960×540 (Output uses 960×750);
two native detail scenes use 960×1120, five illustrative scenes use 960×640,
and all four Appendix scenes use 960×720. All fill the MDX measure, use a fixed 2D camera, Pretendard,
pro_white, English visible labels, and no loops, title bars, or footer prose.
The player retains click-to-toggle, bottom hover controls, seek, speed, fullscreen,
keyboard support, and touch controls. It never starts automatically.

## Evidence and numerical scope

`native-trace.mjs` contains the 24×24 C++ execution captured by
`scripts/postprocessing-native-trace.cpp`. `native-evidence.mjs` shares native
span replay, premultiplied RGBA decoding, integer source-over terms, and alpha
windows across the detail scenes. Overview reuses these same native pixel snapshots.

Overview, the eight native pipeline/detail scenes, and Appendix Surface flow
use the same BG, A/B, opacity 128,
GaussianBlur(sigma=1.4, quality=100), and Fill(49,150,123,255). Both effects have
direct=false. A/B Tasks have opacity 255 and 50/39 RLE spans. The selected pixel
is (14,14): rasterized [31,102,196,255], blurred [37,100,188,254], filled
[48,149,122,254], final Canvas [141,196,179,255].

Canvas remains unchanged through the effects. `target()` saves recoverSfc and
selects Offscreen; `beginComposite()` stores mode and opacity. `endComposite()`
restores the Canvas target, then calls `rasterDirectImage()` to write the result
into that same Canvas. `postRender()` runs after Main Scene returns, outside the
effect loop. Its straight-alpha branch is an alternative output format.

There is one effect Offscreen and one Blur Scratch. Blur alternates their
storage through H1/H2/H3, transpose, V1/V2/V3, transpose. This configuration
finishes in Offscreen; Fill overwrites it without another allocation. Scratch
writes do not change the Shape render target. History pictures and replay
vectors are snapshots, not extra engine buffers. Canvas is excluded from the
temporary-buffer count. Worker order, span batching, row reveals, and playback
durations are explanatory, not measured timings.

Prepare uses a separate geometric model of accumulated filter support.
DropShadow and its order comparison use floating point explanatory images.
Tint/Tritone use opaque swatches and integer luminance, with floating point
interpolation. Those five scenes do not reproduce every engine byte truncation;
their scope is stated in the article. Blue/orange identify circle/triangle;
teal is Fill output, checkerboard transparency. White process nodes indicate
preparation/control, dark nodes pixel processing. Diagrams use a light gray
background, monochrome structure, and dashed storage/group boundaries; semantic
Shape, effect, RGBA-channel, and comparison colors are retained.

`straight-alpha.mjs` mirrors the pinned byte operations for a fully covered
pixel in a straight target. With Canvas [200,100,50,128] and Shape [0,200,100,128], the
required premultiplied target path returns [66,166,82,192]. The pinned
`draw(false)` path returns [132,199,99,192] because `target()` marks the Surface
premultiplied without converting the retained bytes. The public harness is
`scripts/straight-alpha-target-trace.cpp`. The animation builds illustrative
64×64 leaf/disk masks with these operations; the selected overlap pixel (33,32)
matches the public native harness. The masks do not reproduce native edge AA.

`alpha-image-model.mjs` supplies one 64×64 leaf bitmap with hidden magenta RGB
and an illustrative 7×7 clamped box filter. `alpha-fringe.mjs` compares straight
channel filtering against filtering premultiplied pixels, then pulls the same
8×8 ROI directly out of each result. At (47,14), the stored results are
[122,98,80,125] and [0,98,39,125]. `alpha-output.mjs` uses that same filtered
image: unpremultiply produces [0,199,79,125], changing RGB but retaining alpha.
This box model isolates hidden RGB; the native Gaussian replay remains in `blur`.

`alpha-visuals.mjs` displays whole images and crops from the same RGBA arrays.
Checkerboard phase is retained when a crop is enlarged. Moving crop/composition
proxies deliberately start on top of their source and are reviewed visually;
stationary images are included in every-frame separation checks. A moving
proxy is a presentation copy, not an additional renderer allocation.
The transparent composition proxy uses immutable Cell patches: repeated draws
of a transparent Image in the frozen runtime premultiply its shared source
bytes again. Cell patches avoid that mutation. Its alpha multiplier lives below
the fading owner, so FadeIn cannot reset the group contribution to full opacity.

## Series / beat ledger

Settled times are exported by each definition; beats have readable holds.

| Episode | Source | Progression | Final evidence |
|---|---|---|---|
| overview | Canvas/Scene/SwRenderer | API/tree → Task request → Effect parameters and worker RLE → main Draw → effects → composition | Prepared kernel/extent/valid, complete four-column map and final Canvas |
| effect-pipeline | SceneImpl::render, GaussianBlur, Fill, endComposite | A+B → Blur → Fill → composite once | Before/after states of one Offscreen and one Canvas; one Blur scratch |
| begin | target/beginComposite | Canvas → request/clear → save and switch → mode/opacity | One Offscreen, saved Canvas, opacity 128 |
| raster | renderShape/rasterShape | Tasks → A spans → B spans → selected pixel | Native Offscreen; unchanged Canvas |
| chain | effect dispatch/GaussianBlur/Fill | input → alternating passes → in-place Fill → loop complete | Two buffers, reusable Scratch, unchanged Canvas |
| composite | endComposite/rasterDirectImage | preserved buffers → restore context → mark reusable → write | Offscreen composited into the same restored Canvas; no numeric channel labels |
| output | postRender | completed Scene → premultiplied format → alternative straight format → cleanup | Conditional conversion and frame state |
| prepare | effectGaussianBlurRegion | bbox → radius-1 → radius-2 → radius-3 support | Computed extent; unchanged geometry |
| blur | _gaussianFilter | native input → first H pass → average → sliding window → remaining passes | Alpha 12 then 45 from native bytes |
| fill | effectFill | Blur output → recolor → alpha equality → allocation count | Alpha 254, changed RGB, zero extra buffers |
| tint | effectTint | palette → luma → mapping → mix | Opaque mapped swatches |
| tritone | effectTritone | ramp → low branch → high branch → original mix | Two intervals and original fraction |
| shadow | effectDropShadow | source → alpha → blur → color/offset → source-over | Body retained over shadow |
| order | SceneImpl::render | input → Shadow then Fill → Fill then Shadow → hold | Different shadow colors |
| alpha-surface-flow | native spans/effects/endComposite | A/B writes → eight alternating Blur passes → in-place Fill → bitmap composition | Native Canvas and exact source-over contributions |
| alpha-fringe | shared leaf/box-filter model | visible image + raw RGB → two filters → exact boundary crops | Brown/pink fringe versus green edge; same alpha |
| alpha-output | shared leaf + unpremultiply | correct premul image → wrong straight reader → RGB bars expand → corrected image | Same appearance, different stored RGB, unchanged alpha |
| straight-alpha | clear/target/postRender | same old leaf → clear/retain/prepare → new disk → exact overlap crops | Three images with native-verified overlap RGBA |

## Native reproduction

The Raster diagram's call path was rechecked against local ThorVG
cdc1c9596a5edebc159d5623d726febda7595896: `SceneImpl::render` visits children,
`ShapeImpl::render` passes `impl.rd`, and `SwRenderer::renderShape` calls
`task->done()` before reading valid prepared data. For the example's solid
fills, `rasterShape` calls `_rasterRle` on the current Offscreen surface.
The diagram keeps both Task records fixed and replays the existing native
span snapshots only in Offscreen. `done()` waits; it does not invoke `run()`.

Build the pinned ThorVG checkout out of tree with CPU engine, static library,
no loaders/savers/tools/tests. Compile `scripts/postprocessing-native-trace.cpp`
with `-fno-access-control`, the build configuration directory, and ThorVG inc,
src/common, src/renderer, src/renderer/cpu_engine includes; link src/libthorvg-1.a.
This inspects private compositor state without editing engine sources.

Run `node scripts/generate-postprocessing-trace.mjs /path/to/trace-binary` to
verify baseline and perturbed executions and regenerate `native-trace.mjs`.
An optional binary argument moves A by 0.75px. Both runs assert span/pass/chain
replay against native pixels and public Canvas::draw() output. Only initialized
pixels inside the compositor bbox are read. A second public draw reuses both
cached addresses while matching reference pixels. The frozen tmath runtime
version is separate from the analyzed ThorVG source revision.

Compile `scripts/straight-alpha-target-trace.cpp` against the same static
library and public include directory. It renders the 1×1 straight-alpha target
three times: cleared, retained straight bytes, and equivalent prepared
premultiplied bytes.

## Review

Run `node scripts/review-postprocessing.mjs` for every-frame text bounds,
visibility, gap/ownership, image/text separation, and image overlap checks,
plus initial/settled/final PNGs and posters. It verifies frozen runtime hashes.
The runtime exposes object bounds; connector paths also need visual inspection.
Evidence is written under `temp/`; archive that directory outside public before
building, because Astro publishes everything under public. Runtime manifest and
licenses remain in ../runtime/.

All 18 scenes pass 6,938 sampled frames at 30fps with zero issues. The six
16:9 Section 2 scenes account for 2,064 of those frames; the four Appendix
scenes add 1,838 frames. Initial, settled, moving, and final images were inspected.
Four rendered variants change hidden RGB, leaf geometry/kernel, and retained
target/Shape RGBA; crops, values, and final images follow their changed inputs.
Tests cover every native composite pixel, independent RLE snapshots, the native
first horizontal alpha pass, the straight-target byte boundary, alpha-invariant
output conversion, hidden-RGB perturbations, crop identity, and stable proxy
color/opacity across repeated runtime renders.
Browser review passed normal 1× playback and exact final raster equality for
the four rewritten Appendix scenes, including a second end seek without color
drift. At 390px, each player follows the 342px article measure with no overflow;
all 20 disclosures, including 19 code disclosures, start closed. The earlier
six-scene Section 2 playback/control review remains valid.
Production build and all 136 tests passed. Astro check: zero errors/warnings,
six existing hints. Appendix reference contact sheets, every-frame audits,
motion/variant renders, and desktop/mobile browser evidence are archived under
`/private/tmp/postprocessing-alpha-redesign-review-20260912`.

## Effect Pipeline: beginComposite → endComposite overview

`effect-pipeline.mjs` uses a 960×720 cumulative map of the composition lifetime.
The top row explicitly shows target() and beginComposite(), including None and
Scene opacity 128. A dashed Offscreen scope contains renderShape(A, B),
GaussianBlur, Fill, their native snapshots, and the one Blur scratch. The end
node restores Canvas and contains rasterDirectImage(), making that call's
ownership explicit. Its source-over output uses the same opacity 128.

Seven beats establish target selection, begin configuration, child raster,
Blur, Fill, context restore, and the final image write. The Canvas BG stays
visible throughout; the final map retains every stage and the same five native
pixel snapshots. The diagram's vertical expansion gives function names and
scope boundaries room. Individual implementation details remain in 2.1–2.5.

## Preserved Overview constraints

Four columns contain data, main flow, expanded Effect Offscreen, and pixel
evidence. Canvas owns an internal Main Scene with sibling BG Shape and A/B Scene.
BG uses the same renderShape operation as A/B. A dashed scope groups main Scene
iteration with its two Paint visits. The Update/Draw boundary separates Task/RLE
preparation from pixel writes. Workers can overlap Draw; renderShape waits for
its Task and preRender waits on the partial-render path. Draw may invoke update
for Painting/Damaged state. Effect parameters are prepared in Update; composition
bounds are evaluated during Draw.

`SceneImpl::update()` requests child Paint preparation before calling
`SwRenderer::prepare(effect, transform)` on the caller thread. That overload does
not schedule a worker or join the child Tasks. GaussianBlur stores kernel radii
`[1, 1, 1]` and `rd->extends = 3`; Fill sets `valid = true`. The kernel cells and
extent label derive from the native trace. Effect preparation does not allocate
Offscreen or Scratch, and `rd->extends` is distinct from the RenderRegion expanded
later by `effectGaussianBlurRegion()`. The reveal order illustrates overlapping
preparation, not an enforced worker completion order. The caller's route to Draw
bypasses the worker output, while the prepared parameters remain visible.

The main spine stays visible. Data, expansion bracket, detail nodes, and side
arrows appear at their owning step and remain for the final hold. The bracket
expands Render Scene; it is not a parallel execution branch. The target follows
Canvas Surface → Offscreen → Canvas Surface. Preserved Canvas and Fill output
meet at final source-over. Playback starts with API setup; the poster and final
hold show the complete topology.

The Effect Update revision runs for 44.965s and passes all 1,350 sampled frames
with zero layout issues. `node scripts/review-postprocessing.mjs overview`
regenerates `overview.lua` and its poster; the article loads this Lua source.
Object handles use a table to stay below Lua's 200-local limit.

A read-only native probe verifies both effects immediately after Canvas Update:
Blur has the displayed radii and extent, Fill is valid with no private `rd`,
the compositor cache is empty, and Canvas pixels remain untouched. Replaying
sigma 2.3 gives radii `[1, 2, 2]`, extent 5, identical Shape Tasks, and a different
native final Canvas; the same Overview builder renders that complete second trace.
The default trace still matches every original native field and pixel.
Initial, all settled beats, transitions, and the final map were inspected.
Browser review passes complete 1× playback, a stable repeated final seek, no
runtime errors, and no page overflow at 390px. The build passes all 183 enabled
tests; one optional native test is skipped. Astro check reports no errors or
warnings and two existing hints. Evidence is archived outside the published
assets at `/tmp/postprocessing-overview-update-review-20260913`.

## Appendix 1.5: Alpha mask around the effect Scene

`mask-pipeline.mjs` adds a 960×1120 six-beat scene using `mask-trace.mjs`.
The original BG/A/B, Blur → Fill and Scene opacity 128 are retained. A circle
mask at (12,12), radius 8, has fill alpha 160 and Paint opacity 255. Its
non-fast-track Alpha path uses Grayscale8 storage. Two mask begin calls first
render with None/255, then restore Canvas with Alpha/255. The nested effect
compositor saves/restores this mask context. Ending its None scope invokes
masked image composition; ending the outer Alpha scope only restores context.
The mask bitmap, effect images and Canvas stay fixed; dashed arrows show their
relationships. The final frame retains the pipeline and output while marking
the prior compositor restored. Orange/blue remain A/B; teal remains Fill.

The selected pixel (14,14) combines group opacity 128 and stored mask alpha 160
with MULTIPLY to obtain 80, then yields Canvas [175,212,200,255]. This is the
normal-blend Alpha image path, not a formula for every MaskMethod. Temporary
storage peaks at three buffers (Mask, Effect, Blur Scratch), excluding Canvas.

`scripts/mask-native-trace.cpp` replays the unchanged pinned CPU implementation,
asserts Surface/compositor transitions and unchanged Canvas through effect
processing, and compares all final pixels with the public Canvas draw.
`scripts/generate-mask-trace.mjs` also checks a mask moved +1.25 with alpha 96
and an alpha-0 mask, and verifies the native integer composition per pixel.
Build it with the pinned b4471844c source and a matching CPU-only static build:

```sh
maskSource=/path/to/thorvg-b4471844c
maskBuild=/path/to/cpu-static-build
c++ -std=c++14 -O2 -fno-access-control -DTVG_STATIC \
  -I"$maskBuild" -I"$maskSource/inc" -I"$maskSource/src/renderer" \
  -I"$maskSource/src/renderer/cpu_engine" -I"$maskSource/src/common" \
  scripts/mask-native-trace.cpp "$maskBuild/src/libthorvg-1.a" -lpthread \
  -o /tmp/mask-native-trace
node scripts/generate-mask-trace.mjs /tmp/mask-native-trace
node scripts/review-postprocessing.mjs mask-pipeline
```

Archive `public/tmath/postprocessing/temp` outside public before building.
