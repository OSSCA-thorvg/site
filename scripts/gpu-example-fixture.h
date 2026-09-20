// Fixture record shared by the GPU example headers and the native trace harness.
// Public ThorVG API only; the ThorVG checkout is never modified.
#ifndef GPU_EXAMPLE_FIXTURE_H
#define GPU_EXAMPLE_FIXTURE_H

#include <vector>
#include "thorvg.h"

struct GpuExampleFixture { const char* name; const char* api; tvg::Shape* shape; };

#endif
