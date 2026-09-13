import {buildMaskPipeline} from './mask-pipeline.mjs';
import {buildOverview} from './overview.mjs';
import {buildPipeline, nativeEpisodes} from './pipeline.mjs';
import {buildStraightAlpha} from './straight-alpha.mjs';
import {buildAlphaSurfaceFlow} from './alpha-surface-flow.mjs';
import {buildAlphaFringe} from './alpha-fringe.mjs';
import {buildAlphaOutput} from './alpha-output.mjs';
import {buildBlurDetail} from './effect-blur.mjs';
import {buildTintDetail, buildTritoneDetail, buildFillDetail} from './effect-colors.mjs';
import {buildShadowDetail} from './effect-shadow.mjs';
import {tmath} from '../runtime/client.js';
import {N, geometry, sampleImage, blue, orange, over, hex, fill, shadow} from './model.mjs';

export const episodes = {
  'mask-pipeline': ['Mask + Effect pipeline', 'Alpha 마스크 생성 → 컨텍스트 연결 → 효과 결과의 마스크 합성'],
  overview: ['전체 파이프라인', 'Scene부터 최종 Surface까지'],
  'effect-pipeline': ['Effect Pipeline', 'A·B의 합성 이미지 → Blur → Fill → Canvas 합성'],
  begin: ['target · beginComposite', '기존 Canvas를 보관하고 offscreen 선택'],
  order: ['Effect order', 'DropShadow → Fill / Fill → DropShadow'],
  prepare: ['Prepare · 처리 영역', '필터가 읽을 이웃 픽셀까지 확보'],
  raster: ['renderShape · Offscreen 기록', 'A와 B의 실제 RLE span을 같은 버퍼에 기록'],
  chain: ['Effect chain · GaussianBlur → Fill', '두 임시 버퍼의 역할과 연속 처리'],
  composite: ['endComposite · Canvas 합성', '실제 RGBA 바이트로 source-over 계산'],
  output: ['postRender · 프레임 마무리', '출력 형식 분기와 갱신 상태 정리'],
  'alpha-surface-flow': ['Alpha Surface flow', 'Offscreen 픽셀 쓰기부터 effect와 Canvas 합성까지'],
  'alpha-fringe': ['Transparent edge pixels', '숨은 RGB가 필터 경계색에 미치는 영향'],
  'alpha-output': ['Straight-alpha output', '같은 이미지를 유지하며 출력 RGB 표현을 변환'],
  'straight-alpha': ['Straight target · retained pixels', 'draw(false)에서 기존 straight-alpha 픽셀의 변환 경계'],
  blur: ['GaussianBlur', 'Separable passes'],
  shadow: ['DropShadow', 'Alpha → offset → composite'],
  fill: ['Fill', 'Alpha → recolor'],
  tint: ['Tint', 'Read → map → write'],
  tritone: ['Tritone', 'Luma → branch → write'],
};

const C = {ink: '#202020', muted: '#626262', line: '#555555', blue: hex(blue), orange: hex(orange)};
const pos = (x, y) => [(x - 480) / 100, (320 - y) / 100];
const source = sampleImage();
export const detailBuilders = {blur: buildBlurDetail, tint: buildTintDetail, tritone: buildTritoneDetail, fill: buildFillDetail, shadow: buildShadowDetail};

