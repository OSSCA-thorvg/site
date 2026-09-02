import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');
const coreMembers = [
  'alpakaDurumi',
  'J-unStiN',
  'jeongsunyong',
  'DaengDo',
  'Saususge',
  'tcpark11',
];
const assignmentAuthors = [
  ...coreMembers,
  'autlyr21',
  'chae-dahee',
  'hd1534',
  'hwiskim',
  'inmare',
  'jinlee0310',
  'juyonLee00',
  'KimSH39',
  'mnchnk',
  'mungjin01',
  'nowgnuesLeee',
  'numkite',
  'seobinpark',
  'taejun0',
  'YoungB0',
  'zurdhva',
];
const requestedRepositories = [
  'thorvg/thorvg',
  'thorvg/thorvg.flutter',
  'thorvg/thorvg.example',
  'thorvg/thorvg.web',
];
const sortOptions = [
  ['issue-open', 'Issue Open'],
  ['issue-closed', 'Issue Closed'],
  ['issue-total', 'Issue 참여'],
  ['pr-open', 'PR Open'],
  ['pr-closed', 'PR Closed'],
  ['pr-merged', 'PR Merged'],
  ['pr-total', 'PR Total'],
  ['contribution-total', 'Total'],
];

test('hardcoded assignment authors cover the public ThorVG project family', async () => {
  const data = JSON.parse(await readSource('src/data/core-contributions.json'));

  assert.equal(data.organization, 'thorvg');
  assert.equal(data.contributionSince, '2026-06-01');
  assert.ok(!Number.isNaN(Date.parse(data.generatedAt)), 'the sync timestamp must be an ISO date');
  assert.deepEqual(data.coreMembers, coreMembers);
  assert.deepEqual(data.assignmentAuthors, assignmentAuthors);
  assert.deepEqual(data.members.map(({ name }) => name), assignmentAuthors);
  assert.ok(coreMembers.every((member) => assignmentAuthors.includes(member)));
  for (const repository of requestedRepositories) {
    assert.ok(data.repositories.includes(repository), `${repository} must be in the dashboard scope`);
  }
  assert.deepEqual(data.repositories, [...new Set(data.repositories)].sort());

  for (const member of data.members) {
    assert.equal(member.profile, `https://github.com/${member.name}`);
    assert.deepEqual(
      member.activities.map(({ updatedAt }) => updatedAt),
      [...member.activities]
        .sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt))
        .map(({ updatedAt }) => updatedAt),
      `${member.name} activities must be newest first`
    );

    for (const activity of member.activities) {
      assert.ok(
        new Date(activity.updatedAt) >= new Date(data.contributionSince),
        `${member.name} activity must be updated on or after ${data.contributionSince}`
      );
      assert.ok(data.repositories.includes(activity.repo));
      assert.ok(['issue', 'pullRequest'].includes(activity.kind));
      assert.ok(['open', 'closed', 'merged'].includes(activity.state));
      assert.equal(typeof activity.authored, 'boolean');
      assert.match(activity.url, new RegExp(`^https://github\\.com/${activity.repo}/(?:issues|pull)/${activity.number}$`));
      if (activity.kind === 'pullRequest') {
        assert.equal(activity.authored, true, 'the PR dashboard tracks PRs authored by the member');
      }
    }
  }
});

