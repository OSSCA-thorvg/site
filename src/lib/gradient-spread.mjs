/** @typedef {'Pad' | 'Repeat' | 'Reflect'} SpreadMode */

/** @param {number} t @param {SpreadMode} mode */
export function spreadT(t, mode) {
  if (mode === 'Repeat') return t - Math.floor(t);
  if (mode === 'Reflect') {
    const period = t - 2 * Math.floor(t / 2);
    return 1 - Math.abs(period - 1);
  }
  return Math.max(0, Math.min(1, t));
}

/** @param {SpreadMode} mode */
export function spreadFormula(mode) {
  if (mode === 'Repeat') return 'u = t − floor(t)';
  if (mode === 'Reflect') return 'u = 1 − |(t mod 2) − 1|';
  return 'u = clamp(t, 0, 1)';
}

// Canvas fallback for the interactive labs. The primary image uses ThorVG SW.
/**
 * @param {CanvasRenderingContext2D} context
 * @param {number} width
 * @param {number} height
 * @param {{offset: number, color: string}[]} stops
 * @param {(x: number, y: number) => number} position
 * @param {SpreadMode} mode
 */
export function drawGradientPreview(context, width, height, stops, position, mode) {
  const entries = stops.map(stop => ({offset: stop.offset, rgb: [1, 3, 5].map(i => parseInt(stop.color.slice(i, i + 2), 16))}));
  const table = new Uint8ClampedArray(1024 * 4);
  for (let index = 0; index < 1024; index++) {
    const t = index / 1023;
    let rgb = entries.at(-1).rgb;
    if (t <= entries[0].offset) rgb = entries[0].rgb;
    else {
      const right = entries.findIndex(stop => stop.offset >= t);
      if (right > 0) {
        const a = entries[right - 1], b = entries[right];
        const u = b.offset === a.offset ? 0 : (t - a.offset) / (b.offset - a.offset);
        rgb = a.rgb.map((v, i) => Math.round(v + (b.rgb[i] - v) * u));
      }
    }
    table.set([...rgb, 255], index * 4);
  }
  const image = context.createImageData(width, height);
  for (let y = 0; y < height; y++) for (let x = 0; x < width; x++) {
    const t = position(x + 0.5, y + 0.5);
    if (!Number.isFinite(t)) continue;
    const index = Math.round(spreadT(t, mode) * 1023) * 4;
    const offset = (y * width + x) * 4;
    for (let channel = 0; channel < 4; channel++) image.data[offset + channel] = table[index + channel];
  }
  context.putImageData(image, 0, 0);
}
