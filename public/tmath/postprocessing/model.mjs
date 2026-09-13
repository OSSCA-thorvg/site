export const N = 11;
export const blue = [0.12, 0.40, 0.77];
export const orange = [0.90, 0.38, 0.13];
export const teal = [0.06, 0.48, 0.39];
export const geometry = {
  triangle: [[4.4, 1.5], [1.18, 8.5], [7.62, 8.5]],
  disk: {cx: 6.6, cy: 5.4, radius: 2.7, opacity: 0.85},
};
export const over = (s, d) => s.map((v, k) => v + d[k] * (1 - s[3]));
export const solid = (rgb, a = 1) => [...rgb.map(v => v * a), a];
export const hex = rgb => '#' + rgb.slice(0, 3).map(v => Math.round(Math.min(1, Math.max(0, v)) * 255).toString(16).padStart(2, '0')).join('');
export function sampleImage({cx = geometry.disk.cx, cy = geometry.disk.cy, radius = geometry.disk.radius} = {}) {
  return Array.from({length: N * N}, (_, i) => {
    const x = i % N, y = Math.floor(i / N), sum = [0, 0, 0, 0];
    for (let sy = 0; sy < 4; sy++) for (let sx = 0; sx < 4; sx++) {
      const px = x + (sx + 0.5) / 4, py = y + (sy + 0.5) / 4;
      const [top, left, right] = geometry.triangle;
      const fraction = (py - top[1]) / (left[1] - top[1]);
      const inTriangle = fraction >= 0 && fraction <= 1 && px >= top[0] + (left[0] - top[0]) * fraction && px <= top[0] + (right[0] - top[0]) * fraction;
      const inDisk = (px - cx) ** 2 + (py - cy) ** 2 <= radius ** 2;
      const p = over(solid(blue, inDisk ? geometry.disk.opacity : 0), solid(orange, inTriangle ? 1 : 0));
      p.forEach((v, k) => sum[k] += v / 16);
    }
    return sum;
  });
}
export function box(image, radius = 1, vertical = false) {
  return image.map((_, i) => {
    const out = [0, 0, 0, 0], x = i % N, y = Math.floor(i / N);
    for (let d = -radius; d <= radius; d++) {
      const xx = Math.max(0, Math.min(N - 1, x + (vertical ? 0 : d)));
      const yy = Math.max(0, Math.min(N - 1, y + (vertical ? d : 0)));
      image[yy * N + xx].forEach((v, k) => out[k] += v / (2 * radius + 1));
    }
    return out;
  });
}
export const alpha = image => image.map(p => solid([0.18, 0.21, 0.25], p[3]));
export const fill = (image, color = teal, opacity = 1) => image.map(p => solid(color, p[3] * opacity));
export function shift(image, dx = 1, dy = 1) {
  return image.map((_, i) => {
    const x = i % N - dx, y = Math.floor(i / N) - dy;
    return x >= 0 && y >= 0 && x < N && y < N ? [...image[y * N + x]] : [0, 0, 0, 0];
  });
}
export const blur = image => box(box(image), 1, true);
export const shadowOnly = image => shift(fill(blur(alpha(image)), [0.2, 0.23, 0.3], 0.7));
export const shadow = image => {
  const back = shadowOnly(image);
  return image.map((p, i) => over(p, back[i]));
};
export const luma = rgb => (54 * Math.round(rgb[0] * 255) + 182 * Math.round(rgb[1] * 255) + 19 * Math.round(rgb[2] * 255)) >> 8;
export const mix = (a, b, t) => a.map((v, i) => v * (1 - t) + b[i] * t);
export const tint = (rgb, black, white, intensity = 1) => mix(rgb, mix(black, white, luma(rgb) / 255), intensity);
export function tritone(rgb, dark, mid, light, original = 0) {
  const l = luma(rgb);
  const mapped = l < 128 ? mix(dark, mid, Math.min(l * 2, 255) / 255) : mix(mid, light, 2 * Math.max(0, l - 128) / 255);
  return mix(mapped, rgb, original);
}
