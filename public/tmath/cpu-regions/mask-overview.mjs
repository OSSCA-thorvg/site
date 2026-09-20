import {overviewKit} from './overview-kit.mjs';
import {maskAvatarModel,native} from './model.mjs';

export function buildMaskOverview(trace=native,{still=false}={}){
  const {w,h,a,changedRows}=maskAvatarModel(trace);
  const k=overviewKit('mask',{w,h,still});
  const {C,scene,text,line,scope,node,down,arrow,grid,packed,blank,circle,route,write,section,violet,green,phases,handleCopy,rleGrid,scan,finish}=k;
  const gray=values=>values.map(v=>[255-v,255-v,255-v,255]);
  text('Mask',40,55,36);text('ThorVG CPU Engine',460,55,27,C.muted);
  text('CALLER / CALL SCOPE',40,110,18,C.muted);text('ONE EXAMPLE · A TRANSLUCENT AVATAR',460,110,18,C.muted);
  line([430,145],[430,3140]);
  scope(25,180,395,485,'Paint::mask()');
  const api=[node(44,250,357,86,['avatar->mask(fadeMask,','MaskMethod::Alpha)']),node(44,375,357,86,['Paint::Impl::mask()','allocate Mask']),node(44,505,357,86,['source / target / method','fadeMask->ref()'])];
  api.slice(1).forEach((n,i)=>down(api[i],n));arrow([223,674],[223,726],C.muted);
  scope(25,735,395,870,'canvas->update()');
  const pre=node(44,800,357,86,['preUpdate()','clips.clear()']);
  const root=node(44,925,357,60,['avatar Paint::Impl::update()'],{size:19});down(pre,root);
  const target=node(60,1035,325,86,['fadeMask->update()','opacity 255 · clipper false'],{size:19});down(root,target);
  scope(44,1160,357,340,'SceneImpl::update()');down(target,{x:44,y:1155,w:357,h:0});
  const compose=node(60,1225,325,86,['needComposition()','children opacity = 255'],{size:18});
  const children=node(60,1350,325,86,['photo / badge update()','prepareCommon()','TaskScheduler::request()'],{size:18});down(compose,children);
  const post=node(44,1520,357,60,['postUpdate()']);down(children,post);
  arrow([223,1614],[223,1637],C.muted);
  scope(25,1645,395,1460,'canvas->draw(true)');
  scope(44,1705,357,1340,'Paint::Impl::render()');
  const nodes=[
    node(60,1780,325,86,['target(Grayscale8)','beginComposite(None)'],{dark:true,size:19}),
    node(60,1900,325,60,['fadeMask->render()'],{dark:true,size:19}),
    node(60,2010,325,86,['beginComposite(Alpha)','recoverSfc + mask'],{size:19}),
    node(76,2210,293,86,['target(Color Surface)','beginComposite(None)'],{dark:true,size:18}),
    node(76,2340,293,86,['photo task->done()','renderImage()'],{dark:true,size:19}),
    node(76,2470,293,86,['badge task->done()','renderShape()'],{dark:true,size:19}),
    node(76,2670,293,86,['endComposite(group)','rasterDirectImage()'],{dark:true,size:19}),
    node(60,2910,325,86,['endComposite(mask)','restore context'],{size:19})
  ];
  scope(60,2135,325,685,'SceneImpl::render()');
  nodes.slice(1).forEach((n,i)=>{
    if(i===2)down(nodes[i],{x:60,y:2131,w:325,h:0});
    else down(nodes[i],n);
  });
  node(44,3140,357,60,['canvas->sync()']);arrow([223,3115],[223,3132],C.muted);
  {
    const y=section(0,'API · ONE MASK FOR THE AVATAR SCENE');
    const code=['auto avatar = Scene::gen();','avatar->add(photo);   // Picture','avatar->add(badge);   // Shape','auto fadeMask = Shape::gen();',`fadeMask->appendCircle(${a.circle.join(', ')});`,`fadeMask->fill(45, 160, 210, ${a.alpha});`,'avatar->mask(fadeMask,','    MaskMethod::Alpha);','canvas->add(avatar);'];
    code.forEach((s,i)=>text(s,475,y+100+i*40,21,i===6||i===7?violet:C.ink));
    text('Paint::mask(Paint*, MaskMethod)',475,y+510,21,C.blue);
    scope(1035,y+85,350,285,'avatar · Scene');
    const photo=grid(1055,y+180,packed(a.sourcePixels),'photo · Picture',{u:10});
    circle(1300,y+225,28,green,scene,green);text('badge',1255,y+293,20);text('Shape',1255,y+324,19,C.muted);
    text('fadeMask · Shape',1035,y+416,21,violet);
    circle(1120,y+497,46,'#2da0d2',scene,`#2da0d2${a.alpha.toString(16).padStart(2,'0')}`);
    route([[1360,y+370],[1360,y+497],[1178,y+497]],violet);
    text(`fill alpha ${a.alpha}`,1210,y+545,19,C.muted);write(photo,phases[0],{start:.7,end:4.7});
  }
  {
    const y=section(1,'MASK DATA · SOURCE, TARGET AND METHOD');
    node(475,y+95,385,115,['avatar · Paint::Impl','Mask* maskData'],{size:20});
    node(1000,y+75,385,214,['Mask','source = avatar','target = fadeMask','method = Alpha'],{size:20});
    arrow([880,y+151],[984,y+151],violet);
    text('API retains the target Paint',475,y+251,21,C.muted);
    node(475,y+300,385,86,['photo / badge RenderData','SwImageTask / SwShapeTask'],{size:19});
    node(1000,y+305,385,86,['fadeMask RenderData','SwShapeTask · clipper = false'],{size:19});
    route([[1389,y+180],[1405,y+180],[1405,y+348],[1393,y+348]],violet);
    handleCopy([1398,y+180],[1398,y+348],phases[1],1.4,3.2);
  }
  {
    const y=section(2,'UPDATE · MASK TARGET, THEN AVATAR CHILDREN');
    text('Scene Masking flag → children prepare at opacity 255',475,y+80,22);
    const mask=rleGrid(475,y+155,a.maskSpans,'fadeMask · shape.rle',{u:12,phase:phases[2],reveal:true});
    const photo=grid(805,y+155,packed(a.sourcePixels),'photo · image.buf32',{u:12});
    const badge=rleGrid(1135,y+155,a.badgeSpans,'badge · shape.rle',{u:12,phase:phases[2]+.5,reveal:true});
    node(475,y+345,265,86,['SwShapeTask','fill alpha stored'],{size:20});
    node(805,y+345,265,86,['SwImageTask','clips = []'],{size:20});
    node(1135,y+345,250,86,['SwShapeTask','clips = []'],{size:20});
    scan(mask,phases[2]);scan(photo,phases[2]);scan(badge,phases[2]+.5);
  }
  {
    const y=section(3,'DRAW MASK · GEOMETRY TO GRAYSCALE8');
    const mask=rleGrid(475,y+112,a.maskSpans,'fadeMask · shape.rle',{u:16});
    const buffer=grid(1080,y+112,gray(a.maskStorage),'Mask buffer · alpha bytes',{u:16});
    text(`fill alpha ${a.alpha}`,800,y+170,22,C.blue);arrow([760,y+225],[1058,y+225]);
    text('coverage × alpha',790,y+282,20,C.muted);
    node(475,y+365,420,86,['target(Grayscale8)','surface = Mask buffer'],{size:20});
    node(1000,y+365,385,86,['beginComposite(Alpha)','Main Surface + mask'],{size:20});
    arrow([913,y+408],[983,y+408]);scan(mask,phases[3]);write(buffer,phases[3],{initial:gray(Array(w*h).fill(0))});
  }
  {
    const y=section(4,'DRAW SCENE · PHOTO AND BADGE SHARE A COLOR SURFACE');
    scope(460,y+70,925,375,'SceneImpl::render() · group target');
    grid(475,y+170,blank,'cleared group',{u:14});
    const photo=grid(805,y+170,packed(a.sourcePixels),'photo rendered',{u:14});
    const badge=grid(1135,y+170,packed(a.groupPixels),'shape rendered',{u:14});
    arrow([720,y+253],[785,y+253]);arrow([1050,y+253],[1115,y+253]);
    text('Color Surface · ABGR8888 · children opacity 255',475,y+395,22,C.muted);
    write(photo,phases[4],{start:.7,end:3.2,initial:blank,scanCursor:false,hold:true});
    write(badge,phases[4],{rows:changedRows,start:3.6,end:6.4,initial:packed(a.sourcePixels),scanCursor:false,hold:true});
  }
  {
    const y=section(5,'COMPOSITE · READ MASK, WRITE GROUP, RESTORE');
    grid(475,y+135,packed(a.groupPixels),'group',{u:12});
    grid(705,y+135,gray(a.maskStorage),'mask alpha',{u:12});
    const composited=grid(935,y+135,packed(a.pixels),'composited',{u:12});
    grid(1165,y+135,packed(a.pixels),'result',{u:12});
    text('×',678,y+207,26,violet);arrow([905,y+207],[927,y+207]);arrow([1135,y+207],[1157,y+207]);
    text('ALPHA_BLEND(group pixel, mask byte)',475,y+350,22,C.blue);
    text('endComposite(group) writes · endComposite(mask) restores',475,y+423,21,C.muted);
    write(composited,phases[5],{initial:blank,scanCursor:false,hold:true});
  }
  text('ThorVG CPU · 4d5810cf · one native Scene example',460,3217,19,C.muted);
  return finish();
}
