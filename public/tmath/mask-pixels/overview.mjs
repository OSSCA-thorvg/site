import {tmath} from '../runtime/client.js';
import {native,model,rgba,hex,gray,display,commit} from './model.mjs';

// The avatar's Scene is already flattened when the outer mask is sampled.
export function buildOverview(trace=native,{still=false}={}){
 const m=model(trace),{w,h,a,point,q,src,tmp,dst,rest,result}=m,width=1440,height=2630;
 const ink='#24292e',muted='#646d75',blue='#2078dc',green='#279a75',bg='#f6f7f8';
 const scene=tmath.scene({width,height,fps:30,loop:true,camera:{mode:'fixed',view:'2d',height:height/100},theme:{preset:'pro_white',background:bg}});
 const textIds=[],textPolicies={},routes=[],pixelProbes=[],sampleChecks=[],spanChecks=[],geometryChecks=[],regions=[],imageRegions=[],fixedRegions=[],tracks=[],beats=[];
 const reviewTimes=[0,.8,1.5,2.4,3.4,4.6,6,7.6],phases=[.5,2,3.5,5,6.5];let serial=0;
 const id=n=>`mask-pixels-${n}-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
 const clamp=x=>Math.max(0,Math.min(1,x)),smooth=x=>{x=clamp(x);return x*x*(3-2*x);};
 function text(value,x,y,size=22,color=ink,parent=scene,owner=null,align=[.5,.5]){
  const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
  return parent.text({id:key,text:value,point:p(x,y),size,font:'Pretendard',role:'text',align,fill:color,layer:60});
 }
 function rect(parent,x,y,ww,hh,fill,stroke='#00000000',layer=5,border=1.5,key=id('rect')){return {id:key,handle:parent.rectangle({id:key,center:p(x+ww/2,y+hh/2),size:[ww/100,hh/100],fill,stroke,width:border,layer})};}
 function line(parent,a,b,color='#cfd4d9',weight=1,layer=5,key=id('line')){return parent.line({id:key,from:p(...a),to:p(...b),stroke:color,width:weight,layer});}
 function route(points){const key=id('route');routes.push({id:key,points});scene.route({id:key,points:points.map(q=>p(...q)),stroke:muted,width:3.5,tip:10,layer:8});}
 function box(y,labels,{x=225,ww=348,dark=false}={}){
  const hh=labels.length*33+26,r=rect(scene,x-ww/2,y-hh/2,ww,hh,dark?ink:'#ffffff',ink);
  labels.forEach((v,i)=>text(v,x,y+(i-(labels.length-1)/2)*33,i?18:21,dark?'#ffffff':ink,scene,r));
 }
 function scope(y,hh,title){const r=rect(scene,25,y,400,hh,'#00000000',ink);text(title,225,y+29,23,ink,scene,r);}
 function section(n,y,end,title){line(scene,[455,y],[1400,y]);text(`${String(n).padStart(2,'0')}  ${title}`,475,y+29,24,muted,scene,null,[0,.5]);regions.push({name:title,x:470,y:y+64,width:925,height:end-y-77});beats.push({section:n,label:title,phase:phases[n-1]});}
 function animated(phase,state){const sample=t=>state((t+phase)%8),s=sample(0),g=scene.group({id:id('motion'),opacity:s.opacity??1,...(s.transform?{matrix:s.transform}:{})});tracks.push({target:g,state:sample});return g;}
 const reveal=(phase,start)=>still?scene:animated(phase,t=>({opacity:smooth((t-start)/.2)}));
 function pixels(parent,values,x,y,u,columns=w,rows=h,layer=20){
  const texels=Array.from({length:columns*rows*16},(_,i)=>values[Math.floor(Math.floor(i/(columns*4))/4)*columns+Math.floor(i%(columns*4)/4)]);
  parent.image({id:id('pixels'),pixels:texels,size:[columns*4,rows*4],center:p(x+columns*u/2,y+rows*u/2),width:columns*u/100,filter:'nearest',layer});
 }
 function field(values,x,y,u,label,{fixed=false,columns=w,rows=h,mark=false}={}){
  if(label)text(label,x+columns*u/2,y-29,22);pixels(scene,values,x,y,u,columns,rows);
  imageRegions.push({x,y,width:columns*u,height:rows*u});rect(scene,x,y,columns*u,rows*u,'#00000000','#cbd2d9',35,1);
  if(fixed)fixedRegions.push({x,y,width:columns*u,height:rows*u});
  values.forEach((color,i)=>{for(const [a,b] of [[.5,.5],[.25,.25],[.75,.75]])pixelProbes.push({x:x+(i%columns+a)*u,y:y+(Math.floor(i/columns)+b)*u,color});});
  if(mark)rect(scene,x+point[0]*u,y+point[1]*u,u,u,'#00000000',ink,40,2.5);
 }
 function writer(values,x,y,u,phase,initial=Array(w*h).fill('#ffffff')){
  if(still)return;pixels(scene,initial,x,y,u,w,h,22);
  for(let row=0;row<h;row++)pixels(reveal(phase,.4+row*5.6/(h-1)),values.slice(row*w,(row+1)*w),x,y+row*u,u,w,1,24);
  for(const time of reviewTimes){const local=(time+phase)%8;if(local<.15||local>7.85)continue;
   for(const row of [2,6,9]){const start=.4+row*5.6/(h-1);if(local>start-.15&&local<start+.35)continue;
    for(const col of [3,8,12])sampleChecks.push({time,x:x+(col+.5)*u,y:y+(row+.5)*u,color:local<start?initial[row*w+col]:values[row*w+col]});
   }
  }
 }
 function rle(spans,x,y,u,label){
  text(label,x+w*u/2,y-29,22);rect(scene,x,y,w*u,h*u,'#ffffff','#cbd2d9');
  for(let xx=1;xx<w;xx++)line(scene,[x+xx*u,y],[x+xx*u,y+h*u],'#e0e5e9');
  for(let yy=1;yy<h;yy++)line(scene,[x,y+yy*u],[x+w*u,y+yy*u],'#e0e5e9');
  for(const [sx,sy,len,c] of spans){const key=id('span'),bx=x+(sx+.5)*u,by=y+(sy+.5)*u,ex=x+(sx+len-.5)*u;
   rect(scene,x+sx*u+1,y+sy*u+1,u-2,u-2,gray(c),'#00000000',20);
   if(len>1){line(scene,[bx,by],[ex,by],blue,3.5,32,key+'-len');line(scene,[ex,by-3],[ex,by+3],blue,2.5,33,key+'-end');}
   spanChecks.push({key,len,bx,by,ex,strokeWidth:3.5});
  }
  rect(scene,x+point[0]*u,y+point[1]*u,u,u,'#00000000',ink,40,2.5);
 }
 text('Mask / Inside one avatar pixel',40,50,36,ink,scene,null,[0,.5]);
 text(`Same Scene, photo, badge and Alpha mask · Canvas pixel (${point.join(', ')}) throughout`,40,101,23,muted,scene,null,[0,.5]);
 line(scene,[440,145],[440,2540]);
 section(1,155,625,'MASK BYTE / Target coverage becomes weight q');
 section(2,625,1090,'GROUP PIXEL / Badge coverage is applied here');
 section(3,1090,1595,'MATTE / Attenuate premultiplied RGBA together');
 section(4,1595,2075,'SOURCE-OVER / Use alpha after the mask');
 section(5,2075,2540,'DISPATCH / The Scene is now a direct image');

 scope(170,390,'fadeMask->render()');
 box(284,['SwShapeTask::shape.rle','prepared geometric coverage']);
 box(448,['Grayscale8 mask Surface','coverage × fill alpha'],{dark:true});route([[225,330],[225,402]]);
 scope(650,380,'SceneImpl::render()');
 box(765,['photo → badge','renderImage()','renderShape()']);
 box(925,['Group Color Surface','coverage already applied'],{dark:true});route([[225,828],[225,879]]);
 scope(1120,425,'endComposite(group)');
 box(1240,['rasterDirectImage()','active compositor: Alpha']);
 box(1395,['_rasterDirectMattedImage','tmp = ALPHA_BLEND(src, q)'],{ww:378,dark:true});route([[225,1286],[225,1349]]);
 text('q = alpha(cmp)',225,1500,21);
 scope(1620,385,'Write destination');
 box(1738,['Remaining D weight','IA(tmp) = 255 − tmp.alpha']);
 box(1900,['Source-over','tmp + attenuated destination'],{dark:true});route([[225,1784],[225,1854]]);
 scope(2100,405,'Raster alternatives');
 box(2220,['Source representation','selects the matted kernel']);
 box(2375,['endComposite(mask)','restore Surface + compositor']);
 text('The mask is applied once',225,2465,21,muted);

 // 01: separate mask geometry and stored byte, with exactly the same sample.
 rle(a.maskSpans,505,280,18,'fadeMask / SwRle');
 field(m.maskColors,995,280,18,'Mask / Grayscale8',{mark:true});writer(m.maskColors,995,280,18,phases[0]);
 route([[820,390],[964,390]]);
 text(`coverage ${m.maskCoverage} × fill alpha ${a.alpha}`,905,529,24);
 text(`q = (${m.maskCoverage} × ${a.alpha} + 255) >> 8 = ${q}`,905,579,24,blue);

 // 02: source geometry is consumed before the group is masked.
 const photoColors=a.sourcePixels.map(p=>hex(rgba(p)));
 field(photoColors,492,748,13,'Photo pixel');rle(a.badgeSpans,818,748,13,'Badge / coverage');
 field(m.groupColors,1140,748,13,'Group pixel S',{mark:true});writer(m.groupColors,1140,748,13,phases[1],photoColors);
 route([[719,826],[794,826]]);route([[1040,826],[1118,826]]);
 text(`badge coverage = ${m.badgeCoverage}`,635,961,22);
 text(`covered badge = ${m.badgeCovered.join(' / ')}`,1060,961,22,green);
 text(`photo ${m.photo.join(' / ')}   →   group S ${src.join(' / ')}`,935,1012,22);
 text('Mask sampling reads this finished group pixel',935,1060,21,muted);

 // 03: bars continuously contract to the exact native premultiplied bytes.
 text('Group S / stored RGBA',714,1190,23);text(`After mask q = ${q} / final bytes`,1165,1190,23);
 const barX=985,barW=280,colors=['#ca6767','#559f72','#548bc4','#646d75'];
 for(let c=0;c<4;c++){
  const y=1240+c*66;
  text(['R','G','B','A'][c],505,y+12,22);
  rect(scene,545,y,barW,24,'#e1e5e8');rect(scene,545,y,barW*src[c]/255,24,colors[c],'#00000000',20);
  text(String(src[c]),865,y+12,22);
  rect(scene,barX,y,barW,24,'#e1e5e8');rect(scene,barX,y,barW*tmp[c]/255,24,'#00000000',ink,35,1);
  const ratio=t=>1-(1-tmp[c]/src[c])*smooth((t-.5)/3.3)*(1-smooth((t-6.4)/1.6));
  const state=t=>{const scale=ratio(t),x=p(barX,0)[0];return {transform:[scale,0,0,x*(1-scale),0,1,0,0,0,0,1,0,0,0,0,1]};};
  const g=still?scene:animated(phases[2],state);
  const handle=rect(g,barX,y,barW*(still?tmp[c]:src[c])/255,24,colors[c],'#00000000',20);
  if(!still)for(const time of reviewTimes){const ww=barW*src[c]/255*ratio((time+phases[2])%8);geometryChecks.push({time,id:handle.id,x:barX,y,width:ww,height:24});}
  text(String(tmp[c]),1320,y+12,22,green);
 }
 text(`tmp[channel] = (S[channel] × (${q} + 1)) >> 8`,935,1537,24);

 // 04: preserve the existing transparent output; change only D for a control.
 const bgColors=Array(w*h).fill(hex(dst));
 field(m.backgroundColors,492,1722,13,'Writing over D');writer(m.backgroundColors,492,1722,13,phases[3],bgColors);
 field(m.outColors,818,1722,13,'Transparent D',{fixed:true});
 field(m.backgroundColors,1140,1722,13,'Opaque D',{fixed:true});
 text(`Control D = ${dst.join(' / ')}   RGBA`,935,1909,21,muted);
 text(`IA(tmp) = 255 − ${tmp[3]} = ${255-tmp[3]}`,935,1950,24,blue);
 text(`T ${tmp.join(' / ')}  +  D contribution ${rest.join(' / ')}`,935,1993,23);
 text(`= ${result.join(' / ')}   RGBA`,935,2036,24);

 // 05: a row samples src and q at the same Canvas positions; alternatives stay separate.
 const row=point[1],at=row*w,rowSrc=m.groupColors.slice(at,at+w),rowQ=m.maskColors.slice(at,at+w),rowOut=m.outColors.slice(at,at+w);
 field(rowSrc,492,2198,15,`S row y = ${row}`,{columns:w,rows:1});
 field(rowQ,818,2198,15,'q at the same (x, y)',{columns:w,rows:1});
 field(rowOut,1140,2198,15,'ALPHA_BLEND(S, q)',{columns:w,rows:1});
 if(!still){pixels(scene,Array(w).fill('#ffffff'),1140,2198,15,w,1,22);
  for(let x=0;x<w;x++)pixels(reveal(phases[4],.4+x/(w-1)*5.6),[rowOut[x]],1140+x*15,2198,15,1,1,24);
 }
 route([[748,2205],[794,2205]]);route([[1070,2205],[1118,2205]]);
 text('This Scene uses _rasterDirectMattedImage()',935,2270,24,blue);
 text('Other source representations select different kernels',935,2340,22,muted);
 const alternatives=[['Shape / Stroke spans','_rasterMattedRle()'],['Fast rectangle','_rasterMattedRect()'],['Gradient spans','_rasterGradientMattedRle()']];
 alternatives.forEach(([name,fn],i)=>{const x=630+i*315;text(name,x,2394,23);text(fn,x,2442,19);});
 text('Each kernel reads a mask weight during rasterization',935,2499,21,muted);
 text(`ThorVG ${commit.slice(0,8)} · native avatar buffers and pixels · local loops show operations, not CPU timing`,720,2582,20,muted);
 if(still)scene.wait(8);else{
  const previous=tracks.map(({state})=>state(0));
  for(let k=1;k<=96;k++){const changes=[];tracks.forEach(({target,state},i)=>{const next=state(k/12),changed={};for(const key of Object.keys(next))if(JSON.stringify(next[key])!==JSON.stringify(previous[i][key]))changed[key]=next[key];if(Object.keys(changed).length)changes.push({target,...changed});previous[i]=next;});if(changes.length)scene.play(changes,1/12,'linear');else scene.wait(1/12);}
 }
 return {scene,model:m,beats,reviewTimes,textIds,textPolicies,routes,pixelProbes,sampleChecks,spanChecks,geometryChecks,regions,imageRegions,fixedRegions};
}
