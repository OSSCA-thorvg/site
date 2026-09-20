// Native geometry trace for the GPU Engine overview articles.
// Compiled by scripts/generate-gpu-overview-trace.mjs against a matching static
// ThorVG build (GL by default, WebGPU with -DTRACE_WG) plus an instrumented copy
// of the backend tessellator. The ThorVG checkout is never modified.
#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>
#ifdef GPU_TRACE_STROKE_PATH
#include <cstdarg>
#include <type_traits>
#endif
#include "tvgCommon.h"
#include "tvgMath.h"
#include "tvgRender.h"
#include "tvgShape.h"
#include "tvgGpuCommon.h"
#ifndef GPU_EXAMPLE_HEADER
#define GPU_EXAMPLE_HEADER "gpu-overview-example.h"
#define GPU_EXAMPLE_NS gpuOverviewExample
#endif
#include GPU_EXAMPLE_HEADER
namespace example = GPU_EXAMPLE_NS;

// Opt-in switches, off by default so the overview / topic traces are unchanged.
// GPU_TRACE_CONVEX_WINDING: emit the fill winding grid for convex paints too. Clip
//   paths are stencilled with INCR_WRAP / DECR_WRAP (GL GlClipTask::run) or the
//   nonzero pipeline (WGPU markupClipPath) whether or not they are convex.
// GPU_EXAMPLE_META: append `"meta": example::meta()` (a JSON string from the
//   fixture header) for fixture facts that are not traced Shapes.
// GPU_TRACE_STROKE_PATH: follow the backends' stroke-path order. GlGeometry::prepare /
//   WgShape::update trim rs.path first when trimpath() is set and gpuOptimize the trimmed
//   path (fill + optimised local stroke path); GlGeometry::tesselateStroke / WgShape::update
//   stroke gpuStrokeDash(rs, dashed, nullptr) instead of that local path when it returns
//   true. Instrumented copies of the trim / dash code (trace-stroke-path.cpp, written by
//   instrumentStrokePath() in scripts/lib/gpu-native-trace.mjs) run next to the library
//   functions and must produce bit-identical paths; Stroker::cap() calls become `cap` ops.
//   Appends `"strokePath"` to every paint and `"trimGet"` to the top level.
#ifdef GPU_TRACE_CONVEX_WINDING
static constexpr bool convexWinding = true;
#else
static constexpr bool convexWinding = false;
#endif

#ifdef TRACE_WG
#include "tvgWgMesh.h"
using Buffer = WgMesh;
static uint32_t vcount(const Buffer* b) { return b->vbuffer.count; }
static uint32_t tcount(const Buffer* b) { return b->ibuffer.count / 3; }
static Point vertexAt(const Buffer* b, uint32_t i) { return b->vbuffer[i]; }
static uint32_t indexAt(const Buffer* b, uint32_t i) { return b->ibuffer[i]; }
#else
#include "tvgGlCommon.h"
using Buffer = GlGeometryBuffer;
static uint32_t vcount(const Buffer* b) { return b->vertex.count / 2; }
static uint32_t tcount(const Buffer* b) { return b->index.count / 3; }
static Point vertexAt(const Buffer* b, uint32_t i) { return {b->vertex[i * 2], b->vertex[i * 2 + 1]}; }
static uint32_t indexAt(const Buffer* b, uint32_t i) { return b->index[i]; }
#endif

/************************************************************************/
/* Trace hooks used by the instrumented tessellator copy                */
/************************************************************************/

struct ProbeStep { Point edge; const char* op; bool convex; int winding; int xDir; int yDir; int xChanges; int yChanges; int reversals; };
static std::vector<ProbeStep> probeSteps;

static void record(const GpuConvexProbe& probe, const Point& edge, const char* op)
{
    probeSteps.push_back({edge, op, probe.convex, probe.winding, probe.prevXDir, probe.prevYDir, probe.xDirChanges, probe.yDirChanges, probe.reversals});
}
static void traceEdge(GpuConvexProbe& probe, const Point& edge) { probe.addEdge(edge); record(probe, edge, "edge"); }
static void traceClose(GpuConvexProbe& probe, const Point& edge) { probe.addContourClose(edge); record(probe, edge, "close"); }
static void traceContour(GpuConvexProbe& probe) { probe.nextContour(); record(probe, {0.0f, 0.0f}, "contour"); }

struct CubicStep { Bezier curve; uint32_t segments; bool crossed; };
static std::vector<CubicStep> cubicSteps;
static void traceCubic(const Bezier& curve, uint32_t segments, bool crossed) { cubicSteps.push_back({curve, segments, crossed}); }

struct StrokeOp { const char* kind; uint32_t v0, vc, t0, tc; Point at, to; int orient; };
static std::vector<StrokeOp> strokeOps;

