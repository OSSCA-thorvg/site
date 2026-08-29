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

