// Headless WebGPU capture of the GPU overview example through the real WgCanvas.
// Compiled by scripts/generate-gpu-overview-trace.mjs against the pinned static build and wgpu-native.
#include <wgpu.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <vector>
#ifndef GPU_EXAMPLE_HEADER
#define GPU_EXAMPLE_HEADER "gpu-overview-example.h"
#define GPU_EXAMPLE_NS gpuOverviewExample
#endif
#include GPU_EXAMPLE_HEADER
namespace example = GPU_EXAMPLE_NS;

static std::string text(WGPUStringView view)
{
    if (!view.data) return "";
    return view.length == WGPU_STRLEN ? std::string(view.data) : std::string(view.data, view.length);
}

static const char* backendName(WGPUBackendType type)
{
    switch (type) {
        case WGPUBackendType_Metal: return "Metal";
        case WGPUBackendType_Vulkan: return "Vulkan";
        case WGPUBackendType_D3D12: return "D3D12";
        case WGPUBackendType_D3D11: return "D3D11";
        case WGPUBackendType_OpenGL: return "OpenGL";
        case WGPUBackendType_OpenGLES: return "OpenGLES";
        case WGPUBackendType_WebGPU: return "WebGPU";
        case WGPUBackendType_Null: return "Null";
        default: return "Unknown";
    }
}

