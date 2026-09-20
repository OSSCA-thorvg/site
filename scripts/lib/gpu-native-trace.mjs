// Shared machinery for the GPU native traces (overview + topic fixtures).
// The pinned ThorVG revision is read through `git show`/`git archive` only; the
// checkout is never modified. Builds are static GL / WG libraries of that revision.
//
// Env: THORVG_SOURCE (git checkout containing the pinned commit, default ./thorvg),
//      GPU_OVERVIEW_WORK (work dir, default <tmpdir>/thorvg-gpu-overview),
//      THORVG_GL_BUILD / THORVG_WG_BUILD / THORVG_CPU_BUILD (existing static builds of the pinned source).
// The CPU Shape-series generators use the same pinned `source` and build('cpu').
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import sharp from 'sharp';

export const root = path.resolve(import.meta.dirname, '../..');
export const checkout = path.resolve(process.env.THORVG_SOURCE || path.join(root, 'thorvg'));
export const commit = '4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad';
execFileSync('git', ['-C', checkout, 'cat-file', '-e', `${commit}^{commit}`]);
export const work = path.resolve(process.env.GPU_OVERVIEW_WORK || path.join(os.tmpdir(), 'thorvg-gpu-overview'));
export const source = path.join(work, 'source');
export const temp = path.join(work, 'trace');
fs.mkdirSync(temp, {recursive: true});

export const show = (file) => execFileSync('git', ['-C', checkout, 'show', `${commit}:${file}`], {encoding: 'utf8', maxBuffer: 1 << 26});
const run = (cmd, args, opts = {}) => execFileSync(cmd, args, {stdio: 'inherit', ...opts});

if (!fs.existsSync(path.join(source, 'meson.build'))) {
  fs.mkdirSync(source, {recursive: true});
  execFileSync('sh', ['-c', `git -C "${checkout}" archive ${commit} | tar -x -C "${source}"`]);
}

export function build(engine) {
  const preset = process.env[`THORVG_${engine.toUpperCase()}_BUILD`];
  const dir = preset ? path.resolve(preset) : path.join(work, `${engine}-build`);
  if (!fs.existsSync(path.join(dir, 'src/libthorvg-1.a'))) {
    assert.ok(!preset, `${dir} has no src/libthorvg-1.a`);
    // cpu: `-Dextra=` drops the default OpenMP option, so harnesses link without libomp (the traced RLE,
    // stroke, dash and trim code has no OpenMP loops; they only parallelise image and effect rasterizers).
    run('meson', ['setup', dir, source, `-Dengines=${engine}`, '-Dloaders=', '-Dsavers=', '-Dbindings=', '-Ddefault_library=static', '-Dtests=false', '-Dlog=false', ...(engine === 'cpu' ? ['-Dextra='] : [])]);
    run('ninja', ['-C', dir]);
  }
  return dir;
}

function edit(text, anchor, replacement, count = 1) {
  assert.equal(text.split(anchor).length - 1, count, `anchor not found exactly ${count}x: ${anchor.slice(0, 60)}`);
  return text.split(anchor).join(replacement);
}

