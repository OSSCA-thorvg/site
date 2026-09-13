B 윤곽 → coverage 격자 탐색 → SwRle::spans

파일
- 소스: font-shape-rle.lua
- 재현 스크립트: render-font-shape-rle.mjs
- 영상/포스터: ../IMAGE/07-SW-Font/font-shape-rle.mp4 / .webp
- 1600×900, H.264/yuv420p, 30 FPS, 2,953프레임, 약 98.43초
- Scene 길이: 98.380004883초, 마지막 프레임에 정확한 종료 상태 포함
- 무음, 자동 반복 없음

영상 구성
1. Public Sans B의 MoveTo/LineTo 경로 생성.
2. quadratic 제어점으로 cubic 제어점 두 개 구성, 같은 곡선 그리기.
3. 나머지 곡선과 내부 윤곽 두 개를 그리고 Close.
4. 같은 윤곽 위에 16×21 픽셀 격자와 좌표 표시.
5. y=0..20, x 증가 방향으로 탐색. coverage=0은 기록 생략.
   시작 픽셀 중앙에서 len만큼 가로선을 뻗으며 배열 추가/병합 표시.
   내부 빈 공간이 있는 y=4와 긴 255 구간이 있는 y=10은 픽셀별 추적.
   나머지는 같은 coverage의 연속 구간을 묶어 탐색하는 빠른 재생.
6. 격자 위의 시작 픽셀·가로선 131개와 누적 개수, 마지막 5개 기록 유지.
   화면에서 사라진 레코드도 원본 배열에서는 유지되는 표시 영역 이동.

출처와 표현 범위
- ThorVG v1.1.1: f9a618047bc31360d921dd05dcc0979c01fc8cf8
- test/resources/PublicSans-Regular.ttf의 B, advance=1341, unitsPerEm=2000.
- 폰트 SHA256:
  b577e9bc9887284e90aae5ad0699689ce36b5cd96207efbec68f77f8aed88379
- 원본 contour 좌표를 Lua에 포함. 생성 시 별도 폰트 추출 불필요.
- quadratic → cubic 변환은 정확한 degree elevation, 샘플 위치 동일성 assert.
- RenderPath는 벡터 경로. 완성된 비트맵을 읽어서 압축하는 영상이 아님.
- 시작 픽셀과 선의 회색 농도는 12분할/Q + 8×8 NonZero 샘플링 coverage.
  실제 ThorVG AA의 셀 area/cover 적분이나 엔진 실행을 계측한 trace가 아님.
- SwSpan의 필드는 int32_t x,y,len과 uint8_t coverage.
  SwRle는 Array<SwSpan> spans를 소유하며 x는 구간 시작 좌표.
- Overview의 sw-rle-surface.lua / spanGlyph와 동일한 좌표 표현:
  begin=(x+0.5,y+0.5), end=begin+(len,0), 작은 사각형의 크기는 픽셀 간격의 0.36배.
  회색 값은 255-floor(coverage*195/255), 선은 픽셀 중앙에서 가로로 확장.
  끝 표식은 제외 끝점이며, 해당 끝점의 픽셀까지 채운다는 뜻이 아님.
  이전의 전체 구간 채우기와 배열로 향하는 대각 연결선은 제거.
- append/merge 조건은 v1.1.1의 _horizLine과 대응.
  실제 _sweep는 일정 coverage 구간을 aCount > 1로 한 번에 전달하기도 하므로,
  상세 행의 픽셀별 len 증가 모션을 실제 호출 횟수로 해석하면 안 됨.
- 색상/브러시를 적용한 RGBA framebuffer 출력은 표현하지 않음.
- y=10의 coverage:
  [0,223,255,255,255,255,255,255,255,255,231,112,16,0,0,0]
- 해당 행의 (x,y,len,coverage):
  (1,10,1,223), (2,10,8,255), (10,10,1,231), (11,10,1,112), (12,10,1,16).

재현 — site 루트
  node src/content/blog/Mentoring/LUA/render-font-shape-rle.mjs /path/to/tmath-skills/assets/wasm
  node src/content/blog/Mentoring/LUA/render-font-shape-rle.mjs /path/to/tmath-skills/assets/wasm --preview

요구 사항
- Node, site의 sharp 의존성, ffmpeg, 완전한 tmath skill WASM 번들.
- CPU 렌더러. 번들의 Pretendard를 실제 출력과 모든 layout 검사에 동일하게 사용.
- WASM 번들 sourceCommit=2cca90ca4c4b, ThorVG=1.1.1, Lua=5.4.8.
- 폰트/WASM 바이너리는 site에 복사하지 않음.

검증
- 전체 모델의 모든 셀과 기록을 독립적으로 replay/decode하여 일치 assert.
- x offset 1.1 → 1.2 변형: 윤곽이 2.6px 이동, 폭 유지,
  숫자로 표시한 coverage와 저장 레코드 값도 함께 변경.
- 전체 2,953프레임의 Text 간격 4px, canvas 여백 4px, 소유 사각형 여백 12px 검사.
- 최소 canvas 여백 21.68px, 최소 소유 사각형 여백 14.41px, 위반 0건.
- 매 프레임 선의 시작점과 시작 픽셀 중앙, 선의 끝과 끝 표식의 정렬 검사.
- 최종 131개 span 모두 유지, 각 선 길이가 배열 len × 격자 간격과 일치.
- H.264 MP4 전체 스트림 디코딩 통과, 98.433333초, 4,968,816 bytes.
- y=4의 빈 공간 탐색은 약 31초, y=10의 len 증가 추적은 약 55~67초.
- 명시적인 ID 패턴으로 전체 Text 소유권 목록을 확장하여 검사.
- Font MDX 단독 컴파일 통과.
- 이번 npm run check는 다른 작업의 LUA/gradient-fill/README.md가 블로그
  콘텐츠로 수집되면서 title/github/date 메타데이터 오류로 중단. 해당 파일은 미수정.
- 원본 크기의 주요 시점 PNG와 contact sheet는 temp/font-shape-center-spans/에 생성.
- 이 스레드의 tmath raster review 한도(2회)가 이전 영상 검토에서 소진되어,
  이번 수정본은 새 이미지를 모델에 첨부하여 육안 검사하지 못함.
  자동 layout/데이터 검사와 파일 렌더링만 수행, 1배속 육안 재생 검토는 미수행.
- npm test는 build의 미디어 복사 단계에서 아래 기존 파일의 EACCES로 중단.
  그 뒤의 node --test 계약 테스트는 실행되지 않음:
  IMAGE/09-Post-Effects/temp/01-separable-box-blur-final.png (EACCES).
  해당 파일이나 권한은 수정하지 않음.
- text-state-intervals.json: 각 좌표/readout, 레코드 상태, count의 표시 구간.
- text-ownership.json: 전체 Text 소유권 목록.
