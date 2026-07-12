import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, readdir } from 'node:fs/promises';

const pages = {
  home: 'index.html',
  issues: 'issues/index.html',
  blog: 'blog/index.html',
  playground: 'playground/index.html',
  schedule: 'schedule/index.html',
};

const readPage = (path) =>
  readFile(new URL(`../dist/${path}`, import.meta.url), 'utf8');
const readSource = (path) =>
  readFile(new URL(`../${path}`, import.meta.url), 'utf8');
const baseSegment = (process.env.BASE_PATH || '/').replace(/^\/+|\/+$/g, '');
const baseUrl = baseSegment ? `/${baseSegment}/` : '/';
const sitePath = (relative) => baseUrl + relative.replace(/^\/+/, '');
const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
const namedHtmlEntities = {
  amp: '&',
  quot: '"',
  apos: "'",
  lt: '<',
  gt: '>',
};
const decodeHtmlAttribute = (value) =>
  value.replace(
    /&(?:#(\d+)|#x([0-9a-f]+)|(amp|quot|apos|lt|gt));/gi,
    (_entity, decimal, hex, named) => {
      if (decimal) return String.fromCodePoint(Number.parseInt(decimal, 10));
      if (hex) return String.fromCodePoint(Number.parseInt(hex, 16));
      return namedHtmlEntities[named.toLowerCase()];
    }
  );
test('blog HTML attribute decoder handles named and numeric entities', () => {
  const encoded = '&amp;&quot;&apos;&lt;&gt;&#38;&#x26;&#34;&#x22;&#39;&#x27;&#60;&#x3c;&#62;&#x3e;';

  assert.equal(decodeHtmlAttribute(encoded), `&"'<>&&""''<<>>`);
});

for (const [name, path] of Object.entries(pages)) {
  test(`${name} page declares Korean as its document language`, async () => {
    const html = await readPage(path);

    assert.ok(html.includes('<html lang="ko"'), `${path} must contain <html lang="ko"`);
  });
}

test('home page defaults the shared shell to the light theme', async () => {
  const html = await readPage(pages.home);

  assert.ok(
    html.includes('<html lang="ko" data-theme="light">'),
    'home page must default to data-theme="light"'
  );
});

test('home page navigation uses Korean menu labels', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.home),
    readSource('src/components/Nav.astro'),
  ]);
  const navigation = html.match(/<nav\b[^>]*class="nav__links"[^>]*>([\s\S]*?)<\/nav>/)?.[1];

  assert.ok(navigation, 'home page must contain the primary navigation');

  for (const label of ['홈', '이슈', '블로그', '일정', 'ThorVG']) {
    assert.ok(navigation.includes(`>${label}</a>`), `home page navigation must contain ${label}`);
  }
  const playgroundLink = navigation.match(
    /<a\b(?=[^>]*href="[^"]*playground")[^>]*>플레이그라운드<\/a>/
  )?.[0];
  assert.ok(playgroundLink);
  assert.doesNotMatch(playgroundLink, /aria-label=/);
  assert.doesNotMatch(source, /nav__label--compact|>실습</);
  assert.ok(html.includes(`href="${sitePath('thorvg')}">ThorVG 자료</a>`));
});

test('home page marks the home navigation link as current', async () => {
  const html = await readPage(pages.home);
  const navigation = html.match(/<nav\b[^>]*class="nav__links"[^>]*>([\s\S]*?)<\/nav>/)?.[1];

  assert.ok(navigation, 'home page must contain the primary navigation');
  assert.match(
    navigation,
    /<a\b(?=[^>]*\baria-current="page")[^>]*>홈<\/a>/,
    'home navigation link must have aria-current="page"'
  );
});

test('current navigation uses color without an underline decoration', async () => {
  const css = await readSource('src/styles/global.css');

  assert.doesNotMatch(css, /\.nav__links a\[aria-current="page"\]::after/);
});

test('home page exposes the theme checkbox identifier', async () => {
  const html = await readPage(pages.home);

  assert.match(
    html,
    /<input\b(?=[^>]*\bid="theme-toggle")(?=[^>]*\btype="checkbox")[^>]*>/,
    'home page must contain the #theme-toggle checkbox'
  );
});

test('theme persistence stores either explicit selection and treats other values as light', async () => {
  const [base, navigation] = await Promise.all([
    readSource('src/layouts/Base.astro'),
    readSource('src/components/Nav.astro'),
  ]);

  assert.match(
    base,
    /localStorage\.getItem\('ossca-thorvg-theme'\)\s*===\s*'dark'\s*\?\s*'dark'\s*:\s*'light'/
  );
  assert.match(
    navigation,
    /const theme = toggle\.checked \? 'dark' : 'light';[\s\S]*?localStorage\.setItem\('ossca-thorvg-theme', theme\)/
  );
});

test('blog and issues page eyebrows use Korean interface copy', async () => {
  const [blog, issues] = await Promise.all([
    readPage(pages.blog),
    readPage(pages.issues),
  ]);

  assert.match(blog, /<p\b[^>]*class="eyebrow"[^>]*>학습 기록<\/p>/);
  assert.match(issues, /<p\b[^>]*class="eyebrow"[^>]*>기여 이슈<\/p>/);
  assert.match(issues, /<p\b[^>]*class="lede"[^>]*>\s*기여할 이슈를 찾아보세요\./);
  assert.doesNotMatch(blog, /<p\b[^>]*class="eyebrow"[^>]*>Blog<\/p>/);
  assert.doesNotMatch(issues, /<p\b[^>]*class="eyebrow"[^>]*>ThorVG Issues<\/p>/);
});

test('home page exposes recent issues and learning records', async () => {
  const html = await readPage(pages.home);

  assert.match(
    html,
    /ThorVG는 SVG와 Lottie를 포함한 벡터 그래픽을 직접 구성하고, 다양한 환경에서 렌더링할 수 있는 경량 오픈소스 엔진입니다\.\s*함께 ThorVG에 기여해봅시다!/
  );
  assert.ok(html.includes('최근 업데이트 이슈'), 'home page must contain 최근 업데이트 이슈');
  assert.ok(html.includes('최근 블로그 글'), 'home page must contain 최근 블로그 글');
});

test('home page uses the newest synchronised issue rows', async () => {
  const [html, liveSource] = await Promise.all([
    readPage(pages.home),
    readSource('src/data/live-issues.json'),
  ]);
  const issues = JSON.parse(liveSource).issues;
  const featuredRows = html.match(
    /<a\b(?=[^>]*\bdata-featured-issue="true")[^>]*>/g
  ) ?? [];

  assert.equal(featuredRows.length, Math.min(4, issues.length));
  for (const issue of issues.slice(0, 4)) {
    assert.ok(
      html.includes(`https://github.com/${issue.repo}/issues/${issue.number}`),
      `home must include the current issue ${issue.repo}#${issue.number}`
    );
  }
});

test('home issue project labels stay within their grid column', async () => {
  const css = await readSource('src/styles/global.css');
  const issue = css.match(/\.home-issue\s*\{([^}]*)\}/)?.[1];
  const project = css.match(/\.home-issue__num\s*\{([^}]*)\}/)?.[1];

  assert.match(issue, /grid-template-columns:\s*minmax\(0,\s*40%\)\s+minmax\(0,\s*1fr\)/);
  assert.match(project, /min-width:\s*0/);
  assert.match(project, /white-space:\s*normal/);
  assert.match(project, /overflow-wrap:\s*anywhere/);
});

