import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

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
