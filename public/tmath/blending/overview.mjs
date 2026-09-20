import {tmath} from '../runtime/client.js';
import {input, buildModel} from './model.mjs';

// Seven persistent sections, each with its own local mechanism and clock.
export function buildOverview(data = input, {still=false}={}) {
  const model = buildModel(data);
  const width = 1440, height = 3880;
  const ink = '#202020', muted = '#626262';
  const scene = tmath.scene({width, height, fps: 30, loop: true,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f6f7f8',
      text: Object.fromEntries(['h1', 'h2', 'h3', 'text', 'code'].map(r => [r, {font: 'Pretendard', color: ink}]))}});
  const textIds = [], textPolicies = {}, routes = [], beats = [], reviewTimes = [0,.8,1.5,2.4,3.4,4.6,6,7.6], pixelProbes = [], sampleChecks = [], spanChecks = [], geometryChecks = [], tracks = [], regions = [], imageRegions = [], fixedRegions = [];
  let serial = 0;
  const id = name => `cpu-blending-${name}-${serial++}`;
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  function text(parent, value, x, y, size = 22, color = ink, owner, align = [.5, .5]) {
    const key = id('text'); textIds.push(key);
    textPolicies[key] = owner ? {owner: owner.id, inset: 12} : {standalone: true};
    return parent.text({id: key, text: value, point: p(x, y), font: 'Pretendard', size, fill: color, align, layer: 40});
  }
  function rect(parent, x, y, w, h, fill = '#ffffff', stroke = ink) {
    const key = id('rect');
    const handle = parent.rectangle({id: key, center: p(x, y), size: [w / 100, h / 100], fill, stroke, width: 1.4, layer: 12});
    return {id: key, handle};
  }
  function route(parent, points, dashed = false) {
    const key = id('route'); routes.push({id: key, points});
    parent.route({id: key, points: points.map(([x, y]) => p(x, y)), stroke: ink, width: 3.5, tip: 10,
      ...(dashed ? {dash: [5, 5]} : {}), layer: 7});
  }
  function node(parent, x, y, title, detail, dark = false, w = 330) {
    const box = rect(parent, x, y, w, 94, dark ? ink : '#ffffff');
    text(parent, title, x, y - 17, 22, dark ? '#ffffff' : ink, box);
    text(parent, detail, x, y + 20, 18, dark ? '#dddddd' : muted, box);
  }
  function rule(y, label, end) {
    scene.line({id: id('rule'), from: p(455, y), to: p(1400, y), stroke: '#cccccc', width: 1});
    text(scene, label, 470, y + 27, 23, muted, undefined, [0, .5]);
    regions.push({name:label,x:460,y:y+60,width:935,height:end-y-70});beats.push({section:regions.length,label,phase:phases[regions.length-1]});
  }
  const phases=[.4,1.4,2.5,3.5,4.6,5.5,6.4];
  const clamp=v=>Math.max(0,Math.min(1,v)),smooth=v=>{v=clamp(v);return v*v*(3-2*v);};
  const matrix=(sx=1,dx=0,dy=0)=>[sx,0,0,dx,0,1,0,dy,0,0,1,0,0,0,0,1];
  function animated(parent,phase,state){
    const sample=t=>state((t+phase)%8),initial=sample(0);
    const g=parent.group({id:id('motion'),opacity:initial.opacity??1,...(initial.transform?{matrix:initial.transform}:{})});
    tracks.push({target:g,state:sample});return g;
  }
  function pixels(parent, values, x, y, w, h, columns, rows, layer = 20) {
    values.forEach((color, index) => parent.rectangle({id: id('pixel'),
      center: p(x - w / 2 + (index % columns + .5) * w / columns, y - h / 2 + (Math.floor(index / columns) + .5) * h / rows),
      size: [w / columns / 100, h / rows / 100], fill: color, stroke: '#00000000', width: 0, layer}));
  }
  function probes(values, x, y, w, h) {
    values.forEach((color, index) => {
      for (const [u, v] of [[.5,.5],[.25,.25],[.75,.25],[.25,.75],[.75,.75]]) pixelProbes.push({
        x: x - w / 2 + (index % model.width + u) * w / model.width,
        y: y - h / 2 + (Math.floor(index / model.width) + v) * h / model.height, color});
    });
  }
  function grid(parent, values, x, y, w, h, columns = model.width, rows = model.height, gridColor = '#ffffff55') {
    imageRegions.push({x:x-w/2,y:y-h/2,width:w,height:h});
    pixels(parent, values, x, y, w, h, columns, rows);
    for (let i = 0; i <= columns; i++) parent.line({id: id('grid-v'), from: p(x - w / 2 + i * w / columns, y - h / 2), to: p(x - w / 2 + i * w / columns, y + h / 2), stroke: gridColor, width: .7, layer: 30});
    for (let i = 0; i <= rows; i++) parent.line({id: id('grid-h'), from: p(x - w / 2, y - h / 2 + i * h / rows), to: p(x + w / 2, y - h / 2 + i * h / rows), stroke: gridColor, width: .7, layer: 30});
  }
  const hex = c => '#' + c.slice(0, 3).map(v => v.toString(16).padStart(2, '0')).join('');
  const rgb = c => c.slice(0, 3).join(', ');
  function writer(parent,values,x,y,w,h,phase,initial=model.blankColors){
    const v=h/model.height;
    grid(parent,initial,x,y,w,h);
    for(let row=0;row<model.height;row++){
      const g=animated(parent,phase,t=>({opacity:still?1:smooth((t-.7-row*4.8/(model.height-1))/.18)}));
      pixels(g,values.slice(row*model.width,(row+1)*model.width),x,y-h/2+(row+.5)*v,w,v,model.width,1,22);
    }
    probes(values,x,y,w,h);
    for(const time of reviewTimes){
      const local=(time+phase)%8;
      for(const row of [4,7,10]){
        const start=.7+row*4.8/(model.height-1);
        if(local>start-.15&&local<start+.35)continue;
        for(const col of [6,9,14]){
          const i=row*model.width+col;
          sampleChecks.push({time,x:x-w/2+(col+.5)*w/model.width,y:y-h/2+(row+.5)*v,color:local<start?initial[i]:values[i]});
        }
      }
    }
  }
  function rle(parent,x,y,w,h,phase,spans){
    const u=w/model.width,v=h/model.height,rows=new Map(),shades=Array(model.width*model.height).fill('#ffffff');
    grid(parent,shades,x,y,w,h,model.width,model.height,'#d5dde3');
    for(const [sx,sy,len,c] of spans){
      if(!rows.has(sy))rows.set(sy,animated(parent,phase,t=>({opacity:still?1:smooth((t-.6-sy*4.8/(model.height-1))/.18)})));
      const g=rows.get(sy),shade=255-Math.floor(c*195/255),color=hex([shade,shade,shade]),key=id('span');
      const bx=x-w/2+(sx+.5)*u,by=y-h/2+(sy+.5)*v,ex=bx+(len-1)*u;shades[sy*model.width+sx]=color;
      g.rectangle({id:key+'-begin',center:p(bx,by),size:[(u-2)/100,(v-2)/100],fill:color,stroke:'#cbd5df',width:1,layer:32});
      if(len>1){g.line({id:key+'-len',from:p(bx,by),to:p(ex,by),stroke:'#526579',width:2.5,layer:34});g.line({id:key+'-end',from:p(ex,by-v*.16),to:p(ex,by+v*.16),stroke:'#526579',width:1.5,layer:34});}
      spanChecks.push({key,len,bx,by,ex});
    }
    shades.forEach((color,i)=>pixelProbes.push({x:x-w/2+(i%model.width+.25)*u,y:y-h/2+(Math.floor(i/model.width)+.25)*v,color}));
  }
  const channelColors=['#c45b61','#7c9553','#236caa'];
  function channels(parent,x,y,from,to,phase){
    for(let k=0;k<3;k++){
      const left=x-87.5,base=Math.max(from[k],1),origin=p(left,0)[0];
      parent.rectangle({id:id('channel-track'),center:p(x,y+k*14),size:[1.75,.08],fill:'#dedfe2',stroke:'#00000000',layer:22});
      const bar=animated(parent,phase,t=>{const value=still?to[k]:from[k]+(to[k]-from[k])*smooth((t-.8)/2.2),sx=value/base;return {transform:matrix(sx,origin*(1-sx))};});
      const key=id('channel');
      bar.rectangle({id:key,center:p(left+base/255*87.5,y+k*14),size:[base/255*1.75,.08],fill:channelColors[k],stroke:'#00000000',layer:24});
      geometryChecks.push({id:key,time:(4-phase+8)%8,x:left,y:y+k*14-4,width:to[k]/255*175,height:8});
    }
  }
  function sampleSwatch(parent,x,y,color,title){
    rect(parent,x,y,175,36,hex(color));text(parent,title,x,y-45,22);text(parent,rgb(color),x,y+37,20,muted);
  }
  function scope(y,h,label){const box=rect(scene,225,y+h/2,400,h,'#00000000',ink);text(scene,label,225,y+28,23,ink,box);}
  function down(y1,y2){route(scene,[[225,y1],[225,y2]]);}
  function left(y,title,detail,dark=false){node(scene,225,y,title,detail,dark,356);}
  function thinNode(x,y,w,title,detail){node(scene,x,y,title,detail,false,w);}
  function outline(parent,x,y,u,shape,color,phase){
    const [sx,sy,ww,hh,r]=shape,l=x+sx*u,t=y+sy*u,R=l+ww*u,B=t+hh*u,rad=r*u,k=.55228475;
    const start=[l+rad,t],segments=[
      {type:'line',to:p(R-rad,t)},
      {type:'cubic',control1:p(R-rad+k*rad,t),control2:p(R,t+rad-k*rad),to:p(R,t+rad)},
      {type:'line',to:p(R,B-rad)},
      {type:'cubic',control1:p(R,B-rad+k*rad),control2:p(R-rad+k*rad,B),to:p(R-rad,B)},
      {type:'line',to:p(l+rad,B)},
      {type:'cubic',control1:p(l+rad-k*rad,B),control2:p(l,B-rad+k*rad),to:p(l,B-rad)},
      {type:'line',to:p(l,t+rad)},
      {type:'cubic',control1:p(l,t+rad-k*rad),control2:p(l+rad-k*rad,t),to:p(...start)},
    ];
    parent.path({id:id('input-path'),commands:[{type:'move',to:p(...start)},...segments,{type:'close'}],stroke:color,fill:'#00000000',width:1.3,layer:20});
    let previous=p(...start);
    segments.forEach((seg,i)=>{const g=animated(parent,phase,t=>({opacity:still?1:smooth((t-.5-i*.45)/.25)}));g.path({id:id('construct-path'),commands:[{type:'move',to:previous},seg],stroke:color,fill:'#00000000',width:4,layer:22});previous=seg.to;});
  }
  const destTask=data.cases.Multiply.destinationTask,srcTask=data.cases.Multiply.sourceTask;
  text(scene,'CPU Engine / Blending',40,48,36,ink,undefined,[0,.5]);
  text(scene,'Two overlapping rectangles · prepare geometry → draw D → blend S into the same Surface',40,98,23,muted,undefined,[0,.5]);
  scene.line({id:id('spine-divider'),from:p(440,155),to:p(440,3800),stroke:'#cfd4d9',width:1});
  rule(160,'01  API / Two Shapes, one retained paint order',580);
  rule(580,'02  UPDATE / Paths become tasks and coverage',1250);
  rule(1250,'03  DRAW D / Destination means the pixels already written',1680);
  rule(1680,'04  DRAW S / Select the mode, then the raster path',2290);
  rule(2290,'05  READ & BLEND / One pixel inside the overlap',2710);
  rule(2710,'06  COVERAGE / The same color rule at a rounded corner',3150);
  rule(3150,'07  WRITE / Accumulate into the existing Surface',3800);

  // 01: inputs only. Reconstruct each path locally; never show a blended result.
  left(275,'Paint::blend()','s → BlendMethod::Multiply');
  left(426,'canvas->add(d); add(s);','D: Normal     S: Multiply');
  down(323,378);down(474,554);
  text(scene,'Destination Shape d',680,245,24);
  text(scene,'Source Shape s',1160,245,24);
  text(scene,`appendRect(${data.destinationRect.join(', ')})`,680,292,20,muted);
  text(scene,`appendRect(${data.sourceRect.join(', ')})`,1160,292,20,muted);
  rect(scene,680,430,288,208,'#ffffff','#cbd5df');
  rect(scene,1160,430,288,208,'#ffffff','#cbd5df');
  outline(scene,536,326,16,data.destinationRect,hex(model.destination),phases[0]);
  outline(scene,1016,326,16,data.sourceRect,hex(model.source),phases[0]+.7);
  text(scene,`fill(${rgb(model.destination)})`,680,553,20,muted);
  text(scene,`fill(${rgb(model.source)})`,1160,553,20,muted);

  // 02: Canvas's root Scene traverses both Shapes; work may run on workers.
  scope(580,646,'canvas->update()');
  left(690,'Paint::Impl::update()','root Scene → d, s');
  left(805,'ShapeImpl::update()','SwRenderer::prepare(rs, …)');
  left(920,'prepareCommon()','TaskScheduler::request(task)');
  left(1035,'SwShapeTask::run()','shapeGenRle() → rleRender()',true);
  left(1150,'postUpdate()','no target pixels written');
  [738,853,968].forEach((y,i)=>down(y,[757,872,987][i]));
  // postUpdate returns independently of the scheduled worker branch.
  route(scene,[[404,920],[414,920],[414,1150],[404,1150]]);
  thinNode(695,727,390,'SwShapeTask / d','rshape → blue RenderShape');
  thinNode(1155,727,390,'SwShapeTask / s','rshape → orange RenderShape');
  text(scene,`clipBox = [${srcTask.clipBox.join(', ')}] · opacity = ${srcTask.opacity} · clips = ${srcTask.clipCount}`,925,815,21,muted);
  text(scene,'SwShape.rle / d',695,866,22);
  text(scene,'SwShape.rle / s',1155,866,22);
  rle(scene,695,1010,324,234,phases[1],destTask.spans);
  rle(scene,1155,1010,324,234,phases[1]+.7,srcTask.spans);
  text(scene,'SwRle → SwSpan { x, y, len, coverage }',925,1160,22);
  text(scene,'shade = coverage · length line joins pixel centers · len = 1 has no line',925,1206,20,muted);
  down(1228,1243);

  // 03: exact native intermediate from a destination-only public draw.
  scope(1250,2420,'canvas->draw(true)');
  left(1360,'clear() → preRender()','transparent Surface');
  left(1478,'SceneImpl::render()','Paint order: d → s');
  left(1596,'d: renderShape()','Normal → _rasterSolidRle()',true);
  down(1408,1430);down(1526,1548);
  text(scene,'Cleared Surface',680,1370,23);
  text(scene,'After drawing d',1160,1370,23);
  grid(scene,model.blankColors,680,1512,324,234);
  writer(scene,model.colors.destination,1160,1512,324,234,phases[2]);
  route(scene,[[861,1512],[978,1512]]);
  text(scene,'Checkerboard = display only · D is read from this buffer, pixel by pixel',925,1650,20,muted);
  down(1644,1712);

  // 04: main fixture plus the actual alternate CPU branches, not one universal helper.
  left(1760,'s: ShapeImpl::render()','SwRenderer::blend(Multiply)');
  left(1880,'surface->blender','blendMultiply');
  left(2000,'renderShape(rd)','task->done() → solid fill');
  left(2120,'rasterShape()','fastTrack ? Rect : Rle');
  [1808,1928,2048].forEach((y,i)=>down(y,[1832,1952,2072][i]));
  text(scene,'Input geometry',620,1765,20,muted);
  text(scene,'Custom-blend path',1080,1765,20,muted);
  const branches=[
    ['Axis-aligned rectangle','_rasterBlendingRect',false],
    ['Rounded rectangle / this s','_rasterBlendingRle',true],
    ['Gradient fill / stroke','_rasterBlendingGradientRect / Rle',false],
    ['Solid stroke / strokeRle','_rasterBlendingRle',false],
    ['Image / direct, scaled','_raster…BlendingImage / RleImage',false],
  ];
  branches.forEach(([label,fn,main],i)=>{
    const y=1822+i*64;
    rect(scene,675,y,350,48,main?'#e5edf3':'#ffffff','#bfc8d1');text(scene,label,675,y,19);
    rect(scene,1142,y,462,48,main?ink:'#ffffff',main?ink:'#bfc8d1');text(scene,fn,1142,y,19,main?'#ffffff':ink);
    route(scene,[[860,y],[901,y]]);
  });
  text(scene,'_rasterRle dispatch priority',925,2180,22);
  const slots=[['compositing?','Mask / Matte'],['blender != null','custom Blend'],['otherwise','Solid / Translucent']];
  slots.forEach(([title,sub],i)=>{const x=625+i*305;rect(scene,x,2235,275,56,'#ffffff','#cbd5df');text(scene,title,x,2220,19);text(scene,sub,x,2250,17,muted);});
  // Bind the mode to a function pointer; only this connection rebuilds locally.
  text(scene,'s->blend(Multiply)',675,2137,20);
  text(scene,'blender = blendMultiply',1175,2137,20);
  const origin=p(857,0)[0];
  const bind=animated(scene,phases[3],t=>{const sx=still?1:smooth((t-.6)/2.8);return {transform:matrix(sx,origin*(1-sx)),opacity:still?1:smooth((t-.3)/.2)};});
  route(bind,[[857,2137],[982,2137]]);

  // 05: operands from the same native example, not abstract paint swatches.
  left(2435,'_rasterBlendingRle()','fetch spans within bbox');
  left(2580,'buf32[y × stride + x]','color = join(fill.r, g, b, a)');
  down(2168,2387);down(2483,2532);
  const point=[model.full%model.width,Math.floor(model.full/model.width)];
  text(scene,`Overlap pixel (${point.join(', ')}) · source coverage = 255`,925,2387,22);
  sampleSwatch(scene,620,2480,model.source,'S / fill color');
  sampleSwatch(scene,930,2480,model.destination,'D / current *dst');
  sampleSwatch(scene,1240,2480,model.blended,'B / blendMultiply');
  channels(scene,620,2550,model.source,model.source,phases[4]);
  channels(scene,930,2550,model.destination,model.destination,phases[4]);
  channels(scene,1240,2550,model.source,model.blended,phases[4]);
  route(scene,[[725,2480],[825,2480]]);route(scene,[[1035,2480],[1135,2480]]);
  text(scene,'B = surface->blender(surface, color, *dst)',925,2627,24);
  text(scene,'Opaque overlap / each RGB channel: (S × D + 255) >> 8',925,2673,21,muted);

  // 06: coverage weights B against the original D, not against another buffer.
  left(2845,'surface->blender(...)','calculate B from S and D',true);
  left(3000,'span->coverage','full B / interpolated edge');
  down(2628,2797);down(2893,2952);
  const c=model.coverage[model.edge];
  text(scene,`Rounded corner (${model.edgePoint.join(', ')}) · coverage = ${c}`,925,2800,23);
  sampleSwatch(scene,620,2900,model.destination,'Original D');
  sampleSwatch(scene,930,2900,model.blended,'Full blend B');
  sampleSwatch(scene,1240,2900,model.edgeResult,'Covered output');
  channels(scene,620,2970,model.destination,model.destination,phases[5]);
  channels(scene,930,2970,model.blended,model.blended,phases[5]);
  channels(scene,1240,2970,model.destination,model.edgeResult,phases[5]);
  route(scene,[[725,2900],[825,2900]]);route(scene,[[1035,2900],[1135,2900]]);
  text(scene,`INTERPOLATE(B, D, ${c})`,925,3060,24);
  text(scene,'No span: keep D · full coverage: write B · edge: mix B with D',925,3112,21,muted);

  // 07: one retained buffer, plus three fixed native reference results.
  left(3270,'*dst = output; ++dst;','len pixels → next span',true);
  left(3450,'postRender()','finish this Surface');
  left(3600,'One Surface','no intermediate compositor');
  down(3048,3222);down(3318,3402);down(3498,3552);
  left(3740,'canvas->sync()','CPU output ready');
  down(3648,3692);
  const xs=[620,940,1260];
  ['Cleared','D rendered','S blended into D'].forEach((label,i)=>text(scene,label,xs[i],3258,22));
  grid(scene,model.blankColors,xs[0],3380,252,182);
  writer(scene,model.colors.destination,xs[1],3380,252,182,phases[6]);
  writer(scene,model.colors.Multiply,xs[2],3380,252,182,phases[6]+.6,model.colors.destination);
  route(scene,[[760,3380],[800,3380]]);route(scene,[[1080,3380],[1120,3380]]);
  text(scene,'Same two Shapes · only s->blend(method) changes',940,3515,22,muted);
  ['Normal','Multiply','Screen'].forEach((mode,i)=>{
    text(scene,mode,xs[i],3570,23);
    grid(scene,model.colors[mode],xs[i],3695,252,182);
    probes(model.colors[mode],xs[i],3695,252,182);
    fixedRegions.push({x:xs[i]-126,y:3604,width:252,height:182});
  });
  text(scene,'Native CPU / ABGR8888 · opaque fills, rounded corners · local motion explains operations, not execution time',720,3842,20,muted);
  if(still)scene.wait(8);
  else{
    const previous=tracks.map(({state})=>state(0));
    for(let k=1;k<=96;k++){
      const changes=[];
      tracks.forEach(({target,state},i)=>{const next=state(k/12),changed={};for(const key of Object.keys(next))if(JSON.stringify(next[key])!==JSON.stringify(previous[i][key]))changed[key]=next[key];if(Object.keys(changed).length)changes.push({target,...changed});previous[i]=next;});
      if(changes.length)scene.play(changes,1/12,'linear');else scene.wait(1/12);
    }
  }
  return {scene,model,beats,reviewTimes,textIds,textPolicies,routes,pixelProbes,sampleChecks,spanChecks,geometryChecks,regions,imageRegions,fixedRegions};
}
