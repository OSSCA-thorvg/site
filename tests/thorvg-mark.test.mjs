import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const readSource = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('uses the traced ThorVG silhouette in every requested asset', async () => {
  const [favicon, mark, lottieSource] = await Promise.all([
    readSource('public/favicon.svg'),
    readSource('public/thorvg-mark.svg'),
    readSource('public/lottie/thorvg-sample.json'),
  ]);
  const lottie = JSON.parse(lottieSource);

  for (const [name, source] of [['favicon', favicon], ['mark', mark]]) {
    assert.equal((source.match(/<path\b/g) ?? []).length, 1, `${name} must have one traced mark path`);
    assert.doesNotMatch(source, /<circle\b|\bstroke=/, `${name} must not contain the legacy line-and-circle geometry`);
    assert.match(source, /C144\.373 37\.0515 112\.597 52\.8675 78\.8633 52\.9087/);
  }

  const shapeTypes = lottie.layers[0].shapes[0].it.map((shape) => shape.ty);
  assert.deepEqual(shapeTypes.filter((type) => type === 'sh'), ['sh']);
  assert.ok(!shapeTypes.includes('rc'), 'Lottie must not contain the legacy rounded rectangle');
  assert.equal(lottie.layers[0].shapes[0].it[0].nm, 'ThorVG mark path');
});

test('uses the animated mark for page branding without replacing the favicon', async () => {
  const [home, nav, layout, markLottieSource] = await Promise.all([
    readSource('src/pages/index.astro'),
    readSource('src/components/Nav.astro'),
    readSource('src/layouts/Base.astro'),
    readSource('public/lottie/thorvg-mark.json').catch(() => ''),
  ]);

  assert.ok(markLottieSource, 'the standalone mark Lottie must exist');
  assert.match(home, /<lottie-player\b[\s\S]*?data-lottie-mark/);
  assert.match(home, /<lottie-player\b(?=[^>]*data-lottie-mark)(?=[^>]*aria-hidden="true")[^>]*>/);
  assert.match(nav, /<img\b(?=[^>]*\bsrc=\{base \+ 'favicon\.svg'\})[^>]*>/);
  assert.doesNotMatch(nav, /<lottie-player\b/);
  assert.doesNotMatch(home, /favicon\.svg/);
  assert.match(layout, /@thorvg\/lottie-player@1\.0\.9\/dist\/lottie-player\.js/);
  assert.match(layout, /prefers-reduced-motion/);
  assert.match(
    layout,
    /querySelectorAll\('\[data-lottie-mark\]'\)[\s\S]*?new URL\(src, document\.baseURI\)\.href/
  );
  assert.ok(
    layout.indexOf("querySelectorAll('[data-lottie-mark]')") <
      layout.indexOf('src="https://unpkg.com/@thorvg/lottie-player'),
    'mark URLs must be normalized before the custom element is defined'
  );
  assert.match(layout, /customElements\.whenDefined\('lottie-player'\)/);
  assert.match(layout, /player\.play\(\)/);
  assert.match(layout, /player\.pause\(\)/);
  const markLottie = JSON.parse(markLottieSource);
  assert.equal(markLottie.nm, 'thorvg-mark');
  assert.equal(markLottie.layers[0].ty, 4);
  assert.equal(markLottie.layers[0].shapes[0].it[0].nm, 'ThorVG mark path');
});
