import {tmath} from '../runtime/client.js';
import {shapeModel,spanGeometry} from './model.mjs';
export {shapeModel} from './model.mjs';

export function buildShapeOverview(trace,{still=false}={}) {
  const model=shapeModel(trace),width=1440,height=1850;
  const ink='#202020',muted='#626262',blue='#2078dc',orange='#d66b30';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(r=>[r,{font:'Pretendard',color:ink}]))}});
  let serial=0,time=0;const textIds=[],textPolicies={},beats=[],states=new Map();
  const id=()=>`shape-overview-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  function text(parent,value,x,y,size=20,color=ink,opacity=1){const key=id();textIds.push(key);textPolicies[key]={standalone:true};return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',size,fill:color,align:[0,.5],layer:60,opacity});}
  function box(parent,x,y,w,h,fill,stroke='#00000000',layer=10,opacity=1){return parent.rectangle({id:id(),center:p(x+w/2,y+h/2),size:[w/100,h/100],fill,stroke,width:1,layer,opacity});}
  function line(parent,a,b,color=blue,lineWidth=2,layer=30,opacity=1){return parent.line({id:id(),from:p(...a),to:p(...b),stroke:color,width:lineWidth,layer,opacity});}
  const group=()=>scene.group({id:id(),opacity:0});
  // Keep transitions above float timeline precision, including the final minute.
  function show(g,d=0){const duration=still?.001:Math.max(.001,d);scene.fade(g,1,duration);time+=duration;}
  function hide(g){if(g){scene.fade(g,0,.001);time+=.001;}}
  function draw(g,d){if(!still){scene.create(g,d);time+=d;}}
  function wait(d){if(!still){scene.wait(d);time+=d;}}
  function beat(label){beats.push({time,label});wait(.8);}
  function status(slot,value,x,y,size=20,color=ink){hide(states.get(slot));const g=text(scene,value,x,y,size,color,0);show(g);states.set(slot,g);}
  const gray=c=>'#'+Array(3).fill(Math.round(255-c).toString(16).padStart(2,'0')).join('');
  const rgb=v=>'#'+[v&255,v>>>8&255,v>>>16&255].map(c=>c.toString(16).padStart(2,'0')).join('');
  const grids={path:{x:60,y:150,u:23},cell:{x:60,y:660,u:27},coverage:{x:800,y:660,u:27},rle:{x:60,y:1300,u:27},surface:{x:800,y:1300,u:27}};
  const at=(g,v)=>[g.x+v[0]*g.u,g.y+v[1]*g.u];
  function grid(g){box(scene,g.x,g.y,20*g.u,16*g.u,'#ffffff','#cbd3df');for(let x=1;x<20;x++)line(scene,at(g,[x,0]),at(g,[x,16]),'#e5eaf0',.7,12);for(let y=1;y<16;y++)line(scene,at(g,[0,y]),at(g,[20,y]),'#e5eaf0',.7,12);}
  Object.values(grids).forEach(grid);
  function pixel(parent,g,x,y,c,layer=20,opacity=1){return box(parent,g.x+x*g.u+1,g.y+y*g.u+1,g.u-2,g.u-2,c,'#00000000',layer,opacity);}
  function fullPath(parent,g,color,thickness=2){let i=0,commands=[];for(const c of trace.path.cmds){commands.push(c===0?{type:'close'}:c===3?{type:'cubic',control1:p(...at(g,trace.path.pts[i++])),control2:p(...at(g,trace.path.pts[i++])),to:p(...at(g,trace.path.pts[i++]))}:{type:c===1?'move':'line',to:p(...at(g,trace.path.pts[i++]))});if(c===0){parent.path({id:id(),commands,stroke:color,fill:'#00000000',width:thickness,layer:25});commands=[];}}}
  function heading(value,x,y,w=230){
    const owner=box(scene,x,y-23,w,46,ink,ink);
    const label=text(scene,value,x+18,y,22,'#ffffff');
    textPolicies[label.id]={owner:owner.id,inset:12};
  }
  text(scene,'Shape',60,49,34);text(scene,'Path → Cell → RLE → Surface',800,49,23,muted);
  line(scene,[60,80],[1380,80],'#cccccc',1,3);
  heading('01  RenderPath',60,112);text(scene,'commands[]',570,108,23);text(scene,'points[]',970,108,23);
  heading('02  SwCell',60,589);heading('03  Coverage',800,589);
  text(scene,'cover < 0',60,626,19,orange);text(scene,'cover ≥ 0',250,626,19,'#387c76');text(scene,'0 → 255',800,626,19,muted);
  heading('04  SwRle',60,1216);heading('05  Surface',800,1216);
  text(scene,'x · y · len · coverage',60,1254,19,muted);text(scene,'RGBA pixels',800,1254,19,muted);
  for(const y of [865,1500])scene.route({id:id(),points:[p(650,y),p(745,y)],stroke:ink,width:1.8,tip:9,layer:30});
  text(scene,'sweep',665,839,16,muted);text(scene,'draw',670,1474,16,muted);
  text(scene,'20 × 16 · EvenOdd',60,1814,19,muted);text(scene,'PREPARE  01–04     DRAW  05',900,1814,19,muted);
  fullPath(scene,grids.cell,'#c3cbd5',2);
  let index=0,current=null,start=null;const commandNames=['Close','MoveTo','LineTo','CubicTo'];
  trace.path.cmds.forEach((cmd,ci)=>{
    const g=group(),first=index,count=cmd===0?0:cmd===3?3:1;
    text(g,`${String(ci).padStart(2,'0')}  ${commandNames[cmd]}${count?`  P${first}${count===3?'–'+(first+2):''}`:''}`,570,153+ci*31,20);show(g);
    for(let j=0;j<count;j++){const v=trace.path.pts[index],pt=group();text(pt,`P${index}  (${v[0]}, ${v[1]})`,970,149+index*24,15,j<count-1?orange:blue);pt.point({id:id(),point:p(...at(grids.path,v)),radius:4,fill:j<count-1?orange:blue,layer:45});show(pt,.07);index++;}
    if(cmd===1){current=trace.path.pts[first];start=current;wait(.3);return;}
    const end=cmd===0?start:trace.path.pts[index-1],commands=[{type:'move',to:p(...at(grids.path,current))}];
    if(cmd===3){commands.push({type:'cubic',control1:p(...at(grids.path,trace.path.pts[first])),control2:p(...at(grids.path,trace.path.pts[first+1])),to:p(...at(grids.path,end))});show(line(scene,at(grids.path,current),at(grids.path,trace.path.pts[first]),'#d8b397',1,30,0));show(line(scene,at(grids.path,end),at(grids.path,trace.path.pts[first+1]),'#d8b397',1,30,0));}
    else commands.push({type:'line',to:p(...at(grids.path,end))});
    const segment=scene.path({id:id(),commands,stroke:blue,fill:'#00000000',width:3,layer:35});draw(segment,cmd===3?.85:.4);current=end;
  });
  text(scene,'SwOutline',60,547,20,muted);
  beat('Commands consume points and draw cubic segments, concavity and the inner contour.');
  let previousBand=null,previousRange=null;const rleHandles=new Map(),held=new Set();
  const bandEdges=group();
  const topEdge=line(bandEdges,[60,660],[600,660],blue,2,46);
  const bottomEdge=line(bandEdges,[60,768],[600,768],blue,2,46);
  function holdOnce(key){if(!held.has(key)){held.add(key);wait(1.7);}}
  for(const [bi,band] of model.bands.entries()){
    hide(previousBand);const bandGroup=group();previousBand=bandGroup;
    box(bandGroup,grids.cell.x,grids.cell.y+band.lo*27,540,(band.hi-band.lo)*27,'#2078dc10',blue,15);
    if(previousRange){const d=still?.001:.4;scene.play([{target:topEdge,shift:[0,-(band.lo-previousRange.lo)*.27]},{target:bottomEdge,shift:[0,-(band.hi-previousRange.hi)*.27]}],d);time+=d;}else show(bandEdges,.2);
    previousRange=band;show(bandGroup,.2);
    status('band',`Band ${bi+1}/${model.bands.length}  ·  y [${band.lo}, ${band.hi})`,60,1120,19,muted);
    const cells=new Map();
    for(const e of band.events){
      if(e.type==='line'){
        const a=e.from,b=e.to,dy=b[1]-a[1];let lo=0,hi=1;
        if(dy===0){if(a[1]<band.lo||a[1]>=band.hi)continue;}
        else{const t0=(band.lo-a[1])/dy,t1=(band.hi-a[1])/dy;lo=Math.max(0,Math.min(t0,t1));hi=Math.min(1,Math.max(t0,t1));if(hi<=lo)continue;}
        const v=t=>[a[0]+(b[0]-a[0])*t,a[1]+dy*t];
        const chord=line(bandGroup,at(grids.cell,v(lo)),at(grids.cell,v(hi)),blue,3,40);draw(chord,bi===0?.14:.07);
      }else{
        const key=`${e.x},${e.y}`;hide(cells.get(key));const cell=pixel(bandGroup,grids.cell,e.x,e.y,e.cover<0?'#e9ab78':'#83ccc6',22,0);cells.set(key,cell);show(cell,bi===0?.12:.055);
        status('cell',`Cell (${e.x}, ${e.y})   cover = ${e.cover}   area = ${e.area}`,60,1156,19);
        holdOnce('cell');
      }
    }
    if(bi===0)beat('Band-clipped edges record signed cover and area, not filled interior pixels.');
    let sweepCursor=null;
    for(const e of band.sweep){
      hide(sweepCursor);sweepCursor=box(scene,800+e.x*27,660+e.y*27,e.len*27,27,'#2078dc15',blue,35,0);show(sweepCursor);
      status('formula',`(${e.x}, ${e.y})`,800,1120,19,muted);
      status('coverage',`coverage  ${e.coverage}`,800,1156,19);
      const pixels=group();for(let j=0;j<e.len;j++)pixel(pixels,grids.coverage,e.x+j,e.y,gray(e.coverage));show(pixels,e.coverage?.065:.08);
      if(e.span){
        hide(rleHandles.get(e.index));const g=group();rleHandles.set(e.index,g);const s=e.span,geometry=spanGeometry(s);
        pixel(g,grids.rle,s.x,s.y,gray(s.coverage),30);
        const length=line(g,at(grids.rle,geometry.start),at(grids.rle,geometry.end),blue,2,40);
        g.point({id:id(),point:p(...at(grids.rle,geometry.start)),radius:2.3,fill:blue,layer:42});
        line(g,at(grids.rle,[geometry.end[0],geometry.end[1]-.17]),at(grids.rle,[geometry.end[0],geometry.end[1]+.17]),blue,1.5,42);
        show(g);draw(length,bi===0?.13:.055);
        status('span',`${e.merge?'MERGE':'APPEND'} [${e.index}]  {x:${s.x}, y:${s.y}, len:${s.len}, coverage:${s.coverage}}`,60,1762,18,blue);
        holdOnce(e.merge?'merge':e.cell?'boundary':'gap');
      }
      if(!e.coverage)holdOnce('zero-coverage');
    }
    hide(sweepCursor);if(bi===0)wait(.8);else beat(`Band ${bi+1}: Cells sweep into coverage and append or merge RLE spans.`);
  }
  status('span',`${model.spans.length} spans`,60,1762,19,muted);
  let cursor=null;
  status('draw','Raster',800,1762,19,muted);
  for(const [i,s] of model.spans.entries()){
    hide(cursor);const v=spanGeometry(s);cursor=line(scene,at(grids.rle,v.start),at(grids.rle,v.end),orange,4,44,0);show(cursor);
    const pixels=group();for(let j=0;j<s.len;j++)pixel(pixels,grids.surface,s.x+j,s.y,rgb(trace.pixels[s.y*trace.stride+s.x+j]));show(pixels,.055);
  }
  hide(cursor);status('draw','Complete',800,1762,19,muted);
  beat('Draw traverses the completed RLE and composites the native Surface pixels.');wait(1.5);if(still)scene.wait(1);
  return {scene,textIds,textPolicies,beats,model};
}
