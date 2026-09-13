# CPU Engine Overview videos

Engine Overview의 공개 장면과 `.vscode/SW/CPU-Overview.mdx`로 옮긴 로컬 Pipeline 장면의 기록입니다.
아래 API → Surface·TaskScheduler의 Lua는 사이트 루트 기준 `.vscode/SW/CPU-Overview/`, 영상·poster는 그 아래 `posters/`에 있습니다.
ThorVG 분석 기준: `6cf10d47fbe13b45040f2c56feeafa0711f53b2b`.

| Lua | 영상·poster (`.vscode/SW/CPU-Overview/posters/`) | 설명 |
| --- | --- | --- |
| `sw-overview-api-rle-surface.lua` | `api-rle-surface.mp4`, `.webp` | API → outline → coverage / RLE → 최종 surface |
| `sw-overview-task-scheduler.lua` | `task-scheduler.mp4`, `.webp` | Loader·Prepare의 worker 실행, 순서 있는 Paint 합성, 완료 의존성 |

30 fps, Pro White theme, 무음 H.264/yuv420p MP4입니다. 해상도는 영상별 검증 결과를 참고합니다.
각 영상은 한 번의 구성을 보여 주고 최종 상태를 유지합니다. 자동 재생·반복 없이
문서의 재생 컨트롤로 탐색하며, poster에는 완성된 다이어그램을 사용합니다.

## 소스 근거와 예시의 범위

- `tvgCanvas.h`: update → prepare, draw → render, sync의 공개 경계.
- `tvgScene.h`: Paint를 장면 순서로 순회.
- `cpu_engine/tvgSwShape.cpp`: outline → RLE, axis-aligned rectangle fast path.
- `cpu_engine/tvgSwCommon.h`: SwSpan / SwRle / SwSurface 구조.
- `cpu_engine/tvgSwRaster.cpp`: coverage에 따른 픽셀 합성.
- `cpu_engine/tvgSwRenderer.cpp`: prepareCommon의 clip 대기와 task 제출,
  renderShape/renderImage의 done() 및 직접 raster 호출,
  partial preRender의 전체 준비 대기, sync 정리.
- `tvgTaskScheduler.cpp`: worker별 queue, 다른 queue에서 작업 가져오기,
  thread가 없을 때 run(0).
- `loaders/svg/tvgSvgLoader.cpp`: read() 요청과 paint() 대기.

첫 영상은 rle-engine-trace.cpp로 추출한 실제 ThorVG 29개 span과 packed 출력 값을
사용합니다. API 호출 좌표, RenderShape.path, RLE, Surface 모두 같은 trace에 기반합니다.
입력 다각형이나 coverage를 별도의 수학 모델로 재계산하지 않습니다.
자세한 추출·재현 절차는 rle-detail-README.txt에 있습니다.

두 번째 영상의 시간 폭과 worker 배정은 측정값이 아닙니다. worker 2개, 독립 입력
A(벡터)·B(bitmap), 첫 frame의 full draw를 가정합니다. 각 입력의 Loader → Prepare →
draw 의존성과 A → B 합성 순서를 Lua assertion으로 검사합니다. clip·group bounds
대기로 동시성이 줄어드는 상황과 OpenMP의 개별 픽셀 루프는 본문에서 설명합니다.

## 재생성

사이트의 npm dependencies와 `ffmpeg`, `tmath-skills/assets/wasm` bundle이 필요합니다.
장면은 이식 가능한 Lua이고, CLI가 없는 환경에서도 bundled CPU WASM host로 생성합니다.
런타임·폰트 파일 자체를 이 사이트에 복사하거나 배포하지 않습니다.

```sh
node src/content/blog/Mentoring/LUA/render-sw-overview.mjs /absolute/path/to/tmath-skills/assets/wasm
```

`--preview`를 추가하면 대표 프레임 검사와 poster만 생성합니다. 기본 실행은 MP4의
모든 프레임과 정확한 최종 시점을 검사한 뒤 인코딩합니다. 검토용 PNG, contact sheet,
Scheduler audit는 `temp/sw-overview/`, API overview audit는 `temp/rle-engine/`에 기록합니다.

Scheduler의 `@standalone`, `@contain` 주석과 API 영상의 `label_*` 접두사가 텍스트 소유 관계 목록입니다.
export helper는 실제 renderer의 paint bounds를 사용해 4px canvas inset,
4px Text/Text gap, 12px box inset을 검사합니다. 상자의 family bounds로 글자의
포함 여부를 추정하지 않습니다.

## 검증 결과

