import fs from 'node:fs/promises';
import path from 'node:path';
import sharp from 'sharp';
import {createTMath, compileScene} from '../public/tmath/runtime/client.js';
import {buildSampling, buildCoverage, buildComposition} from '../public/tmath/raster/scenes.mjs';
import {buildDispatch} from '../public/tmath/raster/dispatch.mjs';
import {buildSurface} from '../public/tmath/raster/surface.mjs';
import {buildShapeFill} from '../public/tmath/raster/shape-fill.mjs';
import {buildBitmapFilter} from '../public/tmath/raster/bitmap-filter.mjs';

const root = path.resolve(import.meta.dirname, '..');
const out = path.join(root, 'src/content/blog/Mentoring/LUA/raster');
const temp = path.join(out, 'temp');
await fs.mkdir(temp, {recursive: true});
const bundle = path.join(root, 'public/tmath/runtime');
const runtime = await createTMath('return tmath.scene {}', 'bootstrap.lua', {renderEngine: 'cpu', wasmBinary: await fs.readFile(path.join(bundle, 'tmath-wasm.wasm'))});
for (const [name, file] of [['Pretendard', 'Pretendard.ttf'], ['Source Serif 4', 'SourceSerif4-Semibold.ttf'], ['IBM Plex Sans KR', 'IBMPlexSansKR-SemiBold.ttf']]) {
  runtime.font(name, await fs.readFile(path.join(bundle, file)), 'ttf');
}
const ids = ['dispatch', 'direct', 'nearest', 'bilinear', 'downscale', 'texmap', 'solid-rle', 'composition', 'surface', 'shape-fill', 'bitmap-filter'];
const reports = [];
try {
  for (const id of ids) {
    if (process.argv[2] && process.argv[2] !== id) continue;
    const episode = id === 'bitmap-filter' ? buildBitmapFilter() : id === 'shape-fill' ? buildShapeFill() : id === 'surface' ? buildSurface() : id === 'dispatch' ? buildDispatch() : id === 'solid-rle' ? buildCoverage() : id === 'composition' ? buildComposition() : buildSampling(id);
    // The builder emits a local per handle; pixel traces exceed Lua's 200-local limit.
    // Keep the same objects and commands, with generated handles in one local table.
    const source = 'local refs = {}\n' + compileScene(episode.scene)
      .replace(/^local (object\d+) = /gm, '$1 = ')
      .replace(/\bobject(\d+)\b/g, 'refs[$1]');
    await fs.writeFile(path.join(out, id + '.lua'), source);
    runtime.loadLua(source, id + '.lua');
    const [width, height] = runtime.size();
    const frames = Math.ceil(runtime.duration * 30);
    const errors = new Set(), seen = new Set();
    let minClearance = Infinity;
    for (let frame = 0; frame <= frames; frame++) {
      const layout = runtime.layoutReport(Math.min(frame / 30, runtime.duration), 4);
      const texts = layout.objects.filter(o => o.type === 'text' && o.visible && o.paintBounds?.width);
      for (const t of texts) {
        seen.add(t.id);
        if (!episode.textPolicies[t.id]) errors.add('Missing text ownership: ' + t.id);
        const policy = episode.textPolicies[t.id];
        if (policy?.owner) {
          const owner = layout.objects.find(o => o.id === policy.owner)?.paintBounds;
          const b = t.paintBounds, inset = policy.inset;
          if (!owner || b.x < owner.x + inset || b.y < owner.y + inset ||
              b.x + b.width > owner.x + owner.width - inset || b.y + b.height > owner.y + owner.height - inset)
            errors.add('Text containment: ' + t.id);
        }
        const b = t.paintBounds;
        minClearance = Math.min(minClearance, b.x, b.y, width - b.x - b.width, height - b.y - b.height);
        if (b.x < 4 || b.y < 4 || b.x + b.width > width - 4 || b.y + b.height > height - 4 || t.clipped) errors.add('Text clipped: ' + t.id);
      }
      for (let i = 0; i < texts.length; i++) for (let j = i + 1; j < texts.length; j++) {
        const a = texts[i].paintBounds, b = texts[j].paintBounds;
        if (Math.min(a.x + a.width, b.x + b.width) - Math.max(a.x, b.x) > -4 && Math.min(a.y + a.height, b.y + b.height) - Math.max(a.y, b.y) > -4)
          errors.add('Text clearance: ' + texts[i].id + ' / ' + texts[j].id);
      }
    }
    for (const id of episode.textIds) if (!seen.has(id)) errors.add('Never visible: ' + id);
    const times = [...new Set([0, ...episode.beats.map(b => Math.min(b.time, runtime.duration)), runtime.duration])];
    for (const [i, time] of times.entries()) {
      await sharp(runtime.render(time, true), {raw: {width, height, channels: 4}}).png().toFile(path.join(temp, id + '-' + i + '.png'));
    }
    await sharp(runtime.render(runtime.duration, true), {raw: {width, height, channels: 4}}).webp({quality: 92}).toFile(path.join(out, id + '.webp'));
    let loopSeam;
    if (episode.loop) {
      loopSeam = Buffer.from(runtime.render(0, true)).equals(Buffer.from(runtime.render(runtime.duration, true)));
      if (!loopSeam) errors.add('Loop endpoint differs from the opening');
    }
    const report = {id, duration: runtime.duration, frames, minClearance, textCount: seen.size, errors: [...errors], beats: episode.beats, width, height, loopSeam};
    reports.push(report);
    console.log(JSON.stringify(report));
    if (errors.size) throw new Error('Layout review failed: ' + id);
  }
  await fs.writeFile(path.join(temp, 'review.json'), JSON.stringify(reports, null, 2));
} finally { runtime.destroy(); }