struct TraceScope
{
    const Buffer* buffer; const char* kind; Point at; uint32_t v0, t0;
    TraceScope(const Buffer* buffer, const char* kind, const Point& at) : buffer(buffer), kind(kind), at(at), v0(vcount(buffer)), t0(tcount(buffer)) {}
    ~TraceScope()
    {
        auto vc = vcount(buffer) - v0, tc = tcount(buffer) - t0;
        if (strcmp(kind, "miter-limit") == 0) strokeOps.push_back({kind, v0, 0, t0, 0, at, at, 0});
        else if (vc) strokeOps.push_back({kind, v0, vc, t0, tc, at, at, 0});
    }
};
static void traceQuad(const Buffer* buffer, const Point& from, const Point& to)
{
    strokeOps.push_back({"quad", vcount(buffer) - 4, 4, tcount(buffer) - 2, 2, from, to, 0});
}
static void traceJoin(Orientation orient, const Point& at) { strokeOps.push_back({"join", 0, 0, 0, 0, at, at, int(orient)}); }
#ifdef GPU_TRACE_STROKE_PATH
// Stroker::cap() entry: `at` = contour first point, `to` = last point. Butt returns without geometry.
static void traceCap(const Buffer* buffer, const Point& first, const Point& last) { strokeOps.push_back({"cap", vcount(buffer), 0, tcount(buffer), 0, first, last, 0}); }
#endif

#ifdef TRACE_WG
#include "trace-wgpu-tessellator.cpp"
using TraceTessellator = TraceWgBWTessellator;
using TraceStrokerType = TraceWgStroker;
#else
#include "trace-gl-tessellator.cpp"
using TraceTessellator = TraceBWTessellator;
using TraceStrokerType = TraceStroker;
#endif

#ifdef GPU_TRACE_STROKE_PATH
/************************************************************************/
/* Stroke-path hooks (trim + dash) used by trace-stroke-path.cpp         */
/************************************************************************/

static std::vector<std::string>* spSink = nullptr;  // null: hooks record nothing

static std::string spf(const char* fmt, ...)
{
    va_list ap, aq;
    va_start(ap, fmt);
    va_copy(aq, ap);
    auto n = vsnprintf(nullptr, 0, fmt, ap);
    va_end(ap);
    std::string s(n, '\0');
    vsnprintf(s.data(), n + 1, fmt, aq);
    va_end(aq);
    return s;
}
static const char* spBool(bool b) { return b ? "true" : "false"; }
static std::string spPt(const Point& p) { return spf("[%.8g,%.8g]", p.x, p.y); }
static std::string spPath(const RenderPath& path, uint32_t c0, uint32_t c1, uint32_t p0, uint32_t p1)
{
    std::string s = "{\"cmds\":[";
    for (auto i = c0; i < c1; ++i) s += spf("%s%d", i > c0 ? "," : "", int(path.cmds[i]));
    s += "],\"pts\":[";
    for (auto i = p0; i < p1; ++i) s += (i > p0 ? "," : "") + spPt(path.pts[i]);
    return s + "]}";
}
static std::string spPath(const RenderPath& path) { return spPath(path, 0, path.cmds.count, 0, path.pts.count); }
static void spEvent(const std::string& json) { if (spSink) spSink->push_back(json); }

