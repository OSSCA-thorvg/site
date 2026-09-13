import trace from './effect-shadow-trace.mjs';

export const rgba = value => [value & 255, value >>> 8 & 255, value >>> 16 & 255, value >>> 24];
export const pack = value => (value[0] | value[1] << 8 | value[2] << 16 | value[3] << 24) >>> 0;
export const scale = (value, opacity) => value.map(channel => channel * (opacity + 1) >> 8);
export function over(source, destination, opacity) {
  const foreground = scale(rgba(source), opacity);
  const background = scale(rgba(destination), 255 - foreground[3]);
  return {foreground, background, result: pack(foreground.map((value, c) => value + background[c]))};
}

// _dropShadowFilter reads alpha only, then writes the configured opaque RGB
// multiplied by the filtered alpha. Every pass reuses the same fixed color.
export function buildShadowEvents(data = trace) {
  const width = data.width, blank = () => Array(width * data.height).fill(0);
  let source = data.original;
  const passes = data.passes.map(pass => {
    const output = blank(), rows = [];
    const [x0, y0, x1, y1] = pass.region;
    if (pass.op === 'transpose') {
      for (let y = y0; y < y1; ++y) for (let x = x0; x < x1; ++x)
        output[y * width + x] = source[x * width + y];
    } else {
      const inverse = Math.fround(1 / (pass.radius * 2 + 1));
      for (let y = y0; y < y1; ++y) {
        const writes = [];
        for (let x = x0; x < x1; ++x) {
          const taps = Array.from({length: pass.radius * 2 + 1}, (_, n) => {
            const sx = Math.max(x0, Math.min(x1 - 1, x + n - pass.radius));
            return {x: sx, y, rgba: rgba(source[y * width + sx])};
          });
          const sum = taps.reduce((acc, tap) => acc + tap.rgba[3], 0);
          const alpha = Math.trunc(Math.fround(sum * inverse));
          const result = pack(scale([...data.color.slice(0, 3), 255], alpha));
          output[y * width + x] = result;
          writes.push({x, y, taps, sum, alpha, result});
        }
        rows.push({y, writes});
      }
    }
    const event = {...pass, input: source, output, rows};
    source = output;
    return event;
  });
  const shadowCanvas = [...data.background], shifted = blank(), shifts = [];
  const [x0, y0, x1, y1] = data.bbox, [dx, dy] = data.offset;
  for (let y = y0; y < y1; ++y) for (let x = x0; x < x1; ++x) {
    const tx = x + dx, ty = y + dy;
    if (tx < x0 || ty < y0 || tx >= x1 || ty >= y1) continue;
    const result = over(source[y * width + x], data.background[ty * width + tx], data.shadowOpacity);
    shifted[ty * width + tx] = pack(scale(rgba(source[y * width + x]), data.shadowOpacity));
    shadowCanvas[ty * width + tx] = result.result;
    shifts.push({x, y, tx, ty, ...result});
  }
  const final = shadowCanvas.map((destination, i) => over(data.original[i], destination, data.groupOpacity).result);
  return {passes, shifts, shifted, shadowCanvas, final};
}

export function verifyShadowTrace(data = trace) {
  const events = buildShadowEvents(data);
  const equals = (a, b) => a.length === b.length && a.every((value, i) => value === b[i]);
  const checks = [
    ...events.passes.map((pass, i) => [`pass ${i + 1}`, equals(pass.output, data.passes[i].pixels)]),
    ['shifted shadow', equals(events.shifted, data.shifted)],
    ['shadow Canvas', equals(events.shadowCanvas, data.shadowCanvas)],
    ['final Canvas', equals(events.final, data.final)],
  ];
  const failed = checks.filter(([, ok]) => !ok);
  if (failed.length) throw new Error('DropShadow replay mismatch: ' + failed.map(([name]) => name).join(', '));
  return events;
}
