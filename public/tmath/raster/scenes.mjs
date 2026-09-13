import {tmath} from '../runtime/client.js';
import {buildScenarios} from './model.mjs';

export const WIDTH = 960, HEIGHT = 600;
const C = {ink: '#263447', faint: '#dbe2e9', teal: '#009d91', orange: '#eb8c28'};
const pos = (x, y) => [(x - WIDTH / 2) / 100, (HEIGHT / 2 - y) / 100];
// All model colors are premultiplied RGBA bytes. tmath fill colors are straight RGBA.
export const color = rgba => '#' + [...rgba.slice(0, 3).map(v => rgba[3] ? Math.min(255, Math.round(v * 255 / rgba[3])) : 0), rgba[3]]
  .map(v => v.toString(16).padStart(2, '0')).join('');

// Native UV pre-stepping evaluates (x + 1, y + 1) for destination slot (x,y).
// A displayed slot is centered at (x + .5, y + .5): map geometry into that frame.
export const textureDisplayPoint = (grid, vertex) => [
  grid.left + (vertex.x - .5) * grid.cell,
  grid.top + (vertex.y - .5) * grid.cell,
];

function stage(id) {
  const scene = tmath.scene({width: WIDTH, height: HEIGHT, fps: 30, loop: false, theme: 'pro_white', camera: {mode: 'fixed', view: '2d', height: HEIGHT / 100}});
  const textIds = [], textPolicies = {};
  function text(key, value, x, y, size = 22, opacity = 1) {
    const name = id + '-' + key; textIds.push(name); textPolicies[name] = {standalone: true};
    return scene.text({id: name, text: value, point: pos(x, y), font: 'Pretendard', size, role: 'text', fill: C.ink, layer: 40, opacity});
  }
  function rect(parent, key, x, y, w, h, fill, stroke = '#00000000', width = 0, layer = 10, opacity = 1) {
    return parent.rectangle({id: id + '-' + key, center: pos(x, y), size: [w / 100, h / 100], fill, stroke, width, layer, opacity});
  }
  function line(parent, key, x1, y1, x2, y2, stroke = C.faint, width = 1, layer = 5) {
    return parent.line({id: id + '-' + key, from: pos(x1, y1), to: pos(x2, y2), stroke, width, layer});
  }
  function grid(key, bitmap, left, top, size, filled) {
    const cell = size / Math.max(bitmap.width, bitmap.height);
    const width = bitmap.width * cell, height = bitmap.height * cell;
    const centers = bitmap.pixels.map((_, i) => [left + (i % bitmap.width + 0.5) * cell, top + (Math.floor(i / bitmap.width) + 0.5) * cell]);
    for (const [index, center] of centers.entries()) {
      const x = index % bitmap.width, y = Math.floor(index / bitmap.width);
      rect(scene, key + '-back-' + index, ...center, cell, cell, (x + y) % 2 ? '#e8edf2' : '#f5f7fa', '#00000000', 0, 4);
      if (filled) rect(scene, key + '-pixel-' + index, ...center, cell - 1, cell - 1, color(bitmap.pixels[index]), '#00000000', 0, 10);
    }
    rect(scene, key + '-border', left + width / 2, top + height / 2, width, height, '#00000000', '#afbbc8', 1, 15);
    return {cell, centers, left, top, width, height};
  }
  return {scene, text, rect, line, grid, textIds, textPolicies};
}

