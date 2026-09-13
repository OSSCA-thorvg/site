import {tmath} from '../runtime/client.js';

// tvgSwRenderer.cpp: prepareCommon/prepare/renderShape/renderImage/sync.
// tvgTaskScheduler.h: run finishes before done permits consumption.
// Illustrative triangle spans and bitmap; no native coverage claim.
// Beats: persistent owners → request → stored results → done/Draw → retained owners.
export function buildTasks() {
 const W=1280,H=1320,ink='#202020',muted='#626262',orange='#e66121',blue='#1f6bc4';
 const scene=tmath.scene({width:W,height:H,fps:30,loop:false,
  camera:{mode:'fixed',view:'2d',height:H/100},theme:{preset:'pro_white',background:'#f2f2f2'}});
 let serial=0,time=0;
 const textIds=[],textPolicies={},beats=[];
 const id=()=>`tasks-${serial++}`,p=(x,y)=>[(x-W/2)/100,(H/2-y)/100];
 const group=(opacity=1)=>scene.group({id:id(),opacity});
 const rect=(parent,x,y,w,h,fill='#ffffff',stroke=ink,layer=15)=>{
  const key=id();
  const handle=parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.5,layer});
  return {key,handle};
 };
 const text=(parent,value,x,y,size=22,color=ink,owner)=>{
  const key=id();textIds.push(key);textPolicies[key]=owner?{owner,inset:12}:{standalone:true};
  parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align:[.5,.5],layer:50});
 };
 const route=(parent,points,tip=9,color=ink,layer=8)=>parent.route({id:id(),points:points.map(v=>p(...v)),stroke:color,width:1.8,tip,layer});
 const play=(spec,d=.5)=>{scene.play(spec,d,'ease_in_out');time+=d;};
 const show=(g,d=.5)=>play([{target:g,opacity:1}],d);
 const wait=d=>{scene.wait(d);time+=d;};
 const beat=label=>{beats.push({time:+time.toFixed(3),label});wait(.8);};
 const box=(parent,label,x,y,w=180,h=58)=>{
  const r=rect(parent,x,y,w,h);
  text(parent,label,x,y,22,ink,r.key);return r;
 };
 // Same asymmetric triangle drives the path, span marks and raster.
 const vertices=[[4.5,.5],[1,8],[9,8]],spans=[];
 for(let y=0;y<9;y++){
  const xs=[];
  for(let i=0;i<3;i++){
   const a=vertices[i],b=vertices[(i+1)%3],py=y+.5;
   if((a[1]<=py&&py<b[1])||(b[1]<=py&&py<a[1]))xs.push(a[0]+(py-a[1])*(b[0]-a[0])/(b[1]-a[1]));
  }
  if(xs.length===2){const x=Math.ceil(Math.min(...xs)-.5),end=Math.ceil(Math.max(...xs)-.5);if(end>x)spans.push({x,y,len:end-x});}
 }
 const bitmap=['#1f6bc4','#1f6bc4','#96bfdf','#f4d078','#1f6bc4','#96bfdf','#f4d078','#f4d078','#96bfdf','#f4d078','#e66121','#e66121','#f4d078','#f4d078','#e66121','#202020'];
 const triangle=(parent,cx,cy,u)=>parent.polygon({id:id(),points:vertices.map(([x,y])=>p(cx+(x-5)*u,cy+(y-4.5)*u)),stroke:orange,width:2,fill:'#00000000',layer:25});
 function bitmapView(parent,cx,cy,u){for(let i=0;i<16;i++)rect(parent,cx+(i%4-1.5)*u,cy+(Math.floor(i/4)-1.5)*u,u-1,u-1,bitmap[i],'#00000000',25);}
 const preparedRows=[],drawnRows=[];
 function rleView(cx,cy,u){for(const s of spans){
  const parent=group(0);preparedRows.push(parent);
  const x=cx+(s.x-5)*u,y=cy+(s.y-4.5)*u;
  rect(parent,x+u/2,y+u/2,u-2,u-2,ink,'#00000000',24);
  route(parent,[[x+u/2,y+u/2],[x+s.len*u,y+u/2]],0,blue,30);
 }}
 function rasterTriangle(cx,cy,u){for(const s of spans){
  const parent=group(0);drawnRows.push(parent);
  for(let j=0;j<s.len;j++)rect(parent,cx+(s.x+j-4.5)*u,cy+(s.y-4)*u,u-1,u-1,orange,'#00000000',25);
 }}
 text(scene,'Prepare Task',640,52,32);
 text(scene,'Input',145,151,21,muted);
 text(scene,'Task → SwTask',610,151,21,muted);
 text(scene,'Canvas',1100,151,21,muted);
 const inputs=group(),prepared=[group(0),group(0)],drawnBitmap=group(0);
 const scan=group(0),scanY=350+(spans[0].y-4)*18;
 route(scan,[[65,scanY],[230,scanY]],0,blue,30);
 for(const [i,y] of [350,750].entries()){
  const owner=rect(scene,610,y,560,340);
  const header=rect(scene,610,y-137,560,66,ink);
  text(scene,i?'SwImageTask':'SwShapeTask',610,y-137,25,'#ffffff',header.key);
  text(scene,'RenderData',450,y-52,21,muted,owner.key);
  route(scene,[[450,y-73],[450,y-100]],8,ink,22);
  text(scene,i?'image':'shape',730,y-50,23,ink,owner.key);
  rect(scene,730,y+52,250,165,'#ffffff','#cccccc');
  text(scene,'run(tid)',485,y+24,22,ink,owner.key);
  route(scene,[[545,y+24],[585,y+24]],9,ink,22);
  route(scene,[[238,y],[310,y]],9);
  rect(scene,1100,y,220,250);
  text(scene,i?'Bitmap':'RenderPath',145,y+125,22);
  if(i){
   bitmapView(inputs,145,y,32);
   bitmapView(prepared[i],730,y+44,27);
   text(prepared[i],'transform',730,y+145,18,muted,owner.key);
   bitmapView(drawnBitmap,1100,y,35);
  }else{
   triangle(inputs,145,y,18);
   rleView(730,y+52,16);
   text(prepared[i],'RLE',730,y+145,18,muted,owner.key);
   rasterTriangle(1100,y,20);
  }
 }
 const consumed=group(0);
 for(const y of [350,750]){
  route(consumed,[[900,y],[980,y]],9);
  text(consumed,'done()',941,y-26,18,muted);
 }
 const request=group(0),running=group(0),completed=group(0),retained=group(0);
 box(request,'request(task)',190,1040,240);
 box(running,'run(tid)',510,1040);
 route(running,[[310,1040],[410,1040]],9);
 box(completed,'done()',810,1040);
 route(completed,[[610,1040],[710,1040]],9);
 box(completed,'Draw',1100,1040);
 route(completed,[[910,1040],[1000,1040]],9);
 box(retained,'sync()',1100,1190);
 route(retained,[[1100,1070],[1100,1150]],9);
 route(retained,[[1000,1190],[190,1190],[190,1080]],9);
 text(retained,'Next update · retained tasks',640,1235,22,muted);
 beat('RenderData points to a Task that owns its prepared result.');
 show(request);beat('Preparation submits Task handles.');
 show(running);show(prepared[0],.3);
 show(scan,.2);
 for(const [i,row] of preparedRows.entries()){
  const dy=-(spans[i].y-spans[0].y)*18/100;
  play([{target:scan,transform:[1,0,0,0, 0,1,0,dy, 0,0,1,0, 0,0,0,1]}, {target:row,opacity:1}],.18);
 }
 play([{target:scan,opacity:0}],.2);
 show(prepared[1],.8);
 beat('run(tid) stores Shape RLE or Bitmap preparation inside its Task.');
 show(completed);show(consumed);
 for(const row of drawnRows)show(row,.12);
 show(drawnBitmap,.8);
 beat('Draw consumes the prepared data after done().');
 show(retained);beat('sync retains non-disposed Tasks for reuse.');wait(1.5);
 return {scene,textIds,textPolicies,beats,duration:time};
}
