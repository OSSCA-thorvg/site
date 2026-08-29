import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

import {
  extractFirstImage,
  extractShowcases,
  groupHackathons,
  parseEndNoticeDate,
  parseNoticeDate,
  stripUnsafeMarkdown,
} from '../src/lib/hackathon.js';

const readPage = (path) =>
  readFile(new URL(`../dist/${path}`, import.meta.url), 'utf8');
const readSource = (path) =>
  readFile(new URL(`../${path}`, import.meta.url), 'utf8');

const issue = (overrides) => ({
  number: '1',
  title: '프로젝트',
  body: '',
  state: 'open',
  createdAt: '2026-07-01T00:00:00Z',
  labels: ['Hackathon'],
  assignees: [],
  url: 'https://github.com/OSSCA-thorvg/site/issues/1',
  ...overrides,
});

test('notice titles must end with a parenthesized date', () => {
  assert.equal(parseNoticeDate('OSSCAxThorVG Hackathon(2026-08-02)'), '2026-08-02');
  assert.equal(parseNoticeDate('OSSCAxThorVG Hackathon (2026-08-02) '), '2026-08-02');
  assert.equal(parseNoticeDate('OSSCAxThorVG Hackathon'), null);
  assert.equal(parseNoticeDate('(2026-08-02) OSSCAxThorVG Hackathon'), null);
  assert.equal(parseNoticeDate('OSSCAxThorVG Hackathon(2026-08-09)(END)'), null);
  assert.equal(parseEndNoticeDate('OSSCAxThorVG Hackathon(2026-08-09)(END)'), '2026-08-09');
  assert.equal(parseEndNoticeDate('OSSCAxThorVG Hackathon(2026-08-09) (end) '), '2026-08-09');
});

test('showcase links are read from the closing notice Repo and Link table', () => {
  const showcases = extractShowcases(`Repo | Link
-- | --
Hackathon-BeatVG | https://ossca-thorvg.github.io/Hackathon-BeatVG/
Color Swapper | [Play](https://ossca-thorvg.github.io/ThorVG_Lottie_Color_Swapper/)
Unsafe | javascript:alert(1)`);

  assert.deepEqual(showcases, [
    { repo: 'Hackathon-BeatVG', link: 'https://ossca-thorvg.github.io/Hackathon-BeatVG/' },
    { repo: 'Color Swapper', link: 'https://ossca-thorvg.github.io/ThorVG_Lottie_Color_Swapper/' },
  ]);
});

test('the first issue image becomes the project card thumbnail', () => {
  assert.equal(
    extractFirstImage('인트로\n\n![썸네일](https://example.com/a.png "제목")'),
    'https://example.com/a.png'
  );
  assert.equal(
    extractFirstImage('<img width="800" src="https://example.com/logo.png" />'),
    'https://example.com/logo.png'
  );
  assert.equal(extractFirstImage('![x](javascript:alert(1))'), null);
});

test('raw HTML is stripped except whitelisted <img> tags', () => {
  const tree = {
    type: 'root',
    children: [
      { type: 'html', value: '<script>alert(1)</script>' },
      { type: 'html', value: '<p align="center">\n<img width="800" alt="Logo" src="https://example.com/logo.png" />\n</p>' },
      { type: 'html', value: '<img src="javascript:alert(2)">' },
    ],
  };

  stripUnsafeMarkdown()(tree);

  assert.equal(tree.children.length, 1);
  const [image] = tree.children;
  assert.equal(image.data.hName, 'img');
  assert.equal(image.data.hProperties.src, 'https://example.com/logo.png');
  assert.equal(image.data.hProperties.width, '800');
  assert.equal(image.data.hProperties.alt, 'Logo');
  assert.match(image.data.hProperties.style, /margin-inline:auto/);
});

