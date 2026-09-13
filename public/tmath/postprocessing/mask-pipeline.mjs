import {tmath} from '../runtime/client.js';
import native from './mask-trace.mjs';
import {rgba} from './native-evidence.mjs';
import {maskCompositeTerms} from './mask-evidence.mjs';

// Pinned native Alpha mask, normal blending, no rectangle fast track.
// Six beats: select mask storage → render mask → attach its context → render
// the effect Scene → masked image write → restore the previous context.
export function buildMaskPipeline(input = native) {
  const width = 960, height = 1120;
  const C = {ink: '#202020', muted: '#626262', line: '#555555', white: '#ffffff', dark: '#242424'};
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: C.ink}]))}});
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const textIds = [], textPolicies = {}, imageRegions = [], beats = [], owners = new WeakMap();
  let serial = 0, time = 0;
  const key = name => `mask-pipeline-${name}-${serial++}`;
  const group = () => scene.group({id: key('group')});
  function text(parent, value, x, y, size = 21, color = C.ink, owner = null) {
    const id = key('text'); textIds.push(id);
    textPolicies[id] = owner ? {owner: owners.get(owner), inset: 12} : {standalone: true};
    return parent.text({id, text: value, point: p(x, y), size, fill: color, font: 'Pretendard', role: 'text', align: [.5, .5], layer: 30});
  }
  function rect(parent, x, y, w, h, fill = '#00000000', border = 2) {
    const id = key('rect');
    const handle = parent.rectangle({id, center: p(x, y), size: [w / 100, h / 100], fill, stroke: C.ink, width: border, layer: 10});
    owners.set(handle, id); return handle;
  }
  function route(points) {
    return scene.route({id: key('route'), points: points.map(([x, y]) => p(x, y)),
      stroke: C.line, width: 2.5, dash: [8, 6], tip: 10, layer: 7});
  }
  function image(parent, values, x, y, size, grayscale = false) {
    const pixels = values.map((v, i) => {
      if (grayscale) return '#' + v.toString(16).padStart(2, '0').repeat(3);
      const c = rgba(v), bg = ((i % input.width) + Math.floor(i / input.width)) % 2 ? 241 : 250;
      return '#' + c.slice(0, 3).map(channel => Math.min(255, Math.round(channel + bg * (1 - c[3] / 255))).toString(16).padStart(2, '0')).join('');
    });
    const id = key('image'); imageRegions.push(id);
    return parent.image({id, pixels, size: [input.width, input.height], center: p(x, y), width: size / 100, filter: 'nearest', layer: 5});
  }
  function wait(seconds) {scene.wait(seconds); time += seconds;}
  function show(target, seconds = .35) {scene.fadeIn(target, {duration: seconds}); time += seconds;}
  function hide(target, seconds = .15) {scene.fadeOut(target, {duration: seconds}); time += seconds;}
  function beat(label, hold = 1.2) {beats.push({time: +time.toFixed(3), label}); wait(hold);}
  const stages = [
    [130, 'target(mask)', 'surface = Mask Surface', false],
    [285, 'beginComposite(None, 255)', 'render Mask into its own bitmap', true],
    [440, `beginComposite(Alpha, ${input.maskOpacity})`, 'surface = Canvas · compositor = mask', false],
    [625, 'Scene(A, B) → effects', `beginComposite(None, ${input.groupOpacity})`, true],
    [835, 'endComposite(effect)', 'group opacity × mask alpha → Canvas', true],
    [1020, 'endComposite(mask)', 'restore context · no extra pixel write', false],
  ];
  const frames = stages.map(([y, label, detail, pixel], i) => {
    const owner = rect(scene, 270, y, 440, 100, pixel ? C.dark : C.white);
    text(scene, label, 270, y - 22, 21, pixel ? C.white : C.ink, owner);
    text(scene, detail, 270, y + 22, 17, pixel ? '#e0e0e0' : C.muted, owner);
    if (i) route([[270, stages[i - 1][0] + 56], [270, y - 56]]);
    return rect(scene, 270, y, 448, 108, '#00000000', 3);
  });
  let current = null;
  function focus(i) {if (current !== null) hide(frames[current]); show(frames[i]); current = i;}
  text(scene, `Scene opacity ${input.groupOpacity}  ·  mask fill alpha ${input.maskFillAlpha}`, 480, 32, 22);

  const mask = group();
  text(mask, 'Mask Surface · Grayscale8', 750, 110, 21);
  rect(mask, 750, 230, 176, 176);
  const clear = image(mask, input.clear, 750, 230, 176, true);
  const coverage = image(mask, input.mask, 750, 230, 176, true);
  text(mask, `mask opacity ${input.maskOpacity} · RGB unused`, 750, 345, 17, C.muted);
  const maskLink = route([[495, 285], [615, 285], [615, 230], [650, 230]]);
  const attached = text(scene, 'Canvas restored · mask attached', 750, 425, 18);
  const detached = text(scene, 'Previous compositor restored', 750, 425, 18);
  const countOne = text(scene, `Temp buffers: ${input.maskBuffers}`, 750, 470, 18, C.muted);
  const countPeak = text(scene, `Temp buffers: ${input.temporaryPeak} · Canvas excluded`, 750, 470, 18, C.muted);

  const effect = group();
  rect(effect, 750, 625, 176, 176);
  const effectLabels = ['A + B', 'GaussianBlur', 'Fill'].map(label => text(effect, `Effect Offscreen · ${label}`, 750, 510, 21));
  const effectImages = [input.children, input.blurred, input.filled].map(pixels => image(effect, pixels, 750, 625, 176));
  const effectLink = route([[495, 625], [650, 625]]);
  const point = input.point[1] * input.width + input.point[0];
  const terms = maskCompositeTerms(input.filled[point], input.background[point], input.mask[point], input.groupOpacity);
  const multiply = text(scene, `MULTIPLY(${terms.groupOpacity}, ${terms.maskAlpha}) = ${terms.effectiveOpacity}`, 750, 755, 19);
  const pointLabel = text(scene, `pixel (${input.point.join(', ')}) · effective opacity`, 750, 797, 16, C.muted);
  const output = group();
  text(output, 'Canvas · masked result', 750, 890, 21);
  rect(output, 750, 1000, 160, 160);
  const background = image(output, input.background, 750, 1000, 160);
  const final = image(output, input.final, 750, 1000, 160);
  const resultBytes = text(scene, rgba(input.final[point]).join(' / '), 750, 1100, 18);
  const outputLink = route([[495, 835], [580, 835], [580, 1000], [655, 1000]]);

  focus(0); show(mask); show(countOne);
  beat('target(mask) saves Canvas and selects one cleared Grayscale8 Mask Surface.');
  focus(1); show(maskLink); hide(clear); show(coverage, .65);
  beat('None keeps the mask Surface selected while the mask Paint writes its alpha bitmap.');
  focus(2); show(attached);
  beat('Alpha restores Canvas and attaches the mask compositor; the bitmap is now a read input.');
  focus(3); show(effect); show(effectLabels[0], .001); show(effectImages[0], .001); show(effectLink);
  wait(.75); hide(countOne); show(countPeak);
  hide(effectLabels[0]); hide(effectImages[0]); show(effectLabels[1]); show(effectImages[1], .6);
  wait(.75); hide(effectLabels[1]); hide(effectImages[1]); show(effectLabels[2]); show(effectImages[2], .6);
  beat('The nested effect compositor saves the mask context. A/B, Blur and Fill run in RGBA Offscreen, with one Blur scratch.');
  focus(4); show(multiply); show(pointLabel); show(output); show(outputLink);
  hide(background); show(final, .8); show(resultBytes, .2);
  beat('Ending the inner None compositor restores Canvas with Alpha masking; the flattened effect image is masked during source-over.', 1.8);
  focus(5); hide(attached); show(detached);
  beat('Ending the outer Alpha compositor restores the earlier context and releases its cache entry, without drawing the mask bitmap onto Canvas.', 2.5);
  return {scene, beats, textIds, textPolicies, imageRegions, duration: time};
}
