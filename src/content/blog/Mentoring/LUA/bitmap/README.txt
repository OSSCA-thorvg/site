Bitmap 렌더링 tmath 시리즈

기준: thorvg/thorvg 6cf10d47fbe13b45040f2c56feeafa0711f53b2b
대상: ../../07-2-CPU-Engine-Paint.mdx#1-bitmap / CPU bitmap renderer 입문자.
출력: 1280×720, 30fps, Pro White, Pretendard, loop=false, MP4 + WebP.
화면 제목/설명문은 제외. Source, Target, Scale 및 실제 해상도, UV, XY만 표기.
00-pixel-memory의 별도 계약은 pixel-memory-README.txt 참조.

원본과 데이터
- 01~03/05: 8×8 불투명 풍경 Bitmap. Source를 지우지 않고 읽은 사본만 이동.
- 04: 같은 풍경의 24×24 변형. 아래쪽에 가는 무늬를 추가하여 축소 결과 구분.
- bitmap-model.mjs가 CPU 보간과 입력 모델을 정의. 독립 Lua에 입력 RGB를 내장.
- Source/Target을 비교하기 위해 표시 배율은 다르게 지정. Scale은 표시 사각형의
  크기 비율이 아니라 원본/타겟의 실제 화소 수 비율이며 두 해상도를 명시.
- 선형 보간은 실제 uint8 dx/dy와 /256 정수 연산. Opaque normal-blend에 한정.
- 확대 좌표: sx=x/scale-.49, sy=y/scale-.49. x/y는 target 화소 인덱스.
- Nearest는 trunc, Bilinear는 4개 이웃과 경계 clamp, Downscale은 실제 표본 간격.
- 색·footprint·기여도·완성 타겟 모두 같은 sample record에서 파생.
- 위치는 화면 Y-down; p()가 tmath Y-up으로 변환. 고정 2D 카메라.
- Layer: Cell 10, 결과 사본 35, 가이드 40, 선택 45, Sample 50, Text 60.
- 모든 label_* Text는 backing Rectangle 밖의 독립 라벨. containment 대상 없음.

장면과 3–7 beat ledger
01-direct / 어떻게 보간을 생략하는가? / 9.92초
  Source·빈 Target → source 행 선택 → 행 사본을 같은 크기로 이동 →
  다음 행 반복 → 8×8 전체 이미지가 (2,1) 이동 위치에 완성.
  stride/주소/조건문 설명을 영상에서 제거. 12×10 target, source stride=8.

02-nearest / 스케일과 단일 texel 선택 / 19.20초
  Source·2배 Target → target Sample 역매핑 → texel 한 개 사본 기록 →
  16×16 전체 결과 → target (10,6)을 고정한 채 3배 크기로 변경 →
  source Sample 이동·조회 → 24×24 전체 결과.

03-bilinear / 왜 Sample 위치와 결과 색이 달라지는가? / 24.72초
  Source·2배 Target → target의 (10,6), (11,6), (12,6) 순회 →
  네 이웃의 기여도를 strip 면적으로 모아 한 색으로 합성 → 16×16 전체 결과 →
  target (10,6) 고정, 30개 scale step에서 경계 크기와 source Sample 동시 이동 →
  새 위치의 이웃 보간 → 24×24 전체 결과.
  source Sample: scale2 (4.51,2.51), scale3 (2.8433,1.51).
  arbitrary sample 이동이나 네 픽셀만 표시하는 장면이 아님.

04-downscale / 큰 축소율은 무엇을 더 읽는가? / 22.40초
  24×24 Source → scale1/3, n1/inc1의 2×2 표본 결합 → 8×8 전체 Target →
  target (2,2) 고정, 1/6으로 축소하면서 source Sample 이동 →
  n3/inc2의 6×6 범위에서 9개 실제 표본 결합 → 4×4 전체 결과.
  값은 실제 방문 횟수로 나눈 채널 정수 평균. 경계에서는 커널 범위 제한.

