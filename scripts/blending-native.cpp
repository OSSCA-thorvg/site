// Read-only fixture: public Canvas output plus prepared CPU task data.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"

constexpr unsigned W = 18, H = 13;
using Pixels = std::vector<uint32_t>;
static void pixels(const Pixels& values)
{
    printf("[");
    for (unsigned i = 0; i < values.size(); ++i) printf("%s%u", i ? "," : "", values[i]);
    printf("]");
}
static void box(const RenderRegion& r) {printf("[%d,%d,%d,%d]",r.min.x,r.min.y,r.max.x,r.max.y);}
static void taskData(SwShapeTask* task)
{
    task->done();
    Pixels coverage(W * H, 0);
    printf("{\"fastTrack\":%s,\"clipBox\":",task->shape.fastTrack?"true":"false"); box(task->clipBox);
    printf(",\"curBox\":"); box(task->curBox);
    printf(",\"opacity\":%u,\"clipCount\":%u,\"spans\":[",task->opacity,task->clips.count);
    bool first=true;
    if (task->shape.rle) for (auto& s : task->shape.rle->spans) {
        printf("%s[%d,%d,%d,%u]",first?"":",",s.x,s.y,s.len,s.coverage);first=false;
        for(int x=s.x;x<s.x+s.len;++x) coverage[s.y*W+x]=s.coverage;
    }
    if(task->shape.fastTrack) for(int y=task->curBox.min.y;y<task->curBox.max.y;++y)
        for(int x=task->curBox.min.x;x<task->curBox.max.x;++x)coverage[y*W+x]=255;
    printf("],\"coverage\":");pixels(coverage);printf("}");
}
static void run(const char* name, BlendMethod mode, bool changed, bool destination, bool source, bool rounded=true)
{
    Pixels output(W * H, 0);
    auto canvas=SwCanvas::gen();
    assert(canvas->target(output.data(),W,W,H,ColorSpace::ABGR8888)==Result::Success);
    Shape *d=nullptr,*s=nullptr;
    if(destination){
        d=Shape::gen();d->appendRect(2,1,9,7,rounded?1.5f:0,rounded?1.5f:0);
        d->fill(48,136,208);canvas->add(d);
    }
    if(source){
        s=Shape::gen();s->appendRect(changed?6.6f:6,4,9,7,rounded?1.5f:0,rounded?1.5f:0);
        s->fill(changed?174:230,changed?73:97,changed?119:33);s->blend(mode);canvas->add(s);
    }
    assert(canvas->update()==Result::Success);
    printf("\"%s\":{",name);
    if(d){printf("\"destinationTask\":");taskData(static_cast<SwShapeTask*>(PAINT(d)->rd));printf(",");}
    if(s){printf("\"sourceTask\":");taskData(static_cast<SwShapeTask*>(PAINT(s)->rd));printf(",");}
    // Preparing outlines / RLE never writes target pixels.
    for(auto p:output)assert(p==0);
    assert(canvas->draw(true)==Result::Success);
    assert(canvas->sync()==Result::Success);
    printf("\"pixels\":");pixels(output);
    auto paint=s?s:d;
    auto renderer=static_cast<SwRenderer*>(PAINT(paint)->renderer);
    printf(",\"compositors\":%u}",renderer->compositors.count);
    delete canvas;
}
int main(int argc,char**)
{
    bool changed=argc>1;
    assert(Initializer::init(0)==Result::Success);
    printf("{\"width\":%u,\"height\":%u,\"source\":[%u,%u,%u,255],\"destination\":[48,136,208,255],\"sourceRect\":[%g,4,9,7,1.5,1.5],\"destinationRect\":[2,1,9,7,1.5,1.5],\"cases\":{",W,H,changed?174:230,changed?73:97,changed?119:33,changed?6.6:6.0);
    run("destination",BlendMethod::Normal,changed,true,false);printf(",");
    run("source",BlendMethod::Normal,changed,false,true);printf(",");
    run("Normal",BlendMethod::Normal,changed,true,true);printf(",");
    run("Multiply",BlendMethod::Multiply,changed,true,true);printf(",");
    run("Screen",BlendMethod::Screen,changed,true,true);printf(",");
    run("fastRect",BlendMethod::Multiply,changed,true,true,false);
    printf("}}\n");
    assert(Initializer::term()==Result::Success);
}
