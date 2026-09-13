import {tmath} from '../runtime/client.js';
import {traceSolid, traceGradient} from './model.mjs';
import {color} from './scenes.mjs';

// Same native RLE fixture, two color sources (ThorVG cdc1c959).
// tvgSwRaster.cpp:1566-1584,1602-1612; model.mjs replays captured spans/LUT.
// Three beats: retain area/coverage; show color inputs; record rows into Surface.
// Row reveal is an illustrative comparison, not concurrent execution or timing.
export function buildShapeFill(traces=[traceSolid(),traceGradient()]) {
  const width=960,height=580,ink='#191919',muted='#686868';
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f1f1f1'}});
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const textIds=[],textPolicies={},beats=[],rows=new Map(),palettes=[];
  let serial=0,time=0;
  const id=()=>`shape-fill-${serial++}`;
  function text(value,x,y,size=20,fill=ink,align=[.5,.5]) {
    const key=id();textIds.push(key);textPolicies[key]={standalone:true};
    return scene.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill,layer=15) {
    return parent.rectangle({id:id(),center:p(x,y),size:[w/100,h/100],fill,stroke:'#00000000',width:0,layer});
  }
  text('Shape Fill',40,40,28,ink,[0,.5]);
  text('Solid / Linear Gradient',920,40,21,muted,[1,.5]);
  for(const [index,d] of traces.entries()) {
    const top=143+index*220,cy=top+67.5,gradient=d.fill==='gradient';
    scene.line({id:id(),from:p(40,85+index*220),to:p(920,85+index*220),stroke:'#cccccc',width:1,layer:5});
    text(gradient?'Linear Gradient':'Solid',40,cy-20,24,ink,[0,.5]);
    text(gradient?'rasterGradientShape()':'rasterShape()',40,cy+17,17,muted,[0,.5]);
    text('Area + coverage',355,top-25,19,muted);
    text(gradient?'Color Table':'Color',555,top-25,19,muted);
    text('Surface',800,top-25,19,muted);
    text('+',460,cy,26,muted);
    scene.arrow({id:id(),from:p(650,cy),to:p(700,cy),stroke:ink,width:2,tip:10,layer:20});
    const cell=150/Math.max(d.target.width,d.target.height);
    const coverage=new Map(d.steps.map(s=>[s.y*d.target.width+s.x,s.coverage]));
    for(let y=0;y<d.target.height;y++)for(let x=0;x<d.target.width;x++) {
      const i=y*d.target.width+x,v=255-(coverage.get(i)??0);
      rect(scene,280+(x+.5)*cell,top+(y+.5)*cell,cell-1,cell-1,color([v,v,v,255]));
      rect(scene,725+(x+.5)*cell,top+(y+.5)*cell,cell-1,cell-1,(x+y)%2?'#e0e4e6':'#fafafa',5);
    }
    const palette=scene.group({id:id(),opacity:0});palettes.push(palette);
    if(gradient)for(let i=0;i<140;i++) {
      rect(palette,485+i+.5,cy,1,28,color(d.colorTable[Math.floor(i*d.colorTable.length/140)]));
    } else rect(palette,555,cy,90,28,color(d.source.pixels[0]));
    for(const step of d.steps) {
      const key=`${index}-${step.y}`;
      if(!rows.has(key))rows.set(key,{y:step.y,group:scene.group({id:id(),opacity:0})});
      rect(rows.get(key).group,725+(step.x+.5)*cell,top+(step.y+.5)*cell,cell-1,cell-1,color(step.rgba));
    }
  }
  text('Same area · different color source',480,550,21,muted);
  beats.push({time:0,label:'Area and coverage are independent of color'});
  scene.wait(.8);time+=.8;
  scene.play(palettes.map(target=>({target,opacity:1})),.5);time+=.5;
  beats.push({time,label:'A single color or a position-dependent table lookup'});
  scene.wait(.9);time+=.9;
  for(const y of [...new Set([...rows.values()].map(r=>r.y))].sort((a,b)=>a-b)) {
    scene.play([...rows.values()].filter(r=>r.y===y).map(r=>({target:r.group,opacity:1})),.18);
    scene.wait(.08);time+=.26;
  }
  beats.push({time:+time.toFixed(3),label:'Both color sources fill the same covered region'});
  scene.wait(2);
  return {scene,beats,textIds,textPolicies};
}