05-texmap / 왜 두 개의 삼각형을 차례로 채우는가? / 26.04초
  사각형 outline을 UV에서 XY로 변환 → 양쪽 대각선 생성 →
  첫 삼각형의 세 UV/XY 꼭짓점 대응 → 실제 scanline 순서로 첫 삼각형 전체 채움 →
  완료 상태 유지 → 두 번째 삼각형의 세 꼭짓점 대응 및 전체 채움 → 완성 이미지.
  실제 Polygon은 vertex[3]을 받음. 세 꼭짓점으로 내부 UV field의 미분값 결정.
  사각형 전체는 (0,1,3)과 (1,2,3)의 두 호출로 처리. 교대로 행을 쓰지 않음.
  trace-texmap.mjs가 고정 커밋의 _rasterPolygonImage()를 직접 추출/컴파일하여
  XY/UV 방문 순서 기록: 첫 삼각형 288 samples → 두 번째 289 samples.
  577개 목적지 모두 고유. 한 삼각형이 끝나기 전에 다른 삼각형의 화소를 쓰지 않음.
  UV 가이드·XY 가이드·움직이는 Sample·출력 색은 같은 trace record 사용.
  13.52초에서 T0가 완성되고 T1 영역이 비어 있음을 실제 렌더 화소로 확인.
  normal-blend 경로의 scan geometry/subpixel stepping과 Bilinear를 설명.
  _feathering(), mask, custom blend는 제외. 전체 엔진 framebuffer 캡처는 아님.

재생성 (프로젝트 루트)
node src/content/blog/Mentoring/LUA/bitmap/trace-texmap.mjs
node src/content/blog/Mentoring/LUA/bitmap/build-scenes.mjs
node src/content/blog/Mentoring/LUA/bitmap/render.mjs /path/to/tmath-skills/assets/wasm

검증
node src/content/blog/Mentoring/LUA/bitmap/verify-scenes.mjs /path/to/tmath-skills/assets/wasm
- 고정 커밋 C++ _interpNoScaler/_interpUpScaler/_interpDownScaler와 INTERPOLATE를
  추출/컴파일하여 JS/Lua 결과와 비교. 최종 1,168개 샘플의 RGB 완전 일치.
- Direct 결과 64개, 두 확대 결과의 첫 스케일 각각 256개, 축소 첫 결과 64개,
  마지막 결과 1,168개, Texture Mapping 577개를 실제 렌더 픽셀과 대조.
- Bilinear의 scale 전환 30시점에서 target 고정/source 역스케일 이동 확인.
- Texture Mapping 첫 삼각형 완료/두 번째 미기록 상태와 최종 결과 모두 확인.
- 모든 encoded frame의 production-font Text 간격/캔버스 여백 검사.
- 대표 프레임 및 JSON 보고서, native reference probe는 temp/ 아래에 저장.
- 원본/결과 및 단계별 프레임은 디스크에 렌더. 이 대화의 raster 시각 도구 한도는
  앞선 장면 검토에서 소진하여 새 contact sheet의 추가 육안 검토는 미실시.

환경: Node, 사이트 sharp, ffmpeg, clang++(C++17), 고정 commit을 가진 ./thorvg,
CPU tmath WASM bundle + Pretendard.ttf. 런타임 소스를 사이트에 추가하지 않음.

최종 검증 기록 (2026-09-06)
- 01~05의 3,077개 시점 layout 검사 통과. Text 최소 간격 9.33px, 캔버스 최소 여백 50.28px.
- MP4 다섯 개의 전체 프레임 디코딩 통과.
- npm run check: 오류/경고 0, 기존 파일 hint 1개.
- npm test: 프로덕션 빌드 및 123개 테스트 통과.
- 빌드된 글에서 다섯 영상을 headless Chrome으로 1배속 재생하여 모두
  ended=true 및 1280×720 확인. source-target-playback.json에 결과 기록.
