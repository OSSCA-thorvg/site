import {tmath} from '../runtime/client.js';
import {native,model,equations,combineMethods,weightColor,hex} from './model.mjs';

export function buildOverview(trace=native,{still=false}={}){
 const m=model(trace),{w,h}=m,width=1440,height=3160;
 const ink='#24292e',muted='#646d75',bg='#f6f7f8';
 const scene=tmath.scene({width,height,fps:30,loop:true,camera:{mode:'fixed',view:'2d',height:height/100},theme:{preset:'pro_white',background:bg}});
 const textIds=[],textPolicies={},routes=[],imageRegions=[],pixelProbes=[],sampleChecks=[],spanChecks=[],geometryChecks=[],regions=[],fixedRegions=[],tracks=[],beats=[];
 const reviewTimes=[0,.8,1.5,2.4,3.4,4.6,6,7.6];let serial=0;
 const id=n=>`mask-methods-${n}-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
 const phases=[.3,1.1,2.2,3.4,4.8,6.2].map(t=>Math.round(t*12)/12);
 const clamp=x=>Math.max(0,Math.min(1,x)),smooth=x=>{x=clamp(x);return x*x*(3-2*x);};
 function text(value,x,y,size=22,color=ink,parent=scene,owner=null,align=[.5,.5]){
  const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
  return parent.text({id:key,text:value,point:p(x,y),size,font:'Pretendard',role:'text',align,fill:color,layer:50});
 }
 function rect(parent,x,y,ww,hh,fill,stroke='#00000000',layer=5,border=1.5){const key=id('rect');parent.rectangle({id:key,center:p(x,y),size:[ww/100,hh/100],fill,stroke,width:border,layer});return {id:key};}
 function line(x1,y1,x2,y2){scene.line({id:id('line'),from:p(x1,y1),to:p(x2,y2),stroke:'#cfd4d9',width:1,layer:5});}
 function route(points){const key=id('route');routes.push({id:key,points});scene.route({id:key,points:points.map(q=>p(...q)),stroke:muted,width:3.5,tip:10,layer:8});}
 function box(y,labels,{x=225,ww=356,dark=false}={}){
  const hh=labels.length*34+28,r=rect(scene,x,y,ww,hh,dark?ink:'#ffffff',ink);
  labels.forEach((v,i)=>text(v,x,y+(i-(labels.length-1)/2)*34,i?19:22,dark?'#ffffff':ink,scene,r));return {y,hh};
 }
 function scope(y,hh,title){const r=rect(scene,225,y+hh/2,400,hh,'#00000000',ink);text(title,225,y+32,23,ink,scene,r);}
 function section(n,y,end,title){line(455,y,1400,y);text(`${String(n).padStart(2,'0')}  ${title}`,475,y+29,24,muted,scene,null,[0,.5]);regions.push({name:title,x:470,y:y+64,width:925,height:end-y-77});beats.push({section:n,label:title,phase:phases[n-1]});}
 function animated(phase,state){const sample=t=>state((t+phase)%8),s=sample(0),g=scene.group({id:id('motion'),opacity:s.opacity});tracks.push({target:g,state:sample});return g;}
 // A field is one Image, not hundreds of scene objects. Replicated texels
 // keep magnified native cells stable at interior sample points.
 function pixels(parent,values,x,y,u,columns=w,rows=h,layer=20){
  const scale=4,texels=Array.from({length:columns*rows*scale*scale},(_,i)=>values[Math.floor(Math.floor(i/(columns*scale))/scale)*columns+Math.floor(i%(columns*scale)/scale)]);
  parent.image({id:id('pixels'),pixels:texels,size:[columns*scale,rows*scale],center:p(x+columns*u/2,y+rows*u/2),width:columns*u/100,filter:'nearest',layer});
 }
 function grid(values,x,y,u,label,{fixed=false,probe=true}={}){
  text(label,x+w*u/2,y-29,22);imageRegions.push({x,y,width:w*u,height:h*u});
  pixels(scene,values,x,y,u);rect(scene,x+w*u/2,y+h*u/2,w*u,h*u,'#00000000','#d5dde3',35,1);
  if(fixed)fixedRegions.push({x,y,width:w*u,height:h*u});
  if(probe)probes(values,x,y,u);
  return {values,x,y,u};
 }
 function probes(values,x,y,u){values.forEach((color,i)=>{for(const [a,b] of [[.5,.5],[.25,.25],[.75,.75]])pixelProbes.push({x:x+(i%w+a)*u,y:y+(Math.floor(i/w)+b)*u,color});});}
 function write(g,initial,phase){
  phase=Math.round(phase*12)/12;
  if(still)return;
  pixels(scene,initial,g.x,g.y,g.u,w,h,22);
  for(let row=0;row<h;row++){
   const a=animated(phase,t=>({opacity:smooth((t-.6-row*4.8/(h-1))/.18)}));
   pixels(a,g.values.slice(row*w,(row+1)*w),g.x,g.y+row*g.u,g.u,w,1,24);
  }
  for(const time of reviewTimes){const local=(time+phase)%8;
   // The sampled timeline interpolates the reset over its last frame.
   // Probe native values outside that reset transition and row fades.
   if(local<.15||local>7.85)continue;
   for(const row of [2,5,8]){const start=.6+row*4.8/(h-1);if(local>start-.15&&local<start+.35)continue;
    for(const col of [4,8,12]){const i=row*w+col;sampleChecks.push({time,x:g.x+(col+.5)*g.u,y:g.y+(row+.5)*g.u,color:local<start?initial[i]:g.values[i]});}
   }
  }
 }
 function method(name,x,y,phase){
  const d=m.all[name],combination=combineMethods.includes(name),u=12;
  text(name,x+216,y+90,27);
  text(equations[name],x+216,y+135,23,muted);
  const field=grid(d.weightColors,x,y+215,u,combination?'A alpha → q':'B → weight q');
  grid(d.colors,x+240,y+215,u,'Result',{fixed:true});
  route([[x+204,y+287],[x+228,y+287]]);
  write(field,combination?m.a.map(weightColor):m.inputs.inputB,phase);
  const value=d.q[m.sample],trackX=x+56,trackY=y+394,trackW=320;
  rect(scene,trackX+trackW/2,trackY,trackW,7,'#dce2e7');
  rect(scene,trackX+trackW*value/255/2,trackY,trackW*value/255,7,'#526579');
  text(`sample q = ${value} / 255`,x+216,y+430,21,muted);
 }
 text('MaskMethod / Same inputs, different weights',40,50,36,ink,scene,null,[0,.5]);
 text('Read alpha or luminance · combine mask alpha · apply the resulting weight to content',40,100,23,muted,scene,null,[0,.5]);
 line(440,145,440,3060);
 section(1,155,650,'INPUT / One avatar, two partially opaque masks');
 section(2,650,1130,'ALPHA / Read target alpha or its complement');
 section(3,1130,1610,'LUMA / Read target luminance or its complement');
 section(4,1610,2090,'ADD / SUBTRACT / Expand a mask or cut it back');
 section(5,2090,2570,'INTERSECT / DIFFERENCE / Shared or exclusive opacity');
 section(6,2570,3060,'LIGHTEN / DARKEN / Choose the larger or smaller alpha');

 scope(155,460,'Inputs / retained Paints');
 box(286,['content · Scene','photo Picture + badge Shape']);
 box(462,['MaskMethod::None','original content remains']);
 grid(m.inputs.None,482,290,16,'content / None',{fixed:true});
 const a=grid(m.inputs.inputA,800,290,16,'A / rounded rectangle');
 const b=grid(m.inputs.inputB,1118,290,16,'B / gradient circle');
 const blank=Array(w*h).fill(null).map((_,i)=>hex(Array(3).fill((i%w+Math.floor(i/w))%2?244:231)));
 write(a,blank,phases[0]);write(b,blank,phases[0]+.7);
 text('Same photo + badge',610,519,21,muted);
 text(`fill alpha = ${trace.alphaA}`,928,519,21,muted);
 text(`alpha = ${trace.alphaB} · RGB varies`,1246,519,21,muted);
 text(`Sample (${m.point.join(', ')}): a = ${m.sampleA}, b = ${m.sampleB} · darker q = more content`,930,571,22);
 text('Formulas use 0–1 weights · sample values use CPU bytes (0–255)',930,612,20,muted);

 scope(650,450,'Matting / alpha');
 box(782,['content->mask(B,','method)']);
 box(936,['B → Grayscale8','q reads its alpha byte'],{dark:true});
 route([[225,838],[225,884]]);
 method('Alpha',482,650,phases[1]);method('InvAlpha',947,650,phases[1]+.7);

 scope(1130,450,'Matting / luminance');
 box(1258,['content->mask(B,','method)']);
 box(1390,['B → ABGR8888','Y reads premultiplied RGB'],{dark:true});
 route([[225,1315],[225,1338]]);
 text('Y = (54R + 182G + 19B) >> 8',225,1505,21);
 text(`sample Y = ${m.sampleY}`,225,1549,21,muted);
 method('Luma',482,1130,phases[2]);method('InvLuma',947,1130,phases[2]+.7);

 scope(1610,1430,'Mask combination');
 box(1735,['A->mask(B, method)']);
 box(1880,['content->mask(A, Alpha)']);
 route([[225,1780],[225,1835]]);
 text('Render B before A',225,1995,22,muted);
 box(2170,['_rasterMaskedRle()','_getMaskOp(method)'],{dark:true});
 box(2335,['q = maskOp(a, b, 255-a)','a: A alpha · b: B alpha']);
 route([[225,2221],[225,2283]]);
 text('Add / Difference / Lighten',225,2450,21);
 text('combine into B, then copy',225,2487,20,muted);
 box(2675,['Direct mask path','Subtract / Intersect / Darken'],{dark:true});
 box(2835,['Grayscale8 result q']);
 box(2970,['Apply q to content','outer Alpha mask']);
 route([[225,2726],[225,2790]]);route([[225,2880],[225,2910]]);
 method('Add',482,1610,phases[3]);method('Subtract',947,1610,phases[3]+.7);
 method('Intersect',482,2090,phases[4]);method('Difference',947,2090,phases[4]+.7);
 method('Lighten',482,2570,phases[5]);method('Darken',947,2570,phases[5]+.7);
 text('q scales premultiplied content RGBA · only Luma methods read target RGB',720,3093,21,muted);
 text('ThorVG CPU / 4d5810cf · native pixels · row replacement illustrates computation · final results stay fixed',720,3130,19,muted);

 if(still)scene.wait(8);else{
  const previous=tracks.map(({state})=>state(0));
  for(let k=1;k<=96;k++){
   const changes=[];tracks.forEach(({target,state},i)=>{const next=state(k/12);if(next.opacity!==previous[i].opacity)changes.push({target,opacity:next.opacity});previous[i]=next;});
   if(changes.length)scene.play(changes,1/12,'linear');else scene.wait(1/12);
  }
 }
 return {scene,model:m,beats,reviewTimes,textIds,textPolicies,routes,pixelProbes,sampleChecks,spanChecks,geometryChecks,regions,imageRegions,fixedRegions};
}
