// Real CPU raster evidence; no ThorVG source changes.
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <cassert>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"

static Shape* polygon(float firstX) {
    auto s=Shape::gen();
    s->moveTo(firstX,1.25f);s->lineTo(9.5f,2.75f);
    s->lineTo(8.25f,6.5f);s->lineTo(2.25f,5.75f);s->close();
    s->fill(32,120,220,255);return s;
}
static void pixels(const std::vector<uint32_t>& v) {
    std::printf("[");for(size_t i=0;i<v.size();++i)std::printf("%s%u",i?",":"",v[i]);std::printf("]");
}
int main(int argc,char** argv) {
    constexpr uint32_t w=12,h=8,stride=16,bg=0xffdef0fa;
    float firstX=argc>1?std::strtof(argv[1],nullptr):1.25f;
    Initializer::init(0);
    std::vector<SwSpan> canonical;
    std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"background\":%u,\"lanes\":[",w,h,stride,bg);
    for(int lane=0;lane<2;++lane) {
        std::vector<uint32_t> buffer(stride*h,bg),replay=buffer,source(stride*h,bg);
        auto canvas=SwCanvas::gen();assert(canvas->target(buffer.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
        auto shape=polygon(firstX);LinearGradient* grad=nullptr;
        if(lane==1) {
            grad=LinearGradient::gen();grad->linear(0,0,w,0);
            Fill::ColorStop stops[]={{0,32,120,220,255},{.5f,145,80,200,255},{1,245,158,55,255}};
            grad->colorStops(stops,3);shape->fill(grad);
        }
        canvas->add(shape);canvas->update();
        auto st=static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(shape)->impl.rd);
        st->done();auto rle=st->shape.rle;
        assert(rle&&rle->valid());
        SwSurface surface;surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);assert(rasterCompositor(&surface)==Result::Success);
        RenderRegion bbox{{0,0},{w,h}};RenderColor color{32,120,220,255};
        if(lane==0)source.assign(stride*h,surface.join(32,120,220,255));
        if(lane==1) {
            // Sample the actual position-dependent gradient independently of coverage.
            for(uint32_t y=0;y<h;++y)
                fillLinear(st->shape.fill,source.data()+y*stride,y,0,w,opBlendSrcOver,255);
        }
        if(lane==0)canonical.assign(rle->data(),rle->data()+rle->size());
        assert(canonical.size()==rle->size());
        std::printf("%s{\"source\":",lane?",":"");pixels(source);std::printf(",\"spans\":[");
        for(uint32_t i=0;i<rle->size();++i) {
            auto span=rle->data()[i],a=canonical[i];assert(span.x==a.x&&span.y==a.y&&span.len==a.len&&span.coverage==a.coverage);
            SwRle one;one.spans.push(span);auto before=replay;
            SwShape item;item.rle=&one;item.bbox=bbox;
            if(lane==0)assert(rasterShape(&surface,&item,bbox,color));
            else {item.fill=st->shape.fill;assert(rasterGradientShape(&surface,&item,bbox,grad,255));}
            unsigned offset=span.y*stride+span.x;
            for(unsigned at=0;at<replay.size();++at)if(at<offset||at>=offset+span.len)assert(before[at]==replay[at]);
            std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u,\"offset\":%u,\"writes\":[",i?",":"",span.x,span.y,span.len,span.coverage,offset);
            for(int j=0;j<span.len;++j)std::printf("%s%u",j?",":"",replay[offset+j]);std::printf("]}");
        }
        assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);assert(buffer==replay);
        std::printf("],\"pixels\":");pixels(buffer);std::printf(",\"verifiedCanvasMatch\":true}");delete canvas;
    }
    std::printf("]}\n");Initializer::term();
}
