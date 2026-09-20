import {overviewKit} from './overview-kit.mjs';
import {viewportAvatarModel,native} from './model.mjs';

export function buildViewportOverview(trace=native,{still=false}={}){
  const {w,h,a,b,rows,changedRows}=viewportAvatarModel(trace);
  const k=overviewKit('viewport',{w,h,still});
  const {C,scene,text,line,scope,node,down,arrow,grid,packed,blank,circle,route,write,section,green,phases,handleCopy,rleGrid,scan,regionBox,finish}=k;
  const bg=packed(Array(w*h).fill(a.background));
  const boundedScan=(g,phase)=>scan({...g,x:g.x+b[0]*g.u,y:g.y+b[1]*g.u,ww:(b[2]-b[0])*g.u},phase,{rows:rows.map(y=>y-b[1])});
  const bounds=`[${b[0]}, ${b[2]}) × [${b[1]}, ${b[3]})`;
  text('Viewport',40,55,36);text('ThorVG CPU Engine',460,55,27,C.muted);
  text('CALLER / CALL SCOPE',40,110,18,C.muted);text('ONE EXAMPLE · AN AVATAR UPDATE REGION',460,110,18,C.muted);
  line([430,145],[430,3140]);
  scope(25,180,395,485,'Canvas::viewport(x, y, w, h)');
  const api=[node(44,250,357,60,[`canvas->viewport(${a.requested.join(',')})`],{size:20}),node(44,355,357,86,['intersect target bounds','renderer->viewport(region)'],{size:19}),node(44,505,357,86,['CanvasImpl::vport = region','status = Damaged'],{size:19})];
  api.slice(1).forEach((n,i)=>down(api[i],n));arrow([223,674],[223,726],C.muted);
  scope(25,735,395,1295,'canvas->update()');
  const pre=node(44,800,357,86,['preUpdate()','clips.clear()']);
  const root=node(44,925,357,60,['root SceneImpl::update()'],{size:19});down(pre,root);
  scope(44,1040,357,825,'SceneImpl::update()');down(root,{x:44,y:1036,w:357,h:0});
  const child=node(60,1110,325,86,['photo / badge update()','same Canvas coordinates'],{size:19});
  const capture=node(60,1250,325,86,['prepareCommon()','clipBox = vport ∩ target'],{size:18});down(child,capture);
  const request=node(60,1390,325,86,['TaskScheduler::request()','Image / Shape tasks'],{size:18});down(capture,request);
  const image=node(60,1550,325,86,['imagePrepare()','photo bounds ∩ clipBox'],{size:19});down(request,image);
  const shape=node(60,1710,325,86,['shapeGenRle()','spans ∩ clipBox'],{size:19});down(image,shape);
  const post=node(44,1930,357,60,['postUpdate()']);down(shape,post);
  arrow([223,2039],[223,2106],C.muted);
  scope(25,2115,395,990,'canvas->draw(clear)');
  const draw=[node(44,2180,357,86,['clear = true → clear()','full target'],{size:20}),node(44,2310,357,60,['preRender()']),node(44,2420,357,60,['SceneImpl::render()']),node(44,2680,357,86,['photo task->done()','renderImage()'],{dark:true}),node(44,2810,357,86,['badge task->done()','renderShape()'],{dark:true}),node(44,2980,357,60,['postRender()'])];
  draw.slice(1).forEach((n,i)=>down(draw[i],n));
  node(44,3140,357,60,['canvas->sync()']);arrow([223,3115],[223,3132],C.muted);
  {
    const y=section(0,'API · DRAW THE AVATAR INSIDE A CANVAS REGION');
    const code=['auto avatar = Scene::gen();','avatar->add(photo);   // Picture','avatar->add(badge);   // Shape','canvas->add(avatar);',`canvas->viewport(${a.requested.join(', ')});`,'canvas->update();','canvas->draw(false);','canvas->sync();'];
    code.forEach((s,i)=>text(s,475,y+100+i*40,21,i===4?C.blue:C.ink));
    text('Canvas::viewport(int32_t x, y, w, h)',475,y+500,21,C.blue);
    scope(1035,y+85,350,285,'avatar · Scene');
    const photo=grid(1055,y+180,packed(a.sourcePixels),'photo · Picture',{u:10});
    circle(1300,y+225,28,green,scene,green);text('badge',1255,y+293,20);text('Shape',1255,y+324,19,C.muted);
    const region=grid(1055,y+430,bg,'Canvas · 16 × 12',{u:10});regionBox(region,b,scene,C.blue);
    text('blue = viewport',1235,y+485,19,C.blue);
    boundedScan(photo,phases[0]);
  }
  {
    const y=section(1,'VIEWPORT DATA · ONE REGION IN CANVAS COORDINATES');
    node(475,y+95,385,128,['CanvasImpl::vport',`min = {${b[0]}, ${b[1]}}`,`max = {${b[2]}, ${b[3]}}`],{size:21});
    node(1000,y+95,385,128,['SwRenderer::vport',`min = {${b[0]}, ${b[1]}}`,`max = {${b[2]}, ${b[3]}}`],{size:21});
    arrow([880,y+157],[984,y+157],C.blue);
    text(bounds,475,y+293,23,C.blue);
    text('No translation · no resampling',1000,y+293,21,C.muted);
    handleCopy([890,y+180],[974,y+180],phases[1],1.2,3.0,C.blue);
    text('RenderRegion · half-open integer bounds',475,y+365,21,C.muted);
  }
  {
    const y=section(2,'SCENE UPDATE · BOTH TASKS CAPTURE THE SAME CLIPBOX');
    scope(475,y+110,385,240,'avatar · Scene');
    node(495,y+188,345,60,['photo · Picture'],{size:20});
    node(495,y+272,345,60,['badge · Shape'],{size:20});
    node(1030,y+110,355,128,['photo · SwImageTask','clipBox = vport','clips = []'],{size:20});
    node(1030,y+285,355,128,['badge · SwShapeTask','clipBox = vport','clips = []'],{size:20});
    route([[872,y+218],[942,y+218],[942,y+174],[1018,y+174]],C.blue);
    route([[872,y+302],[942,y+302],[942,y+349],[1018,y+349]],C.blue);
    handleCopy([880,y+218],[1015,y+174],phases[2],.9,2.1,C.blue);
    handleCopy([880,y+302],[1015,y+349],phases[2],3.0,4.2,C.blue);
    text(`prepareCommon(): clipBox = ${bounds}`,475,y+465,21,C.muted);
  }
  {
    const y=section(3,'PREPARE · IMAGE BOUNDS AND SHAPE SPANS');
    const photo=grid(475,y+115,packed(a.sourcePixels),'photo · original pixels',{u:16});regionBox(photo,b,scene,C.blue);
    const badge=rleGrid(1080,y+115,a.badgeSpans,'badge · prepared shape.rle',{u:16,phase:phases[3],reveal:true,scanRows:rows});
    regionBox(badge,b,scene,C.blue);
    text('imagePrepare()',795,y+166,21);text('shapeGenRle()',795,y+218,21);
    node(475,y+357,420,86,['image.rle = nullptr','render within image bounds'],{size:20});
    node(1000,y+357,385,86,['RLE retains x / y','spans stop at clipBox'],{size:20});
    text(a.badgeSpans.every(s=>s[2]===1)?'len = 1 · no length line':'len > 1 · center-to-center line',1000,y+326,20,C.muted);
    boundedScan(photo,phases[3]);boundedScan(badge,phases[3]);
  }
  {
    const y=section(4,'CLEAR POLICY · THE VIEWPORT DOES NOT LIMIT CLEARING');
    const initial=grid(475,y+140,bg,'initial target',{u:14});regionBox(initial,b,scene,C.blue);
    grid(805,y+140,packed(a.keepPixels),'draw(false)',{u:14});
    const cleared=grid(1135,y+140,packed(a.clearPixels),'draw(true)',{u:14});
    text('Outside pixels retained',805,y+380,19,C.muted);
    text('Whole target cleared',1135,y+380,19,C.muted);
    text('First draw on the same initialized target',475,y+465,21,C.muted);
    // A whole-target clear precedes drawing; no viewport cursor implies a partial clear.
    write(cleared,phases[4],{start:2.8,end:6.4,initial:blank,scanCursor:false});
    const cover=k.loop(phases[4]);
    for(let row=0;row<h;row++){
      const strip=k.animated(cover,phases[4],t=>({opacity:1-k.smooth((t-(.6+row*.12))/.2)}));
      for(let x=0;x<w;x++)k.rect(strip,cleared.x+x*cleared.u+1,cleared.y+row*cleared.u+1,cleared.u-2,cleared.u-2,k.hex(bg[0].slice(0,3)),'#00000000',30);
    }
  }
  {
    const y=section(5,'DRAW(FALSE) · BACKGROUND → PHOTO → SHAPE → RESULT');
    grid(475,y+135,bg,'background',{u:12});
    const photo=grid(705,y+135,packed(a.keepPhotoPixels),'photo rendered',{u:12});
    const badge=grid(935,y+135,packed(a.keepPixels),'shape rendered',{u:12});
    grid(1165,y+135,packed(a.keepPixels),'result',{u:12});
    for(const x of [475,705,935])arrow([x+200,y+207],[x+222,y+207]);
    text('Main Surface',475,y+333,20,C.muted);text('renderImage()',705,y+333,20,C.blue);text('renderShape()',935,y+333,20,green);text('Final pixels',1165,y+333,20,C.muted);
    write(photo,phases[5],{rows,start:.7,end:3.2,initial:bg,scanCursor:false,hold:true});
    write(badge,phases[5],{rows:changedRows,start:3.6,end:6.4,initial:packed(a.keepPhotoPixels),scanCursor:false,hold:true});
    text('One Main Surface · original coordinates · restricted writes',475,y+423,22,C.muted);
  }
  text('ThorVG CPU · 4d5810cf · first-draw native Scene example',460,3217,19,C.muted);
  return finish();
}
