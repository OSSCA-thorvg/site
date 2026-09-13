import trace from './rle-trace.mjs';
import {lesson,pathGrid,C} from './rle-visuals.mjs';

// Six beats: source path, fixed-point representation, selected band, signed edge
// contribution, native cubic subdivision, sorted band-local cell lists.
export function buildCells(input=trace) {
  const v=lesson('update-cells','Path → band-local cells');
  const {scene,p,id,group,text,rect,line,arrow,show,hide,create,beat,finish}=v;
  text(scene,'Outline',155,115,23);arrow(scene,217,115,290,115,C.muted,1.5,[6,5]);
  text(scene,'26.6',347,115,23);arrow(scene,402,115,475,115,C.muted,1.5,[6,5]);
  text(scene,'24.8',532,115,23);arrow(scene,587,115,660,115,C.muted,1.5,[6,5]);
  text(scene,'Band',724,115,23);arrow(scene,780,115,853,115,C.muted,1.5,[6,5]);text(scene,'cover / area',983,115,23);
  const grid=pathGrid(v,input,{left:65,top:190,step:69});
  const at=grid.at,[a,b,c1,c2,d]=input.points;
  text(scene,'Screen coordinates · +y ↓',304,658,18,C.muted);
  const source=group();
  text(source,'MoveTo → LineTo → CubicTo → Close',883,215,23);
  const pointLine=(pt,y)=>{text(source,`(${pt.map(n=>n.toFixed(2)).join(', ')})`,890,y,28);};
  pointLine(a,290);
  const fixed=group();
  arrow(fixed,890,325,890,367,C.muted);text(fixed,`(${a.map(n=>Math.round(n*64)).join(', ')})`,890,408,31);text(fixed,'× 64',1060,408,18,C.muted);
  arrow(fixed,890,441,890,482,C.muted);text(fixed,`(${a.map(n=>Math.round(n*256)).join(', ')})`,890,524,31);text(fixed,'<< 2',1060,524,18,C.muted);
  text(fixed,'1 pixel = 256 subpixels',890,593,22,C.muted);
  scene.point({id:id('start-point'),point:p(...at(a)),radius:6,fill:C.orange,layer:40});
  text(scene,'A',at(a)[0]-18,at(a)[1]-18,18,C.orange);
  beat('The asymmetric source contour remains visible in screen coordinates.',1);
  show(fixed,.65);beat('Outline points are 26.6; UPSCALE shifts them into the 24.8 cell walker.',1.3);
  hide(source);hide(fixed);
  const band=group(),[lo,hi]=input.band;
  rect(band,65+7*69/2,190+(lo+hi)*69/2,7*69,(hi-lo)*69,'#20202009','#00000000',0,8);
  line(band,65,190+lo*69,548,190+lo*69,C.ink,2,[7,5]);line(band,65,190+hi*69,548,190+hi*69,C.ink,2,[7,5]);
  text(band,`Band [${lo}, ${hi})`,887,210,26);text(band,`local y = world y − ${lo}`,887,256,23,C.muted);text(band,`local x = world x − ${input.bbox[0]}`,887,290,21,C.muted);
  show(band,.5);beat('Only cells inside the current band receive row heads.',.8);
  const zoom=group(),cellX=760,cellY=315,cellSize=180;
  rect(zoom,cellX+90,cellY+90,180,180,C.white,C.ink,2);
  const fraction=a[0]-Math.floor(a[0]),cutX=cellX+fraction*cellSize;
  const signed=group();
  rect(signed,cellX+fraction*cellSize/2,cellY+90,fraction*cellSize,180,'#df792b55','#00000000',0,19);
  line(signed,cutX,cellY,cutX,cellY+180,C.orange,5);
  arrow(signed,cellX+215,cellY,cellX+215,cellY+180,C.orange,2);text(signed,'+256',cellX+267,cellY+90,23,C.orange);
  const leftCell=input.lineCells[0];
  text(signed,`cover ${leftCell.cover>0?'+':''}${leftCell.cover}`,846,545,25,C.orange);
  text(signed,`area ${leftCell.area.toLocaleString('en-US')}`,846,588,25,C.orange);
  text(signed,'2 × x × Δy',846,632,21,C.muted);
  text(zoom,`Cell (${leftCell.x}, ${leftCell.y})`,846,700,22);
  const sourceEdge=line(scene,...at(a),...at(b),C.orange,5);
  const cells=input.cells.map(c=>({data:c,handle:rect(scene,...at([c.x+.5,c.y+.5]),69,69,c.cover>0?'#df792b25':'#3f7cce25',c.cover>0?C.orange:C.blue,2,17)}));
  create(sourceEdge,1);show(zoom,.4);show(signed,.7);
  for(const cell of cells.filter(c=>c.data.cover>0))show(cell.handle,.4);
  beat('A vertical edge contributes signed cover and twice the left-side area at each crossed cell.',1.4);
  hide(zoom);hide(signed);
  const cubicLabel=group();text(cubicLabel,'CubicTo → accepted chords',886,326,26,C.blue);
  const handles=group();line(handles,...at(b),...at(c1),C.blue,1.4,[6,5]);line(handles,...at(c2),...at(d),C.blue,1.4,[6,5]);
  for(const pt of [c1,c2])handles.point({id:id('control'),point:p(...at(pt)),radius:4,fill:C.blue,layer:40});
  show(handles,.3);show(cubicLabel,.35);
  const chords=[];
  for(let i=1;i<input.chords.length;i++){
    const from=input.chords[i-1],to=input.chords[i];
    const outside=from[1]>=hi&&to[1]>=hi;
    const chord=line(scene,...at(from),...at(to),outside?C.muted:C.blue,outside?2:4,outside?[6,5]:undefined,35);
    chords.push(chord);create(chord,.45);
  }
  for(const cell of cells.filter(c=>c.data.cover<0))show(cell.handle,.4);
  const chordCount=text(scene,`${input.chords.length-1} chords → _lineTo()`,886,383,24,C.muted);show(chordCount,.25);
  beat('Native subdivision yields five chords; the same cell walker records only band-local contributions.',1.2);
  hide(handles);hide(cubicLabel);hide(chordCount);
  const lists=group();
  text(lists,'yCells',865,335,26);
  for(let y=lo;y<hi;y++){
    const row=input.cells.filter(c=>c.y===y),rowY=411+(y-lo)*132;
    text(lists,`[${y-lo}]`,665,rowY,22,C.muted);
    row.forEach((cell,index)=>{
      const x=754+index*135;
      rect(lists,x,rowY,107,63,C.white,C.ink,1.5);
      text(lists,`x ${cell.x-input.bbox[0]}`,x,rowY,23,cell.cover>0?C.orange:C.blue);
      if(index<row.length-1)arrow(lists,x+56,rowY,x+75,rowY,C.ink,1.2);
      text(lists,String(cell.cover),x,rowY+54,18,cell.cover>0?C.orange:C.blue);
      text(lists,String(cell.area),x,rowY+79,17,C.muted);
    });
  }
  text(lists,'cover',1110,465,17,C.muted);text(lists,'area',1110,490,17,C.muted);
  text(lists,`${input.cells.length} cells · sorted by x`,876,671,24);
  show(lists,.6);beat('Temporary row lists retain the signed cover/area needed by the sweep, not RGBA pixels.',2);
  return finish(input);
}
