// Replays the Solid / alpha-127 / Gradient relationships in
// thorvg.example 8df10a05 src/Blending.cpp, with an additional midtone pair.
// The engine remains unmodified. Output pixels are premultiplied ABGR8888.
#include <cassert>
#include <cstdio>
#include <fstream>
#include <string>
#include <vector>
#include "thorvg.h"
using namespace tvg;

int main(int argc, char** argv)
{
    assert(argc == 2);
    constexpr unsigned W = 128, H = 128;
    const char* modes[] = {"Normal", "Multiply", "Screen", "Overlay", "Darken", "Lighten", "ColorDodge", "ColorBurn", "HardLight", "SoftLight", "Difference", "Exclusion", "Hue", "Saturation", "Color", "Luminosity", "Add"};
    const char* cases[] = {"solid", "alpha", "gradient", "midtone"};
    assert(Initializer::init(0) == Result::Success);
    printf("{\"width\":128,\"height\":128,\"sample\":[60,60],\"records\":[");
    bool first = true;
    for (unsigned mode = 0; mode < 17; ++mode) {
        for (unsigned kind = 0; kind < 4; ++kind) {
            std::vector<uint32_t> pixels(W * H, 0);
            auto canvas = SwCanvas::gen();
            assert(canvas->target(pixels.data(), W, W, H, ColorSpace::ABGR8888) == Result::Success);
            for (unsigned layer = 0; layer < 2; ++layer) {
                auto shape = Shape::gen();
                float p = layer ? 32 : 12;
                shape->appendRect(p, p, 80, 80, 8, 8);
                if (kind == 2) {
                    auto fill = LinearGradient::gen();
                    fill->linear(p, p, p + 80, p + 80);
                    Fill::ColorStop stops[] = {{0, 255, 0, 255, 255}, {1, 0, 255, 0, 127}};
                    fill->colorStops(stops, 2);
                    shape->fill(fill);
                } else if (kind == 3) {
                    if (layer) shape->fill(230, 97, 33);
                    else shape->fill(48, 136, 208);
                } else {
                    auto alpha = kind == 1 ? 127 : 255;
                    if (layer) shape->fill(0, 255, 255, alpha);
                    else shape->fill(255, 255, 0, alpha);
                }
                if (layer) assert(shape->blend(static_cast<BlendMethod>(mode)) == Result::Success);
                assert(canvas->add(shape) == Result::Success);
            }
            assert(canvas->update() == Result::Success);
            assert(canvas->draw(true) == Result::Success);
            assert(canvas->sync() == Result::Success);
            std::string name = std::string(modes[mode]) + "-" + cases[kind];
            std::ofstream file(std::string(argv[1]) + "/" + name + ".rgba", std::ios::binary);
            for (auto pixel : pixels) {
                const unsigned char channels[] = {static_cast<unsigned char>(pixel), static_cast<unsigned char>(pixel >> 8), static_cast<unsigned char>(pixel >> 16), static_cast<unsigned char>(pixel >> 24)};
                file.write(reinterpret_cast<const char*>(channels), 4);
            }
            assert(file.good());
            file.close();
            auto sample = pixels[60 * W + 60];
            printf("%s{\"mode\":\"%s\",\"case\":\"%s\",\"file\":\"%s.webp\",\"rgba\":[%u,%u,%u,%u]}",first?"":",",modes[mode],cases[kind],name.c_str(),sample&255,(sample>>8)&255,(sample>>16)&255,sample>>24);
            first = false;
            delete canvas;
        }
    }
    printf("]}\n");
    assert(Initializer::term() == Result::Success);
}
