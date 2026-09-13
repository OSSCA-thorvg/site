Conic SW fill — 원본 tmath 시리즈의 블로그 편집본

원본: conic-gradiant-sw/.vscode/tmath/conic-sw-fill/animations/
본문: ../../07-6-CPU-Engine-FILL.mdx
출력: ../../IMAGE/07-SW-Fill/conic-series/

편집 원칙
- 원본 7개 Lua를 직접 사용. 도형 생성, canonical 수치, object ID,
  easing, 순회, scene:play / wait 순서는 원본과 동일하다.
- 제목/장황한 설명은 text helper에서 빈 문자열로 표시한다.
  animation target handle은 유지하므로 원본 타임라인이 그대로 동작한다.
- 원본 adaptive_vscode의 light 팔레트 및 Pretendard/IBM/Source Serif 폰트 사용.
- Basic Math는 원본 한 장면의 네 영역을 잘라 각각 필요한 본문에 배치한다.
  새로운 도형으로 다시 그리거나 타임라인을 재구성하지 않는다.
- 마지막 _conicPixel만 export 시 원본 reset 직전 27.45초에서 멈추고
  완성된 48픽셀 surface를 1.6초 유지한다. 원본 Lua reset은 수정하지 않는다.
- HTML은 명시적 재생 controls, 자동 재생/반복 없음. 모바일 전체 화면은
  브라우저 기본 video control 사용. MP4와 WebP 합계 약 3MB.

원본 → 출력 / 핵심 beat
conicTitle → conic-paint
  중심 → 60 sector 순차 생성 → seam wrap → affine 변환 → 원래 공간
_conicT → conic-lookup
  110° 샘플 → 점에서 LUT로 proxy 이동 → 350° → 375° wrap → 복귀
_prepareConic → math-dot-cross
  operand A → b 변화에 따른 투영선/평행사변형 → A로 복귀
_prepareConic → math-normal
  seam/normal 직교 → construction vector를 seam으로 → 90° 회전
_prepareConic → math-inverse
  local 격자 → 화면 격자로 proxy 이동 → M^-1로 local 격자에 재결합
_prepareConic → math-derivatives
  inverse A → inverse B → footprint/두 투영/fwidth 동시 갱신 → A
conicFwidthAppendix → conic-fwidth
  pixel pullback → 법선/투영 구성 → local scale ×3 → 거리 토큰 정규화 → 복귀
conicSeamProjectionAppendix → conic-projection
  ray 위 cursor → Pdx 양수 clipping → 음수 clipping → 상수 분기 → 복귀
conicAARangeGatesAppendix → conic-gates
  공유 행 cursor → 거리/방향 gate → i2 반례 → [3,6) 교집합 → 복귀
_conicPixel → conic-pixel-fill
  행 순회 → NORMAL 첫 사례 → AA 첫 사례 → NO AA 첫 사례 → surface 완성

다른 장면
- RLE 섹션은 interactive만 표시. 기존 04-shape-rle 영상은 본문에서 제거.
- Color Table은 .vscode/components/GradientColorTable.astro 기반 interactive로 교체.
  현재 본문: 영상 10개, interactive 5개.
- 기존 05-conic / 06-aa-width / 07-fwidth / 08-aa-range는 본문에서 제거.
- Linear·Radial은 요청한 WebCanvas SW interactive를 유지.
- RLE 및 AA 비교 interactive도 유지. Composition은 추가하지 않는다.

재현 (site 폴더에서)
node src/content/blog/Mentoring/LUA/conic-series/adapt.mjs /path/to/conic-gradiant-sw
node src/content/blog/Mentoring/LUA/conic-series/render.mjs /path/to/tmath-runtime
node src/content/blog/Mentoring/LUA/conic-series/verify.mjs /path/to/conic-gradiant-sw /path/to/tmath-runtime

runtime: client.js, tmath-wasm.wasm, Pretendard.ttf,
SourceSerif4-Semibold.ttf, IBMPlexSansKR-SemiBold.ttf가 필요하다.
render.mjs 뒤에 --audit 또는 clip 이름을 붙여 선택 실행 가능.
manifest.json: 원본 경로·SHA256·숨긴 라벨 ID·crop·poster 시간·final hold.

검증
- verify.mjs는 제목 숨김 패치를 역으로 제거한 소스가 원본과 byte 단위로
  같은지 검사한다. 도형/계산/타임라인 보존을 단순 유사성으로 판단하지 않는다.
- 모든 프레임의 표시 Text bounds, overlap, canvas inset 4px 검사.
  연결된 equation token은 실제 glyph bounds로 비교. A/B 텍스트 crossfade만
  같은 suffix의 state-a/state-b ID 쌍으로 명시적으로 허용한다.
- Text ownership: 모두 독립 라벨. 조건식 highlight/focus는 backing panel이 아니다.
  해당 standalone ID 목록을 각 temp/*.audit.json에 기록한다.
- 도형은 crop에 일부만 걸친 객체가 없는지 모든 프레임 검사한다.
  원본의 다른 module은 의도적으로 crop 밖에 있으며 출력에 포함되지 않는다.
- 48개의 surface-output이 최종 hold 시점에 모두 표시되는지 확인한다.
- 디코딩한 MP4의 프레임 수/30fps/최종 프레임을 원본 렌더와 대조한다.
- browser: 전체 영상 12개 1배속 종료, page error 없음, 390px page overflow 없음.
- Astro check / production build 통과.

검토 한계
이번 수정에서는 원본 레이아웃·프레임 bounds·디코딩 비교·브라우저 재생으로
검증했다. 이 스레드의 tmath raster review 예산을 이전 작업에서 사용했으므로,
새 프레임의 모델 시각 검토는 추가하지 않았다. 대표 프레임 및 desktop/mobile
브라우저 캡처는 temp에 저장했다. 인터랙티브 수치 모델은 이번 수정 대상이 아니다.
