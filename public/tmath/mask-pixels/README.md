# Mask: inside one avatar pixel

This is the detailed animation embedded in the single **ETC / Mask** page.
It replaces the separate Matte article's duplicate pipeline with a pixel-level
continuation of `../cpu-regions/mask-overview.mjs`. The existing Mask overview and
MaskMethod comparison remain intact. The old article URL redirects to this section.

English, 1440×2630, 30 fps, eight-second autoplay loop. Five always-visible sections
run independently, with solid call scopes on the left and numbered data views on
the right. The exported poster contains the completed reference state; transparent
and opaque-destination comparison images remain fixed throughout playback.

## Evidence and local beats

Pinned ThorVG: `4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad`, scalar CPU, no workers.
The native probe reuses the exact avatar fixture from `scripts/cpu-regions-native.cpp`:
photo + green badge in a Scene, circular Alpha mask. One Canvas pixel **(12,6)**
remains the sample in both baseline and target-only variant.

1. **Mask byte:** mask RLE is geometric coverage; grayscale storage is coverage
   times target alpha. At the baseline sample, coverage203 and alpha160 yield127.
   The stored byte field writes rows locally. RLE uses starting-pixel shade for
   coverage, a first-to-last pixel-center length segment, and no singleton segment.
2. **Group pixel:** badge coverage100 is consumed while drawing into the group's
   color Surface. Badge RGBA(13,63,39,100) over the photo yields the group's
   RGBA(126,190,180,255). Local writes assemble this same native group buffer.
3. **Matte attenuation:** all four premultiplied channels shrink together to
   ALPHA_BLEND(S,127) = (63,95,90,127). Bar lengths continuously contract to the
   actual byte values; fixed outlines and numeric labels identify final values.
   No badge-coverage multiplication is repeated on the completed group pixel.
4. **Source-over:** final alpha127 leaves destination weight128. A control changes
   only the destination to RGBA(220,229,238,255) and retains it via draw(false).
   Native output is (173,210,209,255), alongside the original transparent result.
   A separate working Surface writes locally; final comparisons never transform.
5. **Dispatch:** one group row and the same-coordinate mask row produce the output
   row via `_rasterDirectMattedImage()`. The source-selected Shape RLE, rectangle
   and Gradient alternatives are a source-verified branch reference, not stages
   executed by this Scene. `endComposite(mask)` restores context without remasking.

`endComposite(group)` reaches `rasterDirectImage()` with an Alpha compositor
installed on the destination. The group is an image at this point. The old Matte
example's `_rasterMattedRle()` is appropriate for a directly masked Shape; it is
not used as the final avatar Scene kernel. Image/Gradient dispatch is source
verified, not additional native examples rendered by this probe.

All 192 pixels of both destinations match native Canvas for both fixtures.
Mask/group storage remains identical when changing the destination. Moving only
the target center to x7.25 and changing its alpha to96 keeps group pixels fixed;
the same selected pixel now has mask coverage14 and weight6. The checkerboard is
presentation of premultiplied transparency, not stored destination color.

## Files and regeneration

- `model.mjs`: validates existing overview evidence, badge source-over, all masked
  channels, opaque-destination output and restoration against native records.
- `native-trace.mjs`: two native destinations × two target configurations.
- `overview.mjs`: authoring source; `overview.lua` and `.webp`: published assets.
- `scripts/mask-pixels-native.cpp`: original fixture helpers, new Canvas captures.
- `scripts/generate-mask-pixels-trace.mjs`: compiles a read-only probe in OS temp.
- `scripts/render-mask-pixels.mjs`: renderer and every-frame auditor.

```sh
THORVG_BUILD=/path/to/matching/static/build node scripts/generate-mask-pixels-trace.mjs
node scripts/render-mask-pixels.mjs
node scripts/render-mask-pixels.mjs --variant
npm run check
npm test
```

Review files go to `/tmp/thorvg-mask-pixels-review`, overridable with
`MASK_PIXELS_REVIEW_DIR`. `--quick` audits a sparse preview without publishing;
`--variant` never replaces the baseline assets. The full audit verifies all text
policies, bounds, text/grid/route clearance, RLE endpoints, native poster colors,
moving row colors, all four animated channel widths, local motion per section,
fixed final outputs and decoded loop-seam equality. Timing is educational.
