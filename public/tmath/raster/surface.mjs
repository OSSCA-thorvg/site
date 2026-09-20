import {tmath} from '../runtime/client.js';

// Local ThorVG 4d5810cf: tvgSwRaster.cpp buffer/color/alpha operations;
// tvgSwRenderer.cpp:prepareCommon/postRender; tvgSwPostEffect.cpp:effectGaussianBlur.
// Independent illustrative examples, not a mandatory call sequence or timing trace.
// Beats: clear pixels; prepare channel order/alpha; write a span; transpose;
// restore straight alpha when the output color space requires it.
export function buildSurface(sample = {a:128, r:240, g:120, b:60}) {
  const width=1280, height=1040, ink='#191919', muted='#686868';
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f1f1f1'}});
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const textIds=[],textPolicies={},beats=[],steps=[];
  let serial=0,time=0;
  const id=name=>`surface-${name}-${serial++}`;
  function text(parent,value,x,y,size=21,color=ink,align=[.5,.5]) {
    const key=id('text'); textIds.push(key); textPolicies[key]={standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill,stroke='#00000000',thickness=0) {
    return parent.rectangle({id:id('pixel'),center:p(x,y),size:[w/100,h/100],fill,stroke,width:thickness,layer:18});
  }
  function row(y,title,functions,context,before,after) {
    scene.line({id:id('rule'),from:p(48,y-78),to:p(1232,y-78),stroke:'#cccccc',width:1,layer:5});
    text(scene,title,48,y-43,25,ink,[0,.5]);
    functions.forEach((f,i)=>text(scene,f,48,y-7+i*32,19,muted,[0,.5]));
    text(scene,context,48,y+60,18,muted,[0,.5]);
    text(scene,before,730,y-44,19,muted);
    scene.arrow({id:id('arrow'),from:p(858,y+22),to:p(958,y+22),stroke:ink,width:2,tip:10,layer:20});
    const result=scene.group({id:id('result'),opacity:0});
    const caption=scene.group({id:id('caption'),opacity:0});
    text(caption,after,1090,y-44,19,muted);
    return {result,caption};
  }
  const colors=['#42647d','#68869b','#b4c8d5','#719b90','#b2c9b4','#c4a26b'];
  function grid(parent,cx,cy,columns,values,cell=30) {
    const rows=Math.ceil(values.length/columns);
    return values.map((fill,i)=>rect(parent,cx+(i%columns-(columns-1)/2)*cell,
      cy+(Math.floor(i/columns)-(rows-1)/2)*cell,cell-3,cell-3,fill));
  }
  // The bytes follow PREMULTIPLY's >>8 and rasterUnpremultiply's integer /alpha.
  const premult={a:sample.a,...Object.fromEntries(['r','g','b'].map(k=>
    [k,sample.a===255?sample[k]:Math.floor(sample[k]*sample.a/256)]))};
  const straight={a:premult.a,...Object.fromEntries(['r','g','b'].map(k=>
    [k,premult.a===0||premult.a===255?premult[k]:Math.min(255,Math.floor(premult[k]*255/premult.a))]))};
  const channelColors={a:'#606060',r:'#b06c66',g:'#648b72',b:'#688ca8'};
  function channels(parent,cx,y,order,values,labels=true) {
    return order.map((channel,i)=>{
      const x=cx+(i-1.5)*48;
      const group=parent.group({id:id('channel')});
      rect(group,x,y+20,32,54,'#e0e0e0');
      // Separate stored-byte bars, not displayed pixel brightness.
      const bar=rect(group,x,y+47-values[channel]/255*27,32,values[channel]/255*54,channelColors[channel]);
      if(labels) text(group,channel.toUpperCase(),x,y+66,18,muted);
      return {group,bar,channel};
    });
  }
  function resizeBar(bar,channel,from,to,y) {
    const ratio=from[channel]===0?1:to[channel]/from[channel];
    const baseline=p(0,y+47)[1];
    return {target:bar,transform:[1,0,0,0, 0,ratio,0,baseline*(1-ratio), 0,0,1,0, 0,0,0,1]};
  }

  text(scene,'Surface operations',48,43,30,ink,[0,.5]);
  text(scene,'CPU Engine',1232,43,22,muted,[1,.5]);

  const clear=row(175,'Initialize surface',['rasterClear()','rasterCompositor()'],'Clear region · configure color / alpha helpers','Existing pixels','Cleared region · zero');
  const pixels=Array.from({length:15},(_,i)=>colors[i%colors.length]);
  grid(scene,730,197,5,pixels);
  const cleared=grid(clear.result,1090,197,5,pixels);
  const clearedIndices=[6,7,8,11,12,13];
  steps.push({...clear,label:'Clear only the selected region',motion:clearedIndices.map(i=>({target:cleared[i],fill:'#dedede'}))});

  const prepare=row(355,'Prepare input',['rasterConvertCS()','rasterPremultiply()'],'Image preparation · channel order and alpha','ABGR · straight','ARGB · premultiplied');
  channels(scene,730,355,['a','b','g','r'],sample);
  const prepared=channels(prepare.result,1090,355,['a','b','g','r'],sample,false);
  const order=['a','r','g','b'];
  order.forEach((channel,i)=>text(prepare.caption,channel.toUpperCase(),1090+(i-1.5)*48,421,18,muted));
  steps.push({...prepare,label:'Align channel order, then premultiply RGB',
    motion:prepared.map((v,i)=>({target:v.group,shift:[(order.indexOf(v.channel)-i)*.48,0]})),
    extra:prepared.map(v=>resizeBar(v.bar,v.channel,sample,premult,355))});

  const write=row(535,'Write pixels',['rasterPixel32() · rasterGrayscale8()','rasterTranslucentPixel32()'],'Draw · 32-bit color / 8-bit value','Destination','Written span');
  const blank=Array(15).fill('#dedede');
  grid(scene,730,557,5,blank);
  const written=grid(write.result,1090,557,5,blank);
  steps.push({...write,label:'Write a contiguous span into the buffer',motion:[5,6,7,8,9].map(i=>({target:written[i],fill:colors[0]}))});

  const layout=row(715,'Rearrange buffer',['rasterXYFlip()'],'Effects · transpose for the other axis','3 columns × 2 rows','2 columns × 3 rows');
  grid(scene,730,737,3,colors,32);
  const transposed=grid(layout.result,1090,737,3,colors,32);
  steps.push({...layout,label:'Transpose rows and columns while retaining pixel identity',motion:transposed.map((target,i)=>{
    const x=i%3,y=Math.floor(i/3);
    return {target,shift:[((y-.5)-(x-1))*.32,-((x-1)-(y-.5))*.32]};
  })});

  const output=row(895,'Convert output',['rasterUnpremultiply()'],'postRender() · only for straight-alpha targets','Premultiplied','Straight alpha');
  channels(scene,730,895,order,premult);
  const restored=channels(output.result,1090,895,order,premult);
  steps.push({...output,label:'Restore straight RGB for a straight-alpha output target',
    motion:restored.map(v=>resizeBar(v.bar,v.channel,premult,straight,895))});

  text(scene,'Independent examples · each operation runs where needed',640,1008,19,muted);
  // Stable before/after layout; only the result representation changes.
  scene.wait(.6); time+=.6;
  for(const step of steps) {
    scene.play([{target:step.result,opacity:1}],.2); time+=.2;
    scene.play(step.motion,.85,'ease_in_out'); time+=.85;
    if(step.extra) {scene.play(step.extra,.6,'ease_in_out');time+=.6;}
    scene.play([{target:step.caption,opacity:1}],.2);time+=.2;
    beats.push({time:+time.toFixed(3),label:step.label});
    scene.wait(1);time+=1;
  }
  scene.wait(1.5);
  return {scene,beats,textIds,textPolicies,model:{sample,premult,straight}};
}