test('home page limits recent posts and orders them newest first', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.home),
    readSource('src/pages/index.astro'),
  ]);
  const recentPosts = html.match(
    /<article\b(?=[^>]*\bdata-recent-post="true")(?=[^>]*\bdata-date="[^"]+")[^>]*>/g
  ) ?? [];
  const dates = recentPosts.map((post) => Number(post.match(/\bdata-date="([^"]+)"/)?.[1]));

  assert.ok(recentPosts.length <= 3, 'home page must render at most three recent posts');
  assert.deepEqual(dates, [...dates].sort((a, b) => b - a));
  if (recentPosts.length === 0) {
    assert.match(html, /아직 공개된 블로그 글이 없습니다\./);
  }
  assert.match(source, /toLocaleDateString\('ko-KR',[\s\S]*?timeZone:\s*'UTC'/);
});

test('home dashboard external links name their new-window behavior', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.home),
    readSource('src/pages/index.astro'),
  ]);

  assert.doesNotMatch(source, /입문 이슈 보기|>ThorVG GitHub<\/a>/);
  const authorLinks = html.match(
    /<a\b(?=[^>]*\bhref="https:\/\/github\.com\/[^"]+")(?=[^>]*\btarget="_blank")(?=[^>]*\baria-label="@[^\"]*\(새 창\)")[^>]*>/g
  ) ?? [];
  for (const link of authorLinks) {
    assert.match(link, /\baria-label="[^"]*\(새 창\)"/);
  }
  assert.match(source, /href=\{`https:\/\/github\.com\/\$\{post\.data\.github\}`\}/);
  assert.match(source, /aria-label=\{`@\$\{post\.data\.github\} GitHub 프로필 \(새 창\)`\}/);
  const featuredIssue = source.match(/<a\s+class="home-issue"[\s\S]*?data-featured-issue="true"[\s\S]*?>/)?.[0];
  assert.doesNotMatch(featuredIssue, /aria-label=/);
  assert.match(source, /<span class="sr-only">\(새 창\)<\/span>/);
});

test('blog page exposes a search field and category filters', async () => {
  const html = await readPage(pages.blog);

  assert.ok(html.includes('id="f-search"'), 'blog page must contain a search field');
  assert.match(
    html,
    /<a\b(?=[^>]*\bclass="btn btn--primary blog-write-link")(?=[^>]*\bhref="https:\/\/github\.com\/OSSCA-thorvg\/site\/discussions\/new\?category=blog")(?=[^>]*\btarget="_blank")(?=[^>]*\baria-label="GitHub Discussion에서 새 블로그 글쓰기 \(새 창\)")[^>]*>글쓰기<\/a>/
  );
  assert.match(html, /class="blog-categories"/);
  assert.match(html, /data-tag=""[^>]*>전체<\/button>/);
  assert.doesNotMatch(html, /id="f-year"/);
});

test('blog list follows the site theme with borderless editorial entries', async () => {
  const [html, css] = await Promise.all([
    readPage(pages.blog),
    readSource('src/styles/global.css'),
  ]);

  assert.match(html, /<section\b[^>]*\bclass="section"/);
  assert.doesNotMatch(html, /blog-index/);
  assert.doesNotMatch(css, /\.blog-index\s*\{/);
  const card = css.match(/\.post-card\s*\{([^}]*)\}/)?.[1];
  assert.doesNotMatch(card, /background:/);
  assert.doesNotMatch(card, /border:/);
  assert.doesNotMatch(card, /padding:/);
});

test('blog page derives category buttons and card metadata from published posts', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.blog),
    readSource('src/pages/blog/index.astro'),
  ]);
  const categories = html.match(/<nav\b(?=[^>]*\bclass="blog-categories")[^>]*>([\s\S]*?)<\/nav>/)?.[1];
  const cards = html.match(/<article\b(?=[^>]*\bclass="post-card")[^>]*>/g) ?? [];

  assert.ok(categories, 'blog page must render category buttons');
  assert.match(categories, /data-tag=""[^>]*>전체<\/button>/);
  const optionValues = (select) =>
    [...select.matchAll(/data-tag="([^"]*)"/g)]
      .map((match) => decodeHtmlAttribute(match[1]));
  const tagValues = optionValues(categories).slice(1);
  const cardTags = new Set();
  const cardDates = [];

  for (const card of cards) {
    assert.match(card, /\bdata-search="[^"]+"/);
    assert.match(card, /\bdata-tags="[^"]*"/);
    assert.match(card, /\bdata-year="\d{4}"/);
    assert.match(card, /\bdata-date="\d+"/);

    const rawTags = card.match(/\bdata-tags="([^"]*)"/)?.[1] ?? '';
    let tags;
    assert.doesNotThrow(() => {
      tags = JSON.parse(decodeHtmlAttribute(rawTags));
    }, 'data-tags must contain a JSON array');
    assert.ok(Array.isArray(tags), 'data-tags must decode to an array');
    tags.forEach((tag) => cardTags.add(tag));
    cardDates.push(Number(card.match(/\bdata-date="([^"]+)"/)?.[1]));
  }

  assert.deepEqual(tagValues, [...cardTags].sort(), 'tag options must be unique and sorted');
  assert.deepEqual(cardDates, [...cardDates].sort((a, b) => b - a), 'posts must be newest first');
  assert.doesNotMatch(source, /selectedYear|matchesYear/);
  assert.doesNotMatch(html, /id="f-(?:author|sort|year|tag)"/, 'blog filters must stay focused on search and categories');
});

test('blog keeps tag filter data as JSON instead of splitting on spaces', async () => {
  const source = await readSource('src/pages/blog/index.astro');

  assert.match(source, /data-tags=\{JSON\.stringify\(p\.data\.tags\)\}/);
  assert.match(
    source,
    /JSON\.parse\(card\.dataset\.tags \|\| '\[\]'\)\.includes\(selectedTag\)/
  );
  assert.doesNotMatch(source, /dataset\.tags[^\n]*\.split\(' '\)/);
});