// A trace is computed completely before building any visual objects. Read sets,
// sample coordinates, weighting strips, write order, and all output colors share it.
export function buildSampling(id, data = buildScenarios()[id]) {
  if (!data) throw new Error('Unknown raster sampling scene: ' + id);
  const ui = stage(id), {scene: s, rect, line, text, grid} = ui;
  const sourceSize = id === 'direct' ? 310 * Math.max(data.source.width, data.source.height) / Math.max(data.target.width, data.target.height) : 310;
  const src = grid('source', data.source, 205 - sourceSize / 2, 145 + (310 - sourceSize) / 2, sourceSize, true);
  const dst = grid('surface', data.target, 590, 145, 310, false);
  text('source-label', 'Source', 205, 102);
  text('surface-label', 'Surface', 745, 102);
  s.arrow({id: id + '-sampling-arrow', from: pos(402, 125), to: pos(548, 125), stroke: C.faint, width: 2, tip: 10, layer: 5});
  const contrast = step => {
    const taps = step.taps.filter(t => t.weight > 0);
    if (taps.length < (id === 'bilinear' ? 4 : 2)) return -1;
    if (id === 'bilinear' && taps.some(t => t.weight < 0.1)) return -1;
    if (id !== 'bilinear') return [0, 1, 2].reduce((sum, channel) => sum + Math.max(...taps.map(t => t.rgba[channel])) - Math.min(...taps.map(t => t.rgba[channel])), 0);
    return [0, 1, 2].reduce((sum, channel) => {
      const mean = taps.reduce((value, t) => value + t.weight * t.rgba[channel], 0);
      return sum + taps.reduce((variance, t) => variance + t.weight * (t.rgba[channel] - mean) ** 2, 0);
    }, 0);
  };
  const multi = data.steps.reduce((best, step, i) => contrast(step) > contrast(data.steps[best]) ? i : best, 0);
  const detailed = new Set([0, multi, data.steps.length - 1]);
  if (data.triangles) {
    for (const [i, indices] of data.triangles.entries()) {
      s.polygon({id: id + '-triangle-' + i, points: indices.map(j => pos(...textureDisplayPoint(dst, data.vertices[j]))), fill: '#00000000', stroke: C.faint, width: 2, layer: 18});
    }
  }
  const actions = data.steps.map((step, i) => {
    const group = s.group({id: id + '-read-' + i, opacity: 0});
    const taps = step.taps.filter(t => t.weight > 0);
    const total = taps.reduce((sum, tap) => sum + tap.weight, 0);
    if (step.kernel) {
      const {minx, maxx, miny, maxy} = step.kernel;
      rect(group, 'kernel-' + i, src.left + (minx + maxx) * src.cell / 2, src.top + (miny + maxy) * src.cell / 2, (maxx - minx) * src.cell, (maxy - miny) * src.cell, '#00000000', C.ink, 2, 21);
    }
    if (step.triangle !== undefined) {
      group.polygon({id: id + '-active-triangle-' + i, points: data.triangles[step.triangle].map(j => pos(...textureDisplayPoint(dst, data.vertices[j]))), fill: '#00000000', stroke: C.teal, width: 2, layer: 19});
      // The row interval is taken from the scan converter, before sampling UV.
      line(group, 'scanline-' + i, ...textureDisplayPoint(dst, {x: Math.max(0, step.scanline.left), y: step.y + 1}),
        ...textureDisplayPoint(dst, {x: Math.min(data.target.width, step.scanline.right), y: step.y + 1}), C.teal, 2, 24);
    }
    let y = 254;
    for (const [j, tap] of taps.entries()) {
      const center = src.centers[tap.y * data.source.width + tap.x];
      if (!center) throw new Error('Source read outside bitmap');
      rect(group, 'tap-' + i + '-' + j, ...center, src.cell - 3, src.cell - 3, '#00000000', '#ffffff', 5, 25);
      rect(group, 'tap-ink-' + i + '-' + j, ...center, src.cell - 3, src.cell - 3, '#00000000', C.teal, 2, 26);
      const h = 92 * tap.weight / total;
      if (h > 0) {
        if (step.intermediates) {
          const index = step.taps.indexOf(tap), column = index % 2, row = Math.floor(index / 2);
          const leftWidth = 72 * (256 - step.dx) / 256, topHeight = 92 * (256 - step.dy) / 256;
          const w = column ? 72 - leftWidth : leftWidth, height = row ? 92 - topHeight : topHeight;
          rect(group, 'weight-' + i + '-' + j, 439 + (column ? leftWidth : 0) + w / 2, 254 + (row ? topHeight : 0) + height / 2, w, height, color(tap.rgba), '#00000000', 0, 22);
        } else {
          rect(group, 'weight-' + i + '-' + j, 475, y + h / 2, 72, h, color(tap.rgba), '#00000000', 0, 22);
          y += h;
        }
      }
    }
    let intermediate;
    if (step.intermediates && detailed.has(i)) {
      intermediate = group.group({id: id + '-horizontal-' + i, opacity: 0});
      const topHeight = 92 * (256 - step.dy) / 256;
      rect(intermediate, 'top-mix-' + i, 475, 254 + topHeight / 2, 72, topHeight, color(step.intermediates[0]), '#00000000', 0, 23);
      if (topHeight < 92) rect(intermediate, 'bottom-mix-' + i, 475, 254 + topHeight + (92 - topHeight) / 2, 72, 92 - topHeight, color(step.intermediates[1]), '#00000000', 0, 23);
    }
    // Scaled coordinates come from the inverse transform; texture UV comes from edge increments.
    if (Number.isFinite(step.sx) && Number.isFinite(step.sy)) {
      const offset = 0.5;
      const sx = src.left + (step.sx + offset) * src.cell, sy = src.top + (step.sy + offset) * src.cell;
      line(group, 'sample-h-' + i, sx - 7, sy, sx + 7, sy, C.ink, 2, 30);
      line(group, 'sample-v-' + i, sx, sy - 7, sx, sy + 7, C.ink, 2, 30);
    }
    const [dx, dy] = dst.centers[step.y * data.target.width + step.x];
    rect(group, 'destination-' + i, dx, dy, dst.cell - 2, dst.cell - 2, '#00000000', C.orange, 3, 27);
    const sample = rect(s, 'computed-' + i, 475, 300, 72, 92, color(step.sample ?? step.rgba), '#ffffff', 1, 29, 0);
    // The travelling square is a copy of this computed sample, not a fabricated value.
    const token = rect(s, 'write-' + i, 475, 300, dst.cell - 1, dst.cell - 1, color(step.rgba), '#ffffff', 1, 35, 0);
    const commit = rect(s, 'committed-' + i, dx, dy, dst.cell - 1, dst.cell - 1, color(step.rgba), '#00000000', 0, 11, 0);
    return {step, group, intermediate, sample, token, commit, dx, dy, detailed: detailed.has(i)};
  });
  const beats = [{time: 0, label: 'Input bitmap and empty destination'}];
  let time = 0;
  s.wait(0.5); time += 0.5;
  for (const [i, a] of actions.entries()) {
    const read = a.detailed ? 0.45 : 0.12, mix = a.detailed ? 0.55 : 0.12, move = a.detailed ? 0.65 : 0.3;
    s.fade(a.group, 1, read, 'linear'); time += read;
    if (i === multi) {
      s.wait(0.65); time += 0.65;
      beats.push({time, label: 'Source taps and their weights'});
    }
    if (a.intermediate) {
      const horizontalTime = a.detailed ? 0.5 : 0.12;
      s.fade(a.intermediate, 1, horizontalTime, 'linear'); time += horizontalTime;
    }
    s.fade(a.sample, 1, mix, 'linear'); time += mix;
    if (a.detailed) beats.push({time, label: 'Computed sample ' + i});
    s.play([{target: a.sample, opacity: 0}, {target: a.token, opacity: 1}], 0.04, 'linear'); time += 0.04;
    s.shift(a.token, [(a.dx - 475) / 100, (300 - a.dy) / 100], move, 'ease_in_out'); time += move;
    s.play([{target: a.token, opacity: 0}, {target: a.commit, opacity: 1}], 0.01, 'linear'); time += 0.01;
    if (i !== actions.length - 1) { s.fade(a.group, 0, 0.01, 'linear'); time += 0.01; }
  }
  s.wait(1.4); time += 1.4;
  beats.push({time, label: 'Complete destination from the trace'});
  return {...ui, beats, data, gridRegions: [src, dst].map(g => ({left: g.left, top: g.top, width: g.width, height: g.height}))};
}

