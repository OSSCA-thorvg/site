import {buildScenarios} from '../raster/model.mjs';
import {tmath} from '../runtime/client.js';
import {buildPictureModel,normalizationExample} from './overview-model.mjs';

// Six source-grounded beats: API input; Vector/Bitmap dispatch; prepare artifacts;
// image outline -> RLE intersection; Draw dispatch; Source + coverage -> Surface.
// The example follows the Direct branch. Sampling insets replay the independent Draw/Raster fixtures.
export function buildOverview(model = buildPictureModel(), sample = normalizationExample()) {
  const width=1280,height=3200,ink='#222222',muted='#666666',paper='#f4f4f4',line='#cecece';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:paper,text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[],routes=[],nodeBounds=[];
  let serial=0,time=0;
  const id=name=>`picture-overview-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,opacity=0)=>scene.group({id:id(name),opacity});
  const text=(parent,value,x,y,size=23,color=ink,owner=null,align=[.5,.5])=>{
    const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),size,font:'Pretendard',role:'text',fill:color,align,layer:40});
  };
  const rect=(parent,x,y,w,h,fill='#00000000',stroke=ink,border=1.5,layer=15)=>{
    const key=id('rect');return {id:key,handle:parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:border,layer})};
  };
  function route(parent,points,tip=9,color=ink) {
    const key=id('route');routes.push({id:key,points,tip});
    return parent.route({id:key,points:points.map(v=>p(...v)),stroke:color,width:1.7,dash:[6,5],tip,layer:7});
  }
  function box(parent,title,detail,x,y,w=330,h=100,dark=false) {
    const r=rect(parent,x,y,w,h,dark?ink:'#ffffff');nodeBounds.push({id:r.id,x:x-w/2,y:y-h/2,width:w,height:h});
    text(parent,title,x,y-(detail?17:0),23,dark?'#ffffff':ink,r);
    if(detail)text(parent,detail,x,y+Math.min(17,h/2-27),19,dark?'#dddddd':muted,r);
    return r;
  }
  function stage(name,title,detail,y,dark=false) {
    const g=group(name,.25);box(g,title,detail,230,y,340,104,dark);
    return g;
  }
  function rule(y,label) {
    scene.line({id:id('rule'),from:p(455,y),to:p(1235,y),stroke:line,width:1,layer:3});
    text(scene,label,475,y+31,20,muted,null,[0,.5]);
  }
  const wait=d=>{scene.wait(d);time+=d;};
  const play=(spec,d=.45)=>{scene.play(spec,d,'ease_in_out');time+=d;};
  const show=(target,d=.45)=>play([{target,opacity:1}],d);
  const hide=(target,d=.2)=>play([{target,opacity:0}],d);
  const beat=(label,hold=1.2)=>{beats.push({time:+time.toFixed(3),label});wait(hold);};
  const packedColor=v=>'#'+[v&255,(v>>>8)&255,(v>>>16)&255].map(c=>c.toString(16).padStart(2,'0')).join('');
  function bitmap(parent,pixels,w,h,x,y,cell=20) {
    parent.image({id:id('bitmap'),pixels:pixels.map(packedColor),size:[w,h],center:p(x,y),width:w*cell/100,filter:'nearest',layer:20});
  }
  function grid(parent,x,y,w,h,cell=18,bg='#ffffff') {
    rect(parent,x,y,w*cell,h*cell,bg,line,1,9);
    const left=x-w*cell/2,top=y-h*cell/2;
    for(let a=1;a<w;a++)parent.line({id:id('grid-v'),from:p(left+a*cell,top),to:p(left+a*cell,top+h*cell),stroke:'#dddddd',width:.65,layer:12});
    for(let a=1;a<h;a++)parent.line({id:id('grid-h'),from:p(left,top+a*cell),to:p(left+w*cell,top+a*cell),stroke:'#dddddd',width:.65,layer:12});
    return {left,top,cell};
  }
  function spans(parent,list,x,y,cell=15) {
    // Match section 4.1's spanGlyph: one coverage pixel at the span start,
    // a single thin length line, and a short end tick. No filled span strip.
    const g={left:x-model.target.w*cell/2,top:y-model.target.h*cell/2,cell};
    const rows=[],glyphs=[];
    for(const span of list) {
      const row=parent.group({id:id('span')});
      const pixels=row.group({id:id('coverage')});
      const startX=g.left+(span.x+.5)*cell,centerY=g.top+(span.y+.5)*cell;
      const endX=startX+span.len*cell,pixelSize=cell*(42/44);
      rect(pixels,startX,centerY,pixelSize,pixelSize,'#ffffff','#cbd5df',.6,20);
      rect(pixels,startX,centerY,pixelSize-.6,pixelSize-.6,
        '#3c3c3c'+span.coverage.toString(16).padStart(2,'0'),'#00000000',0,21);
      const length=row.group({id:id('length')});
      length.line({id:id('len'),from:p(startX,centerY),to:p(endX,centerY),stroke:'#526579',width:cell*2.5/44,layer:28});
      length.line({id:id('end'),from:p(endX,centerY-cell*5/44),to:p(endX,centerY+cell*5/44),stroke:'#526579',width:cell*1.5/44,layer:28});
      rows.push(row);
      glyphs.push({pixels,length});
    }
    return {rows,glyphs,...g};
  }

  text(scene,'Picture',230,50,34);
  text(scene,'Load → Prepare → Draw',850,50,28,muted);
  scene.line({id:id('header'),from:p(40,91),to:p(1240,91),stroke:line,width:1,layer:3});
  text(scene,'API / CPU',230,130,20,muted);
  rule(104,'01  INPUT');rule(365,'02  PICTURE UPDATE');rule(748,'03  IMAGE PREPARE');
  rule(1110,'04  CLIP / IMAGE RLE');rule(1470,'05  DRAW / SAMPLING');rule(2840,'06  SURFACE');

  const load=stage('load','Picture::load()','file / raw pixels',220);
  const update=stage('update','canvas->update()','PictureImpl::update()',510);
  const prepare=stage('prepare','SwRenderer::prepare()','SwImageTask::run()',885,true);
  const clip=stage('clip','imageGenRle()','if clips.count > 0',1290);
  const draw=stage('draw','canvas->draw()','renderImage() → done()',1610);
  const output=stage('output','Write Surface','coverage × opacity',3010,true);
  for(const [from,to] of [[272,458],[562,833],[937,1238],[1342,1558],[1662,2958]])route(scene,[[230,from],[230,to]]);

  // The original pixels remain stable in every band; ownership is a shared reference.
  const input=group('input',1);
  text(input,'SVG / Lottie',650,191,25);
  text(input,'Paint tree',650,236,20,muted);
  bitmap(input,model.source.pixels,model.source.w,model.source.h,1040,227,22);
  text(input,`Bitmap  ${model.source.w} × ${model.source.h}`,1040,318,22);

  // This fork is inside PictureImpl::update(), after load() resolves the Loader result.
  const dispatch=group('dispatch');
  route(dispatch,[[401,510],[535,510]]);
  dispatch.polygon({id:id('bitmap-condition'),points:[[650,450],[762,510],[650,570],[538,510]].map(v=>p(...v)),fill:'#ffffff',stroke:ink,width:1.7,layer:15});
  text(dispatch,'Bitmap?',650,510,24);
  route(dispatch,[[764,510],[879,510]]);text(dispatch,'No',817,483,19,muted);
  box(dispatch,'Paint tree','update() / render()',1050,510,310,95);
  route(dispatch,[[1030,560],[1030,592],[974,592],[974,610]],7);
  route(dispatch,[[1030,592],[1102,592],[1102,610]],7);
  dispatch.polygon({id:id('vector-shape-a'),points:[[974,621],[950,666],[998,666]].map(v=>p(...v)),fill:'#e66121',stroke:'#e66121',layer:20});
  rect(dispatch,1102,645,44,42,'#1f66c4','#1f66c4',1,20);
  route(dispatch,[[650,572],[650,610]]);text(dispatch,'Yes',700,591,19,muted);
  box(dispatch,'RenderSurface*','bitmap',650,661,265,82);
  const captured=group('captured');
  route(captured,[[650,704],[650,723],[425,723],[425,810],[230,810]],0);

  const prepared=group('prepared');
  text(prepared,'rasterConvertCS()',662,826,23);text(prepared,'rasterPremultiply()',1040,826,23);
  route(prepared,[[800,826],[886,826]]);
  const artifacts=group('image-artifacts');
  const area=grid(artifacts,654,968,model.target.w,model.target.h,18);
  const extent=artifacts.group({id:id('extent')});
  rect(extent,area.left+model.source.w*9,area.top+model.source.h*9,model.source.w*18,model.source.h*18,'#00000000',ink,2.5,27);
  box(artifacts,'SwImage','buf32 · w · h · stride',1038,942,322,128);
  text(artifacts,`ox = ${model.image.ox}  ·  oy = ${model.image.oy}`,1038,1040,22);
  text(artifacts,`translate(${model.transform[2]}, ${model.transform[5]})`,654,1074,21,muted);
  text(artifacts,'direct = true',1038,1074,21,muted);
  text(artifacts,'imagePrepare()',654,866,22);
  // A completed extent is a prepared coordinate range, never a written Canvas.
  const outlineReady=group('outline-ready');
  route(outlineReady,[[401,885],[442,885],[442,942],[520,942]]);

  // A separate straight-alpha pixel makes both normalization operations visible.
  // The opaque, already-aligned Bitmap fixture itself remains unchanged.
  const normalization=group('normalization');
  const channels={R:'#b8502d',G:'#467c58',B:'#286ea7',A:ink};
  function channel(parent,name,value,x,y) {
    const g=parent.group({id:id('channel')});
    const r=rect(g,x,y,68,80,'#ffffff',channels[name],1.2);
    text(g,name,x,y-14,17,channels[name],r);
    text(g,String(value),x,y+13,18,ink,r);
    return g;
  }
  const sourceChannels=['B','G','R','A'].map((name,i)=>channel(normalization,name,sample.source[i],548+i*72,950));
  const alphaInput=normalization.group({id:id('straight-input'),opacity:0});
  const alphaOutput=normalization.group({id:id('premultiplied-output'),opacity:0});
  const multiply=normalization.group({id:id('multiply'),opacity:0});
  ['R','G','B','A'].forEach((name,i)=>{
    channel(alphaInput,name,sample.aligned[i],925+i*74,936);
    channel(alphaOutput,name,sample.premultiplied[i],925+i*74,1030);
    route(multiply,[[925+i*74,978],[925+i*74,988]],6);
  });
  text(multiply,`RGB × ${sample.aligned[3]} / 256`,1036,876,20);
  text(normalization,'Pixel example · ARGB8888S → ABGR8888',843,1090,20,muted);

  const clipping=group('clipping');
  spans(clipping,model.image.initialSpans,591,1285,14);
  spans(clipping,model.clip.spans,843,1285,14);
  const result=spans(clipping,model.image.spans,1095,1285,14);
  text(clipping,'Image RLE',591,1196,23);text(clipping,'Clip RLE',843,1196,23);text(clipping,'image.rle',1095,1196,23);
  text(clipping,`${model.image.initialSpans.length} spans`,591,1370,21,muted);
  text(clipping,`${model.clip.spans.length} spans`,843,1370,21,muted);
  text(clipping,`${model.image.spans.length} spans`,1095,1370,21,muted);
  // Draw the intersection operator geometrically; the delivery font lacks this glyph.
  clipping.route({id:id('intersection'),points:[[707,1297],[707,1284],[710,1277],[717,1274],[724,1277],[727,1284],[727,1297]].map(v=>p(...v)),stroke:ink,width:2,tip:0,layer:25});
  text(clipping,'=',969,1285,28);
  text(clipping,'Start pixel = coverage  ·  Line = len',843,1410,22,muted);
  text(clipping,'No clip tasks → image.rle = nullptr',843,1450,18,muted);
  route(clipping,[[401,1290],[493,1290]]);

  // Independent dispatch branches, using the same checked buffers as Draw/Raster.
  const sampling=group('sampling'),cases=[],samplingData=buildScenarios(),reviewTimes=[];
  text(sampling,'Source',863,1540,20,muted);
  text(sampling,'Surface',1130,1540,20,muted);
  const definitions=[
    ['direct','Direct','integer offset','Copy'],
    ['texmap','TexMap','rotation / shear','UV → pixel'],
    ['nearest','Scaled/Nearest','nearest pixel','1 tap'],
    ['bilinear','Scaled/Bilinear','scale >= 0.5','4 taps → mix'],
    ['downscale','Scaled/ScaleDown','scale < 0.5','Sum / count'],
  ];
  route(sampling,[[401,1610],[440,1610],[440,2650]],0);
  const rgbaColor=rgba=>'#'+rgba.map(c=>c.toString(16).padStart(2,'0')).join('');
  for(const [i,[key,title,condition,operation]] of definitions.entries()) {
    const d=samplingData[key],cy=1650+i*250,c=12;
    const row=sampling.group({id:id('sampling-case')});
    box(row,title,condition,605,cy,280,100);
    route(row,[[440,cy],[462,cy]],6);
    if(i)row.line({id:id('case-divider'),from:p(465,cy-125),to:p(1230,cy-125),stroke:line,width:1,layer:3});
    const sg=grid(row,863,cy,d.source.width,d.source.height,c);
    const tg=grid(row,1130,cy,d.target.width,d.target.height,c);
    const at=(g,x,y)=>[g.left+(x+.5)*c,g.top+(y+.5)*c];
    d.source.pixels.forEach((rgba,j)=>rect(row,...at(sg,j%d.source.width,Math.floor(j/d.source.width)),c-.5,c-.5,rgbaColor(rgba),'#00000000',0,20));
    route(row,[[910,cy],[1045,cy]],7);
    text(row,operation,978,cy-32,18,muted);
    text(row,`${d.source.width} × ${d.source.height}`,863,cy+95,18,muted);
    text(row,`${d.target.width} × ${d.target.height}`,1130,cy+95,18,muted);
    const focus=row.group({id:id('tap-focus'),opacity:0});
    const step=d.steps.find(s=>s.taps.length>1&&s.taps.every(t=>t.weight>0))??d.steps[Math.floor(d.steps.length/2)];
    const payloads=step.taps.map(t=>{
      const g=row.group({id:id('sample-copy'),opacity:0});
      rect(focus,...at(sg,t.x,t.y),c,c,'#00000000','#222222',2,30);
      rect(g,...at(sg,t.x,t.y),c-.5,c-.5,rgbaColor(t.rgba),ink,1,35);
      return {g,from:at(sg,t.x,t.y)};
    });
    const dest=at(tg,step.x,step.y);
    rect(focus,...dest,c,c,'#00000000',ink,2,30);
    const sampled=row.group({id:id('sample-result'),opacity:0});
    rect(sampled,...dest,c-.5,c-.5,rgbaColor(step.rgba),'#00000000',0,24);
    const batches=[];
    for(const step of d.steps) {
      const batchKey=key==='texmap'?step.triangle+':'+step.y:String(step.y);
      let batch=batches.at(-1);
      if(!batch||batch.key!==batchKey){batch={key:batchKey,g:row.group({id:id('write-row'),opacity:0})};batches.push(batch);}
      rect(batch.g,...at(tg,step.x,step.y),c-.5,c-.5,rgbaColor(step.rgba),'#00000000',0,22);
    }
    const mesh=row.group({id:id('triangles'),opacity:0});
    if(d.vertices)for(const indices of d.triangles)mesh.polygon({id:id('triangle'),points:indices.map(j=>p(tg.left+d.vertices[j].x*c,tg.top+d.vertices[j].y*c)),fill:'#00000000',stroke:ink,width:1,layer:29});
    cases.push({key,focus,payloads,dest,sampled,batches,mesh});
  }
  text(sampling,'Independent branches · same display size per pixel',843,2795,20,muted);

  const surface=group('surface');
  const sx=573,sy=3008,tx=1083,ty=3008,cell=18;
  bitmap(surface,model.source.pixels,model.source.w,model.source.h,sx,sy,cell);
  text(surface,'Source',sx,2898,23);
  spans(surface,model.image.spans,803,sy,12);
  text(surface,'image.rle',803,2898,23);
  const targetGrid=grid(surface,tx,ty,model.target.w,model.target.h,cell,packedColor(model.target.background));
  text(surface,'Surface',tx,2898,23);
  // Source color and RLE coverage meet at the destination; RLE contains no color.
  route(surface,[[648,sy],[665,sy],[665,2930],[940,2930],[940,sy]],0);
  route(surface,[[891,sy],[940,sy]],0);
  route(surface,[[940,sy],[969,sy]],7);
  text(surface,`${model.source.w} × ${model.source.h}`,sx,3120,21,muted);
  text(surface,'x · y · len · coverage',803,3120,18,muted);
  text(surface,`${model.target.w} × ${model.target.h}`,tx,3120,21,muted);
  const targetRows=[];
  for(const span of model.image.spans) {
    const g=surface.group({id:id('target-span'),opacity:0});
    for(let n=0;n<span.len;n++) {
      const v=model.target.pixels[span.y*model.target.w+span.x+n];
      rect(g,targetGrid.left+(span.x+n+.5)*cell,targetGrid.top+(span.y+.5)*cell,cell-.65,cell-.65,packedColor(v),'#00000000',0,21);
    }
    targetRows.push(g);
  }
  const first=model.image.spans[0],sourceLeft=sx-model.source.w*cell/2,sourceTop=sy-model.source.h*cell/2;
  const proxy=group('source-span-copy');
  for(let n=0;n<first.len;n++) {
    const x=first.x+n+model.image.ox,y=first.y+model.image.oy;
    rect(proxy,sourceLeft+(x+.5)*cell,sourceTop+(y+.5)*cell,cell-.65,cell-.65,packedColor(model.source.pixels[y*model.source.stride+x]),ink,1,35);
  }

  // Full settled geometry precedes choreography; all dimensions derive from one fixture.
  show(load);beat('Public Picture load selects a Loader; Bitmap source pixels are retained.',1);
  show(update);show(dispatch);show(captured);
  beat('Picture update delegates Vector to its Paint tree and passes Bitmap Surface to prepare.',1.3);
  show(prepare);show(prepared);show(normalization);
  wait(.7);
  // R/B use separate vertical lanes, preserving each byte's identity and value.
  play([{target:sourceChannels[0],shift:[0,-.70]},{target:sourceChannels[2],shift:[0,.70]}],.45);
  play([{target:sourceChannels[0],shift:[1.44,0]},{target:sourceChannels[2],shift:[-1.44,0]}],.8);
  play([{target:sourceChannels[0],shift:[0,.70]},{target:sourceChannels[2],shift:[0,-.70]}],.45);
  wait(.6);show(alphaInput);show(multiply);show(alphaOutput,.6);
  beat('Separate pixel example: swap R/B bytes, then scale RGB by Alpha while preserving A.',1.4);
  hide(normalization,.35);show(artifacts);show(outlineReady);
  play([{target:extent,shift:[model.transform[2]*18/100,-model.transform[5]*18/100]}],1.05);
  beat('Image task normalizes Source representation and prepares transformed extent and Direct offsets.',1.5);
  show(clip);show(clipping);
  for(const glyph of result.glyphs) {
    scene.fadeIn(glyph.pixels,{duration:.045});time+=.045;
    scene.create(glyph.length,.055,'linear');time+=.055;
  }
  beat('Image outline becomes spans; clipping replaces image.rle with the intersection.',1.7);
  show(draw);show(sampling);
  for(const example of cases) {
    show(example.focus,.15);
    if(example.key==='texmap')show(example.mesh,.25);
    play(example.payloads.map(({g})=>({target:g,opacity:1})),.1);
    wait(.2);
    play(example.payloads.map(({g,from})=>({target:g,shift:[(example.dest[0]-from[0])/100,-(example.dest[1]-from[1])/100]})),.55);
    play(example.payloads.map(({g})=>({target:g,opacity:0})),.08);
    show(example.sampled,.1);reviewTimes.push(time);wait(.3);
    hide(example.focus,.1);
    for(const batch of example.batches)show(batch.g,.7/example.batches.length);
    if(example.key==='texmap')hide(example.mesh,.2);
    reviewTimes.push(time);wait(.35);
  }
  beat('Draw waits for its task; independent sampling examples copy, map UV, select a pixel, interpolate, or average.',1.7);
  show(output);show(surface);show(proxy,.15);
  play([{target:proxy,shift:[(targetGrid.left-sourceLeft-model.image.ox*cell)/100,-(targetGrid.top-sourceTop-model.image.oy*cell)/100]}],.9);
  hide(proxy,.1);
  for(const row of targetRows)show(row,.065);
  beat('Each final span reads Source color and combines coverage with opacity into the target Surface.',2.8);
  return {scene,width,height,duration:time,beats,reviewTimes,textIds,textPolicies,routes,nodeBounds,model};
}
