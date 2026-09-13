import {buildFlagFlow} from './flag-flow.mjs';
import {tmath} from '../runtime/client.js';
import {shapeEvidence, clipSpans, imagePreparation, invalidationInputs, firstFrameInputs, premultiplyRgba, sourceCommit} from './prepare-model.mjs';

const BLACK = '#222222', GRAY = '#757575', LIGHT = '#dedede', WHITE = '#f7f7f7';
const ORANGE = '#e66121', BLUE = '#1f6bc4';

// 1280×900; source pixels are Y-down, scene world coordinates are Y-up.
// Text belongs to its memory/node rectangle or is an intentionally freestanding label.
function drawing(name) {
  const scene = tmath.scene({width: 1280, height: 900, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: 9},
    theme: {preset: 'pro_white', background: WHITE, text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: BLACK}]))}});
  const textIds = [], textPolicies = {}, beats = [];
  let serial = 0, time = 0;
  const id = type => `update-${name}-${type}-${serial++}`;
  const p = (x, y) => [(x - 640) / 100, (450 - y) / 100];
  const group = () => scene.group({id: id('group')});
  const text = (parent, value, x, y, size = 24, color = BLACK, owner) => {
    const key = id('text'); textIds.push(key);
    textPolicies[key] = owner ? {owner, inset: 10} : {standalone: true};
    return parent.text({id: key, text: value, point: p(x, y), size, font: 'Pretendard',
      role: 'text', align: [.5, .5], fill: color, layer: 40});
  };
  const rect = (parent, x, y, w, h, fill = '#00000000', stroke = BLACK, line = 1.4, layer = 10, corner = 0) => {
    const key = id('rect');
    return {key, handle: parent.rectangle({id: key, center: p(x, y), size: [w / 100, h / 100],
      fill, stroke, width: line, layer, corner: corner / 100})};
  };
  const box = (parent, label, x, y, w = 220, h = 64, color = BLACK, size = 24) => {
    const r = rect(parent, x, y, w, h, WHITE, color);
    text(parent, label, x, y, size, color, r.key);
    return r.handle;
  };
  const line = (parent, points, color = BLACK, width = 1.6, dash = []) => parent.route({
    id: id('route'), points: points.map(v => p(...v)), stroke: color, width, fill: '#00000000', tail: 0, tip: 0,
    ...(dash.length ? {dash} : {}), layer: 8});
  const arrow = (parent, points, color = BLACK, dash = [6, 5]) => parent.route({
    id: id('arrow'), points: points.map(v => p(...v)), stroke: color, width: 1.7,
    fill: '#00000000', ...(dash.length ? {dash} : {}), tip: 9, layer: 8});
  const polygon = (parent, points, stroke = BLACK, fill = '#00000000', width = 2, layer = 15) => parent.polygon({
    id: id('polygon'), points: points.map(v => p(...v)), fill, stroke, width, layer});
  const shape = (parent, type, x, y, color, scale = 1) => {
    if (type === 'A') return polygon(parent, [[x - 10 * scale, y - 37 * scale],
      [x - 38 * scale, y + 32 * scale], [x + 39 * scale, y + 32 * scale]], color, color);
    return rect(parent, x, y, 73 * scale, 65 * scale, color, color, 1, 15, 13 * scale).handle;
  };
  const wait = duration => {scene.wait(duration); time += duration;};
  const show = (target, duration = .5) => {scene.fadeIn(target, {duration}); time += duration;};
  const hide = (target, duration = .25) => {scene.fade(target, 0, duration, 'linear'); time += duration;};
  const create = (target, duration = .6) => {scene.create(target, duration, 'linear'); time += duration;};
  const play = (actions, duration = .7, lag = 0) => {
    scene.play(actions, duration, 'ease_in_out', lag / duration);
    time += duration + lag * (actions.length - 1);
  };
  const move = (target, dx, dy, duration = .8) => play([{target, shift: [dx / 100, -dy / 100]}], duration);
  const beat = (label, hold = 1.1) => {beats.push({time, label}); wait(hold);};
  const finish = data => ({scene, beats, textIds, textPolicies, duration: time, sourceCommit, data});
  return {scene, id, p, group, text, rect, box, line, arrow, polygon, shape, wait, show, hide, create, play, move, beat, finish};
}

