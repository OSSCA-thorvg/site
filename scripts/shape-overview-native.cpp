// Evidence probe: instrumented copy of tvgSwRle.cpp, engine checkout unchanged.
#include <cassert>
#include <cstdio>
#include <vector>
#include <algorithm>
#include "shape-rle-instrumented.cpp"

static void spans(const SwRle& rle)
{
    printf("[");
    for (unsigned i = 0; i < rle.spans.count; ++i) {
        const auto& s = rle.spans[i];
        printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}", i ? "," : "", s.x, s.y, s.len, s.coverage);
    }
    printf("]");
}

int main(int argc, char**)
{
    const float dx = argc > 1 ? .25f : 0;
    const PathCommand commands[] = {PathCommand::MoveTo, PathCommand::CubicTo, PathCommand::CubicTo,
        PathCommand::LineTo, PathCommand::LineTo, PathCommand::CubicTo, PathCommand::Close,
        PathCommand::MoveTo, PathCommand::LineTo, PathCommand::LineTo, PathCommand::LineTo, PathCommand::Close};
    Point points[] = {{2.25,11.75}, {.5,6.25},{4.75,1.25},{9.25,2.25},
        {13.5,.5},{18.5,3.25},{17.75,7.25}, {14.25,7.75},{18.25,12.75},
        {12.5,15.5},{6.75,14.75},{2.25,11.75}, {6.25,6.25},{10.75,5.25},{11.25,9.25},{7.25,10.25}};
    for (auto& p : points) p.x += dx;
    RenderPath path;
    SwOutline outline;
    outline.path = &path;
    unsigned pi = 0;
    for (const auto command : commands) {
        path.cmds.push(command);
        if (command == PathCommand::Close) continue;
        const auto count = command == PathCommand::CubicTo ? 3 : 1;
        for (int j = 0; j < count; ++j, ++pi) {
            outline.out.push({int32_t(points[pi].x * 64), int32_t(points[pi].y * 64)});
            path.pts.push(points[pi]);
        }
    }
    outline.fillRule = FillRule::EvenOdd;
    RenderRegion bbox; bbox.min = {0,0}; bbox.max = {20,16};
    SwMpool pool(0);
    auto cp = pool.cell(0);
    tvg::free(cp->buffer); cp->size = 24 * sizeof(SwCell); cp->buffer = tvg::malloc<SwCell>(cp->size);
    capture = true;
    auto rle = rleRender(nullptr, &outline, bbox, &pool, 0, true);
    capture = false;
    assert(rle);
    SwMpool normalPool(0);
    auto normal = rleRender(nullptr, &outline, bbox, &normalPool, 0, true);
    assert(normal && normal->spans.count == rle->spans.count);
    for (unsigned i = 0; i < rle->spans.count; ++i) {
        const auto& a = rle->spans[i]; const auto& b = normal->spans[i];
        assert(a.x == b.x && a.y == b.y && a.len == b.len && a.coverage == b.coverage);
    }
    constexpr unsigned w = 20, h = 16, stride = 24, background = 0xffffffff;
    std::vector<uint32_t> pixels(stride * h, background), replay = pixels;
    Initializer::init(0);
    auto canvas = SwCanvas::gen();
    assert(canvas->target(pixels.data(), stride, w, h, ColorSpace::ABGR8888) == Result::Success);
    auto shape = Shape::gen(); shape->appendPath(commands, 12, points, 16);
    shape->fillRule(FillRule::EvenOdd); shape->fill(32,120,220); canvas->add(shape);
    assert(canvas->update() == Result::Success); assert(canvas->draw(false) == Result::Success); canvas->sync();
    SwSurface surface; surface.setup(replay.data(), stride, w, h, 4, ColorSpace::ABGR8888);
    assert(rasterCompositor(&surface) == Result::Success);
    SwShape sw{}; sw.rle = rle;
    RenderColor color{32,120,220,255};
    assert(rasterShape(&surface, &sw, bbox, color));
    assert(replay == pixels);
    printf("{\"w\":20,\"h\":16,\"stride\":24,\"background\":%u,\"poolBytes\":%u,\"rule\":\"evenodd\",\"path\":{\"cmds\":[", background, cp->size);
    for (unsigned i = 0; i < 12; ++i) printf("%s%d", i ? "," : "", int(commands[i]));
    printf("],\"pts\":[");
    for (unsigned i = 0; i < 16; ++i) printf("%s[%g,%g]", i ? "," : "", points[i].x, points[i].y);
    printf("]},\"bands\":[");
    for (unsigned i = 0; i < recorded.size(); ++i) {
        const auto& band = recorded[i];
        printf("%s{\"lo\":%d,\"hi\":%d,\"ok\":%s,\"events\":[", i ? "," : "", band.lo, band.hi, band.ok ? "true" : "false");
        for (unsigned j = 0; j < band.events.size(); ++j) {
            const auto& e = band.events[j];
            if (e.kind == 0) printf("%s{\"type\":\"line\",\"from\":[%.10g,%.10g],\"to\":[%.10g,%.10g]}", j ? "," : "", e.a/256.0,e.b/256.0,e.c/256.0,e.d/256.0);
            else printf("%s{\"type\":\"cell\",\"x\":%ld,\"y\":%ld,\"cover\":%ld,\"area\":%ld}", j ? "," : "",e.a,e.b,e.c,e.d);
        }
        printf("],\"cells\":[");
        for (unsigned j = 0; j < band.cells.size(); ++j) {
            const auto& c = band.cells[j];
            printf("%s{\"x\":%ld,\"y\":%ld,\"cover\":%ld,\"area\":%ld}", j ? "," : "",c.a,c.b,c.c,c.d);
        }
        printf("]}");
    }
    printf("],\"spans\":"); spans(*rle);
    printf(",\"pixels\":["); for (unsigned i = 0; i < pixels.size(); ++i) printf("%s%u", i ? "," : "", pixels[i]);
    printf("],\"verifiedCanvas\":true,\"verifiedNormalPool\":true}\n");
    delete canvas; rleFree(rle); rleFree(normal); Initializer::term();
}
