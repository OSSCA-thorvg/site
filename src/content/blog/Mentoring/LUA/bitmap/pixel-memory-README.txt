00-pixel-memory — 이미지에서 32비트 화소까지

질문: 화면의 이미지와 한 화소의 RGBA/BGRA 4바이트는 어떻게 연결되는가?
근거: ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b의 inc/thorvg.h
ColorSpace, src/renderer/tvgRender.h RenderSurface, tvgSwRaster.cpp rasterConvertCS.
변형: 160×96 불투명 RGBA procedural landscape. 사진/엔진 캡처는 아님.
단일 row-major buffer에서 원본 Image, 8×8 crop Cell, 1×1 Image,
채널 값, binary bit pattern, uint32 값을 모두 파생.
Alpha=255로 고정하여 byte order와 premultiplication을 분리.
채널의 빨강/초록/파랑/회색 표식은 채널 정체성, 원본 색을 다시 칠한 것이 아님.
RGBA/BGRA는 메모리의 낮은 주소부터 읽는 byte order.
각 byte의 binary는 왼쪽 MSB(7), 오른쪽 LSB(0). 4byte의 표시 순서 자체를
32비트 정수의 MSB→LSB 문자열로 읽으면 안 됨. 오른쪽 hex가 실제 LE uint32 값.

출력: 1280×720, 30fps, Pro White/Pretendard, loop=false.
Text ownership: 모든 label_*는 backing Rectangle 밖의 독립 라벨.
Bit 숫자는 bit bar 위에 배치. 채널명도 채널 strip 위의 독립 라벨.
확대 crop은 이미지 필터의 texel offset에 따른 재샘플링을 피하기 위해
같은 버퍼의 화소 값을 Cell에 직접 지정. 보간된 색이나 별도 예시 데이터가 아님.
레이어: 원본 10, crop 15, pixel/bit bar 20, guide 30, channel strip 35,
선택 outline 40, Text 50. 확대는 실제 source crop/pixel의 크기 변화.

7-beat ledger:
1. 제목/설명문 없이 160×96 RGBA Image를 6배 크기로 보여주는 시작 화면.
2. 원본 좌표 (122,30)의 8×8 영역 선택 → 원본을 옆으로 축소하는 동시에 같은 crop을 확대 → 격자.
3. crop의 화소 (125,32) 선택 → 동일한 1×1 Image가 112px로 확대.
4. 선택 색을 R/G/B/A의 채널 strip으로 분해하여 byte 자리에 배치.
5. 각 strip이 여덟 bit bar로 갈라져 아래로 이동 → 실제 binary 숫자와 32bit 정수 값.
6. 같은 8bit 사본을 BGRA 자리로 이동. 원본 RGBA 배열은 유지.
7. 이미지/crop/pixel과 두 메모리 배열, 같은 색과 다른 정수 값을 모두 유지.

재생성:
node src/content/blog/Mentoring/LUA/bitmap/render.mjs /path/to/tmath-skills/assets/wasm 00-
원본: 00-pixel-memory.lua. build-scenes.mjs가 이 파일을 덮어쓰지 않음.
일회성 검증 자료는 bitmap/temp/에 저장.

표현 원칙: 제목, 화살표 문장, 단계 설명, 좌표/주소, 각 채널 8비트 등의
부차적인 문장은 화면에서 제외. R/G/B/A의 decimal·hex, 32개 bit 숫자,
ABGR8888/ARGB8888 및 uint32 값만 남겨 모션의 결과를 직접 비교.
본문의 영상 순서 나열과 중복 binary 설명도 제거.

값 검증: node src/content/blog/Mentoring/LUA/bitmap/verify-pixel-memory.mjs /path/to/tmath-skills/assets/wasm
원본 15,360개 화소, crop 64개, 선택 화소, 두 배열의 bit bar 64개를
실제 렌더 픽셀과 대조. 다른 ROI/선택 좌표로 바꾼 비대칭 변형도 같은 검증 수행.
원본 선택값: RGBA(58,98,117,255), RGBA word=0xFF75623A, BGRA word=0xFF3A6275.

검토 범위: 실제 렌더 수치/production-font layout/디코딩/브라우저 재생.
이 대화의 tmath raster 시각 도구 한도는 앞선 5개 장면 검토에서 사용했으므로
새 장면의 contact sheet는 temp/에만 저장하며 추가 육안 검토는 미실시.

최종 검증 (설명문 제거 및 모션 수정 후):
- 26.43초 scene, 794개 시점의 production-font layout 통과.
- Text 간 최소 8.82px, 캔버스 최소 52.15px 여백.
- 원본 및 비대칭 변형의 화소/확대 영역/비트 값 대조 통과.
- MP4 전체 디코딩 통과, 빌드된 실제 글에서 headless Chrome으로
  playbackRate=1 재생 후 ended=true, 1280×720, 26.47초 확인.
- npm run check 오류 0, 기존 다른 파일의 hint 1개.
- 최종 npm test: 프로덕션 빌드와 테스트 123개 통과.
