import {alphaStage, colors, crop} from './alpha-visuals.mjs';
import {leafEvidence, leafInput} from './alpha-image-model.mjs';

// Beats: visible image/raw RGB → same source in two filters → visible fringe
// → pull the exact boundary crops out of the images → selected pixel values.
export function buildAlphaFringe(input = leafInput) {
  const e=leafEvidence(input), n=input.size;
  const v=alphaStage('alpha-fringe'), {group,text,picture,mark,grid,line,bytes,show,hide,play,replace,beat}=v;
  const initialLabels=group();
  text('Visible image',240,40,24,initialLabels);
  text('Stored RGB · alpha ignored',720,40,24,initialLabels);
  const source=picture(e.source,n,240,190,240,{mode:'straight',tracked:false});
  const raw=picture(e.source,n,720,190,240,{mode:'rgb',tracked:false});
  const retainedLabels=group();
  text('Input',480,120,15,retainedLabels);
  text('RGB only',480,350,15,retainedLabels);
  text('A = 0 still stores RGB',480,490,13,retainedLabels);
  const labels=group();
  text('Straight channel filter',240,40,23,labels,colors.warning);
  text('Premultiply → filter',720,40,23,labels,colors.green);
  let left=picture(e.source,n,240,190,240,{mode:'straight',checker:false});
  let right=picture(e.premultiplied,n,720,190,240,{checker:false});
  const stages=[];
  for(let rows=8;rows<=n;rows+=8) {
    stages.push([
      picture(e.source.map((c,i)=>i<rows*n?e.bad[i]:c),n,240,190,240,{mode:'straight',checker:false}),
      picture(e.premultiplied.map((c,i)=>i<rows*n?e.filtered[i]:c),n,720,190,240,{checker:false}),
    ]);
  }
  const zooms=[e.bad,e.filtered].map((buffer,i)=>{
    const x=240+i*480,mode=i?'premul':'straight';
    const [rx,ry]=e.roi, startX=x-120+(rx+4)*240/n, startY=190-120+(ry+4)*240/n;
    const owner=picture(crop(buffer,n,rx,ry,8),8,startX,startY,8*240/n,{mode,checker:false,tracked:false,layer:36});
    const guides=group();
    mark(x,190,240,n,rx,ry,8,guides);
    line(startX,startY+4*240/n,x,385,guides);
    grid(x,465,160,8,guides);
    mark(x,465,160,8,e.point[0]-rx,e.point[1]-ry,1,guides);
    const sample=group();
    text('8 × 8 pixels',x,567,16,sample,colors.muted);
    bytes(buffer[e.selected],x,604,sample,58);
    return {owner,guides,sample,x};
  });

  beat('The same leaf is visible on the left; ignoring alpha exposes red RGB in transparent pixels.',1.7);
  hide(initialLabels);
  play([{target:source,transform:v.matrix(480,190,86)},{target:raw,transform:v.matrix(480,420,86)}],1.3);
  show(retainedLabels);show(labels);show(left,.001);show(right,.001);
  beat('Both filters start from exactly the same visible leaf.',.8);
  for(const [nextLeft,nextRight] of stages) {
    replace(left,nextLeft);replace(right,nextRight);v.wait(.14);left=nextLeft;right=nextRight;
  }
  beat('Averaging hidden red RGB makes a brown fringe. Filtering premultiplied pixels preserves the green edge.',1.8);
  for(const z of zooms) {
    show(z.owner,.001);
    play([{target:z.owner,transform:v.matrix(z.x,465,160)}],1.1);
    show(z.guides,.3);
  }
  beat('The exact same boundary coordinates expand into 8 × 8 pixel grids.',1);
  for(const z of zooms) show(z.sample,.35);
  beat('Same alpha coverage, different RGB: the source, full result, zoom and selected sample remain together.',3);
  return v.finish();
}
