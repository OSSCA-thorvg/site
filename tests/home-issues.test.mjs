import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('home feature list uses the synchronised issue source', async () => {
  const source = await readSource('src/pages/index.astro');

  assert.match(source, /live-issues\.json/);
  assert.match(source, /const featuredIssues = liveIssues\.issues\.slice\(0, 4\)/);
  assert.match(source, />최근 업데이트 이슈<\/h2>/);
  assert.match(source, /href=\{issueUrl\(issue\)\}/);
  assert.doesNotMatch(source, /샘플 \$\{issue\.number\}/);
});