// Instrumented tessellator copies: renamed classes so they never collide with the library symbols.
// `fixture` only matters for the opt-in GPU_TRACE_STROKE_PATH edit below; every other fixture gets the same copy.
export function instrument(engine, fixture) {
  const dir = `src/renderer/gpu_engine/${engine === 'gl' ? 'gl' : 'wg'}`;
  const cls = engine === 'gl' ? {tess: 'BWTessellator', stroker: 'Stroker', header: 'tvgGlTessellator.h', cpp: 'tvgGlTessellator.cpp', guard: '_TVG_GL_TESSELLATOR_H_'}
                              : {tess: 'WgBWTessellator', stroker: 'WgStroker', header: 'tvgWgTessellator.h', cpp: 'tvgWgTessellator.cpp', guard: '_TVG_WG_TESSELLATOR_H_'};
  const rename = (t) => t.replaceAll(cls.tess, `Trace${cls.tess}`).replaceAll(cls.stroker, `Trace${cls.stroker}`).replaceAll(cls.guard, `_TRACE_${cls.guard.slice(5)}`);
  let header = rename(show(`${dir}/${cls.header}`));
  let cpp = rename(show(`${dir}/${cls.cpp}`));
  const S = `Trace${cls.stroker}`;
  cpp = edit(cpp, `#include "${cls.header}"`, `#include "trace-${engine}-tessellator.h"`);
  if (engine === 'wgpu') cpp = edit(cpp, '#include "tvgWgCommon.h"', '#include "tvgGpuCommon.h"');
  // Convexity probe + cubic subdivision.
  cpp = edit(cpp, 'probe.addEdge(', 'traceEdge(probe, ', 3);
  cpp = edit(cpp, 'probe.addContourClose(firstPt - prevPt);', 'traceClose(probe, firstPt - prevPt);');
  cpp = edit(cpp, 'probe.nextContour();', 'traceContour(probe);');
  cpp = edit(cpp, 'if (probe.convex && gpuEdgesCross(curve.start, curve.ctrl1, curve.ctrl2, curve.end)) probe.convex = false;',
    'auto crossed = probe.convex && gpuEdgesCross(curve.start, curve.ctrl1, curve.ctrl2, curve.end);\n                if (crossed) probe.convex = false;');
  cpp = edit(cpp, 'if (stepCount <= 1) stepCount = 2;', 'if (stepCount <= 1) stepCount = 2;\n                traceCubic(curve, stepCount, crossed);');
  // Stroker operations.
  const quadAnchor = engine === 'gl' ? '_pushTriangle(mBuffer->index, ib, id, ic);' : 'mBuffer->ibuffer.push(ib);\n    mBuffer->ibuffer.push(id);\n    mBuffer->ibuffer.push(ic);';
  cpp = edit(cpp, quadAnchor, `${quadAnchor}\n    traceQuad(mBuffer, mState.prevPt, curr);`);
  cpp = edit(cpp, 'auto orient = orientation(mState.prevPt - mState.prevPtDir, mState.prevPt, mState.prevPt + dir);',
    'auto orient = orientation(mState.prevPt - mState.prevPtDir, mState.prevPt, mState.prevPt + dir);\n    traceJoin(orient, mState.prevPt);');
  for (const [signature, kind, at] of [
    [`void ${S}::round(const Point &prev, const Point& curr, const Point& center)\n{`, 'round', 'center'],
    [`void ${S}::roundPoint(const Point &p)\n{`, 'roundPoint', 'p'],
    [`void ${S}::miter(const Point& prev, const Point& curr, const Point& center)\n{`, 'miter', 'center'],
    [`void ${S}::bevel(const Point& prev, const Point& curr, const Point& center)\n{`, 'bevel', 'center'],
    [`void ${S}::square(const Point& p, const Point& outDir)\n{`, 'square', 'p'],
    [`void ${S}::squarePoint(const Point& p)\n{`, 'squarePoint', 'p'],
  ]) cpp = edit(cpp, signature, `${signature}\n    TraceScope scope(mBuffer, "${kind}", ${at});`);
  cpp = edit(cpp, 'bevel(prev, curr, center);\n        return;', 'scope.kind = "miter-limit";\n        bevel(prev, curr, center);\n        return;');
  // Opt-in (GPU_TRACE_STROKE_PATH): one `cap` op per Stroker::cap() call, before the geometry it emits.
  if (strokePathOn(fixture)) cpp = edit(cpp, `void ${S}::cap()\n{`, `void ${S}::cap()\n{\n    traceCap(mBuffer, mState.firstPt, mState.prevPt);`);
  fs.writeFileSync(path.join(temp, `trace-${engine}-tessellator.h`), header);
  fs.writeFileSync(path.join(temp, `trace-${engine}-tessellator.cpp`), cpp);
}

