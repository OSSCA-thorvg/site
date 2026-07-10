# CLAUDE.md

이 저장소에서 작업하는 에이전트와 기여자를 위한 규칙입니다.

## 제품 원칙

- 이 사이트는 OSSCA 2026 ThorVG 멘티의 정보, 입문 이슈, 학습 기록과 실습 자료 허브다.
- 사용자에게 보이는 문구는 한국어로 작성한다. 코드, 경로, API 이름, 상태 값과 고유명사
  같은 기술 식별자는 예외다.
- 조용하고 실용적인 작업 화면을 유지한다. 시각 규칙의 기준은 `DESIGN.md`, 실제 토큰의
  기준은 `src/styles/global.css`다.
- 기본 테마는 라이트다. 사용자가 고른 `light`와 `dark`를 모두 `ossca-thorvg-theme` 키에
  저장한다. 저장 값이 정확히 `dark`일 때만 다크를 적용하고, 값이 없거나 잘못되면 라이트를
  적용한다. 운영체제 테마를 자동 기본값으로 삼지 않는다.

## 경로와 데이터 계약

- `/`: 동기화된 최신 이슈를 최대 4개 보여 준다. 최신 공개 블로그 글은 최대 3개다.
- `/issues`: 동기화된 이슈를 우선 사용하고, 없을 때 `src/data/issues.csv`를 폴백으로 사용한다.
  CSV 열 순서는 `number,repo,title,labels,status,assignee,area,difficulty,recommended`이다.
  이슈 행은 실제 숫자 번호를 사용하며 GitHub 원문을 연다.
- `/blog`: `src/content/blog/` 아래 중첩된 `.md`와 `.mdx`를 최신순으로 보여 주고
  검색·태그·연도 필터를 제공한다. `title`, `github`, `date`는 필수이고,
  `summary`, `tags`, `draft`는 생략 시 각각 `''`, `[]`, `false`가 된다.
  `src/content.config.ts`가 이 계약을 검증한다.
- `/playground`: 저장소의 Lottie 샘플과 로컬 JSON 파일을 재생하고, 공식 Viewer와
  WebCanvas 예제를 iframe으로 제공한다.
- `/schedule`: `src/data/schedule.ts`의 공식 출처와 `milestones`를 표시한다.
- `/thorvg`: `src/pages/thorvg.astro`에 정의한 공식 문서와 도구 링크를 묶어 제공한다.

## 사람과 사실

- 사람을 만들어 내거나 임의의 GitHub 사용자를 수집하지 않는다.
- 저장소에는 개인 계정으로 작성한 예시 글을 포함하지 않는다. 실제 멘티가 콘텐츠를 추가할
  때는 자신의 `github`, `assignee`를 직접 입력한다.
- 일정은 `officialHub`와 `officialNotice`, ThorVG 기술 정보는 공식 사이트·공식 GitHub와
  로컬 원본을 확인한 뒤 갱신한다. 확인하지 않은 수치나 기능을 사실처럼 쓰지 않는다.
- `../docs/README.md`와 `../../thorvg/`는 사실 확인용 읽기 전용 이웃 저장소다. 이 사이트
  작업에서 수정하거나 함께 커밋하지 않는다.

## 내부 경로와 GitHub Pages

- 내부 링크와 정적 자산은 `import.meta.env.BASE_URL`을 사용한다. `/issues`처럼 루트 절대
  경로를 하드코딩하지 않는다.
- `astro.config.mjs`는 `BASE_PATH`를 `/` 또는 앞뒤 슬래시가 있는 `/<segment>/`로
  정규화한다. 따라서 현재의 `const base = import.meta.env.BASE_URL`과
  `base + 'issues'` 패턴은 `base`가 슬래시로 끝난다는 계약에 의존한다.
- `base + '/issues'`처럼 슬래시를 다시 붙이거나 설정의 끝 슬래시를 제거하지 않는다.
  경로 규칙을 바꾸면 루트 배포와 프로젝트 페이지 배포를 모두 테스트한다.

## 외부 실행 경계

- 로컬 샘플은 `public/lottie/thorvg-sample.json`이다.
- Lottie 웹 컴포넌트는 다음 고정 버전과 SRI를 유지한다.
  `https://unpkg.com/@thorvg/lottie-player@1.0.9/dist/lottie-player.js`
- iframe URL은 현재 Viewer `https://thorvg.github.io/thorvg.viewer/`와 WebCanvas 예제
  `https://thorvg-playground.vercel.app/showcase/custom-transform`이다.
- WebCanvas는 외부 예제 iframe이며 페이지 안에 임의 코드를 실행하는 별도 실행기를
  만들지 않는다.
- iframe의 `sandbox`, `referrerpolicy`, 원본 열기 링크와 새 창 표기를 제거하지 않는다.
  외부 링크는 `target="_blank"`, `rel="noopener noreferrer"`, 한국어 새 창 레이블을
  함께 사용한다.

## 소스 경계

- 이슈 내용: `src/data/issues.csv`; 파서: `src/lib/csv.js`.
- 블로그 내용: `src/content/blog/**/*.{md,mdx}`; 스키마: `src/content.config.ts`.
- 일정과 공식 출처: `src/data/schedule.ts`.
- ThorVG 자료 링크: `src/pages/thorvg.astro`.
- 공통 레이아웃과 동작: `src/layouts`, `src/components`; 시각 토큰: `src/styles/global.css`.
- 로컬 공개 자산: `public/`. 생성 결과물 `dist/`는 직접 편집하지 않는다.

표현용 페이지에 중복 데이터를 만들지 말고 위 소유 파일을 수정한다. GitHub 사용자명 검증,
필터의 `aria-live` 결과와 키보드 탭 동작을 유지한다.

## 검증

변경을 마치기 전에 모두 실행한다.

```bash
npm run check
npm test
```

`npm test`는 프로덕션 빌드와 `tests/*.test.mjs` 계약 테스트를 함께 실행한다.
