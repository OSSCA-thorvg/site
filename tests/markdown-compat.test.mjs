import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { createMarkdownProcessor, rehypeHeadingIds } from '@astrojs/markdown-remark';
import { remarkAlert } from 'remark-github-blockquote-alert';
import remarkLottieImages from '../src/lib/remark-lottie-images.js';
import remarkGithubVideos from '../src/lib/remark-github-videos.js';
import remarkSeriesHeading from '../src/lib/remark-series-heading.js';
import rehypeHeadingAnchors from '../src/lib/rehype-heading-anchors.js';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('GitHub Alert syntax renders with the shared Markdown processor', async () => {
  const processor = await createMarkdownProcessor({ remarkPlugins: [remarkAlert] });
  const result = await processor.render('> [!NOTE]\n> 사이트에서도 GitHub처럼 표시됩니다.');

  assert.match(result.code, /class="markdown-alert markdown-alert-note"/);
  assert.match(result.code, /class="markdown-alert-title"/);
  assert.match(result.code, />NOTE</);
  assert.match(result.code, /사이트에서도 GitHub처럼 표시됩니다\./);
});

test('Mermaid fences stay identifiable for lazy browser rendering', async () => {
  const processor = await createMarkdownProcessor({});
  const result = await processor.render('```mermaid\ngraph TD\n  A --> B\n```');

  assert.match(result.code, /<pre\b[^>]*data-language="mermaid"/);
  assert.match(result.code, /graph TD/);
});

test('Markdown images render as responsive figures instead of MDX-only placeholders', async () => {
  const processor = await createMarkdownProcessor({
    remarkPlugins: [[remarkLottieImages, { base: '/' }]],
  });
  const result = await processor.render('![렌더링 결과](image.png)', {
    fileURL: new URL('../src/content/blog/blog-writing-guide.md', import.meta.url),
  });

  assert.match(result.code, /<figure class="media-figure">/);
  assert.match(result.code, /<img src="\/blog-assets\/image\.png" alt="렌더링 결과" loading="lazy" decoding="async">/);
  assert.match(result.code, /<figcaption>렌더링 결과<\/figcaption>/);
});

test('standalone GitHub attachment and video-extension URLs render as players', async () => {
  const processor = await createMarkdownProcessor({ remarkPlugins: [remarkGithubVideos] });
  const attachment = 'https://github.com/user-attachments/assets/0f5b4e42-9d4a-4819-b8b3-0d4a8302e6a5';
  const result = await processor.render([
    '데모 영상입니다.',
    '',
    attachment,
    '',
    'https://example.com/clip.mp4',
    '',
    '문장 속 [링크](https://example.com/inline.mp4)는 그대로 둡니다.',
    '',
    'https://example.com/page',
  ].join('\n'));

  assert.match(result.code, new RegExp(`<video src="${attachment}" controls preload="metadata" playsinline`));
  assert.match(result.code, /<video src="https:\/\/example\.com\/clip\.mp4"/);
  assert.match(result.code, /<a href="https:\/\/example\.com\/inline\.mp4">링크<\/a>/);
  assert.match(result.code, /<a href="https:\/\/example\.com\/page">/);
});

