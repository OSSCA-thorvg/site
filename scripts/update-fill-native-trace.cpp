// Two-stop opaque Pad Fill table from the pinned, unmodified fillPrepare().
#include <cassert>
#include <cstdio>
#include "tvgSwCommon.h"
static uint32_t abgr(uint8_t r,uint8_t g,uint8_t b,uint8_t a) {return (uint32_t(a)<<24)|(uint32_t(b)<<16)|(uint32_t(g)<<8)|r;}
int main(int argc,char**) {
    assert(Initializer::init(0)==Result::Success);
    const bool variant=argc>1;
    Fill::ColorStop stops[]={{0,230,97,33,255},{1,31,102,196,255}};
    if(variant){stops[0]={0,17,83,201,255};stops[1]={1,219,44,91,255};}
    auto gradient=LinearGradient::gen();assert(gradient->linear(0,0,4,0)==Result::Success);
    assert(gradient->colorStops(stops,2)==Result::Success);
    SwSurface surface;surface.cs=ColorSpace::ABGR8888;surface.channelSize=4;surface.join=abgr;
    SwFill* fill=nullptr;const auto matrix=tvg::identity();
    assert(fillPrepare(fill,gradient,matrix,&surface,255,true));assert(!fill->solid&&!fill->translucent);
    printf("{\"stops\":[[%u,%u,%u],[%u,%u,%u]],\"table\":[",stops[0].r,stops[0].g,stops[0].b,stops[1].r,stops[1].g,stops[1].b);
    for(unsigned i=0;i<1024;++i){auto v=fill->ctable[i];printf("%s[%u,%u,%u]",i?",":"",v&255,(v>>8)&255,(v>>16)&255);assert((v>>24)==255);}
    printf("],\"opaque\":true}\n");
    tvg::free(fill);delete gradient;assert(Initializer::term()==Result::Success);
}
