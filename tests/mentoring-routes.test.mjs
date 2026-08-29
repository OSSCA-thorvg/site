import test from 'node:test';
import assert from 'node:assert/strict';
import { access } from 'node:fs/promises';

const mentoringPages = [
  '01-dashboard',
  '02-opensource-references',
  '03-cpp',
  '04-tools',
  '05-unittest',
  '06-loader',
];

test('Core2026 mentoring posts build under the correctly spelled URL', async () => {
  for (const slug of mentoringPages) {
    const page = new URL(`../dist/blog/mentoring/${slug}/index.html`, import.meta.url);
    await assert.doesNotReject(access(page), `/blog/mentoring/${slug}/ must be generated`);
  }
});
