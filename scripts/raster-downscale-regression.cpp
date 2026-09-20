// Native C / host SIMD comparison against unmodified ThorVG headers.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgSwRaster.cpp"
#if defined(__aarch64__) && !defined(THORVG_NEON_VECTOR_SUPPORT)
#define THORVG_NEON_VECTOR_SUPPORT
#include "tvgSwRasterNeon.h"
#elif defined(__x86_64__) && !defined(THORVG_AVX_VECTOR_SUPPORT)
#define THORVG_AVX_VECTOR_SUPPORT
#include "tvgSwRasterAvx.h"
#endif

int main()
{
    constexpr unsigned w=47,h=43,stride=53;
    std::vector<uint32_t> pixels(stride*h);
    uint32_t state=0x4d5810cf,checksum=0;
    unsigned cases=0,maxTaps=0;
    for (auto& p:pixels) {state=1664525u*state+1013904223u;p=state;}
    for (int n=1;n<=24;++n) for (int y=0;y<int(h);y+=3) for (int x=0;x<int(w);x+=3) {
        int miny=std::max(0,y-n),maxy=std::min(int(h),y+n);
        auto c=cInterpDownScaler(pixels.data(),stride,w,h,x+.35f,y+.65f,miny,maxy,n);
#if defined(__aarch64__)
        auto vector=neonInterpDownScaler(pixels.data(),stride,w,h,x+.35f,y+.65f,miny,maxy,n);
        constexpr auto backend="NEON";
#else
        auto vector=avxInterpDownScaler(pixels.data(),stride,w,h,x+.35f,y+.65f,miny,maxy,n);
        constexpr auto backend="AVX";
#endif
        assert(c==vector);
        unsigned count=0;
        for(int yy=miny;yy<maxy;yy+=n/2+1)
            for(int xx=std::max(0,x-n);xx<std::min(int(w),x+n);xx+=n/2+1)++count;
        assert(count>0&&count<=16);
        maxTaps=std::max(maxTaps,count);checksum=(checksum*33u)^c;++cases;
        if(n==24&&y==42&&x==45) std::printf("{\"commit\":\"4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad\",\"backend\":\"%s\",\"cMatchesSimd\":true,\"cases\":%u,\"maxTaps\":%u,\"checksum\":%u}\n",backend,cases,maxTaps,checksum);
    }
}
