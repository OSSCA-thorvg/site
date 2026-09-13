import test from 'node:test';
import assert from 'node:assert/strict';

import { createSeriesIndex, extractSeriesHeading, parseSeriesHeading, getSeriesTrail } from '../src/lib/post-series.js';

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
    ['ThorVG 렌더링 흐름 - 0', 'ThorVG 렌더링 흐름', 0],
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

  assert.deepEqual({ name: series.name, entries: series.entries }, {
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


test('nested headings use > without splitting names containing slashes', () => {
  assert.deepEqual(parseSeriesHeading('Core2026  > Renderer Overview > Draw/Raster ( 2 )'), {
    key: 'core2026 > renderer overview > draw/raster',
    name: 'Core2026 > Renderer Overview > Draw/Raster',
    number: 2,
  });
  for (const heading of ['Core > > CPU - 1', '> CPU - 1', 'Core > - 1']) {
    assert.equal(parseSeriesHeading(heading), null);
  }
});

test('Markdown character references and escaped separators preserve nested series paths', () => {
  for (const separator of ['>', '&gt;', '&GT;', '&#62;', '&#x3e;', '\\>']) {
    for (const markdown of [
      `# Core2026 ${separator} Engine - 7`,
      `**Core2026 ${separator} Engine - 7**`,
    ]) {
      const heading = extractSeriesHeading(markdown);
      assert.equal(heading, 'Core2026 > Engine - 7', markdown);
      assert.deepEqual(parseSeriesHeading(heading), {
        key: 'core2026 > engine',
        name: 'Core2026 > Engine',
        number: 7,
      });
    }
  }
  assert.equal(extractSeriesHeading('# Core2026 &gt; Render &amp; Draw - 1'), 'Core2026 > Render & Draw - 1');
  assert.equal(extractSeriesHeading('# Core2026 &gt; &lt;Engine&gt; - 1'), 'Core2026 > <Engine> - 1');
  assert.equal(extractSeriesHeading('# Literal &amp;gt; - 1'), 'Literal &gt; - 1');
});

test('encoded Engine headings join the existing Core2026 tree regardless of post order', () => {
  const posts = [
    { id: 'overview', title: '[Core2026] Engine Overview', heading: extractSeriesHeading('# Core2026 &gt; Engine - 7') },
    { id: 'shape', title: '[Core2026] CPU Engine - Shape', heading: 'Core2026 > Engine > CPU Engine - 12' },
  ];

  for (const ordered of [posts, [...posts].reverse()]) {
    const index = createSeriesIndex(ordered);
    const root = index.get('overview');
    assert.equal(new Set(index.values()).size, 1);
    assert.strictEqual(root, index.get('shape'));
    assert.equal(root.name, 'Core2026');
    assert.deepEqual(getSeriesTrail(root, 'overview'), ['Core2026', 'Engine']);
    assert.deepEqual(getSeriesTrail(root, 'shape'), ['Core2026', 'Engine', 'CPU Engine']);
    assert.equal(root.children[0].children[0].id, 'overview');
  }
});

test('one root tree mixes legacy posts, nested groups and group introductions in number order', () => {
  const posts = [
    { id: 'draw', title: 'Draw', heading: 'Core2026 > Renderer Overview > CPU Renderer - 15' },
    { id: 'intro', title: 'Overview', heading: 'Core2026 > Renderer Overview - 7' },
    { id: 'loader', title: 'Loader case', heading: 'Core2026 > Issue - 6' },
    { id: 'dashboard', title: 'Dashboard', heading: 'Core2026 - 1' },
    { id: 'prepare', title: 'Prepare', heading: 'core2026 > Renderer Overview > CPU Renderer - 14' },
    { id: 'other', title: 'Other', heading: 'Other > CPU Renderer - 1' },
  ];
  const index = createSeriesIndex(posts);
  const root = index.get('draw');
  assert.equal(new Set(index.values()).size, 2);
  assert.strictEqual(index.get('loader'), root);
  assert.deepEqual(root.children.map((node) => node.name ?? node.id), ['dashboard', 'Issue', 'Renderer Overview']);
  const renderer = root.children[2];
  assert.equal(renderer.children[0].id, 'intro');
  assert.equal(renderer.children[1].name, 'CPU Renderer');
  assert.deepEqual(renderer.children[1].entries.map((entry) => entry.id), ['prepare', 'draw']);
  assert.equal(root.entries.length, 5);
  assert.deepEqual(getSeriesTrail(root, 'draw'), ['Core2026', 'Renderer Overview', 'CPU Renderer']);
  assert.deepEqual(getSeriesTrail(root, 'dashboard'), ['Core2026']);
  assert.deepEqual(getSeriesTrail(root, 'missing'), []);
  assert.deepEqual(getSeriesTrail(null, 'draw'), []);
  const reordered = createSeriesIndex([posts[0], ...posts.slice(1).reverse()]).get('draw');
  assert.deepEqual(reordered.children, root.children);
});

test('identically named groups under different parents stay separate and sibling numbering can restart', () => {
  const index = createSeriesIndex([
    { id: 'one', title: 'one', heading: 'Core > First > CPU - 1' },
    { id: 'two', title: 'two', heading: 'Core > Second > CPU - 1' },
    { id: 'zero', title: 'zero', heading: 'Core > First > CPU - 0' },
  ]);
  const root = index.get('one');
  assert.equal(root.children.length, 2);
  assert.deepEqual(root.children[0].children[0].entries.map((entry) => entry.id), ['zero', 'one']);
  assert.deepEqual(root.children[1].children[0].entries.map((entry) => entry.id), ['two']);
});