test('blog cards use an image-first editorial hierarchy with whole-card post links', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.blog),
    readSource('src/pages/blog/index.astro'),
  ]);
  const cards = html.match(
    /<article\b(?=[^>]*\bclass="post-card")[^>]*>[\s\S]*?<\/article>/g
  ) ?? [];

  assert.match(source, /post-card__fallback-mark/);
  assert.match(source, /class=\{`post-card__media \$\{media \? `post-card__media--\$\{media\.type\}` : 'post-card__media--fallback'\}`\}/);
  assert.match(source, /class="post-card__link"/);

  for (const card of cards) {
    assert.match(card, /post-card__media/);
    assert.match(
      card,
      new RegExp(`<a\\b(?=[^>]*\\bclass="post-card__link")(?=[^>]*\\bhref="${escapeRegExp(sitePath('blog/'))}[^"]+")(?=[^>]*\\baria-label="[^"]+")[^>]*><\\/a>`)
    );
    const authorLink = card.match(
      /<a\b(?=[^>]*\bclass="post-card__author")[^>]*>[\s\S]*?<\/a>/
    )?.[0];
    const github = authorLink?.match(/\bhref="https:\/\/github\.com\/([^"]+)"/)?.[1];

    assert.ok(authorLink, 'post card must render a GitHub author link');
    assert.ok(github, 'author link must identify its GitHub username');
    assert.match(authorLink, /\btarget="_blank"/);
    assert.match(authorLink, /\baria-label="[^"]*\(새 창\)"/);
    assert.ok(authorLink.includes(`@${github}`));

    const avatar = authorLink.match(/<img\b[^>]*>/)?.[0];
    assert.ok(avatar, 'author link must render an avatar');
    assert.ok(avatar.includes(`src="https://github.com/${github}.png?size=80"`));
    assert.match(avatar, /\bwidth="32"/);
    assert.match(avatar, /\bheight="32"/);
    assert.match(avatar, /\bloading="lazy"/);
    assert.match(avatar, /\breferrerpolicy="no-referrer"/);
    assert.match(avatar, /\balt=""/);
    assert.match(card, /<h2\b[^>]*class="post-card__heading"[^>]*>\s*<span\b[^>]*class="post-card__title"[^>]*>[^<]+<\/span>\s*<\/h2>/);
    assert.doesNotMatch(card, /post-card__(?:summary|tags)/);

    let anchorDepth = 0;
    for (const anchor of card.match(/<\/?a\b[^>]*>/g) ?? []) {
      anchorDepth += anchor.startsWith('</') ? -1 : 1;
      assert.ok(anchorDepth >= 0 && anchorDepth <= 1, 'post card links must not be nested');
    }
    assert.equal(anchorDepth, 0, 'all post card links must close');
  }
});

test('blog page combines search and category filters and reports results in Korean', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.blog),
    readSource('src/pages/blog/index.astro'),
  ]);

  assert.match(html, /<h1\b[^>]*>블로그<\/h1>/);
  assert.match(html, /<p\b[^>]*\bclass="lede"[^>]*>ThorVG 학습 내용과 오픈소스 기여 경험, 그리고 다양한 이야기를 나눕니다\.<\/p>/);
  assert.match(
    html,
    /<span\b(?=[^>]*\bid="b-count")(?=[^>]*\brole="status")(?=[^>]*\baria-live="polite")(?=[^>]*\baria-atomic="true")[^>]*>\d+개 글<\/span>/
  );
  assert.match(html, /id="b-empty"[^>]*hidden[^>]*>[^<]*조건에 맞는 글이 없습니다\.<\/p>/);
  assert.match(source, /matchesSearch\s*&&\s*matchesTag/);
  assert.match(source, /card\.hidden\s*=\s*!matches/);
  assert.match(
    source,
    /shown\s*===\s*0[\s\S]*?0개 글 · 조건에 맞는 글이 없습니다\.[\s\S]*?\$\{shown\}개 글/,
    'zero results must be announced through the live status'
  );
});

test('blog cards derive body media and play Lottie on hover', async () => {
  const source = await readSource('src/pages/blog/index.astro');

  assert.match(source, /data-blog-lottie/);
  assert.match(source, /extractFirstMedia\(post\.body\)/);
  assert.match(source, /media\.type/);
  assert.match(source, /new URL\(src, document\.baseURI\)\.href/);
  assert.match(source, /mouseenter/);
  assert.match(source, /mouseleave/);
  assert.match(source, /focusin/);
  assert.match(source, /player\.play\(\)/);
  assert.match(source, /player\.pause\(\)/);
});

test('bundled blog writing guide uses its first image as card media', async () => {
  const html = await readPage(pages.blog);
  const card = [...html.matchAll(/<article\b(?=[^>]*\bclass="post-card")[^>]*>[\s\S]*?<\/article>/g)]
    .map(([article]) => article)
    .find((article) =>
      article.includes('블로그 글쓰는 방법') &&
      article.includes(`href="${sitePath('blog/blog-writing-guide')}"`));

  assert.ok(card, 'blog list must render the writing guide post');
  assert.match(card, /@Nor-s/);
  assert.match(card, /post-card__media--image/);
  assert.match(card, new RegExp(`src="${escapeRegExp(sitePath('blog-assets/blog-writing-guide/image.png'))}"`));
  assert.match(html, /<span\b(?=[^>]*\bid="b-count")[^>]*>\d+개 글<\/span>/);
});

