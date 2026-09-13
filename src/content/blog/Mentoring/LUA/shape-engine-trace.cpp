// Source-grounded Shape chapter data; unmodified CPU implementation.
#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <functional>
#include <vector>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"
#include "tvgSwShape.cpp"
static void point(Point p){std::printf("[%g,%g]",p.x,p.y);}
static void path(const RenderPath& p){std::printf("{\"cmds\":[");for(unsigned i=0;i<p.cmds.count;++i)std::printf("%s%d",i?",":"",int(p.cmds[i]));std::printf("],\"pts\":[");for(unsigned i=0;i<p.pts.count;++i){if(i)std::printf(",");point(p.pts[i]);}std::printf("]}");}
static void outline(const SwOutline* p){std::printf("{\"pts\":[");for(unsigned i=0;i<p->in.count;++i){if(i)std::printf(",");point(p->in[i]);}std::printf("],\"types\":[");for(unsigned i=0;i<p->types.count;++i)std::printf("%s%d",i?",":"",int(p->types[i]));std::printf("],\"ends\":[");for(unsigned i=0;i<p->cntrs.count;++i)std::printf("%s%u",i?",":"",p->cntrs[i]);std::printf("],\"closed\":[");for(unsigned i=0;i<p->closed.count;++i)std::printf("%s%s",i?",":"",p->closed[i]?"true":"false");std::printf("]}");}
static void spans(const SwRle* r){std::printf("[");if(r)for(unsigned i=0;i<r->size();++i){auto s=r->data()[i];std::printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}",i?",":"",s.x,s.y,s.len,s.coverage);}std::printf("]");}
static void pixels(const std::vector<uint32_t>& a){std::printf("[");for(unsigned i=0;i<a.size();++i)std::printf("%s%u",i?",":"",a[i]);std::printf("]");}
static void box(BBox b){std::printf("[%g,%g,%g,%g]",b.min.x,b.min.y,b.max.x,b.max.y);}
int main(int argc,char**argv){
 const float delta=argc>1?0.5f:0;constexpr unsigned w=24,h=18,stride=28,bg=0xfff4f7fb;Initializer::init(0);
 auto curve=[&](Shape* s){s->moveTo(3,13);s->lineTo(3,9);s->cubicTo(6+delta,1,17,1,20,13);s->close();};
 std::printf("{\"w\":%u,\"h\":%u,\"stride\":%u,\"background\":%u,\"delta\":%g,\"cases\":[",w,h,stride,bg,delta);bool comma=false;
 auto emit=[&](const char* name,const std::function<void(Shape*)>& configure){
  std::vector<uint32_t> buf(stride*h,bg);auto canvas=SwCanvas::gen();assert(canvas->target(buf.data(),stride,w,h,ColorSpace::ABGR8888)==Result::Success);
  auto shape=Shape::gen();shape->fill(0,0,0,0);configure(shape);canvas->add(shape);assert(canvas->update()==Result::Success);
  auto impl=static_cast<ShapeImpl*>(shape);auto task=static_cast<SwShapeTask*>(impl->impl.rd);task->done();assert(task->valid);assert(canvas->draw(false)==Result::Success);assert(canvas->sync()==Result::Success);
  const auto& rs=impl->rs;const bool isStroke=rs.strokeWidth()>0;auto rle=isStroke?task->shape.strokeRle:task->shape.rle;
  std::printf("%s{\"name\":\"%s\",\"stroke\":%s,\"width\":%g,\"path\":",comma?",":"",name,isStroke?"true":"false",rs.strokeWidth());comma=true;path(rs.path);
  BBox tight;assert(const_cast<RenderPath&>(rs.path).bounds(&task->transform,tight));std::printf(",\"tight\":");box(tight);
  auto o=rs.stroke&&rs.stroke->dash.count?_genDashOutline(&rs,task->renderer->mpool,0,rs.trimpath()):_genOutline(&rs,task->renderer->mpool,0,rs.trimpath());assert(o);std::printf(",\"centerline\":");outline(o);
  BBox control;utilExport(o,task->transform,control);std::printf(",\"controlBox\":");box(control);
  std::printf(",\"transform\":[%g,%g,%g,%g,%g,%g]",task->transform.e11,task->transform.e12,task->transform.e13,task->transform.e21,task->transform.e22,task->transform.e23);
  if(isStroke){shapeResetStroke(task->shape,&rs,task->transform,task->renderer->mpool,0);assert(strokeParseOutline(task->shape.stroke,*o,task->renderer->mpool,0));auto expanded=strokeExportOutline(task->shape.stroke,task->renderer->mpool,0);std::printf(",\"expanded\":");outline(expanded);}
  // Stroke rebuild above resets the task span count: regenerate it before replay.
  if(isStroke){RenderRegion renderBox;assert(shapeGenStrokeRle(task->shape,&rs,task->transform,task->clipBox,renderBox,task->renderer->mpool,0,true));rle=task->shape.strokeRle;}
  std::printf(",\"renderBox\":[%d,%d,%d,%d],\"rle\":",task->curBox.min.x,task->curBox.min.y,task->curBox.max.x,task->curBox.max.y);spans(rle);
  std::printf(",\"pixels\":");pixels(buf);std::printf(",\"writes\":[");
  auto replay=std::vector<uint32_t>(stride*h,bg);SwSurface surface;surface.setup(replay.data(),stride,w,h,4,ColorSpace::ABGR8888);assert(rasterCompositor(&surface)==Result::Success);RenderColor color; if(isStroke)rs.strokeFill(&color.r,&color.g,&color.b,&color.a);else rs.fillColor(&color.r,&color.g,&color.b,&color.a);
  assert(rle&&rle->valid());
  for(unsigned i=0;i<rle->size();++i){auto s=rle->data()[i];SwRle one;one.spans.push(s);auto temp=task->shape;if(isStroke)temp.strokeRle=&one;else temp.rle=&one;assert(isStroke?rasterStroke(&surface,&temp,task->curBox,color):rasterShape(&surface,&temp,task->curBox,color));std::printf("%s[",i?",":"");for(int j=0;j<s.len;++j)std::printf("%s%u",j?",":"",replay[s.y*stride+s.x+j]);std::printf("]");}
  assert(replay==buf);std::printf("]}");delete canvas;
 };
 emit("fill",[&](Shape*s){curve(s);s->fill(32,120,220);});
 emit("bounds",[&](Shape*s){curve(s);s->fill(32,120,220);s->translate(6,-3);});
 for(int cap=0;cap<3;++cap){char name[32];std::snprintf(name,sizeof(name),"cap%d",cap);emit(name,[&](Shape*s){s->moveTo(4,9);s->lineTo(20,9);s->strokeWidth(3+delta);s->strokeFill(225,140,40);s->strokeCap(static_cast<StrokeCap>(cap));});}
 for(int join=0;join<3;++join){char name[32];std::snprintf(name,sizeof(name),"join%d",join);emit(name,[&](Shape*s){s->moveTo(3,13);s->lineTo(9,4);s->lineTo(20,12);s->strokeWidth(3+delta);s->strokeFill(225,140,40);s->strokeCap(StrokeCap::Butt);s->strokeJoin(static_cast<StrokeJoin>(join));});}
 for(int offset=0;offset<=5;++offset){char name[32];std::snprintf(name,sizeof(name),"dash%d",offset);emit(name,[&](Shape*s){s->moveTo(3,13);s->cubicTo(3,2,20,2,20,13);s->strokeWidth(2);s->strokeFill(225,140,40);s->strokeCap(StrokeCap::Butt);float pattern[]={4+delta,2};s->strokeDash(pattern,2,offset);});}
 for(int simultaneous=0;simultaneous<2;++simultaneous)for(int end=1;end<=4;++end){char name[32];std::snprintf(name,sizeof(name),"trim%d_%d",simultaneous,end);emit(name,[&](Shape*s){s->moveTo(3,5);s->lineTo(21,5);s->moveTo(3,12);s->lineTo(12+delta,12);s->strokeWidth(2);s->strokeFill(225,140,40);s->strokeCap(StrokeCap::Butt);s->trimpath(0,end*.25f,simultaneous);});}
 for(int rule=0;rule<2;++rule){char name[32];std::snprintf(name,sizeof(name),"rule%d",rule);emit(name,[&](Shape*s){s->appendRect(3,3,18,12);s->appendRect(8,6,8,6);s->fill(32,120,220);s->fillRule(static_cast<FillRule>(rule));});}
 std::printf("],\"bezier\":{\"control\":[[3,9],[%g,1],[17,1],[20,13]],\"samples\":[",6+delta);
 Bezier b{{3,9},{6+delta,1},{17,1},{20,13}};for(int i=0;i<=60;++i){if(i)std::printf(",");point(b.at(i/60.0f));}
 Bezier l,r;b.split(l,r);std::printf("],\"split\":[");for(auto bz:{l,r}){if(bz.start.x!=l.start.x)std::printf(",");std::printf("[");point(bz.start);std::printf(",");point(bz.ctrl1);std::printf(",");point(bz.ctrl2);std::printf(",");point(bz.end);std::printf("]");}std::printf("]}}\n");Initializer::term();
}
