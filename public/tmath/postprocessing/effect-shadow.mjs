import {tmath} from '../runtime/client.js';
import trace from './effect-shadow-trace.mjs';
import {verifyShadowTrace, rgba, scale, over} from './effect-shadow-model.mjs';

// Seven beats: API/input; alpha reads and retained body; repeated H passes;
// transpose/V/restore; shifted shadow into Canvas; restored body source-over;
// the complete native result. Pixel values and read/write sets come from the
// unmodified CPU engine. Row playback is explanatory, not worker scheduling.
export function buildShadowDetail(data = trace) {
  const events = verifyShadowTrace(data);
  const width = 960, height = 800, ink = '#222222', muted = '#666666';
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: 8},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: ink}]))}});
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const textIds = [], textPolicies = {}, beats = [];
  let serial = 0, time = 0;
  const key = name => `shadow-detail-${name}-${serial++}`;
  const group = (name, opacity = 0) => scene.group({id: key(name), opacity});
  const hex = channels => '#' + channels.map(value => Math.max(0, Math.min(255, value)).toString(16).padStart(2, '0')).join('');
  const display = (value, x, y) => {
    const c = rgba(value), base = (x + y) % 2 ? 235 : 250;
    return hex(c.slice(0, 3).map(v => Math.round(v + base * (1 - c[3] / 255))));
  };
  const transparent = c => hex([...c.slice(0, 3).map(v => c[3] ? Math.round(v * 255 / c[3]) : 0), c[3]]);
  function text(parent, value, x, y, size = 20, color = ink) {
    const id = key('text'); textIds.push(id); textPolicies[id] = {standalone: true};
    return parent.text({id, text: value, point: p(x, y), size, font: 'Pretendard', role: 'text', fill: color, align: [.5, .5], layer: 40});
  }
  function rect(parent, x, y, w, h, fill = '#00000000', stroke = '#00000000', thickness = 0, layer = 12) {
    return parent.rectangle({id: key('rect'), center: p(x, y), size: [w / 100, h / 100], fill, stroke, width: thickness, layer});
  }
  function arrow(parent, points) {
    return parent.route({id: key('route'), points: points.map(([x, y]) => p(x, y)), stroke: ink, width: 1.8, tip: 8, layer: 8});
  }
  function grid(left, top, size, pixels, mutable = false) {
    const cell = size / data.width;
    const centers = pixels.map((_, i) => [left + (i % data.width + .5) * cell, top + (Math.floor(i / data.width) + .5) * cell]);
    const cells = mutable ? pixels.map((value, i) => rect(scene, ...centers[i], cell, cell,
      display(value, i % data.width, Math.floor(i / data.width)), '#00000000', 0, 12)) : [];
    if (!mutable) scene.image({id: key('static-bitmap'), center: p(left + size / 2, top + size / 2), width: size / 100,
      size: [data.width, data.height], pixels: pixels.map((value, i) => display(value, i % data.width, Math.floor(i / data.width))), filter: 'nearest', layer: 12});
    rect(scene, left + size / 2, top + size / 2, size, size, '#00000000', ink, 1.4, 20);
    return {left, top, size, cell, centers, cells};
  }
  function play(spec, duration = .2) {scene.play(spec, duration, 'linear'); time += duration;}
  function show(target, duration = .25) {play([{target, opacity: 1}], duration);}
  function hide(target, duration = .12) {play([{target, opacity: 0}], duration);}
  function wait(duration) {scene.wait(duration); time += duration;}
  function beat(label, hold = 1.0) {beats.push({time: +time.toFixed(4), label}); wait(hold);}
  function label(value, y, size = 20) {const owner = group('stage'); text(owner, value, 480, y, size); return owner;}

  const args = data.color.join(', ');
  text(scene, `scene->add(SceneEffect::DropShadow, ${args},`, 480, 38, 20);
  text(scene, `${data.angle.toFixed(1)}, ${data.distance.toFixed(1)}, ${data.sigma.toFixed(1)}, ${data.quality});     scene->opacity(${data.groupOpacity});`, 480, 69, 20);
  text(scene, 'SceneImpl::render()  →  SwRenderer::render()  →  effectDropShadow()', 480, 109, 18, muted);
  text(scene, 'Original · A + B', 170, 190, 21);
  text(scene, 'Shadow · front → back', 480, 190, 21);
  text(scene, 'Canvas', 790, 190, 21);
  const original = grid(50, 220, 240, data.original);
  const work = grid(360, 220, 240, Array(data.width * data.height).fill(0), true);
  const canvas = grid(670, 220, 240, data.background);
  const retained = group('retained'); text(retained, 'body retained', 170, 485, 18, muted);
  const workInfo = group('work-info'); text(workInfo, '2 work buffers · swap()', 480, 485, 18, muted);
  const canvasLabels = ['BG', 'shadow first', 'body over shadow'].map(value => {
    const g = group('canvas-state'); text(g, value, 790, 485, 18, muted); return g;
  });
  const apiStage = label(`single effect · direct = true · ${data.width} × ${data.height} pixels`, 151, 18);
  const passStages = events.passes.map((pass, index) => {
    const number = pass.op === 'H' ? index + 1 : pass.op === 'V' ? index - 3 : null;
    return label(pass.op === 'transpose'
      ? (pass.flipped ? 'rasterXYFlip() · rows become columns' : 'rasterXYFlip() · restore x / y')
      : `${pass.op}${number}  ·  kernel radius ${pass.radius}  ·  read front, write back`, 151, 19);
  });
  const offsetStage = label(`_dropShadowShift()  ·  offset (${data.offset.join(', ')})`, 151, 20);
  const bodyStage = label('restore Original → endComposite() → source-over', 151, 20);

  // Magnified reads preserve actual RGB and expose the alpha byte underneath.
  const detailPasses = new Map();
  for (const passIndex of [0, 4]) {
    const pass = events.passes[passIndex];
    const candidates = pass.rows.flatMap(row => row.writes);
    const contrast = w => Math.max(...w.taps.map(t => t.rgba[3])) - Math.min(...w.taps.map(t => t.rgba[3]));
    const selected = candidates.reduce((best, value) => contrast(value) > contrast(best) ? value : best);
    const g = group('alpha-detail');
    const stages=['taps','alpha','color','result'].map(name=>g.group({id:key(name),opacity:0}));
    const readGrid = passIndex === 0 ? original : work;
    const minTap = Math.min(...selected.taps.map(tap => tap.x)), maxTap = Math.max(...selected.taps.map(tap => tap.x));
    rect(g, readGrid.left + (minTap + maxTap + 1) * readGrid.cell / 2,
      readGrid.top + (selected.y + .5) * readGrid.cell,
      (maxTap - minTap + 1) * readGrid.cell, readGrid.cell, '#00000000', ink, 2.5, 34);
    rect(g, ...work.centers[selected.y * data.width + selected.x], work.cell, work.cell, '#00000000', ink, 2.5, 34);
    text(g, '_dropShadowFilter()', 480, 535, 20);
    const start = 260, step = 65;
    selected.taps.forEach((tap, i) => {
      const x = start + i * step;
      rect(stages[0], x, 590, 46, 38, display(pass.input[tap.y * data.width + tap.x], tap.x, tap.y), ink, 1);
      const gray = 255 - tap.rgba[3];
      rect(stages[1], x, 643, 46, 38, hex([gray, gray, gray]), ink, 1);
      text(stages[1], `${tap.rgba[3]}`, x, 687, 17);
      arrow(stages[1], [[x, 611], [x, 622]]);
    });
    rect(stages[2], 500, 643, 48, 48, hex(data.color.slice(0, 3)), ink, 1);
    text(stages[2], 'RGB', 500, 591, 17);
    text(stages[2], data.color.slice(0, 3).join(' / '), 500, 687, 16);
    rect(stages[3], 650, 643, 64, 64, display(selected.result, selected.x, selected.y), ink, 1);
    text(stages[3], `A = ${selected.alpha}`, 650, 698, 18);
    arrow(stages[2], [[419, 643], [469, 643]]);
    arrow(stages[3], [[529, 643], [611, 643]]);
    text(g, `front[${selected.y}][x] → back[${selected.y}][${selected.x}]`, 480, 747, 18, muted);
    const token = group('filtered-write');
    rect(token, 650, 643, work.cell, work.cell, display(selected.result, selected.x, selected.y), '#ffffff', .5, 50);
    detailPasses.set(passIndex, {g, stages, selected, token});
  }

  const cursor = group('row-cursor');
  const initialRow = data.bbox[1];
  rect(cursor, work.left + work.size / 2, work.top + (initialRow + .5) * work.cell,
    work.size - 1, work.cell, '#00000000', '#111111', 2.5, 32);
  let cursorRow = initialRow;
  const offsetDetail = group('offset-detail');
  text(offsetDetail, `${data.angle}°  ·  distance ${data.distance}  →  (${data.offset.join(', ')}) pixels`, 480, 546, 21);
  text(offsetDetail, `shadow opacity ${data.color[3]} × group opacity ${data.groupOpacity} → ${data.shadowOpacity}`, 480, 590, 20);
  text(offsetDetail, 'filtered alpha → shifted source → Canvas', 480, 644, 20);
  const fromPoint = [424, 704], toPoint = [424 + data.offset[0] * 18, 704 + data.offset[1] * 18];
  rect(offsetDetail, ...fromPoint, 18, 18, '#ffffff', ink, 1.4);
  arrow(offsetDetail, [fromPoint, [toPoint[0], fromPoint[1]], toPoint]);
  rect(offsetDetail, ...toPoint, 18, 18, hex(data.color.slice(0, 3)), ink, 1.4);

  // Copy proxies use Rectangle paint, never repeatedly premultiplied Image bytes.
  function pixelProxy(name, grid, pixels, opacity, includes = () => true) {
    const owner = group(name);
    const [cx, cy] = p(grid.left + grid.size / 2, grid.top + grid.size / 2);
    const pixelSize = grid.cell / 100;
    const paint = owner.group({id: key('proxy-paint'), matrix: [pixelSize,0,0,cx, 0,pixelSize,0,cy, 0,0,1,0, 0,0,0,1]});
    paint.cell({id: key('proxy-cells'), origin: [-data.width / 2, -data.height / 2], size: [data.width, data.height],
      mode: 'full', color: '#00000000', layer: 45,
      patches: pixels.flatMap((value, i) => {
        const c = scale(rgba(value), opacity), x = i % data.width, y = Math.floor(i / data.width);
        return c[3] && includes(x, y) ? [{region: [x, data.height - y - 1, 1, 1], color: transparent(c)}] : [];
      })});
    return owner;
  }
  const allowed = new Set(events.shifts.map(step => step.y * data.width + step.x));
  const shadowProxy = pixelProxy('shadow-offset', work, data.filtered, data.shadowOpacity, (x, y) => allowed.has(y * data.width + x));
  const bodyProxy = pixelProxy('restore-body', original, data.original, data.groupOpacity);
  const parentStages = [data.shadowCanvas, data.final].map((pixels, stage) => {
    const owner = group('parent-commit');
    owner.image({id: key('parent-bitmap'), center: p(canvas.left + canvas.size / 2, canvas.top + canvas.size / 2),
      width: canvas.size / 100, size: [data.width, data.height], filter: 'nearest', layer: 13 + stage,
      pixels: pixels.map((value, i) => display(value, i % data.width, Math.floor(i / data.width)))});
    return owner;
  });
  const index = data.original.reduce((best, value, i) => {
    const a = rgba(value)[3], score = a > 0 && a < 255 ? 256 + a : a;
    const b = rgba(data.original[best])[3], bestScore = b > 0 && b < 255 ? 256 + b : b;
    return score > bestScore ? i : best;
  }, 0);
  const point = [index % data.width, Math.floor(index / data.width)];
  const terms = over(data.original[index], data.shadowCanvas[index], data.groupOpacity);
  const bodyDetail = group('body-detail');
  text(bodyDetail, `Original[${point.join(', ')}] over Canvas[${point.join(', ')}]`, 480, 537, 20);
  const termXs = [265, 480, 695];
  const values = [terms.foreground, terms.background, rgba(terms.result)];
  const names = ['body × opacity', 'Canvas × (1 − body alpha)', 'Canvas write'];
  values.forEach((value, i) => {
    text(bodyDetail, names[i], termXs[i], 582, 16);
    rect(bodyDetail, termXs[i], 640, 86, 62, hex(value.slice(0, 3)), ink, 1.3);
    text(bodyDetail, value.slice(0, 3).join(' / '), termXs[i], 700, 18);
  });
  text(bodyDetail, '+', 370, 640, 27);
  text(bodyDetail, '=', 588, 640, 27);
  text(bodyDetail, `effective body alpha ${terms.foreground[3]} · source-over in the original Canvas`, 480, 750, 18, muted);
  const bodyFocus = group('body-focus');
  rect(bodyFocus, ...original.centers[index], original.cell, original.cell, '#00000000', ink, 2.5, 33);
  rect(bodyFocus, ...canvas.centers[index], canvas.cell, canvas.cell, '#00000000', ink, 2.5, 33);

  // The opening already has subject + unchanged parent; later facts start hidden.
  show(apiStage, .01); show(canvasLabels[0], .01);
  beat('One public DropShadow effect selects the direct parent-composition path.', 1.3);
  hide(apiStage); show(workInfo); show(cursor);
  for (const [passIndex, pass] of events.passes.entries()) {
    if (passIndex) hide(passStages[passIndex - 1], .08);
    show(passStages[passIndex], .2);
    if (pass.op === 'transpose') {
      hide(cursor, .05);
      const moved = [...work.cells];
      play(work.cells.map((target, i) => {
        const x = i % data.width, y = Math.floor(i / data.width);
        const destination = x * data.width + y;
        moved[destination] = target;
        return {target, shift: [(y - x) * work.cell / 100, (y - x) * work.cell / 100]};
      }), 1.15);
      work.cells = moved;
      wait(.4);
      continue;
    }
    show(cursor, .04);
    for (const row of pass.rows) {
      if (cursorRow !== row.y) {
        play([{target: cursor, shift: [0, (cursorRow - row.y) * work.cell / 100]}], .035);
        cursorRow = row.y;
      }
      const detail = detailPasses.get(passIndex);
      if (detail && row.y === detail.selected.y) {
        show(detail.g, .2);
        for (const stage of detail.stages) {show(stage,.35);wait(.25);}
        wait(.65);
        show(detail.token, .05);
        const [tx, ty] = work.centers[detail.selected.y * data.width + detail.selected.x];
        play([{target: detail.token, shift: [-.25, (643 - ty) / 100]}], .4);
        play([{target: detail.token, shift: [(tx - 625) / 100, 0]}], .4);
        play([{target: work.cells[detail.selected.y * data.width + detail.selected.x], fill: display(detail.selected.result, detail.selected.x, detail.selected.y)}, {target: detail.token, opacity: 0}], .04);
        wait(.5); hide(detail.g, .2);
      }
      play(row.writes.map(write => ({target: work.cells[write.y * data.width + write.x], fill: display(write.result, write.x, write.y)})), passIndex === 0 ? .10 : .075);
    }
    if (passIndex === 0) {
      show(retained); beat('The first pass reads source alpha; the original body is retained independently.', .9);
    } else if (passIndex === 2) {
      beat('All three horizontal passes build the shadow from alpha, with fixed shadow RGB.', .8);
    }
  }
  hide(passStages.at(-1));
  beat('Transpose, three vertical passes and inverse transpose complete the two-dimensional blur.', 1.1);
  show(offsetStage); show(offsetDetail);
  wait(.8); show(shadowProxy, .2);
  play([{target: shadowProxy, shift: [(canvas.left - work.left) / 100, 0]}], 1.0);
  play([{target: shadowProxy, shift: [data.offset[0] * work.cell / 100, -data.offset[1] * work.cell / 100]}], .85);
  show(parentStages[0], .01);
  hide(shadowProxy, .01); hide(canvasLabels[0], .05); show(canvasLabels[1], .1);
  beat('Integer offset places the filtered shadow into the parent at combined opacity 90.', 1.6);
  hide(offsetDetail); hide(offsetStage); show(bodyStage); show(bodyDetail); show(bodyFocus);
  wait(1.2); show(bodyProxy, .2);
  play([{target: bodyProxy, shift: [(canvas.left - original.left) / 100, 0]}], 1.25);
  show(parentStages[1], .01);
  hide(bodyProxy, .01); hide(canvasLabels[1], .05); show(canvasLabels[2], .1);
  beat('endComposite overlays the retained body with group opacity 128 onto that same Canvas.', 1.6);
  beat('Final pixels match the public Canvas::draw() result, including the selected source-over write.', 2.2);
  return {scene, beats, textIds, textPolicies, data, events,
    pixelChecks: [{name: 'shadow Canvas', grid: canvas, pixels: data.final}],
    detailPoint: point, detailTerms: terms};
}
