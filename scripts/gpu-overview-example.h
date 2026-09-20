// Shared example scene for the GPU Engine overview articles (GL + WebGPU).
// Keep in sync with src/content/blog/Mentoring/GPUEngine/Overview.mdx.
// The ThorVG checkout is never modified; this header only uses the public API.
#ifndef GPU_OVERVIEW_EXAMPLE_H
#define GPU_OVERVIEW_EXAMPLE_H

#include "thorvg.h"
#include "gpu-example-fixture.h"

namespace gpuOverviewExample {

constexpr uint32_t width = 400;
constexpr uint32_t height = 208;

// 10-vertex concave star in local coordinates. The paint transform moves it to (330, 104).
constexpr float starPoints[10][2] = {{0, -60}, {15, -21}, {57, -19}, {25, 8}, {35, 49}, {0, 26}, {-35, 49}, {-25, 8}, {-57, -19}, {-15, -21}};
constexpr float starX = 330.0f;
constexpr float starY = 104.0f;
constexpr float starStrokeWidth = 6.0f;

inline tvg::Shape* back()
{
    auto shape = tvg::Shape::gen();
    shape->appendRect(24, 24, 160, 112, 12, 12);
    shape->fill(50, 110, 220);
    return shape;
}

inline tvg::Shape* front()
{
    auto shape = tvg::Shape::gen();
    shape->appendRect(104, 72, 160, 112, 12, 12);
    shape->fill(240, 140, 60, 192);
    return shape;
}

inline tvg::Shape* star()
{
    auto shape = tvg::Shape::gen();
    shape->moveTo(starPoints[0][0], starPoints[0][1]);
    for (auto i = 1; i < 10; ++i) shape->lineTo(starPoints[i][0], starPoints[i][1]);
    shape->close();
    shape->fill(40, 160, 110);
    shape->strokeFill(30, 50, 70);
    shape->strokeWidth(starStrokeWidth);
    shape->strokeJoin(tvg::StrokeJoin::Miter);
    shape->strokeCap(tvg::StrokeCap::Butt);
    shape->translate(starX, starY);
    return shape;
}

inline void build(tvg::Canvas* canvas)
{
    canvas->add(back());
    canvas->add(front());
    canvas->add(star());
}

// Same paints, in canvas order, for the trace harness.
inline std::vector<GpuExampleFixture> fixtures()
{
    return {{"back", "appendRect(24, 24, 160, 112, 12, 12)", back()},
            {"front", "appendRect(104, 72, 160, 112, 12, 12)", front()},
            {"star", "moveTo/lineTo x10, close, strokeWidth(6), Miter, translate(330, 104)", star()}};
}

}  // namespace gpuOverviewExample

#endif
