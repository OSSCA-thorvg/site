import test from 'node:test';
import assert from 'node:assert/strict';
import { access, readFile } from 'node:fs/promises';

import {
  parseDiscussionBody,
  isPublishedDiscussion,
  renderDiscussionMarkdown,
} from '../scripts/sync-discussions.mjs';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

const discussion = {
  number: 42,
  title: 'ThorVG 렌더링 기록',
  body: [
    '![](https://github.com/user-attachments/files/42/animation.json)',
    '',
    '## 살펴본 내용',
    '',
    '본문 안의 제목은 그대로 남아야 합니다.',
  ].join('\n'),
  createdAt: '2026-07-13T04:30:00Z',
  author: { login: 'contributor-id' },
  category: { name: 'Blog', id: 'DIC_category' },
  labels: { nodes: [{ name: 'Study' }] },
};

test('discussion summaries skip headings and images and come from the first paragraph', () => {
  assert.deepEqual(parseDiscussionBody(discussion.body), {
    summary: '본문 안의 제목은 그대로 남아야 합니다.',
    body: discussion.body,
  });
});

test('legacy form discussions keep only the 본문 section as their body', () => {
  const legacyBody = [
    '### 요약',
    '',
    '렌더링 파이프라인을 따라간 기록입니다.',
    '',
    '### 태그',
    '',
    'thorvg, lottie, study',
    '',
    '### 본문',
    '',
    '![](https://github.com/user-attachments/files/42/animation.json)',
    '',
    '## 살펴본 내용',
    '',
    '본문 안의 제목은 그대로 남아야 합니다.',
  ].join('\n');

  assert.deepEqual(parseDiscussionBody(legacyBody), {
    summary: '본문 안의 제목은 그대로 남아야 합니다.',
    body: [
      '![](https://github.com/user-attachments/files/42/animation.json)',
      '',
      '## 살펴본 내용',
      '',
      '본문 안의 제목은 그대로 남아야 합니다.',
    ].join('\n'),
  });
});

test('Blog discussions publish by default unless the title ends with WIP', () => {
  assert.equal(isPublishedDiscussion(discussion), true);
  assert.equal(isPublishedDiscussion({ ...discussion, category: { name: 'General' } }), false);
  assert.equal(isPublishedDiscussion({ ...discussion, labels: { nodes: [] } }), true);
  assert.equal(isPublishedDiscussion({ ...discussion, title: 'ThorVG 렌더링 기록 (WIP)' }), false);
  assert.equal(isPublishedDiscussion({ ...discussion, title: 'ThorVG 렌더링 기록 (wip)  ' }), false);
});

test('discussion tags come from labels only', () => {
  const labelled = {
    ...discussion,
    body: '두 가지 방법이 있습니다.\n\n1. Discussion에서 작성\n\n2. Markdown PR로 작성',
    labels: { nodes: [{ name: 'Notice' }, { name: 'Study' }] },
  };
  const output = renderDiscussionMarkdown(labelled);

  assert.match(output, /summary: "두 가지 방법이 있습니다\."/);
  assert.match(output, /tags: \["Notice","Study"\]/);
  assert.match(output, /두 가지 방법이 있습니다\.\n\n1\. Discussion에서 작성/);

  const unlabelled = renderDiscussionMarkdown({ ...labelled, labels: { nodes: [] } });
  assert.match(unlabelled, /tags: \[\]/);
});

test('discussion Markdown gets stable generated frontmatter', () => {
  const output = renderDiscussionMarkdown(discussion);

  assert.match(output, /^---\n/);
  assert.match(output, /title: "ThorVG 렌더링 기록"/);
  assert.match(output, /github: "contributor-id"/);
  assert.match(output, /date: "2026-07-13"/);
  assert.match(output, /summary: "본문 안의 제목은 그대로 남아야 합니다\."/);
  assert.match(output, /tags: \["Study"\]/);
  assert.match(output, /draft: false/);
  assert.match(output, /discussionNumber: 42/);
  assert.match(output, /## 살펴본 내용/);
});

test('repository no longer ships a Blog discussion form', async () => {
  await assert.rejects(
    access(new URL('../.github/DISCUSSION_TEMPLATE/blog.yml', import.meta.url)),
    undefined,
    'discussions must be written freeform without a form template'
  );
});

test('Pages build synchronizes discussion lifecycle changes without committing generated posts', async () => {
  const [workflow, gitignore] = await Promise.all([
    readSource('.github/workflows/deploy.yml'),
    readSource('.gitignore'),
  ]);

  assert.match(workflow, /discussion:\s*\n\s+types: \[created, edited, deleted, category_changed, labeled, unlabeled\]/);
  assert.match(workflow, /discussions: read/);
  assert.match(workflow, /node scripts\/sync-discussions\.mjs/);
  assert.match(gitignore, /src\/content\/blog\/discussion-\*\.md/);
  assert.doesNotMatch(workflow, /contents: write/);
});
