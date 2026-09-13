// Includes unmodified pinned engine translation units. See raster/README.md.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"
#include "tvgSwRaster.cpp"

using Pixels = std::vector<uint32_t>;
static constexpr const char* COMMIT = "cdc1c9596a5edebc159d5623d726febda7595896";
static void pixels(const Pixels& values)
{
    std::printf("[");
    for (unsigned i = 0; i < values.size(); ++i) {
        auto c = values[i];
        std::printf("%s[%u,%u,%u,%u]", i ? "," : "", c & 255, (c >> 8) & 255, (c >> 16) & 255, c >> 24);
    }
    std::printf("]");
}
static Pixels bitmap(bool variant)
{
    Pixels result;
    for (int y = 0; y < 6; ++y) for (int x = 0; x < 6; ++x) {
        int r = 53+x*9, g = 133+y*9, b = 203-x*4;
        if ((x == 4 || x == 5) && (y == 0 || y == 1)) {r=250;g=198+x*4;b=53+y*9;}
        if (y >= 5-x/2) {r=37+x*5;g=133+y*8;b=80+x*3;}
        if (y >= 4 && x <= 1) {r=33+x*8;g=101+y*11;b=181+x*9;}
        if (variant && x == 3 && y == 2) {r=241;g=31;b=173;}
        result.push_back(_abgrJoin(r,g,b,255));
    }
    return result;
}
static SwSurface surface(Pixels& pixels, unsigned w, unsigned h)
{
    SwSurface result;
    result.buf32=pixels.data();result.w=w;result.h=h;result.stride=w;
    result.channelSize=4;result.cs=ColorSpace::ABGR8888;result.premultiplied=true;result.join=_abgrJoin;
    return result;
}
static void imageCases(bool variant)
{
    auto src=bitmap(variant);
    SwImage image;
    image.buf32=src.data();image.w=image.h=image.stride=6;image.channelSize=4;
    image.alphaIgnored=false;image.filter=FilterMethod::Bilinear;
    std::printf("\"source\":");pixels(src);
    for(int i=0;i<5;++i) {
        const char* names[]={"direct","nearest","bilinear","downscale","texmap"};
        unsigned w=i==0?9:i==3?2:i==4?11:12,h=i==0?8:w;
        Pixels dst(w*h,0);auto target=surface(dst,w,h);RenderRegion box{{0,0},{int(w),int(h)}};
        if(i==0) {
            image.ox=-2;image.oy=-1;RenderRegion directBox{{2,1},{8,7}};
            assert(rasterDirectImage(&target,image,directBox,255));image.ox=image.oy=0;
        } else if(i<4) {
            auto scale=i==3?.25f:2.0f;image.scale=scale;image.filter=i==1?FilterMethod::Nearest:FilterMethod::Bilinear;
            Matrix m{scale,0,0,0,scale,0,0,0,1};
            assert(rasterScaledImage(&target,image,m,box,255));
        } else {
            image.filter=FilterMethod::Bilinear;Matrix m{1.15f,-.35f,3,.45f,1.1f,1,0,0,1};
            assert(rasterTexmapPolygon(&target,image,m,box,255));
        }
        std::printf(",\"%s\":{\"width\":%u,\"height\":%u,\"pixels\":",names[i],w,h);pixels(dst);std::printf("}");
    }
    Pixels composed=src,overlay;
    for(int y=0;y<6;++y)for(int x=0;x<6;++x) {
        uint8_t a=64+x*24+y*8;
        overlay.push_back(_abgrJoin(MULTIPLY(224,a),MULTIPLY(70+x*7,a),MULTIPLY(77+y*5,a),a));
    }
    cRasterTranslucentPixels(composed.data(),overlay.data(),36,160);
    std::printf(",\"composition\":{\"width\":6,\"height\":6,\"pixels\":");pixels(composed);std::printf("}");
}
static void shapeCase(bool rle, bool variant, bool gradient = false, bool stroke = false)
{
    constexpr unsigned W=10,H=9;
    Pixels dst(W*H,0);
    auto canvas=SwCanvas::gen();assert(canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888)==Result::Success);
    auto shape=Shape::gen();
    auto cx=variant?5.55f:5.2f;
    if(rle)shape->appendCircle(cx,4.4f,3.1f,2.7f);
    else shape->appendRect(2,2,6,5);
    if (stroke) { shape->fill(0,0,0,0); shape->strokeWidth(1.5f); }
    if (gradient) {
        auto fill = LinearGradient::gen();
        fill->linear(2,1,8,6);
        const Fill::ColorStop stops[] = {{0,235,85,55,255},{.5f,variant?uint8_t(245):uint8_t(45),175,155,255},{1,65,85,220,255}};
        assert(fill->colorStops(stops,3)==Result::Success);
        if (stroke) shape->strokeFill(fill); else shape->fill(fill);
    } else if (stroke) shape->strokeFill(36,162,122); else shape->fill(36,162,122);
    canvas->add(shape);
    assert(canvas->update()==Result::Success);
    auto task=static_cast<SwShapeTask*>(static_cast<ShapeImpl*>(shape)->impl.rd);task->done();
    if (!stroke) assert(task->shape.fastTrack!=rle);
    auto spans=stroke?task->shape.strokeRle:task->shape.rle;
    auto prepared=gradient?(stroke?task->shape.stroke->fill:task->shape.fill):nullptr;
    const auto name=stroke?(gradient?"strokeGradient":"strokeSolid"):gradient?(rle?"gradientRle":"gradientRect"):(rle?"solidRle":"solidRect");
    std::printf(",\"%s\":{\"width\":%u,\"height\":%u,\"color\":[36,162,122,255],\"geometry\":",name,W,H);
    if(rle)std::printf("{\"type\":\"ellipse\",\"cx\":%g,\"cy\":4.4,\"rx\":3.1,\"ry\":2.7}",cx);
    else std::printf("{\"type\":\"rect\",\"x\":2,\"y\":2,\"width\":6,\"height\":5}");
    std::printf(",\"bbox\":[%d,%d,%d,%d],\"spans\":[",task->bounds().min.x,task->bounds().min.y,task->bounds().max.x,task->bounds().max.y);
    if(rle) {
        for(unsigned i=0;i<spans->size();++i) {
            const auto& s=spans->data()[i];
            std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}",i?",":"",s.x,s.y,s.len,s.coverage);
        }
    } else for(int y=2;y<7;++y) std::printf("%s{\"x\":2,\"y\":%d,\"len\":6,\"coverage\":255}",y>2?",":"",y);
    std::printf("]");
    if (gradient) {
        std::printf(",\"colorTable\":");pixels(Pixels(prepared->ctable,prepared->ctable+SW_COLOR_TABLE));
        std::printf(",\"linear\":[%.9g,%.9g,%.9g]",prepared->linear.dx,prepared->linear.dy,prepared->linear.offset);
        Pixels samples(W*H,0);
        if (rle) for(unsigned i=0;i<spans->size();++i) {
            const auto& s=spans->data()[i];
            fillLinear(prepared,samples.data()+s.y*W+s.x,s.y,s.x,s.len,opBlendSrcOver,255);
        } else for(int y=2;y<7;++y) fillLinear(prepared,samples.data()+y*W+2,y,2,6,opBlendSrcOver,255);
        std::printf(",\"samples\":");pixels(samples);
    }
    assert(canvas->draw()==Result::Success);assert(canvas->sync()==Result::Success);
    std::printf(",\"pixels\":");pixels(dst);std::printf("}");delete canvas;
}
static void helperCases(bool variant)
{
    auto src=bitmap(variant);
    const float coordinates[][2]={{-.49f,-.49f},{0,0},{.01f,.51f},{1.25f,2.75f},{2.999f,3.499f},{5.99f,5.75f}};
    std::printf(",\"samples\":[");
    for(unsigned i=0;i<6;++i) {
        auto x=coordinates[i][0],y=coordinates[i][1];
        std::printf("%s{\"sx\":%.9g,\"sy\":%.9g,\"nearest\":",i?",":"",x,y);
        pixels({_interpNoScaler(src.data(),6,6,6,x,y,0,0,0)});
        std::printf(",\"bilinear\":");pixels({_interpUpScaler(src.data(),6,6,6,x,y,0,0,0)});
        std::printf("}");
    }
    std::printf("],\"downsamples\":[");
    const float scales[]={.125f,.24f,.25f,.499f};
    for(unsigned i=0;i<4;++i) {
        auto x=3.51f,y=3.51f,s=scales[i];auto n=_sampleSize(s);
        auto miny=std::max(0,int(nearbyint(y))-int(n)),maxy=std::min(6,int(nearbyint(y))+int(n));
        std::printf("%s{\"sx\":%.9g,\"sy\":%.9g,\"scale\":%.9g,\"rgba\":",i?",":"",x,y,s);
        pixels({_interpDownScaler(src.data(),6,6,6,x,y,miny,maxy,n)});std::printf("}");
    }
    std::printf("],\"byteCases\":[");
    uint32_t state=12345;
    auto random=[&]() {state=state*1664525u+1013904223u;return uint8_t(state>>24);};
    for(unsigned i=0;i<64;++i) {
        uint8_t sa=random(),da=random(),opacity=random();
        uint8_t sr=random(),sg=random(),sb=random(),dr=random(),dg=random(),db=random();
        auto s=_abgrJoin(MULTIPLY(sr,sa),MULTIPLY(sg,sa),MULTIPLY(sb,sa),sa);
        auto d=_abgrJoin(MULTIPLY(dr,da),MULTIPLY(dg,da),MULTIPLY(db,da),da);
        auto scaled=ALPHA_BLEND(s,opacity);
        std::printf("%s{\"opacity\":%u,\"src\":",i?",":"",opacity);pixels({s});
        std::printf(",\"dst\":");pixels({d});
        std::printf(",\"alphaBlend\":");pixels({scaled});
        std::printf(",\"interpolate\":");pixels({INTERPOLATE(s,d,opacity)});
        std::printf(",\"sourceOver\":");pixels({scaled+ALPHA_BLEND(d,IA(scaled))});std::printf("}");
    }
    std::printf("]");
}
int main(int argc,char**)
{
    assert(Initializer::init(0)==Result::Success);
    std::printf("{\"sourceCommit\":\"%s\",",COMMIT);
    imageCases(argc>1);shapeCase(false,argc>1);shapeCase(true,argc>1);
    shapeCase(false,argc>1,true);shapeCase(true,argc>1,true);
    shapeCase(true,argc>1,false,true);shapeCase(true,argc>1,true,true);
    helperCases(argc>1);std::printf("}\n");
    assert(Initializer::term()==Result::Success);
}
