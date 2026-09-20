// Exercise the pinned, unmodified Fill and Raster entry points.
#include <cassert>
#include <cstdio>
#include <vector>
#include "tvgSwRaster.cpp"
static unsigned blendCalls=0;
static uint32_t forbiddenColorBlend(const SwSurface*,uint32_t,uint32_t){++blendCalls;return 0;}
static void bytes(const std::vector<uint8_t>& values){printf("[");for(unsigned i=0;i<values.size();++i)printf("%s%u",i?",":"",values[i]);printf("]");}
int main(int argc,char**) {
 assert(Initializer::init(0)==Result::Success);bool variant=argc>1;
 SwSurface prep;prep.cs=ColorSpace::ABGR8888;prep.channelSize=4;prep.join=_abgrJoin;
 Matrix identity{1,0,0,0,1,0,0,0,1},singular{};SwFill* absent=nullptr;
 assert(fillPrepare(absent,nullptr,identity,&prep,255,true)&&!absent);
 printf("{\"nullFillNoAllocation\":true,\"prepare\":[");
 for(unsigned i=0;i<6;i++){
  bool radial=i==1||i==3;Fill* gradient;
  if(radial){auto g=RadialGradient::gen();g->radial(2,2,i==3?0:4,2,2,0);gradient=g;}
  else {auto g=LinearGradient::gen();g->linear(0,0,i==2?0:4,0);gradient=g;}
  Fill::ColorStop stops[]={{0,31,102,196,variant?uint8_t(173):uint8_t(219)},{1,214,107,48,255}};
  gradient->colorStops(stops,i<2?1:2);SwFill* fill=nullptr;
  bool ok=fillPrepare(fill,gradient,(i<2||i==5)?singular:identity,&prep,255,true);
  const auto solid=fillFetchSolid(fill,gradient);
  printf("%s{\"id\":%u,\"ok\":%s,\"solid\":%s,\"fallback\":",i?",":"",i,ok?"true":"false",fill->solid?"true":"false");
  if(solid)printf("[%u,%u,%u,%u]",solid->r,solid->g,solid->b,solid->a);else printf("null");printf("}");
  tvg::free(fill);delete gradient;
 }
 printf("],\"gray\":[");unsigned emitted=0;
 for(unsigned rle=0;rle<2;rle++)for(unsigned translucent=0;translucent<2;translucent++)for(unsigned blending=0;blending<2;blending++){
  const unsigned alpha=translucent?(variant?173:128):255,coverage=variant?173:127;
  std::vector<uint8_t> buffer(30,0xa5),before;
  for(unsigned y=0;y<2;y++)for(unsigned x=0;x<4;x++)buffer[4+y*7+x]=uint8_t(37+y*28+x*7);
  before=buffer;SwSurface surface;surface.buf8=buffer.data()+4;surface.w=4;surface.h=2;surface.stride=7;surface.channelSize=1;surface.cs=ColorSpace::Grayscale8;
  if(blending)surface.blender=forbiddenColorBlend;
  SwFill fill{};fill.translucent=translucent;fill.spread=FillSpread::Pad;
  for(auto& c:fill.ctable)c=alpha<<24;
  SwRle spans;spans.spans.push({0,0,4,255});spans.spans.push({0,1,4,uint8_t(coverage)});
  RenderRegion box{{0,0},{4,2}};
  bool ok=rle?_rasterGradientRle<FillLinear>(&surface,&spans,&fill):_rasterGradientRect<FillLinear>(&surface,box,&fill);assert(ok);
  printf("%s{\"rle\":%s,\"alpha\":%u,\"coverage\":%u,\"blending\":%s,\"before\":",emitted++?",":"",rle?"true":"false",alpha,coverage,blending?"true":"false");bytes(before);printf(",\"after\":");bytes(buffer);printf("}");
  SwCompositor compositor;compositor.method=MaskMethod::Alpha;surface.compositor=&compositor;auto saved=buffer;
  bool matted=rle?_rasterGradientRle<FillLinear>(&surface,&spans,&fill):_rasterGradientRect<FillLinear>(&surface,box,&fill);
  assert(!matted&&saved==buffer);
 }
 printf("],\"colorBlendCalls\":%u,\"grayMatteRejectedWithoutWrites\":true}\n",blendCalls);assert(blendCalls==0);assert(Initializer::term()==Result::Success);
}
