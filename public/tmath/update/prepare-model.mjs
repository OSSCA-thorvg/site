import native from '../postprocessing/native-trace.mjs';

// CPU engine b4471844. Geometry/span values are recorded by the native engine;
// affine variants below are illustrative inputs to the same prepare decisions.
export const shapeEvidence = native.tasks.find(task => task.id === 'A');
export const sourceCommit = native.sourceCommit;
// rasterPremultiply skips opaque pixels; PREMULTIPLY uses c*a/256 for the rest.
export const premultiplyRgba = rgba => rgba[3] === 255 ? [...rgba]
  : [...rgba.slice(0, 3).map(channel => channel * rgba[3] >> 8), rgba[3]];
// scripts/update-image-native-trace.cpp, linked against the unchanged b4471844
// library: imagePrepare -> imageGenRle(antiAlias=false) -> rleClip(triangle RLE).
const imageNative = {
  matrix: [6, -2, 9, 2, 6, 3], clipPoints: [[8,7], [18,10], [11,18]],
  spans: [[8,3,4,255],[8,4,7,255],[8,5,10,255],[7,6,14,255],[7,7,14,255],[7,8,14,255],
    [6,9,15,255],[6,10,14,255],[6,11,14,255],[5,12,15,255],[5,13,14,255],[5,14,14,255],
    [5,15,14,255],[8,16,10,255],[11,17,7,255],[14,18,4,255]],
  clipSpans: [[8,7,1,184],[9,7,1,142],[10,7,1,65],[11,7,1,5],[8,8,1,152],[9,8,2,255],
    [11,8,1,239],[12,8,1,167],[13,8,1,91],[14,8,1,18],[8,9,1,82],[9,9,5,255],
    [14,9,1,252],[15,9,1,193],[16,9,1,116],[17,9,1,39],[8,10,1,16],[9,10,1,253],
    [10,10,7,255],[17,10,1,144],[9,11,1,198],[10,11,6,255],[16,11,1,174],[17,11,1,3],
    [9,12,1,129],[10,12,5,255],[15,12,1,199],[16,12,1,9],[9,13,1,59],[10,13,4,255],
    [14,13,1,219],[15,13,1,21],[9,14,1,4],[10,14,1,241],[11,14,2,255],[13,14,1,236],
    [14,14,1,37],[10,15,1,175],[11,15,1,255],[12,15,1,247],[13,15,1,57],[10,16,1,105],
    [11,16,1,254],[12,16,1,82],[10,17,1,36],[11,17,1,112]],
};
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

export function invalidationInputs({translation = [2, 1], parentOpacity = 255, localOpacity = 255} = {}) {
  return {
    translation, parentOpacity, localOpacity,
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