test('blog detail template localizes navigation, date, and GitHub author metadata', async () => {
  const source = await readSource('src/pages/blog/[...slug].astro');

  assert.match(source, />← 블로그 목록<\/a>/);
  assert.match(source, /toLocaleDateString\('ko-KR',[\s\S]*?timeZone:\s*'UTC'/);
  assert.match(source, /href=\{`https:\/\/github\.com\/\$\{post\.data\.github\}`\}/);
  assert.match(source, /aria-label=\{`@\$\{post\.data\.github\} GitHub 프로필 \(새 창\)`\}/);
  assert.match(source, /src=\{`https:\/\/github\.com\/\$\{post\.data\.github\}\.png\?size=80`\}/);
  assert.doesNotMatch(source, /post\.data\.author/);
  assert.match(source, /post\.data\.tags\.map\(\(t\) => <li><span class="chip">#\{t\}<\/span><\/li>\)/);
});

test('blog article Lottie sources are normalized before the player loads', async () => {
  const [layout, astroConfig, css] = await Promise.all([
    readSource('src/layouts/Base.astro'),
    readSource('astro.config.mjs'),
    readSource('src/styles/global.css'),
  ]);

  assert.match(layout, /querySelectorAll\('\.prose lottie-player'\)/);
  assert.match(layout, /new URL\(src, document\.baseURI\)\.href/);
  assert.match(layout, /src="https:\/\/unpkg\.com\/@thorvg\/lottie-player@1\.0\.9\/dist\/lottie-player\.js"/);
  assert.doesNotMatch(layout, /@lottiefiles\//);
  assert.match(astroConfig, /remarkPlugins:\s*\[remarkAlert,\s*\[remarkLottieImages,\s*\{ base \}\]\]/);
  assert.match(css, /\.prose lottie-player\s*\{[^}]*background:\s*transparent/);
});

test('writing guide renders article media centered without stretching', async () => {
  const [html, css] = await Promise.all([
    readPage('blog/blog-writing-guide/index.html'),
    readSource('src/styles/global.css'),
  ]);
  assert.match(html, /<figure\b[^>]*class="media-figure"/);
  assert.match(html, new RegExp(`<img src="${escapeRegExp(sitePath('blog-assets/blog-writing-guide/image.png'))}"`));
  assert.match(css, /\.prose\s*\{[^}]*margin-inline:\s*auto/);
  assert.match(css, /\.prose figure\s*\{[^}]*display:\s*flex/);
  assert.match(css, /\.prose figure\s*\{[^}]*align-items:\s*center/);
  assert.match(css, /\.prose figure\s*\{[^}]*text-align:\s*center/);
  assert.match(css, /\.prose figure :where\(img,\s*lottie-player\)\s*\{[^}]*margin-inline:\s*auto/);
  assert.match(css, /\.prose img\s*\{[^}]*width:\s*auto[^}]*max-width:\s*100%[^}]*height:\s*auto/);
  assert.match(css, /\.prose figcaption\s*\{[^}]*color:\s*var\(--ink-subtle\)/);
});

test('writing guide collapses the repository Markdown workflow behind a summary', async () => {
  const [html, css] = await Promise.all([
    readPage('blog/blog-writing-guide/index.html'),
    readSource('src/styles/global.css'),
  ]);

  assert.match(html, /<details class="guide-details">/);
  assert.match(html, /<summary>저장소에 직접 Markdown으로 글쓰기<\/summary>/);
  assert.match(html, /<h2 id="파일-만들기">파일 만들기<\/h2>/);
  assert.match(css, /\.guide-details\s*\{/);
  assert.match(css, /\.guide-details\s*>\s*summary\s*\{/);
});

test('blog cards are borderless editorial entries with stable author metadata', async () => {
  const css = await readSource('src/styles/global.css');
  const card = css.match(/\.post-card\s*\{([^}]*)\}/)?.[1];
  const avatar = css.match(/(?:^|\n)\.author-avatar\s*\{([^}]*)\}/)?.[1];
  const chip = css.match(/\.chip\s*\{([^}]*)\}/)?.[1];

  assert.match(card, /min-width:\s*0/);
  assert.doesNotMatch(card, /background:/);
  assert.doesNotMatch(card, /border:/);
  assert.doesNotMatch(card, /padding:/);
  assert.match(avatar, /width:\s*32px/);
  assert.match(avatar, /height:\s*32px/);
  assert.match(avatar, /flex:\s*0 0 32px/);
  assert.match(css, /\.post-card:hover\s*, \.post-card:focus-within\s*\{[^}]*transform:\s*translateY\(-6px\)/);
  assert.match(css, /\.post-card__media\s*\{[^}]*aspect-ratio:\s*16\s*\/\s*9/);
  assert.match(css, /\.post-card__media\s*\{[^}]*border:\s*0/);
  assert.match(css, /\.post-card__media--fallback\s*\{/);
  assert.match(css, /\.post-card__media--fallback\s*\{[^}]*background:\s*#F7CBB9/);
  assert.match(css, /\.post-card:hover \.post-card__media[^\{]*\{[^}]*transform:\s*scale\(1\.07\)/);
  assert.match(css, /prefers-reduced-motion:\s*reduce[\s\S]*?\.post-card:hover/);
  assert.match(css, /\.post-card:hover \.post-card__title\s*, \.post-card:focus-within \.post-card__title\s*\{/);
  assert.match(css, /\.post-card__author:hover\s+\.post-card__author-name/);
  assert.match(chip, /max-width:\s*100%/);
  assert.match(chip, /white-space:\s*normal/);
  assert.match(chip, /overflow-wrap:\s*anywhere/);
});

test('hidden blog cards override the component display rule', async () => {
  const css = await readSource('src/styles/global.css');
  const hiddenCard = css.match(/\.post-card\[hidden\]\s*\{([^}]*)\}/)?.[1];

  assert.match(hiddenCard, /display:\s*none/);
  assert.doesNotMatch(hiddenCard, /!important/);
});

const readAiReviewNumbers = async () => {
  const files = await readdir(new URL('../ai-review-issue/core', import.meta.url));
  return new Set(files.filter((file) => file.endsWith('.md')).map((file) => file.split('-')[0]));
};

test('synchronised issues render links to their GitHub sources', async () => {
  const [html, liveSource] = await Promise.all([
    readPage(pages.issues),
    readSource('src/data/live-issues.json'),
  ]);
  const liveIssue = JSON.parse(liveSource).issues[0];

  if (liveIssue) {
    assert.match(
      html,
      new RegExp(`<a\\b(?=[^>]*class="issue-row")(?=[^>]*href="https://github\\.com/${escapeRegExp(liveIssue.repo)}/issues/${liveIssue.number}")`)
    );
  } else {
    assert.match(html, /<a\b(?=[^>]*class="issue-row")(?=[^>]*href="https:\/\/github\.com\/[^"]+\/issues\/\d+")/);
  }
});

test('AI review easter egg stays hidden until the thorvg/thorvg project is selected', async () => {
  const [html, source, liveSource, reviewedNumbers] = await Promise.all([
    readPage(pages.issues),
    readSource('src/pages/issues.astro'),
    readSource('src/data/live-issues.json'),
    readAiReviewNumbers(),
  ]);

  const reviewedIssue = JSON.parse(liveSource).issues.find(
    (issue) => issue.repo === 'thorvg/thorvg' && reviewedNumbers.has(String(issue.number))
  );
  if (reviewedIssue) {
    assert.match(
      html,
      new RegExp(`<a\\b(?=[^>]*class="issue-row")(?=[^>]*href="https://github\\.com/thorvg/thorvg/issues/${reviewedIssue.number}")(?=[^>]*data-review-href="${escapeRegExp(sitePath(`issues/${reviewedIssue.number}`))}")(?=[^>]*data-ai-score="\\d+")`)
    );
  }

  // 서버 렌더 기본값: 안내 문구와 정렬 UI는 숨겨진 채로 시작한다.
  assert.match(html, /<span\b(?=[^>]*id="issue-ai-note")(?=[^>]*hidden)[^>]*>/);
  assert.match(html, /GPT 5\.6 Sol ultra가 리뷰한 글을 볼 수 있습니다/);
  assert.match(html, /<div\b(?=[^>]*class="issue-sort")(?=[^>]*id="issue-sort")(?=[^>]*hidden)[^>]*>/);
  assert.match(html, /data-sort-key="number"[^>]*>이슈 번호</);
  assert.match(html, /data-sort-key="difficulty"[^>]*>난이도</);
  assert.match(html, /data-sort-dir="asc"[^>]*>오름차순</);
  assert.match(html, /data-sort-dir="desc"[^>]*>내림차순</);

  // 클라이언트 스크립트가 thorvg/thorvg 선택에서만 이스터에그를 켠다.
  assert.match(source, /selectedProject === 'thorvg\/thorvg'/);
  assert.match(source, /issue-list--ai/);
  assert.match(source, /난이도가 아직 없는\(리뷰되지 않은\) 이슈는 항상 위에 둔다/);
});

test('AI-reviewed thorvg issues render a review page with the GitHub source link', async () => {
  const reviewedNumbers = await readAiReviewNumbers();
  const [number] = [...reviewedNumbers].sort((a, b) => Number(a) - Number(b));
  assert.ok(number, 'at least one AI review markdown must exist');

  const html = await readPage(`issues/${number}/index.html`);
  assert.match(html, /AI 이슈 리뷰/);
  assert.match(html, new RegExp(`href="https://github\\.com/thorvg/thorvg/issues/${number}"`));
  assert.match(html, /이슈 목록/);
});

test('issues page keeps real issue links without a separate GitHub CTA', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.issues),
    readSource('src/pages/issues.astro'),
  ]);

  assert.doesNotMatch(html, /GitHub에서 실제 이슈 보기/);
  const issueRow = source.match(/<a\s+class="issue-row"[\s\S]*?data-search=\{searchText\}[\s\S]*?>/)?.[0];
  assert.doesNotMatch(issueRow, /aria-label=/);
  assert.match(source, /issueUrl\(row\)/);
  assert.doesNotMatch(source, /샘플 \$\{row\.number\}/);
  assert.match(source, /<span class="sr-only">\(새 창\)<\/span>/);
});

test('issues page filters by search and project only', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.issues),
    readSource('src/pages/issues.astro'),
  ]);
  assert.match(html, /class="issue-heading"/);
  assert.match(html, /class="issue-categories"/);
  assert.match(html, /data-project=""[^>]*>전체<\/button>/);
  assert.doesNotMatch(html, /\bid="issue-project"|\bid="issue-status"|\bid="issue-difficulty"/);
  assert.match(source, /data-project=\{row\.repo\}/);
  assert.match(source, /selectedProject/);
  assert.match(source, /\[data-project\]/);
});

