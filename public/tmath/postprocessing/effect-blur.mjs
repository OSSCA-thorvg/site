import {tmath} from '../runtime/client.js';
import {trace, rgba, pack} from './native-evidence.mjs';

// 4d5810cf: tvgSwPostEffect.cpp::_gaussianFilter / effectGaussianBlur;
// tvgSwRaster.cpp::rasterXYFlip. Keep physical storage and logical axes separate.
export function blurPasses(input = trace) {
  const stride = input.width, [x0, y0, x1, y1] = input.bbox;
  const buffers = {offscreen: [...input.offscreen], scratch: Array(input.width * input.height).fill(0)};
  const passes = [];
  let front = 'offscreen', back = 'scratch';
  function run(op, radius, flipped) {
    const src = buffers[front], dst = buffers[back], steps = [];
    const left = flipped ? y0 : x0, top = flipped ? x0 : y0;
    const w = flipped ? y1 - y0 : x1 - x0, h = flipped ? x1 - x0 : y1 - y0;
    const before = [...src];
    if (op === 'transpose') {
      // Match the native 8×8 tiled traversal, including the partial bottom tile.
      for (let bx = 0; bx < w; bx += 8) for (let by = 0; by < h; by += 8) {
        for (let xx = 0; xx < Math.min(8, w - bx); xx++) for (let yy = 0; yy < Math.min(8, h - by); yy++) {
          const x = bx + xx, y = by + yy;
          const read = (top + y) * stride + left + x, write = (left + x) * stride + top + y;
          dst[write] = src[read];
          steps.push({read: [read], write, pixel: dst[write], block: `${bx},${by}`});
        }
      }
    } else {
      const factor = Math.fround(1 / (radius * 2 + 1));
      for (let y = 0; y < h; y++) {
        const address = x => (top + y) * stride + left + Math.max(0, Math.min(w - 1, x));
        let acc = [0,0,0,0];
        for (let x = -radius - 1; x < radius; x++) acc = acc.map((v,c)=>v+rgba(src[address(x)])[c]);
        for (let x = 0; x < w; x++) {
          const read = [address(x + radius),address(x - radius - 1)];
          const previousSum = [...acc];
          acc = acc.map((v,c)=>v+rgba(src[read[0]])[c]-rgba(src[read[1]])[c]);
          const dependencies = Array.from({length:radius*2+1},(_,k)=>address(x+k-radius));
          const channels = acc.map(v => Math.trunc(Math.fround(v * factor)));
          const write = (top + y) * stride + left + x;
          dst[write] = pack(channels);
          steps.push({read,dependencies,previousSum,write,pixel:dst[write],sum:[...acc],channels,x,y});
        }
      }
    }
    passes.push({op, radius, flipped, from: front, to: back, before, pixels: [...dst], steps, left, top, w, h});
    [front, back] = [back, front];
  }
  for (const r of input.kernels) run('H', r, false);
  run('transpose', 0, false);
  for (const r of input.kernels) run('V', r, true);
  run('transpose', 0, true);
  return passes;
}

