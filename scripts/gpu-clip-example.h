// Clip fixture for the GPU Engine Clipping articles (GL + WebGPU).
// One 640 × 320 canvas, two cases side by side. No parent of a clipped paint or of
// a clipper has a transform, so the traced clip geometry is in canvas coordinates.
//
//  A (left)  a solid rectangle clipped by a circle: Paint::clip(Shape*) on a Shape.
//            GL: GlRenderer::renderShape → drawClip (one GlClipTask).
//            WGPU: WgCompositor::renderClipPath (one clip) → clipShape → clearClipPath.
//  B (right) a raw "photo" Picture clipped by a circle, inside a Scene clipped by a
//            rounded card. The picture's clip list is [card, circle] (the scene's
//            clipper is pushed first: tvgPaint.cpp Paint::Impl::update, tvgScene.h).
//            GL: renderImage → drawClip loop over two clips.
//            WGPU: renderClipPath loop (AND merge) → clipImage → clearClipPath.
//
// Neither clipper is a 4-point path (circle: 13 points, rounded rect: 17), so neither
// takes the axis-aligned rectangle fast track in Paint::Impl::update (_compFastTrack).
// Public ThorVG API only; the ThorVG checkout is never modified.
#ifndef GPU_CLIP_EXAMPLE_H
#define GPU_CLIP_EXAMPLE_H

#include <cstdio>
#include <string>
#include <vector>
#include "thorvg.h"
#include "gpu-example-fixture.h"