// RenderTrimPath::trim and helpers (tvgRender.cpp).
static void traceTrimBegin(float begin, float end, bool simultaneous, const RenderPath& in)
{
    spEvent(spf("{\"ev\":\"trimBegin\",\"begin\":%.8g,\"end\":%.8g,\"simultaneous\":%s,\"inCmds\":%u,\"inPts\":%u}", begin, end, spBool(simultaneous), in.cmds.count, in.pts.count));
}
static void traceTrimGet(float begin0, float end0, bool loop, float begin, float end)
{
    spEvent(spf("{\"ev\":\"trimGet\",\"in\":[%.8g,%.8g],\"loop\":%s,\"out\":[%.8g,%.8g]}", begin0, end0, spBool(loop), begin, end));
}
static void traceTrimContour(uint32_t cmdsCnt, uint32_t ptsCnt, const Point& first, float begin, float end, bool connect, float totalLength, float trimStart, float trimEnd)
{
    spEvent(spf("{\"ev\":\"trimContour\",\"cmds\":%u,\"pts\":%u,\"first\":%s,\"begin\":%.8g,\"end\":%.8g,\"connect\":%s,\"totalLength\":%.8g,\"trimStart\":%.8g,\"trimEnd\":%.8g,\"wraps\":%s}",
                cmdsCnt, ptsCnt, spPt(first).c_str(), begin, end, spBool(connect), totalLength, trimStart, trimEnd, spBool(begin >= end)));
}
static void traceTrimPass(float trimStart, float trimEnd, bool connect, const RenderPath& out)
{
    spEvent(spf("{\"ev\":\"trimPass\",\"trimStart\":%.8g,\"trimEnd\":%.8g,\"connect\":%s,\"outCmds\":%u,\"outPts\":%u}", trimStart, trimEnd, spBool(connect), out.cmds.count, out.pts.count));
}
static void traceTrimStep(PathCommand cmd, uint32_t i, float len, float dLen, const char* branch, uint32_t cmd0, uint32_t pt0, const RenderPath& out)
{
    spEvent(spf("{\"ev\":\"trimStep\",\"i\":%u,\"cmd\":%d,\"len\":%.8g,\"dLen\":%.8g,\"branch\":\"%s\",\"emitted\":%s}", i, int(cmd), len, dLen, branch,
                spPath(out, cmd0, out.cmds.count, pt0, out.pts.count).c_str()));
}
static void traceTrimPassDone(const RenderPath& out) { spEvent(spf("{\"ev\":\"trimPassDone\",\"outCmds\":%u,\"outPts\":%u}", out.cmds.count, out.pts.count)); }
static void traceTrimCutLine(const char* kind, const Point& p0, const Point& p1, float at1, float at2, const Point& a, const Point& b, bool start)
{
    spEvent(spf("{\"ev\":\"trimCut\",\"kind\":\"%s\",\"from\":%s,\"to\":%s,\"at1\":%.8g,\"at2\":%.8g,\"approxLength\":%.8g,\"euclidLength\":%.8g,\"a\":%s,\"b\":%s,\"start\":%s}",
                kind, spPt(p0).c_str(), spPt(p1).c_str(), at1, at2, tvg::length(p0, p1), tvg::length(p1 - p0), spPt(a).c_str(), spPt(b).c_str(), spBool(start)));
}
static void traceTrimCutCubic(const Bezier& curve, float at1, float at2, const Bezier& left, bool start)
{
    spEvent(spf("{\"ev\":\"trimCut\",\"kind\":\"CubicTo\",\"from\":%s,\"to\":%s,\"at1\":%.8g,\"at2\":%.8g,\"length\":%.8g,\"a\":%s,\"b\":%s,\"piece\":[%s,%s,%s,%s],\"start\":%s}",
                spPt(curve.start).c_str(), spPt(curve.end).c_str(), at1, at2, curve.length(), spPt(left.start).c_str(), spPt(left.end).c_str(),
                spPt(left.start).c_str(), spPt(left.ctrl1).c_str(), spPt(left.ctrl2).c_str(), spPt(left.end).c_str(), spBool(start)));
}
static void traceTrimEnd(bool ok, const RenderPath& out) { spEvent(spf("{\"ev\":\"trimEnd\",\"ok\":%s,\"path\":%s}", spBool(ok), spPath(out).c_str())); }

