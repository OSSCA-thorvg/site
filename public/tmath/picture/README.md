# Picture overview

`overview.mjs` authors the diagram; `overview.lua` and `overview.webp` are the public player assets.

```sh
node scripts/render-picture-overview.mjs
node scripts/render-picture-overview.mjs --variant
```

The seven beats follow API input, Picture dispatch, pixel normalization, Image Prepare, Clip intersection,
Draw/Sampling selection, and Surface writes. White nodes carry control/data and dark
nodes prepare or write pixels. Source pixels preserve their colors; RLE glyphs match section 4.1: only the starting pixel carries coverage alpha;
a thin line of exactly `len` pixel pitches ends in a short tick. The example executes Direct; Scaled and Texmap are alternate
branches. The taller Sampling band places Direct, TexMap, Scaled/Nearest,
Scaled/Bilinear and Scaled/ScaleDown vertically. Each inset replays the checked
Draw/Raster sampling traces: source taps converge on a destination pixel, then
scanlines populate the Surface. TexMap additionally reveals the two triangles.
Equal pixel pitch preserves the relative image scale. This already-aligned opaque Source visits normalization without changing
its pixels.

`overview-model.mjs` derives translated bounds, the image/clip intersection, Source
indices and composited Surface pixels from the existing `image-clip-trace.txt` input.
The matching C++ source anchors are in `pictureRefs`. The second native fixture moves
the circle center from x=6 to x=5.5 and exercises different coverage/output without
changing the Bitmap or its prepared extent.

The render script audits every 30-fps frame with the delivered Pretendard font,
including text containment, text/route gaps, glyph visibility and the exact final
frame. Review files live in `temp/`; `--variant` never replaces the published assets.

The normalization inset uses a separate ARGB8888S pixel: BGRA bytes become RGBA,
then PREMULTIPLY maps (200,100,64,128) to (100,50,32,128). The main opaque
Bitmap retains its original native fixture. The variant uses (21,173,242,73).
