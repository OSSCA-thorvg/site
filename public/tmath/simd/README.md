# SIMD DownScale case study

PR: https://github.com/thorvg/thorvg/pull/4797
Pinned head: `1b96000210eda02e12f2a59fac140e08d449f2bb` (read September 13, 2026).
Source functions: `cInterpDownScaler` in `tvgSwRasterC.h`,
`neonInterpDownScaler` in `tvgSwRasterNeon.h`; dispatch, sample size and coordinate
mapping in `tvgSwRaster.cpp`. ThorVG's MIT license is in
`../runtime/LICENSE-ThorVG.txt`.

- `downscale.lua`: a complete 72×48 house image becomes a 12×8 image at scale 1/6.
  All nine samples for one interior output pixel move together into a 3×3 group,
  Only after extraction settles, the first arrow, Sum / 9, the second arrow
  and the resulting color appear in sequence. Grouped motion summarizes sample
  collection; the scalar implementation still reads samples in a loop.
  Sample positions and results share the records in `model.mjs`.
- `neon.lua`: a persistent Before | After view follows all nine samples.
  Scalar `size_t c[4]` stays on the left; NEON `uint16x8_t sum` stays on the
  right. Both show accumulated values, followed by NEON lane restoration into
  `uint32_t c[4]`, integer averaging and identical packed results: `0xFFE67139`.
  Sample inputs and both accumulator views replace their numbers instantly,
  every 0.22 seconds, without crossfades or travelling packets during accumulation.
  After accumulation, lane selection, channel restoration, averaging and output
  retain their staged animated reveals.

Motion timing illustrates operations, not measured CPU time. One packed pixel is
loaded per sample; vector lanes carry its channels and a duplicate, not eight
independent pixels. The article reports the PR's FPS measurements separately.
The scene's color swatches interpret C1/C2/C3 as R/G/B; they are input data.

## Authoring and checks

Edit `scenes.mjs` and `model.mjs`, then regenerate Lua and final-frame posters:

```sh
node scripts/render-simd-scenes.mjs
node scripts/verify-simd-downscale.mjs ../../thorvg
npm run check
npm test
```

The renderer uses the delivered CPU WASM and Pretendard. It audits all 30fps
frames and the exact final time for text visibility, ownership, canvas bounds and
spacing. Beat rasters and audit reports go to the OS temporary directory under
`thorvg-simd-review` (`TMATH_SIMD_REVIEW_DIR` overrides it).

The native check needs Arm64, a C++ compiler, and a read-only ThorVG checkout
containing the pinned commit. It extracts the original scalar and NEON functions
with `git show`, compiles them in an OS temporary directory, and compares 101
cases with the model. Cases cover the 96 destination pixels, boundary clipping,
a different kernel, padded stride, asymmetric alpha/channel values, and the
maximum 16-sample sum of 4080. It also checks all eight NEON accumulator lanes.
No engine source or worktree is modified.