export function buildFirstFrame() {
  return buildFlagFlow(drawing('first-frame'), firstFrameInputs(), true);
}

export function buildInvalidation(options) {
  return buildFlagFlow(drawing('invalidation'), invalidationInputs(options), false);
}

function spanGeometry(d, parent, spans, left, top, unit, color = BLACK) {
  return spans.map(([x, y, len, coverage]) => {
    const rgb = color.match(/\w\w/g).map(v => parseInt(v, 16));
    const fill = '#' + rgb.map(c => Math.round(c * coverage / 255 + 247 * (1 - coverage / 255)).toString(16).padStart(2, '0')).join('');
    return d.rect(parent, left + (x + len / 2) * unit, top + (y + .5) * unit,
      len * unit - .4, unit - .6, fill, '#00000000', 0, 14).handle;
  });
}

// Six beats: API path; exported outline; rectangle fast track; real native spans;
// separate style outputs; clipping trims those spans. Native AA bytes are unchanged.
export function buildShape() {
  const d = drawing('shape'), {scene, group, text, rect, box, line, arrow, polygon, show, create, play, beat, finish} = d;
  const points = shapeEvidence.points;
  text(scene, 'shape->appendRect(...);     a->moveTo(...); a->lineTo(...);', 640, 43, 27);
  ['Path', 'Exported outline', 'Prepared'].forEach((label, i) => text(scene, label, [207, 627, 1080][i], 108, 24, GRAY));
  const rectInput = group();
  rect(rectInput, 207, 218, 170, 104, '#00000000', BLACK, 3);
  text(rectInput, 'Rect', 207, 297, 23);
  const rectExport = group();
  rect(rectExport, 627, 218, 170, 104, '#00000000', BLACK, 3);
  [[542, 166], [712, 166], [712, 270], [542, 270]].forEach(([x, y]) => rect(rectExport, x, y, 7, 7, BLACK, BLACK));
  const rectRoute = group();
  arrow(rectRoute, [[307, 218], [506, 218]]);
  text(rectRoute, 'utilExport(M)', 408, 179, 21);
  const decision = group();
  polygon(decision, [[801, 164], [867, 218], [801, 272], [735, 218]], BLACK, WHITE, 1.5);
  text(decision, 'Rect?', 801, 217, 21);
  const fastRoute = group();
  arrow(fastRoute, [[868, 218], [956, 218]]);
  text(fastRoute, 'yes', 912, 183, 20);
  const fast = group();
  rect(fast, 1080, 218, 195, 114, '#00000000', BLACK, 3);
  text(fast, 'renderBox', 1080, 218, 22);
  text(fast, 'fastTrack = true', 1080, 309, 23);
  text(fast, 'axis-aligned · no clips', 1080, 349, 20, GRAY);
  const input = group();
  polygon(input, points.map(([x, y]) => [45 + x * 13, 370 + y * 13]), ORANGE, '#00000000', 3);
  text(input, 'A', 207, 665, 24, ORANGE);
  const outline = group();
  polygon(outline, points.map(([x, y]) => [458 + x * 13, 370 + y * 13]), ORANGE, '#00000000', 3);
  points.forEach(([x, y]) => rect(outline, 458 + x * 13, 370 + y * 13, 8, 8, ORANGE, ORANGE));
  const inputRoute = group();
  arrow(inputRoute, [[315, 512], [461, 512]]);
  text(inputRoute, 'utilExport(M)', 390, 465, 21);
  const rleRoute = group();
  arrow(rleRoute, [[724, 512], [920, 512]]);
  text(rleRoute, 'rleRender()', 822, 468, 21);
  text(rleRoute, 'fastTrack = false', 822, 559, 20, GRAY);
  const rle = group();
  const spans = spanGeometry(d, rle, shapeEvidence.spans, 920, 367, 13, ORANGE);
  text(rle, 'shape.rle', 1080, 665, 23, ORANGE);
  const noRle = group();
  text(noRle, 'no fill RLE', 801, 313, 19, GRAY);
  const styles = group();
  line(styles, [[70, 703], [1210, 703]], LIGHT);
  text(styles, 'Stroke', 214, 742, 23);
  text(styles, 'Gradient', 627, 742, 23);
  text(styles, 'Clip', 1078, 742, 23);
  const stroke = group();
  const strokeOutline = polygon(stroke, [[130, 789], [99, 849], [170, 849]], ORANGE, '#00000000', 11);
  arrow(stroke, [[191, 823], [248, 823]]);
  box(stroke, 'strokeRle', 340, 823, 163, 62, BLACK, 21);
  const gradient = group();
  const gradientCells = [];
  for (let i = 0; i < 10; i++) {
    const blend = i / 9, c = [230 + (31 - 230) * blend, 97 + (107 - 97) * blend, 33 + (196 - 33) * blend];
    const color = '#' + c.map(v => Math.round(v).toString(16).padStart(2, '0')).join('');
    gradientCells.push(rect(gradient, 518 + i * 24, 804, 24, 31, color, '#00000000', 0).handle);
  }
  text(gradient, 'color table + transform', 627, 858, 21);
  const clipped = group();
  const clipBox = [8, 9, 15, 18], result = clipSpans(shapeEvidence.spans, clipBox);
  spanGeometry(d, clipped, result, 995, 749, 5.5, ORANGE);
  rect(clipped, 995 + (clipBox[0] + clipBox[2]) / 2 * 5.5,
    749 + (clipBox[1] + clipBox[3]) / 2 * 5.5, (clipBox[2] - clipBox[0]) * 5.5,
    (clipBox[3] - clipBox[1]) * 5.5, '#00000000', BLACK, 2, 22);
  text(clipped, 'rleClip()', 1171, 823, 21);
  const clipping = group();
  rect(clipping, 920 + (clipBox[0] + clipBox[2]) / 2 * 13,
    367 + (clipBox[1] + clipBox[3]) / 2 * 13, (clipBox[2] - clipBox[0]) * 13,
    (clipBox[3] - clipBox[1]) * 13, '#00000000', BLACK, 2.5, 25);
  beat('The same Shape prepare entry receives a rectangle or A’s actual triangle path.', .8);
  create(rectRoute); show(rectExport); create(inputRoute); create(outline);
  beat('The pool outline is exported through M before bounds and route selection.');
  show(decision); create(fastRoute); show(fast); show(noRle);
  beat('An axis-aligned rectangle without clips retains renderBox and bypasses fill RLE.');
  create(rleRoute);
  // Reveal actual native row records; the geometry itself supplies the RLE comparison.
  show(rle, .15);
  // Every span has an entrance; their common label remains visible throughout construction.
  for (const y of [...new Set(shapeEvidence.spans.map(v => v[1]))]) {
    const row = spans.filter((_, i) => shapeEvidence.spans[i][1] === y);
    for (const target of row) show(target, .035);
    d.wait(.035);
  }
  beat('A retains the native [x, y, length, coverage] spans after rleRender().', 1.4);
  show(styles); show(stroke, .2); create(strokeOutline, .7); show(gradient, .2);
  for (const target of gradientCells) show(target, .05);
  beat('Stroke produces a separate strokeRle; a gradient prepares its table and transform.');
  show(clipping); show(clipped);
  play(spans.filter((_, i) => {
    const [x, y, len] = shapeEvidence.spans[i];
    return y < clipBox[1] || y >= clipBox[3] || x + len <= clipBox[0] || x >= clipBox[2];
  }).map(target => ({target, opacity: .25})), .6);
  beat('Clipping intersects prepared fill/stroke spans. Color pixels are still deferred to Draw.', 2.3);
  return finish({points, spans: shapeEvidence.spans, clipBox, clippedSpans: result,
    artifacts: ['renderBox', 'shape.rle', 'strokeRle', 'color table', 'clipped RLE']});
}

