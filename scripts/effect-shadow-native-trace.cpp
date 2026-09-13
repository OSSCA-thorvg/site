// The pinned CPU translation units are included without modification.
// Capture the single-effect DropShadow path and verify every stage against it.
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
    SwCanvas* canvas = SwCanvas::gen();
    Scene* group = Scene::gen();
    Shape* shapes[3];
    Input(bool variant)
    {
        assert(canvas->target(pixels.data(), W, W, H, ColorSpace::ABGR8888) == Result::Success);
        shapes[0] = Shape::gen(); shapes[0]->appendRect(0, 0, W, H); shapes[0]->fill(234, 241, 236);
        shapes[1] = Shape::gen();
        const auto dx = variant ? 0.75f : 0.0f;
        shapes[1]->moveTo(7 + dx, 5); shapes[1]->lineTo(3 + dx, 19);
        shapes[1]->lineTo(18 + dx, 19); shapes[1]->close(); shapes[1]->fill(230, 97, 33);
        shapes[2] = Shape::gen(); shapes[2]->appendCircle(16, 13, 5, 5); shapes[2]->fill(31, 102, 196);
        group->opacity(128);
        group->add(SceneEffect::DropShadow, 32, 40, 52, 180, variant ? 215.0 : 135.0, 4.0, 1.4, 100);
        group->add(shapes[1]); group->add(shapes[2]);
        canvas->add(shapes[0]); canvas->add(group);
        assert(canvas->update() == Result::Success);
    }
    ~Input() { delete canvas; }
};

static Pixels snapshot(const uint32_t* data, int stride, const RenderRegion& box)
{
    Pixels result(W * H, 0);
    for (int y = box.min.y; y < box.max.y; ++y)
        for (int x = box.min.x; x < box.max.x; ++x) result[y * W + x] = data[y * stride + x];
    return result;
}

static void emit(const Pixels& data)
{
    std::printf("[");
    for (unsigned i = 0; i < data.size(); ++i) std::printf("%s%u", i ? "," : "", data[i]);
    std::printf("]");
}

int main(int argc, char**)
{
    assert(Initializer::init(2) == Result::Success);
    {
        const bool variant = argc > 1;
        Input input(variant);
        auto scene = static_cast<SceneImpl*>(input.group);
        auto renderer = static_cast<SwRenderer*>(scene->impl.renderer);
        SwShapeTask* tasks[3];
        for (unsigned i = 0; i < 3; ++i) {
            tasks[i] = static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(input.shapes[i])->impl.rd);
            tasks[i]->done();
        }
        assert(renderer->preRender());
        assert(renderer->renderShape(tasks[0]));
        const auto background = input.pixels;
        auto cmp = static_cast<SwCompositor*>(renderer->target(scene->bounds(), renderer->colorSpace(), scene->impl.cmpFlag));
        assert(renderer->beginComposite(cmp, MaskMethod::None, scene->opacity));
        assert(renderer->renderShape(tasks[1]) && renderer->renderShape(tasks[2]));
        const auto bbox = cmp->bbox;
        const auto original = snapshot(cmp->image.buf32, cmp->image.stride, bbox);
        const auto originalStorage = cmp->image.buf32;
        auto params = static_cast<RenderEffectDropShadow*>((*scene->effects)[0]);
        auto data = static_cast<SwDropShadow*>(params->rd);
        assert(params->valid && scene->effects->count == 1);
        const auto direct = scene->effects->count == 1 && scene->impl.marked(CompositionFlag::PostProcessing);
        assert(direct);
        const auto color = cmp->recoverSfc->join(params->color[0], params->color[1], params->color[2], 255);
        const auto opacity = MULTIPLY(params->color[3], cmp->opacity);
        const auto w = bbox.w(), h = bbox.h();
        const RenderRegion transposed{{bbox.min.y, bbox.min.x}, {bbox.max.y, bbox.max.x}};
        Pixels front = original, back(W * H, 0);
        std::printf("{\"width\":24,\"height\":24,\"groupOpacity\":128,\"color\":[32,40,52,180],\"angle\":%g,\"distance\":4,\"sigma\":1.4,\"quality\":100,\"direct\":true,\"shadowOpacity\":%u,\"offset\":[%d,%d],\"bbox\":[%d,%d,%d,%d],\"kernels\":[", params->angle, opacity, data->offset.x, data->offset.y, bbox.min.x, bbox.min.y, bbox.max.x, bbox.max.y);
        for (int i = 0; i < data->level; ++i) std::printf("%s%d", i ? "," : "", data->kernel[i]);
        std::printf("],\"background\":"); emit(background);
        std::printf(",\"original\":"); emit(original);
        std::printf(",\"passes\":[");
        bool first = true;
        auto pass = [&](const char* op, int kernel, bool flipped) {
            const auto box = flipped ? transposed : bbox;
            std::printf("%s{\"op\":\"%s\",\"radius\":%d,\"flipped\":%s,\"region\":[%d,%d,%d,%d],\"pixels\":", first ? "" : ",", op, kernel, flipped ? "true" : "false", box.min.x, box.min.y, box.max.x, box.max.y);
            emit(snapshot(front.data(), W, box)); std::printf("}"); first = false;
        };
        for (int i = 0; i < data->level; ++i) {
            _dropShadowFilter(back.data(), front.data(), W, w, h, bbox, data->kernel[i], color, false);
            front.swap(back); pass("H", data->kernel[i], false);
        }
        rasterXYFlip(front.data(), back.data(), W, w, h, bbox, false);
        front.swap(back); pass("transpose", 0, true);
        for (int i = 0; i < data->level; ++i) {
            _dropShadowFilter(back.data(), front.data(), W, h, w, bbox, data->kernel[i], color, true);
            front.swap(back); pass("V", data->kernel[i], true);
        }
        rasterXYFlip(front.data(), back.data(), W, h, w, bbox, true);
        front.swap(back); pass("transpose", 0, false);
        const auto filtered = snapshot(front.data(), W, bbox);
        auto shadowCanvas = background;
        _dropShadowShift(shadowCanvas.data(), front.data(), W, W, W, H, bbox, data->offset, opacity, true);
        Pixels shifted(W * H, 0);
        _dropShadowShift(shifted.data(), front.data(), W, W, W, H, bbox, data->offset, opacity, false);
        assert(renderer->render(cmp, params, direct));
        assert(input.pixels == shadowCanvas);
        assert(cmp->image.buf32 == originalStorage);
        assert(snapshot(cmp->image.buf32, cmp->image.stride, bbox) == original);
        assert(renderer->compositors.count == 3);
        const auto& nativeFiltered = renderer->compositors[1]->compositor->image;
        assert(snapshot(nativeFiltered.buf32, nativeFiltered.stride, bbox) == filtered);
        std::printf("],\"filtered\":"); emit(filtered);
        std::printf(",\"shifted\":"); emit(shifted);
        std::printf(",\"shadowCanvas\":"); emit(shadowCanvas);
        assert(renderer->endComposite(cmp));
        assert(renderer->postRender());
        const auto final = input.pixels;
        Input reference(variant);
        assert(reference.canvas->draw(true) == Result::Success);
        assert(reference.canvas->sync() == Result::Success);
        assert(reference.pixels == final);
        std::printf(",\"final\":"); emit(final);
        std::printf(",\"temporaryBuffers\":3,\"verifiedBlurReplay\":true,\"verifiedShiftReplay\":true,\"verifiedOriginalRestored\":true,\"verifiedCanvasMatch\":true}\n");
    }
    Initializer::term();
}
