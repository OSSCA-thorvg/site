// Real Bitmap clipping cases; unmodified ThorVG CPU engine, no scheduler timing claims.
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cassert>
#include <vector>
#include "tvgPicture.h"
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"
static void pixels(const std::vector<uint32_t>& v) {std::printf("[");for(size_t i=0;i<v.size();++i)std::printf("%s%u",i?",":"",v[i]);std::printf("]");}
static void spans(const SwRle* rle) {
 std::printf("[");if(rle)for(unsigned i=0;i<rle->size();++i){auto s=rle->data()[i];std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}",i?",":"",s.x,s.y,s.len,s.coverage);}std::printf("]");
}
int main(int argc,char** argv) {
 constexpr unsigned w=12,h=8,stride=16,iw=8,ih=6,tx=2,ty=1,bg=0xffdef0fa;
 float cx=argc>1?std::strtof(argv[1],nullptr):6.0f,cy=4,radius=3.25f;
 std::vector<uint32_t> bitmap(iw*ih),buffer(stride*h,bg);
 for(unsigned y=0;y<ih;++y)for(unsigned x=0;x<iw;++x){uint32_t c=0xffefd090;if(x>=6&&y>=1&&y<=2)c=0xff40c4fa;if(y>=2&&int(y)>=5-std::abs(int(x)-3))c=0xff807552;if(y>=5)c=0xff599541;bitmap[y*iw+x]=c;}
 Initializer::init(0);
 std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"iw\":%u,\"ih\":%u,\"tx\":%u,\"ty\":%u,\"background\":%u,\"circle\":{\"cx\":%g,\"cy\":%g,\"r\":%g},\"source\":",w,h,stride,iw,ih,tx,ty,bg,cx,cy,radius);pixels(bitmap);std::printf(",\"cases\":[");
 for(int mode=0;mode<3;++mode) {
  std::fill(buffer.begin(),buffer.end(),bg);
  auto canvas=SwCanvas::gen();assert(canvas->target(buffer.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
  auto picture=Picture::gen();assert(picture->load(bitmap.data(),iw,ih,ColorSpace::ABGR8888,true)==Result::Success);picture->translate(tx,ty);
  Shape* clip=nullptr;
  if(mode){clip=Shape::gen();if(mode==1)clip->appendRect(3,2,6,4);else clip->appendCircle(cx,cy,radius,radius);assert(picture->clip(clip)==Result::Success);}
  canvas->add(picture);assert(canvas->update()==Result::Success);
  auto task=static_cast<SwImageTask*>(static_cast<PictureImpl*>(picture)->impl.rd);task->done();assert(task->valid&&task->image.direct);
  SwShapeTask* clipTask=nullptr;SwImage raw;RenderRegion box;
  if(mode<2){assert(task->clips.count==0&&task->image.rle==nullptr);if(mode==1)assert(PAINT(clip)->ctxFlag & ContextFlag::FastTrack);}
  else {
   assert(task->clips.count==1&&task->image.rle&&task->image.rle->valid());
   clipTask=static_cast<SwShapeTask*>(task->clips[0]);clipTask->done();assert(clipTask->clipper&&clipTask->shape.rle);
   assert(clipTask->shape.rle!=task->image.rle); // separate owned RLEs
   raw=task->image;raw.rle=nullptr;raw.outline=nullptr;
   assert(imagePrepare(raw,task->transform,task->clipBox,box,task->renderer->mpool,0));
   assert(imageGenRle(raw,box,task->renderer->mpool,0,false));
  }
  std::printf("%s{\"clipTasks\":%u,\"fastTrack\":%s,\"clipRle\":",mode?",":"",task->clips.count,mode==1?"true":"false");spans(clipTask?clipTask->shape.rle:nullptr);
  std::printf(",\"rawRle\":");spans(raw.rle);std::printf(",\"imageRle\":");spans(task->image.rle);
  if(mode==2){assert(clipTask->clip(raw.rle));assert(raw.rle->size()==task->image.rle->size());for(unsigned i=0;i<raw.rle->size();++i){auto a=raw.rle->data()[i],b=task->image.rle->data()[i];assert(a.x==b.x&&a.y==b.y&&a.len==b.len&&a.coverage==b.coverage);}}
  std::printf(",\"writes\":[");auto replay=buffer;
  if(mode==2){SwSurface surface;surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);assert(rasterCompositor(&surface)==Result::Success);RenderRegion bbox{{0,0},{w,h}};
   for(unsigned i=0;i<task->image.rle->size();++i){auto span=task->image.rle->data()[i];SwRle one;one.spans.push(span);auto image=task->image;image.rle=&one;auto before=replay;assert(rasterDirectRleImage(&surface,image,bbox,255));unsigned offset=span.y*stride+span.x;
    for(unsigned at=0;at<replay.size();++at)if(at<offset||at>=offset+span.len)assert(replay[at]==before[at]);
    std::printf("%s[",i?",":"");for(int j=0;j<span.len;++j)std::printf("%s%u",j?",":"",replay[offset+j]);std::printf("]");
   }
  }
  assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);if(mode==2)assert(buffer==replay);
  std::printf("],\"pixels\":");pixels(buffer);std::printf("}");if(raw.rle)imageFree(raw);delete canvas;
 }
 std::printf("]}\n");Initializer::term();
}
