// ThorVG b4471844c3c2f849ce82e0825798e2696a4a2cad, unchanged CPU engine.
// Link the existing CPU static build; no renderer translation unit is modified.
// c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC -I$build -I$thorvg/inc \
//   -I$thorvg/src/common -I$thorvg/src/renderer -I$thorvg/src/renderer/cpu_engine \
//   scripts/update-image-native-trace.cpp $build/src/libthorvg-1.a -lpthread -o /tmp/update-image-trace
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgPicture.h"
#include "tvgSwRenderer.cpp"

static void dump(SwRle* rle)
{
    std::printf("[");
    for (unsigned i = 0; i < rle->size(); ++i) {
        const auto span = rle->data()[i];
        std::printf("%s[%d,%d,%d,%u]", i ? "," : "", span.x, span.y, span.len, span.coverage);
    }
    std::printf("]");
}

int main(int argc, char**)
{
    const int dx = argc > 1 ? 1 : 0, dy = argc > 1 ? 2 : 0;
    SwMpool pool(0);
    SwImage image{};
    image.w = image.h = image.stride = 2;
    Matrix matrix{6, -2, float(9 + dx), 2, 6, float(3 + dy), 0, 0, 1};
    RenderRegion viewport{{0, 0}, {24, 24}}, box;
    assert(imagePrepare(image, matrix, viewport, box, &pool, 0));
    assert(imageGenRle(image, box, &pool, 0, false));
    std::printf("{\"matrix\":[6,-2,%d,2,6,%d],\"renderBox\":[%d,%d,%d,%d],\"spans\":",
        9 + dx, 3 + dy, box.min.x, box.min.y, box.max.x, box.max.y);
    dump(image.rle);
    auto paint = Shape::gen();
    paint->moveTo(8 + dx, 7 + dy);
    paint->lineTo(18 + dx, 10 + dy);
    paint->lineTo(11 + dx, 18 + dy);
    paint->close();
    paint->fill(255, 255, 255);
    SwShape clip{};
    RenderRegion clipBox;
    const auto identity = tvg::identity();
    assert(shapeGenRle(clip, &static_cast<ShapeImpl*>(paint)->rs, identity, viewport, clipBox, &pool, 0, false, true));
    assert(!clip.fastTrack);
    std::printf(",\"clipRle\":");
    dump(clip.rle);
    assert(rleClip(image.rle, clip.rle));
    std::printf(",\"clippedSpans\":");
    dump(image.rle);
    const std::vector<SwSpan> expected(image.rle->data(), image.rle->data() + image.rle->size());
    imageFree(image);
    shapeFree(clip);
    paint->unref();

    // Prove that the public example takes the same non-rect clip task branch.
    assert(Initializer::init(2) == Result::Success);
    std::vector<uint32_t> pixels(24 * 24, 0);
    uint32_t source[] = {0xff2161e6, 0xffc46b1f, 0x804080c0, 0xffeeeeee};
    auto canvas = SwCanvas::gen();
    assert(canvas->target(pixels.data(), 24, 24, 24, ColorSpace::ABGR8888) == Result::Success);
    auto picture = Picture::gen();
    assert(picture->load(source, 2, 2, ColorSpace::ABGR8888S, false) == Result::Success);
    picture->size(2, 2);
    picture->transform(matrix);
    auto mask = Shape::gen();
    mask->moveTo(8 + dx, 7 + dy);
    mask->lineTo(18 + dx, 10 + dy);
    mask->lineTo(11 + dx, 18 + dy);
    mask->close();
    picture->clip(mask);
    canvas->add(picture);
    assert(canvas->update() == Result::Success);
    auto task = static_cast<SwImageTask*>(static_cast<PictureImpl*>(picture)->impl.rd);
    task->done();
    assert(task->image.rle && task->image.rle->size() == expected.size());
    for (unsigned i = 0; i < expected.size(); ++i) {
        const auto& actual = task->image.rle->data()[i];
        const auto& wanted = expected[i];
        assert(actual.x == wanted.x && actual.y == wanted.y && actual.len == wanted.len && actual.coverage == wanted.coverage);
    }
    for (auto pixel : pixels) assert(pixel == 0);  // Update has not drawn Canvas pixels.
    std::printf(",\"publicApiMatch\":true,\"canvasUntouched\":true}\n");
    delete canvas;
    Initializer::term();
}