test('projects attach to the latest notice created before them', () => {
  const events = groupHackathons([
    issue({ number: '10', title: 'Hackathon(2026-08-02)', labels: ['Hackathon', 'Notice'], createdAt: '2026-07-01T00:00:00Z' }),
    issue({ number: '20', title: 'Hackathon(2026-09-02)', labels: ['Hackathon', 'Notice'], createdAt: '2026-08-10T00:00:00Z' }),
    issue({ number: '1', createdAt: '2026-06-30T00:00:00Z' }),
    issue({ number: '2', createdAt: '2026-07-15T00:00:00Z' }),
    issue({ number: '3', createdAt: '2026-08-03T00:00:00Z' }),
    issue({ number: '4', createdAt: '2026-08-20T00:00:00Z' }),
  ]);

  assert.deepEqual(events.map((event) => event.date), ['2026-09-02', '2026-08-02']);
  assert.equal(events[0].title, 'Hackathon');
  // August event: issues created after the July notice and before the September notice.
  assert.deepEqual(events[1].projects.map((project) => project.number), ['3', '2']);
  // September event: issues created after its notice; issue #1 predates every event.
  assert.deepEqual(events[0].projects.map((project) => project.number), ['4']);
});

test('an END notice closes the matching latest hackathon and supplies its showcases', () => {
  const events = groupHackathons([
    issue({ number: '10', title: 'OSSCAxThorVG Hackathon(2026-08-02)', labels: ['Hackathon', 'Notice'], createdAt: '2026-07-27T00:00:00Z' }),
    issue({
      number: '11',
      title: 'OSSCAxThorVG Hackathon(2026-08-09)(END)',
      labels: ['Notice', 'Hackathon'],
      createdAt: '2026-08-09T00:00:00Z',
      body: 'Repo | Link\n-- | --\nBeatVG | https://example.com/beatvg/',
    }),
  ]);

  assert.equal(events.length, 1);
  assert.equal(events[0].closingNotice.number, '11');
  assert.equal(events[0].endDate, '2026-08-09');
  assert.deepEqual(events[0].showcases, [{ repo: 'BeatVG', link: 'https://example.com/beatvg/' }]);
});

test('notice-labeled issues without a valid date are excluded entirely', () => {
  const events = groupHackathons([
    issue({ number: '10', title: 'Hackathon(2026-08-02)', labels: ['Hackathon', 'Notice'], createdAt: '2026-07-01T00:00:00Z' }),
    issue({ number: '11', title: '날짜 없는 공지', labels: ['Hackathon', 'Notice'], createdAt: '2026-07-02T00:00:00Z' }),
  ]);

  assert.equal(events.length, 1);
  assert.deepEqual(events[0].projects, []);
});

test('hackathon navigation sits last, after Assignments', async () => {
  const html = await readPage('index.html');
  const navigation = html.match(/<nav\b[^>]*class="nav__links"[^>]*>([\s\S]*?)<\/nav>/)?.[1];

  assert.ok(navigation);
  assert.match(navigation, />Assignments<\/a>\s*<a\b[^>]*>Hackathon<\/a>\s*$/);
});

test('hackathon page renders synced notices or the Korean empty state', async () => {
  const live = JSON.parse(await readSource('src/data/live-hackathon.json'));
  const events = groupHackathons(live.issues);
  const html = await readPage('hackathon/index.html');

  assert.ok(html.includes('<html lang="ko"'));
  if (events.length === 0) {
    assert.ok(html.includes('아직 공지된 해커톤이 없습니다.'));
  } else {
    assert.ok(html.includes('aria-label="해커톤과 출품작"'));
    assert.ok(html.includes('id="hackathon-notice-title"'));
    assert.ok(html.includes('id="hackathon-projects-title"'));
    assert.ok(html.includes('>Home</span>'));
    for (const project of events[0].projects) {
      assert.ok(html.includes(`hackathon/project/${project.number}`));
    }
    if (events[0].closingNotice) {
      assert.doesNotMatch(html, />참여하기<\/a>/);
      for (const showcase of events[0].showcases) {
        assert.ok(html.includes(`data-showcase-url="${showcase.link}"`));
      }
    } else {
      // Show the prefilled participation link only while the event is active.
      assert.match(
        html,
        /<a\b(?=[^>]*\bclass="btn btn--primary")(?=[^>]*\bhref="https:\/\/github\.com\/[^"]+\/issues\/new\?labels=Hackathon")(?=[^>]*\btarget="_blank")(?=[^>]*\brel="noopener noreferrer")[^>]*>참여하기<\/a>/
      );
    }
  }
});

