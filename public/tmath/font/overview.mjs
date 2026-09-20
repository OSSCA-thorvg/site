import {tmath} from '../runtime/client.js';
import glyphs from './native-trace.mjs';
import baseline from './delegation-trace.mjs';
import {pathCommands,verifyTrace} from './glyphs.mjs';

// Local b4471844: TextImpl constructor/load/update/render; SfntLoader::_build,
// wrapNone/request/get; ShapeImpl update/render; SwRenderer prepare/renderShape.
// Exact Public Sans ABC paths and CPU pixels are the fixtures revalidated byte-for-byte at 4d5810cf.
// Six beats: text/font; glyph loading; append to one Shape; common Prepare;
// Draw reads the same rd; native Surface output. Visibility is presentation order,
// not a worker schedule. Glyphs accumulate in place; no travelling copies.
export function buildOverview(output=baseline) {
  const trace=glyphs.ABC;
  verifyTrace(trace);
  const width=1280,height=2080,ink='#202020',muted='#626262';
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2'}});
  const textIds=[],textPolicies={},beats=[],routes=[],nodeBounds=[];
  let serial=0,time=0;
  const id=name=>`font-overview-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,opacity=0)=>scene.group({id:id(name),opacity});
  function text(parent,value,x,y,size=22,fill=ink,owner=null,align=[.5,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill='#ffffff',stroke=ink,border=1.5,layer=15) {
    const key=id('rect');
    return {id:key,handle:parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:border,layer})};
  }
  function box(parent,x,y,w,h,title,detail='',dark=false) {
    const r=rect(parent,x,y,w,h,dark?ink:'#ffffff');
    nodeBounds.push({id:r.id,x:x-w/2,y:y-h/2,width:w,height:h});
    text(parent,title,x,y-(detail?17:0),22,dark?'#ffffff':ink,r);
    if(detail)text(parent,detail,x,y+(h<=90?15:21),17,dark?'#dddddd':muted,r);
    return r;
  }
  function route(parent,points,tip=9) {
    const key=id('route');routes.push({id:key,points,tip});
    parent.route({id:key,points:points.map(([x,y])=>p(x,y)),stroke:ink,width:1.8,tip,layer:7});
  }
  function rule(y,label) {
    scene.line({id:id('rule'),from:p(455,y),to:p(1235,y),stroke:'#cccccc',width:1,layer:3});
    text(scene,label,475,y+30,19,muted,null,[0,.5]);
  }
  const wait=d=>{scene.wait(d);time+=d;};
  const show=(target,d=.45)=>{scene.play([{target,opacity:1}],d,'linear');time+=d;};
  const beat=(label,hold=1.2)=>{beats.push({time:+time.toFixed(3),label});wait(hold);};
  const bounds=path=>{
    const xs=path.pts.map(v=>v[0]),ys=path.pts.map(v=>v[1]);
    return {x0:Math.min(...xs),x1:Math.max(...xs),y0:Math.min(...ys),y1:Math.max(...ys)};
  };
  function outlines(parent,path,convert) {
    for(const commands of pathCommands(path,convert))parent.path({id:id('contour'),commands,
      fill:'#00000000',stroke:ink,width:1.5,layer:22});
  }

  text(scene,'Font / Text',230,50,34);
  text(scene,'Glyphs → one Shape → CPU rendering',850,50,26,muted);
  scene.line({id:id('header'),from:p(40,91),to:p(1240,91),stroke:'#cccccc',width:1,layer:3});
  text(scene,'API / CPU',230,135,19,muted);
  rule(105,'01  TEXT INPUT');rule(430,'02  FONT LOADER');
  rule(795,'03  ONE RETAINED SHAPE');rule(1220,'04  SHAPE PREPARE');rule(1550,'05  SHARED DRAW');

  const api=group('api',1);
  box(api,230,260,340,104,'Text','text · font · size',true);
  box(api,650,260,300,104,'UTF-8 string',`"${trace.text}"`);
  box(api,1070,260,300,104,'Font resource','Public Sans · TTF');
  route(api,[[400,260],[500,260]]);
  route(api,[[430,260],[430,340],[1070,340],[1070,312]]);
  text(api,'Loaded font + text settings',850,370,22,muted);

  const load=group('load');
  box(load,230,570,340,104,'TextImpl::update()','load() if changed');
  route(load,[[230,312],[230,518]]);
  box(load,850,530,360,90,'SfntLoader::get()','wrapNone() in this example');
  route(load,[[400,570],[450,570],[450,530],[670,530]]);
  text(load,'request(codepoint) · outline + advance',850,613,20,muted);
  for(const [index,glyph] of trace.glyphs.entries()) {
    const cx=640+index*210,cy=690,b=bounds(glyph.path);
    const scale=Math.min(88/(b.x1-b.x0),88/(b.y1-b.y0));
    outlines(load,glyph.path,([x,y])=>p(cx+(x-(b.x0+b.x1)/2)*scale,cy+(y-(b.y0+b.y1)/2)*scale));
    text(load,`glyph ${glyph.letter}`,cx,758,18,muted);
  }

  const shape=group('shape');
  box(shape,230,980,340,104,'TextImpl::shape','one owned Shape',true);
  route(shape,[[230,622],[230,928]]);
  const pathBox=rect(shape,850,985,740,260);
  text(shape,'ShapeImpl::rs.path · RenderPath',850,884,23,ink,pathBox);
  route(shape,[[400,980],[480,980]]);
  const b=bounds(trace.result),scale=Math.min(490/(b.x1-b.x0),112/(b.y1-b.y0));
  const convert=([x,y])=>p(850+(x-(b.x0+b.x1)/2)*scale,990+(y-(b.y0+b.y1)/2)*scale);
  const placed=[];
  for(const glyph of trace.glyphs) {
    const g=shape.group({id:id('placed-glyph'),opacity:0});placed.push(g);
    outlines(g,{cmds:trace.result.cmds.slice(...glyph.cmdRange),pts:trace.result.pts.slice(...glyph.pointRange)},convert);
  }
  const counts=group('path-counts');
  text(counts,`${trace.result.cmds.length} commands · ${trace.result.pts.length} points`,850,1085,19,muted,pathBox);
  text(shape,'_build(): point + cursor + offset',850,1155,22,muted);

  const prepare=group('prepare');
  box(prepare,230,1360,340,104,'ShapeImpl::update()','shared Shape preparation');
  route(prepare,[[230,1032],[230,1308]]);
  box(prepare,680,1320,340,90,'SwRenderer::prepare()','Shape RenderData');
  box(prepare,1090,1320,300,90,'SwShapeTask','RLE · Fill / Stroke',true);
  route(prepare,[[400,1360],[455,1360],[455,1320],[510,1320]]);
  route(prepare,[[850,1320],[940,1320]]);
  box(prepare,680,1450,340,90,'Shape RenderData','ShapeImpl::impl.rd');
  route(prepare,[[1090,1365],[1090,1450],[850,1450]]);
  text(prepare,'Task handle retained for Draw',850,1525,20,muted);

  const draw=group('draw');
  box(draw,230,1690,340,104,'TextImpl::render()','same Shape · same rd');
  route(draw,[[230,1412],[230,1638]]);
  box(draw,680,1650,340,90,'ShapeImpl::render()','via Paint::Impl::render()');
  box(draw,1090,1650,300,90,'renderShape(rd)','task->done() → Raster',true);
  route(draw,[[400,1690],[450,1690],[450,1650],[510,1650]]);
  route(draw,[[850,1650],[940,1650]]);
  text(draw,'Shape RLE',680,1740,22);
  text(draw,'Surface',1090,1740,22);
  const cell=3,w=output.width,h=output.height,cy=1840;
  const gridLeft=680-w*cell/2,gridTop=cy-h*cell/2;
  rect(draw,680,cy,w*cell,h*cell,'#ffffff','#cccccc',1);
  rect(draw,1090,cy,w*cell,h*cell,'#ffffff','#cccccc',1);
  for(const [x,y,len,coverage] of output.spans) {
    const value=Math.round(242-(242-32)*coverage/255),shade='#'+value.toString(16).padStart(2,'0').repeat(3);
    const start=gridLeft+(x+.5)*cell,row=gridTop+(y+.5)*cell;
    draw.line({id:id('span'),from:p(start,row),to:p(start+len*cell,row),stroke:shade,width:1,layer:22});
    rect(draw,start,row,1.5,1.5,shade,'#00000000',0,23);
  }
  route(draw,[[850,cy],[920,cy]]);
  text(draw,`${output.spans.length} spans`,680,1960,18,muted);
  text(draw,`${w} × ${h} · x = ${output.x}`,1090,1960,18,muted);
  const outputGroup=group('surface');
  box(outputGroup,230,1930,340,104,'Write Surface','common Shape raster',true);
  route(outputGroup,[[230,1742],[230,1878]]);
  const rows=[];
  for(let y=0;y<h;y++) {
    // Display captured premultiplied ABGR pixels on white, preserving native alpha.
    const pixels=output.pixels.slice(y*w,(y+1)*w).map(pixel=>'#'+[pixel&255,(pixel>>>8)&255,(pixel>>>16)&255]
      .map(v=>Math.min(255,v+255-(pixel>>>24)).toString(16).padStart(2,'0')).join(''));
    const row=outputGroup.group({id:id('pixel-row'),opacity:0});rows.push(row);
    row.image({id:id('native-pixels'),center:p(1090,gridTop+(y+.5)*cell),width:w*cell/100,
      size:[w,1],pixels,filter:'nearest',layer:25});
  }
  text(scene,'One Text · one retained Shape · shared CPU rendering',640,2030,24,muted);

  beat('Text retains the string and font settings.');
  show(load);beat('The font loader supplies glyph paths and layout metrics.');
  show(shape);
  for(const glyph of placed)show(glyph,.35);
  show(counts,.2);beat('All glyph contours accumulate in one retained RenderPath.',1.5);
  show(prepare);beat('Shape preparation stores the task handle on the same Shape.',1.5);
  show(draw);beat('Draw delegates to Shape and waits for its prepared task.');
  show(outputGroup);
  for(const row of rows)show(row,.025);
  beat('The captured native Shape pipeline writes the text pixels.',2.5);
  return {scene,beats,textIds,textPolicies,routes,nodeBounds,trace,output,duration:time};
}
