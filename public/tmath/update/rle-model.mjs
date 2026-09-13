import trace from './rle-trace.mjs';

// b4471844 tvgSwRle.cpp::_sweep / _horizLine, nonzero fill and anti-aliasing.
// Cell x,y are world coordinates in the trace; cover/area retain signed 24.8 units.
export function coverageOf(area, rule = 'nonzero') {
  let coverage = Math.abs(Math.floor(area / 512));
  if (rule === 'evenodd') {coverage &= 511; if (coverage > 255) coverage = 511 - coverage;}
  else coverage = Math.min(255,coverage);
  return coverage;
}
export function sweepCells(input = trace) {
  const events=[],spans=[];
  function emit(x,y,len,area,source,cover) {
    const coverage=coverageOf(area);
    if (!coverage || !len) return;
    const span={x,y,len,coverage};
    events.push({source,cover,area,span:{...span}});
    const previous=spans.at(-1);
    if(previous&&previous.y===y&&previous.coverage===coverage&&previous.x+previous.len===x)previous.len+=len;
    else spans.push(span);
  }
  for(let y=input.band[0];y<input.band[1];y++) {
    let cover=0,x=input.bbox[0];
    for(const cell of input.cells.filter(v=>v.y===y).sort((a,b)=>a.x-b.x)) {
      if(cell.x>x&&cover!==0)emit(x,y,cell.x-x,cover*512,null,cover);
      cover+=cell.cover;
      emit(cell.x,y,1,cover*512-cell.area,cell,cover);
      x=cell.x+1;
    }
    if(cover!==0)emit(x,y,input.bbox[2]-x,cover*512,null,cover);
  }
  return {events,spans};
}
export function poolLayout(rows, input = trace) {
  const headBytes=rows*input.pointerBytes;
  const alignedBytes=Math.ceil(headBytes/input.cellBytes)*input.cellBytes;
  return {headBytes,alignedBytes,paddingBytes:alignedBytes-headBytes,maxCells:(input.poolBytes-alignedBytes)/input.cellBytes};
}
