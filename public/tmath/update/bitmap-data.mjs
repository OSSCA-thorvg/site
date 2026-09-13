import {tmath} from '../runtime/client.js';
import native from './bitmap-native.mjs';
import {bitmap} from './render-data-model.mjs';

// Seven beats: source alias; Direct; Scaled; general affine; Clip input;
// retained native spans; handoff. Each column is an independent Picture.
// Colored quads are source-cell geometry under transform, not sampled Canvas pixels.
export function buildBitmapData({trace=native}={}) {
 const width=1280,height=1500,ink='#222222',gray='#737373',paper='#f7f7f7',unit=22;
 const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
  theme:{preset:'pro_white',background:paper,text:Object.fromEntries(['h1','h2','h3','text','code'].map(r=>[r,{font:'Pretendard',color:ink}]))}});
 let serial=0,time=0;const textIds=[],textPolicies={},beats=[],geometry=[];
 const id=()=>`bitmap-data-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
 const group=(opacity=0)=>scene.group({id:id(),opacity});
 const text=(g,value,x,y,size=22,color=ink,owner)=>{
  const key=id();textIds.push(key);textPolicies[key]=owner?{owner,inset:12}:{standalone:true};
  g.text({id:key,text:String(value),point:p(x,y),size,font:'Pretendard',fill:color,align:[.5,.5],layer:40});
 };
 const rect=(g,x,y,w,h,fill=paper,stroke=ink,layer=15)=>{
  const key=id();const handle=g.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.2,layer});return {key,handle};
 };
 const line=(g,points,{color=ink,dashed=false,tip=0,layer=10}={})=>g.route({id:id(),points:points.map(q=>p(...q)),stroke:color,width:1.3,fill:'#00000000',tip,...(dashed?{dash:[5,4]}:{}),layer});
 const play=(spec,d=.45)=>{scene.play(spec,d,'ease_in_out');time+=d;};
 const show=(g,d=.4)=>play([{target:g,opacity:1}],d);
 const create=(objects,d=.7)=>{scene.create(objects,d,'linear');time+=d;};
 const beat=(label,hold=1)=>{beats.push({time:+time.toFixed(3),label});scene.wait(hold);time+=hold;};
 const grid=(g,cx,top)=>{
  const left=cx-6*unit,xy=([x,y])=>[left+x*unit,top+y*unit];
  for(let i=0;i<=12;i++){
   line(g,[[left+i*unit,top],[left+i*unit,top+12*unit]],{color:'#dedede',layer:5});
   line(g,[[left,top+i*unit],[left+12*unit,top+i*unit]],{color:'#dedede',layer:5});
  }
  text(g,'0',left-15,top,16,gray);text(g,'12',left+12*unit,top+12*unit+19,16,gray);
  return {left,top,xy};
 };
 const source=(g,cx,cy,side)=>bitmap.pixels.forEach((color,i)=>rect(g,cx+((i%bitmap.w+.5)/bitmap.w-.5)*side,
  cy+((Math.floor(i/bitmap.w)+.5)/bitmap.h-.5)*side,side/bitmap.w,side/bitmap.h,color,'#00000000'));
 text(scene,'Picture Bitmap · prepared members',640,47,31);
 source(scene,119,137,76);
 text(scene,'image.data = source->data',412,111,23);
 text(scene,`w = ${bitmap.w} · h = ${bitmap.h} · stride = ${bitmap.stride}`,412,156,21,gray);
 text(scene,'image.filter = Bilinear',938,111,23);
 text(scene,'task.transform · task.curBox',938,156,21,gray);
 line(scene,[[45,199],[1235,199]],{color:'#dedede'});
 const labels={direct:'Direct',scaled:'Scaled',transformed:'Transformed'};
 const lanes=trace.filter(row=>row.id!=='clipped').map((row,i)=>{
  const cx=218+i*422;
  text(scene,labels[row.id],cx,240,26);
  text(scene,'task.transform',cx,278,19,gray);
  text(scene,`[ ${row.matrix.slice(0,3).join('    ')} ]`,cx,312,22);
  text(scene,`[ ${row.matrix.slice(3).join('    ')} ]`,cx,347,22);
  const plane=grid(scene,cx,385),origin=p(plane.left,plane.top);
  const quad=scene.group({id:id(),matrix:[1,0,0,origin[0],0,1,0,origin[1],0,0,1,0,0,0,0,1]});
  bitmap.pixels.forEach((color,n)=>quad.rectangle({id:id(),center:[(n%bitmap.w+.5)*unit/100,-(Math.floor(n/bitmap.w)+.5)*unit/100],
   size:[unit/100,unit/100],fill:color,stroke:ink,width:1,layer:20}));
  const [a,b,tx,c,d,ty]=row.matrix;
  const target=[a,-b,0,origin[0]+tx*unit/100,-c,d,0,origin[1]-ty*unit/100,0,0,1,0,0,0,0,1];
  const fields=group(),box=group();
  const [x0,y0,x1,y1]=row.curBox;
  const boundary=line(box,[[x0,y0],[x1,y0],[x1,y1],[x0,y1],[x0,y0]].map(plane.xy),{color:gray,dashed:true,layer:30});
  text(fields,'image.outline → task.curBox',cx,690,20,gray);
  text(fields,row.direct?'image.direct = true':`direct = false · scaled = ${row.scaled}`,cx,738,19);
  text(fields,row.direct?`image.ox / oy = (${row.offset.join(', ')})`:`image.scale = ${Number(row.scale.toFixed(4))}`,cx,781,21);
  text(fields,'image.rle = nullptr',cx,824,21);
  text(fields,`curBox = (${x0}, ${y0}) → (${x1}, ${y1})`,cx,866,19,gray);
  geometry.push({id:row.id,origin,unit,target,corners:row.corners.map(plane.xy),box:row.curBox});
  return {row,quad,target,fields,box,boundary};
 });
 const clip=trace.find(row=>row.id==='clipped'),clipScene=group(),clipOutline=group(),clipSteps=group(),clipResult=group();
 line(clipScene,[[45,913],[1235,913]],{color:'#dedede'});
 text(clipScene,'Transformed + Clip · picture->clip(shape)',640,959,25);
 const input=grid(clipScene,240,1013),output=grid(clipScene,1040,1013);
 line(clipScene,[...clip.corners,clip.corners[0]].map(input.xy),{color:'#b7b7b7',layer:15});
 const outline=line(clipOutline,[...clip.clipPoints,clip.clipPoints[0]].map(input.xy),{layer:25});
 text(clipOutline,`task.clips.count = ${clip.clips}`,240,1323,21);
 text(clipScene,'SwImageTask::run()',640,1089,23);
 const stepsBox=rect(clipSteps,640,1174,354,118);
 text(clipSteps,'imageGenRle()',640,1150,22,ink,stepsBox.key);
 text(clipSteps,'clipper->clip(image.rle)',640,1196,21,ink,stepsBox.key);
 const arrows=[line(clipSteps,[[383,1160],[453,1160]],{dashed:true,tip:8}),line(clipSteps,[[827,1160],[895,1160]],{dashed:true,tip:8})];
 const spanRows=new Map(),spanEvidence=[];
 for(const [x,y,len,coverage] of clip.rle){
  if(!spanRows.has(y))spanRows.set(y,{owner:group(),lines:[]});
  const row=spanRows.get(y),start=output.xy([x+.5,y+.5]),end=[start[0]+len*unit,start[1]],color=ink+coverage.toString(16).padStart(2,'0');
  row.lines.push(line(row.owner,[start,end],{color,layer:25}));
  line(row.owner,[[end[0],end[1]-3],[end[0],end[1]+3]],{color,layer:25});
  rect(row.owner,...start,11,11,'#ffffff','#00000000',26);
  rect(row.owner,...start,11,11,color,'#00000000',27);
  spanEvidence.push({x,y,len,coverage,start,end});
 }
 text(clipResult,'image.rle → SwRle::spans',1040,1323,22);
 text(clipResult,'x · y · len · coverage',1040,1362,20,gray);
 const handoff=group();
 text(handoff,'task.curBox · task.transform · image.data → Draw',640,1421,23);
 text(handoff,'Outline → pool     RLE → task.image.rle',640,1464,20,gray);
 beat('Source pixels are shared by source->data and image.data; each column starts from the same 2×2 geometry.');
 for(const lane of lanes){
  play([{target:lane.quad,transform:lane.target}],1.1);
  show(lane.box,.15);create(lane.boundary,.35);show(lane.fields,.45);
  beat(lane.row.direct?'Direct stores integer source offsets.':lane.row.scaled?'Axis-aligned scaling stores scale and scaled=true.':'A general affine transform stores scale and scaled=false; no Clip still means no image RLE.',1.2);
 }
 show(clipScene,.5);show(clipOutline,.2);create(outline,.7);
 beat('A Shape clip adds one task.clips entry; its triangle is independent of the image quad.');
 show(clipSteps,.4);create(arrows,.3);
 for(const row of spanRows.values()){show(row.owner,.06);create(row.lines,.09);}
 show(clipResult,.35);
 beat('The clipped case retains the exact native intersection as SwRle::spans.');
 show(handoff,.4);
 beat('Draw reads the retained image members and common task context; source pixels have not been resampled during Update.',2.2);
 return {scene,textIds,textPolicies,beats,duration:time,geometry,spanEvidence,trace};
}
