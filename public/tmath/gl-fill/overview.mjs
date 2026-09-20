import {tmath} from '../runtime/client.js';
import {model,hex,gradient,seamStrip,revision} from './model.mjs';
import {localLoops,smooth} from '../shape/chapter-motion.mjs';

// One native radial fixture, three placements of scale. Every row owns its clock.
export function buildOverview(capture, thumbnails, input={}, {still=false}={}) {
 const m=model(input),width=1440,height=3970,duration=8;
 const C={ink:'#24292e',muted:'#646d75',line:'#cfd5db',blue:'#2368a8',orange:'#b65622',paper:'#f6f7f8',white:'#ffffff'};
 const scene=tmath.scene({width,height,fps:30,loop:true,theme:{preset:'pro_white',background:C.paper},camera:{mode:'fixed',view:'2d',height:height/100}});
 const loops=localLoops(scene,{still,duration,prefix:'gl-fill-loop'}),phases=[.5,1.5,2.5,3.5,4.5,5.5,6.5];
 const textIds=[],textPolicies={},routes=[],regions=[],fixedRegions=[],pixelChecks=[],sampleChecks=[],geometryChecks=[],imageRegions=[],beats=[],scopes=[];
 const reviewTimes=[0,.8,1.5,2.4,3.4,4.6,6,7.6,8],ids=new WeakMap();let serial=0;
 const id=n=>`gl-fill-${n}-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100],fmt=n=>String(Number(n.toFixed(3)));
 const centers=[625,940,1255],labels=['Fill scale','Shape scale','Reference'];
 function rect(parent,x,y,w,h,fill=C.white,stroke='#00000000',layer=10,border=1.5){const key=id('rect'),o=parent.rectangle({id:key,center:p(x+w/2,y+h/2),size:[w/100,h/100],fill,stroke,width:border,layer});ids.set(o,key);return o;}
 function text(value,x,y,size=22,color=C.ink,owner=null,center=false){
  owner??=x<420?scopes.find(s=>y>s.y&&y<s.end)?.owner:undefined;
  const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:ids.get(owner),inset:12}:{standalone:true};
  return scene.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align:[center?.5:0,.5],layer:70});
 }
 function line(parent,a,b,color=C.line,weight=1,layer=8){return parent.line({id:id('line'),from:p(...a),to:p(...b),stroke:color,width:weight,layer});}
 function route(points,color=C.muted){const key=id('route');routes.push({id:key,points});scene.route({id:key,points:points.map(q=>p(...q)),stroke:color,width:3.5,tip:10,layer:9});}
 function circle(parent,x,y,r,fill='#00000000',stroke=C.blue,layer=30){return parent.circle({id:id('circle'),center:p(x,y),radius:r/100,fill,stroke,width:2,layer});}
 function scope(y,end,title){const owner=rect(scene,25,y,395,end-y,'#00000000',C.ink,2);scopes.push({y,end,owner});text(title,44,y+30,20,C.muted,owner);}
 function node(y,lines,dark=false){const hh=lines.length*33+26,owner=rect(scene,44,y,357,hh,dark?C.ink:C.white,C.ink);lines.forEach((s,i)=>text(s,62,y+29+i*33,i?19:22,dark?C.white:C.ink,owner));return {y,h:hh};}
 function down(a,b){route([[222,a.y+a.h+7],[222,b.y-9]]);}
 function section(n,y,end,title){line(scene,[455,y],[1400,y]);text(`${String(n).padStart(2,'0')}  ${title}`,475,y+30,24,C.muted);regions.push({name:title,x:472,y:y+70,width:922,height:end-y-85});beats.push({section:n,label:title,phase:phases[n-1]});}
 function bitmap(parent,data,x,y,w,{layer=20,filter='nearest'}={}){
  // Replicated texels keep magnified native pixels stable at quarter-cell probes.
  if(data.width*data.height<=1024){const W=data.width,H=data.height;data={width:W*4,height:H*4,pixels:Array.from({length:W*H*16},(_,i)=>data.pixels[Math.floor(Math.floor(i/(W*4))/4)*W+Math.floor(i%(W*4)/4)])};}
  if(data.width*data.height>16384){for(let ty=0;ty<data.height;ty+=128)for(let tx=0;tx<data.width;tx+=128){const tw=Math.min(128,data.width-tx),th=Math.min(128,data.height-ty),pixels=[];for(let yy=0;yy<th;yy++)pixels.push(...data.pixels.slice((ty+yy)*data.width+tx,(ty+yy)*data.width+tx+tw));bitmap(parent,{width:tw,height:th,pixels},x+tx*w/data.width,y+ty*w/data.width,tw*w/data.width,{layer,filter});}return;}
  parent.image({id:id('image'),pixels:data.pixels,size:[data.width,data.height],center:p(x+w/2,y+w*data.height/data.width/2),width:w/100,filter,layer});
 }
 function field(data,x,y,w,{fixed=false,probe=false,filter='nearest'}={}){
  bitmap(scene,data,x,y,w,{filter});const h=w*data.height/data.width;
  rect(scene,x,y,w,h,'#00000000',C.line,35,1);imageRegions.push({x,y,width:w,height:h});
  if(fixed)fixedRegions.push({x,y,width:w,height:h});
  if(probe){const u=w/data.width;data.pixels.forEach((color,i)=>{for(const [a,b] of [[.5,.5],[.25,.25],[.75,.75]])pixelChecks.push({x:x+(i%data.width+a)*u,y:y+(Math.floor(i/data.width)+b)*u,color,fixed});});}
 }
 function writer(data,x,y,w,phase){
  if(still)return;
  const u=w/data.width;rect(scene,x,y,w,data.height*u,C.white,'#00000000',22);
  // A stripe contains the actual evaluated/captured values, not a traveling cursor.
  for(let col=0;col<data.width;col++){
   const start=.4+col*5.2/Math.max(1,data.width-1),parent=loops.reveal(phase,start);
   const stripe={width:1,height:data.height,pixels:Array.from({length:data.height},(_,row)=>data.pixels[row*data.width+col])};
   bitmap(parent,stripe,x+col*u,y,u,{layer:24});
   for(const time of reviewTimes){const local=(time+phase)%duration;if(local<.15||local>7.35||local>start-.15&&local<start+.4)continue;
    if(col%4===0)sampleChecks.push({time,x:x+(col+.5)*u,y:y+.5*u,color:local<start?'#ffffffff':stripe.pixels[0]});
   }
  }
 }
 function ray(x,y,dx,dy,phase){
  line(scene,[x,y],[x+dx,y+dy],C.line,2,20);
  const group=still?scene:loops.track(t=>{const f=loops.amount(t,.4,2.4),[wx,wy]=p(x,y);return {opacity:f>0?1:0,transform:[Math.max(f,.00001),0,0,wx*(1-f),0,Math.max(f,.00001),0,wy*(1-f),0,0,1,0,0,0,0,1]};},phase);
  group.route({id:id('radius'),points:[p(x,y),p(x+dx,y+dy)],stroke:C.blue,width:3.5,tip:10,layer:32});
 }

 text('GPU Engine / GL Fill',40,50,36);
 text('One radial fill → world mesh → uniform blocks → shader color → resolved pixels',40,99,23,C.muted);
 text('Opaque fill · Normal blend · Repeat',40,133,19,C.muted);
 line(scene,[440,147],[440,3870]);
 section(1,155,600,'INPUT / One shape, four color stops');
 section(2,600,1070,'PREPARE / Different inputs, equal world geometry');
 section(3,1070,1570,'DRAW → SYNC / Record a task, then upload its data');
 section(4,1570,2090,'SHADER / Recover the gradient-space position');
 section(5,2090,2600,'REPEAT AA / Distance units determine the seam width');
 section(6,2600,3070,'MSAA / Resolve covered samples into a pixel');
 section(7,3070,3870,'RESULT / Native GL pixels, at the same screen positions');

 scope(172,579,'Public API');const api=node(250,['RadialGradient::gen()','colorStops(stops, 4)','spread(Repeat)']);const fill=node(426,['Shape::fill(gradient)'],true);down(api,fill);text('S = Shape transform',44,524,21,C.blue);text('F = Fill transform',44,557,21,C.orange);
 scope(617,1048,'Canvas::update()');const prep=node(699,['GlRenderer::prepare()','GlGeometry::prepare()']);const tess=node(859,['tesselateShape()','world vertices + indices'],true);down(prep,tess);text('GlShape: geometry + Fill',44,1004,21,C.muted);
 scope(1087,1358,'Canvas::draw()');node(1167,['renderShape()','drawPrimitive(Fill*)'],true);text('GlRenderTask + bindings',44,1310,21);
 scope(1377,1547,'Canvas::sync()');node(1434,['GlGpuBuffer','flushToGPU()'],true);
 scope(1587,2067,'GlRenderTask::run()');node(1665,['glDrawElements()'],true);text('Vertex shader',44,1770,23,C.blue);text('gl_Position = View × p',44,1813,22);text('vPos = F⁻¹ × S⁻¹ × p',44,1855,22,C.orange);text('Fragment shader',44,1946,23,C.blue);text('radialGradientColor(vPos)',44,1990,22);text('compute_radial_t()',44,2034,21,C.muted);
 scope(2107,2578,'gradient(t, d, l)');node(2187,['Repeat / final interval'],true);text('1 − t < dist',44,2300,25,C.orange);text('a = (1 − t) / dist',44,2350,23);text('C = a × Cstop + (1−a) × C0',44,2400,21);text('Pad / Reflect:',44,2505,21,C.muted);text('ordinary stop interpolation',44,2545,21,C.muted);
 scope(2617,3048,'GlRenderTarget / 4 samples');node(2697,['Premultiplied RGBA','ONE','ONE_MINUS_SRC_ALPHA'],true);node(2872,['GlComposeTask','onResolve()','glBlitFramebuffer()']);text('GlBlitTask → target',44,3020,20,C.muted);
 scope(3087,3870,'Canvas::sync() completes');node(3195,['Target framebuffer','glReadPixels()'],true);text('Same 512 × 512 output',44,3362,23);text(`Screen radius = ${m.radius} px`,44,3405,23,C.blue);text(`Sample (${m.sample.join(', ')})`,44,3505,21);text('Same native crop in each case',44,3548,20,C.muted);text('Captured image + pixel crop',44,3704,20,C.muted);text('Writing captured rows below',44,3748,20,C.blue);

 // 01: the three native inputs differ only in the placement of scale.
 text('ColorStop[4] · the same colors in every case',490,248,23);
 const ramp={width:60,height:3,pixels:Array.from({length:180},(_,i)=>hex(gradient((i%60+.5)/60,128,{aa:false,spread:'Pad',colors:m.colors}).straight))};
 field(ramp,490,281,870);writer(ramp,490,281,870,phases[0]);
 m.colors.forEach(s=>{const x=490+s.offset*870;circle(scene,x,342,5,hex(s.rgba),C.ink);text(fmt(s.offset),x,369,18,C.muted,null,true);});
 m.cases.forEach((c,i)=>{const x=centers[i];text(labels[i],x,419,24,C.ink,null,true);rect(scene,x-41,445,82,82,'#ffffff',C.blue,20,2);text(`${fmt(c.side)} × ${fmt(c.side)}`,x,553,20,C.muted,null,true);text(`R ${fmt(c.R)} · ${i<2?(i?'S':'F')+' × '+m.scale:'identity'}`,x,585,19,i<2?C.orange:C.muted,null,true);});

 // 02: model-derived world vertices; triangle order is a tessellation schematic.
 m.cases.forEach((c,i)=>{
  const x=centers[i]-88,y=740,u=176/m.panel;
  text(labels[i],centers[i],695,24,C.ink,null,true);
  const points=c.vertices.map(v=>[x+(v[0]-c.offset[0])*u,y+(v[1]-c.offset[1])*u]);
  scene.polygon({id:id('world-mesh'),points:points.map(q=>p(...q)),fill:'#e4ebf2',stroke:C.blue,width:2,layer:20});
  [[0,1,2],[0,2,3]].forEach((indices,j)=>{const parent=loops.reveal(phases[1],.6+j*1.7);parent.polygon({id:id('triangle'),points:indices.map(k=>p(...points[k])),fill:j?'#d0e1f1':'#aacbe8',stroke:C.blue,width:2.5,layer:25});});
  text(`world origin (${c.offset.join(', ')})`,centers[i],956,19,C.muted,null,true);
 });
 text('Same 512 × 512 bounds · convex rectangle → direct draw',490,1000,23,C.blue);
 text('Triangle schematic · other nonconvex fills use stencil + cover',490,1040,20,C.muted);

 // 03: keep CPU records visible while stop data is copied into the staged blocks.
 const transform=rect(scene,490,1182,405,164,C.white,C.line),info=rect(scene,950,1182,410,164,C.white,C.line);
 text('TransformInfo · binding 0',508,1214,24,C.ink,transform);text('F⁻¹ × S⁻¹',692,1270,27,C.orange,transform,true);text('world → gradient space',692,1313,21,C.muted,transform,true);
 text('GradientInfo · binding 2',968,1214,24,C.ink,info);text(`4 stops · Repeat · R = ${fmt(m.sourceRadius)}`,968,1259,20,C.muted,info);
 m.colors.forEach((s,i)=>{const x=973+i*94;rect(scene,x,1293,76,28,'#e5e9ed');rect(loops.reveal(phases[2],.4+i*.6),x,1293,76,28,hex(s.rgba));});
 text('Uncorrectable radial → last-stop solid',490,1371,19,C.muted);
 text('CPU staging',490,1407,22,C.muted);text('GPU buffers',950,1407,22,C.blue);
 const staging=rect(scene,490,1433,405,62,C.white,C.line),gpu=rect(scene,950,1433,410,62,C.white,C.blue);
 text('vertices · indices · uniforms',509,1464,22,C.ink,staging);text('uploaded before task execution',968,1464,20,C.ink,gpu);
 route([[906,1464],[938,1464]]);
 m.colors.forEach((s,i)=>rect(loops.reveal(phases[2],3.1+i*.35),973+i*94,1510,76,12,hex(s.rgba)));
 text('Solid: vertex RGBA     Linear / Radial: stop uniforms, up to 16 stops',490,1540,20,C.muted);

 // 04: the radius vector is constructed in each recovered coordinate space.
 text(`Selected pixel (${m.sample.join(', ')}) · concentric circles, focal radius 0`,490,1658,22);
 m.cases.forEach((c,i)=>{
  const x=centers[i],y=1817,r=77;
  text(labels[i],x,1713,23,C.ink,null,true);circle(scene,x,y,r,'#00000000',C.line,20);
  line(scene,[x-r-9,y],[x+r+9,y],C.line);line(scene,[x,y-r-9],[x,y+r+9],C.line);
  circle(scene,x,y,3,C.muted,C.muted);
  const dx=(c.pos[0]-c.c[0])/c.R*r,dy=(c.pos[1]-c.c[1])/c.R*r;
  ray(x,y,dx,dy,phases[3]);circle(scene,x+dx,y+dy,4,C.blue,C.blue,40);
  text(`R = ${fmt(c.R)}`,x,1913,20,C.muted,null,true);
  text(`l = ${fmt(c.l)}`,x,1943,20,C.orange,null,true);
  text(`l / R = ${c.d.toFixed(6)}`,x,1974,23,C.blue,null,true);
 });
 text(`Repeat: t = mod(d, 1) = ${m.cases[0].sample.t.toFixed(6)} in all three cases`,490,2030,23);
 text('Gradient-space diagrams use separate scales · Linear uses projection onto its axis',490,2070,19,C.muted);

 // 05: shader evaluations build each strip; native-space AA widths stay fixed.
 text('dist = 2 × d / l = 2 / R',490,2177,29,C.orange);
 text('Concentric radial example',985,2177,23,C.muted);
 m.cases.forEach((c,i)=>{
  const x=centers[i]-133,W=266,span=6;
  text(labels[i],centers[i],2234,23,C.ink,null,true);
  const data=seamStrip(c,{width:38,height:4,span,colors:m.colors});field(data,x,2272,W);writer(data,x,2272,W,phases[4]);
  const middle=x+W/2,margin=c.screenMargin/span*W;
  line(scene,[middle,2263],[middle,2309],C.ink,2.5,40);
  line(scene,[middle-margin,2342],[middle,2342],C.orange,5,35);
  for(const xx of [middle-margin,middle])line(scene,[xx,2335],[xx,2349],C.orange,2.5,36);
  text(`${fmt(c.screenMargin)} px before wrap`,centers[i],2381,22,C.orange,null,true);
  text(`source R = ${fmt(c.R)}`,centers[i],2418,20,C.muted,null,true);
  rect(scene,x+24,2467,52,40,hex(c.raw.straight));route([[x+94,2487],[x+151,2487]]);
  rect(scene,x+171,2467,52,40,hex(c.sample.straight));
  if(!still){const g=loops.track(t=>({opacity:1-smooth((t-1.5)/2)*(1-smooth((t-6.2)/1.8))}),phases[4]);rect(g,x+171,2467,52,40,hex(c.raw.straight),'#00000000',25);}
  pixelChecks.push({x:x+197,y:2487,color:hex(c.sample.straight)});
  text(c.screenMargin>m.radius-m.sampleRadius?'Seam color mixes':'Outside blend margin',centers[i],2542,20,C.muted,null,true);
 });
 text('dist uses Fill-space distance · brackets show screen pixels',490,2580,20,C.muted);

 // 06: a coverage schematic, separate from the measured native images below.
 const sampleLocations=[[.375,.125],[.875,.375],[.125,.625],[.625,.875]],source=capture.cases[0].sample,bg=[32,32,32,255];
 [2,4].forEach((count,i)=>{
  const x=490+i*460,y=2750,size=146,outX=x+235;
  text(i?'Inside the fill':'At the shape edge',x,2710,25);
  rect(scene,x,y,size,size,hex(bg),C.line,20);
  if(!i){rect(scene,x,y+size/2,size,size/2,hex(source).slice(0,7)+'40','#00000000',21);line(scene,[x,y+size/2],[x+size,y+size/2],C.white,2,24);}
  sampleLocations.forEach(([u,v],j)=>{circle(scene,x+u*size,y+v*size,11,C.paper,C.muted,26);circle(loops.reveal(phases[5],.4+j*.55),x+u*size,y+v*size,11,hex(i||j>=2?source:bg),C.white,30);});
  route([[x+163,y+73],[outX-13,y+73]]);
  const resolved=source.map((v,k)=>v*count/4+bg[k]*(1-count/4));
  rect(scene,outX,y+42,62,62,hex(resolved),C.line,20);
  if(!still){rect(scene,outX,y+42,62,62,C.white,C.line,22);rect(loops.reveal(phases[5],2.8),outX,y+42,62,62,hex(resolved),'#00000000',24);}
  pixelChecks.push({x:outX+31,y:y+73,color:hex(resolved)});
  text(`${count} / 4 covered`,x+size/2,2940,23,C.blue,null,true);text(i?'C':'½ C + ½ D',outX+31,2940,23,C.ink,null,true);
 });
 text('Resolve averages the covered and uncovered sample colors',490,2990,23);
 text('Sample locations and 2/4 coverage are schematic; the target really uses 4×MSAA.',490,3030,19,C.muted);

 // 07: keep measured outputs and crops fixed; write separate captured rows.
 const crop=capture.crop,iw=264,iy=3205,zoomY=3560,zoomW=192,sourceRow=Math.floor(m.sample[1])-crop.y;
 m.cases.forEach((c,i)=>{
  const x=centers[i]-iw/2; text(labels[i],centers[i],3160,25,C.ink,null,true);
  field(thumbnails[i],x,iy,iw,{fixed:true,filter:'bilinear'});
  const ratio=iw/m.panel,bx=x+crop.x*ratio,by=iy+crop.y*ratio,bw=crop.width*ratio,bh=crop.height*ratio;
  rect(scene,bx,by,bw,bh,'#00000000',C.white,40,2);
  const zx=centers[i]-zoomW/2,data={width:crop.width,height:crop.height,pixels:capture.cases[i].cropPixels.map(hex)};
  field(data,zx,zoomY,zoomW,{fixed:true,probe:true});
  const cell=zoomW/crop.width,sx=zx+(Math.floor(m.sample[0])-crop.x)*cell,sy=zoomY+sourceRow*cell;
  rect(scene,sx,sy,cell,cell,'#00000000',C.white,42,1.5);
  route([[bx+bw/2,by+bh+4],[bx+bw/2,3520],[centers[i],3520],[centers[i],zoomY-12]],C.blue);
  text(`${fmt(c.screenMargin)} px · 8× pixels`,centers[i],3784,21,C.orange,null,true);
  const row={width:crop.width,height:3,pixels:data.pixels.slice((sourceRow-2)*crop.width,(sourceRow+1)*crop.width)};
  field(row,zx,3820,zoomW);writer(row,zx,3820,zoomW,phases[6]);
 });
 text(`Captured rows y = ${Math.floor(m.sample[1])-2}…${Math.floor(m.sample[1])} · fixed native images above`,490,3860,20,C.muted);
 text(`ThorVG ${revision.slice(0,8)} · ${capture.renderer} GL readback · local loops illustrate operations, not GPU timing`,40,3917,19,C.muted);
 loops.finish();
 return {scene,m,width,height,duration,textIds,textPolicies,routes,regions,fixedRegions,pixelChecks,sampleChecks,geometryChecks,imageRegions,beats,reviewTimes};
}
