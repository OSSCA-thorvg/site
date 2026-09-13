# OSSCA × ThorVG

OSSCA 2026 ThorVG 멘티를 위한 정보 허브입니다. 

이슈를 찾고, 학습 기록을 공유하며, 브라우저 실습 도구와 공식 일정을 한곳에서 확인할 수 있습니다.

Astro로 빌드해 GitHub Pages에 정적 배포합니다.

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

## 블로그 글 쓰기


- [Disscussion/Blog](https://github.com/OSSCA-thorvg/site/discussions/categories/blog) 를 참고하세요. 
- 또는, Blog 를 Clone 하고 .mdx 를 자유롭게 구성하면, 인터렉티브한 블로그 글을 작성할 수 있습니다. 
    - ThorVG Wasm 추가 
    - ThorVG WebCanvas 활용 
    
> [!IMPORTANT]
> 추가로 H1 요소를 제일 앞에 두고 넘버링 1, 2, (1), (2) 를 사용하면 글을 시리즈로 묶을 수 있습니다. (실제 사이트 렌더링시 목록 생성)
> ex) `# 공지 1`


## 시리즈와 하위 시리즈

Discussion과 로컬 Markdown/MDX 모두 **본문 첫 H1** 한 줄로 분류합니다.
Discussion 제목이나 frontmatter의 `title`은 실제 글 제목으로 사용합니다.

```md
# Core2026 - 1
```

기존 `시리즈 이름 - 번호`, `시리즈 이름 (번호)`, `시리즈 이름 번호` 규칙을 그대로
사용합니다. 하위 그룹은 이름 사이에 `>`만 추가하면 됩니다.

```md
# Core2026 > 이슈 처리 사례 - 6
# Core2026 > Engine - 7
# Core2026 > Engine > Cpu Engine > Pipeline - 8
# Core2026 > Engine > Cpu Engine - 12
```

위 네 줄은 **각각 다른 글의 첫 H1 예시**입니다. 여러 줄을 한 글에 넣는 방식이 아닙니다.
그룹을 만들기 위한 별도 글이나 설정 파일은 필요 없습니다. 경로에 쓰인 그룹은 자동으로
만들어지고, 해당 그룹에 직접 속한 글과 하위 그룹을 함께 표시합니다.

- 마지막 번호는 글의 정렬 순서입니다. 하위 그룹 안에서 번호를 새로 시작해도 됩니다.
- 같은 부모 아래에서는 글 번호순으로 정렬하고, 그룹은 그 안의 가장 작은 번호 위치에
  놓습니다. 상위 목록의 순서도 유지하려면 기존 번호를 그대로 사용하세요.
- 같은 이름의 그룹도 부모 경로가 다르면 별개입니다. 대소문자와 여분의 공백은 구분하지 않습니다.
- 구분자는 `>`입니다. `Draw/Raster`처럼 `/`가 포함된 이름은 하나의 그룹 이름입니다.
- 첫 H1 대신 독립된 굵은 줄(`**Core2026 > Engine - 7**`)도 지원합니다.
- 분류용 첫 제목은 사이트 본문과 목차에서 숨기고, 사이드바에서 트리로 표시합니다.
  읽는 글의 상위 그룹은 자동으로 펼쳐집니다.
- Discussion에서는 일반 Markdown 제목으로 보입니다. 사이트 동기화 후 트리 분류에 반영됩니다.
