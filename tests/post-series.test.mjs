import test from 'node:test';
import assert from 'node:assert/strict';

import { createSeriesIndex, extractSeriesHeading, parseSeriesHeading } from '../src/lib/post-series.js';

test('series metadata comes from the first H1 or standalone bold heading outside code fences', () => {
  assert.equal(extractSeriesHeading([
    '```md',
    '# 가짜 시리즈 - 9',
    '```',
    '',
    '# **ThorVG 렌더링 흐름** - 1 #',
    '',
    '# 나중 H1 (2)',
  ].join('\n')), 'ThorVG 렌더링 흐름 - 1');
  assert.equal(
    extractSeriesHeading('**ThorVG 렌더링 흐름 - 1**\n\n본문입니다.'),
    'ThorVG 렌더링 흐름 - 1'
  );
  assert.equal(extractSeriesHeading('본문만 있습니다.\n\n## H2'), null);
});

test('series headings accept plain, hyphen, and parenthesis counters', () => {
  for (const [heading, name, number] of [
    ['공지 1', '공지', 1],
    ['ThorVG 렌더링 흐름 - 1', 'ThorVG 렌더링 흐름', 1],
    ['ThorVG 렌더링 흐름 -2', 'ThorVG 렌더링 흐름', 2],
    ['ThorVG 렌더링 흐름 (3)', 'ThorVG 렌더링 흐름', 3],
    ['ThorVG 렌더링 흐름 ( 4 )', 'ThorVG 렌더링 흐름', 4],
  ]) {
    assert.deepEqual(parseSeriesHeading(heading), {
      key: name.toLocaleLowerCase('ko-KR'),
      name,
      number,
    });
  }
});

test('ordinary or invalid H1 headings do not create a series', () => {
  for (const heading of [
    'ThorVG 렌더링 흐름',
    'ThorVG 렌더링 흐름1',
    'ThorVG 렌더링 흐름 - intro',
    'ThorVG 렌더링 흐름 (WIP)',
    'ThorVG 렌더링 흐름 - 0',
    '- 1',
  ]) {
    assert.equal(parseSeriesHeading(heading), null);
  }
});

test('series groups by the body H1 but links with frontmatter titles', () => {
  const index = createSeriesIndex([
    { id: 'third', title: '세 번째 frontmatter', heading: '동일한 이름 (3)' },
    { id: 'other', title: '다른 글', heading: '다른 이름 - 1' },
    { id: 'first', title: '첫 번째 frontmatter', heading: '동일한   이름 -1' },
    { id: 'second', title: '두 번째 frontmatter', heading: '동일한 이름 ( 2 )' },
  ]);
  const series = index.get('first');

  assert.deepEqual(series, {
    name: '동일한 이름',
    entries: [
      { id: 'first', title: '첫 번째 frontmatter', number: 1 },
      { id: 'second', title: '두 번째 frontmatter', number: 2 },
      { id: 'third', title: '세 번째 frontmatter', number: 3 },
    ],
  });
  assert.strictEqual(index.get('second'), series);
  assert.strictEqual(index.get('third'), series);
  assert.deepEqual(index.get('other')?.entries, [
    { id: 'other', title: '다른 글', number: 1 },
  ]);
});