- API 예제: 현재 MDX의 polygon/stride/draw(false) 예제를 공개 헤더로 syntax 검사 통과.
- API → Surface: 2400×1400, 1159 frames, scene 38.570초, MP4 38.633초.
  139개 Text는 시간에 따라 교체되는 호출·필드 라벨까지 합한 수입니다.
  모든 프레임의 Text 간격/화면 경계 검사 통과, 최소 canvas 여백 83.58px.
- 실제 엔진 trace: 12×8, stride=16, ABGR8888, 불투명 단색, 29 spans.
  초기/Prepare 완료/각 span 기록/최종 상태에서 총 4096개 buffer cell을 대조했습니다.
  padding 유지, 입력 변형의 실제 엔진 출력 일치도 검사합니다.
- Scheduler: 기존 436 frames / 14.53초, canvas 12.30px / panel 17.03px 검사 결과 유지.
- 새 API MP4 전체 decode 및 MDX compile 통과.
- 추가 인라인 래스터 검토 및 1배속 육안 재생은 수행하지 않았습니다.

## Immediate / Retained 비교 모션

- 원본: `sw-overview-rendering-modes.lua`
- 재생성: `node src/content/blog/Mentoring/LUA/render-rendering-modes.mjs /absolute/path/to/tmath-skills/assets/wasm`
- 출력: `../IMAGE/07-SW-Overview/immediate-retained-mode.mp4`, `.webp`, `.png`
- 규격: 1600×860, 30fps, 약 17.27초, H.264/yuv420p. WebP·PNG는 최종 poster입니다.
- 화면 문구: 구역 이름·두 짧은 캡션을 포함한 Text 9개.
- 동작: 초기 객체 등록 → 첫 출력 → 원 위치 변경 → 원 색 변경.
- Immediate: 애플리케이션에 장면 유지, 매 frame 두 도형의 그리기 명령 전달.
- Retained: 최초 등록한 두 객체가 엔진에 계속 존재, 이후 바뀐 원의 정보만 전달.
- 채워진 도형은 장면·출력, 이동하는 윤곽 도형은 명령·변경·출력 생성의 개념 표현입니다.
- 근거: Microsoft Learn Retained Mode Versus Immediate Mode, Wikipedia Retained mode,
  THorVG-Lecture/2025/image-5.png 및 image-6.png. 시간·데이터 이동 크기는 설명용입니다.
- 검증: 전체 518프레임의 Text 간격·canvas·panel 여백, 등록 후 retained 객체의 지속 가시성,
  세 출력 시점의 결과 비교, 한 좌표 변경이 양쪽 모델·출력 모두에 반영되는지 확인.
  두 출력의 경계 AA 차이는 최대 1/255이며, 최소 canvas 여백 49.29px·panel 여백 21.67px입니다.
- MP4 전체 디코딩 및 MDX 컴파일 통과. 렌더러 bounds·픽셀 비교·OCR로 검토했으며,
  실제 플레이어에서의 1배속 육안 재생 검토는 수행하지 않았습니다.

## Canvas·Paint·Scene 관계와 합성 모션

- 원본: `sw-overview-api-relations.lua`, `sw-overview-scene-composition.lua`
- 재생성: `node src/content/blog/Mentoring/LUA/render-api-scenes.mjs /absolute/path/to/tmath-skills/assets/wasm`
- 출력: `api-relations.mp4`·`.webp`, `scene-composition.mp4`·`.webp`
  (`../IMAGE/07-SW-Overview/`)
- 관계도: 2400×1440, 30fps, 714프레임, 약 23.80초.
  공개·내부 타입 20개와 Extends / Has a / Associate 범례를 표시합니다.
  Canvas·Paint 독립 계층 → 파생 타입 → Scene·Text 보유 → 내부 경로·Fill → Animation·LottieAnimation 순서입니다.
  ShapeImpl::rs의 RenderShape가 RenderPath와 Fill을 보유하며, RenderPath는
  Point·PathCommand 배열을 보유합니다. TextImpl::shape는 내부 Shape입니다.
  RenderShape·RenderPath는 내부 타입이므로 점선 테두리를 사용합니다.
  Animation 아래에 LottieAnimation을 배치하며, Animation의 Picture 보유와 구분합니다.
  각 상속 가족은 하나의 화살촉·공통 줄기와 곡선 가지를 사용합니다.
  SwCanvas·GlCanvas·WgCanvas는 같은 줄에서 동시에 등장하며, Paint·Fill 자식도 동일합니다.
  Canvas·Paint·Fill 계열은 각각 옅은 파랑·보라·초록으로 구분합니다.
  보유 관계는 외곽 곡선, 참조 관계는 점선으로 연결하여 상속 가지와 분리했습니다.
  `--relations-only`로 관계도만 재생성할 수 있습니다.
