import trace from './rle-trace.mjs';
import {poolLayout} from './rle-model.mjs';
import {lesson,pathGrid,gray,C} from './rle-visuals.mjs';

export function buildPool(input=trace) {
  const v=lesson('update-pool','SwMpool · temporary cells, retained spans');
  const {scene,group,text,rect,line,arrow,show,hide,play,beat,finish}=v;
  text(scene,'SwShapeTask · tid',180,117,23);arrow(scene,324,117,444,117,C.muted,1.6,[6,5]);
  text(scene,'mpool->cell(tid)',591,117,23);arrow(scene,747,117,852,117,C.muted,1.6,[6,5]);text(scene,'cellPools[tid]',1000,117,23);
  const grid=pathGrid(v,input,{left:58,top:215,step:51});
  text(scene,'Outline',237,162,23);
  const mx=524,my=276,mw=624,mh=93,unit=mw/input.poolBytes;
  text(scene,'Temporary · same buffer',836,194,24);
  rect(scene,mx+mw/2,my+mh/2,mw,mh,C.white,C.ink,1.8,10);
  const output=group(),ox=572,oy=548,step=67,rowH=37;
  text(output,'SwRle::spans',832,488,25);
  for(let y=1;y<5;y++){
    text(output,`y ${y}`,541,oy+(y-1)*rowH,17,C.muted);
    rect(output,ox+7*step/2,oy+(y-1)*rowH,7*step,rowH-4,C.white,C.grid,1,10);
  }
  text(output,'Retained for Draw/Raster',831,726,23);
  text(scene,`Reduced pool · ${input.poolBytes} B`,239,666,22,C.muted);
  text(scene,'Default · 16,368 B',239,704,20,C.muted);
  text(scene,'bbox sizing → band allocation',836,238,20,C.muted);
  beat('A task selects the temporary cell pool by thread index; RLE spans own separate storage.',1.1);
  show(output,.45);
  let oldMemory=null,oldBand=null,oldStatus=null;
  const successful=[];
  for(const [index,attempt] of input.attempts.entries()) {
    const [lo,hi]=attempt.band,layout=poolLayout(hi-lo,input),start=mx+layout.alignedBytes*unit,cellW=input.cellBytes*unit;
    if(oldMemory){hide(oldMemory,.55);hide(oldBand,.3);hide(oldStatus,.2);}
    const memory=group(),band=group(),status=group();
    rect(band,58+7*51/2,215+(lo+hi)*51/2,7*51,(hi-lo)*51,'#20202009',C.ink,2,15);
    text(band,`Band [${lo}, ${hi})`,239,563,25);
    for(let y=0;y<hi-lo;y++){
      rect(memory,mx+(y+.5)*input.pointerBytes*unit,my+mh/2,input.pointerBytes*unit,mh,'#dddddd',C.white,1,16);
      text(memory,String(y),mx+(y+.5)*input.pointerBytes*unit,my+mh/2,16);
    }
    if(layout.paddingBytes)rect(memory,mx+(layout.headBytes+layout.paddingBytes/2)*unit,my+mh/2,layout.paddingBytes*unit,mh,'#eeeeee',C.white,1,16);
    text(memory,`yCells[${hi-lo}]`,mx+layout.alignedBytes*unit/2,my+mh+26,18,C.muted);
    const slots=[];
    for(let i=0;i<layout.maxCells;i++)slots.push(rect(memory,start+(i+.5)*cellW,my+mh/2,cellW,mh,'#00000000',C.grid,1.2,17));
    text(memory,`${layout.maxCells} cells · world (x,y)`,start+(mw-layout.alignedBytes*unit)/2,my+mh+26,19,C.muted);
    show(memory,.45);show(band,.4);
    const objects=[];
    for(const [slot,c] of attempt.allocated.entries()){
      const token=group(),[sx,sy]=grid.at([c.x+.5,c.y+.5]),dx=start+(slot+.5)*cellW,dy=my+mh/2;
      rect(token,sx,sy,cellW-4,mh-8,c.cover>0?'#df792b36':'#3f7cce36',c.cover>0?C.orange:C.blue,1.6,33);
      show(token,.05);play([{target:token,shift:[(dx-sx)/100,(sy-dy)/100]}],index===0?.32:.2);
      const value=text(scene,`${c.x},${c.y}`,dx,dy,18);show(value,.04);
      objects.push(token,value);
    }
    // Tokens are separate identities so their positions reflect the actual native
    // allocation order. Retire them together with the pool contents on retry.
    if(!attempt.ok){
      text(status,'Pool full',835,434,26);
      show(status,.3);beat('The first band exhausts its six available cell slots and emits no spans.',1.2);
      const split=group();
      const middle=lo+((hi-lo)>>1);
      line(split,58,215+middle*51,415,215+middle*51,C.ink,3,[7,5]);
      text(split,'split → retry',239,614,24);
      show(split,.5);beat('Midpoint subdivision reduces row-head storage and retries the same outline in smaller bands.',1.1);
      hide(split,.25);
    }else{
      text(status,`_sweep() → ${attempt.spans.length} spans`,835,434,25);
      show(status,.3);
      for(const span of attempt.spans){
        const token=rect(scene,ox+(span.x+span.len/2)*step,oy+(span.y-1)*rowH,span.len*step-2,rowH-5,gray(span.coverage),C.white,1,25);
        show(token,.10);successful.push(token);
      }
      beat(index===1?'The upper half fits; its RLE spans survive while the temporary pool is reset.':'The lower half reuses the same pool and appends the remaining ordered spans.',1.1);
    }
    for(const object of objects)hide(object,index===0?.08:.045);
    oldMemory=memory;oldBand=band;oldStatus=status;
  }
  hide(oldMemory,.55);hide(oldBand,.3);hide(oldStatus,.2);
  const final=group();
  text(final,'Next task → reuse buffer',836,321,26,C.muted);
  text(final,`${input.allSpans.length} spans retained`,836,434,29);
  text(final,'[1, 3) + [3, 5)',239,583,24);
  text(final,'Same coverage as the full pool',239,624,21,C.muted);
  show(final,.5);beat('Temporary cell contents are discarded; all sixteen retained spans match the unrestricted native render.',2);
  return finish(input);
}
