import test from 'node:test';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {copyFile, mkdir, mkdtemp, readFile, readdir, rm, stat, symlink, writeFile} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import sharp from 'sharp';

const root = fileURLToPath(new URL('../', import.meta.url));

test('design changes refresh themed posters and thumbnails, and removed posts leave no cached thumbnails', async () => {
  const fixture = await mkdtemp(path.join(os.tmpdir(), 'thorvg-thumbnails-'));
  const run = file => execFileSync(process.execPath, [file], {cwd: fixture, encoding: 'utf8'});
  const poster = path.join(fixture, 'public/tmath/demo.webp');
  const thumbnailDirectory = path.join(fixture, 'public/blog-thumbnails');
  const readManifest = async () => JSON.parse(await readFile(path.join(thumbnailDirectory, 'manifest.json'), 'utf8'));
  try {
    for (const directory of ['scripts', 'src/content/blog', 'src/data', 'public/tmath', 'public/blog-thumbnails', 'public/hackathon-thumbnails']) {
      await mkdir(path.join(fixture, directory), {recursive: true});
    }
    for (const directory of ['node_modules', 'src/lib', 'public/tmath/runtime', 'public/tmath/postprocessing']) {
      await symlink(path.join(root, directory), path.join(fixture, directory), 'dir');
    }
    await symlink(path.join(root, 'public/tmath/theme.mjs'), path.join(fixture, 'public/tmath/theme.mjs'));
    for (const file of ['scripts/render-tmath-posters.mjs', 'scripts/optimize-card-thumbnails.mjs']) {
      await copyFile(path.join(root, file), path.join(fixture, file));
    }
    await mkdir(path.join(fixture, 'src/styles'));
    const css = await readFile(path.join(root, 'src/styles/global.css'), 'utf8');
    const cssPath = path.join(fixture, 'src/styles/global.css');
    await writeFile(cssPath, css);
    await writeFile(path.join(fixture, 'package.json'), '{"type":"module"}');
    await writeFile(path.join(fixture, 'src/data/live-hackathon.json'), '{"issues":[]}');
    await writeFile(path.join(fixture, 'public/tmath/demo.lua'), 'return tmath.scene {width=64,height=40,theme={preset="pro_white",background="#f2f2f2"}}');
    const post = path.join(fixture, 'src/content/blog/demo.mdx');
    await writeFile(post, '<TMathPlayer scene="demo" source={`${import.meta.env.BASE_URL}tmath/demo.lua`} poster={import.meta.env.BASE_URL + \'tmath/demo.webp\'} />');
    await writeFile(path.join(thumbnailDirectory, 'unused.webp'), 'obsolete thumbnail');
    await writeFile(path.join(fixture, 'public/hackathon-thumbnails/unused.webp'), 'obsolete thumbnail');

    assert.match(run('scripts/render-tmath-posters.mjs'), /generated 1, cached 0/);
    const initialPixels = await sharp(await readFile(poster)).raw().toBuffer();
    assert.deepEqual([...initialPixels.subarray(0, 3)], [255, 255, 255], 'poster uses the site canvas rather than the authored gray background');
    run('scripts/optimize-card-thumbnails.mjs');
    const initialManifest = await readManifest();
    const initialThumbnail = initialManifest['demo|/tmath/demo.webp'];
    assert.deepEqual((await readdir(thumbnailDirectory)).filter(file => file.endsWith('.webp')), [initialThumbnail]);
    assert.deepEqual(await readdir(path.join(fixture, 'public/hackathon-thumbnails')), []);

    const initialModified = (await stat(poster)).mtimeMs;
    assert.match(run('scripts/render-tmath-posters.mjs'), /generated 0, cached 1/);
    assert.equal((await stat(poster)).mtimeMs, initialModified, 'unchanged posters are reused');
    await writeFile(cssPath, css.replace('--canvas: #FFFFFF;', '--canvas: #123456;'));
    assert.match(run('scripts/render-tmath-posters.mjs'), /generated 1, cached 0/);
    const changedPixels = await sharp(await readFile(poster)).raw().toBuffer();
    for (const [index, value] of [18, 52, 86].entries()) {
      assert.ok(Math.abs(changedPixels[index] - value) <= 2, `Themed background: ${[...changedPixels.subarray(0, 3)]}, expected 18,52,86`);
    }
    run('scripts/optimize-card-thumbnails.mjs');
    const changedThumbnail = (await readManifest())['demo|/tmath/demo.webp'];
    assert.notEqual(changedThumbnail, initialThumbnail, 'changed image content gets a new browser-cache URL');
    assert.deepEqual((await readdir(thumbnailDirectory)).filter(file => file.endsWith('.webp')), [changedThumbnail]);

    execFileSync(process.execPath, ['--input-type=module', '-e', `
      import assert from 'node:assert/strict';
      import {readFileSync, writeFileSync} from 'node:fs';
      import {resolveBlogThumbnail} from './src/lib/blog-thumbnails.js';
      const media = {type: 'tmath', src: '/tmath/demo.webp'};
      const before = resolveBlogThumbnail('demo', media);
      const file = 'public/blog-thumbnails/manifest.json';
      const manifest = JSON.parse(readFileSync(file, 'utf8'));
      manifest['demo|/tmath/demo.webp'] = 'replacement-thumbnail.webp';
      writeFileSync(file, JSON.stringify(manifest));
      assert.equal(resolveBlogThumbnail('demo', media), '/blog-thumbnails/replacement-thumbnail.webp');
      assert.notEqual(resolveBlogThumbnail('demo', media), before);
    `], {cwd: fixture});

    await rm(post);
    run('scripts/render-tmath-posters.mjs');
    run('scripts/optimize-card-thumbnails.mjs');
    assert.deepEqual(await readManifest(), {});
    assert.deepEqual((await readdir(thumbnailDirectory)).filter(file => file.endsWith('.webp')), []);
  } finally {
    await rm(fixture, {recursive: true, force: true});
  }
});
