import {tmath} from '../runtime/client.js';
import {trace, rgba, replaySpans} from './native-evidence.mjs';

// Overview of the composition lifetime: target → beginComposite → pixel work
// → endComposite. The final map retains the native before/after snapshots.
export function buildEffectPipeline(input = trace) {
  const width = 960, height = 800;
  const C = {ink: '#202020', muted: '#626262', line: '#555555', outside: '#e6eaed'};
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: C.ink}]))}});
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const textIds = [], textPolicies = {}, imageRegions = [], beats = [], owners = new WeakMap();
  let serial = 0, time = 0;
  const key = name => `effect-pipeline-${name}-${serial++}`;
  const group = () => scene.group({id: key('group')});
  function text(parent, value, x, y, size = 22, color = C.ink, owner = null) {
    const id = key('text'); textIds.push(id);
    textPolicies[id] = owner ? {owner: owners.get(owner), inset: 12} : {standalone: true};
    return parent.text({id, text: value, point: p(x, y), size, fill: color,
      font: 'Pretendard', role: 'text', align: [.5, .5], layer: 30});
  }
  function rect(parent, x, y, w, h, color = C.line, dash = null, fill = '#00000000') {
    const id = key('rect');
    const handle = parent.rectangle({id, center: p(x, y), size: [w / 100, h / 100],
      fill, stroke: color, width: 2, ...(dash ? {dash} : {}), layer: 12});
    owners.set(handle, id); return handle;
  }
  function route(parent, points, color = C.line, arrow = true, dash = null) {
    return parent.route({id: key('route'), points: points.map(([x, y]) => p(x, y)),
      stroke: color, width: arrow ? 2.5 : 2, tip: arrow ? 10 : 0,
      ...(dash ? {dash} : {}), layer: 6});
  }
  function image(parent, pixels, x, y, size, offscreen = false) {
    const colors = pixels.map((value, i) => {
      const px = i % input.width, py = Math.floor(i / input.width);
      if (offscreen && (px < input.bbox[0] || py < input.bbox[1] ||
        px >= input.bbox[2] || py >= input.bbox[3])) return C.outside;
      const [r, g, b, alpha] = rgba(value), backdrop = (px + py) % 2 ? 241 : 250;
      return '#' + [r, g, b].map(c => Math.min(255, Math.round(c + backdrop * (1 - alpha / 255)))
        .toString(16).padStart(2, '0')).join('');
    });
    const id = key('image'); imageRegions.push(id);
    return parent.image({id, pixels: colors, size: [input.width, input.height],
      center: p(x, y), width: size / 100, filter: 'nearest', layer: 8});
  }
  function snapshot(parent, pixels, x, y, size = 120, offscreen = false) {
    rect(parent, x, y, size, size);
    image(parent, pixels, x, y, size, offscreen);
  }
  function wait(duration) {scene.wait(duration); time += duration;}
  function show(target, duration = .45) {scene.fadeIn(target, {duration}); time += duration;}
  function beat(label, hold = 1.6) {beats.push({time: +time.toFixed(3), label}); wait(hold);}

  function hide(target, duration = .15) {scene.fadeOut(target, {duration}); time += duration;}
  function node(parent, label, detail, x, y, w, pixel = false) {
    const box = rect(parent, x, y, w, 100, C.ink, null, pixel ? '#242424' : '#ffffff');
    text(parent, label, x, y - 22, 22, pixel ? '#ffffff' : C.ink, box);
    text(parent, detail, x, y + 22, 17, pixel ? '#e0e0e0' : C.muted, box);
    return rect(scene, x, y, w + 8, 108, C.ink);
  }
  const targetFrame = node(scene, 'target()', 'surface = Offscreen', 190, 76, 300);
  const beginFrame = node(scene, 'beginComposite()', `MaskMethod::None · opacity ${input.opacity}`, 665, 76, 480);
  route(scene, [[345, 76], [420, 76]], C.ink, true, [8, 6]);

  // The enclosure is one Offscreen's work interval, not three allocations.
  const work = group();
  rect(work, 480, 331, 860, 318, C.ink, [8, 6]);
  text(work, 'Offscreen ×1 · effects in registration order', 500, 198, 21);
  const beginLink = route(scene, [[665, 132], [665, 154], [215, 154], [215, 216]], C.ink, true, [8, 6]);
  function process(label, x) {
    const g = group(), box = rect(g, x, 252, 230, 60, C.ink, null, '#242424');
    text(g, label, x, 248, 18, '#ffffff', box);
    return g;
  }
  let combined = Array(input.width * input.height).fill(0);
  for (const writes of input.writes) combined = replaySpans(writes, combined, input.width).at(-1).pixels;
  const raster = process('renderShape(A, B)', 215);
  snapshot(raster, combined, 215, 360, 120, true);
  const blur = process('GaussianBlur', 480);
  snapshot(blur, input.filtered, 480, 360, 120, true);
  route(blur, [[335, 252], [360, 252]], C.ink, true, [8, 6]);
  const scratch = rect(blur, 480, 454, 208, 54, C.ink, [8, 6], '#ffffff');
  text(blur, `Blur scratch ×${input.buffers.scratch}`, 480, 450, 17, C.muted, scratch);
  const fill = process('Fill', 745);
  snapshot(fill, input.compositionInput, 745, 360, 120, true);
  route(fill, [[600, 252], [625, 252]], C.ink, true, [8, 6]);
  text(fill, 'in-place', 745, 450, 17, C.muted);

  // End restores the parent first; rasterDirectImage is inside this call.
  const end = group();
  const endBox = rect(end, 460, 650, 470, 184, C.ink, null, '#ffffff');
  text(end, 'endComposite()', 460, 581, 23, C.ink, endBox);
  const restored = text(end, 'surface = Canvas', 460, 619, 18, C.muted, endBox);
  const endLink = route(scene, [[865, 252], [934, 252], [934, 530], [650, 530], [650, 554]], C.ink, true, [8, 6]);
  const write = group();
  const writeBox = rect(write, 460, 695, 400, 74, C.ink, null, '#242424');
  text(write, 'rasterDirectImage()', 460, 680, 20, '#ffffff', writeBox);
  text(write, `source-over · group opacity ${input.opacity}`, 460, 708, 16, '#e0e0e0', writeBox);
  const writeLink = route(scene, [[460, 640], [460, 653]], C.ink, true, [8, 6]);

  text(scene, 'Canvas', 100, 565, 22);
  text(scene, 'BG retained', 100, 595, 17, C.muted);
  snapshot(scene, input.background, 100, 682, 96);
  const savedLink = route(scene, [[154, 682], [218, 682]], C.line, true, [8, 6]);
  const output = group();
  text(output, 'Canvas', 830, 565, 22);
  text(output, 'BG + Effect', 830, 595, 17, C.muted);
  snapshot(output, input.final, 830, 682, 110);
  const outputLink = route(scene, [[665, 695], [769, 695]], C.ink, true, [8, 6]);

  show(targetFrame, .3);
  beat('target selects and clears one Offscreen while the Canvas BG is retained.', 1);
  hide(targetFrame); show(beginFrame, .3); show(work); show(beginLink, .3);
  beat('beginComposite stores None and Scene opacity; the selected target remains Offscreen.', 1.2);
  hide(beginFrame); show(raster);
  beat('A and B are drawn into the same Offscreen at child opacity 255.', 1.2);
  show(blur);
  beat('GaussianBlur uses one scratch buffer and returns its result to Offscreen.', 1.4);
  show(fill);
  beat('Fill updates that Offscreen in place; the parent Canvas is still unchanged.', 1.2);
  show(endLink, .3); show(end); show(restored, .25); show(savedLink, .25);
  beat('endComposite restores Canvas and its prior compositor before writing pixels.', 1.2);
  show(writeLink, .2); show(write); show(outputLink, .25); show(output, .65);
  beat('Inside endComposite, rasterDirectImage applies group opacity and source-over once. The complete begin/end map remains visible.', 3);
  return {scene, beats, textIds, textPolicies, imageRegions, duration: time};
}
