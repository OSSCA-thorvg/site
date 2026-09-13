import {tmath} from '../runtime/client.js';
import {example,focus,channels,byteChannels,color,hex} from './model.mjs';

// Two questions: which samples make one output pixel; how are their channels
// accumulated together? Timing illustrates data dependencies, not CPU cycles.
const ink='#202020',muted='#737373',orange='#e66121',blue='#1f66c4';
function stage(height,title,subtitle){
 const width=1280,scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
  theme:{preset:'pro_white',background:'#f7f7f7',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
 let serial=0,time=0;const textIds=[],textPolicies={},beats=[];
 const id=()=>`simd-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
 const group=(opacity=0)=>scene.group({id:id(),opacity});
 const box=(parent,x,y,w,h,fill='#ffffff',stroke='#bcbcbc')=>{const key=id();return {id:key,handle:parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.3,layer:15})};};
 const text=(parent,value,x,y,size=22,fill=ink,owner)=>{
  const key=id();textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
  return parent.text({id:key,text:String(value),point:p(x,y),font:'Pretendard',size,fill,align:[.5,.5],layer:40});
 };
 const line=(parent,x1,y1,x2,y2,stroke='#cccccc')=>parent.line({id:id(),from:p(x1,y1),to:p(x2,y2),stroke,width:1,layer:5});
 const arrow=(parent,x1,y1,x2,y2)=>parent.route({id:id(),points:[p(x1,y1),p(x2,y2)],stroke:ink,width:1.5,tip:8,dash:[5,4],layer:8});
 const play=(spec,d=.35)=>{scene.play(spec,d,'ease_in_out');time+=d;};
 const show=(g,d=.35)=>play([{target:g,opacity:1}],d);
 const hide=(g,d=.2)=>play([{target:g,opacity:0}],d);
 const wait=d=>{scene.wait(d);time+=d;};
 const beat=label=>{beats.push({time:+time.toFixed(3),label});wait(1);};
 text(scene,title,640,48,30);if(subtitle)text(scene,subtitle,640,100,20,muted);line(scene,40,132,1240,132);
 return {scene,p,group,box,text,line,arrow,play,show,hide,wait,beat,finish:()=>({scene,textIds,textPolicies,beats,duration:time})};
}
export function buildDownscale(){
 const s=stage(920,'DownScale',`${example.image.w} × ${example.image.h} → ${example.w} × ${example.h}`);
 const {scene,p,group,box,text,line,arrow,play,show,hide,wait,beat}=s;
 const gx=80,gy=208,cell=6,ox=892,oy=280,outCell=18;
 const inputPixels=example.image.pixels.map(color),outputPixels=example.outputs.map(o=>color(o.pixel));
 const input=group(1);
 input.image({id:'downscale-source',center:p(gx+example.image.w*cell/2,gy+example.image.h*cell/2),width:example.image.w*cell/100,size:[example.image.w,example.image.h],pixels:inputPixels,filter:'nearest',layer:15});
 box(scene,296,352,432,288,'#00000000',ink);
 text(scene,'SOURCE',296,175,18,muted);text(scene,'OUTPUT',1000,240,18,muted);
 box(scene,1000,352,216,144,'#ffffff','#bbbbbb');
 const output=group();
 output.image({id:'downscale-output',center:p(1000,352),width:2.16,size:[example.w,example.h],pixels:outputPixels,filter:'nearest',layer:15});
 const preview=group();
 preview.image({id:'downscale-whole-image-proxy',center:p(296,352),width:4.32,size:[example.image.w,example.image.h],pixels:inputPixels,filter:'nearest',layer:20});
 arrow(scene,575,352,817,352);text(scene,'DownScale',695,311,21);
 line(scene,60,538,1220,538);
 const selected=group();
 box(selected,gx+(focus.minx+focus.maxx)*cell/2,gy+(focus.miny+focus.maxy)*cell/2,(focus.maxx-focus.minx)*cell,(focus.maxy-focus.miny)*cell,'#00000000',ink);
 box(selected,ox+(focus.x+.5)*outCell,oy+(focus.y+.5)*outCell,outCell,outCell,'#00000000',orange);
 const packets=focus.samples.map((tap,i)=>{
  const x=gx+(tap.x+.5)*cell,y=gy+(tap.y+.5)*cell,g=group();
  box(selected,x,y,5,5,'#ffffff',ink);
  box(g,x,y,6,6,color(tap.pixel),orange);
  return {g,from:p(x,y),to:p(210+(i%3)*62,616+Math.floor(i/3)*62)};
 });
 const sampleLabel=group(),toCalculation=group(),calculation=group(),toResult=group();
 text(sampleLabel,'9 samples',272,840,22,muted);
 arrow(toCalculation,399,678,543,678);
 text(calculation,'Sum / 9',653,678,34);
 arrow(toResult,765,678,875,678);
 const result=group();box(result,969,678,112,112,color(focus.pixel),ink);
 text(result,hex(focus.pixel),969,793,24,blue);
 const resultCopy=group();box(resultCopy,969,678,112,112,color(focus.pixel),ink);
 const transform=(from,to,scale)=>[scale,0,0,to[0]-scale*from[0],0,scale,0,to[1]-scale*from[1],0,0,1,0,0,0,0,1];
 beat('The complete source image establishes the frame and its landmarks.');
 show(preview,.2);
 play([{target:preview,transform:transform(p(296,352),p(1000,352),.5)}],1.1);
 hide(preview,.1);show(output,.15);
 beat('The whole frame is reduced; the output keeps the house, sun and ground.');
 show(selected,.35);
 play(packets.map(v=>({target:v.g,opacity:1})),.15);
 beat('All nine sample positions for one interior output pixel are selected together.');
 play(packets.map(v=>({target:v.g,transform:transform(v.from,v.to,8)})),1.15);
 show(sampleLabel,.2);
 beat('The nine source samples move together into one sampling group.');
 show(toCalculation,.35);show(calculation,.4);
 beat('Only after extraction, the sample group feeds Sum / 9.');
 show(toResult,.35);show(result,.5);
 beat('One channel-wise sum divided by nine produces the output pixel.');
 show(resultCopy,.1);
 play([{target:resultCopy,transform:transform(p(969,678),p(ox+(focus.x+.5)*outCell,oy+(focus.y+.5)*outCell),outCell/112)}],.85);
 hide(resultCopy,.1);wait(1.5);
 return s.finish();
}

export function buildNeon(){
 // Persistent comparison: same sample → scalar c[] writes / vector sum write
 // → nine accumulated samples → NEON extraction to c[] → equal mean and pack.
 const s=stage(1100,'DownScale · Before | After','');
 const {scene,group,box,text,line,arrow,play,show,wait,beat}=s;
 text(scene,'BEFORE · Scalar',320,181,25);
 text(scene,'AFTER · NEON',950,181,25);
 line(scene,640,160,640,1070);
 // The portable runtime requires positive durations; this is below one frame.
 const snap=spec=>play(spec,0.000001);
 const lx=[710,780,850,920,990,1060,1130,1200];
 const scalarSlots=[],laneSlots=[];
 text(scene,'size_t c[4]',475,329,22,orange);
 channels.forEach((c,i)=>{
  const y=405+i*86;
  text(scene,`${c}(*p)`,112,y,21);
  text(scene,'+',339,y,23,muted);
  const b=box(scene,475,y,172,58);
  text(scene,`c[${i}]`,590,y,17,orange);
  scalarSlots.push(b);
 });
 text(scene,'vdup_n_u32 → vreinterpret_u8_u32',950,329,19,muted);
 lx.forEach((x,i)=>{
  text(scene,byteChannels[i],x,374,15,muted);
  box(scene,x,413,70,56);
  arrow(scene,x,455,x,515);
  laneSlots.push(box(scene,x,559,70,64));
 });
 text(scene,'uint16x8_t sum',950,623,22,blue);
 text(scene,'vaddw_u8 · 8 → 16 bits',950,671,20,muted);
 const low=group();box(low,815,559,280,88,'#00000000',blue);
 text(low,'low 4 lanes',815,730,18,blue);
 text(low,'duplicate half',1095,730,18,muted);
 line(scene,64,767,1216,767);
 let oldInput,scalar=scalarSlots.map((b)=>{
  const g=group(1);text(g,0,475,405+scalarSlots.indexOf(b)*86,22,orange,b);return g;
 });
 let vector=group(1);lx.forEach((x,i)=>text(vector,0,x,559,15,blue,laneSlots[i]));
 for(const [index,tap] of focus.samples.entries()){
  const input=group(index===0?1:0);
  for(const x of [320,950])text(input,hex(tap.pixel),x,251,25);
  text(input,`${index+1} / ${focus.samples.length}`,640,100,20,muted);
  // Both views share the same sample counter and trace record.
  tap.values.forEach((v,i)=>text(input,v,248,405+i*86,22));
  tap.bytes.forEach((v,i)=>text(input,v,lx[i],413,16));
  if(index===0)beat('The same packed sample feeds scalar c[4] and vector sum.');
  const nextScalar=scalarSlots.map((b,i)=>{const g=group();text(g,tap.sum[i],475,405+i*86,22,orange,b);return g;});
  const nextVector=group();tap.lanes.forEach((v,i)=>text(nextVector,v,lx[i],559,15,i<4?blue:muted,laneSlots[i]));
  // One discrete frame change: inputs and both accumulator views stay in sync.
  const previous=[...scalar,vector,...(oldInput?[oldInput]:[])];
  const next=[...nextScalar,nextVector,...(oldInput?[input]:[])];
  snap([...previous.map(target=>({target,opacity:0})),...next.map(target=>({target,opacity:1}))]);
  scalar=nextScalar;vector=nextVector;oldInput=input;
  wait(.22);
 }
 show(low,.3);beat('After nine samples, c[] and the useful sum lanes contain equal channel totals.');
 const restore=group();
 text(restore,'c[4]',320,800,21,orange);
 text(restore,'sum → low → reverse → widen → c[4]',950,800,19,blue);
 for(const center of [320,950]){
  channels.forEach((c,i)=>{
   const x=center-174+i*116;
   text(restore,c,x,840,15,muted);
   const b=box(restore,x,879,106,54);
   text(restore,focus.sum[i],x,879,21,center===320?orange:blue,b);
  });
 }
 show(restore,.6);beat('NEON restores A, C1, C2, C3 order into uint32_t c[4].');
 const average=group(),final=group();
 for(const center of [320,950]){
  text(average,`c[i] / ${focus.samples.length}`,center,938,21,muted);
  focus.means.forEach((v,i)=>text(average,v,center-174+i*116,979,21));
  box(final,center-130,1040,40,40,color(focus.pixel),ink);
  text(final,hex(focus.pixel),center+25,1040,23,blue);
 }
 show(average,.45);beat('Both paths divide each channel total by the same sample count.');
 show(final,.45);beat('Both c[] arrays produce the same integer mean and packed output.');wait(.8);
 return s.finish();
}
