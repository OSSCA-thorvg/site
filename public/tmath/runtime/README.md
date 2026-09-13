# tmath WASM bundle

This directory is a portable, optimized tmath 0.1.0 browser runtime. Keep all files together when copying it into an application.

- Import `createTMath` and `tmath` from `client.js`.
- Author scenes with the JavaScript builder, or pass Lua source to `createTMath`.
- Use `object.label(options)` or Lua `object:label(config)` for an ordinary child Text that follows the Object; placement and styling stay explicit.
- Use `route(options)` or Lua `route(config)` for one marker-aware polyline; dashed shafts keep solid head/tail markers and one Create/Uncreate state.
- This build enables the Lua-only `tmath.diagram` and `tmath.chart` authoring sidecars; both lower into ordinary Scene Objects before rendering.
- Lua `grow_from_edge` and JavaScript `growFromEdge` keep a selected bounds edge fixed while revealing the perpendicular dimension.
- Serve browser applications over HTTP so the module can fetch `tmath-wasm.wasm`.
- Register `Pretendard.ttf` as `Pretendard` before rendering body text.
- Register `SourceSerif4-Semibold.ttf` as `Source Serif 4` for every semantic Text role in the VS Code host.
- Register `IBMPlexSansKR-SemiBold.ttf` as `IBM Plex Sans KR`; inherited Source Serif Text containing Korean switches to this family.
- Use `runtime.layoutReport(time, padding)` for root-pixel collision, clipping, stretch, and parent/child containment review across nested Viewports.
- UI/Input, action maps, retained Lua runtime, audio, and game loops are documented by `tmath-game`; this bundle README covers only mounting and rendering finished scenes.
- In Node, pass the contents of `tmath-wasm.wasm` as the `wasmBinary` module option.
- Preserve the included Pretendard, Source Serif 4, and IBM Plex Sans KR OFL notices when redistributing the bundle.

`BUILD-MANIFEST.json` records the exact toolchain, enabled features, file sizes, and SHA-256 checksums.
