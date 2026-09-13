import {tmath} from '../runtime/client.js';
import glyphs from './native-trace.mjs';
import output from './delegation-trace.mjs';
import {pathCommands} from './glyphs.mjs';

// TextImpl::update/load/render -> Paint::Impl dispatch -> ShapeImpl -> SwRenderer.
// One retained Shape owns the ABC path and its rd across both calls.
// Native fixture: solid fill, no outline/mask, 0 workers. Timings illustrate
// delegation, not the runtime duration or an asynchronous worker schedule.
export function buildDelegation({still=false}={}) {
  const width=1280,height=1040,ink='#202020',muted='#626262',blue='#1f66c4';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const id=name=>`font-delegation-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,opacity=0)=>scene.group({id:id(name),opacity:still?1:opacity});
  function text(parent,value,x,y,size=22,color=ink,owner,align=[.5,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),align,font:'Pretendard',role:'text',size,fill:color,layer:50});
  }
  function rect(parent,x,y,w,h,fill='#ffffff',stroke=ink,layer=15) {
    const key=id('rect');parent.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.5,layer});return {id:key};
  }
  function arrow(parent,points,color=ink,dashed=false) {
    return parent.route({id:id('route'),points:points.map(([x,y])=>p(x,y)),stroke:color,width:1.8,tip:9,...(dashed?{dash:[6,5]}:{}),layer:25});
  }
  function node(name,x,y,title,detail,w=300) {
    const g=group(name,.24),box=rect(g,x,y,w,94);
    text(g,title,x,y-15,22,ink,box);text(g,detail,x,y+23,17,muted,box);
    return g;
  }
  function wait(duration){scene.wait(duration);time+=duration;}
  function reveal(target,duration=.45){scene.play([{target,opacity:1}],duration,'ease_in_out');time+=duration;}
  function connect(target,duration=.65){scene.create(target,duration,'linear');time+=duration;}
  function beat(label,hold=1.2){beats.push({time:+time.toFixed(3),label});wait(hold);}

  text(scene,'Text → Shape delegation',50,44,32,ink,undefined,[0,.5]);
  text(scene,'Update / Draw',1230,44,23,muted,undefined,[1,.5]);
  scene.line({id:id('rule'),from:p(50,80),to:p(1230,80),stroke:'#cccccc',width:1,layer:5});
  text(scene,'Text("ABC")',205,127,26);
  text(scene,'Internal Shape',625,127,24);
  text(scene,'CPU Engine',1075,127,24);
  const owned=rect(scene,625,478,360,640,'#00000000','#aaaaaa',10);
  text(scene,'TextImpl::shape',625,187,23,ink,owned);

  const textUpdate=node('text-update',205,256,'TextImpl::update()','load() · text properties');
  const shapeUpdate=node('shape-update',625,256,'ShapeImpl::update()','via Paint::Impl::update()');
  const prepare=node('prepare',1075,256,'SwRenderer::prepare()','Shape RenderData',330);
  const updateCall=arrow(scene,[[356,256],[474,256]],blue);
  const prepareCall=arrow(scene,[[776,256],[909,256]],blue);
  const argumentsGroup=group('arguments');
  text(argumentsGroup,'renderer · transform · clips',625,323,18,muted,owned);
  text(argumentsGroup,'opacity · flag',625,351,18,muted,owned);

  const path=group('retained-path');
  text(path,'ShapeImpl::rs.path',625,383,20);
  const size=.06,origin=625-glyphs.ABC.glyphs.at(-1).nextCursor[0]*size/2;
  for(const commands of pathCommands(glyphs.ABC.result,([x,y])=>p(origin+x*size,493+y*size))) {
    path.path({id:id('glyph-contour'),commands,fill:'#00000000',stroke:ink,width:1.5,layer:20});
  }
  text(path,`${output.commands} cmds · ${output.points} pts`,625,521,19,muted);

  const data=group('render-data');
  const slot=rect(data,625,588,150,60,ink);
  text(data,'impl.rd',625,588,22,'#ffffff',slot);
  const task=group('shape-task');
  text(task,'SwShapeTask',1075,352,23);
  text(task,'RLE · x / y / len / coverage',1075,385,17,muted);
  const grid={x:931,y:416,scale:3};
  rect(task,1075,grid.y+output.height*grid.scale/2,output.width*grid.scale,output.height*grid.scale,'#00000000','#cccccc');
  for(const [x,y,len,coverage] of output.spans) {
    const value=Math.round(242-(242-32)*coverage/255),color='#'+value.toString(16).padStart(2,'0').repeat(3);
    const start=grid.x+(x+.5)*grid.scale,cy=grid.y+(y+.5)*grid.scale;
    task.line({id:id('span'),from:p(start,cy),to:p(start+len*grid.scale,cy),stroke:color,width:1.1,layer:20});
    rect(task,start,cy,1.7,1.7,color,'#00000000',21);
  }
  text(task,`${output.spans.length} spans`,931,584,17,muted,undefined,[0,.5]);
  const returnData=arrow(scene,[[1075,561],[1075,616],[860,616],[860,588],[701,588]],muted,true);
  const returnLabel=group('returned-handle');text(returnLabel,'rd',851,561,17,muted);

  scene.line({id:id('draw-rule-left'),from:p(50,646),to:p(415,646),stroke:'#cccccc',width:1,layer:5});
  text(scene,'Draw',205,662,18,muted);
  const textDraw=node('text-draw',205,736,'TextImpl::render()','Shape reference');
  const shapeDraw=node('shape-draw',625,736,'ShapeImpl::render()','via Paint::Impl::render()');
  const render=node('render',1075,736,'renderShape(rd)','SwRenderer · task->done()',330);
  const drawCall=arrow(scene,[[356,736],[474,736]],blue);
  const renderCall=arrow(scene,[[776,736],[909,736]],blue);
  const reuse=arrow(scene,[[625,619],[625,688]],muted,true);
  const taskRead=arrow(scene,[[1075,616],[1075,688]],muted,true);
  const raster=group('raster');
  text(raster,'rasterShape()',1075,818,20);
  const pixels=group('canvas-output');
  text(pixels,`Canvas · ${output.width} × ${output.height}`,931,855,18,muted,undefined,[0,.5]);
  const canvasY=886;
  // Composite native premultiplied ABGR bytes onto white for presentation.
  // Supplying opaque RGB avoids applying alpha twice in the Image API.
  const rgba=output.pixels.map(pixel=>'#'+[pixel&255,(pixel>>>8)&255,(pixel>>>16)&255].map(v=>Math.min(255,v+255-(pixel>>>24)).toString(16).padStart(2,'0')).join('')+'ff');
  rect(pixels,1075,canvasY+output.height*2.5/2,output.width*2.5,output.height*2.5,'#ffffff','#cccccc');
  pixels.image({id:id('native-output'),center:p(1075,canvasY+output.height*2.5/2),width:output.width*2.5/100,size:[output.width,output.height],pixels:rgba,filter:'nearest',layer:25});
  const completed=group('shared-pipeline');
  text(completed,'Same Shape · same rd',625,866,23);
  text(completed,'Shared Shape rendering',625,904,20,muted);
  text(scene,'Public Sans · ABC · solid fill',50,1016,17,muted,undefined,[0,.5]);

  if(still){beat('One retained Shape handles both calls',1);return {scene,textIds,textPolicies,beats};}
  beat('Text holds one internal Shape',1.2);
  reveal(textUpdate);reveal(path,.8);beat('Load the glyph path into the owned Shape',1.1);
  connect(updateCall);reveal(shapeUpdate,.3);reveal(argumentsGroup,.3);beat('Update delegates through Paint to Shape',1.2);
  connect(prepareCall);reveal(prepare,.3);reveal(task,.7);connect(returnData,.5);reveal(data,.25);reveal(returnLabel,.25);
  beat('Prepare produces the Shape task and stores rd',1.5);
  reveal(textDraw,.3);connect(drawCall);reveal(shapeDraw,.3);connect(reuse,.45);beat('Draw uses the same Shape and its rd',1.2);
  connect(renderCall);connect(taskRead,.45);reveal(render,.3);reveal(raster,.3);reveal(pixels,.7);reveal(completed,.4);
  beat('The common Shape renderer writes the Canvas',2.5);
  return {scene,textIds,textPolicies,beats};
}