test('the first series H1 becomes metadata instead of rendered article content', async () => {
  const processor = await createMarkdownProcessor({ remarkPlugins: [remarkSeriesHeading] });
  const series = await processor.render([
    '# ThorVG 렌더링 흐름 - 1',
    '',
    '본문입니다.',
    '',
    '# 나중 H1은 유지',
  ].join('\n'));
  const boldSeries = await processor.render([
    '**ThorVG 렌더링 흐름 - 1**',
    '',
    '본문입니다.',
  ].join('\n'));
  const plainSeries = await processor.render('# 공지 1\n\n공지 본문입니다.');
  const zeroSeries = await processor.render('**ThorVG 렌더링 흐름 - 0**\n\n0번 본문입니다.');
  const ordinary = await processor.render('# 일반 글 제목\n\n본문입니다.');

  assert.doesNotMatch(series.code, /ThorVG 렌더링 흐름/);
  assert.doesNotMatch(boldSeries.code, /ThorVG 렌더링 흐름/);
  assert.doesNotMatch(plainSeries.code, /<h1[^>]*>공지 1<\/h1>/);
  assert.match(plainSeries.code, /<p>공지 본문입니다\.<\/p>/);
  assert.doesNotMatch(zeroSeries.code, /ThorVG 렌더링 흐름/);
  assert.match(zeroSeries.code, /<p>0번 본문입니다\.<\/p>/);
  assert.match(boldSeries.code, /<p>본문입니다\.<\/p>/);
  assert.match(series.code, /<h1 id="나중-h1은-유지">나중 H1은 유지<\/h1>/);
  assert.match(ordinary.code, /<h1 id="일반-글-제목">일반 글 제목<\/h1>/);
});

test('body headings render accessible permalink anchors with their existing IDs', async () => {
  const processor = await createMarkdownProcessor({
    rehypePlugins: [rehypeHeadingIds, rehypeHeadingAnchors],
  });
  const result = await processor.render([
    '# 글 제목',
    '',
    '## 렌더링 흐름',
    '',
    '#### 세부 단계',
  ].join('\n'));

  assert.match(result.code, /<h1 id="글-제목">글 제목<\/h1>/);
  assert.match(result.code, /<h2 id="렌더링-흐름">렌더링 흐름<a class="heading-anchor" href="#렌더링-흐름" aria-label="렌더링 흐름 섹션 링크"/);
  assert.match(result.code, /<h4 id="세부-단계">세부 단계<a class="heading-anchor" href="#세부-단계" aria-label="세부 단계 섹션 링크"/);
  assert.match(result.code, /<svg[^>]*aria-hidden="true"[^>]*focusable="false"/);
});

test('Astro config and blog detail enable GitHub Alerts and Mermaid rendering', async () => {
  const [config, detail, mermaidComponent, css, packageSource] = await Promise.all([
    readSource('astro.config.mjs'),
    readSource('src/pages/blog/[...slug].astro'),
    readSource('src/components/MermaidDiagrams.astro'),
    readSource('src/styles/global.css'),
    readSource('package.json'),
  ]);
  const packageJson = JSON.parse(packageSource);

  assert.ok(packageJson.dependencies?.mermaid);
  assert.ok(packageJson.dependencies?.['remark-github-blockquote-alert']);
  assert.match(config, /import \{ remarkAlert \} from 'remark-github-blockquote-alert'/);
  assert.match(config, /remarkPlugins:\s*\[remarkAlert,\s*\[remarkLottieImages,\s*\{ base \}\],\s*remarkGithubVideos,\s*remarkSeriesHeading\]/);
  assert.match(config, /\[rehypeHeadingAnchors,\s*\{ contentPath: 'src\/content\/blog\/' \}\]/);
  assert.match(css, /\.prose video/);
  assert.match(css, /\.prose \.heading-anchor/);
  assert.match(detail, /<MermaidDiagrams \/>/);
  assert.match(mermaidComponent, /import\('mermaid'\)/);
  assert.match(mermaidComponent, /pre\[data-language="mermaid"\]/);
  assert.match(mermaidComponent, /securityLevel:\s*'strict'/);
  assert.match(mermaidComponent, /MutationObserver/);
  assert.match(css, /\.markdown-alert-note/);
  assert.match(css, /\.markdown-alert-caution/);
  assert.match(css, /\.mermaid-diagram/);
});

test('writing guide documents the supported GitHub Alert and Mermaid syntax', async () => {
  const guide = await readSource('src/content/blog/blog-writing-guide.md');

  assert.match(guide, /> \[!NOTE\]/);
  assert.match(guide, /```mermaid/);
  assert.match(guide, /NOTE`, `TIP`, `IMPORTANT`, `WARNING`, `CAUTION`/);
});
