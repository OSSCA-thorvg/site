// ThorVG 4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad, read-only CPU source.
// See public/tmath/update/README.md for the static-library build command.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgPicture.h"
#include "tvgSwRenderer.cpp"

static void record(const char* id, Matrix matrix, bool clipped, int dx)
{
    matrix.e13 += dx;
    auto canvas = SwCanvas::gen();
    std::vector<uint32_t> pixels(12 * 12, 0);
    assert(canvas->target(pixels.data(), 12, 12, 12, ColorSpace::ABGR8888) == Result::Success);
    uint32_t source[] = {0xff2161e6, 0xffc4661f, 0xffdedede, 0xffffffff};
    auto picture = Picture::gen();
    assert(picture->load(source, 2, 2, ColorSpace::ABGR8888, false) == Result::Success);
    picture->size(2, 2);
    picture->filter(FilterMethod::Bilinear);
    picture->transform(matrix);
    if (clipped) {
        auto clip = Shape::gen();
        clip->moveTo(3 + dx, 3); clip->lineTo(10 + dx, 4); clip->lineTo(6 + dx, 10); clip->close();
        picture->clip(clip);
    }
    canvas->add(picture);
    assert(canvas->update() == Result::Success);
    auto task = static_cast<SwImageTask*>(static_cast<PictureImpl*>(picture)->impl.rd);
    task->done();
    assert(task->valid && task->image.data == task->source->data);
    assert(task->image.w == 2 && task->image.h == 2 && task->image.stride == 2);
    assert(task->image.filter == FilterMethod::Bilinear);
    assert(bool(task->image.rle) == clipped && task->clips.count == unsigned(clipped));
    for (auto pixel : pixels) assert(pixel == 0);
    const auto& im = task->image;
    std::printf("{\"id\":\"%s\",\"matrix\":[%g,%g,%g,%g,%g,%g],", id,
        matrix.e11, matrix.e12, matrix.e13, matrix.e21, matrix.e22, matrix.e23);
    std::printf("\"direct\":%s,\"scaled\":%s,\"offset\":", im.direct ? "true" : "false", im.scaled ? "true" : "false");
    if (im.direct) std::printf("[%d,%d],\"scale\":null,", im.ox, im.oy);
    else std::printf("null,\"scale\":%.9g,", im.scale);
    const auto& box = task->curBox;
    std::printf("\"curBox\":[%d,%d,%d,%d],\"corners\":[", box.min.x, box.min.y, box.max.x, box.max.y);
    Point corners[] = {{0,0},{2,0},{2,2},{0,2}};
    for (unsigned i = 0; i < 4; ++i) {
        auto p = corners[i] * matrix;
        std::printf("%s[%g,%g]", i ? "," : "", p.x, p.y);
    }
    std::printf("],\"clipPoints\":[");
    if (clipped) std::printf("[%d,3],[%d,4],[%d,10]", 3 + dx, 10 + dx, 6 + dx);
    std::printf("],\"clips\":%u,\"rle\":", task->clips.count);
    if (!im.rle) std::printf("null");
    else {
        std::printf("[");
        for (unsigned i = 0; i < im.rle->size(); ++i) {
            const auto& s = im.rle->data()[i];
            std::printf("%s[%d,%d,%d,%u]", i ? "," : "", s.x, s.y, s.len, s.coverage);
        }
        std::printf("]");
    }
    std::printf(",\"sourceAlias\":true,\"canvasUntouched\":true}");
    delete canvas;
}

int main(int argc, char**)
{
    assert(Initializer::init(0) == Result::Success);
    const int dx = argc > 1 ? 1 : 0;
    std::printf("[\n");
    record("direct", {1,0,3,0,1,4,0,0,1}, false, dx); std::printf(",\n");
    record("scaled", {3,0,3,0,2,4,0,0,1}, false, dx); std::printf(",\n");
    record("transformed", {3,-1,4,1,3,2,0,0,1}, false, dx); std::printf(",\n");
    record("clipped", {3,-1,4,1,3,2,0,0,1}, true, dx); std::printf("\n]\n");
    Initializer::term();
}