int main(int argc, char** argv)
{
    assert(argc >= 2);
    const auto width = example::width, height = example::height;

    auto instance = wgpuCreateInstance(nullptr);
    assert(instance);
    // Headless: no compatible surface, any backend the instance offers.
    WGPUAdapter adapter = nullptr;
    WGPURequestAdapterOptions adapterOptions = WGPU_REQUEST_ADAPTER_OPTIONS_INIT;
    WGPURequestAdapterCallbackInfo adapterCallback = WGPU_REQUEST_ADAPTER_CALLBACK_INFO_INIT;
    adapterCallback.mode = WGPUCallbackMode_AllowProcessEvents;
    adapterCallback.callback = [](WGPURequestAdapterStatus status, WGPUAdapter adapter, WGPUStringView, void* out, void*) {
        assert(status == WGPURequestAdapterStatus_Success);
        *static_cast<WGPUAdapter*>(out) = adapter;
    };
    adapterCallback.userdata1 = &adapter;
    wgpuInstanceRequestAdapter(instance, &adapterOptions, adapterCallback);
    while (!adapter) wgpuInstanceProcessEvents(instance);

    WGPUDevice device = nullptr;
    WGPUDeviceDescriptor deviceDesc = WGPU_DEVICE_DESCRIPTOR_INIT;
    deviceDesc.uncapturedErrorCallbackInfo.callback = [](WGPUDevice const*, WGPUErrorType, WGPUStringView message, void*, void*) {
        fprintf(stderr, "wgpu uncaptured error: %s\n", text(message).c_str());
        abort();
    };
    WGPURequestDeviceCallbackInfo deviceCallback = WGPU_REQUEST_DEVICE_CALLBACK_INFO_INIT;
    deviceCallback.mode = WGPUCallbackMode_AllowProcessEvents;
    deviceCallback.callback = [](WGPURequestDeviceStatus status, WGPUDevice device, WGPUStringView, void* out, void*) {
        assert(status == WGPURequestDeviceStatus_Success);
        *static_cast<WGPUDevice*>(out) = device;
    };
    deviceCallback.userdata1 = &device;
    wgpuAdapterRequestDevice(adapter, &deviceDesc, deviceCallback);
    while (!device) wgpuInstanceProcessEvents(instance);
    auto queue = wgpuDeviceGetQueue(device);
    assert(queue);

    // WgRenderer::sync() blits its offscreen root target into this texture (loadOp Load) with a pipeline
    // whose colour target is WgContext::format (BGRA8Unorm at this revision), so the texture must be a
    // same-sized BGRA8Unorm render attachment; CopySrc lets us read it back.
    WGPUTextureDescriptor textureDesc = WGPU_TEXTURE_DESCRIPTOR_INIT;
    textureDesc.usage = WGPUTextureUsage_RenderAttachment | WGPUTextureUsage_CopySrc | WGPUTextureUsage_TextureBinding;
    textureDesc.dimension = WGPUTextureDimension_2D;
    textureDesc.size = {width, height, 1};
    textureDesc.format = WGPUTextureFormat_BGRA8Unorm;
    auto texture = wgpuDeviceCreateTexture(device, &textureDesc);
    assert(texture);
#ifdef GPU_CAPTURE_PREFILL
    {
        // Opt-in (pipeline fixture only): clear the target to example::prefill on the same queue before ThorVG
        // records anything, so the capture shows what WgRenderer::sync() leaves of existing target content.
        auto view = wgpuTextureCreateView(texture, nullptr);
        assert(view);
        WGPURenderPassColorAttachment attachment = WGPU_RENDER_PASS_COLOR_ATTACHMENT_INIT;
        attachment.view = view;
        attachment.loadOp = WGPULoadOp_Clear;
        attachment.storeOp = WGPUStoreOp_Store;
        attachment.clearValue = {example::prefill[0] / 255.0, example::prefill[1] / 255.0, example::prefill[2] / 255.0, example::prefill[3] / 255.0};
        WGPURenderPassDescriptor passDesc = WGPU_RENDER_PASS_DESCRIPTOR_INIT;
        passDesc.colorAttachmentCount = 1;
        passDesc.colorAttachments = &attachment;
        auto encoder = wgpuDeviceCreateCommandEncoder(device, nullptr);
        assert(encoder);
        auto pass = wgpuCommandEncoderBeginRenderPass(encoder, &passDesc);
        wgpuRenderPassEncoderEnd(pass);
        wgpuRenderPassEncoderRelease(pass);
        auto commands = wgpuCommandEncoderFinish(encoder, nullptr);
        assert(commands);
        wgpuQueueSubmit(queue, 1, &commands);
        wgpuCommandBufferRelease(commands);
        wgpuCommandEncoderRelease(encoder);
        wgpuTextureViewRelease(view);
    }
#endif

    assert(tvg::Initializer::init(0) == tvg::Result::Success);
    auto canvas = tvg::WgCanvas::gen();
    assert(canvas);
    assert(canvas->target(device, instance, texture, width, height, tvg::ColorSpace::ABGR8888S, 1) == tvg::Result::Success);
    example::build(canvas);
#ifdef GPU_CAPTURE_PREFILL
    assert(canvas->draw(example::drawClear) == tvg::Result::Success);
#else
    assert(canvas->draw(true) == tvg::Result::Success);
#endif
    assert(canvas->sync() == tvg::Result::Success);

    // Copy the texture into a mappable buffer. bytesPerRow must be a multiple of 256.
    const uint32_t bytesPerRow = (width * 4 + 255) & ~255u;
    WGPUBufferDescriptor bufferDesc = WGPU_BUFFER_DESCRIPTOR_INIT;
    bufferDesc.usage = WGPUBufferUsage_MapRead | WGPUBufferUsage_CopyDst;
    bufferDesc.size = uint64_t(bytesPerRow) * height;
    auto buffer = wgpuDeviceCreateBuffer(device, &bufferDesc);
    assert(buffer);
    auto encoder = wgpuDeviceCreateCommandEncoder(device, nullptr);
    assert(encoder);
    WGPUTexelCopyTextureInfo source = WGPU_TEXEL_COPY_TEXTURE_INFO_INIT;
    source.texture = texture;
    WGPUTexelCopyBufferInfo destination = WGPU_TEXEL_COPY_BUFFER_INFO_INIT;
    destination.layout.bytesPerRow = bytesPerRow;
    destination.layout.rowsPerImage = height;
    destination.buffer = buffer;
    const WGPUExtent3D extent = {width, height, 1};
    wgpuCommandEncoderCopyTextureToBuffer(encoder, &source, &destination, &extent);
    auto commands = wgpuCommandEncoderFinish(encoder, nullptr);
    assert(commands);
    wgpuQueueSubmit(queue, 1, &commands);
    wgpuCommandBufferRelease(commands);
    wgpuCommandEncoderRelease(encoder);

    bool mapped = false;
    WGPUBufferMapCallbackInfo mapCallback = WGPU_BUFFER_MAP_CALLBACK_INFO_INIT;
    mapCallback.mode = WGPUCallbackMode_AllowProcessEvents;
    mapCallback.callback = [](WGPUMapAsyncStatus status, WGPUStringView, void* out, void*) {
        assert(status == WGPUMapAsyncStatus_Success);
        *static_cast<bool*>(out) = true;
    };
    mapCallback.userdata1 = &mapped;
    wgpuBufferMapAsync(buffer, WGPUMapMode_Read, 0, bufferDesc.size, mapCallback);
    while (!mapped) wgpuDevicePoll(device, true, nullptr);
    auto pixels = static_cast<const uint8_t*>(wgpuBufferGetConstMappedRange(buffer, 0, bufferDesc.size));
    assert(pixels);
    // WebGPU texture row 0 is the top row; swap the BGRA bytes to RGBA so the file matches the GL harness.
    std::vector<uint8_t> row(width * 4);
    auto file = fopen(argv[1], "wb");
    assert(file);
    for (uint32_t y = 0; y < height; ++y) {
        auto src = pixels + y * bytesPerRow;
        for (uint32_t x = 0; x < width * 4; x += 4) {
            row[x] = src[x + 2]; row[x + 1] = src[x + 1]; row[x + 2] = src[x]; row[x + 3] = src[x + 3];
        }
        assert(fwrite(row.data(), 1, row.size(), file) == row.size());
    }
    fclose(file);
    wgpuBufferUnmap(buffer);

    WGPUAdapterInfo info = WGPU_ADAPTER_INFO_INIT;
    assert(wgpuAdapterGetInfo(adapter, &info) == WGPUStatus_Success);
    printf("{\"backend\":\"wgpu\",\"adapter\":\"%s\",\"backendType\":\"%s\",\"width\":%u,\"height\":%u}\n",
           text(info.device).c_str(), backendName(info.backendType), width, height);
    wgpuAdapterInfoFreeMembers(info);

    delete canvas;
    tvg::Initializer::term();
    wgpuBufferRelease(buffer);
    wgpuTextureRelease(texture);
    wgpuQueueRelease(queue);
    wgpuDeviceRelease(device);
    wgpuAdapterRelease(adapter);
    wgpuInstanceRelease(instance);
    return 0;
}
