// Source: tvgGlRenderer.cpp + tvgGlShaderSrc.cpp at this exact revision.
export const revision = '4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad';
export const stops = [
  {offset: 0, rgba: [127, 39, 255, 255]},
  {offset: .33, rgba: [159, 112, 253, 255]},
  {offset: .66, rgba: [253, 191, 96, 255]},
  {offset: 1, rgba: [255, 137, 17, 255]},
];
export const identity = [1, 0, 0, 0, 1, 0];
export const apply = (m, [x, y]) => [m[0]*x + m[1]*y + m[2], m[3]*x + m[4]*y + m[5]];
export function multiply(a, b) {
  return [a[0]*b[0]+a[1]*b[3], a[0]*b[1]+a[1]*b[4], a[0]*b[2]+a[1]*b[5]+a[2],
    a[3]*b[0]+a[4]*b[3], a[3]*b[1]+a[4]*b[4], a[3]*b[2]+a[4]*b[5]+a[5]];
}
export function inverse(m) {
  const det = m[0]*m[4] - m[1]*m[3];
  if (!det) throw new Error('Singular fixture transform');
  return [m[4]/det, -m[1]/det, (m[1]*m[5]-m[4]*m[2])/det,
    -m[3]/det, m[0]/det, (m[3]*m[2]-m[0]*m[5])/det];
}
const mix = (a, b, t) => a.map((v, i) => v*(1-t) + b[i]*t);
const clamp = x => Math.max(0, Math.min(1, x));
export const hex = rgba => '#'+rgba.map(x => Math.round(Math.max(0, Math.min(255, x))).toString(16).padStart(2, '0')).join('');

export function wrap(d, spread='Repeat') {
  if (spread === 'Pad') return clamp(d);
  if (spread === 'Reflect') {const n = ((d%2)+2)%2; return n > 1 ? 2-n : n;}
  return ((d%1)+1)%1;
}

// Direct port of gradient(): no LUT, derivatives, or invented symmetric kernel.
// The scene proves the end-of-period branch with these opaque four stops.
export function gradient(d, l, {colors=stops, spread='Repeat', aa=true}={}) {
  const t = wrap(d, spread), dist = d*2/l;
  let color;
  if (t <= colors[0].offset) color = colors[0].rgba;
  else if (t >= colors.at(-1).offset) {
    color = colors.at(-1).rgba;
    if (aa && spread === 'Repeat' && 1-t < dist) color = mix(colors[0].rgba, color, (1-t)/dist);
  } else {
    for (let i=0; i<colors.length-1; ++i) {
      const a = colors[i], b = colors[i+1];
      if (t < a.offset || t > b.offset) continue;
      color = mix(a.rgba, b.rgba, clamp((t-a.offset)/(b.offset-a.offset)));
      if (aa && spread === 'Repeat' && Math.abs(d) > dist) {
        if (i === 0 && t-a.offset < dist) {
          const nc = mix(colors[0].rgba, colors.at(-1).rgba, t-a.offset);
          color = mix(nc, color, (t-a.offset)/dist);
        } else if (i === colors.length-2 && 1-t < dist) {
          color = mix(colors[0].rgba, color, (1-t)/dist);
        }
      }
      break;
    }
  }
  const a = color[3]/255;
  return {d, t, dist, straight: color, premultiplied: [color[0]*a,color[1]*a,color[2]*a,color[3]]};
}

export function model({scale=1/16, radius=128, sample=[346.5,345.5], colors=stops}={}) {
  const panel=512, center=panel/2, sourceRadius=radius/scale;
  const cases = ['Fill 변환','Shape 변환','변환 없는 기준'].map((label, i) => {
    const offset=[16+i*(panel+16),16];
    const S=i===1?[scale,0,offset[0],0,scale,offset[1]]:[1,0,offset[0],0,1,offset[1]];
    const F=i===0?[scale,0,center*(1-scale),0,scale,center*(1-scale)]:identity;
    const c=i===1?[center/scale,center/scale]:[center,center];
    const R=i===2?radius:sourceRadius, side=i===1?panel/scale:panel;
    const inv=multiply(inverse(F),inverse(S)), world=sample.map((v,k)=>v+offset[k]);
    const pos=apply(inv,world), l=Math.hypot(pos[0]-c[0],pos[1]-c[1]), d=l/R;
    const combined=multiply(S,F), effectiveScale=Math.hypot(combined[0],combined[3]);
    const aaMargin=2/R, screenRadius=R*effectiveScale, screenMargin=aaMargin*screenRadius;
    return {label,offset,S,F,c,R,side,inv,world,pos,l,d,aaMargin,screenRadius,screenMargin,
      vertices:[[0,0],[side,0],[side,side],[0,side]].map(q=>apply(S,q)),
      sample:gradient(d,l,{colors}),raw:gradient(d,l,{colors,aa:false})};
  });
  return {scale,radius,sourceRadius,panel,center,colors,cases,sample,
    sampleRadius:Math.hypot(sample[0]-center,sample[1]-center)};
}

export function radialAt(entry, point, colors=stops, aa=true) {
  const pos=apply(entry.inv,point), l=Math.hypot(pos[0]-entry.c[0],pos[1]-entry.c[1]);
  return gradient(l/entry.R,l,{colors,aa});
}

// A continuous one-dimensional shader evaluation, distinct from native readback.
export function seamStrip(entry, {width=280, height=30, span=6, colors=stops}={}) {
  const row=Array.from({length:width},(_,x)=>{
    const delta=((x+.5)/width-.5)*span;
    const l=(entry.screenRadius+delta)*entry.R/entry.screenRadius;
    return hex(gradient(l/entry.R,l,{colors}).straight);
  });
  return {width,height,pixels:Array.from({length:height},()=>row).flat()};
}
