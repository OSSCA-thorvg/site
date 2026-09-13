# Effect Details 장면

CPU 소스 기준: ThorVG `b4471844c3c2f849ce82e0825798e2696a4a2cad`.
`07-7-SW-Renderer-Postprocessing.mdx`의 3절에서 사용하는 960×800, 30fps, 비반복 장면입니다.

Raster 글과 같은 typed builder로 장면을 작성한 뒤 **독립 실행 가능한 Lua**를 생성합니다.
`.lua`를 직접 수정하지 않고 다음 작성 파일과 원본 실행 데이터를 수정합니다.

| 장면 | 작성 파일 | 입력과 핵심 모션 |
| --- | --- | --- |
| `blur.lua` | `../effect-blur.mjs` | A·B Offscreen → H×3 → 8×8 전치 → V×3 → 역전치. 두 물리 버퍼의 역할과 처리 영역을 유지합니다. |
| `tint.lua` | `../effect-colors.mjs` | Blur 출력의 화소 → 정수 luma → 두 색 보간 → intensity → alpha → 같은 주소에 기록합니다. |
| `tritone.lua` | `../effect-colors.mjs` | luma 분기 → 두 색 기여 → 원본 혼합 → alpha → 기록. 밝은 A를 사용한 별도 입력으로 상위 분기를 확대합니다. |
| `fill.lua` | `../effect-colors.mjs` | Blur 출력의 alpha → effect opacity → Fill RGB의 premultiply → 제자리 기록입니다. |
| `shadow.lua` | `../effect-shadow.mjs` | 본체 보존 → alpha H/V 필터 → 정수 offset → Canvas에 그림자 합성 → 본체 source-over입니다. |

각 builder의 `beats`에 핵심 장면과 검토 시점을 기록합니다. 대표 화소는 천천히 보여주고,
반복 화소는 순서를 유지하며 가속합니다. 재생 시간과 행 순서는 CPU 처리 시간이나
OpenMP 작업 스케줄을 표현하지 않습니다. Blur의 커널 외곽선은 결과의 의존 영역이며,
데이터 모델은 초기 누적 후 entering/leaving으로 갱신하는 실제 accumulator를 재현합니다.

기본 입력은 기존 글의 24×24 A·B와 그룹 opacity 128입니다. Tint/Tritone은
`GaussianBlur → 색상 효과` 체인이고, Fill은 기존 `GaussianBlur → Fill`과 같습니다.
DropShadow는 **단일 효과의 direct 경로**를 사용합니다. 효과마다 서로 다른 합성 분기를
동일하게 취급하지 않습니다. Tritone의 밝은 입력 확대는 원본 입력을 변경하지 않는 별도 예입니다.

## 생성과 검증

사이트 루트에서 실행합니다.

```sh
node scripts/render-effect-details.mjs
node scripts/effect-colors-render-verify.mjs
node --test tests/effect-details.test.mjs tests/effect-colors.test.mjs tests/effect-shadow-model.test.mjs
npm run check
npm test
```

개별 생성은 `node scripts/render-effect-details.mjs blur`처럼 장면 이름을 넘깁니다.
생성기는 Lua로 다시 로드한 장면의 모든 프레임과 정확한 마지막 시간을 검사합니다.
검토 PNG와 감사 보고서는 `details/temp/`, 포스터는 `../posters/`에 기록합니다.
포스터에는 검토한 마지막 프레임의 동일한 RGBA 버퍼를 사용합니다.
Lua 지역 변수 한도 때문에 객체 핸들은 `refs` 테이블로 출력합니다.
현재 배포 runtime의 `play()` lag는 duration에 대한 비율입니다.

Blur의 전체 8단계는 `../native-trace.mjs`의 실제 중간 버퍼와 바이트 단위로 비교합니다.
색상 효과와 그림자는 별도의 네이티브 하네스가 공개 `Canvas::draw()` 결과와 비교합니다.
네이티브 생성 파일과 색상·각도·위치를 바꾼 입력도 테스트 대상입니다.

## 네이티브 자료 재생성

수정하지 않은 해당 커밋의 ThorVG와 CPU 정적 빌드가 필요합니다.
예시 빌드 옵션은 `engines=cpu`, loaders/savers/tools/extra 없음,
`tests=false`, `default_library=static`, `buildtype=debugoptimized`입니다.

```sh
TVG_EFFECT_SOURCE=/absolute/path/to/thorvg
TVG_EFFECT_BUILD=/absolute/path/to/cpu-static-build
c++ -std=c++14 -O2 -fno-access-control -DTVG_STATIC \
  -I"$TVG_EFFECT_BUILD" -I"$TVG_EFFECT_SOURCE/inc" \
  -I"$TVG_EFFECT_SOURCE/src/renderer" \
  -I"$TVG_EFFECT_SOURCE/src/renderer/cpu_engine" \
  -I"$TVG_EFFECT_SOURCE/src/common" \
  scripts/effect-shadow-native-trace.cpp \
  "$TVG_EFFECT_BUILD/src/libthorvg-1.a" -lpthread \
  -o /tmp/effect-shadow-native-trace
node scripts/effect-shadow-generate-trace.mjs /tmp/effect-shadow-native-trace
```

색상 효과는 같은 컴파일 명령의 입력을 `scripts/effect-colors-native.cpp`, 출력을
`/tmp/effect-colors-native`로 바꾸고
`node scripts/effect-colors-verify.mjs /tmp/effect-colors-native`를 실행합니다.
기존 Blur 자료는 `scripts/postprocessing-native-trace.cpp`와
`scripts/generate-postprocessing-trace.mjs`가 생성합니다.
