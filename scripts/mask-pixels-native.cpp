// Reuse the exact avatar fixture; change only the destination for source-over.
#include "mask-avatar-fixture.h"

static void runPixels(bool changed, uint32_t background)
{
    auto input=portrait(); Pixels dst(W*H,background);
    auto canvas=SwCanvas::gen();
    assert(canvas->target(dst.data(),W,W,H,ColorSpace::ABGR8888)==Result::Success);
    Picture* photo; Shape* badge; auto group=profile(input,photo,badge,true);
    auto mask=Shape::gen();
    mask->appendCircle(changed?7.25f:8.0f,5.5f,5,5);
    mask->fill(45,160,210,changed?96:160);
    assert(group->mask(mask,MaskMethod::Alpha)==Result::Success);
    assert(canvas->add(group)==Result::Success);
    assert(canvas->update()==Result::Success);
    auto mt=static_cast<SwShapeTask*>(PAINT(mask)->rd);
    auto bt=static_cast<SwShapeTask*>(PAINT(badge)->rd);
    mt->done(); bt->done();
    printf("{\"background\":%u,\"maskCoverage\":",background); pixels(coverage(mt));
    printf(",\"maskSpans\":"); spans(mt->shape.rle);
    printf(",\"badgeCoverage\":"); pixels(coverage(bt));
    printf(",\"badgeSpans\":"); spans(bt->shape.rle);
    assert(canvas->draw(false)==Result::Success); assert(canvas->sync()==Result::Success);
    auto renderer=static_cast<SwRenderer*>(PAINT(photo)->renderer);
    assert(renderer->compositors.count==2&&renderer->surface->compositor==nullptr);
    for(auto surface:renderer->compositors){
        auto cmp=surface->compositor;
        printf(cmp->image.channelSize==1?",\"maskStorage\":":",\"groupPixels\":");
        pixels(compositorPixels(cmp));
    }
    printf(",\"pixels\":"); pixels(dst);
    printf(",\"restored\":true}");
    delete canvas;
}

int main(int argc,char**)
{
    Initializer::init(0);
    printf("{\"transparent\":"); runPixels(argc>1,0);
    printf(",\"background\":"); runPixels(argc>1,0xffeee5dc);
    printf("}\n"); Initializer::term();
    return 0;
}
