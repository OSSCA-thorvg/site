// Replay the pinned CPU engine's mask + effect nesting, then check public draw().
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include "tvgShape.h"
#include "tvgScene.h"
#include "tvgSwRenderer.cpp"

constexpr unsigned W = 24, H = 24;
using Pixels = std::vector<uint32_t>;

struct Input
{
    Pixels pixels = Pixels(W * H, 0);
    SwCanvas* canvas = SwCanvas::gen();
    Scene* scene = Scene::gen();
    Shape* bg = Shape::gen();
    Shape* mask = Shape::gen();

    Input(uint8_t maskAlpha, float dx)
    {
        assert(canvas->target(pixels.data(), W, W, H, ColorSpace::ABGR8888) == Result::Success);
        bg->appendRect(0, 0, W, H);
        bg->fill(234, 241, 236);
        auto a = Shape::gen();
        a->moveTo(7, 5); a->lineTo(3, 19); a->lineTo(18, 19); a->close();
        a->fill(230, 97, 33);
        auto b = Shape::gen();
        b->appendCircle(16, 13, 5, 5); b->fill(31, 102, 196);
        scene->add(a); scene->add(b); scene->opacity(128);
        scene->add(SceneEffect::GaussianBlur, 1.4, 0, 0, 100);
        scene->add(SceneEffect::Fill, 49, 150, 123, 255);
        mask->appendCircle(12 + dx, 12, 8, 8);
        mask->fill(255, 255, 255, maskAlpha);
        assert(scene->mask(mask, MaskMethod::Alpha) == Result::Success);
        canvas->add(bg); canvas->add(scene);
        assert(canvas->update() == Result::Success);
    }
    ~Input() { delete canvas; }
};

static Pixels snapshot(const SwImage& image, const RenderRegion& region)
{
    Pixels out(W * H, 0);
    for (int y = region.min.y; y < region.max.y; ++y)
        for (int x = region.min.x; x < region.max.x; ++x)
            out[y * W + x] = image.channelSize == 1 ? image.buf8[y * image.stride + x] : image.buf32[y * image.stride + x];
    return out;
}

static void print(const char* name, const Pixels& values)
{
    std::printf(",\"%s\":[", name);
    for (unsigned i = 0; i < values.size(); ++i) std::printf("%s%u", i ? "," : "", values[i]);
    std::printf("]");
}

int main(int argc, char** argv)
{
    const auto alpha = uint8_t(argc > 1 ? std::atoi(argv[1]) : 160);
    const auto dx = argc > 2 ? std::atof(argv[2]) : 0.0;
    assert(Initializer::init(2) == Result::Success);
    {
        Input input(alpha, dx);
        auto scene = static_cast<SceneImpl*>(input.scene);
        auto renderer = static_cast<SwRenderer*>(scene->impl.renderer);
        assert(!(PAINT(input.mask)->ctxFlag & ContextFlag::FastTrack));
        assert(renderer->preRender());
        assert(PAINT(input.bg)->render(renderer));
        const auto background = input.pixels;
        auto parent = renderer->surface;
        auto previous = parent->compositor;
        auto mask = static_cast<SwCompositor*>(renderer->target(scene->bounds(), ColorSpace::Grayscale8, CompositionFlag::Masking));
        assert(mask && mask->image.channelSize == 1 && mask->recoverSfc == parent);
        const auto clear = snapshot(mask->image, mask->bbox);
        assert(renderer->beginComposite(mask, MaskMethod::None, 255));
        assert(renderer->surface != parent);
        assert(PAINT(input.mask)->render(renderer));
        const auto maskPixels = snapshot(mask->image, mask->bbox);
        assert(input.pixels == background);
        assert(renderer->beginComposite(mask, MaskMethod::Alpha, PAINT(input.mask)->opacity));
        assert(renderer->surface == parent && parent->compositor == mask);
        assert(mask->opacity == 255 && scene->opacity == 128);
        const auto countMask = renderer->compositors.count;

        auto effect = static_cast<SwCompositor*>(renderer->target(scene->bounds(), renderer->colorSpace(), scene->impl.cmpFlag));
        assert(effect->recoverSfc == parent && effect->recoverCmp == mask);
        assert(renderer->beginComposite(effect, MaskMethod::None, scene->opacity));
        for (auto paint : scene->paints) assert(PAINT(paint)->render(renderer, scene->impl.cmpFlag));
        const auto children = snapshot(effect->image, effect->bbox);
        assert(renderer->render(effect, (*scene->effects)[0], false));
        const auto blurred = snapshot(effect->image, effect->bbox);
        assert(renderer->render(effect, (*scene->effects)[1], false));
        const auto filled = snapshot(effect->image, effect->bbox);
        const auto peak = renderer->compositors.count;
        assert(input.pixels == background);
        assert(renderer->endComposite(effect));
        assert(renderer->surface == parent && parent->compositor == mask);
        const auto output = input.pixels;
        assert(renderer->endComposite(mask));
        assert(renderer->surface == parent && parent->compositor == previous && mask->valid);
        assert(input.pixels == output);
        assert(renderer->postRender());
        Input reference(alpha, dx);
        assert(reference.canvas->draw(true) == Result::Success);
        assert(reference.canvas->sync() == Result::Success);
        assert(reference.pixels == output);
        std::printf("{\"width\":24,\"height\":24,\"groupOpacity\":128,\"maskFillAlpha\":%u,\"maskOpacity\":255,\"maskCenter\":[%g,12],\"maskRadius\":8,\"point\":[14,14],\"maskBuffers\":%u,\"temporaryPeak\":%u", alpha, 12 + dx, countMask, peak);
        print("background", background); print("clear", clear); print("mask", maskPixels);
        print("children", children); print("blurred", blurred); print("filled", filled); print("final", output);
        std::printf(",\"verifiedCanvasMatch\":true,\"verifiedContextRestore\":true,\"verifiedMaskEndNoWrite\":true}\n");
    }
    Initializer::term();
}
