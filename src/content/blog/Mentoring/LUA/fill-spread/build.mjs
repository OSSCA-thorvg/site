import fs from 'node:fs/promises';
import {tmath, compileScene, createTMath} from '../../../../../../public/tmath/runtime/client.js';
import {spreadT} from '../../../../../lib/gradient-spread.mjs';
import sharp from 'sharp';

// Shared source model: normalized gradient position t, with the same stops in all rows.
// Beats: center (0s), right extension (3s), left extension (9s), center (12s).
// All labels are standalone; geometry uses pixel coordinates mapped to Y-up world space.
const dir = import.meta.dirname;
const W = 960, H = 420, left = 210, span = 690;
const pos = (x, y) => [(x - W / 2) / 100, (H / 2 - y) / 100];
const x = t => left + (t + 1) / 3 * span;
export function buildSpread(stops = [[40, 111, 218], [243, 151, 65]]) {
  const s = tmath.scene({width: W, height: H, fps: 30, loop: true, theme: 'pro_white', camera: {mode: 'fixed', view: '2d', height: H / 100}});
  const text = (id, value, px, py, size = 22, align = 0.5) =>
    s.text({id, text: value, point: pos(px, py), size, font: 'Pretendard', role: 'text', align: [align, 0.5], fill: '#293544', layer: 20});
  s.line({id: 'base-bracket', from: pos(x(0), 49), to: pos(x(1), 49), stroke: '#293544', width: 2, layer: 5});
  for (const t of [-1, 0, 1, 2]) {
    text('tick-' + t, String(t), x(t), 75, 18);
    s.line({id: 'guide-' + t, from: pos(x(t), 92), to: pos(x(t), 350), stroke: '#ccd3db', width: 1, layer: 5});
  }
  const markers = s.group({id: 'sample-markers'});
  for (const [i, mode] of ['Pad', 'Repeat', 'Reflect'].entries()) {
    const y = 128 + i * 96;
    text(mode + '-label', mode, 38, y, 26, 0);
    const pixels = Array.from({length: span / 2}, (_, j) => {
      const u = spreadT(-1 + (j + 0.5) / (span / 2) * 3, mode);
      return '#' + stops[0].map((v, k) => Math.round(v + (stops[1][k] - v) * u).toString(16).padStart(2, '0')).join('');
    });
    s.image({id: mode + '-gradient', pixels: Array.from({length: 24}, () => pixels).flat(), size: [span / 2, 24], center: pos(left + span / 2, y), width: span / 100, filter: 'nearest', layer: 10});
    markers.circle({id: mode + '-sample-outline', center: pos(x(0.5), y), radius: 0.15, fill: '#00000000', stroke: '#293544', width: 6, layer: 30});
    markers.circle({id: mode + '-sample', center: pos(x(0.5), y), radius: 0.15, fill: '#00000000', stroke: '#ffffff', width: 3, layer: 31});
  }
  s.shift(markers, [(x(1.9) - x(0.5)) / 100, 0], 3, 'ease_in_out');
  s.shift(markers, [(x(-0.9) - x(1.9)) / 100, 0], 6, 'ease_in_out');
  s.shift(markers, [(x(0.5) - x(-0.9)) / 100, 0], 3, 'ease_in_out');
  return s;
}
await fs.writeFile(dir + '/fill-spread.lua', compileScene(buildSpread()));
const bundle = new URL('../../../../../../public/tmath/runtime/', import.meta.url);
const runtime = await createTMath('return tmath.scene {}', 'bootstrap.lua', {renderEngine: 'cpu', wasmBinary: await fs.readFile(new URL('tmath-wasm.wasm', bundle))});
runtime.font('Pretendard', await fs.readFile(new URL('Pretendard.ttf', bundle)), 'ttf');
runtime.loadScene(buildSpread(), 'fill-spread.js');
const frames = [0, 1.5, 3, 6, 9, 10.5, 12];
for (const time of frames) {
  await sharp(runtime.render(time, true), {raw: {width: W, height: H, channels: 4}}).png().toFile(dir + '/temp/frame-' + time + '.png');
}
await sharp(runtime.render(runtime.duration, true), {raw: {width: W, height: H, channels: 4}}).webp({quality: 92}).toFile(dir + '/fill-spread.webp');
const first = Buffer.from(runtime.render(0, true)), last = Buffer.from(runtime.render(runtime.duration, true));
if (!first.equals(last)) throw new Error('Loop seam differs');
let minClearance = Infinity;
for (let frame = 0; frame <= 360; frame++) {
  const report = runtime.layoutReport(frame / 30, 4);
  const texts = report.objects.filter(o => o.type === 'text' && o.visible);
  for (const obj of texts) {
    const b = obj.paintBounds;
    if (!b) throw new Error('Missing text bounds: ' + obj.id);
    minClearance = Math.min(minClearance, b.x, b.y, W - b.x - b.width, H - b.y - b.height);
    if (obj.clipped || obj.outside) throw new Error('Clipped text: ' + obj.id);
  }
  for (let i=0;i<texts.length;i++) for (let j=i+1;j<texts.length;j++) {
    const a=texts[i].paintBounds,b=texts[j].paintBounds;
    if (Math.min(a.x+a.width,b.x+b.width)-Math.max(a.x,b.x)>-4 && Math.min(a.y+a.height,b.y+b.height)-Math.max(a.y,b.y)>-4) throw new Error('Text clearance: '+texts[i].id+'/'+texts[j].id);
  }
}
runtime.loadScene(buildSpread([[31, 157, 122], [205, 63, 99]]), 'asymmetric-stops.js');
runtime.render(3, true);
runtime.destroy();
console.log({frames: 361, minClearance, loopSeam: 'identical', alternateStops: 'rendered'});
