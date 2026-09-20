// Headless OpenGL capture of the GPU overview example through the real GlCanvas.
// Compiled by scripts/generate-gpu-overview-trace.mjs against the pinned static build.
#include <OpenGL/OpenGL.h>
#include <OpenGL/gl3.h>
#include <dlfcn.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>
#ifdef GPU_CAPTURE_GL_BUFFERS
#include <string>
#endif
#ifndef GPU_EXAMPLE_HEADER
#define GPU_EXAMPLE_HEADER "gpu-overview-example.h"
#define GPU_EXAMPLE_NS gpuOverviewExample
#endif
#include GPU_EXAMPLE_HEADER
namespace example = GPU_EXAMPLE_NS;

// The static ThorVG library carries its own (initially null) GL function
// pointers under the standard names, so the harness resolves the few GL entry
// points it needs straight from the OpenGL framework instead.
template<typename F> static F gl(const char* name)
{
    static auto handle = dlopen("/System/Library/Frameworks/OpenGL.framework/OpenGL", RTLD_LAZY);
    assert(handle);
    auto fn = reinterpret_cast<F>(dlsym(handle, name));
    assert(fn);
    return fn;
}
#define GLFN(name) gl<decltype(&::name)>(#name)

int main(int argc, char** argv)
{
    assert(argc >= 2);
    const auto width = example::width, height = example::height;
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
    GLFN(glGenFramebuffers)(1, &fbo);
    GLFN(glBindFramebuffer)(GL_FRAMEBUFFER, fbo);
    GLFN(glGenTextures)(1, &texture);
    GLFN(glBindTexture)(GL_TEXTURE_2D, texture);
    GLFN(glTexImage2D)(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);
    GLFN(glFramebufferTexture2D)(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
    assert(GLFN(glCheckFramebufferStatus)(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE);
#ifdef GPU_CAPTURE_PREFILL
    // Opt-in (pipeline fixture only): paint the target with example::prefill before ThorVG touches the
    // context, so the capture shows what GlRenderer::sync() leaves of existing target content.
    GLFN(glClearColor)(example::prefill[0] / 255.0f, example::prefill[1] / 255.0f, example::prefill[2] / 255.0f, example::prefill[3] / 255.0f);
    GLFN(glClear)(GL_COLOR_BUFFER_BIT);
    GLFN(glClearColor)(0.0f, 0.0f, 0.0f, 0.0f);
    assert(GLFN(glGetError)() == GL_NO_ERROR);
#endif

    assert(tvg::Initializer::init(0) == tvg::Result::Success);
    auto canvas = tvg::GlCanvas::gen();
    assert(canvas);
    assert(canvas->target(nullptr, nullptr, context, fbo, width, height, tvg::ColorSpace::ABGR8888S) == tvg::Result::Success);
    example::build(canvas);
#ifdef GPU_CAPTURE_PREFILL
    assert(canvas->draw(example::drawClear) == tvg::Result::Success);
#else
    assert(canvas->draw(true) == tvg::Result::Success);
#endif
    assert(canvas->sync() == tvg::Result::Success);

    GLFN(glBindFramebuffer)(GL_READ_FRAMEBUFFER, fbo);
    GLFN(glReadBuffer)(GL_COLOR_ATTACHMENT0);
    std::vector<uint8_t> pixels(width * height * 4);
    GLFN(glReadPixels)(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels.data());
    assert(GLFN(glGetError)() == GL_NO_ERROR);
    auto file = fopen(argv[1], "wb");
    assert(file);
    for (auto y = height; y > 0; --y) assert(fwrite(pixels.data() + (y - 1) * width * 4, 1, width * 4, file) == width * 4);
    fclose(file);
#ifdef GPU_CAPTURE_GL_BUFFERS
    // Opt-in (pipeline fixture only): the alignment GlStageBuffer pads uniform blocks to, and the size of every
    // buffer object in the context after sync(), i.e. what the last GlStageBuffer::flushToGPU() uploaded
    // (tvgGlGpuBuffer.cpp). The harness itself creates no buffer objects.
    GLint uniformAlignment = 0;
    GLFN(glGetIntegerv)(GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT, &uniformAlignment);
    std::string buffers;
    for (GLuint name = 1; name <= 64; ++name) {
        if (!GLFN(glIsBuffer)(name)) continue;
        GLint size = 0;
        GLFN(glBindBuffer)(GL_COPY_READ_BUFFER, name);
        GLFN(glGetBufferParameteriv)(GL_COPY_READ_BUFFER, GL_BUFFER_SIZE, &size);
        buffers += (buffers.empty() ? "[" : ",[") + std::to_string(name) + "," + std::to_string(size) + "]";
    }
    GLFN(glBindBuffer)(GL_COPY_READ_BUFFER, 0);
    assert(GLFN(glGetError)() == GL_NO_ERROR);
    printf("{\"backend\":\"gl\",\"vendor\":\"%s\",\"renderer\":\"%s\",\"version\":\"%s\",\"width\":%u,\"height\":%u,\"uniformBufferOffsetAlignment\":%d,\"buffers\":[%s]}\n",
           GLFN(glGetString)(GL_VENDOR), GLFN(glGetString)(GL_RENDERER), GLFN(glGetString)(GL_VERSION), width, height, uniformAlignment, buffers.c_str());
#else
    printf("{\"backend\":\"gl\",\"vendor\":\"%s\",\"renderer\":\"%s\",\"version\":\"%s\",\"width\":%u,\"height\":%u}\n",
           GLFN(glGetString)(GL_VENDOR), GLFN(glGetString)(GL_RENDERER), GLFN(glGetString)(GL_VERSION), width, height);
#endif
    delete canvas;
    tvg::Initializer::term();
    GLFN(glDeleteFramebuffers)(1, &fbo);
    GLFN(glDeleteTextures)(1, &texture);
    CGLSetCurrentContext(nullptr);
    CGLDestroyContext(context);
    return 0;
}