export function buildCoverage(data = buildScenarios().solidRle) {
  const ui = stage('solid-rle'), {scene: s, text, grid, rect} = ui;
  const mask = {width: data.target.width, height: data.target.height, pixels: data.target.pixels.map(() => [255, 255, 255, 255])};
  for (const {x,y,coverage} of data.steps) mask.pixels[y * mask.width + x] = [255-coverage,255-coverage,255-coverage,255];
  const src = grid('coverage', mask, 50, 145, 310, true);
  const dst = grid('surface', data.target, 590, 145, 310, false);
  text('coverage-label', 'Coverage', 205, 102);
  text('surface-label', 'Surface', 745, 102);
  text('fill-label', 'Fill', 475, 218, 20);
  rect(s, 'fill-color', 475, 275, 68, 68, color(data.source.pixels[0]));
  const actions = data.spans.map((span, i) => {
    const group = s.group({id: 'solid-rle-span-' + i, opacity: 0});
    const steps = data.steps.filter(step => step.spanIndex === i);
    if (!steps.length) return null;
    const left = Math.min(...steps.map(step => step.x)), right = Math.max(...steps.map(step => step.x)) + 1;
    rect(group, 'read-span-' + i, src.left + (left + right) * src.cell / 2, src.top + (span.y + 0.5) * src.cell,
      (right-left)*src.cell-2, src.cell-2, '#00000000', C.teal, 3, 25);
    const targets = steps.map((step, j) => {
      const [x,y] = dst.centers[step.y * data.target.width + step.x];
      return rect(s, 'commit-' + i + '-' + j, x,y,dst.cell-1,dst.cell-1,color(step.rgba),'#00000000',0,12,0);
    });
    rect(group, 'write-span-' + i, dst.left + (left+right)*dst.cell/2, dst.top+(span.y+0.5)*dst.cell,(right-left)*dst.cell-2,dst.cell-2,'#00000000',C.orange,3,25);
    const value = text('coverage-' + i, String(span.coverage) + ' / 255',475,360,22,0);
    return {group,targets,value};
  }).filter(Boolean);
  const beats=[{time:0,label:'Native RLE coverage and fill color'}]; let time=.6;s.wait(.6);
  for(const [i,a] of actions.entries()) {
    s.play([{target:a.group,opacity:1},{target:a.value,opacity:1}],.2,'linear');time+=.2;
    s.wait(.4);time+=.4;
    s.play(a.targets.map(target=>({target,opacity:1})),.4,'linear');time+=.4;
    if(i===0||i===Math.floor(actions.length/2))beats.push({time,label:'Native span '+i+' committed'});
    if(i!==actions.length-1){s.play([{target:a.group,opacity:0},{target:a.value,opacity:0}],.1,'linear');time+=.1;}
  }
  s.wait(1.4);time+=1.4;beats.push({time,label:'All native spans written'});
  return {...ui,beats,data};
}

