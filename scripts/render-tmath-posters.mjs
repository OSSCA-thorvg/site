import fs from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import sharp from 'sharp';
import {createTMath, compileScene} from '../public/tmath/runtime/client.js';
import {buildEpisode} from '../public/tmath/postprocessing/scenes.mjs';
import {themeLua} from '../public/tmath/theme.mjs';
import {tmathPalette} from '../src/lib/tmath-palette.js';

const root = path.resolve(import.meta.dirname, '..');
const bundle = path.join(root, 'public/tmath/runtime');
const selected = new Set(process.argv.slice(2).filter(arg => arg !== '--force'));
const force = process.argv.includes('--force');
const css = await fs.readFile(path.join(root, 'src/styles/global.css'), 'utf8');
const lightTokens = new Map([...css.match(/:root\s*\{([\s\S]*?)\n\}/)[1]
  .matchAll(/(--[\w-]+)\s*:\s*([^;]+);/g)].map(match => [match[1], match[2].trim()]));
const readToken = name => {
  const value = lightTokens.get(name) ?? '';
  const alias = value.match(/^var\((--[\w-]+)\)$/)?.[1];
  return alias ? readToken(alias) : value;
};
const palette = tmathPalette(readToken);
const rendererHash = createHash('sha256').update(await fs.readFile(new URL(import.meta.url)));
for (const file of (await fs.readdir(bundle)).sort()) {
  if (/\.(js|wasm|ttf)$/.test(file)) rendererHash.update(await fs.readFile(path.join(bundle, file)));
}
const cachePath = path.join(root, 'public/blog-thumbnails/tmath-posters.json');
const previousCache = await fs.readFile(cachePath, 'utf8').then(JSON.parse).catch(() => ({}));
const nextCache = selected.size ? {...previousCache} : {};
let runtime;
let generated = 0, cached = 0;
const initialize = async () => {
  if (runtime) return;
  runtime = await createTMath('return tmath.scene {}', 'bootstrap.lua', {
    renderEngine: 'cpu', wasmBinary: await fs.readFile(path.join(bundle, 'tmath-wasm.wasm')),
  });
  for (const [name, file] of [['Pretendard', 'Pretendard.ttf'], ['Source Serif 4', 'SourceSerif4-Semibold.ttf'], ['IBM Plex Sans KR', 'IBMPlexSansKR-SemiBold.ttf'], ['CMUTypewriter-Regular', 'CMUTypewriter-Regular.ttf']]) {
    runtime.font(name, await fs.readFile(path.join(bundle, file)), 'ttf');
  }
  runtime.hostTheme(palette);
};
try {
  for await (const file of fs.glob('src/content/**/*.mdx', {cwd: root})) {
    const fullPath = path.join(root, file);
    const content = await fs.readFile(fullPath, 'utf8');
    const imports = new Map([...content.matchAll(/import (\w+) from ['"]([^'"]+)['"]/g)].map(m => [m[1], m[2]]));
    for (const [tag] of content.matchAll(/<TMathPlayer\b[^>]*\/>/g)) {
      const id = tag.match(/\bscene="([^"]+)"/)?.[1];
      if (!id) throw new Error('Missing scene in ' + file);
      if (selected.size && !selected.has(id)) continue;
      const source = tag.match(/\bsource={(\w+)}/)?.[1];
      const publicPath = attribute => tag.match(new RegExp(`\\b${attribute}=\\{\\s*import\\.meta\\.env\\.BASE_URL\\s*\\+\\s*(['"])([^'"]+)\\1\\s*\\}`))?.[2]
        ?? tag.match(new RegExp('\\b' + attribute + '=\\{`\\$\\{import\\.meta\\.env\\.BASE_URL\\}([^`$]+)`\\}'))?.[1];
      const publicSource = publicPath('source');
      const publicPoster = publicPath('poster');
      const poster = tag.match(/\bposter={(\w+)\.src}/)?.[1];
      let output, lua;
      if (source) {
        const sourcePath = imports.get(source)?.replace(/\?url$/, '');
        const posterPath = imports.get(poster);
        if (!sourcePath || !posterPath) throw new Error('Missing scene/poster import: ' + id);
        lua = await fs.readFile(path.resolve(path.dirname(fullPath), sourcePath), 'utf8');
        output = path.resolve(path.dirname(fullPath), posterPath);
      } else if (publicSource) {
        lua = await fs.readFile(path.join(root, 'public', publicSource), 'utf8');
        output = publicPoster ? path.join(root, 'public', publicPoster)
          : path.join(root, 'public/tmath/postprocessing/posters', id + '.webp');
      } else if (/\bsource=/.test(tag)) {
        throw new Error('Unsupported scene source in ' + file + ': ' + id);
      } else {
        lua = compileScene(buildEpisode(id).scene);
        output = path.join(root, 'public/tmath/postprocessing/posters', id + '.webp');
      }
      const end = tag.match(/\bend={([\d.]+)}/)?.[1];
      const crop = tag.match(/\bcrop={(\[[^\]]+\])}/)?.[1];
      const themedSource = themeLua(lua, palette);
      const inputHash = rendererHash.copy().update(themedSource)
        .update(JSON.stringify({end, crop})).digest('hex');
      const key = path.relative(root, output);
      const outputHash = await fs.readFile(output)
        .then(bytes => createHash('sha256').update(bytes).digest('hex')).catch(() => null);
      if (!force && previousCache[key]?.inputHash === inputHash && previousCache[key]?.outputHash === outputHash) {
        nextCache[key] = previousCache[key];
        cached++;
        continue;
      }
      await initialize();
      runtime.loadLua(themedSource, id + '.lua');
      const time = end === undefined ? runtime.duration : Number(end);
      const [width, height] = runtime.size();
      let image = sharp(runtime.render(time, true), {raw: {width, height, channels: 4}});
      if (crop) {
        const [left, top, width, height] = JSON.parse(crop);
        image = image.extract({left, top, width, height});
      }
      await fs.mkdir(path.dirname(output), {recursive: true});
      const bytes = await image.webp({quality: 92}).toBuffer();
      await fs.writeFile(output, bytes);
      nextCache[key] = {inputHash, outputHash: createHash('sha256').update(bytes).digest('hex')};
      generated++;
      console.log(id + ': final frame at ' + time.toFixed(2) + 's');
    }
  }
  await fs.mkdir(path.dirname(cachePath), {recursive: true});
  await fs.writeFile(cachePath, JSON.stringify(nextCache, null, 2) + '\n');
  console.log(`[tmath-posters] generated ${generated}, cached ${cached}`);
} finally {
  runtime?.destroy();
}
