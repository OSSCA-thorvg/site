import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile, readdir } from 'node:fs/promises';

import { parseCsv } from '../src/lib/csv.js';
import { extractFirstMedia, resolveBlogMediaUrl } from '../src/lib/blog-media.js';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');
const removedFixtureAccount = ['Nor', 's'].join('-');

test('blog collection loads nested Markdown and defaults optional metadata', async () => {
  const config = await readSource('src/content.config.ts');

  assert.ok(
    config.includes("loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' })"),
    'blog loader must include nested .md and .mdx files'
  );

  for (const field of ['title', 'github', 'date']) {
    const schema = config.split(/\r?\n/).find((line) => line.trimStart().startsWith(`${field}:`));
    assert.ok(schema, `blog schema must define required ${field}`);
    assert.doesNotMatch(schema, /\.default\(/, `${field} must stay required`);
    assert.doesNotMatch(schema, /\.optional\(/, `${field} must stay required`);
  }

  assert.doesNotMatch(config, /^\s*author:/m, 'github must be the only writer identity field');
  assert.match(config, /^\s*summary:\s*z\.string\(\)\.default\(''\),$/m);
  assert.match(config, /^\s*tags:\s*z\.array\(z\.string\(\)\)\.default\(\[\]\),$/m);
  assert.match(config, /^\s*draft:\s*z\.boolean\(\)\.default\(false\),$/m);
  assert.match(config, /^\s*discussionNumber:\s*z\.number\(\)\.int\(\)\.positive\(\)\.optional\(\),$/m);
  assert.doesNotMatch(config, /^\s*cover:/m, 'blog media must come from the post body');
});

test('blog schema requires a GitHub username', async () => {
  const config = await readSource('src/content.config.ts');
  const githubSchema = config.split(/\r?\n/).find((line) => line.includes('github:'));

  assert.ok(githubSchema, 'blog schema must define github');
  assert.match(githubSchema, /z\.string\(\)/);
  assert.match(githubSchema, /\.trim\(\)/);
  assert.match(githubSchema, /\.min\(1\)/);
  assert.match(githubSchema, /\.regex\(/);
});

test('bundled blog content ships the writing guide and plain template only', async () => {
  const directory = new URL('../src/content/blog/', import.meta.url);
  const files = await readdir(directory, { recursive: true });
  const markdownFiles = files.filter((file) => (
    /\.(?:md|mdx)$/.test(file) && !/^discussion-\d+\.md$/.test(file)
  ));
  const [guide, template] = await Promise.all([
    readSource('src/content/blog/blog-writing-guide.md'),
    readSource('src/content/blog/TEMPLATE'),
  ]);

  assert.deepEqual(markdownFiles, ['blog-writing-guide.md']);
  assert.ok(files.includes('TEMPLATE'), 'blog directory must include an extensionless TEMPLATE file');
  assert.match(guide, /^---[\s\S]*?title: "블로그 글쓰는 방법"[\s\S]*?github: "Nor-s"[\s\S]*?tags: \["Notice"\][\s\S]*?---/);
  for (const requiredGuideText of [
    '주제는 자유롭게 정하셔도 됩니다',
    'ThorVG와 관련이 없어도 괜찮습니다',
    '오늘 공부한 내용',
    'ThorVG 분석에 관한 내용',
    '프로젝트 셋팅에 관한 내용',
    '이슈 분석 해결에 관한 글',
    '## Frontmatter 작성하기',
    '`title`',
    '`github`',
    '`date`',
    '`tags`',
    '`draft`',
    '## TEMPLATE 사용하기',
    '`src/content/blog/TEMPLATE`',
    '## 로컬에서 확인하기',
    'npm run dev',
    'npm run build',
    'npm run preview',
    '`dist/`',
    '`BASE_PATH=/site`',
    '경로와 다를 수 있습니다',
    '## 미디어 저장 위치',
    '경로는 항상 MDX 파일 위치 기준입니다',
    '`./cover.png`',
    '`src/content/blog/my-post.mdx`',
    '`src/content/blog/my-post/index.mdx`',
    '대괄호 안 텍스트는 캡션으로 표시됩니다',
    '`![렌더링 결과](./render-result.png)`',
    '## PR 보내기',
    'Create pull request',
    '<details className="guide-details">',
    '<summary>저장소에 직접 Markdown으로 글쓰기</summary>',
    '제목 끝에 `(WIP)`',
    '댓글도 같은 Discussion의 답글로 저장됩니다',
    '기능 추가 아이디어나 불편한 점이 있다면',
    'https://github.com/OSSCA-thorvg/site/issues/new',
    'https://github.com/OSSCA-thorvg/site',
  ]) {
    assert.ok(guide.includes(requiredGuideText), `writing guide must mention ${requiredGuideText}`);
  }
  assert.doesNotMatch(guide, /src\/content\/blog\/my-post-cover\.png/);
  assert.doesNotMatch(guide, /src\/content\/blog\/my-post-animation\.json/);
  assert.doesNotMatch(guide, /!\[대표 미디어\]/);
  assert.doesNotMatch(guide, /`publish` 라벨/);
  assert.doesNotMatch(guide, /Lottie|lottie|animation\.json|\/lottie\//i);
  assert.match(template, /^---\ntitle: "글 제목"\ngithub: "github-id"\ndate: \d{4}-\d{2}-\d{2}\ntags: \["thorvg", "study"\]\ndraft: false\n---/);
  assert.match(template, /!\[\]\(\.\/cover\.png\)/);
  assert.doesNotMatch(template, /!\[대표 미디어\]/);
  assert.match(template, /!\[캡션\]\(\.\/cover\.png\)/);
  assert.match(template, /src\/content\/blog\/my-post\/index\.mdx/);
  assert.match(template, /미디어 파일은 index\.mdx와 같은 폴더/);
  assert.doesNotMatch(template, /^\s*author:/m);
});

test('blog body media keeps Markdown Lottie sugar configured without fixture posts', async () => {
  const [readme, astroConfig] = await Promise.all([
    readSource('README.md'),
    readSource('astro.config.mjs'),
  ]);

  assert.doesNotMatch(readme, new RegExp(`\\b${removedFixtureAccount}\\b`, 'i'));
  assert.match(readme, /!\[\]\(\/lottie\/example\.json\)/);
  assert.match(readme, /!\[캡션\]\(\.\.\.\)/);
  assert.doesNotMatch(readme, /<lottie-player src="\/lottie\/example\.json"/);
  assert.match(astroConfig, /remarkPlugins:\s*\[remarkAlert,\s*\[remarkLottieImages,\s*\{ base \}\]\]/);
});

test('project docs and local data no longer expose the removed fixture account', async () => {
  const [readme, issuesCsv, liveSource] = await Promise.all([
    readSource('README.md'),
    readSource('src/data/issues.csv'),
    readSource('src/data/live-issues.json'),
  ]);
  const fixturePattern = new RegExp(`\\b${removedFixtureAccount}\\b`, 'i');
  const liveIssues = JSON.parse(liveSource).issues;

  assert.doesNotMatch(readme, fixturePattern);
  assert.doesNotMatch(issuesCsv, fixturePattern);
  assert.ok(
    liveIssues.every((issue) => issue.assignee !== removedFixtureAccount),
    'live issue assignees must not expose the removed fixture account'
  );
});

test('README documents automatic issue sync without manual issue or schedule chores', async () => {
  const readme = await readSource('README.md');

  assert.match(readme, /src\/data\/live-issues\.json/);
  assert.match(readme, /scripts\/sync-issues\.mjs/);
  assert.match(readme, /npm run preview\s+# 마지막 build 결과 확인/);
  assert.match(readme, /`preview`는 개발 서버가 아니라 이미 만들어진 `dist\/`만 보여줍니다/);
  assert.match(readme, /`BASE_PATH=\/site`/);
  assert.match(readme, /로컬 preview의 경로와 다를 수 있습니다/);
  assert.doesNotMatch(readme, /^## 이슈 추가$/m);
  assert.doesNotMatch(readme, /^## 일정 갱신$/m);
  assert.doesNotMatch(readme, /number,repo,title,labels,status,assignee,area,difficulty,recommended/);
});

test('blog body media parser supports Markdown images, GIFs, and Lottie image sugar', () => {
  assert.deepEqual(extractFirstMedia('![학습 그림](/images/study.png)'), {
    type: 'image',
    src: '/images/study.png',
    alt: '학습 그림',
  });
  assert.deepEqual(extractFirstMedia('![움짤](/images/demo.gif)'), {
    type: 'gif',
    src: '/images/demo.gif',
    alt: '움짤',
  });
  assert.deepEqual(extractFirstMedia('![Lottie 데모](/lottie/demo.json)'), {
    type: 'lottie',
    src: '/lottie/demo.json',
    alt: 'Lottie 데모',
  });
  assert.deepEqual(extractFirstMedia('![압축 Lottie](/lottie/demo.lottie)'), {
    type: 'lottie',
    src: '/lottie/demo.lottie',
    alt: '압축 Lottie',
  });
  assert.deepEqual(extractFirstMedia('<lottie-player src="/lottie/demo.json"></lottie-player>'), {
    type: 'lottie',
    src: '/lottie/demo.json',
    alt: '',
  });
  assert.equal(
    extractFirstMedia('```md\n![](./example.png)\n```'),
    null,
    'Markdown examples inside fenced code must not become card media'
  );
  assert.equal(
    extractFirstMedia('예시는 `![](./example.png)`처럼 작성합니다.'),
    null,
    'Markdown examples inside inline code must not become card media'
  );
});

test('blog media URLs support colocated post assets and root public assets', () => {
  assert.equal(resolveBlogMediaUrl('/lottie/demo.json', 'notes/rendering', '/site/'), '/site/lottie/demo.json');
  assert.equal(resolveBlogMediaUrl('./cover.png', 'notes/rendering', '/site/'), '/site/blog-assets/notes/cover.png');
  assert.equal(resolveBlogMediaUrl('animation.json', 'notes/rendering', '/site/'), '/site/blog-assets/notes/animation.json');
  assert.equal(resolveBlogMediaUrl('./my-post/animation.json', 'my-post', '/site/'), '/site/blog-assets/my-post/animation.json');
  assert.equal(resolveBlogMediaUrl('./cover.png', 'notes/rendering/index', '/site/'), '/site/blog-assets/notes/rendering/cover.png');
  assert.equal(resolveBlogMediaUrl('https://example.com/cover.png', 'notes/rendering', '/site/'), 'https://example.com/cover.png');
});

test('issue data includes valid mentoring metadata', async () => {
  const source = await readSource('src/data/issues.csv');
  const header = source.split(/\r?\n/, 1)[0].split(',');
  const rows = parseCsv(source);

  assert.deepEqual(header, [
    'number',
    'repo',
    'title',
    'labels',
    'status',
    'assignee',
    'area',
    'difficulty',
    'recommended',
  ]);
  assert.ok(rows.length > 0, 'at least one issue row is required');

  const difficulties = new Set(['beginner', 'intermediate', 'advanced']);
  const statuses = new Set(['todo', 'in-progress', 'done', 'open', 'merged', 'closed', 'draft']);
  const booleans = new Set(['true', 'false']);
  const issueKeys = new Set();

  for (const row of rows) {
    for (const field of ['number', 'repo', 'title', 'status']) {
      assert.ok(row[field]?.trim(), `issue row must have ${field}`);
    }
    const issueKey = `${row.repo}#${row.number}`;
    assert.ok(!issueKeys.has(issueKey), `issue key ${issueKey} must be unique`);
    issueKeys.add(issueKey);
    assert.ok(statuses.has(row.status), `issue #${row.number} has invalid status`);
    assert.ok(difficulties.has(row.difficulty), `issue #${row.number} has invalid difficulty`);
    assert.ok(booleans.has(row.recommended), `issue #${row.number} has invalid recommended value`);
    assert.match(row.number, /^[1-9]\d*$/, `issue #${row.number} must use a real GitHub issue number`);
    assert.notEqual(row.assignee, removedFixtureAccount, `issue #${row.number} must not use the removed fixture account`);
  }

  assert.ok(
    rows.some((row) => row.difficulty === 'beginner' && row.recommended === 'true'),
    'issue data must include a beginner recommendation'
  );
});