test('issue rows expose optional mentoring metadata', async () => {
  const [html, liveSource] = await Promise.all([
    readPage(pages.issues),
    readSource('src/data/live-issues.json'),
  ]);
  const issueRows = html.match(/<(?:article|a)\b(?=[^>]*\bclass="issue-row")[^>]*>/g) ?? [];

  assert.ok(issueRows.length > 0, 'issues page must render issue rows');
  assert.match(html, /\bdata-project="thorvg\/[^\"]+"/);
  if (!JSON.parse(liveSource).issues.length) {
    assert.ok(html.includes('입문 추천'), 'recommended issues must contain the 입문 추천 badge');
  }
});

test('issues page reports results and empty state in Korean', async () => {
  const html = await readPage(pages.issues);

  assert.match(
    html,
    /<span\b(?=[^>]*\bid="issue-count")(?=[^>]*\brole="status")(?=[^>]*\baria-live="polite")(?=[^>]*\baria-atomic="true")[^>]*>\d+개 이슈<\/span>/
  );
  assert.match(html, /id="issue-empty"[^>]*hidden[^>]*>[^<]*조건에 맞는 이슈가 없습니다\.<\/p>/);
  assert.match(
    html,
    /shown\s*===\s*0[\s\S]*?0개 이슈 · 조건에 맞는 이슈가 없습니다\.[\s\S]*?\$\{shown\}개 이슈/,
    'zero results must be announced through the status text'
  );
  assert.match(
    html,
    /matchesSearch\s*&&\s*matchesProject/,
    'generated issue filter script must combine search and project conditions with AND'
  );
});

test('issue row metadata wraps long assignee names on narrow screens', async () => {
  const css = await readSource('src/styles/global.css');
  const side = css.match(/\.issue-row__side\s*\{([^}]*)\}/)?.[1];
  const assignee = css.match(/\.issue-row__assignee\s*\{([^}]*)\}/)?.[1];

  assert.match(side, /flex-wrap:\s*wrap/);
  assert.match(side, /min-width:\s*0/);
  assert.match(assignee, /white-space:\s*normal/);
  assert.match(assignee, /overflow-wrap:\s*anywhere/);
});

test('issue labels use the compact radius instead of a pill', async () => {
  const css = await readSource('src/styles/global.css');
  const label = css.match(/\.label\s*\{([^}]*)\}/)?.[1];
  const badge = css.match(/\.badge\s*\{([^}]*)\}/)?.[1];

  assert.match(label, /border-radius:\s*var\(--radius-sm\)/);
  assert.doesNotMatch(label, /var\(--radius-(?:pill|full)\)/);
  assert.match(badge, /border-radius:\s*var\(--radius-sm\)/);
  assert.doesNotMatch(badge, /var\(--radius-(?:pill|full)\)/);
});

