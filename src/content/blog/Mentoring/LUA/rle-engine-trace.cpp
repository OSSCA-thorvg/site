// Standalone evidence harness. Includes the unmodified renderer translation unit
// to inspect its private SwShapeTask, not a change to ThorVG or its public API.
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <cassert>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"

int main(int argc, char** argv)
{
    constexpr uint32_t w=12,h=8,stride=16;
    const float firstX=argc>1?std::strtof(argv[1],nullptr):1.25f;
    const uint32_t background=0xffdef0fa;
    std::vector<uint32_t> buffer(stride*h,background), replay=buffer;
    Initializer::init(0);
    auto canvas=SwCanvas::gen();
    assert(canvas->target(buffer.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
    auto shape=Shape::gen();
    shape->moveTo(firstX,1.25f);shape->lineTo(9.5f,2.75f);
    shape->lineTo(8.25f,6.5f);shape->lineTo(2.25f,5.75f);shape->close();
    shape->fill(32,120,220,255);
    canvas->add(shape);canvas->update();
    auto task=static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(shape)->impl.rd);
    task->done();
    assert(task->valid&&!task->shape.fastTrack&&task->shape.rle);
    auto rle=task->shape.rle;
    SwSurface surface;
    surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);
    assert(rasterCompositor(&surface)==Result::Success);
    RenderColor color{32,120,220,255};
    RenderRegion bbox{{0,0},{w,h}};
    std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"background\":%u,\"color\":%u,\"polygon\":[[%g,1.25],[9.5,2.75],[8.25,6.5],[2.25,5.75]],\"spans\":[",w,h,stride,background,surface.join(32,120,220,255),firstX);
    for(uint32_t i=0;i<rle->size();++i) {
        auto span=rle->data()[i];
        int32_t x,len;assert(span.fetch(bbox,x,len));
        SwRle one;one.spans.push(span);
        SwShape item;item.rle=&one;item.bbox=bbox;
        auto before=replay;
        assert(rasterShape(&surface,&item,bbox,color));
        std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u,\"offset\":%u,\"writes\":[",i?",":"",x,span.y,len,span.coverage,span.y*stride+x);
        for(int32_t j=0;j<len;++j) {
            auto offset=span.y*stride+x+j;
            auto expected=span.coverage==255?surface.join(32,120,220,255):
                ALPHA_BLEND(surface.join(32,120,220,255),span.coverage)+ALPHA_BLEND(before[offset],255-span.coverage);
            assert(replay[offset]==expected);
            std::printf("%s%u",j?",":"",replay[offset]);
        }
        for(uint32_t at=0;at<stride*h;++at)
            if(at<span.y*stride+x||at>=span.y*stride+x+len)assert(replay[at]==before[at]);
        std::printf("]}");
    }
    assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);
    assert(buffer==replay); // actual public Canvas output == per-span rasterShape replay
    std::printf("],\"pixels\":[");
    for(uint32_t i=0;i<buffer.size();++i)std::printf("%s%u",i?",":"",buffer[i]);
    std::printf("],\"verifiedCanvasMatch\":true}\n");
    delete canvas;Initializer::term();
}