export function buildEpisode(id) {
  if (Object.hasOwn(detailBuilders, id)) return detailBuilders[id]();
  if (id === 'mask-pipeline') return buildMaskPipeline();
  if (id === 'overview') return buildOverview();
  if (nativeEpisodes.has(id)) return buildPipeline(id);
  if (id === 'alpha-surface-flow') return buildAlphaSurfaceFlow();
  if (id === 'alpha-fringe') return buildAlphaFringe();
  if (id === 'alpha-output') return buildAlphaOutput();
  if (id === 'straight-alpha') return buildStraightAlpha();
  if (!episodes[id]) throw new Error(`Unknown episode: ${id}`);
  const s = tmath.scene({width: 960, height: 640, fps: 30, loop: false, camera: {mode: 'fixed', view: '2d', height: 6.4},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: C.ink}]))}});
  let serial = 0, time = 0;
  const beats = [{time: 0, label: episodes[id][1]}];
  const textIds = [];
  const textPolicies = {};
  const rectangleIds = new WeakMap();
  const key = name => `${id}-${name}-${serial++}`;
  function text(parent, value, x, y, size = 23, color = C.ink, align = 0.5, owner = null) {
    const textId = key('text'); textIds.push(textId);
    textPolicies[textId] = owner ? {owner: rectangleIds.get(owner), inset: 10} : {standalone: true};
    return parent.text({id: textId, text: value, point: pos(x, y), align: [align, 0.5], size, role: 'text', font: 'Pretendard', fill: color, layer: 30});
  }
  function rect(parent, x, y, w, h, color = '#ffffff', stroke = C.line, width = 2, layer = 2) {
    const id = key('rect');
    const object = parent.rectangle({id, center: pos(x, y), size: [w / 100, h / 100], fill: color, stroke, width, layer});
    rectangleIds.set(object, id);
    return object;
  }
  function arrow(x1, y1, x2, y2) {
    return s.arrow({id: key('arrow'), from: pos(x1, y1), to: pos(x2, y2), stroke: C.line, width: 2.5, tip: 11, layer: 8});
  }
  function grid(image, x, y, size = 190, parent = s, background = null) {
    const g = parent.group({id: key('pixels')}), resolution = N * 8;
    const pixels = Array.from({length: resolution ** 2}, (_, i) => {
      const px = i % resolution, py = Math.floor(i / resolution);
      const xx = Math.floor(px / 8), yy = Math.floor(py / 8);
      const b = background || ((xx + yy) % 2 ? [0.91, 0.93, 0.95, 1] : [0.98, 0.985, 0.99, 1]);
      return px % 8 === 7 || py % 8 === 7 ? '#ffffff' : hex(over(image[yy * N + xx], b));
    });
    g.image({id: key('image'), pixels, size: [resolution, resolution], center: pos(x, y), width: size / 100, filter: 'nearest', layer: 3});
    rect(g, x, y, size, size, '#00000000', C.line, 2, 5);
    return g;
  }
  function vector(x, y, size, parent = s) {
    const g = parent.group({id: key('vector')});
    const p = (xx, yy) => pos(x + (xx / N - 0.5) * size, y + (yy / N - 0.5) * size);
    g.polygon({id: key('triangle'), points: geometry.triangle.map(([x, y]) => p(x, y)), fill: C.orange, stroke: C.orange, width: 1, layer: 5});
    const {cx, cy, radius, opacity} = geometry.disk;
    g.circle({id: key('disk'), center: p(cx, cy), radius: radius / N * size / 100, fill: C.blue, stroke: C.blue, opacity, layer: 6});
    return g;
  }
  function reveal(g, label, duration = 0.7, hold = 1.1) {
    s.fadeIn(g, {duration}); time += duration;
    beats.push({time: +time.toFixed(3), label});
    s.wait(hold); time += hold;
  }
  function step(label, action, duration = 0.8, hold = 1.1) {
    action(); time += duration; beats.push({time: +time.toFixed(3), label}); s.wait(hold); time += hold;
  }
  function heading(value, x, y) {
    const width = value.includes('→') ? 290 : 270;
    const owner = rect(s, x, y - 10, width, 62, '#ffffff', C.ink);
    return text(s, value, x, y - 14, 23, C.ink, 0.5, owner);
  }
  if (id === 'prepare') {
    heading('Original bounds', 245, 135); heading('Filter support', 705, 135);
    const size = 230, cell = size / N, disk = geometry.disk;
    const minX = Math.min(...geometry.triangle.map(p => p[0]), disk.cx - disk.radius);
    const maxX = Math.max(...geometry.triangle.map(p => p[0]), disk.cx + disk.radius);
    const minY = Math.min(...geometry.triangle.map(p => p[1]), disk.cy - disk.radius);
    const maxY = Math.max(...geometry.triangle.map(p => p[1]), disk.cy + disk.radius);
    const w = (maxX - minX) * cell, h = (maxY - minY) * cell;
    const offsetX = ((minX + maxX) / 2 - N / 2) * cell, offsetY = ((minY + maxY) / 2 - N / 2) * cell;
    vector(245, 319, size); vector(705, 319, size);
    rect(s, 245 + offsetX, 319 + offsetY, w, h, '#00000000', C.blue, 2, 8);
    const extent = rect(s, 705 + offsetX, 319 + offsetY, w, h, '#00000000', C.orange, 3, 8);
    arrow(408, 319, 510, 319);
    text(s, 'bbox', 245, 491, 23, C.blue);
    const radii = [1, 1, 1];
    let extentLabel = text(s, 'extend = 0', 705, 523, 23, C.orange);
    radii.forEach((_, i) => {
      const radius = radii.slice(0, i + 1).reduce((a, b) => a + b, 0);
      const scaleX = (w + radius * cell * 2) / w, scaleY = (h + radius * cell * 2) / h;
      // Scale about the rectangle's own center in the shared world frame.
      const [cx, cy] = pos(705 + offsetX, 319 + offsetY);
      s.fade(extentLabel, 0, 0.15); time += 0.15;
      step(`box pass ${i + 1}: 누적 반경 ${radius}만큼 이웃 영역이 필요합니다.`, () => s.transform(extent, [scaleX, 0, 0, cx * (1 - scaleX), 0, scaleY, 0, cy * (1 - scaleY), 0, 0, 1, 0, 0, 0, 0, 1], 0.8), 0.8, 0.1);
      extentLabel = text(s, `extend = ${radii.slice(0, i + 1).join(' + ')}${i ? ` = ${radius}` : ''}`, 705, 523, 23, C.orange);
      s.fadeIn(extentLabel, {duration: 0.15}); time += 0.15; s.wait(0.9); time += 0.9;
    });
  } else if (id === 'order') {
    heading('Input', 150, 157); grid(source, 150, 316, 180);
    heading('DropShadow → Fill', 590, 137); heading('Fill → DropShadow', 590, 381);
    arrow(265, 260, 385, 235); arrow(265, 374, 385, 445);
    const first = s.group({id: key('chain-a')}); grid(shadow(source), 475, 243, 157, first);
    const firstResult = s.group({id: key('chain-a-result')}); grid(fill(shadow(source)), 750, 243, 157, firstResult);
    const second = s.group({id: key('chain-b')}); grid(fill(source), 475, 487, 157, second);
    const secondResult = s.group({id: key('chain-b-result')}); grid(shadow(fill(source)), 750, 487, 157, secondResult);
    arrow(568, 243, 645, 243); arrow(568, 487, 645, 487);
    reveal(first, 'DropShadow adds the shadow.', 0.6, .6);
    reveal(firstResult, 'Fill recolors both body and shadow.', .8, 1.6);
    reveal(second, 'Fill recolors the body.', .6, .6);
    reveal(secondResult, 'DropShadow adds its own color after Fill.', .8, 1.6);
    const result = s.group({id: key('answer')});
    reveal(result, 'Reversing the order changes the shadow color.');
  }
  s.wait(1.5); time += 1.5;
  return {scene: s, beats, textIds, textPolicies, duration: time};
}