// StrokeDashPath / gpuStrokeDash (tvgGpuCommon.cpp).
static float spPieceLength(const RenderPath& p, uint32_t c0, uint32_t c1, uint32_t pt)
{
    auto len = 0.0f;
    Point prev{};
    for (auto i = c0; i < c1; ++i) {
        switch (p.cmds[i]) {
            case PathCommand::MoveTo: prev = p.pts[pt++]; break;
            case PathCommand::LineTo: len += tvg::length(p.pts[pt] - prev); prev = p.pts[pt++]; break;
            case PathCommand::CubicTo: len += Bezier{prev, p.pts[pt], p.pts[pt + 1], p.pts[pt + 2]}.length(); prev = p.pts[pt + 2]; pt += 3; break;
            default: break;
        }
    }
    return len;
}
static void traceDashCall(bool trimmed, bool allowDot) { spEvent(spf("{\"ev\":\"dashCall\",\"trimmed\":%s,\"allowDot\":%s}", spBool(trimmed), spBool(allowDot))); }
static void traceDashNormalize(float offset0, float cycle, float offset, bool odd)
{
    spEvent(spf("{\"ev\":\"dashNormalize\",\"offset\":%.8g,\"cycle\":%.8g,\"normalized\":%.8g,\"doubled\":%s}", offset0, cycle, offset, spBool(odd)));
}
static void traceDashSkip(int32_t idx, float pattern, float offset, bool gap)
{
    spEvent(spf("{\"ev\":\"dashSkip\",\"idx\":%d,\"pattern\":%.8g,\"remaining\":%.8g,\"gapAfter\":%s}", idx, pattern, offset, spBool(gap)));
}
static void traceDashInit(const RenderStroke::Dash& dash, int32_t idx, float offset, bool gap, bool allowDot, const Matrix* transform)
{
    std::string pattern;
    for (uint32_t i = 0; i < dash.count; ++i) pattern += spf("%s%.8g", i ? "," : "", dash.pattern[i]);
    spEvent(spf("{\"ev\":\"dashInit\",\"pattern\":[%s],\"count\":%u,\"length\":%.8g,\"offset\":%.8g,\"state\":{\"idx\":%d,\"offset\":%.8g,\"gap\":%s},\"allowDot\":%s,\"transform\":%s}",
                pattern.c_str(), dash.count, dash.length, dash.offset, idx, offset, spBool(gap), spBool(allowDot), transform ? "\"set\"" : "null"));
}
static void traceDashBegin(const Point& start, int32_t idx, float curLen, bool gap)
{
    spEvent(spf("{\"ev\":\"dashBegin\",\"start\":%s,\"idx\":%d,\"curLen\":%.8g,\"gap\":%s}", spPt(start).c_str(), idx, curLen, spBool(gap)));
}
static void traceDashSegment(const char* kind, const Point& from, const Point& to, float len, int32_t idx, float curLen, bool gap, bool move)
{
    spEvent(spf("{\"ev\":\"dashSegment\",\"kind\":\"%s\",\"from\":%s,\"to\":%s,\"len\":%.8g,\"idx\":%d,\"curLen\":%.8g,\"gap\":%s,\"move\":%s}",
                kind, spPt(from).c_str(), spPt(to).c_str(), len, idx, curLen, spBool(gap), spBool(move)));
}
static void traceDashZeroLength(const Point& at) { spEvent(spf("{\"ev\":\"dashZeroLength\",\"at\":%s}", spPt(at).c_str())); }
static void traceDashZeroInterval(const Point& at, int32_t idx, bool gap, bool allowDot)
{
    spEvent(spf("{\"ev\":\"dashZeroInterval\",\"at\":%s,\"idx\":%d,\"gap\":%s,\"dot\":%s}", spPt(at).c_str(), idx, spBool(gap), spBool(allowDot && !gap)));
}
static void traceDashToggle(const char* why, const Point& at, float s, int32_t idx, float curLen, bool gap)
{
    spEvent(spf("{\"ev\":\"dashToggle\",\"why\":\"%s\",\"at\":%s,\"s\":%.8g,\"idx\":%d,\"curLen\":%.8g,\"gap\":%s}", why, spPt(at).c_str(), s, idx, curLen, spBool(gap)));
}
static void traceDashSegmentEnd(int32_t idx, float curLen, bool gap) { spEvent(spf("{\"ev\":\"dashSegmentEnd\",\"idx\":%d,\"curLen\":%.8g,\"gap\":%s}", idx, curLen, spBool(gap))); }
static void traceDashClose(const Point& start, bool endsAtStart, uint32_t added)
{
    spEvent(spf("{\"ev\":\"dashClose\",\"start\":%s,\"closeEndsAtStart\":%s,\"addedPts\":%u}", spPt(start).c_str(), spBool(endsAtStart), added));
}
static void traceDashFlush(const RenderPath& subOut, bool closed, bool closeEndsAtStart, const Point& mappedStart, const RenderPath& out)
{
    spEvent(spf("{\"ev\":\"dashFlush\",\"closed\":%s,\"closeEndsAtStart\":%s,\"start\":%s,\"subOut\":%s,\"outCmds\":%u,\"outPts\":%u}",
                spBool(closed), spBool(closeEndsAtStart), spPt(mappedStart).c_str(), spPath(subOut).c_str(), out.cmds.count, out.pts.count));
}
static void traceDashPiece(uint32_t k, uint32_t cmdBegin, uint32_t cmdEnd, uint32_t ptBegin, uint32_t ptEnd, const RenderPath& subOut)
{
    spEvent(spf("{\"ev\":\"dashPiece\",\"k\":%u,\"cmdBegin\":%u,\"cmdEnd\":%u,\"ptBegin\":%u,\"ptEnd\":%u,\"first\":%s,\"last\":%s,\"length\":%.8g}",
                k, cmdBegin, cmdEnd, ptBegin, ptEnd, spPt(subOut.pts[ptBegin]).c_str(), spPt(subOut.pts[ptEnd - 1]).c_str(), spPieceLength(subOut, cmdBegin, cmdEnd, ptBegin)));
}
static void traceDashWraps(bool first, bool last, const Point& firstPt, const Point& lastPt, const Point& start)
{
    spEvent(spf("{\"ev\":\"dashWraps\",\"firstStartsAtClose\":%s,\"lastEndsAtClose\":%s,\"firstPt\":%s,\"lastPt\":%s,\"start\":%s}",
                spBool(first), spBool(last), spPt(firstPt).c_str(), spPt(lastPt).c_str(), spPt(start).c_str()));
}
static void traceDashOutcome(const char* outcome) { spEvent(spf("{\"ev\":\"dashOutcome\",\"outcome\":\"%s\"}", outcome)); }
static void traceDashReason(const char* reason) { spEvent(spf("{\"ev\":\"dashReason\",\"reason\":\"%s\"}", reason)); }
static void traceDashDone(const RenderPath& out) { spEvent(spf("{\"ev\":\"dashDone\",\"path\":%s}", spPath(out).c_str())); }

#include "trace-stroke-path.cpp"

static bool samePath(const RenderPath& a, const RenderPath& b)
{
    return a.cmds.count == b.cmds.count && a.pts.count == b.pts.count &&
           (a.cmds.count == 0 || memcmp(a.cmds.data, b.cmds.data, a.cmds.count * sizeof(PathCommand)) == 0) &&
           (a.pts.count == 0 || memcmp(a.pts.data, b.pts.data, a.pts.count * sizeof(Point)) == 0);
}

// Per paint: the trim that GlGeometry::prepare / WgShape::update run before gpuOptimize,
// then gpuStrokeDash(rs, dashed, nullptr) as tesselateStroke / WgShape::update call it.
static struct { RenderPath trimmed, dashed; bool trimSet, trimOk, dashCalled, dashed_; std::vector<std::string> trimEvents, dashEvents; } sp;

