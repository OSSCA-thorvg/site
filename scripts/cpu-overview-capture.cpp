// Headless CPU capture of a GPU example fixture through the real SwCanvas.
// Compiled by scripts/generate-cpu-compare-trace.mjs against the pinned static CPU build, so the CPU
// articles can compare the same paints with the GL / WGPU captures pixel by pixel.
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>
#ifndef GPU_EXAMPLE_HEADER
#define GPU_EXAMPLE_HEADER "gpu-overview-example.h"
#define GPU_EXAMPLE_NS gpuOverviewExample
#endif
#include GPU_EXAMPLE_HEADER
namespace example = GPU_EXAMPLE_NS;

int main(int argc, char** argv)
{
    assert(argc >= 2);
    const auto width = example::width, height = example::height;
    // ABGR8888 is alpha-premultiplied; on a little-endian host its bytes are R, G, B, A, the same
    // premultiplied layout the GL / WGPU capture programs write. The target starts fully transparent.
    std::vector<uint32_t> pixels(width * height, 0);
#ifdef GPU_CAPTURE_PREFILL
    // Opt-in (pipeline fixture only), as in the GPU capture programs: existing target content.
    const uint32_t a = example::prefill[3];
    const uint32_t fill = (a << 24) | (uint32_t(example::prefill[2]) * a / 255 << 16) | (uint32_t(example::prefill[1]) * a / 255 << 8) | (uint32_t(example::prefill[0]) * a / 255);
    for (auto& p : pixels) p = fill;
#endif
    assert(tvg::Initializer::init(0) == tvg::Result::Success);
    auto canvas = tvg::SwCanvas::gen();
    assert(canvas);
    assert(canvas->target(pixels.data(), width, width, height, tvg::ColorSpace::ABGR8888) == tvg::Result::Success);
    example::build(canvas);
#ifdef GPU_CAPTURE_PREFILL
    assert(canvas->draw(example::drawClear) == tvg::Result::Success);
#else
    assert(canvas->draw(true) == tvg::Result::Success);
#endif
    assert(canvas->sync() == tvg::Result::Success);

    auto file = fopen(argv[1], "wb");
    assert(file);
    assert(fwrite(pixels.data(), 4, pixels.size(), file) == pixels.size());
    fclose(file);
    printf("{\"backend\":\"sw\",\"colorSpace\":\"ABGR8888\",\"threads\":0,\"width\":%u,\"height\":%u}\n", width, height);
    delete canvas;
    tvg::Initializer::term();
    return 0;
}
