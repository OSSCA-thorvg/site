# OSSCA × ThorVG

OSSCA 2026 ThorVG 멘티를 위한 정보 허브입니다. 

이슈를 찾고, 학습 기록을 공유하며, 브라우저 실습 도구와 공식 일정을 한곳에서 확인할 수 있습니다.

Astro로 빌드해 GitHub Pages에 정적 배포합니다.

## 페이지

| 경로 | 기능 | 주요 소스 |
|---|---|---|
| `/` | 최근 이슈와 블로그 글을 빠르게 확인하는 대시보드 | `src/pages/index.astro` |
| `/issues` | 자동 동기화된 GitHub 이슈 검색과 프로젝트 필터 | `src/data/live-issues.json` |
| `/blog` | Discussions와 로컬 Markdown 중 `과제` 라벨이 없는 글을 보여 주는 학습 블로그 | `scripts/sync-discussions.mjs`, `src/content/blog/` |
| `/assignments` | 같은 글 데이터에서 `과제` 라벨을 달은 글만 모아 보는 과제 목록 | `src/pages/assignments/index.astro` |
| `/playground` | 저장소의 Lottie 샘플, 로컬 JSON 열기, Viewer와 WebCanvas 예제 iframe | `src/pages/playground.astro` |
| `/schedule` | 공식 페이지와 모집 공고를 근거로 정리한 OSSCA 2026 일정 | `src/data/schedule.ts` |
| `/thorvg` | ThorVG 공식 문서, 저장소, 빌드 안내와 도구 링크 | `src/pages/thorvg.astro` |

## 실행

Node.js 22.12 이상이 필요합니다.

```bash
npm install
npm run dev       # 개발 서버: http://localhost:4321
npm run check     # Astro/TypeScript 검사
npm test          # 프로덕션 빌드와 계약 테스트
npm run build     # 정적 결과물: dist/
npm run preview   # 마지막 build 결과 확인
```

글을 추가하거나 수정한 뒤 `npm run preview`로 확인하려면 먼저 `npm run build`를 다시
실행해야 합니다. `preview`는 개발 서버가 아니라 이미 만들어진 `dist/`만 보여줍니다.
로컬에서 preview로 확인할 때는 `BASE_PATH`를 붙이지 말고 빌드하세요. `BASE_PATH=/site`
같은 빌드는 GitHub Pages 배포용 링크를 만들기 때문에 로컬 preview의 경로와 다를 수 있습니다.

## 블로그 글 추가

기본 글쓰기 경로는 GitHub Discussions입니다. 블로그 화면의 `글쓰기`를 누르고 `Blog`
카테고리 양식에서 제목, 요약, 태그와 본문을 작성합니다. 작성 중인 글은 제목 끝에
`(WIP)`을 붙입니다. `(WIP)`이 없는 글은 다음 Pages 빌드에서 공개됩니다.

Discussion에 `과제` 라벨을 달면 `/assignments`에만 보이고 블로그 목록과 홈의
`최근 블로그 글`에서는 제외됩니다. 라벨을 바꾸면 다음 동기화 빌드에서 자동으로
목록이 이동합니다. 상세 URL은 `/blog/<id>`를 계속 사용해 기존 링크와 Discussion
댓글 연결을 유지합니다.

배포 워크플로는 Discussion의 제목, 작성자와 작성일로 `title`, `github`, `date`를 만들고,
양식의 요약과 태그로 `summary`, `tags`를 채웁니다. `draft: false`와
`discussionNumber`도 자동으로 추가되며 생성된 Markdown은 커밋하지 않습니다. 글 상세
페이지의 댓글은 같은 Discussion의 답글로 저장됩니다.

이미지와 GIF는 Discussion 본문에 붙여넣습니다. Lottie JSON을 첨부하면 GitHub가 만든
`[animation.json](URL)` 앞에 `!`를 붙여 `![animation.json](URL)`로 작성합니다.

저장소에 직접 글을 추가하는 기존 방식도 계속 사용할 수 있습니다.

`src/content/blog/` 아래 원하는 경로에 `.md` 또는 `.mdx` 파일을 만듭니다. `github`에는
실제 작성자의 GitHub 사용자명을 입력합니다.