static const RenderPath& strokePathPrepare(const RenderShape& rs)
{
    sp.trimmed.clear(); sp.dashed.clear(); sp.trimEvents.clear(); sp.dashEvents.clear();
    sp.trimSet = rs.trimpath(); sp.trimOk = false; sp.dashCalled = false; sp.dashed_ = false;
    if (!sp.trimSet) return rs.path;
    RenderPath lib;
    auto libOk = rs.stroke->trim.trim(rs.path, lib);
    spSink = &sp.trimEvents;
    sp.trimOk = strokeTrace::traceDashTrim(rs.stroke->trim, rs.path, sp.trimmed);
    spSink = nullptr;
    assert(sp.trimOk == libOk && samePath(sp.trimmed, lib));
    assert(sp.trimOk);  // every fixture trim keeps a path (GlGeometry::prepare would clear optPath otherwise)
    return sp.trimmed;
}

static const RenderPath& strokePathStrokeInput(const RenderShape& rs, const RenderPath& local)
{
    RenderPath lib;
    auto libOk = gpuStrokeDash(rs, lib, nullptr);
    sp.dashCalled = true;
    spSink = &sp.dashEvents;
    sp.dashed_ = strokeTrace::traceGpuStrokeDash(rs, sp.dashed, nullptr);
    spSink = nullptr;
    assert(sp.dashed_ == libOk && samePath(sp.dashed, lib));
    return sp.dashed_ ? sp.dashed : local;
}

static void printEvents(const std::vector<std::string>& events)
{
    printf("[");
    for (size_t i = 0; i < events.size(); ++i) printf("%s%s", i ? "," : "", events[i].c_str());
    printf("]");
}

static void printStrokePath(const RenderShape& rs)
{
    printf(",\"strokePath\":{\"trimpath\":");
    if (sp.trimSet) printf("{\"begin\":%.8g,\"end\":%.8g,\"simultaneous\":%s}", rs.stroke->trim.begin, rs.stroke->trim.end, spBool(rs.stroke->trim.simultaneous));
    else printf("null");
    printf(",\"dash\":");
    if (rs.stroke && rs.stroke->dash.count > 0) {
        printf("{\"pattern\":[");
        for (uint32_t i = 0; i < rs.stroke->dash.count; ++i) printf("%s%.8g", i ? "," : "", rs.stroke->dash.pattern[i]);
        printf("],\"count\":%u,\"offset\":%.8g,\"length\":%.8g}", rs.stroke->dash.count, rs.stroke->dash.offset, rs.stroke->dash.length);
    } else printf("null");
    printf(",\"prepare\":{\"trimmed\":%s,\"ok\":%s,\"path\":", spBool(sp.trimSet), spBool(sp.trimOk));
    if (sp.trimSet) printf("%s", spPath(sp.trimmed).c_str()); else printf("null");
    printf(",\"events\":"); printEvents(sp.trimEvents);
    printf("},\"gpuStrokeDash\":{\"called\":%s,\"transform\":null,\"returned\":%s,\"path\":", spBool(sp.dashCalled), spBool(sp.dashed_));
    if (sp.dashed_) printf("%s", spPath(sp.dashed).c_str()); else printf("null");
    printf(",\"events\":"); printEvents(sp.dashEvents);
    printf("},\"strokeInput\":\"%s\",\"libraryMatch\":true}", !sp.dashCalled ? "none" : sp.dashed_ ? "gpuStrokeDash" : "optimize.local");
}
#endif

/************************************************************************/
/* JSON helpers                                                         */
/************************************************************************/

static void printPoint(const Point& p) { printf("[%.8g,%.8g]", p.x, p.y); }

static void printPath(const RenderPath& path)
{
    printf("{\"cmds\":[");
    for (unsigned i = 0; i < path.cmds.count; ++i) printf("%s%d", i ? "," : "", int(path.cmds[i]));
    printf("],\"pts\":[");
    for (unsigned i = 0; i < path.pts.count; ++i) { if (i) printf(","); printPoint(path.pts[i]); }
    printf("]}");
}

static void printRegion(const RenderRegion& r) { printf("[%d,%d,%d,%d]", r.min.x, r.min.y, r.max.x, r.max.y); }

static void printBuffer(const Buffer* buffer)
{
    printf("\"vertices\":[");
    for (uint32_t i = 0; i < vcount(buffer); ++i) { if (i) printf(","); printPoint(vertexAt(buffer, i)); }
    printf("],\"triangles\":[");
    for (uint32_t i = 0; i < tcount(buffer); ++i) printf("%s[%u,%u,%u]", i ? "," : "", indexAt(buffer, i * 3), indexAt(buffer, i * 3 + 1), indexAt(buffer, i * 3 + 2));
    printf("]");
}

