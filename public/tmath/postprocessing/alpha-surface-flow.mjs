import {alphaStage, colors} from './alpha-visuals.mjs';
import {trace,rgba,replaySpans,compositeTerms} from './native-evidence.mjs';

// Native BG/A/B, Blur, Fill and source-over bytes from the same Overview trace.
// Beats: two real surfaces → A/B span writes → Blur ping-pong → in-place Fill
// → one bitmap composite → the selected premultiplied pixel contribution.
export function buildAlphaSurfaceFlow() {
  const v=alphaStage('alpha-surface-flow'),{group,text,picture,rect,line,mark,bytes,show,hide,play,replace,beat}=v;
  const n=trace.width,blank=Array.from({length:n*n},()=>[0,0,0,0]),decoded=a=>a.map(rgba);
  const xCanvas=175,xOff=500,xScratch=815,y=230,size=250,scratchSize=150;
  text('Canvas',xCanvas,47,24);text('Effect Offscreen',xOff,47,24);
  const headers=group();
  text('Blur Scratch',xScratch,100,21,headers);
  text('premultiplied RGBA',xOff,80,16,undefined,colors.muted);
  rect(xCanvas,y,size,size);rect(xOff,y,size,size);
  let canvas=picture(decoded(trace.background),n,xCanvas,y,size);
  let off=picture(blank,n,xOff,y,size);
  let scratch=picture(blank,n,xScratch,y,scratchSize);
  const scratchBorder=rect(xScratch,y,scratchSize,scratchSize);
  const scratchState=text('transposed · reusable',xScratch,335,15,undefined,colors.muted);
  const passLabels=trace.passes.map((p,i)=>text(`${p.op} · ${i+1}/${trace.passes.length}`,xScratch,335,16));
  const abFrames=[];
  let state=Array(n*n).fill(0);
  for(const records of trace.writes) {
    const frames=replaySpans(records,state,n,12);
    abFrames.push(frames.map(frame=>picture(decoded(frame.pixels),n,xOff,y,size)));
    state=frames.at(-1).pixels;
  }
  const blurFrames=trace.passes.map(p=>picture(decoded(p.pixels),n,
    p.to==='scratch'?xScratch:xOff,y,p.to==='scratch'?scratchSize:size));
  const fillFrames=[];
  for(let row=4;row<=n;row+=4)
    fillFrames.push(picture(decoded(trace.filtered.map((pixel,i)=>i<row*n?trace.compositionInput[i]:pixel)),n,xOff,y,size));
  const actions=['renderShape(A)','renderShape(B)','GaussianBlur','Fill','endComposite()'].map(label=>text(label,xOff,391,21));
  const directions=[line(635,y,725,y,undefined,colors.muted,9),line(725,y,635,y,undefined,colors.muted,9)];
  const pixels=decoded(trace.compositionInput);
  const transfer=picture(pixels,n,xOff,y,size,{tracked:false,layer:39,transparent:true,opacity:trace.opacity/255});
  const finalCanvas=picture(decoded(trace.final),n,xCanvas,y,size);
  const terms=compositeTerms(trace.compositionInput[trace.point[1]*n+trace.point[0]],
    trace.background[trace.point[1]*n+trace.point[0]],trace.opacity);
  const contribution=group();
  text('Source × group alpha',170,495,18,contribution);
  text('+ Destination remainder',490,495,18,contribution);
  text('= Canvas pixel',800,495,18,contribution);
  [terms.foreground,terms.background,terms.result].forEach((c,i)=>bytes(c,[170,490,800][i],545,contribution));
  text(`source-over · group opacity ${trace.opacity}/255`,480,650,18,contribution,colors.muted);
  const marks=group();mark(xOff,y,size,n,...trace.point,1,marks);mark(xCanvas,y,size,n,...trace.point,1,marks);

  beat('The Canvas already holds BG. The selected Effect Offscreen starts transparent.',1);
  for(let i=0;i<2;i++) {
    if(i) hide(actions[i-1]);show(actions[i]);
    for(const next of abFrames[i]) {replace(off,next);off=next;v.wait(.18);}
    beat(`${trace.tasks[i+1].id} span writes fill the same Offscreen; Canvas remains unchanged.`,.7);
  }
  hide(actions[1]);show(actions[2]);show(headers);show(scratch,.001);show(scratchBorder,.001);
  for(let i=0;i<blurFrames.length;i++) {
    const toScratch=trace.passes[i].to==='scratch',arrow=directions[toScratch?0:1];
    show(arrow,.001);show(passLabels[i],.001);
    if(toScratch){replace(scratch,blurFrames[i]);scratch=blurFrames[i];}
    else {replace(off,blurFrames[i]);off=blurFrames[i];}
    v.wait(.42);hide(arrow,.001);hide(passLabels[i],.001);
  }
  beat('Eight native Blur passes alternate two buffers and finish in Offscreen.',1);
  show(scratchState);
  hide(actions[2]);show(actions[3]);
  for(const next of fillFrames){replace(off,next);off=next;v.wait(.2);}
  beat('Fill changes RGB in the same Offscreen while preserving the Blur alpha.',1);
  hide(actions[3]);show(actions[4]);
  show(transfer,.001);
  play([{target:transfer,transform:v.matrix(xCanvas,y,size)}],1.2);
  hide(transfer,.001);replace(canvas,finalCanvas);canvas=finalCanvas;
  show(marks);show(contribution);
  beat('Only the flattened effect image is composited into Canvas. The selected bytes expose premultiplied source-over.',3);
  return v.finish();
}
