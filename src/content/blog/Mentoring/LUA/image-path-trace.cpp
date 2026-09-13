// Clip-free Bitmap paths, inspected from unmodified CPU engine tasks.
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cassert>
#include <vector>
#include "tvgPicture.h"
#include "tvgSwRenderer.cpp"
#include "tvgSwRaster.cpp" // expose unmodified per-triangle texture rasterizer
static void pixels(const std::vector<uint32_t>& v) {
    std::printf("[");for(size_t i=0;i<v.size();++i)std::printf("%s%u",i?",":"",v[i]);std::printf("]");
}
int main(int argc,char** argv) {
    constexpr uint32_t iw=12,ih=8,w=24,h=20,stride=28,bg=0xffdef0fa;
    float angle=argc>1?std::strtof(argv[1],nullptr):30.0f;
    std::vector<uint32_t> bitmap(iw*ih),buffer(stride*h,bg);
    for(uint32_t y=0;y<ih;++y)for(uint32_t x=0;x<iw;++x) {
        uint32_t c=0xffefd090;
        if(x>=8&&x<=9&&y>=1&&y<=2)c=0xff40c4fa;
        if(y>=3&&int(y)>=6-std::abs(int(x)-4))c=0xff807552;
        if(y>=6)c=0xff599541;
        bitmap[y*iw+x]=c;
    }
    Initializer::init(0);auto canvas=SwCanvas::gen();
    assert(canvas->target(buffer.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
    // A retained background is redrawn after dirty-region clearing. Merely
    // prefilling user memory does not preserve it across partial redraws.
    auto background=Shape::gen();background->appendRect(0,0,w,h);
    background->fill(250,240,222,255);canvas->add(background);
    auto picture=Picture::gen();assert(picture->load(bitmap.data(),iw,ih,ColorSpace::ABGR8888,true)==Result::Success);canvas->add(picture);
    float r=angle*3.14159265358979323846f/180.0f,c=std::cos(r),s=std::sin(r);
    Matrix matrices[]={{1,0,3,0,1,3,0,0,1},{1.5f,0,2,0,1.5f,2,0,0,1},{c,-s,7,s,c,2,0,0,1}};
    const char* names[]={"Direct","Scale","Rotation"};
    std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"iw\":%u,\"ih\":%u,\"background\":%u,\"source\":",w,h,stride,iw,ih,bg);pixels(bitmap);std::printf(",\"stages\":[");
    for(int i=0;i<3;++i) {
        std::fill(buffer.begin(),buffer.end(),bg);
        picture->transform(matrices[i]);assert(canvas->update()==Result::Success);
        auto task=static_cast<SwImageTask*>(static_cast<PictureImpl*>(picture)->impl.rd);task->done();
        assert(task->valid&&task->clips.count==0&&task->image.rle==nullptr);
        assert((i==0&&task->image.direct)||(i==1&&task->image.scaled)||(i==2&&!task->image.direct&&!task->image.scaled));
        assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);assert(task->image.rle==nullptr);
        for(unsigned y=0;y<h;++y)for(unsigned x=0;x<w;++x)assert((buffer[y*stride+x]>>24)==255);
        auto m=task->transform;
        std::printf("%s{\"name\":\"%s\",\"angle\":%g,\"clips\":0,\"hasRle\":false,\"quad\":[",i?",":"",names[i],i==2?angle:0);
        float coords[][2]={{0,0},{iw,0},{iw,ih},{0,ih}};
        for(int j=0;j<4;++j)std::printf("%s[%g,%g]",j?",":"",m.e11*coords[j][0]+m.e12*coords[j][1]+m.e13,m.e21*coords[j][0]+m.e22*coords[j][1]+m.e23);
        std::printf("],\"pixels\":");pixels(buffer);
        if (i==2) {
            std::vector<uint32_t> replay(stride*h,bg);
            SwSurface surface;surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);
            assert(rasterCompositor(&surface)==Result::Success);
            TexmapCtx ctx={&surface,task->image,task->curBox,255};
            Vertex vertices[4];
            for(int j=0;j<4;++j){vertices[j]={{coords[j][0],coords[j][1]},{coords[j][0],coords[j][1]}};vertices[j].pt*=m;}
            const int indices[2][3]={{0,1,3},{1,2,3}};
            std::printf(",\"triangles\":[");
            for(int k=0;k<2;++k) {
                Polygon polygon;for(int j=0;j<3;++j)polygon.vertex[j]=vertices[indices[k][j]];
                _rasterPolygonImage(ctx,polygon,!rightAngle(m));
                std::printf("%s{\"indices\":[%d,%d,%d],\"pixels\":",k?",":"",indices[k][0],indices[k][1],indices[k][2]);pixels(replay);std::printf("}");
            }
            std::printf("]");assert(replay==buffer);
        }
        std::printf("}");
        for(unsigned y=0;y<h;++y)for(unsigned x=w;x<stride;++x)assert(buffer[y*stride+x]==bg);
    }
    std::printf("]}\n");delete canvas;Initializer::term();
}
