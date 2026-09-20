// Stroke-path fixture for the GPU Engine Dash and Trim articles (GL + WebGPU).
// One 800 × 480 canvas, nine stroked paints side by side. Every paint has an identity
// transform except `trimDash`, which is scaled so the dash space (local) is visible.
//
//  row 1  dashGapStart        small closed rectangle whose dash phase starts in a gap → no seam merge
//         trimOpen            open polyline with a diagonal, trimpath(0.2, 0.75)
//         dashWave            line + cubic, odd pattern {0, 14, 22} with offset -10, Round cap (zero-length dots)
//  row 2  trimSimultaneous    two closed rectangles in one Shape, trimpath(0.75, 1.25, true)  (wraps per contour)
//         trimWhole           the same geometry, trimpath(0.75, 1.25, false)                  (wraps the whole path)
//         trimDash            circle, trimpath(0.6, 1.2) + strokeDash {10, 10}, scale(1.5)
//  row 3  dashRound           closed rounded rectangle, the dash that crosses the start point is welded (seam merge)
//         dashCorner          closed sharp rectangle, start at a corner, seam merge → miter at the start corner
//         dashCornerUnclosed  the same corners drawn with moveTo/lineTo and no close() → two butt caps, notch
//
// trimpath(0.75, 1.25) is used instead of trimpath(0.75, 0.25): at this revision an in-range begin > end
// is swapped (tvgRender.cpp _get), so a wrap across the start point needs an end past 1.
// Public ThorVG API only; the ThorVG checkout is never modified.
#ifndef GPU_STROKE_PATH_EXAMPLE_H
#define GPU_STROKE_PATH_EXAMPLE_H

#include "thorvg.h"
#include "gpu-example-fixture.h"