// Opt-in (GPU_TRACE_STROKE_PATH): instrumented copies of RenderTrimPath::trim and its helpers (tvgRender.cpp)
// and of StrokeDashPath / gpuStrokeDash (tvgGpuCommon.cpp), wrapped in `namespace strokeTrace` so they never
// collide with the library symbols. The harness runs them next to the library functions and asserts identical
// output; the hooks only append to its event log. Every anchor must match exactly once, so drift fails loudly.
export function instrumentStrokePath() {
  const section = (text, from, fnSignature) => {
    const a = text.indexOf(from), b = text.indexOf(fnSignature);
    assert.ok(a >= 0 && text.indexOf(from, a + 1) < 0 && b > a && text.indexOf(fnSignature, b + 1) < 0, `section ${from.slice(0, 40)}`);
    return text.slice(a, text.indexOf('\n}\n', b) + 3);
  };
  const render = show('src/renderer/tvgRender.cpp');
  let trim = section(render, '#define EPSILON 1e-4f', 'bool RenderTrimPath::trim(const RenderPath& in, RenderPath& out) const');
  assert.deepEqual([...trim.matchAll(/^(?:static )?\w[\w:<>&* ]* (\w[\w:]*)\(/gm)].map((m) => m[1]), ['_trimAt', '_add', '_trimPath', '_trim', '_get', 'RenderTrimPath::trim']);
  trim = edit(trim, 'bool RenderTrimPath::trim(const RenderPath& in, RenderPath& out) const\n{\n    if (in.pts.count < 2 || tvg::zero(begin - end)) return false;',
    'bool TraceTrimPath::trim(const RenderPath& in, RenderPath& out) const\n{\n    traceTrimBegin(begin, end, simultaneous, in);\n    if (in.pts.count < 2 || tvg::zero(begin - end)) return false;');
  trim = edit(trim, '    return out.pts.count >= 2;\n}', '    traceTrimEnd(out.pts.count >= 2, out);\n    return out.pts.count >= 2;\n}');
  trim = edit(trim, 'static void _get(float& begin, float& end)\n{\n    auto loop = true;', 'static void _get(float& begin, float& end)\n{\n    const auto traceBegin = begin, traceEnd = end;\n    auto loop = true;');
  trim = edit(trim, '    if ((loop && begin < end) || (!loop && begin > end)) std::swap(begin, end);\n', '    if ((loop && begin < end) || (!loop && begin > end)) std::swap(begin, end);\n    traceTrimGet(traceBegin, traceEnd, loop, begin, end);\n');
  trim = edit(trim, '    auto trimEnd = end * totalLength;\n', '    auto trimEnd = end * totalLength;\n    traceTrimContour(inCmdsCnt, inPtsCnt, *inPts, begin, end, connect, totalLength, trimStart, trimEnd);\n');
  trim = edit(trim, '    auto moveToTrimmed = *pts;\n    auto moveTo = *pts;\n    auto len = 0.0f;\n', '    auto moveToTrimmed = *pts;\n    auto moveTo = *pts;\n    auto len = 0.0f;\n    traceTrimPass(trimStart, trimEnd, connect, out);\n');
  trim = edit(trim, '        auto dLen = _length();\n', '        auto dLen = _length();\n        const char* traceBranch = "skip";\n        auto traceOut0 = out.cmds.count, tracePts0 = out.pts.count;\n');
  for (const [call, branch] of [['_trimAt(cmds, pts, moveToTrimmed, trimStart - len, trimEnd - trimStart, start, out);', 'cutBoth'],
    ['_trimAt(cmds, pts, moveToTrimmed, trimStart - len, len + dLen - trimStart, start, out);', 'cutStart'], ['_trimAt(cmds, pts, moveTo, 0.0f, trimEnd - len, start, out);', 'cutEnd']]) {
    trim = edit(trim, `                ${call}`, `                traceBranch = "${branch}";\n                ${call}`);
  }
  trim = edit(trim, '            } else if (len + dLen > trimStart + EPSILON) _add(cmds, pts, moveTo, start, out);',
    '            } else if (len + dLen > trimStart + EPSILON) {\n                traceBranch = "whole";\n                _add(cmds, pts, moveTo, start, out);\n            }');
  trim = edit(trim, '        len += dLen;\n        _shift();\n    }\n', '        traceTrimStep(*cmds, i, len, dLen, traceBranch, traceOut0, tracePts0, out);\n        len += dLen;\n        _shift();\n    }\n    traceTrimPassDone(out);\n');
  trim = edit(trim, '            Line{*(pts - 1), *pts}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n',
    '            Line{*(pts - 1), *pts}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n            traceTrimCutLine("LineTo", *(pts - 1), *pts, at1, at2, left.pt1, left.pt2, start);\n');
  trim = edit(trim, '            Bezier{*(pts - 1), *pts, *(pts + 1), *(pts + 2)}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n',
    '            Bezier{*(pts - 1), *pts, *(pts + 1), *(pts + 2)}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n            traceTrimCutCubic(Bezier{*(pts - 1), *pts, *(pts + 1), *(pts + 2)}, at1, at2, left, start);\n');
  trim = edit(trim, '            Line{*(pts - 1), moveTo}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n',
    '            Line{*(pts - 1), moveTo}.split(at1, left, tmp);\n            tmp.split(at2, left, right);\n            traceTrimCutLine("Close", *(pts - 1), moveTo, at1, at2, left.pt1, left.pt2, start);\n');

  const common = show('src/renderer/gpu_engine/tvgGpuCommon.cpp');
  const tolerance = 'constexpr auto DASH_ENDPOINT_TOLERANCE = DASH_PATTERN_THRESHOLD;\n';
  assert.equal(common.split(tolerance).length, 2, 'DASH_ENDPOINT_TOLERANCE');
  let dash = section(common, 'struct DashPatternState\n', 'bool gpuStrokeDash(const RenderShape& rs, RenderPath& out, const Matrix* transform)');
  const edits = [
    ['bool gpuStrokeDash(const RenderShape& rs, RenderPath& out, const Matrix* transform)', 'bool traceGpuStrokeDash(const RenderShape& rs, RenderPath& out, const Matrix* transform)'],
    ['        if (rs.stroke->trim.trim(rs.path, tpath)) return dash.gen(tpath, out, allowDot, transform);', '        if (traceDashTrim(rs.stroke->trim, rs.path, tpath)) return dash.gen(tpath, out, allowDot, transform);'],
    ['    auto allowDot = rs.stroke->cap != StrokeCap::Butt;\n', '    auto allowDot = rs.stroke->cap != StrokeCap::Butt;\n    traceDashCall(rs.trimpath(), allowDot);\n'],
    ['    auto initialState = dashPatternState(dash);\n', '    auto initialState = dashPatternState(dash);\n    traceDashInit(dash, initialState.idx, initialState.offset, initialState.gap, allowDot, transform);\n'],
    ['    appendDashedSubpath(out, subOut, map(start), subpathState, pieces);\n    return true;\n', '    appendDashedSubpath(out, subOut, map(start), subpathState, pieces);\n    traceDashDone(out);\n    return true;\n'],
    ['    if (state.offset < 0) state.offset += length;\n', '    if (state.offset < 0) state.offset += length;\n    traceDashNormalize(dash.offset, length, state.offset, oddPattern != 0);\n'],
    ['        state.gap = !state.gap;\n', '        state.gap = !state.gap;\n        traceDashSkip(state.idx, curPattern, state.offset, state.gap);\n'],
    ['    opGap = state.gap;\n    move = true;\n    curPos = start;\n', '    opGap = state.gap;\n    move = true;\n    curPos = start;\n    traceDashBegin(start, curIdx, curLen, opGap);\n'],
    ['    static constexpr float MIN_CURR_LEN_THRESHOLD = 0.1f;\n', '    static constexpr float MIN_CURR_LEN_THRESHOLD = 0.1f;\n    const float traceLen0 = len;\n    traceDashSegment(std::is_same<Segment, Line>::value ? "line" : "cubic", curPos, end, len, curIdx, curLen, opGap, move);\n'],
    ['    if (tvg::zero(len)) {\n        out.moveTo(map(curPos));\n', '    if (tvg::zero(len)) {\n        out.moveTo(map(curPos));\n        traceDashZeroLength(curPos);\n'],
    ['                if (allowDot && !opGap) point(out, getStartPt(seg));\n', '                if (allowDot && !opGap) point(out, getStartPt(seg));\n                traceDashZeroInterval(getStartPt(seg), curIdx, opGap, allowDot);\n'],
    ['            curPos = getStartPt(seg);\n            move = true;\n', '            curPos = getStartPt(seg);\n            move = true;\n            traceDashToggle("split", curPos, traceLen0 - len, curIdx, curLen, opGap);\n'],
    ['        if (curLen < MIN_CURR_LEN_THRESHOLD) {\n            if (++curIdx == int32_t(dash.count)) curIdx = 0;\n            curLen = dash.pattern[curIdx];\n            opGap = !opGap;\n',
     '        if (curLen < MIN_CURR_LEN_THRESHOLD) {\n            if (++curIdx == int32_t(dash.count)) curIdx = 0;\n            curLen = dash.pattern[curIdx];\n            opGap = !opGap;\n            traceDashToggle("threshold", end, traceLen0, curIdx, curLen, opGap);\n'],
    ['    curPos = end;\n}\n', '    traceDashSegmentEnd(curIdx, curLen, opGap);\n    curPos = end;\n}\n'],
    ['    state.closeEndsAtStart = (subOut.pts.count > prevPtCount) && tvg::closed(subOut.pts.last(), map(start), DASH_ENDPOINT_TOLERANCE);\n',
     '    state.closeEndsAtStart = (subOut.pts.count > prevPtCount) && tvg::closed(subOut.pts.last(), map(start), DASH_ENDPOINT_TOLERANCE);\n    traceDashClose(start, state.closeEndsAtStart, subOut.pts.count - prevPtCount);\n'],
    ['static inline void appendDashedSubpath(RenderPath& out, RenderPath& subOut, const Point& mappedStart, DashSubpathState& state, Array<PieceRange>& pieces)\n{\n',
     'static inline void appendDashedSubpath(RenderPath& out, RenderPath& subOut, const Point& mappedStart, DashSubpathState& state, Array<PieceRange>& pieces)\n{\n    traceDashFlush(subOut, state.closed, state.closeEndsAtStart, mappedStart, out);\n'],
    ['    if (!state.closed) {\n        appendDashedCommands(out, subOut);\n',
     '    if (!state.closed) {\n        {\n            Array<PieceRange> tracePieces;\n            collectDashedPieces(subOut, tracePieces);\n            for (uint32_t k = 0; k < tracePieces.count; ++k) traceDashPiece(k, tracePieces[k].cmdBegin, tracePieces[k].cmdEnd, tracePieces[k].ptBegin, tracePieces[k].ptEnd, subOut);\n        }\n        traceDashOutcome("open");\n        appendDashedCommands(out, subOut);\n'],
    ['    if (!prepareDashedPieces(subOut, state, pieces)) return;\n',
     '    if (!prepareDashedPieces(subOut, state, pieces)) {\n        traceDashOutcome("empty");\n        return;\n    }\n    for (uint32_t k = 0; k < pieces.count; ++k) traceDashPiece(k, pieces[k].cmdBegin, pieces[k].cmdEnd, pieces[k].ptBegin, pieces[k].ptEnd, subOut);\n'],
    ['    if (!appendClosedDashedSubpath(out, subOut, pieces, mappedStart, state)) {\n        appendDashedCommands(out, subOut);\n',
     '    if (!appendClosedDashedSubpath(out, subOut, pieces, mappedStart, state)) {\n        traceDashOutcome("separate");\n        appendDashedCommands(out, subOut);\n'],
    ['    return firstStartsAtClose && lastEndsAtClose;\n',
     '    traceDashWraps(firstStartsAtClose, lastEndsAtClose, subOut.pts[pieces[0].ptBegin], subOut.pts[pieces.last().ptEnd - 1], mappedStart);\n    return firstStartsAtClose && lastEndsAtClose;\n'],
    ['    if (!wrapsStart) return false;\n', '    if (!wrapsStart) {\n        traceDashReason("first or last piece does not touch the start point");\n        return false;\n    }\n'],
    ['        out.close();\n        return true;\n', '        out.close();\n        traceDashOutcome("single-closed");\n        return true;\n'],
    ['    if (!state.closeEndsAtStart) return false;\n', '    if (!state.closeEndsAtStart) {\n        traceDashReason("Close did not reach the start point");\n        return false;\n    }\n'],
    ['    // Closed dash wraps across the original start point. Emit it as one contour so the stroker can join there.\n',
     '    // Closed dash wraps across the original start point. Emit it as one contour so the stroker can join there.\n    traceDashOutcome("merged");\n'],
  ];
  for (const [anchor, replacement] of edits) dash = edit(dash, anchor, replacement);

  const out = `// Generated by scripts/lib/gpu-native-trace.mjs from ThorVG ${commit} (opt-in GPU_TRACE_STROKE_PATH).
// Instrumented copies of RenderTrimPath::trim + helpers (src/renderer/tvgRender.cpp) and StrokeDashPath /
// gpuStrokeDash (src/renderer/gpu_engine/tvgGpuCommon.cpp). Do not edit.
namespace strokeTrace {

struct TraceTrimPath : RenderTrimPath
{
    bool trim(const RenderPath& in, RenderPath& out) const;
};

#pragma push_macro("EPSILON")
#undef EPSILON
${trim}
#pragma pop_macro("EPSILON")

// gpuStrokeDash's own trim (rs.stroke->trim.trim(rs.path, tpath)) through the traced copy.
static bool traceDashTrim(const RenderTrimPath& trim, const RenderPath& in, RenderPath& out)
{
    TraceTrimPath traced;
    static_cast<RenderTrimPath&>(traced) = trim;
    return traced.trim(in, out);
}

${tolerance}
${dash}
}  // namespace strokeTrace
`;
  fs.writeFileSync(path.join(temp, 'trace-stroke-path.cpp'), out);
}

export const OVERVIEW_FIXTURE = {tag: 'overview', header: 'gpu-overview-example.h', ns: 'gpuOverviewExample'};
export const TOPIC_FIXTURE = {tag: 'topic', header: 'gpu-topic-example.h', ns: 'gpuTopicExample'};
// Optional `defines` (names or NAME=value) turn on opt-in harness switches for one fixture only; see
// scripts/gpu-overview-native.cpp. Fixtures without it compile with exactly the original arguments.
export const CLIP_FIXTURE = {tag: 'clip', header: 'gpu-clip-example.h', ns: 'gpuClipExample', defines: ['GPU_TRACE_CONVEX_WINDING', 'GPU_EXAMPLE_META']};
// GPU_TRACE_STROKE_PATH: the harness follows the backends' trim → gpuOptimize → fill and gpuStrokeDash → stroker
// order and logs instrumented copies of the trim / dash code (instrumentStrokePath below) plus Stroker::cap().
export const STROKE_PATH_FIXTURE = {tag: 'stroke-path', header: 'gpu-stroke-path-example.h', ns: 'gpuStrokePathExample', defines: ['GPU_TRACE_STROKE_PATH']};
const strokePathOn = (fixture) => (fixture?.defines ?? []).includes('GPU_TRACE_STROKE_PATH');
const fixtureDefines = (fixture) => [`-DGPU_EXAMPLE_HEADER="${fixture.header}"`, `-DGPU_EXAMPLE_NS=${fixture.ns}`, ...(fixture.defines ?? []).map((d) => `-D${d}`)];

export function compileTrace(engine, buildDir, fixture = OVERVIEW_FIXTURE) {
  instrument(engine, fixture);
  if (strokePathOn(fixture)) instrumentStrokePath();
  const binary = path.join(temp, `trace-${engine}-${fixture.tag}`);
  const includes = ['inc', 'src', 'src/common', 'src/renderer', 'src/renderer/gpu_engine', `src/renderer/gpu_engine/${engine === 'gl' ? 'gl' : 'wg'}`].map((p) => `-I${path.join(source, p)}`);
  const args = ['-std=c++17', '-O2', '-DTVG_STATIC', ...fixtureDefines(fixture), `-I${buildDir}`, `-I${temp}`, `-I${path.join(root, 'scripts')}`, ...includes];
  if (engine === 'wgpu') args.push('-DTRACE_WG', '-I/opt/homebrew/include');
  args.push(path.join(root, 'scripts/gpu-overview-native.cpp'), path.join(buildDir, 'src/libthorvg-1.a'));
  if (engine === 'gl') args.push('-framework', 'OpenGL');
  else args.push('-L/opt/homebrew/lib', '-lwgpu_native', '-Wl,-rpath,/opt/homebrew/lib', '-framework', 'Metal', '-framework', 'QuartzCore', '-framework', 'CoreFoundation');
  args.push('-o', binary);
  run('c++', args);
  return JSON.parse(execFileSync(binary, {encoding: 'utf8', maxBuffer: 1 << 26}));
}

export function compileCapture(engine, buildDir, fixture = OVERVIEW_FIXTURE) {
  const binary = path.join(temp, `capture-${engine}-${fixture.tag}`);
  const src = path.join(root, `scripts/${engine}-overview-capture.cpp`);
  if (!fs.existsSync(src)) return null;
  const args = ['-std=c++17', '-O2', '-DTVG_STATIC', ...fixtureDefines(fixture), `-I${path.join(source, 'inc')}`, `-I${path.join(root, 'scripts')}`, src, path.join(buildDir, 'src/libthorvg-1.a')];
  if (engine === 'gl') args.push('-framework', 'OpenGL');
  else if (engine === 'wgpu') args.push('-I/opt/homebrew/include', '-L/opt/homebrew/lib', '-lwgpu_native', '-Wl,-rpath,/opt/homebrew/lib', '-framework', 'Metal', '-framework', 'QuartzCore', '-framework', 'CoreFoundation', '-framework', 'Foundation');
  // engine 'cpu' (scripts/cpu-overview-capture.cpp): SwCanvas into host memory, no graphics API.
  args.push('-o', binary);
  run('c++', args);
  const raw = path.join(temp, `capture-${engine}-${fixture.tag}.rgba`);
  const info = JSON.parse(execFileSync(binary, [raw], {encoding: 'utf8'}));
  const pixels = fs.readFileSync(raw);
  assert.equal(pixels.length, info.width * info.height * 4);
  return {info, pixels};
}

export function windowPixels(capture, window) {
  const {info, pixels} = capture;
  const out = [];
  for (let y = 0; y < window.h; ++y) for (let x = 0; x < window.w; ++x) {
    const i = ((window.y + y) * info.width + window.x + x) * 4;
    out.push([pixels[i], pixels[i + 1], pixels[i + 2], pixels[i + 3]]);
  }
  return out;
}
export function probe(capture, x, y) { const i = (y * capture.info.width + x) * 4; return [...capture.pixels.subarray(i, i + 4)]; }

export async function writePng(capture, file) {
  await sharp(capture.pixels, {raw: {width: capture.info.width, height: capture.info.height, channels: 4}}).png().toFile(file);
}

export function writeTrace(file, result, generator) {
  fs.writeFileSync(file, `// Generated by ${generator} at ThorVG ${commit}. Do not edit.\nexport default ${JSON.stringify(result)};\n`);
}

// The two backends run the same gpuOptimize, fan and stroker code; make that claim checkable.
export function assertBackendsAgree(gl, wgpu) {
  assert.deepEqual(gl.paints.map((p) => p.name), wgpu.paints.map((p) => p.name));
  assert.deepEqual(gl.paints.map((p) => p.fill.triangles), wgpu.paints.map((p) => p.fill.triangles));
  assert.deepEqual(gl.paints.map((p) => p.fill.vertices), wgpu.paints.map((p) => p.fill.vertices));
  assert.deepEqual(gl.paints.map((p) => p.stroke?.vertices ?? null), wgpu.paints.map((p) => p.stroke?.vertices ?? null));
}
