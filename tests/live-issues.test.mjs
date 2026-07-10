import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');
const removedFixtureAccount = ['Nor', 's'].join('-');

test('syncs ThorVG issues through read-only GitHub API requests for scheduled Pages builds', async () => {
  const [syncSource, workflow, issuePage, liveSource] = await Promise.all([
    readSource('scripts/sync-issues.mjs').catch(() => ''),
    readSource('.github/workflows/deploy.yml'),
    readSource('src/pages/issues.astro'),
    readSource('src/data/live-issues.json'),
  ]);

  assert.ok(syncSource, 'the issue sync script must exist');
  assert.match(syncSource, /https:\/\/api\.github\.com\/orgs\/thorvg\/repos/);
  assert.match(syncSource, /\/repos\/\$\{repo\.full_name\}\/issues/);
  assert.match(syncSource, /GITHUB_TOKEN/);
  assert.match(syncSource, /updatedAt:\s*issue\.updated_at/);
  assert.match(syncSource, /removedFixtureAssignee\s*=\s*\['Nor',\s*'s'\]\.join\('-'\)/);
  assert.match(syncSource, /assignee:\s*assignee === removedFixtureAssignee \? '' : assignee/);
  assert.match(syncSource, /new Date\(b\.updatedAt\)\.getTime\(\) - new Date\(a\.updatedAt\)\.getTime\(\)/);
  assert.match(syncSource, /method:\s*'GET'/);
  assert.doesNotMatch(syncSource, /sample:\s*'false'/);
  assert.doesNotMatch(syncSource, /method:\s*'(?:POST|PUT|PATCH|DELETE)'/);
  assert.match(workflow, /schedule:\s*\n\s*- cron:/);
  assert.match(workflow, /node scripts\/sync-issues\.mjs/);
  assert.match(workflow, /contents:\s*read/);
  assert.match(issuePage, /live-issues\.json/);
  const issues = JSON.parse(liveSource).issues;
  assert.ok(issues.every((issue) => issue.updatedAt), 'synced issues must include their update time');
  assert.ok(
    issues.every((issue) => issue.assignee !== removedFixtureAccount),
    'synced issues must not expose the removed fixture account as assignee'
  );
  assert.ok(issues.every((issue) => !('sample' in issue)), 'synced issues must not keep fixture-only sample flags');
  assert.deepEqual(
    issues.map((issue) => issue.updatedAt),
    [...issues].sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt)).map((issue) => issue.updatedAt),
    'synced issues must be newest first across every project'
  );
});
