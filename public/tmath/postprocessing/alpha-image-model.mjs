import {unpremultiply} from './alpha-visuals.mjs';

export const leafInput = {size: 64, cx: 31, cy: 30, radius: 23, color: [0,200,80], hidden: [240,0,80], blurRadius: 3};
export function leafImage(input = leafInput) {
  const {size:n,cx,cy,radius,color,hidden}=input;
  return Array.from({length:n*n},(_,i)=>{
    const dx=i%n+.5-cx, dy=Math.floor(i/n)+.5-cy;
    const u=(dx-dy)/Math.SQRT2, v=(dx+dy)/Math.SQRT2;
    const inside=u*u/(radius*radius)+v*v/(radius*.57)**2<=1;
    // One recognisable leaf silhouette; the bright central vein is opaque too.
    const vein=inside && Math.abs(v)<.65 && u>-radius*.7 && u<radius*.7;
    return inside ? [...(vein?[196,239,203]:color),255] : [...hidden,0];
  });
}
export const premultiplyPixel = c => c[3]===255 ? [...c] :
  c.slice(0,3).map(v=>(v*c[3])>>8).concat(c[3]);

// Illustrative square box filter with clamped edges, not a native Gaussian trace.
// Float means are retained until a complete pixel is quantized to 8-bit.
export function boxPixels(buffer,n,radius) {
  return buffer.map((_,i)=>{
    const x=i%n,y=Math.floor(i/n),sum=[0,0,0,0];
    for(let yy=y-radius;yy<=y+radius;yy++) for(let xx=x-radius;xx<=x+radius;xx++) {
      const c=buffer[Math.max(0,Math.min(n-1,yy))*n+Math.max(0,Math.min(n-1,xx))];
      c.forEach((v,ch)=>sum[ch]+=v);
    }
    return sum.map(v=>Math.round(v/(radius*2+1)**2));
  });
}
export function leafEvidence(input = leafInput) {
  const source=leafImage(input),premultiplied=source.map(premultiplyPixel);
  const bad=boxPixels(source,input.size,input.blurRadius);
  const filtered=boxPixels(premultiplied,input.size,input.blurRadius);
  const straight=filtered.map(unpremultiply);
  // Pick a mid-coverage edge near the leaf's upper-right side, independent of RGB.
  let selected=-1,score=Infinity;
  for(let i=0;i<filtered.length;i++) {
    const x=i%input.size,y=Math.floor(i/input.size),a=filtered[i][3];
    if(a<80||a>180) continue;
    const d=Math.abs(a-128)+Math.hypot(x-(input.cx+input.radius*.65),y-(input.cy-input.radius*.65))*2;
    if(d<score){score=d;selected=i;}
  }
  const point=[selected%input.size,Math.floor(selected/input.size)];
  const roi=point.map(v=>Math.max(0,Math.min(input.size-8,v-3)));
  return {input,source,premultiplied,bad,filtered,straight,selected,point,roi};
}
