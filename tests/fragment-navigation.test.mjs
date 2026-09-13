import test from 'node:test';
import assert from 'node:assert/strict';

import {
  decodeFragment,
  findHeadingAlias,
  findNavigationTarget,
} from '../src/lib/fragment-navigation.js';

test('decodeFragment decodes a URL hash and rejects missing or malformed fragments', () => {
  assert.equal(decodeFragment('#2-shape'), '2-shape');
  assert.equal(decodeFragment('#1-%EB%B9%84%ED%8A%B8%EB%A7%B5'), '1-비트맵');
  assert.equal(decodeFragment(''), null);
  assert.equal(decodeFragment('#'), null);
  assert.equal(decodeFragment('#%E0%A4%A'), null);
});

test('findHeadingAlias keeps an exact current-page anchor before considering aliases', () => {
  const headingIds = [
    '2-shape-구조',
    '2-shape',
  ];

  assert.equal(findHeadingAlias('2-shape', headingIds), '2-shape');
});

test('findHeadingAlias resolves only a unique current-page heading prefix', () => {
  assert.equal(
    findHeadingAlias('1-bitmap', ['1-bitmap-표현과-렌더링']),
    '1-bitmap-표현과-렌더링',
  );
  assert.equal(
    findHeadingAlias('2-shape', ['2-shape-fill', '2-shape-stroke']),
    null,
  );
});

test('findNavigationTarget resolves #2-shape from one matching document label', () => {
  const links = [
    { label: 'Picture', href: '/blog/mentoring/07-2-cpu-engine-paint' },
    { label: 'Shape', href: '/blog/mentoring/07-3-cpu-engine-shape' },
    { label: 'Font', href: '/blog/mentoring/07-4-cpu-engine-font' },
  ];

  assert.equal(
    findNavigationTarget(decodeFragment('#2-shape'), links),
    '/blog/mentoring/07-3-cpu-engine-shape',
  );
});

test('findNavigationTarget rejects an ambiguous document label', () => {
  const links = [
    { label: 'Shape', href: '/blog/mentoring/07-3-cpu-engine-shape' },
    { label: 'Shape', href: '/blog/reference/shape' },
  ];

  assert.equal(findNavigationTarget(decodeFragment('#2-shape'), links), null);
});
