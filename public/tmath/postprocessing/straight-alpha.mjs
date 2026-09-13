import {alphaStage, colors, crop} from './alpha-visuals.mjs';
import {leafImage, leafInput} from './alpha-image-model.mjs';
import {scaleBytes} from './native-evidence.mjs';

export const straightAlphaInput = {
  canvas: [200, 100, 50, 128],
  shape: [0, 200, 100, 128],
};

// Mirrors the pinned CPU renderer's byte operations for one fully covered pixel.
export function straightAlphaEvidence(input = straightAlphaInput) {
  const premultiplySurface = rgba => rgba[3] === 255 ? [...rgba] : [
    (rgba[0] * rgba[3]) >> 8,
    (rgba[1] * rgba[3]) >> 8,
    (rgba[2] * rgba[3]) >> 8,
    rgba[3],
  ];
  const premultiplyShape = rgba => rgba[3] === 255 ? [...rgba] : [
    (rgba[0] * rgba[3] + 255) >> 8,
    (rgba[1] * rgba[3] + 255) >> 8,
    (rgba[2] * rgba[3] + 255) >> 8,
    rgba[3],
  ];
  const unpremultiply = rgba => rgba[3] === 0 || rgba[3] === 255 ? [...rgba] : [
    Math.min(255, Math.floor(rgba[0] * 255 / rgba[3])),
    Math.min(255, Math.floor(rgba[1] * 255 / rgba[3])),
    Math.min(255, Math.floor(rgba[2] * 255 / rgba[3])),
    rgba[3],
  ];
  const source = premultiplyShape(input.shape);
  const compose = destination => {
    const background = scaleBytes(destination, 255 - source[3]);
    return source.map((value, i) => value + background[i]);
  };
  const prepared = premultiplySurface(input.canvas);
  return {
    ...input,
    prepared,
    source,
    cleared: unpremultiply(compose([0, 0, 0, 0])),
    expected: unpremultiply(compose(prepared)),
    observed: unpremultiply(compose(input.canvas)),
  };
}


// The leaf/disk masks illustrate fully covered pixels; the overlap uses the
// exact native 1×1 byte operations. No native edge-AA or task timings are claimed.
export function straightDrawImages(input = straightAlphaInput) {
  const n=64,mask=leafImage({...leafInput,cx:28,cy:28});
  const target=mask.map(c=>c[3]?[...input.canvas]:[0,0,0,0]);
  const shape=target.map((_,i)=>Math.hypot(i%n+.5-38,Math.floor(i/n)+.5-36)<=17?[...input.shape]:[0,0,0,0]);
  const evidence=target.map((canvas,i)=>straightAlphaEvidence({canvas,shape:shape[i]}));
  const point=[33,32],roi=[30,29],selected=point[1]*n+point[0];
  return {n,target,shape,evidence,point,roi,selected,
    cleared:evidence.map(e=>e.cleared),observed:evidence.map(e=>e.observed),expected:evidence.map(e=>e.expected)};
}

// Beats: same existing target → clear only left / prepare right → rasterise
// the same new Shape → pull overlap pixels out of all three output images.
export function buildStraightAlpha(input = straightAlphaInput) {
  const e=straightDrawImages(input),v=alphaStage('straight-alpha');
  const {group,text,picture,mark,grid,line,bytes,show,hide,play,replace,beat}=v;
  const xs=[160,480,800],y=235,size=254,blank=Array.from({length:e.n*e.n},()=>[0,0,0,0]);
  ['draw(true)','draw(false)','Prepared target'].forEach((label,i)=>text(label,xs[i],42,23));
  const beforeLabels=xs.map(x=>text('existing pixels',x,76,17,undefined,colors.muted));
  const afterLabels=['clear → draw','retain → draw','premultiply → draw(false)'].map((label,i)=>
    text(label,xs[i],76,i===2?15:17,undefined,i===1?colors.warning:colors.green));
  let pictures=xs.map(x=>picture(e.target,e.n,x,y,size,{mode:'straight'}));
  const cleared=picture(blank,e.n,xs[0],y,size);
  const preparation=group();
  text('old image removed',xs[0],396,17,preparation,colors.muted);
  text('bytes retained',xs[1],396,17,preparation,colors.warning);
  text('appearance preserved',xs[2],396,17,preparation,colors.green);
  const frames=[];
  const outputs=[e.cleared,e.observed,e.expected];
  for(let rows=8;rows<=e.n;rows+=8) frames.push(outputs.map((out,i)=>
    picture(out.map((pixel,j)=>j<rows*e.n?pixel:(i===0?blank[j]:e.target[j])),
      e.n,xs[i],y,size,{mode:'straight'})));
  const zooms=outputs.map((out,i)=>{
    const x=xs[i],[rx,ry]=e.roi,sx=x-size/2+(rx+4)*size/e.n,sy=y-size/2+(ry+4)*size/e.n;
    const owner=picture(crop(out,e.n,rx,ry,8),8,sx,sy,8*size/e.n,{mode:'straight',tracked:false,layer:36,origin:e.roi,checkerStep:8});
    const guide=group();
    mark(x,y,size,e.n,rx,ry,8,guide);line(sx,sy+4*size/e.n,x,448,guide);
    grid(x,496,96,8,guide);mark(x,496,96,8,e.point[0]-rx,e.point[1]-ry,1,guide);
    const values=group();bytes(out[e.selected],x,585,values,55);
    return {owner,guide,values,x};
  });
  beat('All three Canvas images begin with the same translucent leaf.',1.3);
  beforeLabels.forEach(label=>hide(label,.05));afterLabels.forEach(label=>show(label,.15));
  replace(pictures[0],cleared);pictures[0]=cleared;show(preparation);
  beat('Only draw(true) removes the old pixels. Preparing retained bytes keeps their appearance.',1.5);
  for(const frame of frames) {
    for(let i=0;i<3;i++){replace(pictures[i],frame[i]);pictures[i]=frame[i];}
    v.wait(.19);
  }
  beat('The same translucent disk is drawn into all three targets. Their visible overlap differs.',2);
  hide(preparation);
  for(const z of zooms) {
    show(z.owner,.001);play([{target:z.owner,transform:v.matrix(z.x,496,96)}],.7);show(z.guide,.15);
  }
  for(const z of zooms) show(z.values,.2);
  beat('Identical overlap coordinates reproduce the native cleared, retained and prepared RGBA values.',3);
  return v.finish();
}
