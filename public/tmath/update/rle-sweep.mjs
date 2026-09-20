import trace from './rle-trace.mjs';
import {sweepCells} from './rle-model.mjs';
import {lesson,pathGrid,gray,C} from './rle-visuals.mjs';

export function buildSweep(input=trace) {
  const data=sweepCells(input),v=lesson('update-sweep','Cells → coverage → RLE spans');
  const {scene,group,text,rect,arrow,show,hide,play,beat,finish}=v;
  text(scene,'_sweep()',175,119,24);arrow(scene,258,119,380,119,C.muted,1.6,[6,5]);
  text(scene,'_horizLine()',500,119,24);arrow(scene,610,119,744,119,C.muted,1.6,[6,5]);text(scene,'SwRle::spans',920,119,24);
  const grid=pathGrid(v,input,{left:65,top:181,step:63});
  input.cells.forEach(c=>rect(scene,...grid.at([c.x+.5,c.y+.5]),63,63,c.cover>0?'#df792b25':'#3f7cce25',c.cover>0?C.orange:C.blue,2,17));
  for(let y=input.band[0];y<input.band[1];y++)text(scene,`y ${y}`,544,181+(y+.5)*63,20,C.muted);
  text(scene,'cover = 0 at each row',298,597,21,C.muted);
  const output=group();
  text(output,'RLE',94,663,23);
  const left=177,spanStep=58,top=687,rowHeight=39;
  for(let y=input.band[0];y<input.band[1];y++){
    text(output,`y ${y}`,129,top+(y-input.band[0])*rowHeight,18,C.muted);
    rect(output,left+7*spanStep/2,top+(y-input.band[0])*rowHeight,7*spanStep,rowHeight-5,C.white,C.grid,1,10);
  }
  text(scene,'x · len · coverage',885,687,21,C.muted);
  const opening=group();text(opening,'Signed cover accumulates',886,256,26);
  for(let i=0;i<3;i++){
    const y=329+i*75;
    text(opening,['edge cell','between cells','span'][i],805,y,24);
    const widths=[44,150,150];rect(opening,1029,y,widths[i],31,i===0?'#df792b55':i===1?'#20202018':C.ink,i===0?C.orange:C.ink,1.4);
  }
  text(opening,'No RGBA buffer yet',886,582,23,C.muted);
  beat('Sparse edge cells become horizontal coverage runs; no color is stored in the RLE.',1.2);
  hide(opening);show(output,.3);
  let prior=null,priorFocus=null;
  for(const [index,event] of data.events.entries()) {
    if(prior)hide(prior,.12);if(priorFocus)hide(priorFocus,.12);
    const {span,source,cover,area}=event,g=group();
    const kind=source?'Cell':'Gap';
    text(g,`${kind} · y ${span.y} · x ${span.x}`,886,221,25,source?(source.cover>0?C.orange:C.blue):C.ink);
    text(g,'cover',735,292,21,C.muted);text(g,String(cover),979,292,32);
    if(source){
      text(g,`${cover-source.cover} ${source.cover>=0?'+':'−'} ${Math.abs(source.cover)}`,886,337,25);
      text(g,`${cover} × 512 − (${source.area})`,886,407,25);
    }else{
      text(g,`carry ${cover}`,886,337,25);
      text(g,`${cover} × 512`,886,407,25);
    }
    text(g,String(area),886,454,28);
    arrow(g,886,484,886,524,C.muted,1.5);
    text(g,'abs(area >> 9) · clamp 255',886,558,22,C.muted);
    text(g,`${span.coverage}`,886,611,37);
    text(g,`${span.x} · ${span.len} · ${span.coverage}`,886,734,26);
    const focus=rect(scene,...grid.at([span.x+span.len/2,span.y+.5]),span.len*63,63,'#00000000',C.ink,3.2,35);
    show(focus,.22);show(g,.35);
    const coverageTile=rect(scene,...grid.at([span.x+span.len/2,span.y+.5]),span.len*63-5,58,gray(span.coverage),'#00000000',0,28);
    show(coverageTile,.42);
    const [sx,sy]=grid.at([span.x+span.len/2,span.y+.5]),dx=left+(span.x+span.len/2)*spanStep,dy=top+(span.y-input.band[0])*rowHeight;
    const token=rect(scene,sx,sy,span.len*spanStep-3,rowHeight-7,gray(span.coverage),C.white,1.2,38);
    show(token,.06);play([{target:token,shift:[(dx-sx)/100,(sy-dy)/100]}],.65);
    const outputValue=text(scene,String(span.coverage),dx,dy,17,span.coverage>150?C.white:C.ink);
    show(outputValue,.13);
    if(index===0)beat(`First edge: ${cover} × 512 − ${source.area} = ${area}; coverage is ${span.coverage}.`,.9);
    else if(index===1)beat('The gap carries cover without extra cells; three pixels become one full-coverage span.',.85);
    else if(index===data.events.length-1)beat('The second row uses the same sweep; the two edge contributions return cover to zero.',1);
    else v.wait(.45);
    prior=g;priorFocus=focus;
  }
  hide(prior,.2);hide(priorFocus,.2);
  const final=group();
  text(final,`${input.cells.length} edge cells`,886,291,27);arrow(final,886,331,886,390,C.ink,2);
  text(final,`${data.spans.length} spans`,886,438,33);
  text(final,'Same y + coverage + adjacent x',886,519,22,C.muted);
  text(final,'→ one run',886,563,25);
  show(final,.6);beat('Completed RLE retains ordered runs; adjacent equal-coverage writes may coalesce.',2);
  return finish({...input,...data});
}
