import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const readPage = (path) => readFile(new URL(`../dist/${path}`, import.meta.url), 'utf8');
const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

const paginationMarkup = (id, pageSize) => new RegExp(
  `<nav\\b(?=[^>]*\\bid="${id}")(?=[^>]*\\bclass="pagination")(?=[^>]*\\bdata-page-size="${pageSize}")[^>]*>`,
);

test('blog and assignments share twelve-item pagination', async () => {
  const [blog, assignments, source] = await Promise.all([
    readPage('blog/index.html'),
    readPage('assignments/index.html'),
    readSource('src/components/PostListing.astro'),
  ]);

  for (const page of [blog, assignments]) {
    assert.match(page, paginationMarkup('post-pagination', 12));
    assert.match(page, /data-page-previous/);
    assert.match(page, /data-page-next/);
    assert.match(page, /data-page-status[^>]*role="status"[^>]*aria-live="polite"/);
  }

  assert.match(source, /const PAGE_SIZE = 12/);
  assert.match(source, /searchParams\.set\('page', String\(currentPage\)\)/);
  assert.match(source, /window\.history\.pushState/);
  assert.match(source, /window\.addEventListener\('popstate'/);
  assert.match(source, /search\.addEventListener\('input', \(\) => apply\(true\)\)/);
});

test('issues use twenty-item pagination after filtering and sorting', async () => {
  const [issues, source] = await Promise.all([
    readPage('issues/index.html'),
    readSource('src/pages/issues.astro'),
  ]);

  assert.match(issues, paginationMarkup('issue-pagination', 20));
  assert.match(issues, /data-page-previous/);
  assert.match(issues, /data-page-next/);
  assert.match(source, /const ISSUE_PAGE_SIZE = 20/);
  assert.match(source, /applySort\(thorvgMode\)[\s\S]*?list\.querySelectorAll\('\.issue-row'\)/);
  assert.match(source, /projects\.forEach[\s\S]*?apply\(true\)/);
  assert.match(source, /sortKeys\.forEach[\s\S]*?apply\(true\)/);
});

test('pagination follows the shared responsive and accessibility styles', async () => {
  const css = await readSource('src/styles/global.css');

  assert.match(css, /\.pagination\[hidden\]\s*\{\s*display:\s*none/);
  assert.match(css, /\.pagination__page\[aria-current="page"\]/);
  assert.match(css, /@media \(max-width: 520px\)[\s\S]*?\.pagination__summary\s*\{\s*display:\s*block/);
  assert.match(css, /@media \(pointer: coarse\)[\s\S]*?\.pagination__step[\s\S]*?min-height:\s*44px/);
});
