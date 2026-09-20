# GL Fill / Gradient Overview

Page: `src/content/blog/Mentoring/GPUEngine/Fill.mdx`.
Series: **Core2026 > Engine > GPU Engine > Fill**.

The article displays only **section 07's static GL comparison**, `result.webp`.
Both animation players have been removed from the page. The sources below are
retained to reproduce the comparison and its evidence. A full baseline render
exports the 950 × 750 result region losslessly, excluding the pipeline column and
the former row-writing strip. The image labels remain English; article prose is Korean.

1440 × 3970, 30 fps, **8-second autoplay loop**, English labels, Pretendard.
Solid pipeline scopes stay on the left; seven numbered explanations stay on the
right. Every section is visible throughout playback and owns its local motion.
The complete poster includes every result without requiring playback. Native
images and pixel crops remain fixed while separate strips demonstrate writing.

## Source and fixture

- ThorVG revision `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad` in `./thorvg`.
- Four ColorStops, concentric RadialGradient, focal radius 0, Repeat, Normal blend,
  opaque fill. The fixture reproduces the scale comparison from issue #4688.
- Fill scale: R2048, F = 1/16. Shape scale: R2048, S = 1/16.
  Reference: R128, identity scale. All three world rectangles are 512 × 512;
  their screen-space gradient radius is 128 pixels.
- Fill vertices are prepared in world coordinates. The gradient vertex shader
  recovers Fill coordinates using `inverse(F) * inverse(S)`; the View matrix
  independently produces `gl_Position`. This describes the fill path.
- `example.png` is an actual framebuffer readback from a separate shared GL build
  of the local source. `example.json` records the revision, input, device, driver,
  and measured pixels. No installed ThorVG library is used.

## Seven persistent sections

| Section | Local motion and source evidence |
| --- | --- |
| 01 Input | Construct the shared four-stop color strip; retain all three input transforms. Public `RadialGradient` / `Shape::fill` API. |
| 02 Prepare | Construct triangles over model-derived world bounds. `GlRenderer::prepare`, `GlGeometry::prepare/tesselateShape`. Triangle ordering is schematic. |
| 03 Draw → Sync | Record stop values in GradientInfo, then copy them to GPU buffers. `drawPrimitive(Fill*)`, `GlRenderer::sync`, `GlGpuBuffer::flushToGPU`. |
| 04 Shader | Construct a radius vector in each recovered coordinate space. `GRADIENT_VERT_SHADER`, `compute_radial_t`, `gradientWrap`. |
| 05 Repeat AA | Write shader-evaluated colors around the seam and mix the selected pixel. `gradient(t,d,l)`, final-stop interval. |
| 06 MSAA | Fill sample locations, then resolve their colors into one pixel. `GlRenderTarget`, `GlComposeTask::onResolve`, `GlBlitTask::run`. |
| 07 Result | Keep native outputs and matching 8× crops fixed; write three captured rows beneath them. `scripts/gl-fill-native.cpp`, `glReadPixels`. |

GL source files are under `thorvg/src/renderer/gpu_engine/gl/`.
Solid fill uses vertex RGBA; Linear and Radial fills upload at most 16 stops as
uniform data. An uncorrectable radial gradient falls back to its last stop color.
The color strip illustrates interpolation, not a CPU color table or WG texture.
This convex rectangle draws directly; other nonconvex fills use stencil + cover.
The two displayed triangles do not claim the tessellator's native memory order.
`GlComposeTask::onResolve()` resolves the multisampled attachment through
`glBlitFramebuffer()`; `GlBlitTask` then composites to the target framebuffer.

## Exact AA scope

The shader computes `dist = 2*d/l`. For the concentric fixture, `d=l/R`, hence
`dist=2/R`. R is the original Fill radius. The screen width of the interval
**immediately before wrap** is `dist * R_screen`: **0.125 px** for both scaled
cases, **2 px** for the reference. This is not a symmetric filter width or MSAA
sample radius. The current calculation does not use screen-space derivatives.