// Six evidence beats: API/buffers; RGBA neighborhood -> write; repeated H passes;
// tiled transpose; V passes in transposed storage; transpose back + complete result.
export function buildBlurDetail(input = trace) {
  const data = blurPasses(input), width = 960, height = 800;
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: 8},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: '#202020'}]))}});
  const textIds = [], textPolicies = {}, beats = [];
  const painted = new WeakMap();
  let seq = 0;
  const id = name => `blur-detail-${name}-${seq++}`;
  const p = (x, y) => [(x - 480) / 100, (400 - y) / 100];
  const group = () => scene.group({id: id('group')});
  const text = (parent, value, x, y, size = 22, color = '#202020') => {
    const key = id('text'); textIds.push(key); textPolicies[key] = {standalone: true};
    return parent.text({id: key, text: value, point: p(x, y), size, font: 'Pretendard', role: 'text', align: [.5,.5], fill: color, layer: 40});
  };
  const rect = (parent, x, y, w, h, fill = '#00000000', stroke = '#202020', layer = 10, line = 1) => {
    const handle = parent.rectangle({id: id('rect'), center: p(x, y), size: [w / 100, h / 100], fill, stroke, width: line, layer});
    painted.set(handle,fill); return handle;
  };
  const color = value => {
    const [r,g,b,a] = rgba(value);
    return '#' + [r,g,b].map(c => Math.min(255, Math.round(c + 247 * (1 - a / 255)))).concat(255)
      .map(v => v.toString(16).padStart(2,'0')).join('');
  };
  let time = 0;
  const wait = d => { scene.wait(d); time += d; };
  const fade = (o, opacity, d = .16) => { scene.fade(o, opacity, d, 'linear'); time += d; };
  const show = (o, d = .2) => { scene.fadeIn(o, {duration: d}); time += d; };
  const beat = (label, hold = .6) => { beats.push({time, label}); wait(hold); };
  const play = (actions, d, lag = 0) => {
    if (!actions.length) return;
    // Unchanged cells still exist in the replay, but need no duplicate paint clip.
    const changed = actions.filter(a => {
      if (Object.keys(a).length !== 2 || a.fill === undefined) return true;
      if (painted.get(a.target) === a.fill) return false;
      painted.set(a.target,a.fill); return true;
    });
    if (!changed.length) { wait(d); return; }
    // This frozen runtime expresses lag as a fraction of the clip duration.
    scene.play(changed,d,'linear',lag/d); time += d+lag*(changed.length-1);
  };

  text(scene, `scene->add(SceneEffect::GaussianBlur, ${input.sigma}, 0, 0, 100);`, 480, 40, 23);
  text(scene, 'prepare · radii [' + input.kernels.join(', ') + '] · draw → effectGaussianBlur()', 480, 77, 19, '#626262');
  text(scene, 'Offscreen', 221, 158, 24); text(scene, 'Scratch', 739, 158, 24);
  const cell = 14, top = 205, lefts = {offscreen: 53, scratch: 571};
  const centers = name => Array.from({length: input.width * input.height}, (_, i) =>
    [lefts[name] + (i % input.width + .5) * cell, top + (Math.floor(i / input.width) + .5) * cell]);
  const grids = {};
  for (const name of ['offscreen','scratch']) {
    const points = centers(name), pixels = name === 'offscreen' ? input.offscreen : Array(input.offscreen.length).fill(0);
    const handles = pixels.map((v,i) => rect(scene, ...points[i], cell - .6, cell - .6, color(v), '#00000000', 10, 0));
    rect(scene, lefts[name] + 168, top + 168, 336, 336, '#00000000', '#888888', 15);
    grids[name] = {points, handles};
  }
  function regionMask(name, bounds) {
    const [x0,y0,x1,y1]=bounds, g=group(), left=lefts[name];
    const cover=(x,y,w,h)=>{if(w>0&&h>0)rect(g,left+(x+w/2)*cell,top+(y+h/2)*cell,w*cell,h*cell,'#e1e3e5','#00000000',20,0);};
    cover(0,0,input.width,y0); cover(0,y1,input.width,input.height-y1);
    cover(0,y0,x0,y1-y0); cover(x1,y0,input.width-x1,y1-y0);
    return g;
  }
  const masks={offscreen:regionMask('offscreen',input.bbox),scratch:regionMask('scratch',input.bbox)};
  text(scene, 'Gray · outside bbox', 480, 752, 19, '#626262');
  const labels = data.map((v, i) => v.op === 'transpose' ? (v.flipped ? 'T⁻¹' : 'T') : `${v.op}${v.op === 'H' ? i + 1 : i - input.kernels.length}`);
  const ribbon = labels.map((label, i) => {
    const x = 116 + i * 104;
    rect(scene, x, 674, 86, 42, '#ffffff', '#555555', 2);
    text(scene, label, x, 674, 21);
    if (i < labels.length - 1) scene.arrow({id: id('next'), from: p(x+46,674), to:p(x+55,674), stroke:'#555555', tip:5, width:1.5,layer:3});
    return {x};
  });
  let roles=group();
  text(roles,'front · read',221,625,18);text(roles,'back · write',739,625,18);
  let description = text(scene, 'A + B → Offscreen · request(Scratch)', 480, 118, 22);
  let detail = text(scene, '24×24 Surface · bbox = [' + input.bbox.join(', ') + '] · RGBA', 480, 588, 19);
  let progress = text(scene, 'H · horizontal     T · transpose     V · vertical', 480, 715, 18, '#626262');
  beat('API parameters prepare the kernels; the Offscreen contains the native A/B pixels.', 1.2);

  for (const [index, pass] of data.entries()) {
    fade(description, 0); fade(detail, 0); fade(progress, 0);
    const transpose = pass.op === 'transpose';
    description = text(scene, `${labels[index]} · ${transpose ? 'rasterXYFlip()' : '_gaussianFilter()'} · ${pass.from === 'offscreen' ? 'Offscreen → Scratch' : 'Scratch → Offscreen'}`, 480, 118, 21);
    show(description);
    detail = text(scene, transpose ? (pass.flipped ? '(y, x) → (x, y)' : '8 × 8 tile · (x, y) → (y, x)')
      : `${pass.op === 'H' ? 'Horizontal taps ·' : 'Vertical taps ·'} ${2*pass.radius+1} → RGBA → dst[x, y]`, 480, 588, 19);
    show(detail);
    progress = text(scene, transpose ? 'RGBA unchanged' : `radius ${pass.radius}`, 480, 715, 18, '#626262');
    show(progress);
    const active = rect(scene, ribbon[index].x, 674, 92, 48, '#00000000', '#202020', 16, 3);
    show(active);
    const src = grids[pass.from], dst = grids[pass.to];
    const [x0,y0,x1,y1]=input.bbox;
    const outputFlipped=transpose ? !pass.flipped : pass.flipped;
    fade(masks[pass.to],0,.04);
    masks[pass.to]=regionMask(pass.to,outputFlipped?[y0,x0,y1,x1]:input.bbox);
    show(masks[pass.to],.04);
    if (transpose) {
      const blocks = Map.groupBy(pass.steps, step => step.block);
      // Show writes at their transposed destination addresses without moving tiles.
      for (const steps of blocks.values()) {
        play(steps.map(step => ({target: dst.handles[step.write], fill: color(step.pixel)})), .01, .004);
      }
      beat(pass.flipped ? 'Inverse transpose returns the blurred pixels to Offscreen for the following Fill effect.' : 'Tiled transpose preserves values while changing physical row/column addresses.', .8);
    } else {
      const rowMarker = rect(scene, lefts[pass.from] + (pass.left + pass.w / 2) * cell, top + (pass.top + .5) * cell,
        pass.w * cell, cell, '#00000000', '#202020', 25, 2);
      show(rowMarker, .08);
      const rows = Map.groupBy(pass.steps, step => step.y);
      const focus = index === 0 ? pass.steps.find(step => new Set(step.dependencies.map(i=>pass.before[i])).size > 1 && rgba(step.pixel)[3] > 80) : null;
      for (const [row, steps] of rows) {
        if (row) { scene.shift(rowMarker, [0, -cell / 100], .015, 'linear'); time += .015; }
        let batch = [];
        const commit = () => { play(batch,.006,.0018); batch=[]; };
        for (const step of steps) {
          if (step === focus) {
            commit();
            const readSet = group();
            step.dependencies.forEach(i => rect(readSet, ...src.points[i], cell, cell, '#00000000', '#202020', 27, 2));
            rect(readSet, ...dst.points[step.write], cell, cell, '#00000000', '#202020', 27, 2);
            const tile = rect(scene, 480, 358, 52, 52, color(step.pixel), '#202020', 30, 1);
            show(readSet,.24); show(tile,.3);
            fade(detail,0);
            detail = text(scene, `Σ RGBA [${step.sum.join(', ')}] / ${2*pass.radius+1} → [${step.channels.join(', ')}]`, 480,588,20);
            show(detail);
            beat('The marked neighborhood produces one RGBA pixel, not only an alpha average.', .85);
            const [dx,dy] = dst.points[step.write];
            scene.shift(tile, [(dx-480)/100,(358-dy)/100],.55,'ease_in_out'); time += .55;
            play([{target:dst.handles[step.write],fill:color(step.pixel)},{target:tile,opacity:0}],.04);
            fade(readSet,0,.08);
          } else {
            // Commits are row-major, accelerated only after a representative read/write.
            batch.push({target: dst.handles[step.write], fill: color(step.pixel)});
          }
        }
        commit();
        wait(index === 0 ? .065 : .025);
      }
      fade(rowMarker,0,.08);
      if (index === input.kernels.length - 1) beat('All horizontal passes finish before transposition; each pass reads the preceding result.', .7);
      if (index === data.length - 2) beat('Vertical filtering reuses horizontal memory access on the transposed image.', .7);
    }
    fade(roles,0,.12);
    roles=group();
    text(roles,'front · read',pass.to==='offscreen'?221:739,625,18);
    text(roles,'back · write',pass.from==='offscreen'?221:739,625,18);
    show(roles,.18);
    fade(active,0,.08);
  }
  fade(description,0); fade(detail,0); fade(progress,0);
  description = text(scene,'Offscreen → Fill',480,118,22); show(description);
  detail = text(scene,'H × 3 + V × 3 ≈ Gaussian',480,588,20); show(detail);
  progress = text(scene,'RGBA · 1 scratch surface',480,715,18,'#626262'); show(progress);
  wait(2);
  return {scene,beats,textIds,textPolicies,data,duration:time};
}