export function buildComposition(data = buildScenarios().composition) {
  const ui=stage('composition'),{scene:s,text,grid,rect}=ui;
  const src=grid('source',data.source,35,140,250,true);
  const before=grid('destination',data.initial,355,140,250,true);
  const after=grid('output',data.initial,675,140,250,true);
  text('source-label','Source',160,98);text('destination-label','Destination',480,98);text('output-label','Output',800,98);
  text('opacity','opacity = '+data.opacity,160,432,19);
  text('source-term',"S'",360,490,20);text('plus','+',465,490,25);text('destination-term',"D'",570,490,20);
  text('equals','=',645,490,25);text('sum',"S' + D'",760,550,19);
  const actions=data.steps.map((step,i)=>{
    const group=s.group({id:'composition-pixel-'+i,opacity:0});
    for(const [key,g] of [['src',src],['dst',before],['out',after]]) {
      const [x,y]=g.centers[step.y*data.target.width+step.x];
      rect(group,key+'-read-'+i,x,y,g.cell-2,g.cell-2,'#00000000',key==='out'?C.orange:C.teal,3,25);
    }
    // Opaque RGB contribution patches show byte addition; these are not extra Surfaces.
    rect(group,'s-term-'+i,410,490,60,60,color([...step.source.slice(0,3),255]));
    rect(group,'d-term-'+i,515,490,60,60,color([...step.destination.slice(0,3),255]));
    rect(group,'sum-term-'+i,760,490,100,60,color(step.rgba));
    const [x,y]=after.centers[step.y*data.target.width+step.x];
    const commit=rect(s,'commit-'+i,x,y,after.cell-1,after.cell-1,color(step.rgba),'#00000000',0,12,0);
    return {group,commit};
  });
  const beats=[{time:0,label:'Premultiplied source and existing destination'}];let time=.5;s.wait(.5);
  for(const [i,a] of actions.entries()){
    s.fade(a.group,1,.12,'linear');time+=.12;
    s.wait(i===0||i===18?.9:.35);time+=i===0||i===18?.9:.35;
    s.fade(a.commit,1,.2,'linear');time+=.2;
    if(i===0||i===18)beats.push({time,label:'Byte contributions for pixel '+i});
    if(i!==actions.length-1){s.fade(a.group,0,.06,'linear');time+=.06;}
  }
  s.wait(1.4);time+=1.4;beats.push({time,label:'All output bytes committed'});
  return {...ui,beats,data};
}
