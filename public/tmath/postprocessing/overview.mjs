import {tmath} from '../runtime/client.js';
import nativeTrace from './native-trace.mjs';

// Four columns: input data, overall flow, effect processing, pixel results.
// Child Render, Blur Output and Fill Output are successive offscreen snapshots.
export function buildOverview(trace = nativeTrace) {
  const width = 1280, height = 2230;
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: '#202020'}]))}});
  const C = {ink: '#202020', line: '#555555', control: '#202020', controlFill: '#ffffff',
    pixel: '#202020', pixelFill: '#242424', orange: '#e66121', blue: '#1f66c4', muted: '#626262', inverse: '#ffffff', inverseMuted: '#e0e0e0'};
  const rowsY = [650, 900, 1140, 1930, 230, 510, 790, 1070, 1350, 1630];
  // _gaussianInit stores the active radii and their sum in SwGaussianBlur.
  const effectPreparation = {kernels: trace.kernels, extends: trace.kernels.reduce((sum, radius) => sum + radius, 0), fillValid: true};
  const textIds = [], textPolicies = {}, diagramRegions = [], imageRegions = [];
  const owners = new WeakMap(), beats = [], frames = [];
  const stageObjects = [], incoming = [], dataLinks = [], effectIntro = [];
  let serial = 0, time = 0, current = -1;
  const id = name => `overview-${name}-${serial++}`;
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const group = () => scene.group({id: id('group')});
  function text(parent, value, x, y, size = 23, color = C.ink, owner = null, align = [.5, .5]) {
    const key = id('text'); textIds.push(key);
    textPolicies[key] = owner ? {owner: owners.get(owner), inset: 12} : {standalone: true};
    return parent.text({id: key, text: value, point: p(x, y), font: 'Pretendard', role: 'text', size,
      fill: color, align, layer: 30});
  }
  function rect(parent, x, y, w, h, fill = '#00000000', stroke = C.line, border = 2) {
    const key = id('rect');
    const handle = parent.rectangle({id: key, center: p(x, y), size: [w / 100, h / 100], fill, stroke, width: border, layer: 10});
    owners.set(handle, key); return handle;
  }
  function route(points, color = C.line) {
    return scene.route({id: id('route'), points: points.map(([x, y]) => p(x, y)), stroke: color, width: 2.5, tip: 11, layer: 7});
  }
  function wait(duration) {scene.wait(duration); time += duration;}
  function fade(target, opacity, duration = .2) {scene.fade(target, opacity, duration); time += duration;}
  function reveal(target, duration = .4) {scene.fadeIn(target, {duration}); time += duration;}
  function revealAll(targets, duration = .001) {for (const target of targets) reveal(target, duration);}
  function beat(label, hold = 1.2) {beats.push({time: +time.toFixed(3), label}); wait(hold);}
  function focus(index) {
    if (current >= 0) fade(frames[current], 0);
    if (incoming[index]) reveal(incoming[index], .2);
    if (index >= 4) revealAll(stageObjects[index]);
    reveal(frames[index], .3); current = index;
  }

  // White nodes prepare/control; dark nodes process pixels. The outer frame marks execution focus.
  rect(scene, 54, 42, 26, 22, C.controlFill, C.control);
  text(scene, 'Prepare · Control', 190, 42, 21);
  rect(scene, 410, 42, 26, 22, C.pixelFill, C.pixel);
  text(scene, 'Process Pixel', 550, 42, 21);
  const apiBox = rect(scene, 450, 280, 260, 108, C.controlFill, C.control);
  text(scene, 'Update', 450, 263, 22, C.ink, apiBox);
  text(scene, 'canvas->update()', 450, 303, 17, C.ink, apiBox);
  const apiFrame = rect(scene, 450, 280, 268, 116, '#00000000', C.ink, 3);
  route([[450, 340], [450, rowsY[0] - 60]]);
  const apiLink = route([[270, 280], [310, 280]]);
  const stages = [
    ['Scene Update', 'SceneImpl::update()', 'control'],
    ['Prepare Tasks', 'SwRenderer::prepare()', 'control'],
    ['Worker Tasks', 'SwShapeTask::run()', 'control'],
    ['1 · Render Shape', 'BG → Canvas Surface', 'pixel'],
    ['target()', 'surface = Offscreen', 'control', 'beginComposite()'],
    ['Render Shapes', 'A, B → Offscreen', 'pixel'],
    ['GaussianBlur', 'effects[0]', 'pixel'],
    ['Fill', 'effects[1]', 'pixel'],
    ['endComposite()', '→ Canvas Surface', 'control'],
    ['rasterDirectImage()', 'inside endComposite', 'pixel'],
  ];
  stages.forEach(([name, detail, kind, after], index) => {
    const x = index === 2 ? 150 : index < 4 ? 450 : 790;
    const nodeInk = kind === 'pixel' ? C.inverse : C.ink;
    const nodeMuted = kind === 'pixel' ? C.inverseMuted : C.muted;
    const y = rowsY[index], box = rect(scene, x, y, 260, after ? 120 : 108, C[`${kind}Fill`], C[kind]);
    stageObjects[index] = [box,
      text(scene, name, x, y - (after ? 30 : 17), index < 4 ? 21 : 19, nodeInk, box),
      text(scene, detail, x, y + (after ? 0 : 23), 17, nodeMuted, box)];
    if (after) stageObjects[index].push(text(scene, after, x, y + 30, 17, nodeInk, box));
    frames.push(rect(scene, x, y, 268, after ? 128 : 116, '#00000000', C.ink, 3));
    if (index === 0) route([[x, y + 60], [x, rowsY[index + 1] - 60]]);
    else if (index >= 4 && index < 9) incoming[index + 1] = route([[x, y + (after ? 66 : 60)], [x, rowsY[index + 1] - 60]]);
    if (index === 0) dataLinks[index] = route([[270, y], [310, y]]);
    else if (index === 2) dataLinks[index] = route([[150, y + 60], [150, 1240]]);
    else if (index < 4) dataLinks[index] = route([[310, y], [270, y]]);
    diagramRegions.push({x: index < 4 ? 40 : index === 6 ? 980 : 1000, y: y - 135, width: index === 6 ? 300 : 220, height: 265});
  });
  const workerRequest = route([[150, 970], [150, 1080]]);
  text(scene, 'async', 222, 1025, 16, C.muted);
  const prepareEffectsBox = rect(scene, 450, 1140, 260, 108, C.controlFill, C.control);
  text(scene, 'Prepare Effects', 450, 1110, 21, C.ink, prepareEffectsBox);
  text(scene, 'prepare(effect,', 450, 1143, 17, C.muted, prepareEffectsBox);
  text(scene, 'transform)', 450, 1170, 17, C.muted, prepareEffectsBox);
  const prepareEffectsFrame = rect(scene, 450, 1140, 268, 116, '#00000000', C.ink, 3);
  const prepareEffectsLink = route([[450, 960], [450, 1080]]);
  text(scene, 'caller thread', 450, 1218, 16, C.muted);
  scene.line({id: id('update-draw-boundary'), from: p(20, 1490), to: p(610, 1490), stroke: C.line, width: 1.5, layer: 7});
  const drawBox = rect(scene, 450, 1610, 260, 108, C.controlFill, C.control);
  text(scene, 'canvas->draw()', 450, 1593, 22, C.ink, drawBox);
  text(scene, 'preRender()', 450, 1633, 17, C.muted, drawBox);
  const drawFrame = rect(scene, 450, 1610, 268, 116, '#00000000', C.ink, 3);
  // The caller continues after effect preparation, without joining the worker here.
  route([[584, 1140], [600, 1140], [600, 1530], [450, 1530], [450, 1550]]);
  route([[450, 1670], [450, 1710]]);
  // The numbered Paint visits are inside the Main Scene render loop.
  scene.rectangle({id: id('main-scene-scope'), center: p(450, 1925), size: [3, 4.7],
    fill: '#00000000', stroke: C.ink, width: 2, dash: [8, 6], layer: 2});
  const mainBox = rect(scene, 450, 1770, 260, 108, C.controlFill, C.control);
  text(scene, 'Main Scene', 450, 1753, 22, C.ink, mainBox);
  text(scene, 'for (paint : paints)', 450, 1793, 17, C.muted, mainBox);
  const mainFrame = rect(scene, 450, 1770, 268, 116, '#00000000', C.ink, 3);
  route([[450, 1830], [450, rowsY[3] - 60]]);
  const effectBox = rect(scene, 450, 2090, 260, 108, C.pixelFill, C.pixel);
  text(scene, '2 · Render Scene', 450, 2073, 22, C.inverse, effectBox);
  text(scene, 'A + B · effects', 450, 2113, 17, C.inverseMuted, effectBox);
  const effectFrame = rect(scene, 450, 2090, 268, 116, '#00000000', C.ink, 3);
  route([[450, rowsY[3] + 60], [450, 2030]]);
  const effectScope = group();
  text(effectScope, 'Draw · Effect Offscreen', 790, 117, 23);
  effectScope.rectangle({id: id('effect-scope'), center: p(790, 1030), size: [3, 17.4],
    fill: '#00000000', stroke: C.ink, width: 2, dash: [8, 6], layer: 2});
  effectIntro.push(effectScope);
  // This bracket expands Render Scene; it is not a second execution path.
  for (const [a, b] of [[[580, 2090], [615, 2090]], [[650, 160], [615, 2090]], [[615, 2090], [650, 1905]]])
    effectIntro.push(scene.line({id: id('expansion'), from: p(...a), to: p(...b), stroke: C.line, width: 2, layer: 7}));

  // Each right-hand snapshot owns a full row; captions never overlap its pixels.
  const blank = Array(trace.width * trace.height).fill(0);
  function image(parent, pixels, x, y, size = 176) {
    const colors = pixels.map((v, i) => {
      const a = (v >>> 24) / 255, bg = ((i % trace.width) + Math.floor(i / trace.width)) % 2 ? 241 : 250;
      return '#' + [v & 255, (v >>> 8) & 255, (v >>> 16) & 255]
        .map(c => Math.min(255, Math.round(c + bg * (1 - a))).toString(16).padStart(2, '0')).join('');
    });
    const key = id('pixels'); imageRegions.push(key);
    return parent.image({id: key, pixels: colors, size: [trace.width, trace.height], center: p(x, y), width: size / 100, filter: 'nearest', layer: 5});
  }
  function slot(index, label, pixels = blank, detail = '', x = index < 4 ? 150 : 1110, size = 176) {
    const g = group(), y = rowsY[index];
    text(g, label, x, y - 113, 20);
    rect(g, x, y, size, size);
    if (detail) text(g, detail, x, y + 111, 17);
    return {g, x, y, size, handle: image(g, pixels, x, y, size)};
  }
  function replace(target, pixels, hold = .16) {
    fade(target.handle, 0, .001);
    target.handle = image(target.g, pixels, target.x, target.y, target.size); wait(hold);
  }
  function scanRows(target, before, after, count = 12) {
    const state = [...before];
    for (let y = 0; y < trace.height; y += count) {
      for (let row = y; row < Math.min(trace.height, y + count); row++)
        for (let x = 0; x < trace.width; x++) state[row * trace.width + x] = after[row * trace.width + x];
      replace(target, state, .18);
    }
  }
  function writeSpans(target, state, writes) {
    for (let i = 0; i < writes.length; i += 24) {
      for (const r of writes.slice(i, i + 24)) r.pixels.forEach((v, j) => state[r.y * trace.width + r.x + j] = v);
      replace(target, state, .2);
    }
  }

  const source = group();
  // Canvas owns BG and Scene as siblings; only Scene owns A/B and the effects.
  text(source, 'Canvas · Main Scene', 35, 520, 20, C.ink, null, [0, .5]);
  text(source, 'BG : Shape', 70, 566, 19, C.ink, null, [0, .5]);
  text(source, 'Scene', 70, 614, 20, C.ink, null, [0, .5]);
  text(source, `opacity ${trace.opacity}\nBlur → Fill`, 98, 660, 16, C.muted, null, [0, .5]);
  text(source, 'A : Shape', 100, 724, 19, C.orange, null, [0, .5]);
  text(source, 'B : Shape', 100, 770, 19, C.blue, null, [0, .5]);
  for (const points of [
    [[45, 540], [45, 566], [60, 566], [45, 566], [45, 614], [60, 614]],
    [[78, 632], [78, 724], [90, 724], [78, 724], [78, 770], [90, 770]],
  ]) source.path({id: id('scene-tree'), commands: points.map(([x, y], index) => ({type: index ? 'line' : 'move', to: p(x, y)})),
    fill: '#00000000', stroke: C.line, width: 1.5, layer: 7});
  const apiCommands = text(scene, [
    'BG->appendRect(...)', '',
    'A->moveTo(...)', 'A->lineTo(...)', 'A->close()', '',
    'B->appendCircle(...)',
  ].join('\n'), 20, 280, 17, C.ink, null, [0, .5]);

  const config = group();
  text(config, 'SwShapeTask', 150, rowsY[1] - 68, 21);
  text(config, 'rshape · transform', 150, rowsY[1] - 20, 17);
  text(config, `clips · opacity ${trace.tasks[1].opacity}`, 150, rowsY[1] + 24, 17);
  const prepared = group();
  text(prepared, 'bbox / RLE', 150, 1266, 21);
  trace.tasks.forEach((task, index) => {
    const y = 1326 + index * 55;
    text(prepared, task.fastTrack ? 'BG · bbox' : `${task.id} · ${task.spans.length} RLE`, 100, y, 17, [C.control, C.orange, C.blue][index]);
    if (task.fastTrack) rect(prepared, 205, y, 48, 28, C.controlFill, C.control);
    else for (const [x, row, len, coverage] of task.spans.filter(v => v[1] >= 12 && v[1] <= 14))
      prepared.line({id: id('span'), from: p(170 + x * 3, y - 16 + (row - 11) * 8), to: p(170 + (x + len) * 3, y - 16 + (row - 11) * 8), stroke: index === 1 ? C.orange : C.blue, opacity: coverage / 255, width: 3, layer: 6});
  });
  const blurParameters = group();
  text(blurParameters, 'GaussianBlur', 450, 1266, 21);
  text(blurParameters, `sigma ${trace.sigma} → rd->kernel`, 450, 1306, 17);
  const kernelValues = effectPreparation.kernels.map((radius, index, radii) => {
    const value = group(), x = 450 + (index - (radii.length - 1) / 2) * 54;
    const cell = rect(value, x, 1348, 46, 50, C.controlFill, C.control, 1.5);
    text(value, String(radius), x, 1348, 18, C.ink, cell);
    return value;
  });
  const blurExtent = text(scene, `rd->extends = ${effectPreparation.extends}`, 450, 1396, 18);
  const fillValidity = text(scene, `Fill · valid = ${effectPreparation.fillValid}`, 450, 1444, 18);
  const parent = slot(3, 'Canvas Surface');
  const allocated = slot(4, 'Offscreen · clear');
  const raster = slot(5, 'Offscreen · A + B', blank, 'A → B · opacity 255');
  const blurred = slot(6, 'Offscreen', trace.offscreen, '', 1050, 128);
  const scratch = slot(6, 'Scratch', trace.passes[0].pixels, '', 1200, 128);
  const blurDirections = [text(scene, 'Offscreen → Scratch', 1110, 915, 17), text(scene, 'Scratch → Offscreen', 1110, 915, 17)];
  const scratchReusable = text(scene, 'reusable', 1200, 880, 16);
  const countOne = text(scene, `Temp pixel buffers: ${trace.buffers.afterTarget}`, 1110, 42, 20);
  const countTwo = text(scene, `Temp pixel buffers: ${trace.buffers.temporaryPeak}`, 1110, 42, 20);
  const countNote = text(scene, 'Canvas Surface excluded', 1110, 75, 17);
  const recolored = slot(7, 'Offscreen · filled', blank, 'in-place · no allocation');
  const restored = slot(8, 'Canvas Surface', trace.parentBeforeComposite);
  const output = slot(9, 'Final Canvas Surface', trace.background, `opacity ${trace.opacity} · source-over`);
  const targetLabel = text(scene, 'Render target', 150, 1575, 20);
  const activeTargets = ['Canvas Surface', 'Offscreen'].map(label => text(scene, label, 150, 1615, 20));

  // Canvas pixels are retained while offscreen content changes through the chain.
  const parentCarry = route([[150, parent.y + 100], [150, 2170], [955, 2170], [955, restored.y], [1010, restored.y]], C.control);
  const blurInput = route([[1210, raster.y + 26], [1268, raster.y + 26], [1268, 650], [1050, 650], [1050, 663]], C.pixel);
  const fillInput = route([[1050, 864], [985, 864], [985, recolored.y - 26], [1010, recolored.y - 26]], C.pixel);
  const effectToOutput = route([[1210, recolored.y + 26], [1242, recolored.y + 26], [1242, output.y], [1210, output.y]], C.pixel);
  const destToOutput = route([[1110, restored.y + 100], [1110, restored.y + 135], [970, restored.y + 135], [970, output.y], [1010, output.y]], C.control);

  // Reveal connections and detail at their owning step; retain the completed map.
  reveal(apiFrame, .3); reveal(apiCommands); reveal(apiLink, .2);
  const posterTime = time;
  wait(2); fade(apiFrame, 0);
  focus(0); reveal(source); reveal(dataLinks[0], .2);
  wait(.8); focus(1); reveal(config); reveal(dataLinks[1], .2);
  reveal(workerRequest, .25); focus(2);
  beat('Scene update calls child Paint updates, which request SwShapeTasks for bbox and RLE preparation.');
  reveal(prepareEffectsLink, .25); reveal(prepareEffectsFrame, .3);
  reveal(blurParameters, .3); revealAll(kernelValues, .25); reveal(blurExtent, .3);
  reveal(fillValidity, .3); reveal(dataLinks[2], .2); reveal(prepared, .4);
  beat('After requesting child preparation, Scene update prepares effects on the caller thread: GaussianBlur stores kernel radii and their extent; Fill becomes valid. Worker preparation can overlap this work and Draw.', 1.8);
  fade(prepareEffectsFrame, 0);
  fade(frames[current], 0); current = -1;
  reveal(drawFrame); reveal(targetLabel, .2); reveal(activeTargets[0], .3); wait(1.2); fade(drawFrame, 0);
  reveal(mainFrame); wait(1.2); fade(mainFrame, 0);
  focus(3); reveal(parent.g); reveal(dataLinks[3], .2); scanRows(parent, blank, trace.background);
  beat('Canvas draw enters its internal Main Scene and iterates paints in order: first BG Shape, then the sibling Scene containing A and B.');
  reveal(effectFrame); revealAll(effectIntro, .12);
  focus(4); reveal(allocated.g);
  fade(activeTargets[0], 0, .001); reveal(activeTargets[1], .3);
  reveal(countOne, .2); reveal(countNote, .2); wait(.8);
  focus(5); reveal(raster.g); const rasterState = [...blank];
  writeSpans(raster, rasterState, trace.writes[0]); wait(.7); writeSpans(raster, rasterState, trace.writes[1]);
  beat('target sets surface to Offscreen; beginComposite configures group opacity. A and B render into Offscreen while Canvas Surface is preserved.');
  focus(6); reveal(blurInput); reveal(blurred.g);
  fade(countOne, 0, .001); reveal(countTwo, .2);
  reveal(scratch.g); reveal(blurDirections[0], .001); wait(.35);
  for (let i = 1; i < trace.passes.length; i++) {
    const pass = trace.passes[i], direction = pass.to === 'scratch' ? 0 : 1;
    fade(blurDirections[1 - direction], 0, .001); reveal(blurDirections[direction], .001);
    replace(pass.to === 'scratch' ? scratch : blurred, pass.pixels, .35);
  }
  reveal(scratchReusable, .2);
  beat('GaussianBlur alternates writes between two physical buffers; its final result is in Offscreen. Scratch is reusable.');
  focus(7); reveal(fillInput); reveal(recolored.g); scanRows(recolored, trace.chain[0].output, trace.chain[1].output);
  beat('Fill modifies the same Offscreen in place without requesting another buffer. Canvas Surface is unchanged.');
  focus(8); fade(activeTargets[1], 0, .001); reveal(activeTargets[0], .3);
  reveal(restored.g); reveal(parentCarry); wait(1.1);
  focus(9); reveal(destToOutput); reveal(effectToOutput); reveal(output.g);
  scanRows(output, trace.parentBeforeComposite, trace.final, 12);
  fade(effectFrame, 0);
  beat('endComposite restores Canvas Surface as the render target; rasterDirectImage applies group opacity to the Fill output and writes source-over onto that same buffer.', 3.5);
  return {scene, beats, textIds, textPolicies, imageRegions, diagramRegions, effectPreparation, posterTime, duration: time};
}
