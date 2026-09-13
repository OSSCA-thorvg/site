Preparation scenes 06–09
========================
Source: ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b (local ./thorvg).
Authoring: tmath-skills; fixed 1280x720 camera, 30fps, Pretendard,
standalone label_* text, no decorative panels or supplementary paragraphs.
Each Lua file is portable and self-contained. Generate with:
  node build-prepare-scenes.mjs
The generator reuses the established primitives at the start of 01-direct.lua.
Render each prefix with render.mjs /path/to/wasm 06- (then 07-, 08-, 09-).
Verify with verify-prepare-scenes.mjs /path/to/wasm.

06 ColorSpace — same visible bitmap, different byte ownership
Claim: R and B exchange memory positions; A and G and interpreted color stay fixed.
Beats: source bitmap / byte values; R and B separate into two lanes; both owners
exchange slots; lanes settle as BGRA; converted packed integer and target appear.
Example RGBA=(200,100,40,255), ABGR=0xFF2864C8, ARGB=0xFFC86428.
The byte example illustrates one independent pixel; it is not a selected landscape texel.
Fixed identities byte_R/byte_B move together with their channel/value labels.
Source: inc/thorvg.h ColorSpace; cpu_engine/tvgSwRaster.cpp rasterConvertCS.

07 Alpha — channel lengths and source-over contributions
Claim: A=128 scales RGB by integer /256 while A itself stays unchanged.
Beats: four original channel values; each duplicate moves and shrinks to its
premultiplied value (A moves without shrinking); actual /256 equation;
inverse equation RGB x 255 / 128; copies return left and expand to (199,99,0,128)
while original left values disappear, demonstrating integer round-trip loss;
the two weighted RGB contributions converge; final RGB=(100,50,100).
Straight=(200,100,0,128); premultiplied=(100,50,0,128).
Opaque destination=(0,0,200,255); its inverse-alpha contribution=(0,0,100).
Output A=255. The bottom dark swatches visualize weighted RGB contributions,
not an unpremultiplication or a comparison of perceived straight/premul colors.
Source: tvgSwCommon.h PREMULTIPLY/ALPHA_BLEND; tvgSwRaster.cpp rasterPremultiply.

08 Format — flags, not file-extension dispatch
Claim: premultiply skipping and destination-read skipping are independent.
Beats: JPG flags enable both shortcuts; opaque WebP follows the same route;
WebP with alpha bypasses premultiply but blends; static PNG requires premultiply
and then blends. Underline below true is the bypass; RGB x A is the executed step.
Representative normal Direct route, opacity=255, no masks/custom blend.
PNG decoder does not set alphaIgnored even if a particular image is opaque.
WebP + alpha and PNG demo texel A=128, source RGB=(200,100,40).
Premul=(100,50,20); destination RGB=(71,122,181); result=(135,111,110).
The 150px destination strip is deliberately wider than the copied 90px source
so unchanged destination remains visible at both ends. Timings are illustrative.
Source: jpg/png/webp loaders; tvgSwRenderer.cpp SwImageTask::run;
tvgSwRaster.cpp normal image Direct paths.

09 update / prepare — source alias and transformed geometry
Claim: prepare connects shared Source and computes transformed bounds, without
copying the source buffer or writing target pixels.
Beats: Source stays fixed; update composes M; prepare creates/connects task;
source alias is drawn to the same buffer; run normalizes channel/alpha state;
image outline rotates by 30 degrees; its enclosing axis-aligned renderBox appears.
Representative non-clipped Transform update, opacity>0, clipBox contains outline.
The diagram shows logical dependency order, not an observed thread schedule.
Matrix is abbreviated T x R x S with origin at center; original image is 176x176.
The bounding box is continuous explanatory geometry (240.420px), not the CPU
integer/fixed-point rounding implementation. No rasterized target is shown.
Source: tvgPicture.h PictureImpl::update; tvgSwRenderer.cpp prepare,
prepareCommon, SwImageTask::run; tvgSwImage.cpp imagePrepare.

Validation
All 1,759 encoded frames audited: no text collisions or canvas overflow;
minimum text gap 20.78px, minimum canvas inset 17.83px.
Raster probes: all 64 corresponding source/target cells retain identical colors;
source-over result and all four format-row output colors match integer values;
recovered red/green bar endpoints and unchanged alpha bars are raster-probed;
transformed outline bounds agree with rotation geometry within stroke tolerance.
These are numerical renderer checks. No new inline visual inspection was performed:
the tmath skill's two-raster-call budget was already used earlier in this thread.
Review PNGs, encoded-frame audits and playback results are kept in ignored temp/.

Unpremultiply source: tvgSwRaster.cpp:1568, early return at A=0 or 255.
The inverse in scene 07 acts on the original semi-transparent source example,
not the opaque source-over result. Production straight target conversion occurs
in SwRenderer::postRender() for ABGR8888S / ARGB8888S.

Lecture slides image-14.webp / image-15.webp (reference inputs, not render reviews)
--------------------------------------------------------------------------------
Their useful additions are format compatibility for reuse and visible transparency.
Slides are not embedded verbatim: RGB24 in the alpha slide can conflate premultiply
with flattening onto a background. Here both representations retain Alpha.
06 revised opening beats: stationary RGBA memory bytes; Renderer channel slots
move up and align with those exact bytes; one buffer remains; then the existing
R/B exchange illustrates incompatible ordering. No diagonal pointer lines, App
labels or detached condition text. This is a compatibility illustration, not an
execution trace showing copies between source and final output.
07 revised opening beats: one stationary 24x24 bitmap over a coarse checkerboard;
one Alpha slider controls opacity 255 ->128 ->0 ->128 continuously; then stored
RGB and unpremultiply examples follow. The image and background do not move or
get replaced during fading. Previous paired images/formulas removed from intro.
RGBA storage comparison remains in the following bar scene.

Regression evidence for the intro correction
The old ColorSpace diagonal connectors crossed address label regions. Prior text
checks compared only text against text, so they could not catch this. The old Alpha
intro split attention across two repeated images and equations, with stepwise A
labels. The revised intro concentrates on one image and one continuous control.
Every intro frame now checks Text against Rectangle/Line/Cell/Point paint bounds
with a 4px minimum gap, in addition to the existing full-video text checks.
At four settled Alpha states, 2,304 image sample locations agree with expected
source-over values within 2 units (integer opacity rounding), and slider position
matches A within 0.1px. Final storage/swap/composite probes remain in place.
No additional inline raster inspection was performed; the thread review budget
was already exhausted. Normal-speed browser playback and numerical checks are
recorded in temp; they do not constitute a new manual visual review.
