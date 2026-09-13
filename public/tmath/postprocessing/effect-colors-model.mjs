import {trace, rgba, pack, scaleBytes} from './native-evidence.mjs';

// Integer operations from b4471844: RenderEffect*.gen(), MULTIPLY,
// INTERPOLATE, _abgrLuma, effect{Fill,Tint,Tritone}(direct=false).
export const multiplyByte = (a, b) => (a * b + 255) >> 8;
export const interpolateBytes = (s, d, a) => d.map((v, i) => Math.floor(v + (s[i] - v) * a / 256));
export const lumaBytes = c => (54 * c[0] + 182 * c[1] + 19 * c[2]) >> 8;
export const configs = {
  tint: {name: 'Tint', black: [31,51,97,255], white: [255,199,102,255], intensity: 75},
  tritone: {name: 'Tritone', shadow: [28,51,97,255], midtone: [224,99,48,255], highlight: [255,224,143,255], blender: 64},
  fill: {name: 'Fill', color: [49,150,123,255]},
};
export function tritoneMap(luma, config = configs.tritone) {
  const lower = luma < 128, weight = lower ? Math.min(luma * 2, 255) : 2 * Math.max(0, luma - 128);
  const left = lower ? config.shadow : config.midtone, right = lower ? config.midtone : config.highlight;
  const first = scaleBytes(left, 255 - weight), second = scaleBytes(right, weight);
  return {lower, weight, left, right, first, second, mapped: first.map((c, i) => c + second[i])};
}
export function buildColorTrace(id, options = {}) {
  const config = {...configs[id], ...options.config};
  if (!config.name) throw new Error('Unknown color effect: ' + id);
  const input = [...(options.input ?? trace.filtered)], width = options.width ?? trace.width, height = options.height ?? trace.height;
  const bbox = options.bbox ?? trace.bbox, opacity = options.opacity ?? trace.opacity;
  const parameter = options.parameter ?? (id === 'tint' ? Math.trunc(Math.fround(Math.fround(config.intensity) * Math.fround(2.55))) : id === 'tritone' ? config.blender : config.color[3]);
  const output = [...input], steps = [];
  for (let y = bbox[1]; y < bbox[3]; y++) for (let x = bbox[0]; x < bbox[2]; x++) {
    const index = y * width + x, source = rgba(input[index]), luma = lumaBytes(source);
    const operation = id === 'tritone' ? tritoneMap(luma, config) : {};
    const mapped = id === 'fill' ? [...config.color.slice(0,3),255] : id === 'tint' ? interpolateBytes(config.white, config.black, luma) : operation.mapped;
    const mixed = id === 'tint' && parameter < 255 ? interpolateBytes(mapped, source, parameter)
      : id === 'tritone' && parameter > 0 ? interpolateBytes(source, mapped, parameter) : mapped;
    const factor = multiplyByte(id === 'fill' ? parameter : opacity, source[3]);
    const result = scaleBytes(mixed, factor);
    output[index] = pack(result);
    steps.push({index, x, y, source, luma, mapped, mixed, factor, result, ...operation});
  }
  return {id, config, parameter, input, output, width, height, bbox, opacity, steps,
    sourceCommit: trace.sourceCommit, variant: `GaussianBlur → ${config.name}; direct=false`};
}
