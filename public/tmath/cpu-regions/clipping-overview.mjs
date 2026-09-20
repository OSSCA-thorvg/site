import {overviewKit} from './overview-kit.mjs';
import {avatarModel,native} from './model.mjs';

// One Scene, four persistent names, native CPU data from API to final pixels.
export function buildClippingOverview(trace=native,{still=false}={}){
  const kind='clipping',m=avatarModel(trace),{w,h,a}=m,width=1440,height=3260;
  const {C,scene,text,line,scope,node,down,arrow,grid,packed,circle,route,write,section,violet,green,phases,handleCopy,field,rleGrid,scan,finish}=overviewKit(kind,{w,h,width,height,still});
  text('Clipping',40,55,36);text('ThorVG CPU Engine',460,55,27,C.muted);
  text('CALLER / CALL SCOPE',40,110,18,C.muted);text('ONE EXAMPLE · AVATAR IN A PROFILE CARD',460,110,18,C.muted);
  line([430,145],[430,3140]);

  // Public API and retained-state mutation, before a CPU clip task exists.
  scope(25,180,395,485,'Paint::clip(Shape* clipper)');
  const apiNodes=[node(44,250,357,60,['avatar->clip(roundClip)']),node(44,355,357,86,['Paint::Impl::clip()','clipper = roundClip']),node(44,505,357,86,['roundClip->ref()','return Result::Success'])];
  apiNodes.slice(1).forEach((n,i)=>down(apiNodes[i],n));
  arrow([223,674],[223,726],C.muted);
  scope(25,735,395,1870,'canvas->update()');
  const pre=node(44,800,357,86,['preUpdate()','clips.clear()']);
  const root=node(44,935,357,86,['root SceneImpl::update()','background → avatar']);down(pre,root);
  scope(44,1070,357,1300,'Paint::Impl::update()');
  const cp=node(60,1140,325,86,['roundClip->update()','clipper = true']);down(root,{x:44,y:1066,w:357,h:0});
  const push=node(60,1280,325,86,['RenderData rd = clip task','clips.push(rd)'],{size:19});down(cp,push);
  scope(60,1415,325,805,'SceneImpl::update()');down(push,{x:60,y:1410,w:325,h:0});
  const children=node(76,1490,293,86,['PictureImpl::update()','ShapeImpl::update()'],{size:19});
  const prepare=node(76,1660,293,86,['prepareCommon()','task->clips = clips'],{size:19});down(children,prepare);
  const wait=node(76,1840,293,60,['roundClip task->done()'],{size:19});down(prepare,wait);
  const request=node(76,2010,293,86,['TaskScheduler','::request(child task)'],{size:19});down(wait,request);
  const pop=node(60,2280,325,60,['clips.pop()']);down(request,pop);
  const restored=node(60,2395,325,60,['clips = []'],{size:19});down(pop,restored);
  const post=node(44,2525,357,60,['postUpdate()']);down(restored,post);
  arrow([223,2615],[223,2656],C.muted);
  scope(25,2665,395,440,'canvas->draw()');
  const draw=[node(44,2730,357,60,['SceneImpl::render()']),node(44,2840,357,86,['photo task->done()','renderImage() → RLE'],{dark:true}),node(44,2975,357,86,['badge task->done()','renderShape()'],{dark:true})];
  draw.slice(1).forEach((n,i)=>down(draw[i],n));
  node(44,3140,357,60,['canvas->sync()']);arrow([223,3115],[223,3132],C.muted);

  {
    const y=section(0,'API · A CLIPPED AVATAR SCENE');
    const code=[
      'auto avatar = Scene::gen();',
      'avatar->add(photo);   // Picture',
      'avatar->add(badge);   // Shape',
      'auto roundClip = Shape::gen();',
      `roundClip->appendCircle(${a.circle.join(', ')});`,
      'avatar->clip(roundClip);',
      'canvas->add(background);',
      'canvas->add(avatar);'
    ];
    code.forEach((s,i)=>text(s,475,y+100+i*40,21,i===5?violet:C.ink));
    text('clip() is inherited from Paint',475,y+500,21,C.blue);
    scope(1035,y+85,350,285,'avatar · Scene');
    const photo=grid(1055,y+180,packed(a.sourcePixels),'photo · Picture',{u:10});
    circle(1300,y+225,28,green,scene,green);
    text('badge',1255,y+293,20);text('Shape',1255,y+324,19,C.muted);
    text('roundClip · Shape',1035,y+416,21,violet);
    circle(1120,y+497,46,violet);
    route([[1360,y+370],[1360,y+497],[1178,y+497]],violet);
    text('Shape*',1260,y+545,19,violet);
    write(photo,phases[0],{start:.7,end:4.7});
  }
  {
    const y=section(1,'CLIPPER DATA · SHAPE REFERENCE → CPU TASK');
    node(475,y+95,385,115,['avatar · Paint::Impl','Shape* clipper = roundClip'],{size:20});
    node(1010,y+95,375,115,['roundClip · Paint::Impl','RenderData rd'],{size:20});
    arrow([880,y+151],[990,y+151],violet);
    text('API stores a Shape pointer',475,y+251,21,C.muted);
    text('RenderData = void*',1010,y+251,21,C.muted);
    node(475,y+298,385,86,['roundClip->update(..., true)','SwRenderer::prepare()'],{size:20});
    node(1010,y+274,375,105,['SwShapeTask','bool clipper = true','SwShape shape'],{size:20});
    arrow([880,y+341],[990,y+341],violet);
    handleCopy([1398,y+338],[1398,y+169],phases[1],1.4,3.2);
    route([[1389,y+338],[1405,y+338],[1405,y+169],[1393,y+169]],violet);
  }
  {
    const y=section(2,'SCENE TRAVERSAL · BOTH CHILDREN SHARE THE CLIP');
    text('avatar update: clips.push(roundClip.rd)',475,y+89,22);
    scope(475,y+128,370,193,'Array<RenderData> clips');
    field(495,y+222,'roundClip.rd',300);
    const photo=node(1040,y+100,340,115,['photo · SwImageTask','task->clips[0]','→ roundClip task'],{size:20});
    const badge=node(1040,y+254,340,115,['badge · SwShapeTask','task->clips[0]','→ same roundClip task'],{size:20});
    route([[856,y+237],[955,y+237],[955,y+163],[1028,y+163]],violet);
    route([[955,y+237],[955,y+316],[1028,y+316]],violet);
    handleCopy([815,y+252],[1022,y+194],phases[2],1.0,2.3);
    handleCopy([815,y+252],[1022,y+345],phases[2],3.0,4.3);
    node(475,y+378,370,86,['return from avatar','clips.pop()'],{size:20});
    node(1040,y+397,340,60,['clips = []'],{size:19});
    arrow([865,y+427],[1020,y+427],C.muted);
  }
  {
    const y=section(3,'ROUNDCLIP TASK · GEOMETRY → SWRLE → SWSPAN');
    const clip=rleGrid(475,y+112,a.clipSpans,'roundClip · shape.rle',{u:16,phase:phases[3],reveal:true});
    node(790,y+135,225,115,['SwRle','Array<SwSpan>','spans'],{size:20});
    arrow([751,y+199],[774,y+199],violet);
    text('x',1080,y+115,21);text('y',1150,y+115,21);text('len',1213,y+115,21);text('coverage',1284,y+115,20);
    m.spans.slice(0,3).forEach((s,j)=>s.forEach((v,k)=>text(String(v),[1080,1150,1213,1304][k],y+160+j*46,22)));
    text(`row y = ${Math.floor(m.sample.i/w)}`,1080,y+311,20,C.muted);
    text('shade = coverage · line = len',475,y+329,17,C.muted);
    node(475,y+354,460,86,['strokeRle = null · fastTrack = false','this circle selects shape.rle'],{size:20});
    node(1000,y+354,385,86,['SwShapeTask::clip(target)','rleClip(target, shape.rle)'],{size:20});
    arrow([950,y+397],[984,y+397],violet);
    scan(clip,phases[3]);
  }
  {
    const y=section(4,'CHILD TASKS · INTERSECT EACH RLE WITH ROUNDCLIP');
    const photoRaw=Array.from({length:h},(_,y)=>[0,y,w,255]);
    for(const [row,raw,out,title] of [[0,photoRaw,a.photoSpans,'photo · image.rle'],[1,a.badgeRawSpans,a.badgeSpans,'badge · shape.rle']]){
      const yy=y+115+row*215;
      const phase=phases[4]+row*.45;
      const input=rleGrid(475,yy,raw,title,{u:12});
      const clip=rleGrid(805,yy,a.clipSpans,'roundClip · shape.rle',{u:12});
      const result=rleGrid(1135,yy,out,row?'badge · clipped RLE':'photo · clipped RLE',{u:12,phase,reveal:true});
      text('×',716,yy+63,30,violet);arrow([1005,yy+63],[1115,yy+63],violet);
      scan(input,phase);scan(clip,phase);scan(result,phase);
    }
    text('coverage = (source coverage × clip coverage + 255) >> 8',475,y+504,22,C.blue);
  }
  {
    const y=section(5,'DRAW · BACKGROUND → PHOTO → SHAPE → RESULT');
    const bg=Array(w*h).fill(a.background);
    grid(475,y+135,packed(bg),'background',{u:12});
    const photo=grid(705,y+135,packed(a.photoPixels),'photo rendered',{u:12});
    const shape=grid(935,y+135,packed(a.finalPixels),'shape rendered',{u:12});
    grid(1165,y+135,packed(a.finalPixels),'result',{u:12});
    for(const x of [475,705,935])arrow([x+200,y+207],[x+222,y+207]);
    text('Main Surface',475,y+333,20,C.muted);
    text('renderImage()',705,y+333,20,C.blue);
    text('renderShape()',935,y+333,20,green);
    text('Final pixels',1165,y+333,20,C.muted);
    write(photo,phases[5],{start:.7,end:3.2,initial:packed(bg),scanCursor:false,hold:true});
    write(shape,phases[5],{rows:m.changedRows,start:3.6,end:6.4,initial:packed(a.photoPixels),scanCursor:false,hold:true});
    text('One Main Surface · pixels accumulate in draw order',475,y+423,22,C.muted);
  }
  text('ThorVG CPU · 4d5810cf · one native Scene example',460,3217,19,C.muted);
  return finish();
}