// Six beats: loader branch; source storage normalization; size/M geometry;
// bbox + mode; optional clip RLE; prepared record. No texture sampling occurs here.
export function buildImage(options) {
  const model = imagePreparation(options), d = drawing('image');
  if (!model.spans) throw new Error('Image motion requires the native 2×2 affine fixture or an integer translation of it.');
  const {scene, group, text, rect, box, arrow, polygon, shape, show, hide, create, play, beat, finish} = d;
  text(scene, 'picture->transform(M);  picture->clip(clip);  canvas->update();', 640, 43, 27);
  box(scene, 'Picture::update()', 640, 130, 265, 64);
  const loaded = group();
  box(loaded, 'loader->sync()', 640, 225, 250, 60, BLACK, 23);
  arrow(loaded, [[640, 163], [640, 194]]);
  const bitmapBranch = group(), vectorBranch = group();
  arrow(bitmapBranch, [[514, 225], [215, 225], [215, 289]]);
  arrow(vectorBranch, [[766, 225], [1070, 225], [1070, 286]]);
  text(bitmapBranch, 'Bitmap', 348, 187, 24);
  text(vectorBranch, 'Vector', 925, 187, 24);
  const storage = group(), normalized = group();
  const bytes = [[230, 97, 33, 255], [31, 107, 196, 255], [192, 128, 64, 128], [238, 238, 238, 255]];
  const premultiplied = bytes.map(premultiplyRgba);
  const rgb = value => '#' + value.slice(0, 3).map(v => v.toString(16).padStart(2, '0')).join('');
  for (let i = 0; i < 4; i++) {
    rect(storage, 164 + i % 2 * 82, 329 + Math.floor(i / 2) * 82, 80, 80, rgb(bytes[i]), WHITE, 1.5);
    rect(normalized, 164 + i % 2 * 82, 329 + Math.floor(i / 2) * 82, 80, 80, rgb(premultiplied[i]), WHITE, 1.5);
  }
  const sourceLabel = group();
  text(sourceLabel, `${model.width} × ${model.height} · data · stride`, 210, 484, 22);
  const normalizeLabel = group();
  text(normalizeLabel, 'CS + premultiply', 210, 535, 22);
  const nested = group();
  rect(nested, 1070, 372, 300, 167, '#00000000', BLACK);
  text(nested, 'Scene', 1070, 319, 23);
  shape(nested, 'A', 1006, 386, ORANGE, .72);
  shape(nested, 'B', 1134, 386, BLUE, .72);
  text(nested, 'Paint::update() × children', 1070, 484, 22);
  const prepare = group();
  box(prepare, 'SwImageTask::run()', 640, 347, 326, 65, BLACK, 24);
  arrow(prepare, [[288, 368], [475, 368]]);
  text(prepare, 'surface + M', 391, 326, 21);
  const mapping = group();
  text(mapping, 'imagePrepare()', 636, 444, 23);
  const origin = [427, 483], unit = 13;
  rect(mapping, origin[0] + 12 * unit, origin[1] + 12 * unit, 24 * unit, 24 * unit, '#00000000', LIGHT, 1);
  const map = point => [origin[0] + point[0] * unit, origin[1] + point[1] * unit];
  // Four corners retain their source identity through the affine export.
  const untransformed = group();
  polygon(untransformed, model.points.map(v => map(v)), BLACK, '#00000000', 3);
  const preparedQuad = group();
  polygon(preparedQuad, model.transformed.map(v => map(v)), BLACK, '#00000000', 3);
  model.transformed.forEach(v => rect(preparedQuad, ...map(v), 8, 8, BLACK, BLACK));
  const imageRle = group();
  const nativeRows = spanGeometry(d, imageRle, model.spans, origin[0], origin[1], unit, GRAY);
  const bbox = group();
  const [x0, y0, x1, y1] = model.renderBox;
  rect(bbox, ...map([(x0 + x1) / 2, (y0 + y1) / 2]), (x1 - x0) * unit, (y1 - y0) * unit,
    '#00000000', BLUE, 2, 20);
  text(bbox, 'renderBox', 795, 628, 21, BLUE);
  const matrixLabel = group();
  text(matrixLabel, 'M × [0, w] × [0, h]', 641, 837, 22);
  const record = group();
  rect(record, 1058, 692, 316, 264, '#00000000', BLACK);
  text(record, 'SwImage', 1058, 592, 25);
  text(record, 'data · w · h · stride', 1058, 636, 21);
  text(record, `direct = ${model.direct}`, 1058, 681, 22);
  text(record, `scaled = ${model.scaled}`, 1058, 724, 22);
  text(record, 'transform + renderBox', 1058, 772, 21);
  const clip = group();
  text(clip, 'clips → imageGenRle()', 210, 600, 22);
  polygon(clip, model.clipPoints.map(([x,y]) => [75+x*10,595+y*10]), BLACK, '#00000000', 2, 22);
  spanGeometry(d, clip, model.clipRle, 75, 595, 10, GRAY);
  const clippedOutput = group();
  const clipRows = spanGeometry(d, clippedOutput, model.clippedSpans, origin[0], origin[1], unit, GRAY);
  const clipping = group();
  polygon(clipping, model.clipPoints.map(v => map(v)), BLACK, '#00000000', 2.5, 25);
  text(clip, 'image.rle & clip RLE', 210, 826, 21);
  const ready = group();
  text(ready, 'Prepared → Draw/Raster', 1058, 863, 23);
  beat('Picture resolves its loader output into a bitmap surface or a nested vector scene.', .7);
  show(loaded); create(bitmapBranch); show(storage); show(sourceLabel);
  create(vectorBranch); show(nested);
  beat('The bitmap uses a SwImageTask; vector children re-enter the normal Paint update path.');
  show(prepare); hide(storage, .4); show(normalized, .4); show(normalizeLabel);
  beat('The task normalizes source color space and premultiplication, then retains the source data fields.');
  show(mapping); show(untransformed); show(matrixLabel);
  // Affine corner motion is derived from one matrix, never a freehand transformed drawing.
  const from = model.points.map(v => map(v)), to = model.transformed.map(v => map(v));
  hide(untransformed, .2);
  const cornerTokens = group();
  const corners = from.map(v => rect(cornerTokens, ...v, 9, 9, BLACK, BLACK).handle);
  show(cornerTokens, .15);
  play(corners.map((target, i) => ({target, shift: [(to[i][0] - from[i][0]) / 100, (from[i][1] - to[i][1]) / 100]})), 1.2);
  create(preparedQuad, .7); hide(cornerTokens, .1);
  beat('The four source corners are exported through the size-adjusted transform.');
  show(bbox); show(record);
  beat('imagePrepare selects direct/scaled/general geometry and intersects its bounds with clipBox.');
  show(clip); show(imageRle, .12);
  for (const target of nativeRows) show(target, .055);
  show(clipping); play([{target: preparedQuad, opacity: .3}], .3);
  show(clippedOutput, .1);
  // Replace each actual image row with its two-list intersection. The AA
  // coverage comes from the clip task; imageGenRle itself is non-AA here.
  for (const [i, span] of model.spans.entries()) {
    hide(nativeRows[i], .04);
    for (const [j, clipped] of model.clippedSpans.entries()) if (clipped[1] === span[1]) show(clipRows[j], .025);
  }
  show(ready);
  beat('With clip tasks, the image outline becomes an RLE and is intersected before Draw samples any texel.', 2.4);
  return finish({...model, bytes, premultiplied});
}
