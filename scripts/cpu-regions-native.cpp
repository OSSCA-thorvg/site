// Read-only replay of the pinned ThorVG CPU engine. Public draw is the oracle.
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include "tvgShape.h"
#include "tvgSwRenderer.cpp"

constexpr unsigned W = 16, H = 12;
using Pixels = std::vector<uint32_t>;
static void pixels(const Pixels& values)
{
    printf("[");
    for (unsigned i = 0; i < values.size(); ++i) printf("%s%u", i ? "," : "", values[i]);
    printf("]");
}
static void box(const RenderRegion& r) {printf("[%d,%d,%d,%d]",r.min.x,r.min.y,r.max.x,r.max.y);}
static Pixels coverage(SwShapeTask* task)
{
    Pixels out(W * H, 0);
    if (!task) return out;
    task->done();
    if (task->shape.rle) {
        for (auto& s : task->shape.rle->spans) for (int x=s.x;x<s.x+s.len;++x) if(x>=0&&x<int(W)&&s.y>=0&&s.y<int(H)) out[s.y*W+x]=s.coverage;
    } else if (task->shape.fastTrack) {
        for(int y=task->curBox.min.y;y<task->curBox.max.y;++y) for(int x=task->curBox.min.x;x<task->curBox.max.x;++x) out[y*W+x]=255;
    }
    return out;
}
static void run(const char* name, bool variant)
{
    bool masking=!strncmp(name,"mask",4), clipping=!strncmp(name,"clip",4), viewport=!strncmp(name,"viewport",8);
    bool rect=!strcmp(name,"clipRect")||!strcmp(name,"maskRect");
    bool clear=strcmp(name,"viewportKeep");
    bool onlyClip=!strcmp(name,"clipGeometry");
    Pixels output(W*H,viewport?0xfff0eae5:0);
    auto canvas=SwCanvas::gen();
    assert(canvas->target(output.data(),W,W,H,ColorSpace::ABGR8888)==Result::Success);
    if(viewport)assert(canvas->viewport(variant?5:4,2,8,7)==Result::Success);
    auto source=Shape::gen();
    if(masking||!strcmp(name,"sourceRect"))source->appendRect(1,1,13,10);
    else if(onlyClip)source->appendCircle(variant?8.55f:9.2f,5.5f,4.7f,4.2f);
    else source->appendCircle(7.4f,6.0f,6.0f,4.5f);
    source->fill(230,97,33);
    Shape* target=nullptr;
    if(masking|| (clipping&&!onlyClip)) {
        target=Shape::gen();
        if(rect)target->appendRect(4,2,7,7);
        else target->appendCircle(variant?8.55f:9.2f,5.5f,4.7f,4.2f);
        target->fill(45,160,210,rect?255:variant?96:160);
        if(masking)assert(source->mask(target,!strcmp(name,"maskInv")?MaskMethod::InvAlpha:!strcmp(name,"maskLuma")?MaskMethod::Luma:MaskMethod::Alpha)==Result::Success);
        else {target->fill(12,230,80,0);target->opacity(0);assert(source->clip(target)==Result::Success);}
    }
    assert(canvas->add(source)==Result::Success);
    assert(canvas->update()==Result::Success);
    auto task=static_cast<SwShapeTask*>(PAINT(source)->rd);
    auto cov=coverage(task);
    auto renderer=static_cast<SwRenderer*>(PAINT(source)->renderer);
    auto targetTask=target?static_cast<SwShapeTask*>(PAINT(target)->rd):nullptr;
    auto tcov=coverage(targetTask);
    printf("\"%s\":{\"coverage\":",name);pixels(cov);
    printf(",\"clipBox\":");box(task->clipBox);
    printf(",\"curBox\":");box(task->curBox);
    printf(",\"restoredViewport\":");box(renderer->viewport());
    printf(",\"clipCount\":%u,\"fastTrack\":%s,\"targetCoverage\":",task->clips.count,target&&(PAINT(target)->ctxFlag&ContextFlag::FastTrack)?"true":"false");pixels(tcov);
    assert(canvas->draw(clear)==Result::Success);
    assert(canvas->sync()==Result::Success);
    printf(",\"pixels\":");pixels(output);
    printf(",\"compositors\":%u",renderer->compositors.count);
    if(masking&&!rect) {
        assert(renderer->compositors.count==1);
        auto cmp=renderer->compositors[0]->compositor;
        Pixels storage(W*H,0);
        for(int y=cmp->bbox.min.y;y<cmp->bbox.max.y;++y)for(int x=cmp->bbox.min.x;x<cmp->bbox.max.x;++x)storage[y*W+x]=cmp->image.channelSize==1?cmp->image.buf8[y*cmp->image.stride+x]:cmp->image.buf32[y*cmp->image.stride+x];
        printf(",\"maskStorage\":");pixels(storage);
        printf(",\"maskChannels\":%u,\"contextRestored\":%s",cmp->image.channelSize,renderer->surface->compositor==nullptr?"true":"false");
    }
    printf("}");
    delete canvas;
}

