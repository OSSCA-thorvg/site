import native from '../postprocessing/native-trace.mjs';
import imageTrace from './image-native.mjs';

// CPU engine 4d5810cf. Geometry/span values are recorded by the native engine;
// affine variants below are illustrative inputs to the same prepare decisions.
export const shapeEvidence = native.tasks.find(task => task.id === 'A');
export const sourceCommit = native.sourceCommit;
// rasterPremultiply skips opaque pixels; PREMULTIPLY uses c*a/256 for the rest.
export const premultiplyRgba = rgba => rgba[3] === 255 ? [...rgba]
  : [...rgba.slice(0, 3).map(channel => channel * rgba[3] >> 8), rgba[3]];
// scripts/update-image-native-trace.cpp, linked against the unchanged 4d5810cf
// library: imagePrepare -> imageGenRle(antiAlias=false) -> rleClip(triangle RLE).
const imageNative = {...imageTrace,clipPoints:[[8,7],[18,10],[11,18]],clipSpans:imageTrace.clipRle};
export const transformPoint = (m, [x, y]) => [m[0] * x + m[1] * y + m[2], m[3] * x + m[4] * y + m[5]];
export function clipSpans(spans, [left, top, right, bottom]) {
  return spans.flatMap(([x, y, len, coverage]) => {
    const start = Math.max(x, left), end = Math.min(x + len, right);
    return y >= top && y < bottom && end > start ? [[start, y, end - start, coverage]] : [];
  });
}
// tvgSwRle.cpp::rleClip(SwRle*, const SwRle*): two sorted, non-overlapping row lists.
export function intersectRles(spans, clip) {
  const result = [];
  let i = 0, j = 0;
  while (i < spans.length && j < clip.length) {
    const [x,y,len,c] = spans[i], [cx,cy,clen,cc] = clip[j];
    if (y < cy || len <= 0) {i++; continue;}
    if (cy < y || clen <= 0) {j++; continue;}
    const end = x+len, cend = cx+clen;
    if (end <= cx) {i++; continue;}
    if (cend <= x) {j++; continue;}
    result.push([Math.max(x,cx), y, Math.min(end,cend)-Math.max(x,cx), (c*cc+255)>>8]);
    if (end <= cend) i++;
    if (cend <= end) j++;
  }
  return result;
}
export function imagePreparation({width = 2, height = 2, matrix = [6, -2, 9, 2, 6, 3], clipBox = [0, 0, 24, 24]} = {}) {
  const points = [[0, 0], [width, 0], [width, height], [0, height]];
  const transformed = points.map(point => transformPoint(matrix, point));
  const direct = matrix[0] === 1 && matrix[4] === 1 && matrix[1] === 0 && matrix[3] === 0;
  const scaled = !direct && matrix[1] === 0 && matrix[3] === 0;
  // This example's exported points have integer coordinates, so the native
  // fixed-point BBox -> integer RenderRegion rounding is exact here.
  const box = [Math.min(...transformed.map(p => p[0])), Math.min(...transformed.map(p => p[1])),
    Math.max(...transformed.map(p => p[0])), Math.max(...transformed.map(p => p[1]))];
  const renderBox = [Math.max(box[0], clipBox[0]), Math.max(box[1], clipBox[1]),
    Math.min(box[2], clipBox[2]), Math.min(box[3], clipBox[3])];
  const dx = matrix[2] - imageNative.matrix[2], dy = matrix[5] - imageNative.matrix[5];
  const hasNativeSpans = width === 2 && height === 2 && Number.isInteger(dx) && Number.isInteger(dy)
    && [0, 1, 3, 4].every(i => matrix[i] === imageNative.matrix[i]);
  const spans = hasNativeSpans ? clipSpans(imageNative.spans.map(([x,y,len,c]) => [x+dx,y+dy,len,c]), clipBox) : null;
  const clipPoints = imageNative.clipPoints.map(([x,y]) => [x+dx,y+dy]);
  const clipRle = imageNative.clipSpans.map(([x,y,len,c]) => [x+dx,y+dy,len,c]);
  return {width, height, matrix, points, transformed, box, clipBox, renderBox, direct, scaled,
    spans, clipPoints, clipRle, clippedSpans: spans ? intersectRles(spans, clipRle) : null};
}

export function invalidationInputs({translation = [2, 1], rotation = 40, scale = 1.35, parentOpacity = 255, localOpacity = 255} = {}) {
  return {
    translation, rotation, scale, parentOpacity, localOpacity,
    opacity: (parentOpacity * localOpacity + 255) >> 8,
    parentFlag: 'None',
    paints: [
      {id: 'A', localFlag: 'Transform', effectiveFlag: 'Transform', schedule: true, reuse: false},
      {id: 'B', localFlag: 'None', effectiveFlag: 'None', schedule: false, reuse: true},
    ],
  };
}

// Fresh Shape paths + solid fills, inserted into a Scene and then the Canvas.
// SceneImpl::insert marks Transform on each inserted Paint, including the Scene.
// tvgShape.cpp::lineTo; tvgShape.h::addRect/fill; Paint::Impl::rd initialization.
export function firstFrameInputs() {
  return {
    parentFlag: 'Transform', opacity: 255, clips: [],
    paints: ['A', 'B'].map(id => ({id, localFlag: 'Path | Color | Transform',
      effectiveFlag: 'Path | Color | Transform', previousRd: null, schedule: true, reuse: false})),
  };
}
