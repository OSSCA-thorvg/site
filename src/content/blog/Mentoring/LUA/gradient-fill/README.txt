현재 이 폴더의 영상은 본문에 연결하지 않음. RLE 섹션도 interactive만 유지.
01-color-table은 기존 .vscode/components/GradientColorTable.astro 기반 실습으로 교체됨.
Conic·Basic Math는 ../conic-series의 원본 기반 영상으로 교체됨.
아래 기록은 최초 보충 장면 제작 및 Linear/Radial 교체 당시의 검증 기록.

# Gradient fill 블로그 시각 자료

대상: `../../07-6-CPU-Engine-FILL.mdx`.
ThorVG `8c94c1f05693024ee38a721779f54b18941cfcf4`의 32비트 normal fill을 설명한다.
최초 Conic 구현과의 비교는 `2d23fe19b7dd28eff4537c20d2f78691ffd179f2` 기준이다.

Linear·Radial 절은 현재 `LinearGradientLab.astro`, `RadialGradientLab.astro`의
인터랙티브 실습을 사용한다. 02/03 Lua와 영상은 원본 자료로 보관하며, 본문에는
나머지 영상 6편과 실습 4개를 배치한다. 아래 8편 재생 검증은 교체 전 기록이다.

## 디자인과 전달 형태

기존 블로그의 `font-shape-rle.lua`와 SW Overview 시리즈에 맞춘 `pro_white`,
Pretendard, 960×540, 30fps, 고정 카메라, `loop=false`.
장면 안에는 제목/부제목/설명 문단을 두지 않고 도형, 계산 피연산자, index 라벨만 둔다.
공통 Color Stop은 기존 Conic 시리즈의 빨강–노랑–청록–파랑을 유지한다.
화면 좌표는 Y-down이며 `p(x,y)`에서 tmath의 Y-up으로 변환한다.
영상은 controls와 최종 상태 WebP poster를 사용한다. 자동재생하지 않는다.

## 기존 시리즈에서 재구성한 내용과 beat ledger

원본은 conic-gradiant-sw checkout의 `.vscode/tmath/`에서 읽었다.
원본의 세로형 코드 슬라이드를 블로그의 가로형 기하/픽셀 장면으로 재구성했다.
코드 및 설명 문장은 MDX로 이동했다. 원본 시리즈 파일은 수정하지 않았다.

| 장면 | 원본/근거 | 3–7 beats, 각 상태에서 증명할 관계 |
| --- | --- | --- |
| 01-color-table | `_updateColorTable`, `_conicT`의 LUT | Stop → 구간 보간 → LUT → t=.20 조회 → t=.73 조회 → 결과 유지 |
| 02-linear | cpu-gradient-sampling / tvgSwFill.linearGradient.lua | 축과 색면 → P → 수직 투영 → t와 LUT → 같은 투영의 두 번째 점 → 유지 |
| 03-radial | cpu-gradient-sampling / tvgSwFill.radialGradient.lua | 중심·원 → 등색 원 → 샘플 거리 → t → LUT → 유지 |
| 04-shape-rle | cpu-rle-composition / tvgSwRaster._rasterRle.lua의 순회, normal Gradient RLE 원본 코드 | Shape → coverage → span → 내부 픽셀 반복 → 모든 span 누적 → 완성된 surface |
| 05-conic | conic-sw-fill / tvgSwFill._conicT.lua | 중심·seam → 샘플 .12 → .38 → .72 → .97 → seam 넘어 .02 → 유지 |
| 06-aa-width | conic-sw-fill 계획의 LUT AA 품질 분석 | seam → 각도 띠 → 두 반지름의 폭 → 픽셀 띠 → 비교 유지 |
| 07-fwidth | conic-sw-fill / tvgSwFill.conicFwidthAppendix.lua, _prepareConic.lua | 화면 픽셀 → 법선 → xStep 투영 → yStep 투영 → 절댓값 합 → 유지 |
| 08-aa-range | conic-sw-fill / tvgSwFill._conicAARange.lua, conicSeamProjectionAppendix.lua, _conicPixel.lua | 무한 띠 → 뒤쪽 제외 → scanline → AA 후보 → endpoint 보간 → [begin,end) 유지 |