static Pixels imageCoverage(SwRle* rle)
{
    Pixels out(W*H,0);
    if(rle)for(auto& span:rle->spans)for(int x=span.x;x<span.x+span.len;++x)
        if(x>=0&&x<int(W)&&span.y>=0&&span.y<int(H))out[span.y*W+x]=span.coverage;
    return out;
}
static void spans(SwRle* rle)
{
    printf("[");unsigned i=0;
    if(rle)for(auto& s:rle->spans)printf("%s[%d,%d,%u,%u]",i++?",":"",s.x,s.y,s.len,s.coverage);
    printf("]");
}
static Pixels portrait()
{
    Pixels out(W*H,0xffe8d2ba);
    for(unsigned y=0;y<H;++y)for(unsigned x=0;x<W;++x){
        if(y>=7 && x>=3 && x<=12)out[y*W+x]=0xffaa6c23;
        if((int(x)-8)*(int(x)-8)+(int(y)-4)*(int(y)-4)<=7)out[y*W+x]=y<=2?0xff433830:0xffa8c6e9;
    }
    return out;
}
static void avatar(bool changed)
{
    auto input=portrait();float cx=changed?7.25f:8.0f;
    printf("\"avatar\":{\"width\":16,\"height\":12,\"circle\":[%g,5.5,5,5],\"badge\":[12,8.5,2,2],\"badgeColor\":[35,160,100,255],\"background\":4294045416,\"sourcePixels\":",cx);pixels(input);
    // Unclipped badge coverage is captured in an independent public Canvas run.
    {
        Pixels dst(W*H);auto canvas=SwCanvas::gen();canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888);
        auto badge=Shape::gen();badge->appendCircle(12,8.5,2,2);badge->fill(35,160,100);canvas->add(badge);canvas->update();
        auto cov=coverage(static_cast<SwShapeTask*>(PAINT(badge)->rd));printf(",\"badgeRaw\":");pixels(cov);
        printf(",\"badgeRawSpans\":");spans(static_cast<SwShapeTask*>(PAINT(badge)->rd)->shape.rle);delete canvas;
    }
    for(bool complete:{false,true}){
        Pixels dst(W*H);auto canvas=SwCanvas::gen();canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888);
        auto background=Shape::gen();background->appendRect(0,0,W,H);background->fill(232,238,241);canvas->add(background);
        auto group=Scene::gen();auto photo=Picture::gen();assert(photo->load(input.data(),W,H,ColorSpace::ABGR8888,true)==Result::Success);group->add(photo);
        Shape* badge=nullptr;if(complete){badge=Shape::gen();badge->appendCircle(12,8.5,2,2);badge->fill(35,160,100);group->add(badge);}
        auto roundClip=Shape::gen();roundClip->appendCircle(cx,5.5,5,5);
        assert(group->clip(roundClip)==Result::Success);
        assert(PAINT(group)->clipper==roundClip && PAINT(roundClip)->rd==nullptr);
        canvas->add(group);
        assert(canvas->update()==Result::Success);
        auto ct=static_cast<SwShapeTask*>(PAINT(roundClip)->rd);auto it=static_cast<SwImageTask*>(PAINT(photo)->rd);ct->done();it->done();
        if(complete){
            auto bt=static_cast<SwShapeTask*>(PAINT(badge)->rd);bt->done();
            assert(ct->clipper && it->clips.count==1 && bt->clips.count==1);
            assert(it->clips[0]==ct && bt->clips[0]==ct);
            printf(",\"clipCoverage\":");pixels(coverage(ct));printf(",\"photoCoverage\":");pixels(imageCoverage(it->image.rle));
            printf(",\"badgeCoverage\":");pixels(coverage(bt));printf(",\"clipSpans\":");spans(ct->shape.rle);
            printf(",\"photoSpans\":");spans(it->image.rle);printf(",\"badgeSpans\":");spans(bt->shape.rle);
            printf(",\"sameClipTask\":true,\"clipperFlag\":true,\"clipCounts\":[%u,%u],\"clipFastTrack\":%s",it->clips.count,bt->clips.count,ct->shape.fastTrack?"true":"false");
        }
        assert(canvas->draw(true)==Result::Success);assert(canvas->sync()==Result::Success);
        printf(complete?",\"finalPixels\":":",\"photoPixels\":");pixels(dst);
        if(complete)printf(",\"compositors\":%u",static_cast<SwRenderer*>(PAINT(photo)->renderer)->compositors.count);
        delete canvas;
    }
    printf("}");
}
static Scene* profile(const Pixels& input, Picture*& photo, Shape*& badge, bool complete)
{
    auto group=Scene::gen();photo=Picture::gen();
    assert(photo->load(input.data(),W,H,ColorSpace::ABGR8888,true)==Result::Success);group->add(photo);
    badge=nullptr;
    if(complete){badge=Shape::gen();badge->appendCircle(12,8.5,2,2);badge->fill(35,160,100);group->add(badge);}
    return group;
}
static Pixels compositorPixels(SwCompositor* cmp)
{
    Pixels out(W*H,0);
    for(int y=cmp->bbox.min.y;y<cmp->bbox.max.y;++y)for(int x=cmp->bbox.min.x;x<cmp->bbox.max.x;++x)
        out[y*W+x]=cmp->image.channelSize==1?cmp->image.buf8[y*cmp->image.stride+x]:cmp->image.buf32[y*cmp->image.stride+x];
    return out;
}
static void maskAvatar(bool changed)
{
    auto input=portrait();Pixels dst(W*H,0);auto canvas=SwCanvas::gen();canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888);
    Picture* photo;Shape* badge;auto group=profile(input,photo,badge,true);
    auto fadeMask=Shape::gen();float cx=changed?7.25f:8.0f;auto alpha=changed?96:160;
    fadeMask->appendCircle(cx,5.5,5,5);fadeMask->fill(45,160,210,alpha);
    assert(group->mask(fadeMask,MaskMethod::Alpha)==Result::Success);
    assert(PAINT(group)->maskData->source==group&&PAINT(group)->maskData->target==fadeMask&&PAINT(fadeMask)->rd==nullptr);
    canvas->add(group);assert(canvas->update()==Result::Success);
    auto pt=static_cast<SwImageTask*>(PAINT(photo)->rd);auto bt=static_cast<SwShapeTask*>(PAINT(badge)->rd);auto mt=static_cast<SwShapeTask*>(PAINT(fadeMask)->rd);
    pt->done();bt->done();mt->done();
    assert(PAINT(group)->marked(CompositionFlag::Masking)&&!mt->clipper&&pt->clips.count==0&&bt->clips.count==0&&pt->opacity==255&&bt->opacity==255);
    printf("\"maskAvatar\":{\"circle\":[%g,5.5,5,5],\"alpha\":%u,\"sceneMasking\":true,\"childOpacity\":[%u,%u],\"clipCounts\":[0,0],\"sourcePixels\":",cx,alpha,pt->opacity,bt->opacity);pixels(input);
    printf(",\"maskCoverage\":");pixels(coverage(mt));printf(",\"maskSpans\":");spans(mt->shape.rle);
    printf(",\"badgeCoverage\":");pixels(coverage(bt));printf(",\"badgeSpans\":");spans(bt->shape.rle);
    assert(canvas->draw(true)==Result::Success);assert(canvas->sync()==Result::Success);
    auto renderer=static_cast<SwRenderer*>(PAINT(photo)->renderer);assert(renderer->compositors.count==2&&renderer->surface->compositor==nullptr);
    bool gray=false,color=false;
    for(auto surface:renderer->compositors){auto cmp=surface->compositor;
        if(cmp->image.channelSize==1){assert(!gray);gray=true;printf(",\"maskStorage\":");pixels(compositorPixels(cmp));}
        else{assert(!color);color=true;printf(",\"groupPixels\":");pixels(compositorPixels(cmp));}
    }
    assert(gray&&color);printf(",\"pixels\":");pixels(dst);printf(",\"compositors\":2,\"contextRestored\":true}");delete canvas;
}
static void viewportAvatar(bool changed)
{
    auto input=portrait();auto x=changed?5:4;
    printf("\"viewportAvatar\":{\"requested\":[%d,2,8,7],\"background\":4293978853,\"sourcePixels\":",x);pixels(input);
    for(bool clear:{false,true})for(bool complete:{false,true}){
        Pixels dst(W*H,0xfff0eae5);auto canvas=SwCanvas::gen();canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888);
        assert(canvas->viewport(x,2,8,7)==Result::Success);
        Picture* photo;Shape* badge;auto group=profile(input,photo,badge,complete);canvas->add(group);assert(canvas->update()==Result::Success);
        auto pt=static_cast<SwImageTask*>(PAINT(photo)->rd);pt->done();
        if(complete&&!clear){auto bt=static_cast<SwShapeTask*>(PAINT(badge)->rd);bt->done();
            assert(pt->clips.count==0&&bt->clips.count==0&&pt->image.rle==nullptr);
            printf(",\"photoClipBox\":");box(pt->clipBox);printf(",\"badgeClipBox\":");box(bt->clipBox);
            printf(",\"photoBounds\":");box(pt->curBox);printf(",\"badgeBounds\":");box(bt->curBox);
            printf(",\"badgeCoverage\":");pixels(coverage(bt));printf(",\"badgeSpans\":");spans(bt->shape.rle);
            printf(",\"imageRle\":false,\"clipCounts\":[0,0]");
        }
        assert(canvas->draw(clear)==Result::Success);assert(canvas->sync()==Result::Success);
        printf(",\"%s\":",clear?(complete?"clearPixels":"clearPhotoPixels"):(complete?"keepPixels":"keepPhotoPixels"));pixels(dst);
        assert(static_cast<SwRenderer*>(PAINT(photo)->renderer)->compositors.count==0);delete canvas;
    }
    printf(",\"compositors\":0}");
}
int main(int argc,char**)
{
    assert(Initializer::init(0)==Result::Success);
    printf("{\"width\":16,\"height\":12,\"variant\":%s,\"cases\":{",argc>1?"true":"false");
    const char* names[]={"sourceRect","sourceEllipse","clipGeometry","maskAlpha","maskInv","maskLuma","maskRect","clipCurve","clipRect","viewportKeep","viewportClear"};
    for(unsigned i=0;i<sizeof(names)/sizeof(*names);++i){if(i)printf(",");run(names[i],argc>1);}
    printf("},");avatar(argc>1);printf(",");maskAvatar(argc>1);printf(",");viewportAvatar(argc>1);printf("}\n");
    assert(Initializer::term()==Result::Success);
}
