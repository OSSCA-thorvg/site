# MaskMethod comparison

Question: how do the eleven MaskMethod values change the same avatar content?
Pinned CPU source: 4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad.
English labels; 1440×3160; Pretendard; fixed camera; 8-second autoplay loop.

Canonical data: native-trace.mjs records public Canvas executions, prepared
SwSpan records, mask compositor storage, color group storage, and final pixels.
The content Scene contains the same portrait Picture and green badge as the
Mask pipeline example. A is a rounded rectangle, B a circle with constant alpha
and a varying-color gradient. Both masks are partially opaque so union/max and
intersection/min remain distinguishable. The variant shifts B and changes both
alphas. Every other dependent comes from the recorded input.

Two API patterns:
- Four matte methods: content->mask(B, method).
- Six combination methods: A->mask(B, method); content->mask(A, Alpha).
None leaves the original content intact. Combination operations execute in
Grayscale8 mask storage; their output q subsequently mattes the color content.

## Beat ledger (all sections persist, all local mechanisms repeat)

| Band | Claim | Motion | Fixed evidence |
| --- | --- | --- | --- |
| 01 | Same content and two masks | Construct A and B pixels | None / original content |
| 02 | Alpha and InvAlpha read complementary alpha weights | Convert B rows to q | Both output images |
| 03 | Luma reads stored premultiplied RGB, with a complement | Convert B rows to q | Both output images |
| 04 | Add expands; Subtract removes B from A | Update A rows with op(A,B) | Both output images |
| 05 | Intersect retains overlap; Difference removes shared opacity | Update A rows with op(A,B) | Both output images |
| 06 | Lighten and Darken choose max/min alpha | Update A rows with op(A,B) | Both output images |

All formulas use normalized a,b; sample labels expose actual 8-bit CPU weights.
The model checks the exact integer equations, then every premultiplied output
channel. Luma uses (54R + 182G + 19B) >> 8 on stored premultiplied target RGB.
The display checkerboard is not source data. Darker q cells mean larger weight.
No RLE length marks are used: these fields are per-pixel weights, not SwSpan
records. Native spans are expanded and checked in the data model.

Layers: structures 5, routes 8, fields 20, writes 24, labels 50. Every text is
standalone or belongs to a box with a 12-pixel inset. Each method has its own
phase. Row replacement illustrates computation, not native execution timing.
Results remain fixed throughout. The separate completed poster answers the
comparison without playback.

## Reproduce

Use an unmodified static, scalar CPU build of the pinned revision (SIMD and
threads disabled). The existing `/tmp/thorvg-cpu-4d5810cf-build` can be reused.

```sh
meson compile -C /tmp/thorvg-cpu-4d5810cf-build
c++ -std=c++17 -O2 -ffp-contract=off -fno-access-control \
  -I/tmp/thorvg-cpu-4d5810cf-build -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/mask-methods-native.cpp \
  /tmp/thorvg-cpu-4d5810cf-build/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-mask-methods-native
node scripts/generate-mask-methods-trace.mjs
node scripts/render-mask-methods.mjs
node scripts/render-mask-methods.mjs --variant
```

The harness includes the renderer implementation for inspection only; engine
source is never modified. Results cover every public MaskMethod value. The
content group buffer is verified identical across all methods. Native RLE
coverage is independently expanded, all grayscale operators are recalculated,
and every final RGBA channel is checked against public draw output.

Pixel fields use Image objects with replicated texels to stay below the scene
object limit while retaining native pixel interiors when enlarged. The render
audit probes cell centers and quarter points, verifies stable native values
during row writes, checks every frame's text ownership and clearances, compares
decoded loop endpoints, and requires the original content and all ten result
fields to remain fixed. Baseline and asymmetric variant must both pass.
`--quick` is a sparse preview and never publishes assets.

Disposable PNG/audit reviews live in `temp/`; move them outside public before
building the site. Browser review checks autoplay, looping, pause/seek/resume
and mobile width. The Mask page retains its original pipeline Overview above
this separate comparison.
