import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

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
  ].join('\n'),
  createdAt: '2026-07-13T04:30:00Z',
  author: { login: 'contributor-id' },
  category: { name: 'Blog', id: 'DIC_category' },
  labels: { nodes: [{ name: 'Study' }] },
};

test('discussion form fields become blog metadata without truncating body headings', () => {
  assert.deepEqual(parseDiscussionBody(discussion.body), {
    summary: '렌더링 파이프라인을 따라간 기록입니다.',
    tags: ['thorvg', 'lottie', 'study'],
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

test('freeform discussions keep their full body and derive summary and label tags', () => {
  const freeform = {
    ...discussion,
    body: '두 가지 방법이 있습니다.\n\n1. Discussion에서 작성\n\n2. Markdown PR로 작성',
    labels: { nodes: [{ name: 'Notice' }, { name: 'Study' }] },
  };
  const output = renderDiscussionMarkdown(freeform);

  assert.match(output, /summary: "두 가지 방법이 있습니다\."/);
  assert.match(output, /tags: \["Notice","Study"\]/);
  assert.match(output, /두 가지 방법이 있습니다\.\n\n1\. Discussion에서 작성/);
});

test('discussion Markdown gets stable generated frontmatter', () => {
  const output = renderDiscussionMarkdown(discussion);

  assert.match(output, /^---\n/);
  assert.match(output, /title: "ThorVG 렌더링 기록"/);
  assert.match(output, /github: "contributor-id"/);
  assert.match(output, /date: "2026-07-13"/);
  assert.match(output, /summary: "렌더링 파이프라인을 따라간 기록입니다\."/);
  assert.match(output, /tags: \["thorvg","lottie","study"\]/);
  assert.match(output, /draft: false/);
  assert.match(output, /discussionNumber: 42/);
  assert.match(output, /## 살펴본 내용/);
});

test('repository provides a Korean Blog discussion form', async () => {
  const form = await readSource('.github/DISCUSSION_TEMPLATE/blog.yml');

  assert.match(form, /label: 요약/);
  assert.match(form, /label: 태그/);
  assert.match(form, /label: 본문/);
  assert.match(form, /required: true/);
});

test('Pages build synchronizes discussion lifecycle changes without committing generated posts', async () => {
  const [workflow, gitignore] = await Promise.all([
    readSource('.github/workflows/deploy.yml'),
    readSource('.gitignore'),
  ]);

  assert.match(workflow, /discussion:\s*\n\s+types: \[created, edited, deleted, category_changed\]/);
  assert.match(workflow, /discussions: read/);
  assert.match(workflow, /node scripts\/sync-discussions\.mjs/);
  assert.match(gitignore, /src\/content\/blog\/discussion-\*\.md/);
  assert.doesNotMatch(workflow, /contents: write/);
  assert.doesNotMatch(workflow, /labeled|unlabeled/);
});