밝은 배경은 구조, 주황 테두리는 현재 작업, 색상은 Gradient 값을 의미한다.
라벨과 geometry는 동일한 입력 좌표/색/coverage 배열에서 계산한다.
모든 Text의 ID는 `label_`로 시작하며 배경 위 독립 라벨이다. Text를 담는 Rectangle은 없다.
숫자는 전역 span index와 내부 pixel index를 구별하며, shape 밖은 처리하지 않는다.
마지막 프레임은 각 장면의 계산 결과를 유지한다.

## 모델의 범위

- Lua/브라우저 시각 자료는 교육용 재현이며 실제 ThorVG 실행 캡처가 아니다.
- 색은 float 보간 근사이며 packed RGBA LUT/INTERPOLATE의 정수 반올림과 다를 수 있다.
- Radial 영상은 동심원, `F=C`, `fr=0` 예시다. 일반 Radial 식은 본문에서 구별한다.
- Shape 영상은 원을 8×8 샘플링하여 coverage와 RLE를 생성한 뒤 Linear로 채운다.
  브라우저 실습은 동일한 순회 개념을 Conic에 적용한다.
- AA width 영상은 기하 비교이며 실제 blur 결과가 아니다.
- AA Range 영상은 화면 픽셀을 25배 확대한 항등변환 예시다.
- 브라우저 AA 실습은 회전·비균일 scale을 포함한다. 실제 코드는 모든 affine 역변환에
  적용되는 계수로 표현되며, 실습의 UI는 그 중 rotation × scale만 제공한다.
- `_prepareConic`의 축 정렬 우회 조건을 그대로 드러낸다. 일반적인 supersampling,
  중심 특이점 필터링, 내부 hard stop AA를 구현한 것으로 표현하지 않는다.

## 재생성

사이트의 `sharp`와 PATH의 `ffmpeg`, Pretendard.ttf를 포함한 tmath CPU WASM runtime이 필요하다.
런타임은 배포물에 포함하지 않는다. `render.mjs`의 두 번째 인자로 runtime 디렉터리를 전달한다.

```sh
node src/content/blog/Mentoring/LUA/gradient-fill/build-scenes.mjs
node src/content/blog/Mentoring/LUA/gradient-fill/render.mjs /path/to/runtime --preview
node src/content/blog/Mentoring/LUA/gradient-fill/render.mjs /path/to/runtime
```

출력: `../../IMAGE/07-SW-Fill/*.mp4`, `*.webp`.
개별 출력은 마지막 인자로 `04-`와 같은 장면 접두사를 전달한다.
Lua는 자체 완결형이므로 별도 require/import 없이 tmath에서 직접 열 수 있다.

## 검증

- 모든 encoded frame과 정확한 최종 시간에서 production font layout audit 실행.
- Text/Text 간격 ≥4px, canvas inset ≥4px, 전체 Text ownership ledger 적용.
- 패널 안 Text가 없으므로 panel clearance는 해당 없음.
- 처음/27%/55%/80%/끝의 원본 프레임 저장, 대표 장면 contact sheet 시각 검토.
- 각 장면의 독립 입력을 비대칭 값으로 변경하여 최종 출력의 종속 geometry/색 갱신 확인.
- 브라우저: 영상 8편의 1배속 종료, 실습 3개의 조작, 키보드, 라이트/다크, 390px viewport 확인.
- `tests/gradient-fill.test.mjs`: 960개 affine/scanline 조합의 AA Range와 독립 픽셀별
  half-plane 판정 비교, 정확한 열린 구간 endpoint, 픽셀 네 꼭짓점의 투영 폭,
  seam 뒤쪽 제외, RLE coverage/주소/중복 및 subpixel 입력 변경 검사.
- float 비교는 1e-10 이내의 경계 모호성을 따로 제외하며 정확히 표현 가능한
  inverse shear 예시로 `-0.5`, `+0.5` 경계 제외를 별도 검증한다.

확인 결과: Astro check 오류 없음, 새 수치 테스트 5개 통과.
Linear·Radial 교체 후 프로덕션 빌드 통과. 전체 테스트는 119개 중 118개 통과하며,
실패 1개는 기존 Bitmap 글의 `data-search`에 포함된 `-->`와 카드 검사 정규식의 충돌이다.
새 실습 두 개의 드래그·방향키·색상 변경·초기화, 투영점과 Radial 원의 수치 일치,
로컬 WASM 1회 로딩, 390px viewport와 다크 테마를 브라우저에서 확인했다.
