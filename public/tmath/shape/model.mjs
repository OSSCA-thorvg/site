// Integer AA sweep: tvgSwRle.cpp::_sweep / _horizLine.
export function shapeModel(trace) {
  const spans=[],bands=[],coverage=Array(trace.w*trace.h).fill(0);
  for(const band of trace.bands.filter(b=>b.ok)) {
    const recorded=new Map();
    for(const e of band.events)if(e.type==='cell')recorded.set(`${e.x},${e.y}`,{x:e.x,y:e.y,cover:e.cover,area:e.area});
    for(const c of band.cells)if(JSON.stringify(recorded.get(`${c.x},${c.y}`))!==JSON.stringify(c))throw Error('Cell recording mismatch');
    const events=[];
    function emit(x,y,len,area,cover,cell) {
      let c=Math.abs(Math.floor(area/512));
      if(trace.rule==='evenodd'){c&=511;if(c>255)c=511-c;}else c=Math.min(255,c);
      const e={x,y,len,area,cover,cell,coverage:c,merge:false,index:-1};
      if(c&&len>0){const prev=spans.at(-1);
        if(prev&&prev.y===y&&prev.x+prev.len===x&&prev.coverage===c){prev.len+=len;e.merge=true;}
        else spans.push({x,y,len,coverage:c});
        e.index=spans.length-1;e.span={...spans.at(-1)};
        for(let xx=x;xx<x+len;xx++)coverage[y*trace.w+xx]=c;
      }events.push(e);
    }
    for(let y=band.lo;y<band.hi;y++) {let cover=0,x=0;
      for(const cell of band.cells.filter(c=>c.y===y).sort((a,b)=>a.x-b.x)){
        if(cell.x>x&&cover)emit(x,y,cell.x-x,cover*512,cover,null);
        cover+=cell.cover;emit(cell.x,y,1,cover*512-cell.area,cover,cell);x=cell.x+1;
      }if(cover)emit(x,y,trace.w-x,cover*512,cover,null);
    }bands.push({...band,sweep:events});
  }
  if(JSON.stringify(spans)!==JSON.stringify(trace.spans))throw Error('Sweep does not reproduce native spans');
  if(!trace.verifiedCanvas||!trace.verifiedNormalPool)throw Error('Unverified native fixture');
  return {bands,spans,coverage};
}
// len starts at the CENTER of the coverage pixel.
export const spanGeometry=s=>({start:[s.x+.5,s.y+.5],end:[s.x+.5+s.len,s.y+.5]});
