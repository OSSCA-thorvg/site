import {tmath} from '../runtime/client.js';
import {trace, rgba, replaySpans} from './native-evidence.mjs';
import {buildEffectPipeline} from './effect-pipeline.mjs';

export const nativeEpisodes = new Set(['effect-pipeline', 'begin', 'raster', 'chain', 'composite', 'output']);
const C = {ink: '#202020', muted: '#626262', line: '#555555', control: '#202020', controlFill: '#ffffff',
  pixel: '#202020', pixelFill: '#242424', orange: '#e66121', blue: '#1f66c4', focus: '#202020', inverse: '#ffffff', inverseMuted: '#e0e0e0'};
const blank = Array(trace.width * trace.height).fill(0);
const pointIndex = trace.point[1] * trace.width + trace.point[0];

// The same 24×24 native trace carries from Overview through every pipeline episode.
export function buildPipeline(id) {
  if (id === 'effect-pipeline') return buildEffectPipeline();
  const width = 960;
  const height = id === 'output' ? 750 : id === 'composite' ? 920 : id === 'raster' ? 720 : 540;
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: C.ink}]))}});
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  let serial = 0, time = 0;
  const textIds = [], textPolicies = {}, imageRegions = [], owners = new WeakMap(), beats = [];
  const key = name => `${id}-${name}-${serial++}`;
  const group = () => scene.group({id: key('group')});
  function text(parent, value, x, y, size = 23, owner = null, color = C.ink) {
    const name = key('text'); textIds.push(name);
    textPolicies[name] = owner ? {owner: owners.get(owner), inset: 12} : {standalone: true};
    return parent.text({id: name, text: value, point: p(x, y), size, font: 'Pretendard', role: 'text',
      fill: color, align: [.5, .5], layer: 30});
  }
  function rect(parent, x, y, w, h, fill = '#00000000', stroke = C.line, border = 2) {
    const name = key('rect');
    const handle = parent.rectangle({id: name, center: p(x, y), size: [w / 100, h / 100], fill, stroke, width: border, layer: 10});
    owners.set(handle, name); return handle;
  }
  function node(label, detail, x, y, kind = 'control', w = 320) {
    const g = group(), box = rect(g, x, y, w, 108, C[`${kind}Fill`], C[kind]);
    text(g, label, x, y - 17, 23, box, kind === 'pixel' ? C.inverse : C.ink);
    if (detail) text(g, detail, x, y + 23, 19, box, kind === 'pixel' ? C.inverseMuted : C.muted);
    const focus = rect(scene, x, y, w + 8, 116, '#00000000', C.focus, 3);
    return {g, focus};
  }
  function route(points, color = C.line, tip = 11) {
    return scene.route({id: key('route'), points: points.map(([x, y]) => p(x, y)), stroke: color, width: 2.5, tip, layer: id === 'raster' ? 18 : 7});
  }
  function image(parent, pixels, x, y, size) {
    const colors = pixels.map((v, i) => {
      const channels = rgba(v), a = channels[3] / 255;
      const bg = ((i % trace.width) + Math.floor(i / trace.width)) % 2 ? 241 : 250;
      return '#' + channels.slice(0, 3).map(c => Math.min(255, Math.round(c + bg * (1 - a))).toString(16).padStart(2, '0')).join('');
    });
    const name = key('image'); imageRegions.push(name);
    return parent.image({id: name, pixels: colors, size: [trace.width, trace.height], center: p(x, y), width: size / 100,
      filter: 'nearest', layer: 5});
  }
  function buffer(label, pixels, x, y, size = 220, note = '') {
    const g = group();
    text(g, label, x, y - size / 2 - 36, 23);
    rect(g, x, y, size, size);
    if (note) text(g, note, x, y + size / 2 + 35, 19, null, C.muted);
    return {g, x, y, size, handle: image(g, pixels, x, y, size)};
  }
  function mark(target, x = trace.point[0], y = trace.point[1], cells = 1) {
    const unit = target.size / trace.width;
    return rect(scene, target.x - target.size / 2 + (x + .5) * unit,
      target.y - target.size / 2 + (y + .5) * unit, unit * cells, unit, '#00000000', C.focus, 2);
  }
  function wait(duration) {scene.wait(duration); time += duration;}
  function show(target, duration = .4) {scene.fadeIn(target, {duration}); time += duration;}
  function hide(target, duration = .15) {scene.fade(target, 0, duration); time += duration;}
  function beat(label, hold = 1.3) {beats.push({time: +time.toFixed(3), label}); wait(hold);}
  function replace(target, pixels, hold = .3) {
    hide(target.handle, .001); target.handle = image(target.g, pixels, target.x, target.y, target.size); wait(hold);
  }
  function paintRows(target, before, after) {
    const pixels = [...before];
    for (let y = 0; y < trace.height; y += 4) {
      for (let row = y; row < Math.min(y + 4, trace.height); row++) {
        for (let x = 0; x < trace.width; x++) pixels[row * trace.width + x] = after[row * trace.width + x];
      }
      replace(target, pixels, .2);
    }
  }
  function fields(value, x, y, size = 22) {return text(scene, value, x, y, size);}
  function select(item, previous = null) {
    if (previous) hide(previous.focus);
    show(item.focus, .25);
  }

  if (id === 'begin') {
    // Fixed nodes represent the pointer and its two possible destinations.
    // Only the active reference changes; buffer pixels never move.
    function stepNode(label, detail, x, w) {
      const g = group(), box = rect(g, x, 58, w, 84, C.controlFill, C.control);
      text(g, label, x, 40, 21, box);
      text(g, detail, x, 75, 17, box, C.muted);
      const focus = rect(scene, x, 58, w + 8, 92, '#00000000', C.focus, 3);
      return {g, focus};
    }
    function flow(parent, points, tip = 10) {
      return parent.route({id: key('flow'), points: points.map(([x, y]) => p(x, y)),
        stroke: C.ink, width: 2.5, tip, dash: [8, 6], layer: 7});
    }
    const request = stepNode('request()', 'offscreen buffer', 155, 240);
    const target = stepNode('target()', 'surface = cmp', 455, 240);
    const begin = stepNode('beginComposite()', 'opacity · method', 785, 300);
    route([[280, 58], [330, 58]]); route([[580, 58], [630, 58]]);

    const offscreen = group();
    text(scene, 'Canvas Surface', 830, 140, 23);
    rect(scene, 830, 220, 100, 100);
    image(scene, trace.background, 830, 220, 100);
    text(scene, 'BG unchanged', 650, 266, 19, null, C.muted);
    text(offscreen, 'Offscreen', 830, 308, 23);
    rect(offscreen, 830, 385, 100, 100);
    image(offscreen, blank, 830, 385, 100);
    text(offscreen, `${trace.width} × ${trace.height} · clear`, 830, 455, 18, null, C.muted);
    flow(scene, [[255, 300], [400, 300]], 0);
    const toCanvas = flow(scene, [[400, 300], [400, 220], [770, 220]]);
    const toOffscreen = flow(scene, [[400, 300], [400, 385], [770, 385]]);
    scene.circle({id: key('junction'), center: p(400, 300), radius: .045,
      fill: C.ink, stroke: C.ink, width: 0, layer: 8});
    const canvasFocus = rect(scene, 830, 220, 110, 110, '#00000000', C.focus, 3);
    const offscreenFocus = rect(scene, 830, 385, 110, 110, '#00000000', C.focus, 3);
    const surface = group();
    const pointerBox = rect(surface, 155, 300, 200, 86, C.pixelFill, C.pixel);
    text(surface, 'surface', 155, 296, 25, pointerBox, C.inverse);

    const saved = group();
    const savedBox = rect(saved, 515, 164, 342, 60, C.controlFill, C.control);
    text(saved, 'recoverSfc = Canvas Surface', 515, 160, 18, savedBox);
    flow(saved, [[686, 164], [730, 164], [730, 190], [770, 190]]);
    const temp = fields(`Temp buffers: ${trace.buffers.afterTarget}`, 180, 505, 20);
    const config = group(), configBox = rect(config, 665, 504, 530, 58, C.controlFill, C.control);
    text(config, 'MaskMethod::None', 520, 500, 18, configBox);
    text(config, `group opacity = ${trace.opacity}`, 790, 500, 18, configBox);

    beat('The Canvas with BG is the current render target.');
    select(request); show(offscreen); show(temp);
    beat('request returns one temporary pixel buffer; target clears the effect bounds.');
    select(target, request); show(saved);
    scene.fade(toCanvas, .2, .25); time += .25;
    hide(canvasFocus); show(toOffscreen, .3);
    scene.play([{target: toOffscreen, dash_offset: -28}], 1.2, 'linear'); time += 1.2;
    show(offscreenFocus, .25);
    beat('target saves the Canvas context in recoverSfc and selects Offscreen for subsequent Shape writes.');
    select(begin, target); show(config);
    beat('beginComposite stores MaskMethod::None and group opacity. The Canvas pixels are untouched.', 2.5);
  } else if (id === 'raster') {
    // Verified against local ThorVG cdc1c959: tvgScene.h::render visits A then B;
    // tvgShape.h::render passes impl.rd to SwRenderer::renderShape. The latter
    // waits in task->done(), reads the prepared shape and fill, then calls
    // rasterShape -> _rasterRle for this solid-fill, non-fastTrack trace.
    // TaskScheduler::done waits; it does not call run. Task records stay fixed.
    // Beats: prepared records -> A wait/read/raster -> B wait/read/raster ->
    // settled map. Only the selected Offscreen pixels change; Canvas stays BG.
    fields('Scene · A → B', 480, 44, 23);
    for (const [left, right] of [[20, 280], [340, 650]]) {
      scene.route({id: key('region-border'),
        points: [[left, 78], [right, 78], [right, 575], [left, 575], [left, 78]].map(([x, y]) => p(x, y)),
        stroke: '#999999', width: 1.3, dash: [6, 5], tip: 0, layer: 6});
    }
    fields('Prepared data', 150, 105, 22);
    fields('SwRenderer', 495, 105, 22);
    const owner = rect(scene, 495, 355, 280, 400, '#ffffff', C.ink, 1.5);
    const header = rect(scene, 495, 185, 280, 60, C.ink, C.ink, 1.5);
    text(scene, 'renderShape(rd)', 495, 185, 24, header, C.inverse);
    function call(label, y) {
      const box = rect(scene, 495, y, 230, 64, '#ffffff', C.ink, 1.5);
      text(scene, label, 495, y, 22, box);
      return rect(scene, 495, y, 240, 74, '#00000000', C.ink, 2.5);
    }
    const waiting = call('task->done()', 295);
    const writing = call('rasterShape()', 425);
    route([[495, 335], [495, 382]]);
    text(scene, 'valid', 545, 355, 18, owner, C.muted);
    text(scene, '_rasterRle()', 495, 505, 20, owner, C.muted);
    const records = trace.tasks.slice(1);
    for (const [i, task] of records.entries()) {
      const y = 245 + i * 220;
      const record = rect(scene, 150, y, 230, 180, '#ffffff', C.ink, 1.5);
      text(scene, `SwShapeTask · ${task.id}`, 150, y - 62, 20, record);
      // Span starts, lengths and coverage use the existing native trace;
      // muted intensity encodes coverage, never a worker writing pixels.
      for (const [x, row, len, coverage] of task.spans) {
        const shade = Math.round(230 - 198 * coverage / 255).toString(16).padStart(2, '0');
        const unit = 108 / trace.width, left = 96 + x * unit, py = y - 45 + (row + .5) * unit;
        scene.route({id: key('rle-span'), points: [p(left, py), p(left + len * unit, py)],
          stroke: `#${shade}${shade}${shade}`, width: 2.5, tip: 0, layer: 20});
      }
      text(scene, 'shape.rle', 150, y + 65, 18, record, C.muted);
      route([[270, y], [305, y]], C.line, 0);
    }
    route([[305, 245], [305, 465]], C.line, 0);
    const read = route([[305, 425], [370, 425]]);
    const offscreen = buffer('Offscreen', blank, 805, 355, 200);
    fields('surface', 805, 505, 20);
    const write = route([[620, 425], [695, 425]]);
    buffer('Canvas · unchanged', trace.background, 805, 635, 90);
    const state = [...blank];
    // Entrance animations below hide the focus outlines at t=0. Record and
    // call topology stays visible even while span-write snapshots accumulate.
    beat('Prepared Task data is separate from the renderer calls and the Offscreen target.');
    for (let i = 0; i < trace.writes.length; i++) {
      const current = fields(`Shape ${records[i].id}`, 495, 615, 22);
      show(current, .2); show(waiting, .2);
      beat(`renderShape(${records[i].id}) calls task->done before reading prepared data.`, .7);
      hide(waiting); show(writing, .2);
      if (i === 0) { show(read, .2); show(write, .2); }
      for (const frame of replaySpans(trace.writes[i], state)) {
        replace(offscreen, frame.pixels, .24);
        state.splice(0, state.length, ...frame.pixels);
      }
      beat(`rasterShape reads ${records[i].id}'s RLE and writes the current Offscreen.`, .8);
      hide(writing); hide(current);
    }
    beat('A then B remain in one Offscreen; Task records and Canvas pixels are unchanged.', 2.5);
  } else if (id === 'chain') {
    const blur = node('effects[0] · GaussianBlur', 'direct = false', 255, 70, 'pixel', 380);
    const fill = node('effects[1] · Fill', 'in-place · no allocation', 705, 70, 'pixel', 350);
    route([[450, 70], [525, 70]], C.pixel);
    const offscreen = buffer('Offscreen', trace.offscreen, 210, 315, 180);
    const scratch = buffer('Scratch', trace.passes[0].pixels, 500, 315, 180);
    const directions = [route([[312, 315], [398, 315]], C.pixel), route([[398, 315], [312, 315]], C.pixel)];
    const count = fields(`Temp buffers: ${trace.buffers.temporaryPeak}`, 500, 475, 19);
    const oldPixel = fields(`Blur RGBA ${rgba(trace.filtered[pointIndex]).join(' / ')}`, 210, 455, 18);
    const newPixel = fields(`Fill RGBA ${rgba(trace.compositionInput[pointIndex]).join(' / ')}`, 210, 492, 18);
    buffer('Canvas Surface', trace.background, 820, 315, 130, 'unchanged');
    let passLabel;
    beat('The effect loop starts with the already rasterized A/B image.');
    select(blur); show(scratch.g); show(count);
    for (let i = 0; i < trace.passes.length; i++) {
      const pass = trace.passes[i], direction = pass.to === 'scratch' ? 0 : 1;
      hide(directions[1 - direction], .001); show(directions[direction], .001);
      if (passLabel) hide(passLabel, .001);
      passLabel = fields(`pass ${i + 1} / ${trace.passes.length} · ${pass.op}`, 480, 158, 19);
      show(passLabel, .001);
      if (i) replace(pass.to === 'scratch' ? scratch : offscreen, pass.pixels, .55);
      else wait(.55);
    }
    hide(directions[1]); hide(passLabel);
    show(fields('reusable', 500, 435, 18));
    show(mark(offscreen)); show(oldPixel);
    beat('The native Blur passes alternate the two buffers and finish in Offscreen.');
    select(fill, blur); paintRows(offscreen, trace.filtered, trace.compositionInput); show(newPixel);
    beat('Fill reads the Blur result and overwrites the same Offscreen; Canvas remains untouched.');
    show(fields('next: endComposite()', 805, 485, 20));
    beat('The ordered effect loop is complete. Only then is its result composited.', 2.5);
  } else if (id === 'composite') {
    // Local cdc1c959, SwRenderer::endComposite: restore context first;
    // an already valid compositor returns early. This trace uses an active
    // compositor (valid=false) and MaskMethod::None, so mark reusable then
    // rasterDirectImage into recoverSfc. No new Canvas or moving pixel buffer.
    const heading = rect(scene, 480, 45, 400, 70, C.ink, C.ink, 1.5);
    text(scene, 'endComposite()', 480, 45, 27, heading, C.inverse);
    fields('MaskMethod::None', 480, 99, 19);
    for (const [top, bottom] of [[135, 305], [355, 465], [515, 850]]) {
      scene.route({id: key('step-border'),
        points: [[30,top],[930,top],[930,bottom],[30,bottom],[30,top]].map(([x,y])=>p(x,y)),
        stroke:'#999999',width:1.3,dash:[6,5],tip:0,layer:6});
    }
    const restored = group();
    text(restored, '1. Restore context', 480, 170, 23);
    const context = rect(restored, 480, 245, 600, 100, '#ffffff', C.ink, 1.5);
    text(restored, 'surface = p->recoverSfc', 480, 225, 22, context);
    text(restored, 'surface->compositor = p->recoverCmp', 480, 265, 21, context);
    // Dashed pointer denotes the restored destination, not pixel transfer.
    restored.route({id: key('restored-target'), points: [[785,245],[945,245],[945,680],[910,680]].map(([x,y])=>p(x,y)),
      stroke:C.muted,width:1.5,dash:[6,5],tip:9,layer:7});
    const released = group();
    text(released, '2. Mark reusable', 480, 389, 23);
    text(released, 'p->valid = true', 480, 430, 21, null, C.muted);
    buffer('Offscreen', trace.compositionInput, 150, 680, 180);
    const canvas = buffer('Canvas', trace.background, 810, 680, 180);
    fields('premultiplied RGBA', 480, 815, 21);
    const composite = node('rasterDirectImage()', 'group opacity', 480, 680, 'pixel', 300);
    const step = fields('3. Composite', 480, 549, 23);
    const input = route([[250,680],[320,680]]);
    const output = route([[640,680],[710,680]]);
    beat('The completed effect image and preserved Canvas remain in separate buffers.');
    show(restored);
    beat('Recover the parent Surface and compositor; Canvas pixels are unchanged.');
    show(released);
    beat('The active compositor is marked reusable before rasterDirectImage is called.');
    show(step); show(composite.g); show(input); show(output); select(composite);
    paintRows(canvas, trace.background, trace.final);
    beat('rasterDirectImage applies group opacity and writes into that same restored Canvas.', 2.5);
  } else if (id === 'output') {
    const post = node('postRender()', 'after Main Scene returns', 480, 85, 'control', 400);
    const normal = node('ABGR8888', 'keep premultiplied bytes', 250, 265, 'control', 330);
    const straight = node('ABGR8888S', 'rasterUnpremultiply()', 710, 265, 'control', 330);
    // One shared stem, then equal-length drops into the node top edges.
    route([[480, 139], [480, 175]], C.line, 0);
    route([[480, 175], [250, 175], [250, 211]]);
    route([[480, 175], [710, 175], [710, 211]]);
    const left = buffer('Overview output', trace.final, 250, 465, 150);
    const right = buffer('A = 255 · same bytes', trace.final, 710, 465, 150);
    const cleanup = node('dirtyRegion.clear()', 'fulldraw = false', 480, 665, 'control', 420);
    select(post); beat('All Scene rendering and composition have already completed.');
    select(normal, post); show(left.g); beat('This example uses ABGR8888 and keeps premultiplied storage.');
    select(straight, normal); show(right.g);
    beat('Straight-alpha output takes a separate conversion branch. The opaque example needs no RGB change.');
    select(cleanup, straight); beat('postRender clears frame bookkeeping; it is outside the Scene effect loop.', 2.5);
  }
  return {scene, beats, textIds, textPolicies, imageRegions, duration: time};
}
