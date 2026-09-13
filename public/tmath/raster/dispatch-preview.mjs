import {color, textureDisplayPoint} from './scenes.mjs';

// Select by the mechanism being demonstrated, never by authored pixel indices.
export function selectOverviewSamples(input) {
  const {data, id} = input;
  const select = (values, accept, score) => {
    let best = -1, value = -Infinity;
    values.forEach((v, i) => { if (accept(v, i) && score(v, i) > value) { best = i; value = score(v, i); } });
    if (best < 0) throw new Error('No characteristic sample for ' + id);
    return best;
  };
  const contrast = step => step.taps.reduce((sum, tap) => sum + tap.weight *
    tap.rgba.slice(0, 3).reduce((v, c, channel) => v + (c - step.rgba[channel]) ** 2, 0), 0);
  if (input.kind === 'shape') {
    const i = data.branch === 'rect'
      ? select(data.spans, s => s.coverage === 255, s => s.len)
      : select(data.spans, s => s.coverage > 0 && s.coverage < 255, s => -Math.abs(s.coverage - 128));
    return [i, i];
  }
  if (id === 'bilinear' || id === 'downscale') {
    const i = select(data.steps, s => id === 'bilinear'
      ? s.taps.length === 4 && s.taps.every(t => t.weight > .1)
      : s.kernel.inc > 1 && s.taps.length >= 4,
    s => contrast(s));
    return [i, i];
  }
  const i = select(data.steps, (s, i) => {
    const next = data.steps[i + 1];
    if (!next || s.y !== next.y || s.x + 1 !== next.x) return false;
    if (id === 'nearest') return s.taps[0].x === next.taps[0].x && s.taps[0].y === next.taps[0].y;
    if (id === 'texmap') return s.triangle === next.triangle && s.feather === 255 && next.feather === 255 && s.taps.length === 4 && next.taps.length === 4;
    return true;
  }, s => id === 'texmap' ? contrast(s) : s.rgba[0] + s.rgba[1] - 2 * s.rgba[2]);
  return [i, i + 1];
}

// Overview evidence is a set of independent queries on the complete native-
// checked result. The detailed episodes below the overview replay every write.
export function buildDispatchPreview({parent, input, rowY, p, rect, line, key}) {
  const data = input.data;
  const teal = '#009d91', orange = '#eb8c28';
  function grid(bitmap, left, top, size) {
    const cell = size / Math.max(bitmap.width, bitmap.height);
    const centers = bitmap.pixels.map((rgba, index) => {
      const x = index % bitmap.width, y = Math.floor(index / bitmap.width);
      const center = [left + (x + .5) * cell, top + (y + .5) * cell];
      rect(parent, ...center, cell, cell, (x + y) % 2 ? '#e8edf2' : '#f5f7fa', '#00000000', 0, 4);
      rect(parent, ...center, cell - .7, cell - .7, color(rgba), '#00000000', 0, 10);
      return center;
    });
    const width = cell * bitmap.width, height = cell * bitmap.height;
    rect(parent, left + width / 2, top + height / 2, width, height, '#00000000', '#a0a0a0', 1, 15);
    return {left, top, cell, centers};
  }
  const sourceSize = input.id === 'direct' ? 124 * Math.max(data.source.width, data.source.height) / Math.max(data.target.width, data.target.height) : 124;
  const src = grid(data.source, 680 + (124 - sourceSize) / 2, rowY - 62 + (124 - sourceSize) / 2, sourceSize);
  const dst = grid(data.target, 1090, rowY - 62, 124);
  line(parent, [[812, rowY], [836, rowY]], '#a0a0a0', 1.4, 'read', 6);
  line(parent, [[1022, rowY], [1076, rowY]], '#a0a0a0', 1.4, 'write', 7);
  if (data.triangles) for (const indices of data.triangles)
    parent.polygon({id: key('triangle'), points: indices.map(j => p(...textureDisplayPoint(dst, data.vertices[j]))),
      fill: '#00000000', stroke: '#a0a0a0', width: 1, layer: 18});

  const indices = selectOverviewSamples(input);
  const actions = indices.map(index => {
    const steps = [data.steps[index]];
    const step = steps[0];
    const focus = parent.group({id: key('query'), opacity: 0});
    const result = focus.group({id: key('result'), opacity: 0});
    const [dx, dy] = dst.centers[step.y * data.target.width + step.x];
    const tokenWidth = dst.cell - 2;
    if (step.kernel) {
      const {minx, maxx, miny, maxy} = step.kernel;
      rect(focus, src.left + (minx + maxx) * src.cell / 2, src.top + (miny + maxy) * src.cell / 2,
        (maxx - minx) * src.cell, (maxy - miny) * src.cell, '#00000000', '#191919', 2, 20);
    }
    if (step.triangle !== undefined) {
      focus.polygon({id: key('active-triangle'), points: data.triangles[step.triangle].map(j => p(...textureDisplayPoint(dst, data.vertices[j]))),
        fill: '#00000000', stroke: teal, width: 2, layer: 24});
      line(focus, [textureDisplayPoint(dst, {x: Math.max(0, step.scanline.left), y: step.y + 1}),
        textureDisplayPoint(dst, {x: Math.min(data.target.width, step.scanline.right), y: step.y + 1})], teal, 2, 'scanline');
    }
    const taps = step.taps.filter(tap => tap.weight > 0), total = taps.reduce((sum, tap) => sum + tap.weight, 0);
    let x = 846;
    for (const tap of taps) {
      const center = src.centers[tap.y * data.source.width + tap.x];
      rect(focus, ...center, src.cell - 2, src.cell - 2, '#00000000', '#ffffff', 4, 25);
      rect(focus, ...center, src.cell - 2, src.cell - 2, '#00000000', teal, 2, 26);
      const width = 84 * tap.weight / total;
      rect(focus, x + width / 2, rowY, width, 44, color(tap.rgba), '#00000000', 0, 22);
      x += width;
    }
    if (Number.isFinite(step.sx) && Number.isFinite(step.sy)) {
      const offset = .5;
      const x = src.left + (step.sx + offset) * src.cell, y = src.top + (step.sy + offset) * src.cell;
      line(focus, [[x - 5, y], [x + 5, y]], '#191919', 2, 'sample-x');
      line(focus, [[x, y - 5], [x, y + 5]], '#191919', 2, 'sample-y');
    }
    rect(focus, dx, dy, tokenWidth, dst.cell - 2, '#00000000', orange, 2.5, 27);
    line(focus, [[940, rowY], [964, rowY]], '#191919', 2, 'compute', 9);
    rect(result, 993, rowY, 44, 44, color(step.rgba), '#a0a0a0', 1, 29);
    const token = parent.group({id: key('sample-copy'), opacity: 0});
    rect(token, 993, rowY, tokenWidth, dst.cell - 2, color(step.rgba), '#ffffff', 1, 35);
    return {focus, result, token, dx, dy, homeX: 993, homeY: rowY, steps};
  });
  return {actions};
}