// Pixel-centre replay of the triangle list with the top-left fill convention,
// so shared fan edges are never counted twice. `faces` is the facing the GPU
// sees: both backends map canvas y-down to NDC y-up (GL _viewMatrix e22 = -2/h,
// WGPU view matrix -2/height), so a triangle with a positive y-down cross product
// is clockwise in NDC. With glFrontFace(GL_CCW) / the default WGPU CCW front face
// that makes it a back face. Front faces get INCR_WRAP / IncrementWrap (+1),
// back faces DECR_WRAP / DecrementWrap (-1). With `signedCount` the counts are the
// signed stencil value before 8-bit wrapping; otherwise plain coverage counts.
// `masks` (when the list has at most 31 triangles) records which triangles cover
// each pixel centre so a replay can show the stencil after every draw.
static void printGrid(const Buffer* buffer, const Matrix& matrix, const RenderRegion& bounds, bool signedCount)
{
    auto w = bounds.max.x - bounds.min.x, h = bounds.max.y - bounds.min.y;
    std::vector<int> grid(w * h, 0), masks(w * h, 0);
    std::vector<int> faces;
    auto maskable = tcount(buffer) <= 31;
    for (uint32_t t = 0; t < tcount(buffer); ++t) {
        Point v[3];
        for (auto k = 0; k < 3; ++k) v[k] = vertexAt(buffer, indexAt(buffer, t * 3 + k)) * matrix;
        auto area = cross(v[1] - v[0], v[2] - v[0]);
        auto sign = tvg::zero(area) ? 0 : (area > 0.0f ? 1 : -1);
        auto face = -sign;  // y flip in the view matrix: y-down cross > 0 is a GPU back face
        faces.push_back(face);
        if (!sign) continue;
        if (sign < 0) std::swap(v[1], v[2]);  // normalise winding so edge functions are positive inside
        auto edgeOK = [](const Point& a, const Point& b, const Point& p) {
            auto e = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);
            if (e > 0.0f) return true;
            if (e < 0.0f) return false;
            auto top = (a.y == b.y) && (b.x < a.x);
            auto left = b.y < a.y;
            return top || left;
        };
        for (auto y = 0; y < h; ++y) {
            for (auto x = 0; x < w; ++x) {
                Point p{bounds.min.x + x + 0.5f, bounds.min.y + y + 0.5f};
                if (!(edgeOK(v[0], v[1], p) && edgeOK(v[1], v[2], p) && edgeOK(v[2], v[0], p))) continue;
                grid[y * w + x] += signedCount ? face : 1;
                if (maskable) masks[y * w + x] |= 1 << t;
            }
        }
    }
    printf("{\"x\":%d,\"y\":%d,\"w\":%d,\"h\":%d,\"signed\":%s,\"faces\":[", bounds.min.x, bounds.min.y, w, h, signedCount ? "true" : "false");
    for (size_t i = 0; i < faces.size(); ++i) printf("%s%d", i ? "," : "", faces[i]);
    printf("],\"counts\":[");
    for (size_t i = 0; i < grid.size(); ++i) printf("%s%d", i ? "," : "", grid[i]);
    printf("],\"masks\":");
    if (maskable) {
        printf("[");
        for (size_t i = 0; i < masks.size(); ++i) printf("%s%d", i ? "," : "", masks[i]);
        printf("]");
    } else printf("null");
    printf("}");
}

static const char* capName(StrokeCap cap) { return cap == StrokeCap::Butt ? "Butt" : cap == StrokeCap::Round ? "Round" : "Square"; }
static const char* joinName(StrokeJoin join) { return join == StrokeJoin::Miter ? "Miter" : join == StrokeJoin::Round ? "Round" : "Bevel"; }

/************************************************************************/
/* Fixture                                                              */
/************************************************************************/