- 합성: 2200×1100, 30fps, 678프레임, 약 22.60초. parent·child·opacity 등 Text 13개입니다.
  포함 상자로 부모·자식 관계를, child 번호로 각 부모의 목록 순서를 표시합니다.
  원과 중첩 Scene은 root Scene의 형제이며, Paint 사이의 화살표는 없습니다.
  첫 draw는 중첩 Scene opacity 255: 원·삼각형·사각형이 target으로 직접 전달됩니다.
  두 번째 draw는 같은 Scene opacity 128: 원은 target으로, 삼각형·사각형은
  offscreen RGBA로 전달된 뒤 한 장의 픽셀 이미지로 target에 합성됩니다.
  유일한 화살표와 composite × 128/255 표기는 마지막 bitmap 합성만 의미합니다.
  `--composition-only`로 이 영상만 재생성할 수 있습니다.
- 실선 빈 삼각형: 상속 방향은 파생 타입에서 기반 타입으로 향합니다.
  빈 마름모: 보유 측에 표시합니다. 독점 수명을 뜻하는 엄격한 UML composition이
  아니며, 참조 계수로 공유 가능한 Paint도 포함하는 추상적인 Has a 관계입니다.
  점선 화살표: API에서 참조·사용하는 타입입니다.
- 근거: `inc/thorvg.h`의 타입 선언, Paint::transform, Shape::appendPath/fill,
  TextImpl::shape / Text::fill 위임, ShapeImpl::rs, RenderShape::path/fill,
  RenderPath::pts/cmds, Fill::colorStops, Animation::picture와 Scene::add.
  LottieAnimation 상속은 src/loaders/lottie/thorvg_lottie.h에 근거합니다.
  `tvgCanvas.h`의 root Scene·renderer 보유 및 `tvgScene.h`의 자식 순회.
  LinearFill/RadialFill 대신 실제 이름 LinearGradient/RadialGradient를 사용합니다.
  ColorStop은 Fill::ColorStop이며, 모든 API·멤버 관계를 나열한 그림은 아닙니다.
- 합성 영상의 정확한 조건: 불투명 fill만 가진 Shape, 자식 두 개인 중첩 Scene,
  Normal blend, mask·effect 없음, root opacity 255, 중첩 Scene opacity 255 → 128.
  SceneImpl::needComposition/update/render와 SwRenderer::target/beginComposite/endComposite에 근거합니다.
  Scene::gen/add는 논리적인 그룹을 구성하고, update에서 합성 필요 여부를 정하며,
  draw에서 캐시 또는 새 Surface를 선택합니다. 중간 합성은 Shape·Paint mask 등에도 쓰입니다.
  작은 도형은 보관된 객체, 윤곽선은 raster proxy, checkerboard는 투명 offscreen입니다.
  그룹 결과는 동일한 삼각형·사각형 모델로 만든 128×128 RGBA 이미지이며,
  한 Image에 opacity를 적용합니다. 자식별 alpha로 그룹 opacity를 흉내 내지 않습니다.
  교육용 raster와 시간이며, ThorVG의 실제 AA·실행 시간을 재현한 캡처는 아닙니다.
- 검증: 전체 프레임과 정확한 마지막 시점의 텍스트 충돌·canvas·box 여백 0건.
  관계도 최소 canvas 여백 64.29px / box 여백 13.70px,
  합성 최소 canvas 여백 97.87px / box 여백 12.95px.
  첫 draw의 직접 겹침 순서와 offscreen 비가시성을 검사합니다.
  후반의 offscreen은 불투명 주황색 [233,165,59]이며, 삼중 겹침의 target은
  주황색을 파란 원에 128/255로 한 번 합성한 [137,143,139]입니다.
  opacity 128 → 96 변경 시 target만 [113,137,159]로 바뀌고 offscreen은 유지됩니다.
  위쪽 삼각형 픽셀로 bitmap의 상하 방향도 확인합니다.
  사각형 너비 135 → 157 변경 시 retained icon·offscreen·합성 픽셀이 함께 변합니다.
  Matrix 노드 이동 시 참조 선 끝점도 함께 이동합니다.
  파생 타입의 같은 높이 배치와 곡선의 다른 클래스 상자 침범 여부도 확인합니다.
  곡선 검사는 각 Bézier의 161개 좌표와 상자 바깥 14px 여백을 사용합니다.
- MP4 전체 디코딩과 MDX 컴파일을 확인합니다. 이 스레드의 tmath 래스터 검토 한도를
  이전 작업에서 사용했으므로 새 인라인 이미지 검토는 하지 않았습니다.
  대표 프레임의 렌더러 bounds·픽셀 검사는 수행했으며, 1배속 육안 재생은 미검토입니다.