test('theme toggle uses a semantic thumb color in both themes', async () => {
  const css = await readSource('src/styles/global.css');
  const light = css.match(/:root\s*\{([\s\S]*?)\n\}/)?.[1];
  const dark = css.match(/:root\[data-theme="dark"\]\s*\{([\s\S]*?)\n\}/)?.[1];
  const checkedThumb = css.match(/\.theme-toggle input:checked::after\s*\{([^}]*)\}/)?.[1];

  assert.match(light, /--toggle-thumb:\s*#FFFFFF/);
  assert.match(dark, /--toggle-thumb:\s*#241108/);
  assert.match(checkedThumb, /background:\s*var\(--toggle-thumb\)/);
  assert.match(checkedThumb, /border-color:\s*var\(--toggle-thumb\)/);
  assert.doesNotMatch(checkedThumb, /#FFFFFF/);
});

test('generated internal paths preserve the configured base separator', async () => {
  const [home, blog, playground] = await Promise.all([
    readPage(pages.home),
    readPage(pages.blog),
    readPage(pages.playground),
  ]);
  const html = home + blog + playground;

  assert.ok(html.includes(`href="${sitePath('blog')}"`));
  assert.ok(html.includes(`src="${sitePath('lottie/thorvg-sample.json')}"`));
  assert.ok(html.includes(`href="${sitePath('favicon.svg')}"`));

  if (baseSegment) {
    const baseWithoutSeparator = escapeRegExp(`/${baseSegment}`);
    assert.doesNotMatch(
      html,
      new RegExp(`(?:href|src)="${baseWithoutSeparator}(?:blog|lottie|favicon\\.svg)`)
    );
  }
});

test('playground bootstraps an absolute bundled sample with the shared pinned player', async () => {
  const [html, source, layout] = await Promise.all([
    readPage(pages.playground),
    readSource('src/pages/playground.astro'),
    readSource('src/layouts/Base.astro'),
  ]);
  const player = html.match(/<lottie-player\b(?=[^>]*\bid="lottie-player")[^>]*>/)?.[0];

  assert.ok(player, 'playground page must render a lottie-player immediately');
  assert.match(
    player,
    new RegExp(`\\bsrc="${escapeRegExp(sitePath('lottie/thorvg-sample.json'))}"`)
  );
  assert.match(player, /\bautoplay(?:="(?:true)?")?(?:\s|>)/);
  assert.match(player, /\bloop(?:="(?:true)?")?(?:\s|>)/);
  assert.match(player, /\bcontrols(?:="(?:true)?")?(?:\s|>)/);
  assert.match(
    layout,
    /<script\b(?=[^>]*\bsrc="https:\/\/unpkg\.com\/@thorvg\/lottie-player@1\.0\.9\/dist\/lottie-player\.js")(?=[^>]*\bintegrity="sha256-pcsL7ofeFadgXR45WR3bw\+LVMqffBtrurMlP1RDy0wA=")(?=[^>]*\bcrossorigin="anonymous")[^>]*><\/script>/
  );
  assert.match(source, /new URL\(sampleLottie, document\.baseURI\)\.href/);
  assert.match(source, /matchMedia\('\(prefers-reduced-motion: reduce\)'\)/);
  assert.match(source, /removeAttribute\('autoplay'\)/);
  assert.doesNotMatch(source, /@thorvg\/webcanvas/);
  assert.doesNotMatch(source, /\bnew\s+Function\b/);
});

test('playground reloads through the public player API and exposes loading failures', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.playground),
    readSource('src/pages/playground.astro'),
  ]);
  const loadFunction = source.match(/async function loadLottie\(src, nextObjectUrl\) \{[\s\S]*?\n      \}/)?.[0];

  assert.ok(loadFunction, 'playground must define the shared async load path');
  assert.match(loadFunction, /await player\.load\(src\)/);
  assert.doesNotMatch(loadFunction, /setAttribute\(['"]src/);
  assert.doesNotMatch(source, /var sampleUrl = player\.dataset\.sampleUrl/);
  assert.match(source, /addEventListener\('load'/);
  assert.match(source, /addEventListener\('error'/);
  assert.match(source, /setAttribute\('aria-busy', loading \? 'true' : 'false'\)/);
  assert.match(source, /fileInput\.disabled = loading/);
  assert.doesNotMatch(source, /resetButton|lottie-reset/);
  assert.match(source, /URL\.revokeObjectURL\(objectUrl\)/);
  assert.match(source, /addEventListener\('pagehide', revokeObjectUrl/);
  assert.match(source, /customElements\.whenDefined\('lottie-player'\)/);
  assert.match(source, /player\.play\(\)/);
  assert.match(source, /player\.pause\(\)/);
  assert.match(source, /stage\.getAttribute\('aria-busy'\) === 'true'/);
  assert.match(source, /window\.clearTimeout\(readyTimeout\)/);
  assert.match(
    html,
    /<p\b(?=[^>]*\bid="lottie-error")(?=[^>]*\brole="status")[^>]*>[\s\S]*?ThorVG Viewer[\s\S]*?<\/p>/
  );
});

test('playground keeps labeled Lottie controls compact without advanced or renderer settings', async () => {
  const [html, source, css] = await Promise.all([
    readPage(pages.playground),
    readSource('src/pages/playground.astro'),
    readSource('src/styles/global.css'),
  ]);

  for (const id of ['lottie-file', 'lottie-play', 'lottie-stop', 'lottie-speed', 'lottie-direction', 'lottie-loop', 'lottie-count', 'lottie-mode', 'lottie-autoplay', 'lottie-intermission', 'lottie-quality', 'lottie-background', 'lottie-frame']) {
    assert.ok(html.includes(`id="${id}"`), `playground must expose #${id}`);
  }
  assert.doesNotMatch(html, /샘플 다시 보기|id="lottie-reset"|고급 설정|id="lottie-renderer"/);
  assert.match(html, /<div\b[^>]*class="pg-controls"[^>]*>[\s\S]*?id="lottie-play"[\s\S]*?id="lottie-stop"/);
  for (const label of ['속도', '방향', '반복 횟수', '프레임']) {
    assert.match(html, new RegExp(`<label class="pg-inline-field">\\s*<span>${label}</span>`));
  }
  assert.match(css, /\.pg-inline-field\s*\{[^}]*height:\s*38px/);
  assert.match(source, /setPlayerAttribute\('speed'/);
  assert.match(source, /setPlayerAttribute\('direction'/);
  assert.doesNotMatch(source, /renderConfig|lottie-renderer|lottie-reset/);
  assert.match(source, /player\.setQuality/);
  assert.match(source, /player\.seek/);
});

test('playground embeds the exact hosted tools with matching fallback links', async () => {
  const html = await readPage(pages.playground);
  const urls = [
    'https://thorvg.github.io/thorvg.viewer/',
    'https://thorvg-playground.vercel.app/showcase/custom-transform',
    'https://thorvg-janitor.vercel.app/',
  ];
  const frames = html.match(/<iframe\b[^>]*>/g) ?? [];

  assert.equal(frames.length, urls.length, 'playground page must contain all hosted tool frames');
  for (const url of urls) {
    const encodedUrl = escapeRegExp(url);
    const frame = frames.find((candidate) => new RegExp(`\\bsrc="${encodedUrl}"`).test(candidate));
    const fallback = html.match(
      new RegExp(`<a\\b(?=[^>]*\\bhref="${encodedUrl}")(?=[^>]*\\btarget="_blank")[^>]*>`)
    )?.[0];

    assert.ok(frame, `${url} must be embedded`);
    assert.match(frame, /\btitle="[^"]+"/);
    assert.match(frame, /\bloading="lazy"/);
    assert.match(frame, /\breferrerpolicy="no-referrer"/);
    assert.match(
      frame,
      /\bsandbox="allow-scripts allow-same-origin allow-forms allow-downloads allow-modals allow-popups"/
    );
    assert.ok(fallback, `${url} must have a direct fallback link`);
    assert.match(fallback, /\brel="noopener noreferrer"/);
    assert.match(fallback, /\baria-label="[^"]*\(새 창\)"/);
  }
  const webCanvas = frames.find((frame) => frame.includes(urls[1]));
  assert.match(webCanvas, /\ballow="clipboard-write"/);
});

test('playground tabs expose their tab-panel relationships and keyboard controls', async () => {
  const [html, source] = await Promise.all([
    readPage(pages.playground),
    readSource('src/pages/playground.astro'),
  ]);
  const contracts = [
    ['tab-lottie', 'panel-lottie', 'true', '0'],
    ['tab-viewer', 'panel-viewer', 'false', '-1'],
    ['tab-webcanvas', 'panel-webcanvas', 'false', '-1'],
    ['tab-janitor', 'panel-janitor', 'false', '-1'],
  ];

  assert.match(html, /<aside\b[^>]*class="playground-sidebar"[^>]*>/);
  assert.match(html, /id="playground-sidebar-toggle"/);
  for (const label of ['LottiePlayer', 'ThorVG Viewer', 'WebCanvas', 'Janitor']) {
    assert.ok(html.includes(`>${label}</button>`), `playground must show ${label} as a tab`);
  }
  assert.doesNotMatch(html, /ThorVG 플레이그라운드/);
  assert.doesNotMatch(html, /Lottie 애니메이션을 재생하고/);

  for (const [tabId, panelId, selected, tabIndex] of contracts) {
    assert.match(
      html,
      new RegExp(`<button\\b(?=[^>]*\\bid="${tabId}")(?=[^>]*\\brole="tab")(?=[^>]*\\baria-controls="${panelId}")(?=[^>]*\\baria-selected="${selected}")(?=[^>]*\\btabindex="${tabIndex}")[^>]*>`)
    );
    assert.match(
      html,
      new RegExp(`<(?:section|div)\\b(?=[^>]*\\bid="${panelId}")(?=[^>]*\\brole="tabpanel")(?=[^>]*\\baria-labelledby="${tabId}")[^>]*>`)
    );
  }

  for (const key of ['ArrowLeft', 'ArrowRight', 'Home', 'End']) {
    assert.ok(source.includes(`'${key}'`), `tab keyboard handling must support ${key}`);
  }
  assert.match(source, /\.focus\(\)/);
  assert.match(source, /sidebar\.classList\.toggle\('is-compact'\)/);
});

test('playground styles use a desktop sidebar and a narrow-screen tool list', async () => {
  const css = await readSource('src/styles/global.css');
  const shell = css.match(/\.playground-shell\s*\{([^}]*)\}/)?.[1];
  const sidebar = css.match(/\.playground-sidebar\s*\{([^}]*)\}/)?.[1];
  const frame = css.match(/\.pg-frame\s*\{([^}]*)\}/)?.[1];
  const player = css.match(/\.pg-lottie-player\s*\{([^}]*)\}/)?.[1];

  assert.match(shell, /grid-template-columns:\s*auto\s+minmax\(0,\s*1fr\)/);
  assert.match(sidebar, /border-right:\s*1px\s+solid\s+var\(--hairline\)/);
  assert.match(css, /\.playground-sidebar\.is-compact\s*\{[^}]*width:\s*56px/);
  assert.match(css, /\.playground-workspace\s*\{[^}]*background:\s*var\(--canvas\)/);
  assert.match(css, /\.pg-stage\s*\{[^}]*background:\s*var\(--canvas\)/);
  assert.match(frame, /min-height:/);
  assert.match(frame, /width:\s*100%/);
  assert.match(frame, /border:\s*0/);
  assert.match(frame, /height:\s*calc\(100vh/);
  assert.match(css, /@media \(max-width:\s*760px\)[\s\S]*?\.playground-sidebar\s*\{[^}]*overflow-x:\s*auto/);
  assert.match(css, /@media \(max-width:\s*760px\)[\s\S]*?\.playground-tabs\s*\{[^}]*display:\s*flex/);
  assert.match(player, /width:\s*min\(320px,\s*100%\)/);
  assert.match(player, /height:\s*auto/);
  assert.match(player, /aspect-ratio:\s*1\s*\/\s*1/);
  assert.doesNotMatch(player, /height:\s*320px/);
  assert.doesNotMatch(css, /\.pg-editor\b/);
});

test('narrow screens preserve Korean headings and keep the Lottie stage compact', async () => {
  const css = await readSource('src/styles/global.css');
  const pageTitle = css.match(/\.page-title\s*\{([^}]*)\}/)?.[1];
  const mobile = css.match(/@media \(max-width:\s*520px\)\s*\{([\s\S]*?)\n\}/)?.[1];
  const narrowNav = css.match(/@media \(max-width:\s*400px\)\s*\{([\s\S]*?)\n\}/)?.[1];

  assert.match(pageTitle, /word-break:\s*keep-all/);
  assert.match(mobile, /\.pg-canvas-wrap\s*\{\s*min-height:\s*0/);
  assert.match(narrowNav, /\.nav__github\s*\{\s*display:\s*none/);
  assert.match(narrowNav, /\.nav__links\s*\{[^}]*grid-row:\s*2/);
  assert.match(css, /@media \(max-width:\s*760px\)[\s\S]*?\.nav__mark\s*\{\s*display:\s*none/);
  assert.match(css, /@media \(max-width:\s*760px\)[\s\S]*?\.nav__links\s*\{[^}]*gap:\s*10px/);
  assert.doesNotMatch(css, /\.nav__label--(?:compact|wide)/);
  assert.match(css, /\.sr-only\s*\{[^}]*clip:/);
});

test('WebCanvas gets the extended iframe height', async () => {
  const css = await readSource('src/styles/global.css');
  assert.match(css, /#panel-webcanvas \.pg-embed\s*\{[^}]*height:\s*calc\(100vh\s*-\s*108px\s*\+\s*300px\)/);
  assert.match(css, /@media \(max-width:\s*760px\)[\s\S]*?#panel-webcanvas \.pg-embed\s*\{[^}]*height:\s*calc\(100vh\s*-\s*160px\s*\+\s*300px\)/);
  assert.match(css, /#panel-webcanvas \.pg-embed\s*\{[^}]*overflow:\s*hidden/);
  assert.match(css, /#panel-webcanvas \.pg-frame\s*\{[^}]*width:\s*100%/);
  assert.doesNotMatch(css, /#panel-webcanvas \.pg-frame\s*\{[^}]*transform:/);
});

test('schedule page uses the official 2026 links and exact Korean dates', async () => {
  const [html, scheduleSource, pageSource, css] = await Promise.all([
    readPage(pages.schedule),
    readSource('src/data/schedule.ts'),
    readSource('src/pages/schedule.astro'),
    readSource('src/styles/global.css'),
  ]);
  const officialUrls = [
    'https://www.contribution.ac/2026ossca',
    'https://www.oss.kr/pages/10/4511',
  ];
  const dates = [
    '5월 12일 ~ 6월 14일',
    '6월 15일 ~ 17일',
    '6월 18일 ~ 24일',
    '6월 29일',
    '7월 11일',
    '7월 11일 ~ 8월 4일',
    '8월 3일 ~ 9일',
    '8월 15일 ~ 10월 24일',
    '9월 28일 ~ 10월 5일',
    '10월 13일 ~ 20일',
    '10월 24일',
    '12월 초',
  ];
  const datetimes = [
    '2026-05-12',
    '2026-06-15',
    '2026-06-18',
    '2026-06-29',
    '2026-07-11',
    '2026-07-11',
    '2026-08-03',
    '2026-08-15',
    '2026-09-28',
    '2026-10-13',
    '2026-10-24',
    '2026-12',
  ];

  for (const url of officialUrls) assert.ok(html.includes(url), `schedule page must link to ${url}`);
  for (const date of dates) assert.ok(html.includes(date), `schedule page must contain ${date}`);
  for (const label of ['멘티 모집', '발대식', '챌린저스', '마스터스', '성과공유회', '시상식']) {
    assert.ok(html.includes(label), `schedule page must contain the Korean label ${label}`);
  }
  assert.doesNotMatch(html, /\bTBD\b/i);
  assert.doesNotMatch(scheduleSource, /\btbd\b/i);
  assert.doesNotMatch(scheduleSource, /MilestoneState|\bstate\s*:/);
  assert.doesNotMatch(html, /tl-item__state|\bis-(?:done|current|upcoming)\b/);

  assert.match(
    html,
    /<nav\b(?=[^>]*\bclass="schedule-sources")(?=[^>]*\baria-label="공식 일정 출처")[^>]*>/
  );
  const timeElements = html.match(/<time\b[^>]*>[\s\S]*?<\/time>/g) ?? [];
  assert.deepEqual(
    timeElements.map((time) => time.match(/\bdatetime="([^"]+)"/)?.[1]),
    datetimes
  );

  const milestones = html.match(/\bdata-milestone="true"/g) ?? [];
  const milestoneLinks = html.match(/<a\b(?=[^>]*\bclass="tl-item__link")(?=[^>]*\btarget="_blank")[^>]*>/g) ?? [];
  assert.ok(milestones.length > 0, 'schedule page must render milestones');
  assert.equal(milestoneLinks.length, milestones.length, 'every milestone must link to an official source');
  for (const link of milestoneLinks) assert.match(link, /\baria-label="[^"]*\(새 창\)"/);

  assert.match(html, /<div\b(?=[^>]*\bclass="timeline-scroll")(?=[^>]*\bdata-timeline-scroll)(?=[^>]*\btabindex="0")[^>]*>/);
  assert.match(html, /<li\b(?=[^>]*\bclass="tl-item")(?=[^>]*\bdata-milestone="true")(?=[^>]*\bdata-datetime="2026-07-11")[^>]*>/);
  assert.match(pageSource, /querySelectorAll<HTMLElement>\('\.tl-item\[data-datetime\]'\)/);
  assert.match(pageSource, /new Date\(\)/);
  assert.match(pageSource, /timeline\.scrollTop\s*=/);
  assert.match(css, /\.timeline-scroll\s*\{[^}]*overflow-y:\s*auto/);
  assert.match(css, /\.timeline-scroll\s*\{[^}]*scrollbar-width:\s*none/);
  assert.match(css, /\.timeline-scroll::-webkit-scrollbar\s*\{\s*display:\s*none/);
});

test('ThorVG page is a concise Korean resource hub with the current Viewer link', async () => {
  const html = await readPage('thorvg/index.html');

  assert.match(html, /<h1\b[^>]*>ThorVG 자료<\/h1>/);
  for (const group of ['공식', '시작하기', '도구']) assert.ok(html.includes(`>${group}</h2>`));
  assert.ok(html.includes('https://thorvg.github.io/thorvg.viewer/'));
  assert.doesNotMatch(html, /https:\/\/www\.thorvg\.org\/viewer/);
});

test('ThorVG page exposes a hidden two-renderer Lottie diff and pixel comparison section', async () => {
  const [html, source, css] = await Promise.all([
    readPage('thorvg/index.html'),
    readSource('src/pages/thorvg.astro'),
    readSource('src/styles/global.css'),
  ]);

  assert.match(html, /<button\b(?=[^>]*\bid="thorvg-diff-toggle")[^>]*>[\s\S]*?Diff[\s\S]*?<\/button>/);
  assert.doesNotMatch(html, /thorvg\.web/);
  assert.match(html, /<section\b[^>]*class="resource-group"[\s\S]*?<h2[^>]*>도구<\/h2>[\s\S]*?<button\b[^>]*id="thorvg-diff-toggle"/);
  assert.match(html, /<section\b(?=[^>]*\bid="thorvg-diff")[^>]*\bhidden/);
  assert.match(
    html,
    new RegExp(`id="thorvg-diff"[^>]*data-sample-src="${escapeRegExp(sitePath('lottie/thorvg-sample.json'))}"`)
  );
  assert.match(html, /<lottie-player\b(?=[^>]*\bid="diff-thorvg")(?=[^>]*\bloop="true")(?![^>]*\bsrc=)[^>]*><\/lottie-player>/);
  for (const renderer of ['thorvg', 'airbnb', 'pixel-diff']) {
    assert.match(html, new RegExp(`data-diff-renderer="${renderer}"`));
  }
  assert.doesNotMatch(html, /data-diff-renderer="skottie"/);
  assert.match(html, /<canvas\b(?=[^>]*\bid="diff-pixel-canvas")[^>]*><\/canvas>/);
  assert.match(html, /id="diff-pixel-summary"/);
  assert.match(html, /<input\b(?=[^>]*\bid="diff-file")[^>]*\btype="file"/);
  assert.match(html, /<input\b(?=[^>]*\bid="diff-seek")[^>]*\btype="range"/);
  assert.match(html, /id="diff-play"/);
  assert.match(html, /id="diff-stop"/);
  assert.doesNotMatch(source, /skottie/i);
  assert.doesNotMatch(source, /canvaskit/i);
  assert.match(source, /URL\.createObjectURL/);
  assert.match(source, /URL\.revokeObjectURL/);
  assert.match(source, /await thorvg\.load\(src\)/);
  assert.doesNotMatch(source, /thorvg\.setAttribute\('src'/);
  assert.match(source, /waitFor\(\(\) => window\.lottie\)/);
  assert.match(source, /warmThorvgFrame/);
  assert.match(source, /thorvg\.currentFrame/);
  assert.match(source, /await waitForPaint\(\);\s*renderPixelDiff/);
  assert.match(source, /section\.scrollIntoView/);
  assert.match(source, /renderPixelDiff/);
  assert.match(source, /normalizeCanvasPixels/);
  assert.match(source, /getBoundingClientRect/);
  assert.match(source, /devicePixelRatio/);
  assert.match(source, /drawImage/);
  assert.match(source, /putImageData/);
  assert.match(source, /maxDelta/);
  assert.match(source, /unionAlpha/);
  assert.match(source, /collectBounds/);
  assert.match(source, /boundsDelta/);
  assert.match(source, /diff\s*>\s*0/);
  assert.match(source, /goToAndStop/);
  assert.match(source, /thorvg\.seek/);
  assert.match(source, /getImageData/);
  assert.match(source, /lottie-web@5\.13\.0\/build\/player\/lottie\.min\.js/);
  assert.match(css, /\.diff-grid\s*\{[^}]*grid-template-columns/);
  assert.match(css, /\.diff-color-readout\s*\{/);
});

test('deploy workflow checks the project and runs the full test build with the Pages base', async () => {
  const [workflow, packageSource] = await Promise.all([
    readSource('.github/workflows/deploy.yml'),
    readSource('package.json'),
  ]);
  const packageJson = JSON.parse(packageSource);

  assert.ok(packageJson.devDependencies?.['@astrojs/check']);
  assert.ok(packageJson.devDependencies?.typescript);
  assert.match(workflow, /- name: Check\s+run: npm run check/);
  assert.match(
    workflow,
    /- name: Test\s+run: npm test\s+env:[\s\S]*?BASE_PATH: \$\{\{ steps\.pages\.outputs\.base_path \}\}/
  );
  assert.doesNotMatch(workflow, /run: npm run build/);
  assert.ok(workflow.indexOf('- name: Check') < workflow.indexOf('- name: Test'));
  assert.ok(workflow.indexOf('- name: Test') < workflow.indexOf('- name: Upload artifact'));
});

test('discussion posts use their source discussion for Korean giscus comments', async () => {
  const [detail, comments, config, css] = await Promise.all([
    readSource('src/pages/blog/[...slug].astro'),
    readSource('src/components/GiscusComments.astro'),
    readSource('src/data/discussions-config.json'),
    readSource('src/styles/global.css'),
  ]);

  assert.match(detail, /<GiscusComments discussionNumber=\{post\.data\.discussionNumber\}/);
  assert.match(comments, /dataset\.mapping = 'number'/);
  assert.match(comments, /dataset\.term = String\(discussionNumber\)/);
  assert.match(comments, /dataset\.lang = 'ko'/);
  assert.match(comments, /MutationObserver/);
  assert.match(comments, /setConfig/);
  assert.match(comments, /discussionNumber/);
  assert.match(css, /\.article-comments\s*\{[^}]*width:\s*100%/);
  assert.doesNotMatch(css, /\.article-comments\s*\{[^}]*max-width/);
  assert.equal(JSON.parse(config).repo, 'OSSCA-thorvg/site');
});

test('blog write button opens the Blog discussion form', async () => {
  const blog = await readSource('src/pages/blog/index.astro');

  assert.match(blog, /href="https:\/\/github\.com\/OSSCA-thorvg\/site\/discussions\/new\?category=blog"/);
  assert.match(blog, /GitHub Discussion에서 새 블로그 글쓰기/);
  assert.doesNotMatch(blog, /\/new\/main\/src\/content\/blog/);
});