static void tracePaint(const GpuExampleFixture& item, bool last)
{
    auto& rs = to<ShapeImpl>(item.shape)->rs;
    const Matrix matrix = PAINT(item.shape)->transform();  // Paint::Impl::transform(): scale/rotate folded in
    auto strokeWidth = rs.strokeWidth();
    auto hasStroke = std::isfinite(strokeWidth) && !tvg::zero(strokeWidth);

    RenderPath world, local;
    GpuOptimizeResult result{&world, hasStroke ? &local : nullptr};
#ifdef GPU_TRACE_STROKE_PATH
    gpuOptimize(strokePathPrepare(rs), result, matrix);  // trimmed path when trimpath() is set
#else
    gpuOptimize(rs.path, result, matrix);
#endif
    assert(!result.thin && !result.skipFill);

    // GlRenderer::renderShape / WgCompositor draw the fill only with a colour alpha or a gradient.
    auto fillDrawn = rs.color.a > 0 || rs.fill;
    printf("{\"name\":\"%s\",\"api\":\"%s\",\"color\":[%u,%u,%u,%u],\"fillDrawn\":%s,\"fillRule\":\"%s\",\"transform\":[%.8g,%.8g,%.8g,%.8g,%.8g,%.8g],", item.name, item.api,
           rs.color.r, rs.color.g, rs.color.b, rs.color.a, fillDrawn ? "true" : "false", rs.rule == FillRule::EvenOdd ? "EvenOdd" : "NonZero",
           matrix.e11, matrix.e12, matrix.e13, matrix.e21, matrix.e22, matrix.e23);
    printf("\"path\":"); printPath(rs.path);
    printf(",\"optimize\":{\"world\":"); printPath(world);
    printf(",\"local\":"); if (hasStroke) printPath(local); else printf("null");
    printf(",\"thin\":%s,\"skipFill\":%s}", result.thin ? "true" : "false", result.skipFill ? "true" : "false");

    // Fill: triangle fan + convexity probe (BWTessellator / WgBWTessellator).
    Buffer fill{};
    probeSteps.clear(); cubicSteps.clear();
    TraceTessellator tess(&fill);
    tess.tessellate(world);
    auto convex = tess.convex;
    auto fillBounds = tess.bounds();
    // One fan per contour (probe.nextContour() runs on every MoveTo): k contours give vcount - 2k triangles.
    auto contours = 0u; for (auto& s : probeSteps) if (strcmp(s.op, "contour") == 0) ++contours;
    assert(contours >= 1 && vcount(&fill) >= 3 && tcount(&fill) == vcount(&fill) - 2 * contours);

    const char* stencilMode = convex ? "None" : (rs.rule == FillRule::EvenOdd ? "FillEvenOdd" : "FillNonZero");
    printf(",\"fill\":{"); printBuffer(&fill);
    printf(",\"convex\":%s,\"bounds\":", convex ? "true" : "false"); printRegion(fillBounds);
#ifdef TRACE_WG
    // WgShape::shape.bbox is the fill's float bbox. WgShape::bboxMesh is built
    // later from the union of this bbox and the stroke's world bounds.
    auto bbox = tess.getBBox();
    printf(",\"bbox\":[%.8g,%.8g,%.8g,%.8g]", bbox.min.x, bbox.min.y, bbox.max.x, bbox.max.y);
    BBox paintBox = bbox;
#else
    // GlStencilCoverBatch: cover quad = two triangles over the integer fill bbox.
    printf(",\"cover\":[[%d,%d],[%d,%d],[%d,%d],[%d,%d],[%d,%d],[%d,%d]]", fillBounds.min.x, fillBounds.min.y, fillBounds.min.x, fillBounds.max.y, fillBounds.max.x, fillBounds.min.y,
           fillBounds.max.x, fillBounds.min.y, fillBounds.min.x, fillBounds.max.y, fillBounds.max.x, fillBounds.max.y);
#endif
    printf(",\"stencilMode\":\"%s\",\"probe\":[", stencilMode);
    for (size_t i = 0; i < probeSteps.size(); ++i) {
        auto& s = probeSteps[i];
        printf("%s{\"op\":\"%s\",\"edge\":", i ? "," : "", s.op); printPoint(s.edge);
        printf(",\"convex\":%s,\"winding\":%d,\"xDir\":%d,\"yDir\":%d,\"xChanges\":%d,\"yChanges\":%d,\"reversals\":%d}", s.convex ? "true" : "false", s.winding, s.xDir, s.yDir, s.xChanges, s.yChanges, s.reversals);
    }
    printf("],\"cubics\":[");
    for (size_t i = 0; i < cubicSteps.size(); ++i) {
        auto& c = cubicSteps[i];
        printf("%s{\"start\":", i ? "," : ""); printPoint(c.curve.start); printf(",\"ctrl1\":"); printPoint(c.curve.ctrl1);
        printf(",\"ctrl2\":"); printPoint(c.curve.ctrl2); printf(",\"end\":"); printPoint(c.curve.end);
        printf(",\"segments\":%u,\"crossed\":%s}", c.segments, c.crossed ? "true" : "false");
    }
    printf("]");
    if (!convex || convexWinding) { printf(",\"winding\":"); printGrid(&fill, tvg::identity(), fillBounds, true); }
    printf("}");

    // Stroke: quads per segment + joins (Stroker / WgStroker), kept in local space.
    printf(",\"stroke\":");
    if (hasStroke) {
        Buffer stroke{};
        strokeOps.clear();
        auto qualityScale = scaling(matrix);
        TraceStrokerType stroker(&stroke, strokeWidth, rs.strokeCap(), rs.strokeJoin(), rs.strokeMiterlimit(), qualityScale);
#ifdef GPU_TRACE_STROKE_PATH
        stroker.run(strokePathStrokeInput(rs, local));
#else
        stroker.run(local);
#endif
        auto strokeBounds = stroker.bounds();
        auto worldBounds = gpuTransformBounds(strokeBounds, matrix);
#ifdef TRACE_WG
        // WgShape::update: expand({strokeBounds.min, strokeBounds.max}) after the fill bbox.
        paintBox.min = tvg::min(paintBox.min, Point{(float)worldBounds.min.x, (float)worldBounds.min.y});
        paintBox.max = tvg::max(paintBox.max, Point{(float)worldBounds.max.x, (float)worldBounds.max.y});
#endif
        printf("{\"width\":%.8g,\"cap\":\"%s\",\"join\":\"%s\",\"miterlimit\":%.8g,\"qualityScale\":%.8g,\"renderWidth\":%.8g,\"color\":[%u,%u,%u,%u],",
               strokeWidth, capName(rs.strokeCap()), joinName(rs.strokeJoin()), rs.strokeMiterlimit(), qualityScale, strokeWidth * qualityScale,
               rs.stroke->color.r, rs.stroke->color.g, rs.stroke->color.b, rs.stroke->color.a);
        printBuffer(&stroke);
        printf(",\"bounds\":"); printRegion(strokeBounds);
        printf(",\"worldBounds\":"); printRegion(worldBounds);
#ifdef TRACE_WG
        auto sb = stroker.getBBox();
        printf(",\"bbox\":[%.8g,%.8g,%.8g,%.8g]", sb.min.x, sb.min.y, sb.max.x, sb.max.y);
        WgMesh strokeBox{}; strokeBox.bbox(sb.min, sb.max);
        printf(",\"bboxMesh\":{"); printBuffer(&strokeBox); printf("}");
#else
        printf(",\"cover\":[[%d,%d],[%d,%d],[%d,%d],[%d,%d],[%d,%d],[%d,%d]]", strokeBounds.min.x, strokeBounds.min.y, strokeBounds.min.x, strokeBounds.max.y, strokeBounds.max.x, strokeBounds.min.y,
               strokeBounds.max.x, strokeBounds.min.y, strokeBounds.min.x, strokeBounds.max.y, strokeBounds.max.x, strokeBounds.max.y);
#endif
        printf(",\"ops\":[");
        for (size_t i = 0; i < strokeOps.size(); ++i) {
            auto& op = strokeOps[i];
            printf("%s{\"kind\":\"%s\",\"v0\":%u,\"vc\":%u,\"t0\":%u,\"tc\":%u,\"at\":", i ? "," : "", op.kind, op.v0, op.vc, op.t0, op.tc); printPoint(op.at);
            printf(",\"to\":"); printPoint(op.to);
            printf(",\"orient\":%d}", op.orient);
        }
        printf("],\"coverage\":"); printGrid(&stroke, matrix, worldBounds, false);
        printf("}");
    } else printf("null");
#ifdef TRACE_WG
    // WgShape::bboxMesh: cover quad over fill bbox ∪ stroke world bounds (tvgWgRenderData.cpp:214).
    printf(",\"bbox\":[%.8g,%.8g,%.8g,%.8g]", paintBox.min.x, paintBox.min.y, paintBox.max.x, paintBox.max.y);
    WgMesh bboxMesh{}; bboxMesh.bbox(paintBox.min, paintBox.max);
    printf(",\"bboxMesh\":{"); printBuffer(&bboxMesh); printf("}");
#endif
#ifdef GPU_TRACE_STROKE_PATH
    printStrokePath(rs);
#endif
    printf("}%s", last ? "" : ",");
}

