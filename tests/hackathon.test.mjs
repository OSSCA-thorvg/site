import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

import {
  extractFirstImage,
  groupHackathons,
  parseNoticeDate,
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
});

test('the first markdown image becomes the card thumbnail', () => {
  assert.equal(
    extractFirstImage('인트로\n\n![썸네일](https://example.com/a.png "제목")\n![b](https://example.com/b.png)'),
    'https://example.com/a.png'
  );
  assert.equal(extractFirstImage('이미지 없음'), null);
  assert.equal(extractFirstImage('![x](javascript:alert(1))'), null);
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
  // 8월 회차: 공지(07-01) 이후 ~ 9월 공지(08-10) 이전 생성분. 최신순 정렬.
  assert.deepEqual(events[1].projects.map((project) => project.number), ['3', '2']);
  // 9월 회차: 9월 공지 이후 생성분. 첫 공지 이전 생성분(#1)은 어디에도 속하지 않는다.
  assert.deepEqual(events[0].projects.map((project) => project.number), ['4']);
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
    assert.ok(html.includes('aria-label="해커톤 회차"'));
    assert.ok(html.includes('id="hackathon-notice-title"'));
    // 참여하기 버튼은 Hackathon 라벨이 미리 채워진 이슈 생성 화면을 새 창으로 연다.
    assert.match(
      html,
      /<a\b(?=[^>]*\bclass="btn btn--primary")(?=[^>]*\bhref="https:\/\/github\.com\/[^"]+\/issues\/new\?labels=Hackathon")(?=[^>]*\btarget="_blank")(?=[^>]*\brel="noopener noreferrer")[^>]*>참여하기<\/a>/
    );
  }
});

test('hackathon board keeps the card and thumbnail contracts without a popup', async () => {
  const [board, css] = await Promise.all([
    readSource('src/components/HackathonBoard.astro'),
    readSource('src/styles/global.css'),
  ]);

  // 카드는 팝업이 아니라 블로그처럼 내부 상세 페이지로 이동한다.
  assert.match(board, /href=\{base \+ 'hackathon\/project\/' \+ project\.number\}/);
  assert.doesNotMatch(board, /<dialog\b|showModal|data-hackathon-trigger/);
  // 이슈 본문은 raw HTML을 제거한 뒤 렌더링한다.
  assert.match(board, /stripUnsafeMarkdown/);
  // 이미지 없는 카드는 렌더링된 본문을 썸네일로 쓰되 선택·클릭이 불가능해야 한다.
  assert.match(board, /hackathon-card__preview/);
  assert.match(css, /\.hackathon-card__preview \{[^}]*pointer-events: none;[^}]*user-select: none;/);
  // 노션형 비율: 미디어 7, 본문 3 (이미지 높이는 유지하고 본문만 축소).
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
