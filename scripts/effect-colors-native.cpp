// Read-only engine evidence. Link against the unmodified b4471844 CPU library.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgScene.h"
#include "tvgSwRenderer.cpp"

constexpr unsigned W = 24, H = 24;
using Pixels = std::vector<uint32_t>;
struct Input {
    Pixels pixels = Pixels(W * H, 0);
    SwCanvas* canvas = SwCanvas::gen();
    Scene* scene = Scene::gen();
    Shape* shapes[3];
    Input(unsigned effect, bool variant) {
        assert(canvas->target(pixels.data(), W, W, H, ColorSpace::ABGR8888) == Result::Success);
        shapes[0] = Shape::gen(); shapes[0]->appendRect(0, 0, W, H); shapes[0]->fill(234, 241, 236);
        shapes[1] = Shape::gen(); const auto dx = variant ? .75f : 0.f;
        shapes[1]->moveTo(7 + dx, 5); shapes[1]->lineTo(3 + dx, 19); shapes[1]->lineTo(18 + dx, 19);
        shapes[1]->close(); shapes[1]->fill(variant ? 241 : 230, variant ? 220 : 97, variant ? 139 : 33);
        shapes[2] = Shape::gen(); shapes[2]->appendCircle(16, 13, 5, 5); shapes[2]->fill(31, 102, 196);
        scene->opacity(variant ? 173 : 128);
        scene->add(SceneEffect::GaussianBlur, 1.4, 0, 0, 100);
        if (effect == 0) scene->add(SceneEffect::Tint, 31, 51, 97, 255, 199, 102, variant ? 43.0 : 75.0);
        if (effect == 1) scene->add(SceneEffect::Tritone, 28, 51, 97, 224, 99, 48, 255, 224, 143, variant ? 111 : 64);
        if (effect == 2) scene->add(SceneEffect::Fill, 49, 150, 123, variant ? 173 : 255);
        scene->add(shapes[1]); scene->add(shapes[2]); canvas->add(shapes[0]); canvas->add(scene);
        assert(canvas->update() == Result::Success);
    }
    ~Input() {delete canvas;}
};
static Pixels snapshot(const SwCompositor* cmp) {
    Pixels result(W * H, 0);
    for (int y = cmp->bbox.min.y; y < cmp->bbox.max.y; ++y)
        for (int x = cmp->bbox.min.x; x < cmp->bbox.max.x; ++x)
            result[y * W + x] = cmp->image.buf32[y * cmp->image.stride + x];
    return result;
}
static void pixels(const Pixels& data) {
    std::printf("[");
    for (unsigned i = 0; i < data.size(); ++i) std::printf("%s%u", i ? "," : "", data[i]);
    std::printf("]");
}
int main(int argc, char**) {
    assert(Initializer::init(2) == Result::Success);
    const bool variant = argc > 1;
    std::printf("[");
    for (unsigned kind = 0; kind < 3; ++kind) {
        Input input(kind, variant);
        auto impl = static_cast<SceneImpl*>(input.scene);
        auto renderer = static_cast<SwRenderer*>(impl->impl.renderer);
        SwShapeTask* tasks[3];
        for (unsigned i = 0; i < 3; ++i) {tasks[i] = static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(input.shapes[i])->impl.rd); tasks[i]->done();}
        assert(renderer->preRender()); assert(renderer->renderShape(tasks[0]));
        const auto background = input.pixels;
        auto cmp = static_cast<SwCompositor*>(renderer->target(impl->bounds(), renderer->colorSpace(), impl->impl.cmpFlag));
        assert(cmp && renderer->beginComposite(cmp, MaskMethod::None, impl->opacity));
        assert(renderer->renderShape(tasks[1]) && renderer->renderShape(tasks[2]));
        assert(impl->effects->count == 2);
        assert(renderer->render(cmp, (*impl->effects)[0], false));
        const auto before = snapshot(cmp);
        const auto address = cmp->image.buf32;
        auto effect = (*impl->effects)[1];
        assert(renderer->render(cmp, effect, false));
        assert(cmp->image.buf32 == address && input.pixels == background);
        const auto output = snapshot(cmp);
        assert(renderer->endComposite(cmp) && renderer->postRender());
        Input reference(kind, variant);
        assert(reference.canvas->draw(true) == Result::Success && reference.canvas->sync() == Result::Success);
        assert(input.pixels == reference.pixels);
        std::printf("%s{\"id\":\"%s\",\"opacity\":%u,\"parameter\":%u,\"bbox\":[%d,%d,%d,%d],\"input\":", kind ? "," : "", kind == 0 ? "tint" : kind == 1 ? "tritone" : "fill", impl->opacity,
            kind == 0 ? static_cast<RenderEffectTint*>(effect)->intensity : kind == 1 ? static_cast<RenderEffectTritone*>(effect)->blender : static_cast<RenderEffectFill*>(effect)->color[3], cmp->bbox.min.x, cmp->bbox.min.y, cmp->bbox.max.x, cmp->bbox.max.y);
        pixels(before); std::printf(",\"output\":"); pixels(output); std::printf(",\"final\":"); pixels(input.pixels);
        std::printf(",\"verifiedCanvasMatch\":true,\"verifiedInPlace\":true,\"verifiedParentDeferred\":true}");
    }
    std::printf("]\n"); Initializer::term();
}
