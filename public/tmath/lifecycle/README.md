# Canvas state machine

`overview.mjs` visualizes the shared Canvas API status, with representative graph
edges and a full state-gate table for valid arguments and successful backend calls.
Black means current Canvas status; blue marks the selected transition. A rejected
update() remains in Drawing. No travelling token represents renderer work, and
timeline durations do not claim execution time or worker progress.

Source: local ThorVG `cdc1c9596a5edebc159d5623d726febda7595896`,
`src/renderer/tvgCanvas.h:28–150` and `tvgCanvas.cpp:121–241`. These files are
unchanged from the Overview's cited `6cf10d47fbe13b45040f2c56feeafa0711f53b2b`.

| Claim | Evidence |
| --- | --- |
| Initial Synced; five named statuses | Canvas::Impl status declaration |
| add/remove set Painting after their Canvas guards | Canvas::Impl::add/remove |
| target sets Damaged; Updating/Drawing rejected | SwCanvas/GlCanvas/WgCanvas::target |
| changed viewport sets Damaged from Synced/Damaged | Canvas::Impl::viewport |
| update sets Updating, rejects Drawing; Updating is a no-op | Canvas::Impl::update |
| draw may run update first, then sets Drawing after rendering | Canvas::Impl::draw |
| sync succeeds into Synced; already Synced is a no-op | Canvas::Impl::sync |

`scripts/canvas-state-native-trace.cpp` exercises all 5 × 7 public API/state
combinations through a native CPU Canvas. Each starting state is reached using
real API calls; the script never assigns status. It also verifies unchanged
viewport and the illustrated target → add → draw → rejected update → sync trace.
GPU rendering itself is not exercised; the diagram's status rules are common
Canvas code, and all three target implementations were checked statically.

`native-trace.mjs` contains the native snapshots. `model.mjs` independently checks
all 35 outcomes against the source gates and derives the table and playback from
the trace. The intermediate Updating state inside draw is a source-derived step
between native before/after snapshots, not a separately sampled native event.
An alternate Damaged → update → draw → sync sequence is also checked during review.

The graph emphasizes the pictured sequence; other allowed sources, no-ops and
viewport conditions are retained in the table/footnotes. Backend failure paths
and invalid argument/ownership errors are outside this successful-input view.
In particular, add/remove assign Painting before returning the Scene operation's
result; the scene does not claim all failures preserve the previous state.

Seven beats: initial Synced, target/Damaged, add/Painting, draw's internal
update/Updating, draw/Drawing, rejected update, sync/Synced. Fixed Y-up camera,
1280×1150, Pretendard, 30 fps, one-shot. Rectangle owners have 12px text insets;
every frame is checked for text clipping/gaps and the final poster keeps the graph.

```sh
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I/tmp/thorvg-font-native-cdc1c959 -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer scripts/canvas-state-native-trace.cpp \
  /tmp/thorvg-font-native-cdc1c959/src/libthorvg-1.a -lpthread \
  -o /tmp/thorvg-font-native-cdc1c959/canvas-state-trace
/tmp/thorvg-font-native-cdc1c959/canvas-state-trace
node scripts/render-canvas-lifecycle.mjs --still
node scripts/render-canvas-lifecycle.mjs
```

Store the native JSON as the default export in `native-trace.mjs`. Move disposable
`temp/` review images outside public before building or browser playback, so they
are neither published nor able to trigger dev-server reloads.
