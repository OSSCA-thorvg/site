import trace from './native-trace.mjs';

export {trace};
export const rgba = value => [value & 255, (value >>> 8) & 255, (value >>> 16) & 255, value >>> 24];
export const pack = channels => (channels[0] | channels[1] << 8 | channels[2] << 16 | channels[3] << 24) >>> 0;
// tvgSwCommon.h: ALPHA_BLEND multiplies each stored byte by (alpha + 1) / 256.
export const scaleBytes = (channels, opacity) => channels.map(value => (value * (opacity + 1)) >> 8);
export function compositeTerms(source, destination, opacity) {
  const foreground = scaleBytes(rgba(source), opacity);
  const background = scaleBytes(rgba(destination), 255 - foreground[3]);
  return {foreground, background, result: foreground.map((v, i) => v + background[i])};
}
export function replaySpans(records, initial, width = trace.width, batch = 8) {
  const state = [...initial], frames = [];
  for (let i = 0; i < records.length; i += batch) {
    for (const record of records.slice(i, i + batch)) {
      record.pixels.forEach((pixel, x) => { state[record.y * width + record.x + x] = pixel; });
    }
    frames.push({completed: Math.min(i + batch, records.length), pixels: [...state]});
  }
  return frames;
}
export function alphaWindow(pixels, x, y, radius = 1, width = trace.width) {
  return Array.from({length: radius * 2 + 1}, (_, i) => pixels[y * width + Math.max(0, Math.min(width - 1, x + i - radius))] >>> 24);
}
