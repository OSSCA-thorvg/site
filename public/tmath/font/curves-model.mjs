import traces from './curves-trace.mjs';

const f=Math.fround;
export const midpoint=(a,b)=>a.map((v,i)=>f(f(v+b[i])*.5));
export const controls=(a,q,b)=>[a,b].map(end=>end.map((v,i)=>f(v+f(f(2/3)*f(q[i]-v)))));
export const quadratic=(a,q,b,t)=>a.map((v,i)=>(1-t)**2*v+2*(1-t)*t*q[i]+t*t*b[i]);
export const cubic=(a,c1,c2,b,t)=>a.map((v,i)=>(1-t)**3*v+3*(1-t)**2*t*c1[i]+3*(1-t)*t*t*c2[i]+t**3*b[i]);

// Replay TtfReader::convert's simple-contour branch, including float32 order,
// implied endpoints and closure; compare every command/point to native output.
export function replayCurves(trace) {
  const cmds=[],pts=[],segments=[];
  let begin=0;
  const append=(cmd,...values)=>{cmds.push(cmd);pts.push(...values);};
  function curve(q,end,controlIndex,kind) {
    const start=pts.at(-1),[c1,c2]=controls(start,q,end);
    segments.push({start,q,end,c1,c2,controlIndex,kind});
    append('C',c1,c2,end);
  }
  for(const last of trace.ends) {
    let off=!trace.raw[begin].on;
    const first=off?midpoint(trace.raw[begin].point,trace.raw[last].point):trace.raw[begin].point;
    append('M',first);
    for(let i=begin+1;i<=last;i++) {
      const {point,on}=trace.raw[i];
      if(on) {
        if(off){curve(trace.raw[i-1].point,point,i-1,'explicit');off=false;}
        else append('L',point);
      } else if(off)curve(trace.raw[i-1].point,midpoint(point,trace.raw[i-1].point),i-1,'midpoint');
      else off=true;
    }
    if(off)curve(trace.raw[last].point,first,last,'closure');
    append('Z');begin=last+1;
  }
  if(JSON.stringify(cmds)!==JSON.stringify(trace.path.cmds))throw Error('TTF command mismatch: '+trace.letter);
  if(pts.length!==trace.path.pts.length||pts.some((p,j)=>p.some((v,i)=>v!==f(trace.path.pts[j][i]))))throw Error('TTF point mismatch: '+trace.letter);
  let maxError=0;
  for(const s of segments)for(let i=0;i<=1000;i++) {
    const q=quadratic(s.start,s.q,s.end,i/1000),c=cubic(s.start,s.c1,s.c2,s.end,i/1000);
    maxError=Math.max(maxError,Math.hypot(...q.map((v,k)=>v-c[k])));
  }
  if(maxError>2e-4)throw Error('Quadratic / cubic mismatch: '+maxError);
  return {segments,maxError,commands:cmds.length,points:pts.length};
}

export function curveExample(trace=traces.B) {
  const replay=replayCurves(trace);
  const single=replay.segments.find(s=>s.kind==='explicit'&&trace.raw[s.controlIndex-1]?.on);
  const pairIndex=replay.segments.findIndex((s,i)=>s.kind==='midpoint'&&trace.raw[s.controlIndex-1]?.on&&replay.segments[i+1]?.kind==='explicit');
  if(!single||pairIndex<0)throw Error('Fixture needs explicit and implied endpoint examples');
  return {trace,single,pair:replay.segments.slice(pairIndex,pairIndex+2),replay};
}

// B and C differ in contour count, raw positions, curve runs and closure branch.
export function verifyCurves() {
  return Object.fromEntries(Object.entries(traces).map(([key,trace])=>[key,replayCurves(trace)]));
}
