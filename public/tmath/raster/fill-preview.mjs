import {color} from './scenes.mjs';
import {selectOverviewSamples} from './dispatch-preview.mjs';

// Geometry is deliberately colorless. Color/ctable is a separate input to writes.
export function buildFillPreview({parent,input,rowY,p,rect,line,text,key}) {
  const d=input.data, gradient=d.fill==='gradient', teal='#009d91';
  const coverage=d.target.pixels.map(()=>0);
  for(const s of d.steps)coverage[s.y*d.target.width+s.x]=s.coverage;
  function grid(left,output){
    const cell=110/Math.max(d.target.width,d.target.height),top=rowY-44;
    if(!output){
      rect(parent,left+d.target.width*cell/2,top+d.target.height*cell/2,d.target.width*cell,d.target.height*cell,'#ffffff','#00000000',0,4);
      for(let x=1;x<d.target.width;x++)line(parent,[[left+x*cell,top],[left+x*cell,top+d.target.height*cell]],'#e8edf2',.5,'area-grid');
      for(let y=1;y<d.target.height;y++)line(parent,[[left,top+y*cell],[left+d.target.width*cell,top+y*cell]],'#e8edf2',.5,'area-grid');
    }
    for(let i=0;i<coverage.length;i++){
      const x=i%d.target.width,y=Math.floor(i/d.target.width),cx=left+(x+.5)*cell,cy=top+(y+.5)*cell;
      if(output)rect(parent,cx,cy,cell,cell,(x+y)%2?'#e8edf2':'#f5f7fa','#00000000',0,4);
      const c=output?color(d.target.pixels[i]):color([255-coverage[i],255-coverage[i],255-coverage[i],255]);
      if(output?d.target.pixels[i][3]>0:coverage[i]>0)rect(parent,cx,cy,cell-.6,cell-.6,c,'#00000000',0,10);
    }
    rect(parent,left+d.target.width*cell/2,top+d.target.height*cell/2,d.target.width*cell,d.target.height*cell,'#00000000','#a0a0a0',1,15);
    return {left,top,cell};
  }
  const area=grid(680,false),dst=grid(1090,true);
  text(parent,d.stroke?'strokeRle':d.branch==='rect'?'Rect':'RLE',735,rowY-84,14);
  text(parent,gradient?'Color Table':'Color',924,rowY-84,14);
  text(parent,'Surface',1145,rowY-84,14);
  if(gradient)for(let i=0;i<176;i++){
    const index=Math.min(d.colorTable.length-1,Math.floor(i*d.colorTable.length/176));
    rect(parent,836+i+.5,rowY-58,1,22,color(d.colorTable[index]),'#00000000',0,15);
  }
  else rect(parent,924,rowY-58,80,22,color(d.source.pixels[0]),'#00000000',0,15);
  line(parent,[[924,rowY-43],[924,rowY-17]],'#a0a0a0',1.5,'color-read',7);
  line(parent,[[963,rowY+16],[963,rowY+27]],'#a0a0a0',1.5,'coverage-apply',6);
  line(parent,[[1008,rowY+45],[1074,rowY+45]],'#a0a0a0',1.5,'surface-write',7);
  const actions=selectOverviewSamples(input).map(index=>{
    const span=d.spans[index],steps=d.steps.filter(s=>s.spanIndex===index);
    const focus=parent.group({id:key('fill-query'),opacity:0});
    const result=focus.group({id:key('covered-colors'),opacity:0});
    const token=parent.group({id:key('fill-write'),opacity:0});
    const x=area.left+(span.x+span.len/2)*area.cell,y=area.top+(span.y+.5)*area.cell;
    rect(focus,x,y,span.len*area.cell-1,area.cell-1,'#00000000',teal,2.5,25);
    // Coordinates choose table entries; coverage gates the resulting colors.
    line(focus,[[796,y],[818,y],[818,rowY+45],[912,rowY+45]],teal,1.8,'area-to-write',7);
    if(gradient)for(const s of steps){
      const tx=836+(s.tableIndex+.5)*176/d.colorTable.length;
      line(focus,[[tx,rowY-70],[tx,rowY-43]],'#191919',1.5,'table-index');
    }
    const dx=dst.left+(span.x+span.len/2)*dst.cell,dy=dst.top+(span.y+.5)*dst.cell;
    const tokenWidth=span.len*dst.cell-1;
    steps.forEach((s,i)=>{
      const raw=gradient?s.gradientSample:d.source.pixels[0];
      rect(focus,921+(i+.5)*84/steps.length,rowY,84/steps.length,28,color(raw),'#00000000',0,23);
      rect(result,921+(i+.5)*84/steps.length,rowY+45,84/steps.length,28,color(s.rgba),'#00000000',0,25);
      rect(token,963-tokenWidth/2+(i+.5)*tokenWidth/steps.length,rowY+45,tokenWidth/steps.length,dst.cell-1,color(s.rgba),'#00000000',0,35);
    });
    rect(focus,dx,dy,tokenWidth,dst.cell-1,'#00000000','#eb8c28',2.5,27);
    rect(focus,735,rowY+70,84,7,'#e8edf2','#00000000',0,22);
    rect(focus,693+42*span.coverage/255,rowY+70,84*span.coverage/255,7,teal,'#00000000',0,23);
    text(focus,span.coverage+' / 255',735,rowY+91,12);
    return {focus,result,token,dx,dy,homeX:963,homeY:rowY+45,steps};
  });
  return {actions};
}
