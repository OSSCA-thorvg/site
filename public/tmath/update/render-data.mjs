import {tmath} from '../runtime/client.js';
import {shapeEvidence,glyph,bitmap,stops,opaquePadTable,rgb} from './render-data-model.mjs';

// Six beats: input types; native Shape RLE; Text's internal Shape delegation;
// bitmap source/sampling state; Fill's attached LUT; retained results vs scratch.
// Rows are independent examples of each path, not four Paints in one Canvas.
export function buildRenderData({colors=stops}={}){
 const table=opaquePadTable(colors);
 const shapeExtra=190,width=1280,height=1580+shapeExtra,ink='#222222',muted='#737373',orange='#e66121',blue='#1f66c4';
 const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
  theme:{preset:'pro_white',background:'#f7f7f7',text:Object.fromEntries(['h1','h2','h3','text','code'].map(r=>[r,{font:'Pretendard',color:ink}]))}});
 let serial=0,time=0;const textIds=[],textPolicies={},beats=[];
 const id=()=>`render-data-${serial++}`,p=(x,y)=>[(x-640)/100,(height/2-(y>=470?y+shapeExtra:y))/100];
 // Shape's expanded area uses physical coordinates; subsequent rows keep their layout.
 const shapePoint=(x,y)=>[(x-640)/100,(height/2-y)/100];
 const group=(opacity=0)=>scene.group({id:id(),opacity});
 const rect=(g,x,y,w,h,fill='#ffffff',stroke=ink)=>{
  const key=id();g.rectangle({id:key,center:p(x,y),size:[w/100,h/100],fill,stroke,width:1.2,layer:15});return key;
 };
 const text=(g,value,x,y,size=22,color=ink,owner)=>{
  const key=id();textIds.push(key);textPolicies[key]=owner?{owner,inset:12}:{standalone:true};
  g.text({id:key,text:String(value),point:p(x,y),size,font:'Pretendard',fill:color,align:[.5,.5],layer:40});
 };
 const line=(g,points,dashed=false)=>g.route({id:id(),points:points.map(v=>p(...v)),stroke:ink,width:1.4,tip:dashed?8:0,...(dashed?{dash:[5,4]}:{}),layer:5});
 const play=(spec,d=.45)=>{scene.play(spec,d,'ease_in_out');time+=d;};
 const show=(g,d=.45)=>play([{target:g,opacity:1}],d);
 const wait=d=>{scene.wait(d);time+=d;};
 const beat=label=>{beats.push({time:+time.toFixed(3),label});wait(1);};
 const arrow=(g,x1,x2,y)=>line(g,[[x1,y],[x2,y]],true);
 const pathShape=(g,x,y,scale,fill)=>g.polygon({id:id(),points:shapeEvidence.points.map(([a,b])=>p(x+(a-10.5)*scale,y+(b-12)*scale)),fill,stroke:orange,width:2,layer:20});
 function fontPath(g,x,y,fill){
  let n=0;const xs=glyph.pts.map(v=>v[0]),ys=glyph.pts.map(v=>v[1]),cx=(Math.min(...xs)+Math.max(...xs))/2,cy=(Math.min(...ys)+Math.max(...ys))/2;
  const contours=[];let commands=[];
  for(const cmd of glyph.cmds){
   if(cmd==='Z'){
    commands.push({type:'close'});
    contours.push(g.path({id:id(),commands,stroke:blue,fill:contours.length&&fill===blue?'#f7f7f7':fill,width:2,layer:20+contours.length}));
    commands=[];
   }else{
    const q=glyph.pts[n++];commands.push({type:cmd==='M'?'move':'line',to:p(x+(q[0]-cx)*.088,y+(q[1]-cy)*.088)});
   }
  }
  return contours;
 }
 const image=(g,x,y,size)=>bitmap.pixels.forEach((color,i)=>rect(g,x+((i%bitmap.w+.5)/bitmap.w-.5)*size,y+((Math.floor(i/bitmap.w)+.5)/bitmap.h-.5)*size,size/bitmap.w,size/bitmap.h,color,'#00000000'));
 text(scene,'Prepared RenderData',640,47,32);
 text(scene,'Paint::Impl::rd → SwShapeTask / SwImageTask',640,87,20,muted);
 ['INPUT','PREPARE','KEPT FOR DRAW'].forEach((v,i)=>text(scene,v,[175,575,1010][i],124,18,muted));
 [155,470,780,1090,1450].forEach(y=>line(scene,[[45,y],[1235,y]]));
 text(scene,'Shape',175,204,25);pathShape(scene,175,309,9,orange);
 text(scene,'Text',175,517,25);fontPath(scene,175,631,blue);
 text(scene,'Picture · Bitmap',175,826,24);image(scene,175,948,112);
 text(scene,'Fill · Gradient',175,1136,24);
 colors.forEach((c,i)=>{rect(scene,115+i*120,1260,44,44,rgb(c),rgb(c));text(scene,i,115+i*120,1324,19,muted);});
 text(scene,'ColorStop',175,1380,20,muted);
 const shapePrep=group(),shapeOut=group(),shapeRoutes=group(),shapeMembers=group();
 text(shapePrep,'shape.outline',575,210,23,muted);pathShape(shapePrep,575,309,9,'#00000000');
 text(shapePrep,'path ref · pooled out[]',575,400,19,muted);
 text(shapeMembers,'shape.bbox · fastTrack',575,435,20);
 text(shapeMembers,'stroke · strokeRle · fill',575,468,20);
 arrow(shapeRoutes,282,460,309);arrow(shapeRoutes,691,804,309);
 const shapeBox=rect(shapeOut,1010,317+shapeExtra/2,392,250+shapeExtra);
 text(shapeOut,'SwShapeTask.shape',1010,227,23,orange,shapeBox);
 text(shapeOut,'shape.rle',1010,265,21,orange,shapeBox);
 const rows=new Map();
 const unit=18,gridTop=295,minX=Math.min(...shapeEvidence.spans.map(s=>s[0])),minY=Math.min(...shapeEvidence.spans.map(s=>s[1]));
 const columns=Math.max(...shapeEvidence.spans.map(s=>s[0]+s[2]))+1-minX,rowCount=Math.max(...shapeEvidence.spans.map(s=>s[1]))+1-minY;
 const gridLeft=1010-columns*unit/2;
 for(let x=0;x<=columns;x++)shapeOut.line({id:id(),from:shapePoint(gridLeft+x*unit,gridTop),to:shapePoint(gridLeft+x*unit,gridTop+rowCount*unit),stroke:'#eeeeee',width:1,layer:20});
 for(let y=0;y<=rowCount;y++)shapeOut.line({id:id(),from:shapePoint(gridLeft,gridTop+y*unit),to:shapePoint(gridLeft+columns*unit,gridTop+y*unit),stroke:'#eeeeee',width:1,layer:20});
 const glyphEvidence=[];
 for(const [x,y,len,coverage] of shapeEvidence.spans){
  if(!rows.has(y))rows.set(y,{owner:group(),lines:[]});
  const row=rows.get(y),sx=gridLeft+(x-minX+.5)*unit,sy=gridTop+(y-minY+.5)*unit,ex=sx+len*unit;
  const color=ink+coverage.toString(16).padStart(2,'0'),side=unit*.52;
  // A starting pixel carries coverage in alpha; center-to-end distance encodes len.
  const length=row.owner.line({id:id(),from:shapePoint(sx,sy),to:shapePoint(ex,sy),stroke:color,width:1.6,layer:30});
  row.lines.push(length);
  row.owner.line({id:id(),from:shapePoint(ex,sy-3),to:shapePoint(ex,sy+3),stroke:color,width:1.2,layer:30});
  // White backing keeps the length line from changing the starting pixel's alpha.
  row.owner.rectangle({id:id(),center:shapePoint(sx,sy),size:[side/100,side/100],fill:'#ffffff',stroke:'#00000000',layer:31});
  row.owner.rectangle({id:id(),center:shapePoint(sx,sy),size:[side/100,side/100],fill:color,stroke:'#00000000',layer:32});
  glyphEvidence.push({x,y,len,coverage,start:[sx,sy],end:[ex,sy],unit,side});
 }
 // Legend stays in the expanded Shape area above the shifted Text row.
 const rleLegend=id();textIds.push(rleLegend);textPolicies[rleLegend]={owner:shapeBox,inset:12};
 shapeOut.text({id:rleLegend,text:'pixel α = coverage / 255 · line = len',point:shapePoint(1010,592),size:17,font:'Pretendard',fill:muted,align:[.5,.5],layer:40});
 const textPrep=group(),textOut=group(),textRoutes=group();
 text(textPrep,'TextImpl::shape → Shape',575,520,22,blue);const glyphPath=fontPath(textPrep,575,631,'#00000000');
 arrow(textRoutes,282,460,631);arrow(textRoutes,691,804,631);
 const textBox=rect(textOut,1010,631,392,180);
 text(textOut,'SwShapeTask.shape',1010,583,23,blue,textBox);
 text(textOut,'rle · strokeRle',1010,638,22,ink,textBox);
 text(textOut,'bbox · fill · fastTrack',1010,688,19,muted,textBox);
 const imagePrep=group(),imageOut=group(),imageRoutes=group();
 const prepBox=rect(imagePrep,575,948,320,130);
 text(imagePrep,'SwImageTask',575,909,24,blue,prepBox);
 text(imagePrep,'source → RenderSurface',575,947,20,ink,prepBox);
 text(imagePrep,'imagePrepare()',575,979,21,ink,prepBox);
 arrow(imageRoutes,282,410,948);arrow(imageRoutes,740,804,948);
 const imageBox=rect(imageOut,1010,941,392,240);
 text(imageOut,'SwImageTask.image',1010,853,23,blue,imageBox);image(imageOut,875,940,66);
 text(imageOut,'data · w · h · stride',1065,901,19,ink,imageBox);
 text(imageOut,'direct · scaled · scale',1065,940,19,ink,imageBox);
 text(imageOut,'ox · oy · filter · rle',1065,979,19,ink,imageBox);
 text(imageOut,'outline → pool',1010,1026,20,muted,imageBox);
 const fillPrep=group(),fillOut=group(),fillRoutes=group();
 const fillPrepBox=rect(fillPrep,575,1260,344,142);
 text(fillPrep,'fillPrepare()',575,1231,22,ink,fillPrepBox);
 text(fillPrep,'gradient parameters',575,1283,20,muted,fillPrepBox);
 arrow(fillRoutes,282,398,1260);arrow(fillRoutes,752,804,1260);
 const fillBox=rect(fillOut,1010,1269,392,272);
 text(fillOut,'shape.fill → SwFill',1010,1176,23,orange,fillBox);
 text(fillOut,'linear / radial · spread',1010,1218,20,ink,fillBox);
 text(fillOut,`ctable[${table.length}]`,1010,1333,22,orange,fillBox);
 text(fillOut,'solid · translucent',1010,1377,19,muted,fillBox);
 const tableBands=Array.from({length:8},()=>group());
 table.forEach((c,i)=>rect(tableBands[Math.floor(i/128)],848+(i+.5)*324/table.length,1275,324/table.length+1,65,rgb(c),'#00000000'));
 const note=group();
 text(note,'SwTask: curBox · transform · clips · opacity · flags[2]',640,1495,22);
 text(note,'Rect fast path → shape.bbox · shape.fastTrack',640,1540,20,muted);
 beat('Shape, Text, bitmap and Gradient provide different kinds of input.');
 show(shapePrep);show(shapeRoutes);play([{target:shapeOut,opacity:1},{target:shapeMembers,opacity:1}],.25);
 for(const {owner,lines} of rows.values()){show(owner,.06);scene.create(lines,.12,'linear');time+=.12;}
 beat('Each native span starts with a coverage-alpha pixel and extends len grid steps from its center.');
 show(textPrep,.35);for(const contour of glyphPath){scene.create(contour,.3,'linear');time+=.3;}show(textRoutes);show(textOut);
 beat('Text delegates its own glyph Shape to the same SwShapeTask path.');
 show(imagePrep);show(imageRoutes);show(imageOut,.6);
 beat('SwImageTask keeps source; its SwImage stores pixel references, transform classification, offsets, filter and optional RLE.');
 show(fillPrep);show(fillRoutes);show(fillOut,.25);
 for(const g of tableBands)show(g,.065);
 beat('Gradient preparation attaches a SwFill and a 1024-entry table to the Shape.');
 play([{target:shapePrep,opacity:.6}],.4);show(note,.35);
 beat('Draw consumes retained results; temporary geometry is not a separate RenderData.');wait(.8);
 return {scene,textIds,textPolicies,beats,duration:time,glyphEvidence};
}