int main()
{
    assert(Initializer::init(0) == Result::Success);
    auto items = example::fixtures();
#ifdef TRACE_WG
    const char* backend = "wgpu";
    const float minStrokeWidth = MIN_WG_STROKE_WIDTH, minStrokeAlpha = MIN_WG_STROKE_ALPHA;
#else
    const char* backend = "gl";
    const float minStrokeWidth = MIN_GL_STROKE_WIDTH, minStrokeAlpha = MIN_GL_STROKE_ALPHA;
#endif
    printf("{\"backend\":\"%s\",\"canvas\":{\"w\":%u,\"h\":%u},\"constants\":{\"pathOptTolerance\":0.25,\"bezierTolerance\":0.5,\"arcTolerance\":0.25,\"minStrokeWidth\":%.8g,\"minStrokeAlpha\":%.8g,\"msaaSamples\":4},\"paints\":[",
           backend, example::width, example::height, minStrokeWidth, minStrokeAlpha);
    for (size_t i = 0; i < items.size(); ++i) tracePaint(items[i], i + 1 == items.size());
    printf("]");
#ifdef GPU_EXAMPLE_META
    printf(",\"meta\":%s", example::meta().c_str());
#endif
#ifdef GPU_TRACE_STROKE_PATH
    // tvgRender.cpp _get() on representative trimpath() arguments (the traced copy).
    const float trimGetCases[][2] = {{0.2f, 0.75f}, {0.75f, 0.25f}, {0.75f, 1.25f}, {0.6f, 1.2f}, {-0.25f, 0.25f}, {1.25f, 0.75f}, {1.2f, 1.6f}};
    std::vector<std::string> trimGetEvents;
    spSink = &trimGetEvents;
    for (auto& c : trimGetCases) { auto b = c[0], e = c[1]; strokeTrace::_get(b, e); }
    spSink = nullptr;
    printf(",\"trimGet\":"); printEvents(trimGetEvents);
#endif
    printf("}\n");
    for (auto& item : items) delete item.shape;
    Initializer::term();
    return 0;
}
