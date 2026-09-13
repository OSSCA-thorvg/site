import fs from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import sharp from 'sharp';
import {createTMath, compileScene, tmath} from '../public/tmath/runtime/client.js';
import {buildEpisode, detailBuilders, episodes} from '../public/tmath/postprocessing/scenes.mjs';

const root = path.resolve(import.meta.dirname, '../public/tmath');
const temp = path.join(root, 'postprocessing/temp');
await fs.mkdir(temp, {recursive: true});
const manifest = JSON.parse(await fs.readFile(path.join(root, 'runtime/BUILD-MANIFEST.json'), 'utf8'));
for (const artifact of manifest.artifacts) {
  const bytes = await fs.readFile(path.join(root, 'runtime', artifact.path));
  if (bytes.length !== artifact.bytes || createHash('sha256').update(bytes).digest('hex') !== artifact.sha256) throw new Error(`Runtime integrity: ${artifact.path}`);
}
const rt = await createTMath(tmath.scene({width: 960, height: 640}), 'bootstrap.js', {
  renderEngine: 'cpu', wasmBinary: await fs.readFile(path.join(root, 'runtime/tmath-wasm.wasm')),
});
rt.font('Pretendard', await fs.readFile(path.join(root, 'runtime/Pretendard.ttf')), 'ttf');
const summaries = [];
const intersects = (a, b, gap = 0) => a.x < b.x + b.width + gap && a.x + a.width + gap > b.x && a.y < b.y + b.height + gap && a.y + a.height + gap > b.y;
try {
  for (const id of Object.keys(episodes)) {
    if (process.argv[2] && process.argv[2] !== id) continue;
    const episode = buildEpisode(id);
    if (Object.hasOwn(detailBuilders, id) || id === 'overview') {
      // Detailed scenes exceed Lua's 200 local-variable limit; keep handles in a table.
      const source = 'local refs = {}\n' + compileScene(episode.scene)
        .replace(/^local (object\d+) = /gm, '$1 = ').replace(/\bobject(\d+)\b/g, 'refs[$1]');
      if (id === 'overview') await fs.writeFile(path.join(root, 'postprocessing/overview.lua'), source);
      rt.loadLua(source, `${id}.lua`);
    } else {
      rt.loadScene(episode.scene, `${id}.js`);
    }
    const [width, height] = rt.size();
    const issues = new Set(), seen = new Set();
    const times = Array.from({length: Math.ceil(rt.duration * 30) + 1}, (_, i) => Math.min(i / 30, rt.duration));
    for (const time of times) {
      const report = rt.layoutReport(time, 4);
      const texts = report.objects.filter(o => o.type === 'text' && o.visible && o.paintBounds?.width > 0);
      for (const t of texts) {
        seen.add(t.id);
        const b = t.paintBounds, policy = episode.textPolicies[t.id];
        if (!policy) issues.add(`Missing text policy ${t.id}`);
        if (b.x < 4 || b.y < 4 || b.x + b.width > width - 4 || b.y + b.height > height - 4 || t.clipped) issues.add(`Canvas clipping ${t.id}`);
        if (policy?.owner) {
          const p = report.objects.find(o => o.id === policy.owner)?.paintBounds;
          if (!p || b.x < p.x + policy.inset || b.y < p.y + policy.inset || b.x + b.width > p.x + p.width - policy.inset || b.y + b.height > p.y + p.height - policy.inset) issues.add(`Containment ${t.id}`);
        }
      }
      for (let i = 0; i < texts.length; i++) for (let j = i + 1; j < texts.length; j++) {
        if (intersects(texts[i].paintBounds, texts[j].paintBounds, 4)) issues.add(`Text gap ${texts[i].id} / ${texts[j].id}`);
      }
      const imageIds = new Set(episode.imageRegions || []);
      const images = report.objects.filter(o => imageIds.has(o.id) && o.visible && o.paintBounds?.width > 0);
      for (const img of images) {
        for (const t of texts) if (intersects(img.paintBounds, t.paintBounds, 6)) issues.add(`Image/text gap ${img.id} / ${t.id}`);
        const b = img.paintBounds;
        if (episode.diagramRegions && !episode.diagramRegions.some(r => b.x >= r.x && b.y >= r.y && b.x + b.width <= r.x + r.width && b.y + b.height <= r.y + r.height)) issues.add(`Evidence row overflow ${img.id}`);
      }
      for (let i = 0; i < images.length; i++) for (let j = i + 1; j < images.length; j++) {
        if (intersects(images[i].paintBounds, images[j].paintBounds, 4)) issues.add(`Image gap ${images[i].id} / ${images[j].id}`);
      }
    }
    for (const id of episode.textIds) if (!seen.has(id)) issues.add(`Never visible ${id}`);
    const reviews = [...new Set([0, ...episode.beats.map(b => Math.min(b.time, rt.duration)), rt.duration])];
    for (let i = 0; i < reviews.length; i++) {
      const rgba = rt.render(reviews[i], true);
      await sharp(Buffer.from(rgba), {raw: {width, height, channels: 4}}).png().toFile(path.join(temp, `${id}-${i}.png`));
    }
    await sharp(Buffer.from(rt.render(rt.duration, true)), {raw: {width, height, channels: 4}}).webp({quality: 90}).toFile(path.join(root, `postprocessing/posters/${id}.webp`));
    const summary = {id, duration: rt.duration, sampledFrames: times.length, reviewTimes: reviews, issues: [...issues], textPolicies: episode.textPolicies};
    summaries.push(summary);
    await fs.writeFile(path.join(temp, `${id}.audit.json`), JSON.stringify(summary, null, 2));
    console.log(`${id}: ${times.length} frames, ${issues.size} issues${issues.size ? '\n' + [...issues].join('\n') : ''}`);
  }
} finally { rt.destroy(); }
await fs.writeFile(path.join(temp, 'review.json'), JSON.stringify(summaries, null, 2));
if (summaries.some(s => s.issues.length)) process.exitCode = 1;
