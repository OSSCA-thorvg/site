// Evidence harness: the engine translation units are included unmodified.
// Replays the Scene render sequence, then compares all pixels with public Canvas.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgScene.h"
#include "tvgSwRenderer.cpp"
#include "tvgSwPostEffect.cpp"

constexpr unsigned W = 24, H = 24;
using Pixels = std::vector<uint32_t>;

struct Input
{
    Pixels pixels = Pixels(W * H, 0);
    SwCanvas* canvas;
    Scene* group;
    Shape* shapes[3];

    Input(float dx = 0)
    {
        canvas = SwCanvas::gen();
        assert(canvas->target(pixels.data(), W, W, H, ColorSpace::ABGR8888) == Result::Success);
        shapes[0] = Shape::gen();
        shapes[0]->appendRect(0, 0, W, H);
        shapes[0]->fill(234, 241, 236);
        group = Scene::gen();
        group->opacity(128);
        group->add(SceneEffect::GaussianBlur, 1.4, 0, 0, 100);
        group->add(SceneEffect::Fill, 49, 150, 123, 255);
        shapes[1] = Shape::gen();
        shapes[1]->moveTo(7 + dx, 5);
        shapes[1]->lineTo(3 + dx, 19);
        shapes[1]->lineTo(18 + dx, 19);
        shapes[1]->close();
        shapes[1]->fill(230, 97, 33);
        shapes[2] = Shape::gen();
        shapes[2]->appendCircle(16, 13, 5, 5);
        shapes[2]->fill(31, 102, 196);
        group->add(shapes[1]); group->add(shapes[2]);
        canvas->add(shapes[0]); canvas->add(group);
        assert(canvas->update() == Result::Success);
    }
    ~Input() { delete canvas; }
};

static Pixels snapshot(const SwImage& image, const RenderRegion& region)
{
    Pixels result;
    for (unsigned y = 0; y < H; ++y)
        for (unsigned x = 0; x < W; ++x) result.push_back(x >= unsigned(region.min.x) && x < unsigned(region.max.x) && y >= unsigned(region.min.y) && y < unsigned(region.max.y) ? image.buf32[y * image.stride + x] : 0);
    return result;
}

static void pixels(const Pixels& data)
{
    std::printf("[");
    for (unsigned i = 0; i < data.size(); ++i) std::printf("%s%u", i ? "," : "", data[i]);
    std::printf("]");
}

