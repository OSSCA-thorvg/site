import fs from 'node:fs/promises';
import path from 'node:path';
import sharp from 'sharp';
import {createTMath} from '../public/tmath/runtime/client.js';
import {buildEpisode} from '../public/tmath/postprocessing/scenes.mjs';

const root = path.resolve(import.meta.dirname, '..');
const bundle = path.join(root, 'public/tmath/runtime');
const selected = new Set(process.argv.slice(2));
const runtime = await createTMath('return tmath.scene {}', 'bootstrap.lua', {
  renderEngine: 'cpu', wasmBinary: await fs.readFile(path.join(bundle, 'tmath-wasm.wasm')),
});
try {
  for (const [name, file] of [['Pretendard', 'Pretendard.ttf'], ['Source Serif 4', 'SourceSerif4-Semibold.ttf'], ['IBM Plex Sans KR', 'IBMPlexSansKR-SemiBold.ttf']]) {
    runtime.font(name, await fs.readFile(path.join(bundle, file)), 'ttf');
  }
  runtime.hostTheme({dark:false,background:'#ffffff',foreground:'#333333',muted:'#717171',accent:'#006ab1',secondary:'#af00db',success:'#008000',warning:'#bf8803',danger:'#a1260d',info:'#007acc',surface:'#f3f3f3',line:'#d4d4d4',result:'#795e26',focus:'#111111',objects:['#006ab1','#af00db','#a31515','#098658']});
  for await (const file of fs.glob('src/content/**/*.mdx', {cwd: root})) {
    const fullPath = path.join(root, file);
    const content = await fs.readFile(fullPath, 'utf8');
    const imports = new Map([...content.matchAll(/import (\w+) from ['"]([^'"]+)['"]/g)].map(m => [m[1], m[2]]));
    for (const [tag] of content.matchAll(/<TMathPlayer\b[^>]*\/>/g)) {
      const id = tag.match(/\bscene="([^"]+)"/)?.[1];
      if (!id) throw new Error('Missing scene in ' + file);
      if (selected.size && !selected.has(id)) continue;
      const source = tag.match(/\bsource={(\w+)}/)?.[1];
      const publicSource = tag.match(/\bsource=\{\s*import\.meta\.env\.BASE_URL\s*\+\s*(['"])([^'"]+)\1\s*\}/)?.[2];
      const publicPoster = tag.match(/\bposter=\{\s*import\.meta\.env\.BASE_URL\s*\+\s*(['"])([^'"]+)\1\s*\}/)?.[2];
      const poster = tag.match(/\bposter={(\w+)\.src}/)?.[1];
      let output;
      if (source) {
        const sourcePath = imports.get(source)?.replace(/\?url$/, '');
        const posterPath = imports.get(poster);
        if (!sourcePath || !posterPath) throw new Error('Missing scene/poster import: ' + id);
        runtime.loadLua(await fs.readFile(path.resolve(path.dirname(fullPath), sourcePath), 'utf8'), id + '.lua');
        output = path.resolve(path.dirname(fullPath), posterPath);
      } else if (publicSource) {
        runtime.loadLua(await fs.readFile(path.join(root, 'public', publicSource), 'utf8'), id + '.lua');
        output = publicPoster ? path.join(root, 'public', publicPoster)
          : path.join(root, 'public/tmath/postprocessing/posters', id + '.webp');
      } else if (/\bsource=/.test(tag)) {
        throw new Error('Unsupported scene source in ' + file + ': ' + id);
      } else {
        runtime.loadScene(buildEpisode(id).scene, id + '.js');
        output = path.join(root, 'public/tmath/postprocessing/posters', id + '.webp');
      }
      const end = tag.match(/\bend={([\d.]+)}/)?.[1];
      const time = end === undefined ? runtime.duration : Number(end);
      const [width, height] = runtime.size();
      let image = sharp(runtime.render(time, true), {raw: {width, height, channels: 4}});
      const crop = tag.match(/\bcrop={(\[[^\]]+\])}/)?.[1];
      if (crop) {
        const [left, top, width, height] = JSON.parse(crop);
        image = image.extract({left, top, width, height});
      }
      await image.webp({quality: 92}).toFile(output);
      console.log(id + ': final frame at ' + time.toFixed(2) + 's');
    }
  }
} finally {
  runtime.destroy();
}