```mdx
---
title: "ThorVG 렌더링 흐름 정리"
github: "github-id"
date: 2026-07-15
summary: "렌더링 파이프라인을 따라가며 정리한 학습 기록입니다."
tags: ["thorvg", "study"]
draft: false
---

본문을 Markdown 또는 MDX로 작성합니다. 이미지, GIF, Lottie는 일반 Markdown 이미지로
넣으면 목록 카드가 첫 번째 미디어를 자동으로 사용합니다.

![](/images/render-result.png)

![](/lottie/example.json)

```

`title`, `github`, `date`는 필수입니다. `summary`, `tags`, `draft`는 선택이며
생략하면 각각 빈 문자열, 빈 배열, `false`가 적용됩니다. `github`는 작성자 표시, 프로필 링크와 아바타,
`tags`는 카테고리 필터와 블로그·과제 분류에, `date`는 최신순 정렬에 사용됩니다. 본문에 미디어가 여러 개면 첫 번째 이미지,
GIF 또는 Lottie가 목록의 16:9 대표 미디어가 됩니다. `![](...)`처럼 대괄호를 비우면
캡션 없이 표시되고, `![캡션](...)`처럼 쓰면 본문 미디어 아래에 캡션이 표시됩니다. Lottie는
카드에 마우스나 키보드 포커스가 들어올 때 재생됩니다. `draft: true`인 글은 공개되지 않습니다.

본문의 H1 제목이 `# 시리즈 이름 - 1`, `# 시리즈 이름 -1` 또는
`# 시리즈 이름 (1)`로 끝나면 같은 H1 기본 이름을 사용한 글들이 자동으로
시리즈로 묶입니다. 시리즈 목록은 추출한 번호순으로 정렬되며, 링크 문구는 각 글의
frontmatter `title`을 사용합니다. 시리즈로 인식한 첫 H1은 본문에 렌더링하지 않고,
`<시리즈 이름>`을 시리즈 목록 제목으로 사용합니다.
동일한 규칙은 첫 표제를 `**시리즈 이름 - 1**`처럼 단독 굵은 문단으로 작성한
Discussion에도 적용됩니다.

## 네트워크와 배포

기본 Lottie JSON은 `public/lottie/thorvg-sample.json`에서 로컬로 제공됩니다. 다만
플레이어 스크립트, ThorVG Viewer와 WebCanvas 예제 iframe, GitHub 아바타와 외부 자료는
네트워크 연결이 필요합니다.

`.github/workflows/deploy.yml`이 `main` 브랜치를 GitHub Pages에 배포합니다. Pages 설정에서
배포 소스를 **GitHub Actions**로 선택해야 합니다. 워크플로는 배포 전에
`scripts/sync-issues.mjs`로 ThorVG GitHub 이슈를 `src/data/live-issues.json`에 동기화합니다.
`scripts/sync-discussions.mjs`는 `Blog` 카테고리에서 제목이 `(WIP)`으로 끝나지 않는
Discussion을 임시 Markdown으로 동기화합니다. Discussion 작성·수정·삭제와 카테고리 변경도
Pages 빌드를 실행합니다.
`actions/configure-pages`가 프로젝트 페이지 경로를 `BASE_PATH`로 전달하며,
`astro.config.mjs`가 이를 `/` 또는 `/<repo>/` 형태로 정규화합니다.

저장소 관리자는 GitHub에서 다음 항목을 한 번 설정해야 합니다.

1. Discussions에 이름과 slug가 `Blog`와 `blog`인 open-ended 카테고리를 만듭니다.
2. 사이트 댓글을 위해 [giscus 앱](https://github.com/apps/giscus)을 이 저장소에 설치합니다.

로컬에서 공개 Discussion까지 가져오려면 Discussions 읽기 권한이 있는 토큰으로 실행합니다.

```bash
GITHUB_TOKEN=... npm run sync:discussions
```

시각 규칙은 [`DESIGN.md`](DESIGN.md), 작업 규칙은 [`CLAUDE.md`](CLAUDE.md)를 따릅니다.
