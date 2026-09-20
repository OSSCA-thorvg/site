import {tmath} from '../runtime/client.js';
import {traceGradient} from '../raster/model.mjs';
import {color} from '../raster/scenes.mjs';

// ThorVG 4d5810cf: SwShapeTask::run → fillPrepare (SwFill allocation/reset).
// A single stop short-circuits geometry; degenerate Linear/Radial geometry can
// also mark the fill solid. Only a non-solid fill follows the table lookup path.
// The Linear/RLE output reuses the independently regenerated native fixture.
// Six persistent beats; branch reveals compare alternatives, not execution time.
export function buildOverview(data=traceGradient()) {
  const width=1280,height=2000,ink='#202020',muted='#626262';
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2'}});
  const textIds=[],textPolicies={},beats=[],routes=[],nodeBounds=[];
  let serial=0,time=0;
  const id=name=>`fill-overview-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,opacity=0)=>scene.group({id:id(name),opacity});
  function text(parent,value,x,y,size=22,fill=ink,owner=null,align=[.5,.5]) {
    const key=id('text');textIds.push(key);
    textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
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
  const beat=(label,hold=1.1)=>{beats.push({time:+time.toFixed(3),label});wait(hold);};

  text(scene,'Fill',230,50,34);
  text(scene,'Gradient: API → Prepare → Draw',850,50,27,muted);
  scene.line({id:id('header'),from:p(40,91),to:p(1240,91),stroke:'#cccccc',width:1,layer:3});
  text(scene,'API / CPU',230,135,19,muted);
  rule(105,'01  FILL INPUT');rule(510,'02  PREPARED DATA');
  rule(1205,'03  NON-SOLID: POSITION → COLOR');rule(1615,'04  COLOR + COVERAGE');

  const api=group('api',1);
  box(api,230,285,340,104,'Shape::fill(Fill*)','attach Gradient');
  box(api,600,285,220,90,'Fill','shared interface',true);
  box(api,1030,215,330,90,'LinearGradient','start / end points');
  box(api,1030,355,330,90,'RadialGradient','start / end circles');
  route(api,[[400,285],[490,285]]);
  route(api,[[710,285],[780,285]],0);
  route(api,[[780,285],[780,215],[865,215]]);
  route(api,[[780,285],[780,355],[865,355]]);
  text(api,'ColorStops · spread · transform',850,450,22,muted);

  const prepare=group('prepare');
  box(prepare,230,695,340,104,'SwShapeTask::run()','Update / Prepare',true);
  route(prepare,[[230,337],[230,643]]);
  text(prepare,'SwFill*& + Gradient',850,592,21);
  route(prepare,[[850,614],[850,630]]);
  box(prepare,850,670,350,80,'fillPrepare()','allocate / reset SwFill');
  route(prepare,[[400,695],[455,695],[455,592],[705,592]]);
  const artifacts=group('artifacts');
  route(artifacts,[[850,710],[850,735]],0);
  route(artifacts,[[850,735],[665,735],[665,760]]);
  route(artifacts,[[850,735],[1060,735],[1060,760]]);
  const table=rect(artifacts,665,860,300,200);
  text(artifacts,'SwFill::ctable',665,798,22,ink,table);
  text(artifacts,`${data.colorTable.length} colors`,665,832,18,muted,table);
  for(let i=0;i<240;i++)rect(artifacts,545+i+.5,873,1,30,
    color(data.colorTable[Math.floor(i*data.colorTable.length/240)]),'#00000000',0,20);
  text(artifacts,'update when dirty',665,928,18,muted,table);
  const coefficients=rect(artifacts,1060,860,300,200);
  text(artifacts,'SwFill geometry',1060,798,22,ink,coefficients);
  text(artifacts,'_prepareLinear()',1060,843,20,ink,coefficients);
  text(artifacts,'_prepareRadial()',1060,886,20,ink,coefficients);
  text(artifacts,'transform → coefficients',1060,928,17,muted,coefficients);

  const solid=rect(artifacts,850,1080,700,150);
  text(artifacts,'Solid shortcut → rasterShape() / rasterStroke()',850,1035,22,ink,solid);
  text(artifacts,'One stop: return before geometry and table preparation',850,1080,20,muted,solid);
  text(artifacts,'Degenerate geometry → last stop via fillFetchSolid()',850,1125,20,muted,solid);
  route(artifacts,[[1025,670],[1230,670],[1230,1080],[1200,1080]]);
  const draw=group('draw');
  box(draw,230,1330,340,104,'renderShape()','Draw · task->done()');
  route(draw,[[230,747],[230,1278]]);
  box(draw,850,1290,420,80,'rasterGradientShape()','Rect or RLE',true);
  route(draw,[[400,1330],[430,1330],[430,1290],[640,1290]]);
  box(draw,650,1400,300,80,'fillLinear()','linear position');
  box(draw,650,1520,300,80,'fillRadial()','radial position');
  route(draw,[[850,1330],[850,1345],[475,1345],[475,1400]],0);
  route(draw,[[475,1400],[500,1400]]);
  route(draw,[[475,1400],[475,1520],[500,1520]]);
  box(draw,1060,1460,300,100,'Color table lookup','position + spread');
  route(draw,[[800,1400],[850,1400],[850,1460]],0);
  route(draw,[[800,1520],[850,1520],[850,1460]],0);
  route(draw,[[850,1460],[910,1460]]);
  text(draw,'Pad · Repeat · Reflect',1060,1550,19,muted);

  const inputs=group('write-inputs'),output=group('output');
  box(inputs,230,1770,340,104,'Write Surface','sampled color + coverage',true);
  route(inputs,[[230,1382],[230,1718]]);
  text(inputs,'Shape: RLE',600,1685,21);
  text(inputs,'Color table',850,1685,21);
  text(inputs,'Surface',1100,1685,21);
  const cell=14,w=data.target.width,h=data.target.height;
  const top=1770-h*cell/2,areaLeft=600-w*cell/2,outLeft=1100-w*cell/2;
  rect(inputs,600,1770,w*cell,h*cell,'#ffffff','#aaaaaa',1);
  for(const span of data.spans) {
    const start=areaLeft+(span.x+.5)*cell,y=top+(span.y+.5)*cell;
    const v=Math.round(242-(242-32)*span.coverage/255),shade=color([v,v,v,255]);
    inputs.line({id:id('span-length'),from:p(start,y),to:p(start+span.len*cell,y),stroke:shade,width:1.2,layer:21});
    rect(inputs,start,y,3,3,shade,'#00000000',0,22);
  }
  text(inputs,'+',730,1770,27,muted);
  for(let i=0;i<150;i++)rect(inputs,775+i+.5,1770,1,28,
    color(data.colorTable[Math.floor(i*data.colorTable.length/150)]),'#00000000',0,20);
  route(inputs,[[950,1770],[1015,1770]]);
  for(let y=0;y<h;y++)for(let x=0;x<w;x++)rect(inputs,outLeft+(x+.5)*cell,top+(y+.5)*cell,
    cell-.6,cell-.6,(x+y)%2?'#e0e4e6':'#fafafa','#00000000',0,10);
  const rows=new Map();
  for(const step of data.steps) {
    if(!rows.has(step.y))rows.set(step.y,output.group({id:id('write-row'),opacity:0}));
    rect(rows.get(step.y),outLeft+(step.x+.5)*cell,top+(step.y+.5)*cell,
      cell-.6,cell-.6,color(step.rgba),'#00000000',0,20);
  }
  text(inputs,'x · y · len · coverage',600,1870,17,muted);
  text(inputs,'position → color',850,1870,17,muted);
  text(inputs,'Linear + RLE example',1100,1870,17,muted);
  text(scene,'Gradient defines color; Shape supplies the area and coverage.',640,1950,23,muted);

  beat('Fill exposes shared settings and two Gradient geometries.');
  show(prepare);beat('Update prepares the Shape fill.');
  show(artifacts);beat('Non-solid fills prepare a table and geometry; solid fills take the shortcut.',1.5);
  show(draw);beat('Draw chooses Linear or Radial lookup and applies spread.',1.5);
  show(inputs);beat('RLE coverage and Gradient colors are independent inputs.');
  show(output,.01);
  for(const row of rows.values())show(row,.15);
  beat('The native-checked Linear example writes the covered Surface pixels.',2.5);
  return {scene,beats,textIds,textPolicies,routes,nodeBounds,data,duration:time};
}
