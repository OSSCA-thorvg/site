import {tmath} from '../runtime/client.js';

// ThorVG cdc1c9596a5edebc159d5623d726febda7595896, local ./thorvg:
// tvgCanvas.h:104-130; tvgSwRenderer.cpp:272-284,819-824;
// tvgTaskScheduler.h:56-64; tvgArray.h:179-182.
// Source relationship map, not a measured execution trace. Both conditional
// branches are shown; exactly one runs per task. Clear follows the whole loop.
// Beats: call boundary -> done -> conditional release -> clear -> Synced.
export function buildOverview() {
  const width=1280,height=760,ink='#202020',muted='#626262';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const id=name=>`sync-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=name=>scene.group({id:id(name),opacity:0});
  function text(parent,value,x,y,size=22,color=ink,owner,align=[.5,.5]) {
    const key=id('text');textIds.push(key);
    textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill='#ffffff',stroke=ink,dash) {
    const key=id('rect');
    parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.5,...(dash?{dash}:{}),layer:12});
    return {id:key};
  }
  function arrow(parent,points) {
    parent.route({id:id('route'),points:points.map(([x,y])=>p(x,y)),stroke:ink,width:1.8,tip:9,layer:20});
  }
  function node(parent,x,y,w,title,detail) {
    const box=rect(parent,x,y,w,94);
    text(parent,title,x,y-18,23,ink,box);
    text(parent,detail,x,y+22,18,muted,box);
  }
  function beat(label,hold) {beats.push({time:+time.toFixed(3),label});scene.wait(hold);time+=hold;}
  function show(target) {scene.play([{target,opacity:1}],.55,'ease_in_out');time+=.55;}

  text(scene,'Sync / End',50,42,30,ink,undefined,[0,.5]);
  text(scene,'CPU task completion',1230,42,22,muted,undefined,[1,.5]);
  scene.line({id:id('rule'),from:p(50,78),to:p(1230,78),stroke:'#cccccc',width:1,layer:5});
  text(scene,'Update',140,120,20,muted);
  text(scene,'Draw / Composite',405,120,20,muted);
  text(scene,'postRender()',740,120,20,muted);
  text(scene,'sync()',1120,120,22);
  arrow(scene,[[200,120],[280,120]]);
  arrow(scene,[[535,120],[645,120]]);
  arrow(scene,[[840,120],[1055,120]]);
  text(scene,'inside draw()',570,157,16,muted);
  scene.line({id:id('draw-scope'),from:p(285,141),to:p(840,141),stroke:'#aaaaaa',width:1,layer:5});

  text(scene,'Canvas::sync()',215,225,23);
  text(scene,'Canvas::Impl::sync()',630,225,23);
  text(scene,'SwRenderer::sync()',1075,225,23);
  arrow(scene,[[335,225],[455,225]]);
  arrow(scene,[[800,225],[910,225]]);

  const wait=group('wait');
  rect(wait,445,453,790,312,'#00000000','#aaaaaa',[6,5]);
  text(wait,'for each task',80,325,19,muted,undefined,[0,.5]);
  node(wait,235,455,280,'task->done()','wait if still pending');

  const release=group('release');
  node(release,625,390,330,'delete task','disposed == true');
  node(release,625,535,330,'pushed = false','otherwise: keep RenderData');
  arrow(release,[[376,455],[415,455],[415,390],[459,390]]);
  arrow(release,[[415,455],[415,535],[459,535]]);

  const clear=group('clear');
  arrow(clear,[[841,455],[918,455]]);
  text(clear,'after all tasks',1040,370,19,muted);
  node(clear,1075,455,310,'tasks.clear()','list count = 0');

  const synced=group('synced');
  arrow(synced,[[1075,503],[1075,597]]);
  const result=rect(synced,1075,645,310,94,ink);
  text(synced,'status = Synced',1075,627,23,'#ffffff',result);
  text(synced,'Canvas::Impl',1075,667,18,'#dddddd',result);
  text(synced,'Live tasks remain reusable.',445,671,23);
  text(synced,'Update without Draw also reaches this cleanup.',445,711,18,muted);

  beat('Call boundary: postRender belongs to draw()',1.3);
  show(wait);beat('Each registered task reaches done()',1.5);
  show(release);beat('Delete disposed tasks; retain live RenderData',2);
  show(clear);beat('Clear the registration list after every task',1.5);
  show(synced);beat('Return to Canvas and set Synced',2.7);
  return {scene,beats,textIds,textPolicies};
}
