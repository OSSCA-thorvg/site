import {tmath} from '../runtime/client.js';
import trace from '../postprocessing/native-trace.mjs';

// 4d5810cf: tvgCanvas.h::update, Paint::Impl::update, SceneImpl::update,
// PictureImpl::update, SwRenderer::prepareCommon, SwShapeTask/SwImageTask::run.
// This map expands call relationships; worker reveal order is not a schedule.
// Beats: API/target; inherited context; Paint dispatch; task submission;
// Shape artifacts; Image artifacts; postUpdate return and Draw's done barrier.
export function buildOverview() {
  const width=1280,height=2500,ink='#202020',muted='#626262',orange='#e66121',blue='#1f66c4';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(r=>[r,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const id=n=>`update-overview-${n}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,opacity=0)=>scene.group({id:id(name),opacity});
  function text(parent,value,x,y,size=22,color=ink,owner,align=[.5,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',size,fill:color,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill='#00000000',stroke=ink,border=1.5,layer=12) {
    const key=id('rect');const handle=parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:border,layer});
    return {id:key,handle};
  }
  function route(parent,points,dashed=false) {
    return parent.route({id:id('route'),points:points.map(([x,y])=>p(x,y)),stroke:ink,width:1.8,tip:9,...(dashed?{dash:[6,5]}:{}),layer:7});
  }
  // Dark nodes perform data preparation; white nodes carry the control flow.
  function node(name,x,y,title,detail,w=310,emphasized=false) {
    const g=group(name,.24),box=rect(g,x,y,w,94,emphasized?ink:'#ffffff');
    text(g,title,x,y-18,20,emphasized?'#ffffff':ink,box);
    text(g,detail,x,y+22,16,emphasized?'#e0e0e0':muted,box);
    return g;
  }
  function wait(d){scene.wait(d);time+=d;}
  function play(spec,d=.45){scene.play(spec,d,'ease_in_out');time+=d;}
  function show(g,d=.45){play([{target:g,opacity:1}],d);}
  function beat(label,hold=1.1){beats.push({time:+time.toFixed(3),label});wait(hold);}
  function triangle(parent,x,y,size,fill,stroke=orange) {
    const points=trace.tasks.find(t=>t.id==='A').points;
    return parent.polygon({id:id('triangle'),points:points.map(([a,b])=>p(x+a*size/24,y+b*size/24)),fill,stroke,width:2.2,layer:20});
  }

  // A caller spine and five separated reading bands. Shape and Image keep
  // the same columns from dispatch through their prepared artifacts.
  function rule(x1,y1,x2,y2) {
    scene.line({id:id('rule'),from:p(x1,y1),to:p(x2,y2),stroke:'#cccccc',width:1,layer:5});
  }
  function section(label,y) {
    rule(465,y,1230,y);
    text(scene,label,480,y+30,18,muted,undefined,[0,.5]);
  }
  text(scene,'Update / Prepare',240,49,30);
  text(scene,'API → tasks → prepared render data',856,49,25,muted);
  rule(36,87,1244,87);
  text(scene,'CALLER',220,130,18,muted);
  section('01  PAINT INPUTS',105);
  section('02  INHERITED CONTEXT',355);
  section('03  PAINT DISPATCH',600);
  section('04  PREPARE TASKS',1175);
  section('05  PREPARED DATA',1465);

  const api=node('api',220,225,'canvas->update()','Canvas::Impl::update()');
  const target=node('target',220,390,'preUpdate()','target Surface exists');
  const paint=node('paint',220,520,'Paint::Impl::update()','mask / clip → inheritance');
  const children=node('children',220,700,'SceneImpl::update()','for (paint : paints)');
  const common=node('common',220,1090,'prepareCommon()','clipBox · clip->done()');
  const request=node('request',220,1320,'Submit task','TaskScheduler::request()');
  const post=node('post',220,1600,'postUpdate()','status = Updating');
  const draw=node('draw',220,2220,'Draw: task->done()','renderShape / renderImage');
  for(const [a,b] of [[272,342],[438,472],[568,652],[1138,1272],[1368,1552],[1648,2172]])route(scene,[[220,a],[220,b]],true);

  const inputs=group('inputs',1);
  rect(inputs,560,235,84,62,'#ffffff',ink);
  text(inputs,'Rect',560,300,18);
  triangle(inputs,690,183,105,'#e661212a');text(inputs,'A',745,300,18,orange);
  rect(inputs,859,235,68,52,'#1f66c42a',blue,2);
  text(inputs,'B',859,300,18,blue);
  inputs.rectangle({id:id('scene-scope'),center:p(792,246),size:[2.32,1.48],fill:'#00000000',stroke:'#999999',width:1,dash:[6,5],layer:8});
  text(inputs,'Scene(A, B)',792,333,16,muted);
  const pixels=['#e66121','#1f66c4','#1f66c4','#e66121'];
  const imageInput=inputs.group({id:id('image-input')});
  imageInput.image({id:id('bitmap'),center:p(1090,235),width:.72,size:[2,2],pixels,filter:'nearest',layer:20});
  text(inputs,'Picture',1090,300,18);

  const context=group('inherited');
  text(context,'Transform',650,448,16,muted);
  text(context,'parent × local',650,487,20);
  text(context,'Update flags',1040,448,16,muted);
  text(context,'flags | renderFlag',1040,487,20);
  text(context,'opacity × parent',650,552,20);
  text(context,'clip stack',1040,552,20);
  route(context,[[377,520],[448,520]],true);

  // Compact fork: one entry, two aligned update calls, then explicit
  // Bitmap/Vector outputs. Vector re-entry is local, without an outer loop.
  const recursion=group('recursion');
  const entry=rect(recursion,850,700,330,56,'#ffffff',ink,1.2);
  text(recursion,'child Paint::update()',850,700,20,ink,entry);
  route(recursion,[[377,700],[684,700]],true);
  route(recursion,[[850,729],[850,757],[650,757],[650,789]],true);
  route(recursion,[[850,757],[1050,757],[1050,789]],true);
  function dispatchCall(name,x,title) {
    const g=group(name,.24),box=rect(g,x,820,310,60,'#ffffff',ink,1.2);
    text(g,title,x,820,20,ink,box);
    return g;
  }
  const shape=dispatchCall('shape',650,'ShapeImpl::update()');
  const picture=dispatchCall('picture',1050,'PictureImpl::update()');
  const bitmapBranch=group('bitmap-branch');
  route(bitmapBranch,[[650,851],[650,902]],true);
  text(bitmapBranch,'RenderShape',650,930,19);
  text(bitmapBranch,'load()',1050,881,17,muted);
  route(bitmapBranch,[[1050,899],[1050,914],[945,914],[945,939]],true);
  route(bitmapBranch,[[1050,914],[1145,914],[1145,939]],true);
  text(bitmapBranch,'Bitmap',945,965,18);
  text(bitmapBranch,'Vector',1145,965,18);
  route(bitmapBranch,[[1145,983],[1145,1000]],true);
  const vectorReturn=rect(bitmapBranch,1145,1035,168,68,'#ffffff','#999999',1);
  text(bitmapBranch,'child Paint',1145,1023,16,ink,vectorReturn);
  text(bitmapBranch,'update()',1145,1046,14,muted,vectorReturn);

  const join=group('prepare-join');
  route(join,[[650,951],[650,1010],[422,1010],[422,1090],[377,1090]],true);
  route(join,[[945,983],[945,1010],[650,1010]],true);
  text(join,'prepare()',650,1050,17,muted);

  const effects=group('effects');
  const effectBox=rect(effects,850,1120,750,84,'#ffffff','#cccccc',1);
  text(effects,'Scene effects?',580,1102,18,muted,effectBox);
  text(effects,'optional',580,1132,16,muted,effectBox);
  text(effects,'prepare(effect, matrix)',952,1102,20,ink,effectBox);
  text(effects,'parameters / extent',952,1132,18,muted,effectBox);

  const workShape=node('worker-shape',650,1320,'SwShapeTask::run(tid)','shapeGenRle() / fill / stroke',310,true);
  const workImage=node('worker-image',1050,1320,'SwImageTask::run(tid)','convertCS() / premultiply()',310,true);
  const dispatch=group('task-dispatch');
  route(dispatch,[[376,1320],[454,1320],[454,1250],[650,1250],[650,1271]],true);
  route(dispatch,[[650,1250],[1050,1250],[1050,1271]],true);
  text(scene,'workers may overlap',850,1410,17,muted);

  // Output columns have independent visual regions, captions and return ports.
  rule(850,1535,850,2040);
  text(scene,'SHAPE',650,1560,17,muted);
  text(scene,'IMAGE',1050,1560,17,muted);
  const shapeOutput=group('shape-artifacts');
  text(shapeOutput,'Rect',555,1620,19);text(shapeOutput,'RLE',750,1620,19);
  rect(shapeOutput,555,1710,92,92,'#ffffff',ink,1.5);
  text(shapeOutput,'fastTrack',555,1795,17,muted);
  const spanGroups=new Map();
  const spans=trace.tasks.find(t=>t.id==='A').spans,cell=5,left=690,top=1650;
  for(const [x,y,len,coverage] of spans){
    if(!spanGroups.has(y))spanGroups.set(y,shapeOutput.group({id:id('rle-row'),opacity:0}));
    const v=Math.round(242-(242-32)*coverage/255),c='#'+v.toString(16).padStart(2,'0').repeat(3);
    const row=spanGroups.get(y),begin=left+(x+.5)*cell,centerY=top+(y+.5)*cell;
    // Match Shape's span glyph: a start-pixel marker and a len-pixel line.
    row.line({id:id('rle-length'),from:p(begin,centerY),to:p(begin+len*cell,centerY),stroke:c,width:1.2,layer:20});
    rect(row,begin,centerY,2.4,2.4,c,'#00000000',0,21);
  }
  rect(shapeOutput,750,1710,120,120,'#00000000','#aaaaaa',1);
  text(shapeOutput,'spans',750,1795,17,muted);
  text(shapeOutput,'x · y · len · coverage',650,1865,19);
  text(shapeOutput,'+ strokeRle',650,1930,18,muted);
  text(shapeOutput,'+ fillPrepare() / SwFill',650,1975,18,muted);

  const imageOutput=group('image-artifacts');
  const origin=[964,1660],scale=2,size=28;
  const raw=imageOutput.group({id:id('raw-image')});
  raw.image({id:id('raw-quad'),center:p(origin[0]+size/2,origin[1]+size/2),width:size/100,size:[2,2],pixels,filter:'nearest',layer:20});
  const quad=imageOutput.group({id:id('transformed-extent'),opacity:0});
  rect(quad,1050,1710,size*scale,size*scale,'#00000000',blue,2,25);
  text(imageOutput,'imagePrepare()',1050,1620,20);
  text(imageOutput,'matrix → extent',1050,1795,19);
  text(imageOutput,'renderBox · direct / scaled',1050,1865,18);
  text(imageOutput,'+ RLE when clipped',1050,1930,18,muted);
  const imageGuide=group('image-guide');
  route(imageGuide,[[1100,1674],[1145,1674],[1145,1738]],true);
  const converted=group('source-converted');text(converted,'source bytes normalized',1050,1975,18,muted);

  const returnLabel=group('update-return');
  const returnNote=rect(returnLabel,220,1480,230,56,'#f2f2f2','#00000000',0);
  text(returnLabel,'no global wait',220,1480,18,muted,returnNote);
  const prepared=group('prepared-dependency');
  route(prepared,[[650,2045],[650,2130],[420,2130],[420,2220],[377,2220]],true);
  route(prepared,[[1050,2045],[1050,2130],[650,2130]],true);
  text(prepared,'prepared data',850,2200,20,muted);
  rule(36,2355,1244,2355);
  text(scene,'NEXT',640,2395,17,muted);
  text(scene,'Draw / Raster → Postprocessing',640,2440,24);
  text(scene,'Update prepares data; Canvas pixels are written during Draw.',640,2480,17,muted);

  show(api);show(target);beat('Canvas update checks the configured target.');
  show(paint);show(context);beat('Paint combines inherited matrix, flags, opacity and clips.');
  show(children);show(recursion);show(shape);show(picture);show(bitmapBranch);
  show(effects);beat('Scene visits child Paints; Shape and Picture select their update paths.');
  show(join);show(common);show(request);show(dispatch);show(post);show(returnLabel);show(workShape);show(workImage);
  beat('Task inputs are captured; clip dependencies complete before submission.');
  show(shapeOutput);
  for(const row of spanGroups.values())show(row,.11);
  beat('Rect bounds or RLE spans become reusable Shape data.');
  show(imageOutput);show(imageGuide);
  play([{target:raw,shift:[(1050-origin[0]-size/2)/100,(origin[1]+size/2-1710)/100]}],.8);
  show(quad);show(converted);
  beat('Image preparation classifies its transform and clips its extent.');
  show(prepared);show(draw);
  beat('Update returns; Draw waits for each prepared task before rasterizing.',2.4);
  return {scene,beats,textIds,textPolicies,duration:time};
}
