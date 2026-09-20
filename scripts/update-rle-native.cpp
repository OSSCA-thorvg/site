// Read-only evidence: compile against ThorVG 4d5810cf, never alter the engine.
// The probe calls original static RLE functions and validates its band replay
// against public rleRender with both normal and illustrative reduced pools.
#include <cassert>
#include <cstdio>
#include <vector>
#include <algorithm>
#include <array>
#include "tvgSwRle.cpp"

using Cells = std::vector<std::array<long, 4>>;
static Cells cells(const RleWorker& rw) {
    Cells out;
    for (int y = 0; y < rw.yCnt; ++y)
        for (auto c = rw.yCells[y]; c; c = c->next)
            out.push_back({c->x + rw.cellMin.x, y + rw.cellMin.y, c->cover, c->area});
    return out;
}
static Cells allocated(const RleWorker& rw) {
    Cells out;
    for(ptrdiff_t i=0;i<rw.cellsCnt;++i) {
        auto c=&rw.cells[i];int worldY=-1;
        for(int y=0;y<rw.yCnt;++y) for(auto row=rw.yCells[y];row;row=row->next) if(row==c)worldY=y+rw.cellMin.y;
        assert(worldY>=0);out.push_back({c->x+rw.cellMin.x,worldY,c->cover,c->area});
    }
    return out;
}
static void printCells(const Cells& values) {
    printf("[");
    for (unsigned i = 0; i < values.size(); ++i) {
        const auto& v = values[i];
        printf("%s{\"x\":%ld,\"y\":%ld,\"cover\":%ld,\"area\":%ld}", i ? "," : "", v[0], v[1], v[2], v[3]);
    }
    printf("]");
}
static void printSpans(const SwRle& rle) {
    printf("[");
    for (unsigned i = 0; i < rle.spans.count; ++i) {
        const auto& s = rle.spans[i];
        printf("%s{\"x\":%d,\"y\":%d,\"len\":%d,\"coverage\":%u}", i ? "," : "", s.x,s.y,s.len,s.coverage);
    }
    printf("]");
}
static bool equal(const SwRle& a, const SwRle& b) {
    if (a.spans.count != b.spans.count) return false;
    for (unsigned i=0; i<a.spans.count; ++i) {
        auto x=a.spans[i], y=b.spans[i];
        if (x.x!=y.x || x.y!=y.y || x.len!=y.len || x.coverage!=y.coverage) return false;
    }
    return true;
}
struct Probe {
    RenderPath path;
    SwOutline outline;
    SwRle rle;
    std::vector<SwCell> storage;
    RleWorker rw{};
    Probe(int dx, int bottom, int top, unsigned bytes=24576) : storage(bytes/sizeof(SwCell)) {
        const SwPoint points[]={{80+dx,80},{80+dx,272},{192+dx,336},{368+dx,272},{336+dx,112}};
        for (unsigned i=0;i<5;++i) {outline.out.push(points[i]);path.pts.push(points[i].toPoint());}
        for(auto cmd : {PathCommand::MoveTo,PathCommand::LineTo,PathCommand::CubicTo,PathCommand::Close})path.cmds.push(cmd);
        outline.path=&path;outline.fillRule=FillRule::NonZero;
        auto heads=sizeof(SwCell*)*(top-bottom);
        auto aligned=(heads+sizeof(SwCell)-1)/sizeof(SwCell)*sizeof(SwCell);
        rw.rle=&rle;rw.outline=&outline;rw.cellMin={1,bottom};rw.cellMax={7,top};rw.cellXCnt=6;rw.cellYCnt=top-bottom;
        rw.yCnt=top-bottom;rw.yCells=reinterpret_cast<SwCell**>(storage.data());
        rw.cells=reinterpret_cast<SwCell*>(reinterpret_cast<char*>(storage.data())+aligned);
        rw.maxCells=(bytes-aligned)/sizeof(SwCell);rw.invalid=true;rw.antiAlias=true;
    }
};
// Same native flatness decision; accepted chords are checked against _cubicTo.
static void chords(std::vector<SwPoint>& out, SwPoint a, SwPoint b, SwPoint c, SwPoint d) {
    SwPoint stack[7]={d,c,b,a};
    auto diff=a-d;auto L=HYPOT(diff), limit=L*(ONE_PIXEL/6);
    auto v1=c-d,v2=b-d;
    if (L>SHRT_MAX || abs(diff.y*v1.x-diff.x*v1.y)>limit || abs(diff.y*v2.x-diff.x*v2.y)>limit ||
        v1.x*(v1.x-diff.x)+v1.y*(v1.y-diff.y)>0 || v2.x*(v2.x-diff.x)+v2.y*(v2.y-diff.y)>0) {
        _splitCubic(stack);
        chords(out,stack[6],stack[5],stack[4],stack[3]);
        chords(out,stack[3],stack[2],stack[1],stack[0]);
    } else out.push_back(d);
}
int main(int argc,char**) {
    const int dx=argc>1 ? 16:0;
    Probe p(dx,2,4);
    auto point=[&](unsigned i){return UPSCALE(p.outline.out[i]);};
    assert(_moveTo(p.rw,point(0)));assert(_lineTo(p.rw,point(1)));auto lineCells=cells(p.rw);
    assert(_cubicTo(p.rw,point(2),point(3),point(4)));auto afterCubic=cells(p.rw);
    assert(_lineTo(p.rw,point(0)));if(!p.rw.invalid)assert(_recordCell(p.rw));
    auto finalCells=cells(p.rw);_sweep(p.rw);
    std::vector<SwPoint> trace{point(1)};chords(trace,point(1),point(2),point(3),point(4));
    Probe replay(dx,2,4);assert(_moveTo(replay.rw,point(0)));assert(_lineTo(replay.rw,point(1)));
    for(unsigned i=1;i<trace.size();++i)assert(_lineTo(replay.rw,trace[i]));
    assert(cells(replay.rw)==afterCubic);
    printf("{\"dx\":%.10g,\"cellBytes\":%zu,\"pointerBytes\":%zu,\"band\":[2,4],\"bbox\":[1,1,7,5],\"points\":[",dx/64.0,sizeof(SwCell),sizeof(SwCell*));
    for(unsigned i=0;i<5;++i)printf("%s[%.10g,%.10g]",i?",":"",p.outline.out[i].x/64.0,p.outline.out[i].y/64.0);
    printf("],\"chords\":[");for(unsigned i=0;i<trace.size();++i)printf("%s[%.10g,%.10g]",i?",":"",trace[i].x/256.0,trace[i].y/256.0);
    printf("],\"lineCells\":");printCells(lineCells);printf(",\"cells\":");printCells(finalCells);printf(",\"spans\":");printSpans(p.rle);
    const unsigned bytes=8*sizeof(SwCell);SwRle accumulated;
    printf(",\"poolBytes\":%u,\"attempts\":[",bytes);
    bool first=true;
    auto band=[&](auto&& self,int lo,int hi)->void {
        Probe trial(dx,lo,hi,bytes);const bool ok=_genRle(trial.rw);
        printf("%s{\"band\":[%d,%d],\"maxCells\":%td,\"ok\":%s,\"cells\":",first?"":",",lo,hi,trial.rw.maxCells,ok?"true":"false");first=false;printCells(cells(trial.rw));printf(",\"allocated\":");printCells(allocated(trial.rw));
        printf(",\"spans\":");
        if(ok) {_sweep(trial.rw);for(auto& s:trial.rle.spans)accumulated.spans.push(s);}
        printSpans(trial.rle);printf("}");
        if(!ok){int mid=lo+((hi-lo)>>1);assert(mid!=lo);self(self,lo,mid);self(self,mid,hi);}
    };
    band(band,1,5);printf("],\"allSpans\":");printSpans(accumulated);
    RenderRegion bbox; bbox.min={1,1};bbox.max={7,5};SwMpool pool(0);
    auto normal=rleRender(nullptr,&p.outline,bbox,&pool,0,true);assert(normal&&equal(*normal,accumulated));rleFree(normal);
    auto cp=pool.cell(0);tvg::free(cp->buffer);cp->size=bytes;cp->buffer=tvg::malloc<SwCell>(bytes);
    auto reduced=rleRender(nullptr,&p.outline,bbox,&pool,0,true);assert(reduced&&equal(*reduced,accumulated));assert(cp->size==bytes);rleFree(reduced);
    printf(",\"verifiedNative\":true,\"verifiedChords\":true,\"verifiedReducedPool\":true}\n");
}
