// Topic fixture for the GPU Engine Shape / Stroke / Fill-Rule articles (GL + WebGPU).
// One canvas, six paints: three two-contour rings that differ only in fill rule or
// contour direction, and three open strokes that exercise round caps and joins,
// the miter limit, square caps, cubic subdivision and the quality scale.
// Public ThorVG API only; the ThorVG checkout is never modified.
#ifndef GPU_TOPIC_EXAMPLE_H
#define GPU_TOPIC_EXAMPLE_H

#include "thorvg.h"
#include "gpu-example-fixture.h"

namespace gpuTopicExample {

constexpr uint32_t width = 640;
constexpr uint32_t height = 420;

// Fill rule: outer r 80 and inner r 40 circles in one Shape (MoveTo + 4 CubicTo + Close each).
constexpr float ringOuter = 80.0f;
constexpr float ringInner = 40.0f;
constexpr float ringY = 110.0f;
constexpr float ringX[3] = {110.0f, 320.0f, 530.0f};

inline tvg::Shape* ring(float cx, bool innerClockwise)
{
    auto shape = tvg::Shape::gen();
    shape->appendCircle(cx, ringY, ringOuter, ringOuter);
    shape->appendCircle(cx, ringY, ringInner, ringInner, innerClockwise);
    shape->fill(36, 108, 170);
    return shape;
}

inline tvg::Shape* ringNonZero() { return ring(ringX[0], true); }

inline tvg::Shape* ringEvenOdd()
{
    auto shape = ring(ringX[1], true);
    shape->fillRule(tvg::FillRule::EvenOdd);
    return shape;
}

inline tvg::Shape* ringReversed() { return ring(ringX[2], false); }

// Stroke: an open polyline with one cubic, in local coordinates (x 0..140, y -30..50).
inline void wave(tvg::Shape* shape)
{
    shape->moveTo(0, 50);
    shape->lineTo(40, 0);
    shape->cubicTo(60, -30, 90, -30, 110, 20);
    shape->lineTo(140, 50);
}

constexpr float strokeRoundX = 30.0f, strokeRoundY = 300.0f;
constexpr float strokeSharpX = 210.0f, strokeSharpY = 250.0f;
constexpr float strokeScaledX = 400.0f, strokeScaledY = 300.0f, strokeScale = 1.6f;

inline tvg::Shape* strokeRound()
{
    auto shape = tvg::Shape::gen();
    wave(shape);
    shape->strokeWidth(20);
    shape->strokeFill(200, 90, 40);
    shape->strokeCap(tvg::StrokeCap::Round);
    shape->strokeJoin(tvg::StrokeJoin::Round);
    shape->translate(strokeRoundX, strokeRoundY);
    return shape;
}

// Three joins: 26.6° (miter limit 4 exceeded → bevel), 32° (miter kept), 52.6° (miter).
inline tvg::Shape* strokeSharp()
{
    auto shape = tvg::Shape::gen();
    shape->moveTo(0, 90);
    shape->lineTo(50, -10);
    shape->lineTo(50, 90);
    shape->lineTo(100, 10);
    shape->lineTo(130, 90);
    shape->strokeWidth(18);
    shape->strokeFill(60, 120, 80);
    shape->strokeCap(tvg::StrokeCap::Square);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->translate(strokeSharpX, strokeSharpY);
    return shape;
}

// Same path and width as strokeRound under scale(1.6): local mesh, larger quality scale.
inline tvg::Shape* strokeScaled()
{
    auto shape = tvg::Shape::gen();
    wave(shape);
    shape->strokeWidth(20);
    shape->strokeFill(120, 80, 180);
    shape->strokeCap(tvg::StrokeCap::Round);
    shape->strokeJoin(tvg::StrokeJoin::Round);
    shape->scale(strokeScale);
    shape->translate(strokeScaledX, strokeScaledY);
    return shape;
}

inline void build(tvg::Canvas* canvas)
{
    canvas->add(ringNonZero());
    canvas->add(ringEvenOdd());
    canvas->add(ringReversed());
    canvas->add(strokeRound());
    canvas->add(strokeSharp());
    canvas->add(strokeScaled());
}

inline std::vector<GpuExampleFixture> fixtures()
{
    return {{"ringNonZero", "appendCircle(110, 110, 80, 80); appendCircle(110, 110, 40, 40); NonZero", ringNonZero()},
            {"ringEvenOdd", "appendCircle(320, 110, 80, 80); appendCircle(320, 110, 40, 40); fillRule(EvenOdd)", ringEvenOdd()},
            {"ringReversed", "appendCircle(530, 110, 80, 80); appendCircle(530, 110, 40, 40, false); NonZero", ringReversed()},
            {"strokeRound", "moveTo/lineTo/cubicTo/lineTo, strokeWidth(20), Round cap + join, translate(30, 300)", strokeRound()},
            {"strokeSharp", "moveTo/lineTo x4, strokeWidth(18), Square cap, Miter join (limit 4), translate(210, 250)", strokeSharp()},
            {"strokeScaled", "same path as strokeRound, scale(1.6), translate(400, 300)", strokeScaled()}};
}

}  // namespace gpuTopicExample

#endif