namespace gpuStrokePathExample {

constexpr uint32_t width = 800;
constexpr uint32_t height = 480;

// Trim A: the lesson polyline (0,70) (150,70) (250,0) (420,0) moved by (40, 40).
constexpr float trimOpenPoints[4][2] = {{40, 110}, {190, 110}, {290, 40}, {460, 40}};
constexpr float trimOpenBegin = 0.2f, trimOpenEnd = 0.75f;

// Trim B: two rectangles per Shape (appendRect starts at the top-right corner, clockwise).
constexpr float trimRects[2][4] = {{40, 200, 100, 100}, {170, 220, 110, 60}};
constexpr float trimWholeShift = 300.0f;
constexpr float trimWrapBegin = 0.75f, trimWrapEnd = 1.25f;

// Dash A: a line then a cubic, odd pattern with a zero on-length.
constexpr float dashWavePattern[3] = {0, 14, 22};
constexpr float dashWaveOffset = -10.0f;

// Dash B: rounded rectangle whose measured length (572.02) is ~11 × 52, so the dash across the start
// point is split 15 + 21 by offset 21; then a sharp 180 × 90 rectangle (perimeter 540 = 9 × 60) twice,
// and a 78 × 40 rectangle (perimeter 236) whose phase starts inside a gap (offset 50).
constexpr float dashRoundRect[6] = {40, 350, 210, 100, 28, 28};
constexpr float dashRoundPattern[2] = {36, 16};
constexpr float dashRoundOffset = 21.0f;
constexpr float dashCornerRect[4] = {300, 360, 180, 90};
constexpr float dashCornerUnclosedX = 540.0f;
constexpr float dashCornerPattern[2] = {40, 20};
constexpr float dashCornerOffset = 20.0f;
constexpr float dashGapStartRect[4] = {30, 20, 78, 40};
constexpr float dashGapStartOffset = 50.0f;

// Trim + dash: circle r 40 at the local origin, scale(1.5), translate(680, 250).
constexpr float trimDashRadius = 40.0f, trimDashScale = 1.5f, trimDashX = 680.0f, trimDashY = 250.0f;
constexpr float trimDashBegin = 0.6f, trimDashEnd = 1.2f;
constexpr float trimDashPattern[2] = {10, 10};

inline tvg::Shape* trimOpen()
{
    auto shape = tvg::Shape::gen();
    shape->moveTo(trimOpenPoints[0][0], trimOpenPoints[0][1]);
    for (auto i = 1; i < 4; ++i) shape->lineTo(trimOpenPoints[i][0], trimOpenPoints[i][1]);
    shape->strokeWidth(14);
    shape->strokeFill(214, 96, 58);
    shape->strokeCap(tvg::StrokeCap::Butt);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->trimpath(trimOpenBegin, trimOpenEnd);
    return shape;
}

inline tvg::Shape* trimRectPair(float dx, bool simultaneous)
{
    auto shape = tvg::Shape::gen();
    for (auto& r : trimRects) shape->appendRect(r[0] + dx, r[1], r[2], r[3]);
    shape->fill(246, 224, 170);
    shape->strokeWidth(12);
    shape->strokeFill(40, 110, 170);
    shape->strokeCap(tvg::StrokeCap::Butt);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->trimpath(trimWrapBegin, trimWrapEnd, simultaneous);
    return shape;
}

inline tvg::Shape* trimSimultaneous() { return trimRectPair(0.0f, true); }
inline tvg::Shape* trimWhole() { return trimRectPair(trimWholeShift, false); }

inline tvg::Shape* dashWave()
{
    auto shape = tvg::Shape::gen();
    shape->moveTo(490, 140);
    shape->lineTo(556, 140);
    shape->cubicTo(590, 20, 690, 20, 760, 120);
    shape->strokeWidth(10);
    shape->strokeFill(120, 70, 170);
    shape->strokeCap(tvg::StrokeCap::Round);
    shape->strokeJoin(tvg::StrokeJoin::Round);
    shape->strokeDash(dashWavePattern, 3, dashWaveOffset);
    return shape;
}

inline tvg::Shape* dashRound()
{
    auto shape = tvg::Shape::gen();
    auto& r = dashRoundRect;
    shape->appendRect(r[0], r[1], r[2], r[3], r[4], r[5]);
    shape->strokeWidth(10);
    shape->strokeFill(30, 140, 110);
    shape->strokeCap(tvg::StrokeCap::Butt);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->strokeDash(dashRoundPattern, 2, dashRoundOffset);
    return shape;
}

inline void dashCornerStroke(tvg::Shape* shape, float offset = dashCornerOffset)
{
    shape->strokeWidth(12);
    shape->strokeFill(200, 60, 110);
    shape->strokeCap(tvg::StrokeCap::Butt);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->strokeDash(dashCornerPattern, 2, offset);
}

inline tvg::Shape* dashCorner()
{
    auto shape = tvg::Shape::gen();
    auto& r = dashCornerRect;
    shape->appendRect(r[0], r[1], r[2], r[3]);
    dashCornerStroke(shape);
    return shape;
}

// The same four corners as appendRect() emits them (top-right first, clockwise), back to the start, no close().
inline tvg::Shape* dashCornerUnclosed()
{
    auto shape = tvg::Shape::gen();
    auto x = dashCornerUnclosedX, y = dashCornerRect[1], w = dashCornerRect[2], h = dashCornerRect[3];
    shape->moveTo(x + w, y);
    shape->lineTo(x + w, y + h);
    shape->lineTo(x, y + h);
    shape->lineTo(x, y);
    shape->lineTo(x + w, y);
    dashCornerStroke(shape);
    return shape;
}

// Closed, but the dash phase starts inside a gap: the first piece does not start at the start point.
inline tvg::Shape* dashGapStart()
{
    auto shape = tvg::Shape::gen();
    auto& r = dashGapStartRect;
    shape->appendRect(r[0], r[1], r[2], r[3]);
    dashCornerStroke(shape, dashGapStartOffset);
    return shape;
}

inline tvg::Shape* trimDash()
{
    auto shape = tvg::Shape::gen();
    shape->appendCircle(0, 0, trimDashRadius, trimDashRadius);
    shape->strokeWidth(6);
    shape->strokeFill(180, 120, 30);
    shape->strokeCap(tvg::StrokeCap::Square);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->trimpath(trimDashBegin, trimDashEnd);
    shape->strokeDash(trimDashPattern, 2);
    shape->scale(trimDashScale);
    shape->translate(trimDashX, trimDashY);
    return shape;
}

inline void build(tvg::Canvas* canvas)
{
    canvas->add(trimOpen());
    canvas->add(dashWave());
    canvas->add(trimSimultaneous());
    canvas->add(trimWhole());
    canvas->add(trimDash());
    canvas->add(dashRound());
    canvas->add(dashCorner());
    canvas->add(dashCornerUnclosed());
    canvas->add(dashGapStart());
}

// Same paints, in canvas order, for the trace harness.
inline std::vector<GpuExampleFixture> fixtures()
{
    return {{"trimOpen", "moveTo(40, 110); lineTo(190, 110); lineTo(290, 40); lineTo(460, 40); strokeWidth(14); Butt; Miter; trimpath(0.2, 0.75)", trimOpen()},
            {"dashWave", "moveTo(490, 140); lineTo(556, 140); cubicTo(590, 20, 690, 20, 760, 120); strokeWidth(10); Round cap + join; strokeDash({0, 14, 22}, 3, -10)", dashWave()},
            {"trimSimultaneous", "appendRect(40, 200, 100, 100); appendRect(170, 220, 110, 60); fill(246, 224, 170); strokeWidth(12); Butt; Miter; trimpath(0.75, 1.25, true)", trimSimultaneous()},
            {"trimWhole", "appendRect(340, 200, 100, 100); appendRect(470, 220, 110, 60); fill(246, 224, 170); strokeWidth(12); Butt; Miter; trimpath(0.75, 1.25, false)", trimWhole()},
            {"trimDash", "appendCircle(0, 0, 40, 40); strokeWidth(6); Square; Miter; trimpath(0.6, 1.2); strokeDash({10, 10}, 2); scale(1.5); translate(680, 250)", trimDash()},
            {"dashRound", "appendRect(40, 350, 210, 100, 28, 28); strokeWidth(10); Butt; Miter; strokeDash({36, 16}, 2, 21)", dashRound()},
            {"dashCorner", "appendRect(300, 360, 180, 90); strokeWidth(12); Butt; Miter; strokeDash({40, 20}, 2, 20)", dashCorner()},
            {"dashCornerUnclosed", "moveTo(720, 360); lineTo(720, 450); lineTo(540, 450); lineTo(540, 360); lineTo(720, 360); no close(); strokeWidth(12); Butt; Miter; strokeDash({40, 20}, 2, 20)", dashCornerUnclosed()},
            {"dashGapStart", "appendRect(30, 20, 78, 40); strokeWidth(12); Butt; Miter; strokeDash({40, 20}, 2, 50)", dashGapStart()}};
}

}  // namespace gpuStrokePathExample

#endif
