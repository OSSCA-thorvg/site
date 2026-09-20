// Public-API readback of #4688. Build against the pinned local ThorVG source.
#define GL_SILENCE_DEPRECATION
#include <OpenGL/OpenGL.h>
#include <OpenGL/gl3.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include "thorvg.h"

int main(int argc, char** argv)
{
    if (argc < 2) return 1;
    auto scale = argc > 2 ? static_cast<float>(atof(argv[2])) : 0.0625f;
    constexpr uint32_t width = 1600, height = 544;
    const CGLPixelFormatAttribute attrs[] = {
        kCGLPFAAccelerated, kCGLPFAOpenGLProfile,
        static_cast<CGLPixelFormatAttribute>(kCGLOGLPVersion_3_2_Core),
        static_cast<CGLPixelFormatAttribute>(0)
    };
    CGLPixelFormatObj format;
    GLint count;
    assert(CGLChoosePixelFormat(attrs, &format, &count) == kCGLNoError);
    CGLContextObj context;
    assert(CGLCreateContext(format, nullptr, &context) == kCGLNoError);
    CGLDestroyPixelFormat(format);
    assert(CGLSetCurrentContext(context) == kCGLNoError);

    GLuint fbo, texture;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
    assert(glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE);
    glDisable(GL_DITHER);
    glDisable(GL_CULL_FACE);
    glEnable(GL_MULTISAMPLE);

    assert(tvg::Initializer::init(0) == tvg::Result::Success);
    auto canvas = tvg::GlCanvas::gen();
    assert(canvas);
    assert(canvas->target(nullptr, nullptr, context, fbo, width, height, tvg::ColorSpace::ABGR8888S) == tvg::Result::Success);
    auto bg = tvg::Shape::gen();
    bg->appendRect(0, 0, width, height);
    bg->fill(32, 32, 32);
    canvas->add(bg);
    const tvg::Fill::ColorStop colors[] = {
        {0.0f, 127, 39, 255, 255}, {0.33f, 159, 112, 253, 255},
        {0.66f, 253, 191, 96, 255}, {1.0f, 255, 137, 17, 255}
    };
    for (auto i = 0; i < 3; ++i) {
        auto shape = tvg::Shape::gen();
        auto fill = tvg::RadialGradient::gen();
        auto x = 16.0f + 528.0f * i;
        if (i == 1) {
            shape->appendRect(0, 0, 512 / scale, 512 / scale);
            shape->transform({scale, 0, x, 0, scale, 16, 0, 0, 1});
            fill->radial(256 / scale, 256 / scale, 128 / scale, 256 / scale, 256 / scale, 0);
        } else {
            shape->appendRect(0, 0, 512, 512);
            shape->translate(x, 16);
            fill->radial(256, 256, i == 0 ? 128 / scale : 128, 256, 256, 0);
            if (i == 0) fill->transform({scale, 0, 256 * (1 - scale), 0, scale, 256 * (1 - scale), 0, 0, 1});
        }
        fill->colorStops(colors, 4);
        fill->spread(tvg::FillSpread::Repeat);
        shape->fill(fill);
        canvas->add(shape);
    }
    assert(canvas->draw(true) == tvg::Result::Success);
    assert(canvas->sync() == tvg::Result::Success);
    glBindFramebuffer(GL_READ_FRAMEBUFFER, fbo);
    glReadBuffer(GL_COLOR_ATTACHMENT0);
    std::vector<uint8_t> pixels(width * height * 4);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels.data());
    assert(glGetError() == GL_NO_ERROR);
    auto file = fopen(argv[1], "wb");
    assert(file);
    for (auto y = height; y > 0; --y) assert(fwrite(pixels.data() + (y - 1) * width * 4, 1, width * 4, file) == width * 4);
    fclose(file);
    printf("{\"vendor\":\"%s\",\"renderer\":\"%s\",\"version\":\"%s\",\"scale\":%.8g,\"width\":%u,\"height\":%u}\n",
           glGetString(GL_VENDOR), glGetString(GL_RENDERER), glGetString(GL_VERSION), scale, width, height);
    delete canvas;
    tvg::Initializer::term();
    glDeleteFramebuffers(1, &fbo);
    glDeleteTextures(1, &texture);
    CGLSetCurrentContext(nullptr);
    CGLDestroyContext(context);
}
