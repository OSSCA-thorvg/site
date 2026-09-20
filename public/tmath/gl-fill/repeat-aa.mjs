import {tmath} from '../runtime/client.js';
import {model,gradient,hex,revision,seamStrip} from './model.mjs';
import {localLoops,smooth} from '../shape/chapter-motion.mjs';

// Evidence ledger: 1) wrap creates a discontinuity; 2) the actual selected
// fragment passes/fails the last-interval AA gate; 3) Fill units set screen width.
// Every section persists and replays independently; the poster is complete.
export function buildRepeatAA(capture,_thumbnails,input={}, {still=false}={}) {
 const m=model(input),width=1440,height=1880,duration=8;
 const scene=tmath.scene({width,height,fps:30,loop:true,theme:{preset:'pro_white',background:'#f6f7f8'},camera:{mode:'fixed',view:'2d',height:height/100}});
 const loops=localLoops(scene,{still,duration,prefix:'repeat-aa-loop'});
 const C={ink:'#24292e',muted:'#646d75',line:'#cfd5db',blue:'#2368a8',orange:'#b65622',white:'#ffffff'};
 const textIds=[],textPolicies={},routes=[],regions=[],fixedRegions=[],pixelChecks=[],sampleChecks=[],geometryChecks=[],imageRegions=[],ids=new WeakMap();let serial=0;
 const reviewTimes=[0,.8,1.5,2.4,3.4,4.6,6,7.6,8];
 const beats=[{section:1,label:'Wrap creates the seam',phase:.5},{section:2,label:'Compare the gap with dist, then mix',phase:2},{section:3,label:'Write the resulting screen-space strip',phase:4}];
 const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100],id=k=>`repeat-aa-${k}-${serial++}`,fmt=(n,d=6)=>String(Number(n.toFixed(d)));
 function rect(parent,x,y,w,h,fill=C.white,stroke='#00000000',layer=20,weight=1.5){const key=id('rect'),o=parent.rectangle({id:key,center:p(x+w/2,y+h/2),size:[w/100,h/100],fill,stroke,width:weight,layer});ids.set(o,key);return o;}
 function text(value,x,y,size=22,color=C.ink,owner=null,center=false){const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:ids.get(owner),inset:12}:{standalone:true};scene.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align:[center?.5:0,.5],layer:70});}
 function line(parent,a,b,color=C.line,weight=1,layer=10){parent.line({id:id('line'),from:p(...a),to:p(...b),stroke:color,width:weight,layer});}
 function route(points){const key=id('route');routes.push({id:key,points});scene.route({id:key,points:points.map(q=>p(...q)),stroke:C.muted,width:3.5,tip:10,layer:12});}
 function section(n,y,end,title){line(scene,[455,y],[1400,y]);text(`${String(n).padStart(2,'0')}  ${title}`,475,y+30,24,C.muted);regions.push({name:title,x:480,y:y+65,width:908,height:end-y-80});}
 function scope(y,h,title,lines){const box=rect(scene,25,y,395,h,'#00000000',C.ink,2);text(title,44,y+30,21,C.muted,box);lines.forEach(([s,offset,color,size])=>text(s,44,y+offset,size??22,color??C.ink,box));}
 function image(parent,data,x,y,w,layer=20){
  // Four copies per texel prevent filtering across magnified pixel centers.
  const W=data.width,H=data.height;
  const pixels=Array.from({length:W*H*16},(_,i)=>data.pixels[Math.floor(Math.floor(i/(W*4))/4)*W+Math.floor(i%(W*4)/4)]);
  parent.image({id:id('image'),pixels,size:[W*4,H*4],center:p(x+w/2,y+w*H/W/2),width:w/100,filter:'nearest',layer});
 }
 function strip(data,x,y,w,phase){
  const h=w*data.height/data.width;image(scene,data,x,y,w);imageRegions.push({x,y,width:w,height:h});
  rect(scene,x,y,w,h,'#00000000',C.line,36,1);
  const u=w/data.width;
  data.pixels.slice(0,data.width).forEach((color,i)=>pixelChecks.push({x:x+(i+.5)*u,y:y+.5*u,color}));
  if(still)return;
  rect(scene,x,y,w,h,C.white,'#00000000',22);
  for(let col=0;col<data.width;col++){
   const start=.3+col*5.1/(data.width-1),g=loops.reveal(phase,start);
   const stripe={width:1,height:data.height,pixels:Array.from({length:data.height},(_,row)=>data.pixels[row*data.width+col])};
   image(g,stripe,x+col*u,y,u,24);
   for(const time of reviewTimes){const t=(time+phase)%duration;if(col%8||t<.15||t>7.35||t>start-.15&&t<start+.4)continue;
    sampleChecks.push({time,x:x+(col+.5)*u,y:y+.5*u,color:t<start?'#ffffffff':stripe.pixels[0]});
   }
  }
 }
 function growBar(x,y,w,h,color,start){
  const g=still?scene:loops.track(t=>{const f=loops.amount(t,start,.7),[wx]=p(x,y);return {transform:[Math.max(f,.000001),0,0,wx*(1-f),0,1,0,0,0,0,1,0,0,0,0,1]};},2);
  const o=rect(g,x,y,w,h,color);
  if(!still)geometryChecks.push({id:ids.get(o),time:4,x,y,width:w,height:h});
 }

 text('Gradient Repeat AA / Inside the fragment shader',40,49,34);
 text('Same radial fixture · four opaque stops · same selected fragment · independent local loops',40,97,22,C.muted);
 line(scene,[440,140],[440,1800]);
 section(1,145,630,'WRAP / The last color meets the first');
 section(2,650,1230,'MIX / A distance test decides the fragment color');
 section(3,1250,1800,'WIDTH / Fill-space AA becomes screen-space pixels');

 scope(165,444,'Fragment shader',[
  ['radialGradientColor(vPos)',94,C.blue],['compute_radial_t(...)',146],['gradientWrap(d)',220],['t = mod(d, 1)',264,C.orange],['gradient(t, d, l)',340,C.blue],['Linear uses this helper too',408,C.muted,20]
 ]);
 route([[223,336],[223,361]]);route([[223,451],[223,479]]);
 text('d before wrap',490,248,22,C.muted);
 [0.99,1,1.01].forEach((d,i)=>{const x=770+i*235;text(fmt(d),x,248,27,C.ink,null,true);text(fmt(((d%1)+1)%1),x,327,27,C.blue,null,true);});
 text('t after wrap',490,327,22,C.blue);
 route([[770,270],[770,299]]);route([[1005,270],[1005,299]]);route([[1240,270],[1240,299]]);
 text('Stop interpolation without the Repeat AA mixture',490,396,23);
 const rawWidth=80,rawSpan=6;
 const raw={width:rawWidth,height:4,pixels:Array.from({length:rawWidth*4},(_,i)=>{const delta=((i%rawWidth+.5)/rawWidth-.5)*rawSpan,l=m.radius+delta;return hex(gradient(l/m.radius,l,{colors:m.colors,aa:false}).straight);})};
 strip(raw,510,430,840,.5);
 line(scene,[930,417],[930,491],C.ink,3,40);
 text('t approaches 1',770,524,23,C.orange,null,true);text('t restarts at 0',1130,524,23,C.blue,null,true);
 text('This seam is inside the shape, before multisample resolve.',490,580,23,C.muted);

 const selected=m.cases[2],gap=1-selected.sample.t;
 scope(670,535,'gradient(t, d, l)',[
  ['dist = 2 * d / l',91,C.orange,25],['Repeat && abs(d) > dist',151,undefined,21],['i == count - 2',202,undefined,24],['1 - t < dist',253,C.orange,25],['alpha = (1 - t) / dist',329,undefined,22],['col = alpha * col',383,undefined,23],['+ (1 - alpha) * firstStop',420,undefined,22],['alpha is a color weight',494,C.muted,21]
 ]);
 text(`Selected pixel (${m.sample.join(', ')}) · t = ${selected.sample.t.toFixed(6)}`,490,742,23);
 const cases=[m.cases[0],m.cases[2]],names=[`Fill / Shape × ${m.scale}`,'Reference'];
 const axisMax=.02,axisWidth=280;
 cases.forEach((c,i)=>{
  const x=510+i*460,gated=gap<c.aaMargin,weight=gated?gap/c.aaMargin:1;
  text(names[i],x,797,24);
  text(`R = ${fmt(c.R,3)} · dist = ${fmt(c.aaMargin)}`,x,839,21,C.muted);
  line(scene,[x,901],[x+axisWidth,901],C.line,1);
  growBar(x,881,c.aaMargin/axisMax*axisWidth,20,C.blue,.5);
  growBar(x,920,gap/axisMax*axisWidth,20,C.orange,1.5);
  text('dist',x+300,891,20,C.blue);text('1 − t',x+300,930,20,C.orange);
  text(gated?'Inside AA interval':'Outside AA interval',x,977,24,gated?C.blue:C.muted);
  text(`1 − t = ${fmt(gap)}`,x,1017,21,C.orange);
  rect(scene,x,1050,140*weight,28,hex(c.raw.straight));
  if(weight<1)rect(scene,x+140*weight,1050,140*(1-weight),28,hex(m.colors[0].rgba));
  text(gated?`alpha = ${fmt(weight,3)}`:'AA branch skipped',x,1110,21);
  route([[x+160,1064],[x+211,1064]]);
  rect(scene,x+236,1046,62,44,hex(c.sample.straight));
  if(!still){const g=loops.track(t=>({opacity:1-smooth((t-3)/1.2)*(1-smooth((t-6.8)/1.2))}),2);rect(g,x+236,1046,62,44,hex(c.raw.straight),'#00000000',25);}
  pixelChecks.push({x:x+267,y:1068,color:hex(c.sample.straight)});
  text(gated?'Mix toward first stop':'Keep interpolated color',x,1157,21,C.muted);
  // The displayed result is checked against a real native GL sample as well.
  const actual=capture.cases[i?2:0].sample;
  if(c.sample.premultiplied.some((v,k)=>Math.abs(Math.round(v)-actual[k])>2))throw Error('Selected native fragment differs');
 });
 text('All stops are opaque: output alpha stays 1 in both cases.',490,1207,22,C.muted);

 scope(1270,510,'Concentric radial',[
  ['focal radius = 0',65,C.muted,20],['d = l / R',112,undefined,25],['dist = 2 / R',163,C.orange,26],['screen width',237,undefined,25],['= dist × screen radius',281,undefined,22],['= 2 × effective scale',331,C.blue,22],['Same screen radius',424,C.muted,21],['R sets the AA width',464,C.muted,21]
 ]);
 text('Shader colors on a radial line · screen distance from wrap',490,1342,22);
 cases.forEach((c,i)=>{
  const y=1462+i*193,span=6,W=840,x=510,mid=x+W/2,margin=c.screenMargin/span*W;
  text(`${names[i]} · ${fmt(c.screenMargin,4)} px before wrap`,x,y-42,23,i?C.blue:C.ink);
  const data=seamStrip(c,{width:120,height:5,span,colors:m.colors});strip(data,x,y,W,4);
  line(scene,[mid,y-8],[mid,y+43],C.ink,3,40);
  line(scene,[mid-margin,y+58],[mid,y+58],C.orange,5,35);
  for(const xx of [mid-margin,mid])line(scene,[xx,y+50],[xx,y+65],C.orange,2.5,36);
  [-3,0,3].forEach(n=>text(`${n} px`,mid+n/span*W,y+94,20,C.muted,null,true));
 });
 text(`ThorVG ${revision.slice(0,8)} · shader-model colors · native fragment checked · first-interval branch differs (see code below)`,40,1840,19,C.muted);
 loops.finish();
 return {scene,m,width,height,duration,textIds,textPolicies,routes,regions,fixedRegions,pixelChecks,sampleChecks,geometryChecks,imageRegions,beats,reviewTimes};
}