## RenderMethod 추상화 모션

- 문서 위치: 1.2 RenderMethod. Immediate/Retained는 1.3, API → Surface는 1.4,
  예약된 Rendering Process는 1.5로 이동합니다.
- 원본: `sw-overview-render-method.lua`
- 재생성: `node src/content/blog/Mentoring/LUA/render-api-scenes.mjs /absolute/path/to/tmath-skills/assets/wasm --method-only`
- 출력: `../IMAGE/07-SW-Overview/render-method.mp4`·`.webp`
- 2400×1600, 30fps, 624프레임, 약 20.80초. 클래스·플랫폼 이름 10개만 표시합니다.
- 참고: `.vscode/THorVG-Lecture/2026/images/image-8.webp`의 backend 추상화 구도.
  실제 checkout의 CPU / OpenGL·ES / WebGPU를 표시하며 다른 그래픽 API를 추가하지 않습니다.
- 근거: `tvgRender.h` RenderMethod 가상 함수, `tvgCanvas.h` Canvas::Impl::renderer와
  update/draw 호출, `tvgCanvas.cpp` SwCanvas·GlCanvas·WgCanvas의 gen(),
  `tvgSwRenderer.h`·`tvgGlRenderer.h`·`tvgWgRenderer.h`의 RenderMethod 상속.
- 세 열은 동일한 도형 구성을 별도로 생성한 독립 Canvas·Paint입니다.
  같은 Paint를 세 renderer에 공유하거나, 하나의 Canvas에서 backend를 바꾸는 영상이 아닙니다.
  모든 선·화살촉은 요청·출력 흐름이며, 상속 관계는 문서의 코드에서 확인할 수 있습니다.
- 위쪽의 채워진 도형은 각 Canvas의 장면을, 이동하는 윤곽 도형은 처리할 데이터를,
  아래쪽 채워진 도형은 출력의 개념적 결과를 나타냅니다. SW → GL → WG 순서의
  설명용 모션이며 실제 속도·실행 동시성·backend 픽셀 일치 측정이 아닙니다.
- 경로의 Bézier 제어점은 그려진 선과 이동 좌표가 공유합니다.
  backend·플랫폼은 같은 높이이며, 하나의 도형 모델로 각 열의 source·packet·output을 만듭니다.
- 검증: 전체 프레임 및 최종 시점의 Text 간격·canvas·box 여백,
  이동 도형과 글자의 충돌 0건. 최소 canvas 106.69px / box 25.01px.
  출력 비교의 경계 AA 차이는 최대 3/255입니다. 사각형 너비 58 → 76 변경 시
  세 backend 출력 도형 모두 같은 폭만큼 변경됩니다.
- MDX·MP4 디코딩 검증을 수행합니다. 인라인 래스터 검토 예산은 이전 작업에서
  소진했으며 새 영상의 1배속 육안 재생은 미검토입니다.


## API → Surface: 실제 API와 엔진 데이터

- 생성: build-rle-scenes.mjs가 rle-engine-trace.txt를 portable Lua에 내장합니다.
- 원본: sw-overview-api-rle-surface.lua. 출력: api-rle-surface.mp4 / lossless .webp.
- 재생성: node src/content/blog/Mentoring/LUA/render-sw-overview.mjs /absolute/path/to/tmath-skills/assets/wasm --surface-only
- 기존 명령은 render-rle-detail.mjs --overview-only로 연결합니다.
- 모션: target 연결 → moveTo/lineTo/close → fill/add → update → draw(false) → sync.
- target/Prepare 단계에는 destination 값이 바뀌지 않습니다. source와 RLE는 draw 후에도 유지됩니다.
- RLE 시작 픽셀·길이 선과 target의 len개 쓰기 범위를 동시에 강조합니다.
- 현재 x/y/len/coverage와 y*stride+x 계산, buf32 범위를 표시합니다.
- API 순서 및 완료된 렌더 결과의 교육용 재생이며 명령 실행 시간·worker 스케줄 측정은 아닙니다.
- 모든 label_* Text는 배경 상자가 없는 standalone 라벨입니다.
- 이 영상의 임시 검사 파일은 temp/rle-engine/overview-review.txt에 기록합니다.

## RenderMethod 정적 그림 전환
- 1.2 본문은 render-method.png 한 장으로 표시합니다.
- 기존 최종 프레임의 lossless WebP를 PNG로 변환했으며 디코딩 픽셀 일치를 확인했습니다.
- render-api-scenes.mjs는 RenderMethod 재생성 시 같은 최종 프레임을 PNG로도 출력합니다.