namespace gpuClipExample {

constexpr uint32_t width = 640;
constexpr uint32_t height = 320;

// Case A: rectangle 40..280 × 50..270, clip circle 70..250 × 70..250
// (the rectangle extends 30 px beyond the circle left/right and 20 px top/bottom).
constexpr float rectX = 40, rectY = 50, rectW = 240, rectH = 220;
constexpr uint8_t rectColor[4] = {230, 110, 50, 255};
constexpr float rectClipX = 160, rectClipY = 160, rectClipR = 90;

// Case B: photo 240 × 240 at (360, 40); clip circle 365..545 × 60..240; card
// 465..590 × 105..255 with 28 px corners. Circle ∩ card ≈ 465..545 × 105..240.
constexpr uint32_t photoW = 240, photoH = 240, photoCell = 24;
constexpr float photoX = 360, photoY = 40;
constexpr uint8_t photoColors[2][4] = {{250, 214, 120, 255}, {44, 96, 160, 255}};
constexpr float photoClipX = 455, photoClipY = 150, photoClipR = 90;
constexpr float cardX = 465, cardY = 105, cardW = 125, cardH = 150, cardR = 28;

// Opaque 24 px two-colour checker, so a clip boundary cuts visibly across cells.
// ColorSpace::ABGR8888 is 0xAABBGGRR per pixel (bytes R, G, B, A in memory), premultiplied;
// with alpha 255 the premultiplied value is the colour itself.
inline uint32_t photoPixel(uint32_t x, uint32_t y)
{
    auto c = photoColors[((x / photoCell) + (y / photoCell)) % 2];
    return (uint32_t(c[3]) << 24) | (uint32_t(c[2]) << 16) | (uint32_t(c[1]) << 8) | uint32_t(c[0]);
}

inline tvg::Shape* rect()
{
    auto shape = tvg::Shape::gen();
    shape->appendRect(rectX, rectY, rectW, rectH);
    shape->fill(rectColor[0], rectColor[1], rectColor[2], rectColor[3]);
    return shape;
}

inline tvg::Shape* rectClip()
{
    auto shape = tvg::Shape::gen();
    shape->appendCircle(rectClipX, rectClipY, rectClipR, rectClipR);
    return shape;
}

inline tvg::Shape* photoClip()
{
    auto shape = tvg::Shape::gen();
    shape->appendCircle(photoClipX, photoClipY, photoClipR, photoClipR);
    return shape;
}

inline tvg::Shape* cardClip()
{
    auto shape = tvg::Shape::gen();
    shape->appendRect(cardX, cardY, cardW, cardH, cardR, cardR);
    return shape;
}

inline tvg::Picture* photo(tvg::Result* loaded = nullptr)
{
    std::vector<uint32_t> pixels(photoW * photoH);
    for (uint32_t y = 0; y < photoH; ++y)
        for (uint32_t x = 0; x < photoW; ++x) pixels[y * photoW + x] = photoPixel(x, y);
    auto picture = tvg::Picture::gen();
    // copy = true: the raw loader keeps its own buffer (RawLoader::open), so `pixels` may go away.
    auto result = picture->load(pixels.data(), photoW, photoH, tvg::ColorSpace::ABGR8888, true);
    if (loaded) *loaded = result;
    picture->translate(photoX, photoY);
    return picture;
}

inline void build(tvg::Canvas* canvas)
{
    // A: one clip on a Shape.
    auto a = rect();
    a->clip(rectClip());
    canvas->add(a);

    // B: two nested clips on an image (card on the scene, circle on the picture).
    auto picture = photo();
    picture->clip(photoClip());
    auto scene = tvg::Scene::gen();
    scene->add(picture);
    scene->clip(cardClip());
    canvas->add(scene);
}

// The traced shapes: separate instances with the same geometry, in canvas coordinates.
inline std::vector<GpuExampleFixture> fixtures()
{
    return {{"rect", "appendRect(40, 50, 240, 220); fill(230, 110, 50); clip(rectClip)", rect()},
            {"rectClip", "appendCircle(160, 160, 90, 90) as rect->clip()", rectClip()},
            {"photoClip", "appendCircle(455, 150, 90, 90) as photo->clip()", photoClip()},
            {"cardClip", "appendRect(465, 105, 125, 150, 28, 28) as scene->clip()", cardClip()}};
}

// Fixture facts that are not traced Shapes, as JSON (printed by the harness with -DGPU_EXAMPLE_META).
// The photo quad is measured through Paint::bounds() on a real Picture, not copied from the constants.
inline std::string meta()
{
    auto result = tvg::Result::Unknown;
    auto picture = photo(&result);
    tvg::Point quad[4] = {};
    float bx = 0, by = 0, bw = 0, bh = 0, pw = 0, ph = 0;
    auto quadOk = picture->bounds(quad) == tvg::Result::Success;
    auto boxOk = picture->bounds(&bx, &by, &bw, &bh) == tvg::Result::Success;
    picture->size(&pw, &ph);
    tvg::Paint::rel(picture);

    // FNV-1a over the pixel bytes in memory order (R, G, B, A), so a consumer can check its copy of photoPixel().
    uint32_t hash = 2166136261u;
    for (uint32_t y = 0; y < photoH; ++y) {
        for (uint32_t x = 0; x < photoW; ++x) {
            auto p = photoPixel(x, y);
            for (auto k = 0; k < 4; ++k) { hash ^= (p >> (8 * k)) & 0xffu; hash *= 16777619u; }
        }
    }

    char text[2048];
    snprintf(text, sizeof(text),
        "{\"caseA\":{\"target\":\"rect\",\"clips\":[\"rectClip\"],\"build\":\"rect->clip(rectClip); canvas->add(rect)\"},"
        "\"caseB\":{\"target\":\"photo\",\"build\":\"photo->clip(photoClip); scene->add(photo); scene->clip(cardClip); canvas->add(scene)\","
        "\"scene\":{\"api\":\"Scene::gen(); add(photo); clip(cardClip)\",\"transform\":\"identity\"},"
        "\"photo\":{\"api\":\"Picture::gen(); load(pixels, %u, %u, ColorSpace::ABGR8888, true); translate(%g, %g); clip(photoClip)\","
        "\"load\":\"%s\",\"size\":[%.8g,%.8g],\"translate\":[%.8g,%.8g],\"colorSpace\":\"ABGR8888\",\"premultiplied\":true,"
        "\"quadOk\":%s,\"quad\":[[%.8g,%.8g],[%.8g,%.8g],[%.8g,%.8g],[%.8g,%.8g]],\"boundsOk\":%s,\"bounds\":[%.8g,%.8g,%.8g,%.8g],"
        "\"pixel\":\"colors[((x / cell) + (y / cell)) %% 2], local x, y\",\"cell\":%u,\"colors\":[[%u,%u,%u,%u],[%u,%u,%u,%u]],\"fnv1a\":%u}}}",
        photoW, photoH, photoX, photoY,
        result == tvg::Result::Success ? "Success" : "Failure", pw, ph, photoX, photoY,
        quadOk ? "true" : "false", quad[0].x, quad[0].y, quad[1].x, quad[1].y, quad[2].x, quad[2].y, quad[3].x, quad[3].y,
        boxOk ? "true" : "false", bx, by, bw, bh,
        photoCell, photoColors[0][0], photoColors[0][1], photoColors[0][2], photoColors[0][3],
        photoColors[1][0], photoColors[1][1], photoColors[1][2], photoColors[1][3], hash);
    return text;
}

}  // namespace gpuClipExample

#endif