The model also follows the shader's first-stop branch, which is not the mirror
of the final-stop branch. The displayed mix equation explains only the latter.
Pad and Reflect do not apply this Repeat seam mixture.

The seam strips evaluate the shader formula. The bottom images, magnified crops,
and replayed rows use native readback. Each crop starts at panel coordinate
`(335,334)`, covers 24 × 24 pixels, and is shown at 8×. The marked pixel center is
`(346.5,345.5)`. Numbers, colors, crop positions, and pixel markers share the same
model/capture data. Small textures replicate texels to preserve magnified pixels.

MSAA sample locations and the edge's 2/4 coverage are schematic; they are not a
measurement of the driver's sample pattern. The actual render target uses
4×MSAA. The tmath CPU WASM renders the explanation, not the native GL fixture.
Local loop phases illustrate operations, not GPU execution timing.

## Generate and verify

From the site root:

```sh
# macOS / CGL; builds and review files stay outside public/.
node scripts/generate-gl-fill-capture.mjs
node scripts/render-gl-fill.mjs --quick
node scripts/render-gl-fill.mjs
node scripts/render-gl-fill.mjs --variant
```

Sources: `overview.mjs`, `model.mjs`. Published assets: `overview.lua`,
`overview.webp`. The default work directory is `/tmp/thorvg-gl-fill-review`;
override it with `GL_FILL_REVIEW_DIR`. `THORVG_SOURCE` / `THORVG_BUILD` can select
the source/build paths; the generator still checks the pinned revision.
Only a passing full baseline render publishes the Lua scene and complete poster.

The native generator checks 1,728 pixels for each of baseline and variant.
Both captures on Apple M5 Pro matched the shader model with zero channel error;
up to two levels are allowed for driver float/RGBA8 rounding differences.
The variant changes scale to 3/32, preserves screen radius and d, and changes the
original R and scaled seam width to 0.1875 px.

Full scene audits check every 30 fps frame and the complete poster for visibility,
text containment, four-pixel text gaps, image intersections, and connector clashes.
They check intermediate strip colors, 5,189 complete-poster pixel probes, exact
loop continuity, at least three distinct states per section, and unchanged native
images/crops across review frames. Review PNGs, layout data, and audit summaries
remain in the temporary directory. Production-browser review covers autoplay,
normal-speed looping, pause/seek/resume, and mobile overflow.

## Repeat AA detail

`repeat-aa.mjs` adds a separate 1440 × 1880, eight-second loop beneath the
Overview. It uses the same four stops, transforms, native selected pixel, and
shader model. The article includes source-linked GLSL excerpts for the Radial
caller, both interval-loop AA branches, endpoint handling, and the Linear caller.
It explicitly retains the Repeat and `abs(d) > dist` guards.

| Persistent section | Evidence and local motion |
| --- | --- |
| 01 Wrap | Map d to t around the repeat boundary and write the unmixed stop colors. |
| 02 Mix | Construct gap/dist bars at the same scale, then mix the selected fragment. The scaled case skips AA; the reference uses its computed weight. |
| 03 Width | Write shader colors on equal radial screen axes. Brackets derive from `dist × screenRadius`. |

`alpha` in the AA branch is a color weight, not the resulting pixel opacity.
Opaque stops keep output alpha at one. The animation illustrates the last
interval; the source excerpts also show the asymmetric first-interval formula.
Its color strips evaluate the shader model and are not new native readbacks.
The selected output colors are checked against the existing native capture.

```sh
node scripts/render-gl-fill.mjs --repeat-aa --quick
node scripts/render-gl-fill.mjs --repeat-aa
node scripts/render-gl-fill.mjs --repeat-aa --variant
```

These commands share the Overview's acceptance gates. The detail checks all
1,728 native crop pixels, four computed bar lengths, 322 poster pixel probes,
intermediate stripe colors, text/connector clearance, three independently moving
sections, and the decoded loop boundary. Only the baseline full command publishes
`repeat-aa.lua` and `repeat-aa.webp`; it does not rewrite the Overview assets.
