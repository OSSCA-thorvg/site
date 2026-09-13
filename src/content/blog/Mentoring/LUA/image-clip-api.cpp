// Public ThorVG API example. Run with an argument for a 30-degree image rotation.
#include <thorvg.h>
#include <cassert>
#include <cmath>
#include <vector>

int main(int argc, char**)
{
    constexpr unsigned width = 12, height = 8, stride = 16;
    constexpr unsigned imageWidth = 8, imageHeight = 6;
    std::vector<uint32_t> surface(stride * height, 0xffdef0fa);
    std::vector<uint32_t> bitmap(imageWidth * imageHeight);
    for (unsigned y = 0; y < imageHeight; ++y) {
        for (unsigned x = 0; x < imageWidth; ++x) {
            uint32_t color = 0xffefd090;  // ABGR8888 sky
            if (x >= 6 && y >= 1 && y <= 2) color = 0xff40c4fa;
            if (y >= 2 && int(y) >= 5 - std::abs(int(x) - 3)) color = 0xff807552;
            if (y >= 5) color = 0xff599541;
            bitmap[y * imageWidth + x] = color;
        }
    }

    assert(tvg::Initializer::init(0) == tvg::Result::Success);
    auto canvas = tvg::SwCanvas::gen();
    assert(canvas->target(surface.data(), stride, width, height,
                          tvg::ColorSpace::ABGR8888) == tvg::Result::Success);
    auto background = tvg::Shape::gen();
    background->appendRect(0, 0, width, height);
    background->fill(250, 240, 222, 255);
    canvas->add(background);

    auto picture = tvg::Picture::gen();
    assert(picture->load(bitmap.data(), imageWidth, imageHeight,
                         tvg::ColorSpace::ABGR8888, true) == tvg::Result::Success);
    // Put the image center at (6,4); rotate only the Picture if requested.
    const float angle = argc > 1 ? 30.0f : 0.0f;
    const float radians = angle * 3.14159265358979323846f / 180.0f;
    const float c = std::cos(radians), s = std::sin(radians);
    const tvg::Matrix transform = {c, -s, 6 - 4*c + 3*s,
                                  s,  c, 4 - 4*s - 3*c,
                                  0,  0, 1};
    picture->transform(transform);
    // Clip lives in the parent's coordinate system: no Picture transform needed.
    auto clip = tvg::Shape::gen();
    clip->appendCircle(6, 4, 3.25f, 3.25f);
    assert(picture->clip(clip) == tvg::Result::Success);
    canvas->add(picture);
    assert(canvas->update() == tvg::Result::Success);
    assert(canvas->draw(false) == tvg::Result::Success);
    assert(canvas->sync() == tvg::Result::Success);
    for (unsigned y = 0; y < height; ++y)
        for (unsigned x = 0; x < width; ++x)
            assert((surface[y * stride + x] >> 24) == 255);
    delete canvas;
    assert(tvg::Initializer::term() == tvg::Result::Success);
}
