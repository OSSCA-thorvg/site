import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { createMarkdownProcessor } from '@astrojs/markdown-remark';
import { remarkAlert } from 'remark-github-blockquote-alert';
import remarkLottieImages from '../src/lib/remark-lottie-images.js';

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

test('Astro config and blog detail enable GitHub Alerts and Mermaid rendering', async () => {
  const [config, detail, css, packageSource] = await Promise.all([
    readSource('astro.config.mjs'),
    readSource('src/pages/blog/[...slug].astro'),
    readSource('src/styles/global.css'),
    readSource('package.json'),
  ]);
  const packageJson = JSON.parse(packageSource);

  assert.ok(packageJson.dependencies?.mermaid);
  assert.ok(packageJson.dependencies?.['remark-github-blockquote-alert']);
  assert.match(config, /import \{ remarkAlert \} from 'remark-github-blockquote-alert'/);
  assert.match(config, /remarkPlugins:\s*\[remarkAlert,\s*\[remarkLottieImages,\s*\{ base \}\]\]/);
  assert.match(detail, /import\('mermaid'\)/);
  assert.match(detail, /pre\[data-language="mermaid"\]/);
  assert.match(detail, /securityLevel:\s*'strict'/);
  assert.match(detail, /MutationObserver/);
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
