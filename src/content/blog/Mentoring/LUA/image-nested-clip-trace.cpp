// Two clips in one retained scene: circle on Scene, slanted polygon on Picture.
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cassert>
#include <vector>
#include "tvgPicture.h"
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"
static void pixels(const std::vector<uint32_t>& v){std::printf("[");for(size_t i=0;i<v.size();++i)std::printf("%s%u",i?",":"",v[i]);std::printf("]");}
static void spans(const SwRle* r){std::printf("[");for(unsigned i=0;i<r->size();++i){auto s=r->data()[i];std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}",i?",":"",s.x,s.y,s.len,s.coverage);}std::printf("]");}
static void equal(const SwRle* a,const SwRle* b){assert(a->size()==b->size());for(unsigned i=0;i<a->size();++i){auto x=a->data()[i],y=b->data()[i];assert(x.x==y.x&&x.y==y.y&&x.len==y.len&&x.coverage==y.coverage);}}
int main(int argc,char** argv){
 constexpr unsigned w=12,h=8,stride=16,iw=8,ih=6,tx=2,ty=1,bg=0xffdef0fa;
 const float edge=argc>1?std::strtof(argv[1],nullptr):9.0f;
 std::vector<uint32_t> bitmap(iw*ih),buffer(stride*h,bg);
 for(unsigned y=0;y<ih;++y)for(unsigned x=0;x<iw;++x){uint32_t c=0xffefd090;if(x>=6&&y>=1&&y<=2)c=0xff40c4fa;if(y>=2&&int(y)>=5-std::abs(int(x)-3))c=0xff807552;if(y>=5)c=0xff599541;bitmap[y*iw+x]=c;}
 Initializer::init(0);auto canvas=SwCanvas::gen();assert(canvas->target(buffer.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
 auto background=Shape::gen();background->appendRect(0,0,w,h);background->fill(250,240,222,255);canvas->add(background);
 auto group=Scene::gen();auto circle=Shape::gen();circle->appendCircle(6,4,3.25f,3.25f);group->clip(circle);
 auto picture=Picture::gen();picture->load(bitmap.data(),iw,ih,ColorSpace::ABGR8888,true);picture->translate(tx,ty);group->add(picture);canvas->add(group);
 assert(canvas->update()==Result::Success);
 auto task=static_cast<SwImageTask*>(static_cast<PictureImpl*>(picture)->impl.rd);task->done();assert(task->valid&&task->image.direct&&task->clips.count==1);
 assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);
 std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"iw\":%u,\"ih\":%u,\"tx\":%u,\"ty\":%u,\"background\":%u,\"source\":",w,h,stride,iw,ih,tx,ty,bg);pixels(bitmap);
 std::printf(",\"firstPixels\":");pixels(buffer);std::printf(",\"firstRle\":");spans(task->image.rle);
 auto cut=Shape::gen();cut->moveTo(0,0);cut->lineTo(edge,0);cut->lineTo(edge-5,8);cut->lineTo(0,8);cut->close();picture->clip(cut);
 assert(canvas->update()==Result::Success);task->done();assert(task->valid&&task->clips.count==2&&task->image.rle);
 auto clipA=static_cast<SwShapeTask*>(task->clips[0]);auto clipB=static_cast<SwShapeTask*>(task->clips[1]);clipA->done();clipB->done();
 assert(clipA->clipper&&clipB->clipper&&clipA->shape.rle&&clipB->shape.rle);
 assert(task->clips[0]==static_cast<ShapeImpl*>(circle)->impl.rd);assert(task->clips[1]==static_cast<ShapeImpl*>(cut)->impl.rd);
 std::printf(",\"polygon\":[[0,0],[%g,0],[%g,8],[0,8]],\"clipA\":",edge,edge-5);spans(clipA->shape.rle);std::printf(",\"clipB\":");spans(clipB->shape.rle);
 auto raw=task->image;raw.rle=nullptr;raw.outline=nullptr;RenderRegion box;
 assert(imagePrepare(raw,task->transform,task->clipBox,box,task->renderer->mpool,0));assert(imageGenRle(raw,box,task->renderer->mpool,0,false));
 std::printf(",\"rawRle\":");spans(raw.rle);assert(clipA->clip(raw.rle));std::printf(",\"afterCircle\":");spans(raw.rle);assert(clipB->clip(raw.rle));equal(raw.rle,task->image.rle);
 std::printf(",\"finalRle\":");spans(task->image.rle);
 std::vector<uint32_t> replay(stride*h,bg);SwSurface surface;surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);assert(rasterCompositor(&surface)==Result::Success);RenderRegion bbox{{0,0},{w,h}};
 std::printf(",\"writes\":[");
 for(unsigned i=0;i<task->image.rle->size();++i){auto s=task->image.rle->data()[i];SwRle one;one.spans.push(s);auto image=task->image;image.rle=&one;auto before=replay;assert(rasterDirectRleImage(&surface,image,bbox,255));unsigned at=s.y*stride+s.x;for(unsigned j=0;j<replay.size();++j)if(j<at||j>=at+s.len)assert(replay[j]==before[j]);std::printf("%s[",i?",":"");for(int j=0;j<s.len;++j)std::printf("%s%u",j?",":"",replay[at+j]);std::printf("]");}
 assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);assert(replay==buffer);
 std::printf("],\"finalPixels\":");pixels(buffer);std::printf("}\n");imageFree(raw);delete canvas;Initializer::term();
}
