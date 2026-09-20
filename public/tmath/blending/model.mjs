import trace, {variant as changed} from './native-trace.mjs';
export const input = trace;
export const variant = changed;
export const modes = ['Normal', 'Multiply', 'Screen'];
export const rgba = p => [p & 255, (p >>> 8) & 255, (p >>> 16) & 255, p >>> 24];
export const hex = c => '#' + c.slice(0, 3).map(v => v.toString(16).padStart(2, '0')).join('');
export const multiply = (s, d) => (s * d + 255) >> 8;
export const interpolate = (s, d, c) => d + Math.floor((s - d) * c / 256);
const alpha = (v, a) => (v * (a + 1)) >> 8;
// Fixture regime: opaque solid S; D is premultiplied and may have partial alpha.
// Exact scalar blendMultiply / blendScreen, not a general BlendMethod emulator.
export function blend(s, d, mode) {
  if (mode === 'Normal') return [...s];
  if (mode === 'Screen') return s.map((v,k) => k===3 ? 255 : v+d[k]-multiply(v,d[k]));
  const a=d[3];
  const b=s.map((v,k)=>k===3?255:multiply(v,a>0&&a<255?Math.min(255,Math.floor(d[k]*255/a)):d[k]));
  return a===255?b:a===0?[...s]:b.map((v,k)=>alpha(v,a)+alpha(s[k],255-a));
}
export function pixel(s,d,mode,c) {
  if(!c)return [...d];
  const b=blend(s,d,mode);
  if(c===255)return b;
  return b.map((v,k)=>mode==='Normal'?alpha(v,c)+alpha(d[k],255-c):interpolate(v,d[k],c));
}
export function display(c,i,width) {
  const bg=(Math.floor(i/width)+i%width)%2?244:231;
  return c.slice(0,3).map(v=>Math.min(255,Math.round(v+bg*(255-c[3])/255)));
}
export function buildModel(data=input) {
  const {width:w,height:h,cases}=data,blank=Array(w*h).fill(0),d=c=>c.map(rgba);
  for(const record of Object.values(cases)) for(const task of [record.sourceTask,record.destinationTask].filter(Boolean)){
    const expanded=Array(w*h).fill(0);
    if(task.fastTrack){const [x0,y0,x1,y1]=task.curBox;for(let y=y0;y<y1;y++)for(let x=x0;x<x1;x++)expanded[y*w+x]=255;}
    for(const [x,y,len,c] of task.spans){
      if(x<0||y<0||x+len>w||y>=h||len<1)throw Error('Span exceeds Surface');
      for(let i=0;i<len;i++)expanded[y*w+x+i]=c;
    }
    if(expanded.some((c,i)=>c!==task.coverage[i]))throw Error('Native coverage differs');
  }
  for(const [name,record] of Object.entries(cases)){
    const base=record.destinationTask?record.destinationTask.coverage.map(c=>pixel(data.destination,[0,0,0,0],'Normal',c)):d(blank);
    const expected=record.sourceTask?base.map((dst,i)=>pixel(data.source,dst,modes.includes(name)?name:name==='fastRect'?'Multiply':'Normal',record.sourceTask.coverage[i])):base;
    if(record.pixels.some((v,i)=>rgba(v).some((c,k)=>c!==expected[i][k])))throw Error(name+' native color differs');
  }
  const coverage=cases.Multiply.sourceTask.coverage,destinationPixels=d(cases.destination.pixels);
  const edge=coverage.findIndex((c,i)=>c>30&&c<220&&destinationPixels[i].every((v,k)=>v===data.destination[k]));
  const full=coverage.findIndex((c,i)=>c===255&&destinationPixels[i].every((v,k)=>v===data.destination[k]));
  if(edge<0||full<0)throw Error('Fixture must include partial and full overlap');
  const colors=Object.fromEntries(Object.entries(cases).map(([k,v])=>[k,v.pixels.map((p,i)=>hex(display(rgba(p),i,w)))]));
  const blankColors=blank.map((v,i)=>hex(display(rgba(v),i,w)));
  return {...data,coverage,edge,full,edgePoint:[edge%w,Math.floor(edge/w)],destinationPixels,blankColors,colors,
    blended:blend(data.source,data.destination,'Multiply'),edgeResult:rgba(cases.Multiply.pixels[edge]),
  };
}
