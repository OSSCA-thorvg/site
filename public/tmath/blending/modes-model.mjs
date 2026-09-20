import manifest from './gallery/manifest.json' with {type: 'json'};
export const input = {kind: 'midtone', source: [230,97,33], destination: [48,136,208]};
export const variant = {kind: 'solid', source: [0,255,255], destination: [255,255,0]};
export const hex = rgb => '#' + rgb.slice(0,3).map(v => v.toString(16).padStart(2,'0')).join('');
const categories = [
  ['Normal', 'Base', 'S'],
  ['Multiply', 'Darken', 'S × D'], ['Darken', 'Darken', 'min(S, D)'], ['ColorBurn', 'Darken', '1 - min(1, (1-D) / S)'],
  ['Screen', 'Lighten', 'S + D - S × D'], ['Lighten', 'Lighten', 'max(S, D)'], ['ColorDodge', 'Lighten', 'min(1, D / (1-S))'], ['Add', 'Lighten', 'min(1, S + D)'],
  ['Overlay', 'Contrast', 'branch on D'], ['HardLight', 'Contrast', 'branch on S'], ['SoftLight', 'Contrast', 'polynomial / sqrt LUT'],
  ['Difference', 'Difference', 'abs(S - D)'], ['Exclusion', 'Difference', 'S + D - 2 × S × D'],
  ['Hue', 'Components', 'S hue · D saturation / luma'], ['Saturation', 'Components', 'S saturation · D hue / luma'],
  ['Color', 'Components', 'S hue / saturation · D luma'], ['Luminosity', 'Components', 'S luma · D hue / saturation'],
];
export function buildModel(data = input) {
  const modes = categories.map(([name, family, rule]) => {
    const record = manifest.records.find(r => r.mode === name && r.case === data.kind);
    if (!record || record.rgba[3] !== 255) throw Error('Mode animation requires opaque native overlap samples');
    return {name, family, rule, rgba: record.rgba, color: hex(record.rgba)};
  });
  return {...data, modes};
}
