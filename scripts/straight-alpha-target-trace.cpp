// Public-API evidence for a retained straight-alpha target pixel.
#include <thorvg.h>
#include <cassert>
#include <cstdio>
#include <memory>

using namespace tvg;

static uint32_t abgr(unsigned r, unsigned g, unsigned b, unsigned a)
{
    return (a << 24) | (b << 16) | (g << 8) | r;
}

enum class Path { Clear, Retain, Prepared };

static void run(Path path)
{
    uint32_t pixel = path == Path::Prepared ? abgr(100, 50, 25, 128)
                                            : abgr(200, 100, 50, 128);
    auto canvas = std::unique_ptr<SwCanvas>(SwCanvas::gen());
    assert(canvas->target(&pixel, 1, 1, 1, ColorSpace::ABGR8888S) == Result::Success);

    auto shape = Shape::gen();
    shape->appendRect(0, 0, 1, 1);
    shape->fill(0, 200, 100, 128);
    canvas->add(shape);
    assert(canvas->draw(path == Path::Clear) == Result::Success);
    assert(canvas->sync() == Result::Success);

    const char* label = path == Path::Clear ? "cleared" :
                        path == Path::Prepared ? "prepared" : "retained";
    std::printf("%s %u %u %u %u\n", label,
                pixel & 255, (pixel >> 8) & 255,
                (pixel >> 16) & 255, pixel >> 24);
}

int main()
{
    assert(Initializer::init(0) == Result::Success);
    run(Path::Clear);
    run(Path::Retain);
    run(Path::Prepared);
    assert(Initializer::term() == Result::Success);
}
