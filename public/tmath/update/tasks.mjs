import {tmath} from '../runtime/client.js';

// ThorVG b447184: tvgSwRenderer.cpp SwTask / SwShapeTask / SwImageTask;
// tvgTaskScheduler.h Task::prepare, operator(), done. Two valid independent
// prepare tasks on a threaded build. Positions show dependencies, not CPU time.
// Beats: persistent data owners → queued handles → run / stored results →
// completion → draw consumption → reuse of those same owners next update.
export function buildTasks() {
 const scene=tmath.scene({width:1280,height:1320,fps:30,loop:false,
  camera:{mode:'fixed',view:'2d',height:13.2},theme:{preset:'pro_white',background:'#f7f7f7',
   text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:'#222222'}]))}});
 const ink='#222222',muted='#777777',orange='#e66121',blue='#1f6bc4';
 let serial=0,time=0;const textIds=[],textPolicies={},beats=[];
 const id=()=>`tasks-${serial++}`,p=(x,y)=>[(x-640)/100,(660-y)/100];
 const group=(opacity=0)=>scene.group({id:id(),opacity});
 const rect=(parent,x,y,w,h,stroke=ink,fill='#ffffff')=>{
  const key=id();parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],stroke,fill,width:1.4,layer:15});return key;
 };
 const text=(parent,value,x,y,size=23,color=ink,owner)=>{
  const key=id();textIds.push(key);textPolicies[key]=owner?{owner,inset:12}:{standalone:true};
  parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',size,fill:color,align:[.5,.5],layer:40});
 };
 const box=(parent,value,x,y,w=280,h=62,color=ink)=>{const key=rect(parent,x,y,w,h,color);text(parent,value,x,y,23,color,key);};
 const route=(parent,points,tip=0)=>parent.route({id:id(),points:points.map(v=>p(...v)),stroke:ink,width:1.4,tip,...(tip?{dash:[5,4]}:{}),layer:5});
 const play=(spec,d=.4)=>{scene.play(spec,d,'ease_in_out');time+=d;};
 const show=(g,d=.4)=>play([{target:g,opacity:1}],d);
 const hide=(g,d=.2)=>play([{target:g,opacity:0}],d);
 const wait=d=>{scene.wait(d);time+=d;};
 const beat=label=>{beats.push({time:+time.toFixed(3),label});wait(1);};
 text(scene,'Prepare tasks',640,48,32);
 box(scene,'Task',640,137,270,58);text(scene,'run(tid) · done()',940,137,20,muted);
 route(scene,[[640,167],[640,224]]);
 box(scene,'SwTask',640,255,310,62);
 const context=group();text(context,'transform · clips · opacity · flags',640,318,22,muted);
 route(scene,[[640,344],[330,344],[330,380]]);route(scene,[[640,344],[950,344],[950,380]]);
 const tasks=[
  {x:330,name:'SwShapeTask',input:'const RenderShape* rshape',output:'SwShape shape',data:'Rect / RLE · Fill · Stroke',handle:'Shape',render:'Raster · task->shape',color:orange},
  {x:950,name:'SwImageTask',input:'RenderSurface* source',output:'SwImage image',data:'Pixels · Sampling · Image RLE*',handle:'Bitmap',render:'Raster · task->image',color:blue},
 ];
 const stored=tasks.map(t=>{
  const owner=rect(scene,t.x,565,530,370);
  text(scene,t.name,t.x,418,28,t.color,owner);
  text(scene,t.input,t.x,481,21,muted,owner);
  const dataOwner=rect(scene,t.x,595,464,140,'#bcbcbc');
  const output=group();text(output,t.output,t.x,565,25,t.color,dataOwner);
  text(output,t.data,t.x,621,20,ink,dataOwner);
  text(scene,'RenderData = task',t.x,711,21,muted,owner);
  return output;
 });
 text(scene,'* Image RLE when needed',950,777,17,muted);
 const flow=group();box(flow,'request(task)',230,861,286);box(flow,'run(tid)',640,861,270);box(flow,'done()',1050,861,250);
 route(flow,[[373,861],[505,861]],8);route(flow,[[775,861],[925,861]],8);
 text(flow,'TaskScheduler',230,807,19,muted);text(flow,'Worker',640,807,19,muted);text(flow,'Caller · render*()',1050,807,19,muted);
 const tokens=tasks.map((t,i)=>{const g=group();const owner=rect(g,230,928+i*56,142,50,t.color);text(g,t.handle,230,928+i*56,17,t.color,owner);return g;});
 const pending=group();text(pending,'pending = true',640,1037,21,muted);
 const complete=group();text(complete,'ready = true',640,1037,21,blue);
 const draw=group();tasks.forEach(t=>box(draw,t.render,t.x,1125,350,62,t.color));
 route(draw,[[1050,1012],[1050,1070],[330,1070],[330,1094]],8);
 route(draw,[[1050,1070],[950,1070],[950,1094]],8);
 const reuse=group();text(reuse,'Next update · reuse the same RenderData',640,1240,25);
 tasks.forEach(t=>rect(reuse,t.x,565,546,386,t.color,'#00000000'));
 beat('SwShapeTask and SwImageTask inherit Task and retain their own prepared data.');
 show(context);show(flow);play(tokens.map(target=>({target,opacity:1})));show(pending,.2);
 beat('prepareCommon supplies context and submits the same task handles.');
 play(tokens.map(target=>({target,shift:[4.1,0]})),.7);
 play(stored.map(target=>({target,opacity:1})),.65);
 beat('run(tid) prepares each task data object without writing the Canvas target.');
 hide(pending);show(complete,.25);
 beat('The worker publishes ready only after run(tid) returns.');
 play(tokens.map(target=>({target,shift:[4.1,0]})),.65);
 show(draw,.5);beat('done() returns before renderShape or renderImage reads the stored data.');
 show(reuse,.55);beat('Kept tasks survive sync and can be reused by the next prepare call.');wait(.8);
 return {scene,textIds,textPolicies,beats,duration:time};
}
