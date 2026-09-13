// Circle coverage recorded by the unchanged CPU renderer in
// src/content/blog/Mentoring/LUA/image-clip-trace.cpp. The second run moves cx to 5.5.
// Keep Source colors separate from the clip Shape and image coverage lists.
const circleSpans = [
  [4,0,1,2], [5,0,2,39], [7,0,1,2],
  [3,1,1,39], [4,1,1,210], [5,1,2,255], [7,1,1,209], [8,1,1,38],
  [2,2,1,2], [3,2,1,210], [4,2,4,255], [8,2,1,208], [9,2,1,2],
  [2,3,1,39], [3,3,6,255], [9,3,1,37],
  [2,4,1,39], [3,4,6,255], [9,4,1,37],
  [2,5,1,2], [3,5,1,209], [4,5,4,255], [8,5,1,207], [9,5,1,1],
  [3,6,1,38], [4,6,1,208], [5,6,2,255], [7,6,1,207], [8,6,1,37],
  [4,7,1,2], [5,7,2,37], [7,7,1,1],
];
const variantCircleSpans = [
  [4,0,1,15], [5,0,1,52], [6,0,1,15],
  [2,1,1,1], [3,1,1,126], [4,1,1,252], [5,1,1,255], [6,1,1,251], [7,1,1,124],
  [2,2,1,83], [3,2,5,255], [8,2,1,81],
  [2,3,1,167], [3,3,5,255], [8,3,1,165],
  [2,4,1,167], [3,4,5,255], [8,4,1,165],
  [2,5,1,82], [3,5,5,255], [8,5,1,80],
  [3,6,1,123], [4,6,1,251], [5,6,1,255], [6,6,1,251], [7,6,1,121],
  [4,7,1,14], [5,7,1,51], [6,7,1,13],
];

const revision = '6cf10d47fbe13b45040f2c56feeafa0711f53b2b';
const reference = (name, path, line) => ({name, path, line,
  url: `https://github.com/thorvg/thorvg/blob/${revision}/${path}#L${line}`});
export const pictureRefs = {
  update: reference('PictureImpl::update()', 'src/renderer/tvgPicture.h', 61),
  prepare: reference('SwRenderer::prepare()', 'src/renderer/cpu_engine/tvgSwRenderer.cpp', 860),
  task: reference('SwImageTask::run()', 'src/renderer/cpu_engine/tvgSwRenderer.cpp', 202),
  convert: reference('rasterConvertCS()', 'src/renderer/cpu_engine/tvgSwRaster.cpp', 1746),
  premultiply: reference('rasterPremultiply()', 'src/renderer/cpu_engine/tvgSwRaster.cpp', 1598),
  imagePrepare: reference('imagePrepare()', 'src/renderer/cpu_engine/tvgSwImage.cpp', 64),
  imageGenRle: reference('imageGenRle()', 'src/renderer/cpu_engine/tvgSwImage.cpp', 86),
  clip: reference('rleClip()', 'src/renderer/cpu_engine/tvgSwRle.cpp', 899),
  renderImage: reference('SwRenderer::renderImage()', 'src/renderer/cpu_engine/tvgSwRenderer.cpp', 381),
  directRle: reference('_rasterDirectRleImage()', 'src/renderer/cpu_engine/tvgSwRaster.cpp', 870),
};

const rgba = pixel => [pixel & 255, (pixel >>> 8) & 255, (pixel >>> 16) & 255, pixel >>> 24];
const pack = channels => (channels[0] | (channels[1] << 8) | (channels[2] << 16) | (channels[3] << 24)) >>> 0;
const spanObject = ([x, y, len, coverage]) => ({x, y, len, coverage});

// ALPHA_BLEND uses (a + 1) / 256, including when a is zero.
// cRasterTranslucentPixels scales Source by span coverage before source-over.
function composite(source, destination, coverage) {
  const src = rgba(source).map(channel => channel * (coverage + 1) >> 8);
  const dst = rgba(destination).map(channel => channel * (256 - src[3]) >> 8);
  return pack(src.map((channel, i) => channel + dst[i]));
}

export function buildPictureModel({variant = false} = {}) {
  const w = 8, h = 6, tx = 2, ty = 1;
  const pixels = Array.from({length: w * h}, (_, i) => {
    const x = i % w, y = Math.floor(i / w);
    let color = 0xffefd090;
    if (x >= 6 && y >= 1 && y <= 2) color = 0xff40c4fa;
    if (y >= 2 && y >= 5 - Math.abs(x - 3)) color = 0xff807552;
    if (y >= 5) color = 0xff599541;
    return color;
  });
  const source = {w, h, stride: w, cs: 'ABGR8888', channelSize: 4,
    premultiplied: true, alphaIgnored: false, pixels, rgba: pixels.map(rgba)};
  const clip = {circle: {cx: variant ? 5.5 : 6, cy: 4, r: 3.25},
    spans: (variant ? variantCircleSpans : circleSpans).map(spanObject)};
  const initialSpans = Array.from({length: h}, (_, y) => ({x: tx, y: y + ty, len: w, coverage: 255}));
  // rleClip intersection specialized to this translated rectangular image:
  // each initial row has coverage 255, so the retained clip coverage is exact.
  const spans = clip.spans.flatMap(span => {
    if (span.y < ty || span.y >= ty + h) return [];
    const x = Math.max(tx, span.x), end = Math.min(tx + w, span.x + span.len);
    return end > x ? [{x, y: span.y, len: end - x, coverage: span.coverage}] : [];
  });
  const image = {data: source.pixels, w, h, stride: source.stride, channelSize: 4,
    alphaIgnored: source.alphaIgnored, direct: true, scaled: false, ox: -tx, oy: -ty,
    filter: 'Bilinear', initialSpans, spans};
  const target = {w: 12, h: 8, stride: 16, background: 0xffdef0fa};
  target.buffer = Array(target.stride * target.h).fill(target.background);
  const writes = spans.map(span => {
    const sourceIndices = [], targetIndices = [], colors = [];
    for (let dx = 0; dx < span.len; dx++) {
      const src = (span.y + image.oy) * image.stride + span.x + dx + image.ox;
      const dst = span.y * target.stride + span.x + dx;
      const color = composite(source.pixels[src], target.buffer[dst], span.coverage);
      target.buffer[dst] = color;
      sourceIndices.push(src);
      targetIndices.push(dst);
      colors.push(color);
    }
    return {...span, sourceIndices, targetIndices, pixels: colors, rgba: colors.map(rgba)};
  });
  target.pixels = Array.from({length: target.w * target.h}, (_, i) =>
    target.buffer[Math.floor(i / target.w) * target.stride + i % target.w]);
  target.rgba = target.pixels.map(rgba);
  return {source, target, clip, image, writes, transform: [1, 0, tx, 0, 1, ty, 0, 0, 1],
    outline: [[tx, ty], [tx + w, ty], [tx + w, ty + h], [tx, ty + h]],
    refs: pictureRefs};
}

// ARGB8888S -> ABGR8888 on a little-endian host, followed by PREMULTIPLY.
// This separate non-opaque pixel demonstrates work skipped by the main fixture.
export function normalizationExample(rgba = [200, 100, 64, 128]) {
  const [r,g,b,a]=rgba;
  return {source:[b,g,r,a],aligned:[r,g,b,a],
    premultiplied:[r,g,b].map(c=>a===255?c:(c*a)>>8).concat(a)};
}
