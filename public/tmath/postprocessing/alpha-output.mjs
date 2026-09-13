import {alphaStage,colors} from './alpha-visuals.mjs';
import {leafEvidence,leafInput} from './alpha-image-model.mjs';

// Same filtered image, two interpretations. Only the outgoing representation
// changes: RGB expands by 255/A and alpha remains fixed.
// Beats: internal image → wrong straight reader → exact pixel → RGB bars grow
// → correct straight image matches the premultiplied image, with old error kept.
export function buildAlphaOutput(input = leafInput) {
  const e=leafEvidence(input),v=alphaStage('alpha-output');
  const {group,text,picture,mark,rect,bars,show,hide,play,beat}=v;
  text('Canvas · premultiplied',240,38,23);text('Straight reader · …8888S',720,38,23);
  picture(e.filtered,input.size,240,230,250);
  const wrong=picture(e.filtered,input.size,720,230,250,{mode:'straight',tracked:false});
  const right=picture(e.straight,input.size,720,230,250,{mode:'straight'});
  const wrongLabel=text('unchanged bytes',720,77,15,undefined,colors.warning);
  const correctLabel=text('unpremultiply(RGB)',720,77,15,undefined,colors.green);
  const oldLabel=group();text('unchanged',480,169,13,oldLabel,colors.warning);text('too dark',480,294,13,oldLabel,colors.warning);
  const selected=group();mark(240,230,250,input.size,...e.point,1,selected);
  mark(720,230,250,input.size,...e.point,1,selected);
  const a=e.filtered[e.selected],b=e.straight[e.selected];
  const details=group();
  text(`pixel (${e.point.join(', ')})`,480,398,17,details,colors.muted);
  bars(a,123,446,details,170);
  const rightBars=group();
  const handles=a.map((value,i)=>{
    const x=603,y=446+i*40,w=Math.max(.5,value/255*170);
    text('RGBA'[i],x-23,y,17,rightBars,colors.channels[i]);
    rect(x+85,y,170,11,'#dddddd','#00000000',rightBars,0);
    const g=rightBars.group({id:v.key('moving-channel'),matrix:v.matrix(x+w/2,y)});
    g.rectangle({id:v.key('channel'),center:[0,0],size:[w/100,.11],
      fill:colors.channels[i],stroke:'#00000000',layer:32});
    return {g,w,x,y};
  });
  const beforeValues=group(),afterValues=group();
  a.forEach((value,i)=>text(String(value),806,446+i*40,18,beforeValues));
  b.forEach((value,i)=>text(String(value),806,446+i*40,18,afterValues));
  const factor=group();text('RGB × 255 / A',480,466,20,factor);text('A unchanged',480,566,17,factor,colors.muted);
  const same=text('same appearance · different stored RGB',480,650,20,undefined,colors.green);

  beat('The image is correct inside the premultiplied Canvas.',.9);
  show(wrong,.001);show(wrongLabel);
  beat('A straight reader multiplies these RGB bytes by alpha again, darkening the translucent edge.',1.8);
  show(selected);show(details);show(rightBars);show(beforeValues);
  beat('The marked pixel has the same bytes on both sides but a different interpretation.',1.3);
  show(factor);hide(beforeValues);
  play(handles.map(({g,w,x,y},i)=>{
    const newWidth=Math.max(.5,b[i]/255*170),m=v.matrix(x+newWidth/2,y);m[0]=newWidth/w;
    return {target:g,transform:m};
  }),1.6);
  show(afterValues);hide(wrongLabel);show(correctLabel);
  play([{target:wrong,transform:v.matrix(480,230,90)}],1.1);show(oldLabel);
  show(right,.2);show(same);
  beat('Only RGB expands. A stays fixed, and the straight reader now reproduces the intended image within byte rounding.',3);
  return v.finish();
}