test('Home and Core mentoring reuse one dashboard with different repository scopes', async () => {
  const [home, mentoring, dashboard] = await Promise.all([
    readSource('src/pages/index.astro'),
    readSource('src/content/blog/Mentoring/01-DashBoard.mdx'),
    readSource('src/components/CoreProgressDashboard.astro'),
  ]);

  assert.match(home, /import CoreProgressDashboard from ['"]\.\.\/components\/CoreProgressDashboard\.astro['"]/);
  assert.match(home, /<CoreProgressDashboard scope="all" headingLevel="h2"\s*\/>/);
  assert.match(mentoring, /import CoreProgressDashboard from ['"]\.\.\/\.\.\/\.\.\/components\/CoreProgressDashboard\.astro['"]/);
  assert.match(mentoring, /<CoreProgressDashboard scope="core" headingLevel="h3">/);
  assert.match(dashboard, /activity\.repo === coreRepository/);
  assert.match(dashboard, /scope === 'all'/);
  assert.match(dashboard, /repositoryLabel\(item\)/);
  assert.match(dashboard, /data-dashboard-scope=\{scope\}/);
  assert.match(dashboard, /data-dashboard-repository-filter/);
  assert.match(dashboard, /data-dashboard-repository=\{repository\}/);
  assert.match(dashboard, /data-dashboard-sort-key=\{option\.key\}/);
  assert.match(dashboard, /applyRepositoryFilter/);
  assert.match(dashboard, /\.filter\(\(member\) => member\.total > 0\)/);
  assert.match(dashboard, /card\.hidden = total === 0/);
  assert.match(dashboard, /Number\(b\.dataset\.dashboardSortValue\) - Number\(a\.dataset\.dashboardSortValue\)/);
});

test('Home renders all hardcoded authors in Total order with project toggles', async () => {
  const [html, coreHtml, dataSource] = await Promise.all([
    readSource('dist/index.html'),
    readSource('dist/blog/mentoring/01-dashboard/index.html'),
    readSource('src/data/core-contributions.json'),
  ]);
  const data = JSON.parse(dataSource);
  const crossProjectActivity = data.members
    .flatMap(({ activities }) => activities)
    .find(({ repo }) => repo !== 'thorvg/thorvg');

  assert.match(html, /data-dashboard-scope="all"/);
  assert.ok(html.includes('ThorVG 기여 대시보드'));
  assert.ok(html.includes('thorvg.flutter'));
  assert.ok(html.includes('thorvg.example'));
  assert.ok(html.includes('thorvg.web'));
  assert.ok(html.includes('기여 프로젝트 필터'));
  assert.ok(html.includes('전체 끄기'));
  assert.ok(html.includes('내림차순'));
  for (const [key, label] of sortOptions) {
    assert.ok(html.includes(`data-dashboard-sort-key="${key}"`));
    assert.ok(html.includes(`>${label}</button>`));
  }
  assert.match(
    html,
    /<button\b(?=[^>]*class="[^"]*dashboard-sort__button[^"]*is-selected)(?=[^>]*aria-pressed="true")(?=[^>]*data-dashboard-sort-key="contribution-total")[^>]*>Total<\/button>/
  );
  for (const repository of data.repositories) {
    assert.ok(
      html.includes(`data-dashboard-repository="${repository}"`),
      `${repository} must have an ON/OFF toggle`
    );
  }

  const memberTags = html.match(/<article\b(?=[^>]*data-dashboard-member=)[^>]*>/g) ?? [];
  const renderedMembers = memberTags.map((tag) => ({
    name: tag.match(/data-dashboard-member="([^"]+)"/)?.[1],
    total: Number(tag.match(/data-dashboard-total="([^"]+)"/)?.[1]),
  }));
  const expectedMembers = data.members
    .map((member) => ({
      name: member.name,
      total: new Set(member.activities.map(({ url }) => url)).size,
    }))
    .filter(({ total }) => total > 0)
    .sort((a, b) =>
      b.total - a.total || a.name.localeCompare(b.name, 'en', { sensitivity: 'base' })
    );
  assert.deepEqual(renderedMembers, expectedMembers);

  const coreRenderedMembers = (coreHtml.match(/<article\b(?=[^>]*data-dashboard-member=)[^>]*>/g) ?? [])
    .map((tag) => tag.match(/data-dashboard-member="([^"]+)"/)?.[1]);
  assert.deepEqual(coreRenderedMembers, coreMembers);
  assert.doesNotMatch(coreHtml, /<nav\b[^>]*data-dashboard-repository-filter/);

  if (crossProjectActivity) {
    assert.ok(html.includes(crossProjectActivity.url));
    assert.ok(html.includes(crossProjectActivity.repo.replace('thorvg/', '')));
  }
});

test('scheduled Pages builds sync contribution data with read-only GitHub requests', async () => {
  const [script, workflow] = await Promise.all([
    readSource('scripts/sync-contributions.mjs'),
    readSource('.github/workflows/deploy.yml'),
  ]);

  assert.match(script, /https:\/\/api\.github\.com\/orgs\/\$\{organization\}\/repos/);
  assert.match(script, /https:\/\/api\.github\.com\/search\/issues/);
  assert.match(script, /org:\$\{organization\} involves:\$\{name\} updated:>=\$\{contributionSince\}/);
  assert.match(script, /GITHUB_TOKEN/);
  assert.match(script, /!repository\.fork && !repository\.private/);
  assert.match(script, /method: 'GET'/);
  assert.match(script, /const assignmentAuthors = \[/);
  assert.match(script, /const memberNames = assignmentAuthors/);
  assert.doesNotMatch(script, /collectContentFiles|frontmatterFor|hasAssignmentTag|readdir/);
  assert.doesNotMatch(script, /method: '(?:POST|PUT|PATCH|DELETE)'/);
  assert.match(workflow, /node scripts\/sync-contributions\.mjs/);
  assert.match(workflow, /pull-requests: read/);
});