int main(int argc, char**)
{
    assert(Initializer::init(2) == Result::Success);
    {
        Input input(argc > 1 ? 0.75f : 0);
        auto scene = static_cast<SceneImpl*>(input.group);
        auto renderer = static_cast<SwRenderer*>(scene->impl.renderer);
        SwShapeTask* tasks[3];
        std::printf("{\"width\":24,\"height\":24,\"opacity\":128,\"sigma\":1.4,\"threads\":%u,\"tasks\":[", TaskScheduler::threads());
        for (unsigned i = 0; i < 3; ++i) {
            tasks[i] = static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(input.shapes[i])->impl.rd);
            tasks[i]->done();
            assert(tasks[i]->valid && tasks[i]->opacity == 255);
            const auto& path = tasks[i]->rshape->path;
            std::printf("%s{\"id\":\"%s\",\"opacity\":%u,\"fastTrack\":%s,\"points\":[", i ? "," : "", i == 0 ? "BG" : i == 1 ? "A" : "B", tasks[i]->opacity, tasks[i]->shape.fastTrack ? "true" : "false");
            for (unsigned p = 0; p < path.pts.count; ++p) std::printf("%s[%g,%g]", p ? "," : "", path.pts[p].x, path.pts[p].y);
            std::printf("],\"spans\":[");
            const auto rle = tasks[i]->shape.rle;
            if (rle) for (unsigned j = 0; j < rle->size(); ++j) {
                const auto span = rle->data()[j];
                std::printf("%s[%d,%d,%d,%u]", j ? "," : "", span.x, span.y, span.len, span.coverage);
            }
            std::printf("]}");
        }
        assert(renderer->preRender());
        assert(renderer->renderShape(tasks[0]));
        assert(renderer->compositors.count == 0);
        const auto background = input.pixels;
        auto cmp = static_cast<SwCompositor*>(renderer->target(scene->bounds(), renderer->colorSpace(), scene->impl.cmpFlag));
        assert(cmp && scene->opacity == 128);
        assert(renderer->compositors.count == 1);
        const auto offscreenStorage = cmp->image.buf32;
        assert(renderer->beginComposite(cmp, MaskMethod::None, scene->opacity));
        std::printf("],\"flags\":%u,\"bbox\":[%d,%d,%d,%d],\"background\":", unsigned(scene->impl.cmpFlag), cmp->bbox.min.x, cmp->bbox.min.y, cmp->bbox.max.x, cmp->bbox.max.y);
        pixels(background);
        std::printf(",\"writes\":[");
        for (unsigned i = 1; i < 3; ++i) {
            auto replay = snapshot(cmp->image, cmp->bbox);
            SwSurface surface;
            surface.setup(replay.data(), W, W, H, 4, ColorSpace::ABGR8888);
            assert(rasterCompositor(&surface) == Result::Success);
            RenderColor color;
            tasks[i]->rshape->fillColor(&color.r, &color.g, &color.b, &color.a);
            std::printf("%s[", i == 2 ? "," : "");
            const auto rle = tasks[i]->shape.rle;
            for (unsigned j = 0; j < rle->size(); ++j) {
                const auto span = rle->data()[j];
                SwRle one; one.spans.push(span);
                auto shape = tasks[i]->shape; shape.rle = &one;
                assert(rasterShape(&surface, &shape, tasks[i]->shape.bbox, color));
                std::printf("%s{\"x\":%d,\"y\":%d,\"pixels\":[", j ? "," : "", span.x, span.y);
                for (unsigned x = 0; x < span.len; ++x) std::printf("%s%u", x ? "," : "", replay[span.y * W + span.x + x]);
                std::printf("]}");
            }
            std::printf("]");
            assert(renderer->renderShape(tasks[i]));
            assert(replay == snapshot(cmp->image, cmp->bbox));
        }
        const auto before = snapshot(cmp->image, cmp->bbox);
        auto params = static_cast<RenderEffectGaussianBlur*>((*scene->effects)[0]);
        auto data = static_cast<SwGaussianBlur*>(params->rd);
        std::printf("],\"offscreen\":"); pixels(before);
        std::printf(",\"kernels\":[");
        for (int i = 0; i < data->level; ++i) std::printf("%s%d", i ? "," : "", data->kernel[i]);
        std::printf("],\"passes\":[");
        Pixels front = before, back(W * H, 0);
        const auto width = cmp->bbox.w(), height = cmp->bbox.h();
        bool first = true;
        unsigned passIndex = 0;
        const auto emit = [&](const char* op) {
            const auto toScratch = (passIndex++ % 2) == 0;
            std::printf("%s{\"op\":\"%s\",\"from\":\"%s\",\"to\":\"%s\",\"pixels\":", first ? "" : ",", op, toScratch ? "offscreen" : "scratch", toScratch ? "scratch" : "offscreen"); first = false;
            pixels(front); std::printf("}");
        };
        for (int i = 0; i < data->level; ++i) {
            _gaussianFilter(reinterpret_cast<uint8_t*>(back.data()), reinterpret_cast<uint8_t*>(front.data()), W, width, height, cmp->bbox, data->kernel[i], false);
            front.swap(back); emit("H");
        }
        rasterXYFlip(front.data(), back.data(), W, width, height, cmp->bbox, false);
        front.swap(back); emit("transpose");
        for (int i = 0; i < data->level; ++i) {
            _gaussianFilter(reinterpret_cast<uint8_t*>(back.data()), reinterpret_cast<uint8_t*>(front.data()), W, height, width, cmp->bbox, data->kernel[i], true);
            front.swap(back); emit("V");
        }
        rasterXYFlip(front.data(), back.data(), W, height, width, cmp->bbox, true);
        front.swap(back); emit("transpose");
        // Match SceneImpl::render(): chains disable the single-effect direct path.
        assert(scene->effects->count == 2);
        assert(renderer->render(cmp, params, false));
        assert(renderer->compositors.count == 2);
        const auto scratch = renderer->compositors[1];
        const auto scratchStorage = scratch->compositor->image.buf32;
        assert(cmp->image.buf32 == offscreenStorage);
        assert(scratch->compositor->image.buf32 != offscreenStorage);
        // The selected eight-pass blur finishes in the original offscreen.
        // Scratch holds the preceding, transposed pass; inspect only written pixels.
        const RenderRegion flipped{{cmp->bbox.min.y, cmp->bbox.min.x}, {cmp->bbox.max.y, cmp->bbox.max.x}};
        for (int y = flipped.min.y; y < flipped.max.y; ++y)
            for (int x = flipped.min.x; x < flipped.max.x; ++x)
                assert(back[y * W + x] == scratch->compositor->image.buf32[y * W + x]);
        const auto filtered = snapshot(cmp->image, cmp->bbox);
        for (int y = cmp->bbox.min.y; y < cmp->bbox.max.y; ++y)
            for (int x = cmp->bbox.min.x; x < cmp->bbox.max.x; ++x) assert(front[y * W + x] == filtered[y * W + x]);
        std::printf("],\"filtered\":"); pixels(filtered);
        assert(input.pixels == background);
        auto fill = (*scene->effects)[1];
        assert(fill->valid && renderer->render(cmp, fill, false));
        assert(renderer->compositors.count == 2 && cmp->image.buf32 == offscreenStorage);
        const auto recolored = snapshot(cmp->image, cmp->bbox);
        assert(input.pixels == background);
        for (unsigned i = 0; i < recolored.size(); ++i) assert((recolored[i] >> 24) == (filtered[i] >> 24));
        std::printf(",\"chain\":[{\"effect\":\"GaussianBlur\",\"output\":"); pixels(filtered);
        std::printf("},{\"effect\":\"Fill\",\"color\":[49,150,123,255],\"output\":"); pixels(recolored);
        std::printf("}],\"compositionInput\":"); pixels(recolored);
        std::printf(",\"parentBeforeComposite\":"); pixels(input.pixels);
        const auto parentSurface = cmp->recoverSfc;
        assert(renderer->endComposite(cmp));
        assert(renderer->surface == parentSurface);
        assert(cmp->valid && scratch->compositor->valid);
        assert(renderer->postRender());
        const auto final = input.pixels;
        Input reference(argc > 1 ? 0.75f : 0);
        assert(reference.canvas->draw(true) == Result::Success);
        assert(reference.canvas->sync() == Result::Success);
        assert(reference.pixels == final);
        // A subsequent public draw reuses the two cached engine buffers.
        assert(input.canvas->draw(true) == Result::Success);
        assert(input.canvas->sync() == Result::Success);
        assert(renderer->compositors.count == 2);
        assert(cmp->image.buf32 == offscreenStorage && scratch->compositor->image.buf32 == scratchStorage && input.pixels == final);
        std::printf(",\"final\":"); pixels(final);
        std::printf(",\"buffers\":{\"parent\":1,\"offscreen\":1,\"scratch\":1,\"temporaryPeak\":2,\"afterTarget\":1,\"afterBlur\":2,\"afterFill\":2,\"cachedAfterComposite\":2,\"reusedNextDraw\":true,\"fillInPlace\":true,\"blurEndsInOriginalOffscreen\":true}");
        std::printf(",\"direct\":false,\"verifiedCanvasMatch\":true,\"verifiedSpanReplay\":true,\"verifiedBlurReplay\":true,\"verifiedDeferredComposition\":true,\"verifiedParentRestored\":true}\n");
    }
    Initializer::term();
}
