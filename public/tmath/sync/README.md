# Sync / End

Local source baseline: ThorVG `cdc1c9596a5edebc159d5623d726febda7595896`.
The engine checkout is unmodified. This scene maps source control flow, including
both alternatives of the `disposed` branch; reveal timing is not CPU timing.

| Source | Evidence |
| --- | --- |
| `src/renderer/tvgCanvas.cpp:100` | Public `Canvas::sync()` delegates to its implementation. |
| `src/renderer/tvgCanvas.h:104–130` | `postRender()` executes within Draw; successful Sync returns the Canvas to `Synced`. Already-synced calls return early. |
| `src/renderer/cpu_engine/tvgSwRenderer.cpp:272–284` | Each registered task completes, then is deleted or unregistered. The list is cleared after the entire loop. |
| `src/renderer/cpu_engine/tvgSwRenderer.cpp:819–857` | Disposal is deferred for registered tasks; live tasks can be registered again. |
| `src/renderer/tvgTaskScheduler.h:56–64` | `done()` waits only when pending and not ready. It clears pending after completion. |
| `src/common/tvgArray.h:179–182` | `clear()` resets count, retaining the array allocation. |

The normal Update → Draw → Sync path is the opening context. Update → Sync
without Draw also executes cleanup. The scene does not imply worker shutdown,
Surface clearing, or unconditional RLE destruction.

Edit `overview.mjs`, then regenerate the delivered Lua and final-frame WebP:

```sh
node scripts/render-sync-scene.mjs
```

Five beats: call boundary, task completion, conditional release, list clear,
Canvas status. Review uses the site's CPU WASM runtime and Pretendard at 1280×760,
30 fps, with an 11.2-second one-shot timeline. The generator checks every frame
and the exact final time for text clipping, collisions and declared containment.
Beat screenshots and the audit are disposable files under `temp/`; remove that
directory before building/publishing the site.

Native verification uses the original CPU translation unit and public Canvas API.
It checks workers=0 and workers=2, Draw → Sync, unchanged straight-alpha output,
retained task/RLE identity, Update → Sync without Draw, deferred disposal, and
repeated Sync. The second worker configuration exercises the threaded path;
the checks do not claim to measure how long a worker blocks.

From the site root, against this exact local checkout:

```sh
meson setup /tmp/thorvg-sync-native-cdc1c959 thorvg \
  -Dengines=cpu -Dloaders= -Dsavers= -Dbindings= -Dextra= \
  -Dthreads=true -Dsimd=false -Ddefault_library=static -Dtests=false -Dbuildtype=debug
meson compile -C /tmp/thorvg-sync-native-cdc1c959
c++ -std=c++17 -O2 -fno-access-control -DTVG_STATIC \
  -I/tmp/thorvg-sync-native-cdc1c959 -Ithorvg/inc -Ithorvg/src/common \
  -Ithorvg/src/renderer -Ithorvg/src/renderer/cpu_engine \
  scripts/sync-native-check.cpp /tmp/thorvg-sync-native-cdc1c959/src/libthorvg-1.a \
  -lpthread -o /tmp/thorvg-sync-native-cdc1c959/check-sync
/tmp/thorvg-sync-native-cdc1c959/check-sync
```