test('hackathon project cards serve optimized local thumbnails', async () => {
  const html = await readPage('hackathon/index.html');
  const media = [...html.matchAll(/<div class="hackathon-card__media">([\s\S]*?)<\/div>/g)]
    .map((match) => match[1]);
  const thumbnails = media
    .map((content) => content.match(/<img\b[^>]*>/)?.[0])
    .filter(Boolean);

  assert.ok(thumbnails.length > 0, 'at least one project card must have a thumbnail');
  for (const thumbnail of thumbnails) {
    assert.match(thumbnail, /src="[^"]*\/hackathon-thumbnails\/\d+-[a-f0-9]{12}\.webp"/);
    assert.match(thumbnail, /width="640"/);
    assert.match(thumbnail, /height="360"/);
    assert.doesNotMatch(thumbnail, /github\.com\/user-attachments/);
  }
});

test('hackathon board uses a collapsible playground tree and one sandboxed showcase iframe', async () => {
  const [board, css] = await Promise.all([
    readSource('src/components/HackathonBoard.astro'),
    readSource('src/styles/global.css'),
  ]);

  assert.match(board, /<details class="hackathon-tree__event"/);
  assert.match(board, /<p class="hackathon-studio__label">Hackathon<\/p>/);
  assert.match(board, /<span>Home<\/span>/);
  assert.match(board, /class="hackathon-tree__item hackathon-showcase-trigger"/);
  assert.match(board, /id="hackathon-showcase-frame"/);
  assert.match(board, /href=\{base \+ 'hackathon\/project\/' \+ project\.number\}/);
  assert.match(board, /hackathon-card__preview/);
  assert.match(board, /sandbox="allow-scripts allow-same-origin allow-forms allow-downloads allow-modals allow-popups"/);
  assert.match(board, /referrerpolicy="no-referrer"/);
  assert.match(board, /stripUnsafeMarkdown/);
  assert.match(css, /\.hackathon-studio \{[^}]*grid-template-columns: 300px minmax\(0, 1fr\);/);
  assert.match(css, /\.hackathon-showcase__frame \{[^}]*height: calc\(100vh - 136px\);/);
  assert.match(css, /\.hackathon-card__preview \{[^}]*pointer-events: none;[^}]*user-select: none;/);
  assert.match(css, /\.hackathon-card__media \{[^}]*flex: 7 1 0;/);
  assert.match(css, /\.hackathon-card__body \{[^}]*flex: 3 1 0;/);
});

test('every synced project builds a detail page with utterances issue comments', async () => {
  const live = JSON.parse(await readSource('src/data/live-hackathon.json'));
  const projects = groupHackathons(live.issues).flatMap((event) => event.projects);

  for (const project of projects) {
    const html = await readPage(`hackathon/project/${project.number}/index.html`);

    assert.ok(html.includes('data-utterances-mount'), `#${project.number} must mount utterances`);
    assert.ok(html.includes('https://utteranc.es/client.js'));
    assert.ok(html.includes(project.url), `#${project.number} must link back to the GitHub issue`);
    for (const login of project.assignees) {
      assert.ok(html.includes(`@${login}`), `#${project.number} must list @${login}`);
    }
  }
});

test('deploy workflow syncs hackathon issues and rebuilds on issue events', async () => {
  const workflow = await readSource('.github/workflows/deploy.yml');

  assert.match(workflow, /node scripts\/sync-hackathon\.mjs/);
  assert.match(workflow, /issues:\n\s+types: \[opened, edited, deleted, closed, reopened, labeled, unlabeled, assigned, unassigned\]/);
});
