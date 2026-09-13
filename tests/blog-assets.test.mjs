import test from 'node:test';
import assert from 'node:assert/strict';
import { access, readFile, readdir } from 'node:fs/promises';

const dist = new URL('../dist/', import.meta.url);
const base = `/${(process.env.BASE_PATH || '').replace(/^\/+|\/+$/g, '')}/`.replace('//', '/');
const origin = 'https://site.test';
const attribute = (tag, name) => tag.match(new RegExp(`\\b${name}="([^"]*)"`))?.[1]
  ?.replaceAll('&amp;', '&').replaceAll('&quot;', '"').replaceAll('&#39;', "'");

async function* pages(directory) {
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const location = new URL(entry.name + (entry.isDirectory() ? '/' : ''), directory);
    if (entry.isDirectory()) yield* pages(location);
    else if (entry.name.endsWith('.html')) yield location;
  }
}

async function checkLocal(reference, page, route = false) {
  const relativePage = page.href.slice(dist.href.length);
  const url = new URL(reference, origin + base + relativePage);
  if (url.origin !== origin) return;
  assert.ok(url.pathname.startsWith(base), `URL must respect BASE_PATH: ${reference}`);
  let relative = url.pathname.slice(base.length);
  if (route && !relative.endsWith('.html')) relative = relative.replace(/\/$/, '') + '/index.html';
  await assert.doesNotReject(access(new URL(relative, dist)), `${page.pathname}: missing ${reference}`);
}

test('blog series links resolve to generated pages', async () => {
  for await (const page of pages(new URL('blog/', dist))) {
    const html = await readFile(page, 'utf8');
    for (const [tag] of html.matchAll(/<a\b[^>]*data-series-topic[^>]*>/g)) {
      const href = attribute(tag, 'href');
      assert.ok(href, `${page.pathname}: series link needs href`);
      await checkLocal(href, page, true);
    }
  }
});

test('blog TMath players reference existing assets', async () => {
  for await (const page of pages(new URL('blog/', dist))) {
    const html = await readFile(page, 'utf8');
    for (const [player] of html.matchAll(/<tmath-player\b[^>]*>[\s\S]*?<\/tmath-player>/g)) {
      const tag = player.slice(0, player.indexOf('>') + 1);
      const scene = attribute(tag, 'data-scene');
      const source = attribute(tag, 'data-source');
      const poster = attribute(player.match(/<img\b[^>]*>/)?.[0] ?? '', 'src');
      assert.ok(scene && poster, `${page.pathname}: player needs scene and poster`);
      await checkLocal(poster, page);
      if (source) await checkLocal(source, page);
    }
  }
});
