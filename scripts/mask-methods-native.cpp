// Public Canvas oracle, with read-only task / compositor inspection.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"
using Pixels=std::vector<uint32_t>;
constexpr unsigned W=16,H=12;
static void pixels(const Pixels& v){printf("[");for(unsigned i=0;i<v.size();++i)printf("%s%u",i?",":"",v[i]);printf("]");}
static Pixels portrait()
{
    Pixels p(W*H,0xffe8d2ba);
    for(unsigned y=0;y<H;++y)for(unsigned x=0;x<W;++x){
        if(y>=7&&x>=3&&x<=12)p[y*W+x]=0xffaa6c23;
        if((int(x)-8)*(int(x)-8)+(int(y)-4)*(int(y)-4)<=7)p[y*W+x]=y<=2?0xff433830:0xffa8c6e9;
    }
    return p;
}
static Scene* content()
{
    auto p=portrait();auto group=Scene::gen();auto photo=Picture::gen();
    assert(photo->load(p.data(),W,H,ColorSpace::ABGR8888,true)==Result::Success);group->add(photo);
    auto badge=Shape::gen();badge->appendCircle(12,8.5,2,2);badge->fill(35,160,100);group->add(badge);return group;
}
static Shape* maskA(bool changed)
{
    auto s=Shape::gen();s->appendRect(2,1.5f,8,8,2,2);s->fill(65,120,200,changed?128:176);return s;
}
static Shape* maskB(bool changed)
{
    auto s=Shape::gen();s->appendCircle(changed?8.6f:9.5f,6,4.5f,4.5f);
    auto fill=LinearGradient::gen();fill->linear(5,0,14,0);
    Fill::ColorStop stops[]={{0,24,48,88,static_cast<uint8_t>(changed?208:144)},{1,240,220,80,static_cast<uint8_t>(changed?208:144)}};
    fill->colorStops(stops,2);s->fill(fill);return s;
}
static void shapeData(Shape* s)
{
    auto task=static_cast<SwShapeTask*>(PAINT(s)->rd);task->done();assert(task->shape.rle);
    printf("{\"spans\":[");bool first=true;Pixels cov(W*H);
    for(auto& span:task->shape.rle->spans){
        printf("%s[%d,%d,%d,%u]",first?"":",",span.x,span.y,span.len,span.coverage);first=false;
        for(int x=span.x;x<span.x+span.len;++x)cov[span.y*W+x]=span.coverage;
    }
    printf("],\"coverage\":");pixels(cov);printf("}");
}
static void run(const char* name,MaskMethod method,bool changed,int kind=0)
{
    Pixels out(W*H);auto canvas=SwCanvas::gen();canvas->target(out.data(),W,W,H,ColorSpace::ABGR8888);
    auto a=kind==1?maskA(changed):nullptr;
    auto b=kind==2?maskB(changed):nullptr;
    Paint* root=kind==1?static_cast<Paint*>(a):kind==2?static_cast<Paint*>(b):static_cast<Paint*>(content());
    if(kind==0&&method!=MaskMethod::None){
        b=maskB(changed);
        if(method>=MaskMethod::Add){a=maskA(changed);assert(a->mask(b,method)==Result::Success);assert(root->mask(a,MaskMethod::Alpha)==Result::Success);}
        else assert(root->mask(b,method)==Result::Success);
    }
    canvas->add(root);assert(canvas->update()==Result::Success);
    printf("\"%s\":{",name);
    if(a){printf("\"a\":");shapeData(a);printf(",");}
    if(b){printf("\"b\":");shapeData(b);printf(",");}
    auto renderer=static_cast<SwRenderer*>(PAINT(root)->renderer);
    assert(canvas->draw(true)==Result::Success);assert(canvas->sync()==Result::Success);
    printf("\"pixels\":");pixels(out);
    printf(",\"buffers\":[");
    for(unsigned i=0;i<renderer->compositors.count;++i){
        auto cmp=renderer->compositors[i]->compositor;Pixels storage(W*H);
        for(int y=cmp->bbox.min.y;y<cmp->bbox.max.y;++y)for(int x=cmp->bbox.min.x;x<cmp->bbox.max.x;++x)
            storage[y*W+x]=cmp->image.channelSize==1?cmp->image.buf8[y*cmp->image.stride+x]:cmp->image.buf32[y*cmp->image.stride+x];
        printf("%s{\"channels\":%u,\"method\":%u,\"pixels\":",i?",":"",cmp->image.channelSize,unsigned(cmp->method));pixels(storage);printf("}");
    }
    printf("],\"restored\":%s}",renderer->surface->compositor==nullptr?"true":"false");delete canvas;
}
int main(int argc,char**)
{
    bool changed=argc>1;assert(Initializer::init(0)==Result::Success);
    printf("{\"width\":16,\"height\":12,\"alphaA\":%u,\"alphaB\":%u,\"rectA\":[2,1.5,8,8,2,2],\"circleB\":[%g,6,4.5,4.5],\"cases\":{",changed?128:176,changed?208:144,changed?8.6:9.5);
    run("inputA",MaskMethod::None,changed,1);printf(",");run("inputB",MaskMethod::None,changed,2);
    const char* names[]={"None","Alpha","InvAlpha","Luma","InvLuma","Add","Subtract","Intersect","Difference","Lighten","Darken"};
    for(unsigned i=0;i<11;++i){printf(",");run(names[i],static_cast<MaskMethod>(i),changed);}
    printf("}}\n");assert(Initializer::term()==Result::Success);
}
