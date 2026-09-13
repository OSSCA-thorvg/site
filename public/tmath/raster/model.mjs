/*
 * Algorithm ports from ThorVG cdc1c9596a5edebc159d5623d726febda7595896.
 * Copyright (c) 2020–2026 ThorVG project. MIT license: ../runtime/LICENSE-ThorVG.txt.
 * See README.md for source anchors, byte arithmetic and supported scope.
 */
import native from './native-trace.mjs';

export const SOURCE_COMMIT = 'cdc1c9596a5edebc159d5623d726febda7595896';
const f = Math.fround, add = (a,b) => f(a+b), sub = (a,b) => f(a-b);
const mul = (a,b) => f(a*b), div = (a,b) => f(a/b);
const zero = a => Math.abs(a) <= f(1e-6);
const blank = (width,height,color=[0,0,0,0]) => ({width,height,pixels:Array.from({length:width*height},()=>[...color])});
const at = (image,x,y) => image.pixels[y*image.width+x];
export const multiply = (c,a) => (c*a+255)>>8;
export const alphaBlend = (rgba,a) => rgba.map(c => (c*(a+1))>>8);
export const interpolate = (src,dst,a) => src.map((c,i)=>Math.floor((c*a+dst[i]*(256-a))/256));
export const premultiply = ([r,g,b,a]) => [multiply(r,a),multiply(g,a),multiply(b,a),a];
export function sourceOver(src,dst,opacity=255) {
  const source = opacity===255 ? [...src] : alphaBlend(src,opacity);
  const destination = alphaBlend(dst,255-source[3]);
  return {source,destination,rgba:source.map((c,i)=>c+destination[i])};
}
export function makeBitmap() {
  const image=blank(6,6);
  for(let y=0;y<6;y++) for(let x=0;x<6;x++) {
    let rgba=[53+x*9,133+y*9,203-x*4,255];
    if((x===4||x===5)&&(y===0||y===1)) rgba=[250,198+x*4,53+y*9,255];
    if(y>=5-Math.floor(x/2)) rgba=[37+x*5,133+y*8,80+x*3,255];
    if(y>=4&&x<=1) rgba=[33+x*8,101+y*11,181+x*9,255];
    image.pixels[y*6+x]=rgba;
  }
  return image;
}
export function classifyImage(matrix,filter='Bilinear',hasRle=false) {
  const [a,b,,c,d]=matrix.map(f);
  const direct=zero(sub(a,1))&&zero(sub(d,1))&&zero(b)&&zero(c);
  const scaled=!direct&&zero(b)&&zero(c);
  const scale=f(Math.sqrt(Math.max(add(mul(a,a),mul(c,c)),add(mul(b,b),mul(d,d)))));
  const branch=direct?'direct':scaled?'scaled':'texmap';
  const sampler=direct?'copy':scaled?(filter==='Bilinear'?(scale<.5?'downscale':'bilinear'):'nearest'):(filter==='Bilinear'?'texture-bilinear':'texture-nearest');
  return {branch,sampler,scale,direct,scaled,hasRle};
}
export function classifyShape({fastTrack=false,gradient=false,stroke=false}={}) {
  return {branch:fastTrack&&!stroke?'rect':'rle',fill:gradient?'gradient':'solid',entry:gradient?(stroke?'rasterGradientStroke':'rasterGradientShape'):(stroke?'rasterStroke':'rasterShape')};
}
function tap(image,x,y,weight) {return {x,y,weight,rgba:[...at(image,x,y)]};}
export function sampleNearest(image,sx,sy) {
  const x=Math.trunc(sx),y=Math.trunc(sy);
  return {taps:[tap(image,x,y,1)],rgba:[...at(image,x,y)]};
}
export function sampleBilinear(image,sx,sy) {
  const x=Math.trunc(sx),y=Math.trunc(sy),x2=Math.min(x+1,image.width-1),y2=Math.min(y+1,image.height-1);
  const dx=sx>0?Math.trunc(mul(sub(sx,x),255)):0,dy=sy>0?Math.trunc(mul(sub(sy,y),255)):0;
  const top=interpolate(at(image,x2,y),at(image,x,y),dx);
  const bottom=interpolate(at(image,x2,y2),at(image,x,y2),dx);
  return {dx,dy,intermediates:[top,bottom],taps:[tap(image,x,y,(256-dx)*(256-dy)/65536),tap(image,x2,y,dx*(256-dy)/65536),tap(image,x,y2,(256-dx)*dy/65536),tap(image,x2,y2,dx*dy/65536)],rgba:interpolate(bottom,top,dy)};
}
function roundEven(x) {
  const lo=Math.floor(x), frac=x-lo;
  return frac===.5 ? (lo%2===0?lo:lo+1) : Math.round(x);
}
export function sampleDownscale(image,sx,sy,scale) {
  const n=Math.max(1,Math.trunc(div(.5,scale))),inc=Math.trunc(n/2)+1;
  const minx=Math.max(0,Math.trunc(sx)-n),maxx=Math.min(image.width,Math.trunc(sx)+n);
  const miny=Math.max(0,roundEven(sy)-n),maxy=Math.min(image.height,roundEven(sy)+n);
  const taps=[];
  for(let y=miny;y<maxy;y+=inc) for(let x=minx;x<maxx;x+=inc) taps.push(tap(image,x,y,0));
  const rgba=[0,0,0,0];
  for(const t of taps) {t.weight=1/taps.length;t.rgba.forEach((c,i)=>rgba[i]+=c);}
  return {kernel:{minx,maxx,miny,maxy,n,inc},taps,rgba:rgba.map(c=>Math.floor(c/taps.length))};
}
function scenario(id,source,width,height,matrix,filter='Bilinear',background=[0,0,0,0]) {
  return {id,source,target:blank(width,height,background),initial:blank(width,height,background),steps:[],matrix,filter,...classifyImage(matrix,filter)};
}
function write(trace,x,y,sx,sy,sample,extra={},opacity=255) {
  const before=[...at(trace.target,x,y)],composite=sourceOver(sample.rgba,before,opacity);
  trace.target.pixels[y*trace.target.width+x]=composite.rgba;
  trace.steps.push({x,y,sx,sy,...sample,sample:sample.rgba,rgba:composite.rgba,before,...extra});
}
export function traceDirect(source=makeBitmap(),{width=9,height=8,tx=2,ty=1,opacity=255,id='direct',background=[0,0,0,0]}={}) {
  const trace=scenario(id,source,width,height,[1,0,tx,0,1,ty],'Nearest',background);
  trace.offset=[-roundEven(tx),-roundEven(ty)];
  for(let y=Math.max(0,-trace.offset[1]);y<Math.min(height,source.height-trace.offset[1]);y++) {
    for(let x=Math.max(0,-trace.offset[0]);x<Math.min(width,source.width-trace.offset[0]);x++) {
      const sx=x+trace.offset[0],sy=y+trace.offset[1];
      write(trace,x,y,sx,sy,sampleNearest(source,sx,sy),{},opacity);
    }
  }
  return trace;
}
export function traceScaled(source=makeBitmap(),{scale=2,filter='Bilinear',id=filter==='Bilinear'?'bilinear':'nearest',width=Math.ceil(source.width*scale),height=Math.ceil(source.height*scale),tx=0,ty=0,opacity=255}={}) {
  const trace=scenario(id,source,width,height,[scale,0,tx,0,scale,ty],filter);
  const inverse=div(1,scale),ox=div(-tx,scale),oy=div(-ty,scale);
  for(let y=0;y<height;y++) {
    const sy=sub(add(mul(y,inverse),oy),f(.49));
    if(sy<=-.5||Math.trunc(add(sy,.5))>=source.height) continue;
    for(let x=0;x<width;x++) {
      const sx=sub(add(mul(x,inverse),ox),f(.49));
      if(sx<=-.5||Math.trunc(add(sx,.5))>=source.width) continue;
      const sample=trace.sampler==='nearest'?sampleNearest(source,sx,sy):trace.sampler==='bilinear'?sampleBilinear(source,sx,sy):sampleDownscale(source,sx,sy,trace.scale);
      write(trace,x,y,sx,sy,sample,{},opacity);
    }
  }
  return trace;
}

// tvgSwRasterTexmap.h: the same UV pre-step, sorted-edge scan conversion,
// interpolation and edge feathering. Every intermediate float is float32.
function feathering(iru,irv,ar,ab,w,h) {
  if(irv===1) {if(iru===1)return 255-multiply(ar,ab);if(iru===w)return multiply(ar,255-ab);return 255-ab;}
  if(irv===h) {if(iru===1)return multiply(255-ar,ab);if(iru===w)return multiply(ar,ab);return ab;}
  if(iru===1)return 255-ar;if(iru===w)return ar;return 255;
}
function textureSample(image,u,v,filter,needAA) {
  const x=Math.trunc(u),y=Math.trunc(v),x2=x+1,y2=y+1;
  const ar=255-(Math.trunc(mul(u,256))&255),ab=255-(Math.trunc(mul(v,256))&255);
  let rgba=[...at(image,x,y)];
  let taps=[tap(image,x,y,1)];
  if(filter==='Bilinear') {
    const right=x2<image.width,bottom=y2<image.height;
    if(right)rgba=interpolate(rgba,at(image,x2,y),ar);
    if(bottom) {
      let row=at(image,x,y2);
      if(right)row=interpolate(row,at(image,x2,y2),ar);
      rgba=interpolate(rgba,row,ab);
    }
    const ax=right?ar/256:1,ay=bottom?ab/256:1;
    taps=[tap(image,x,y,ax*ay)];
    if(right)taps.push(tap(image,x2,y,(1-ax)*ay));
    if(bottom)taps.push(tap(image,x,y2,ax*(1-ay)));
    if(right&&bottom)taps.push(tap(image,x2,y2,(1-ax)*(1-ay)));
  }
  const feather=needAA?feathering(x2,y2,ar,ab,image.width,image.height):255;
  return {taps,ar,ab,feather,unfeathered:rgba,rgba:feather<255?alphaBlend(rgba,feather):rgba};
}
function rightAngle(a,c) {
  // tvgMath.cpp::atan2 and tvgMath.h::rightAngle, including their approximation.
  let angle=0;
  if(a!==0||c!==0) {
    const v=div(Math.min(Math.abs(a),Math.abs(c)),Math.max(Math.abs(a),Math.abs(c))),s=mul(v,v);
    angle=add(mul(mul(sub(mul(add(mul(f(-.0464964749),s),f(.15931422)),s),f(.327622764)),s),v),v);
    if(Math.abs(c)>Math.abs(a))angle=sub(f(1.57079637),angle);
    if(a<0)angle=sub(f(3.14159274),angle);
  }
  return zero(angle)||zero(sub(angle,f(Math.PI/2)))||zero(sub(angle,f(Math.PI)));
}
function triangle(trace,vertices,triangleIndex,needAA) {
  const p=vertices.map(v=>({...v})).sort((a,b)=>a.y-b.y),x=p.map(v=>v.x),y=p.map(v=>v.y),u=p.map(v=>v.u),v=p.map(v=>v.v),yi=y.map(Math.trunc);
  if((yi[0]===yi[1]&&yi[0]===yi[2])||(Math.trunc(x[0])===Math.trunc(x[1])&&Math.trunc(x[0])===Math.trunc(x[2])))return;
  let denom=sub(mul(sub(x[2],x[0]),sub(y[1],y[0])),mul(sub(x[1],x[0]),sub(y[2],y[0])));
  if(zero(denom))return;denom=div(1,denom);
  const ctx={dudx:mul(sub(mul(sub(u[2],u[0]),sub(y[1],y[0])),mul(sub(u[1],u[0]),sub(y[2],y[0]))),denom),dvdx:mul(sub(mul(sub(v[2],v[0]),sub(y[1],y[0])),mul(sub(v[1],v[0]),sub(y[2],y[0]))),denom)};
  const dudy=mul(sub(mul(sub(u[1],u[0]),sub(x[2],x[0])),mul(sub(u[2],u[0]),sub(x[1],x[0]))),denom),dvdy=mul(sub(mul(sub(v[1],v[0]),sub(x[2],x[0])),mul(sub(v[2],v[0]),sub(x[1],x[0]))),denom);
  const slope=(i,j)=>y[j]>y[i]?div(sub(x[j],x[i]),sub(y[j],y[i])):0;
  const slopes=[slope(0,1),slope(0,2),slope(1,2)];
  let side=slopes[1]>slopes[0];if(zero(sub(y[0],y[1])))side=x[0]>x[1];if(zero(sub(y[1],y[2])))side=x[2]>x[1];
  function segment(start,end) {
    for(let yy=Math.max(start,0);yy<Math.min(end,trace.target.height);yy++) {
      const x1=Math.max(Math.trunc(ctx.xa),0),x2=Math.min(Math.trunc(ctx.xb),trace.target.width);
      if(x2-x1>=1&&x1<trace.target.width&&x2>0) {
        const dx=sub(1,sub(ctx.xa,x1));let uu=add(ctx.ua,mul(dx,ctx.dudx)),vv=add(ctx.va,mul(dx,ctx.dvdx));
        for(let xx=x1;xx<x2;xx++) {
          // Native's continue does not advance UV or the destination pointer.
          // Therefore all remaining iterations in this row also skip writes.
          if(Math.trunc(uu)<0||Math.trunc(vv)<0||Math.trunc(uu)>=trace.source.width||Math.trunc(vv)>=trace.source.height)break;
          write(trace,xx,yy,uu,vv,textureSample(trace.source,uu,vv,trace.filter,needAA),{triangle:triangleIndex,scanline:{left:ctx.xa,right:ctx.xb},dudx:ctx.dudx,dvdx:ctx.dvdx});
          uu=add(uu,ctx.dudx);vv=add(vv,ctx.dvdx);
        }
      }
      ctx.xa=add(ctx.xa,ctx.dxdya);ctx.xb=add(ctx.xb,ctx.dxdyb);ctx.ua=add(ctx.ua,ctx.dudya);ctx.va=add(ctx.va,ctx.dvdya);
    }
  }
  let upper=false,dy=sub(1,sub(y[0],yi[0]));
  const off=index=>y[index]<0?sub(0,y[index]):0;
  if(!side) {
    ctx.dxdya=slopes[1];ctx.dudya=add(mul(ctx.dxdya,ctx.dudx),dudy);ctx.dvdya=add(mul(ctx.dxdya,ctx.dvdx),dvdy);
    ctx.xa=add(x[0],mul(dy,ctx.dxdya));ctx.ua=add(u[0],mul(dy,ctx.dudya));ctx.va=add(v[0],mul(dy,ctx.dvdya));
    if(yi[0]<yi[1]) {
      const o=off(0);ctx.xa=add(ctx.xa,mul(o,ctx.dxdya));ctx.ua=add(ctx.ua,mul(o,ctx.dudya));ctx.va=add(ctx.va,mul(o,ctx.dvdya));
      ctx.dxdyb=slopes[0];ctx.xb=add(add(x[0],mul(dy,ctx.dxdyb)),mul(o,ctx.dxdyb));segment(yi[0],yi[1]);upper=true;
    }
    if(yi[1]<yi[2]) {
      const o=off(1);if(!upper){ctx.xa=add(ctx.xa,mul(o,ctx.dxdya));ctx.ua=add(ctx.ua,mul(o,ctx.dudya));ctx.va=add(ctx.va,mul(o,ctx.dvdya));}
      ctx.dxdyb=slopes[2];ctx.xb=add(add(x[1],mul(sub(1,sub(y[1],yi[1])),ctx.dxdyb)),mul(o,ctx.dxdyb));segment(yi[1],yi[2]);
    }
  } else {
    ctx.dxdyb=slopes[1];ctx.xb=add(x[0],mul(dy,ctx.dxdyb));
    if(yi[0]<yi[1]) {
      const o=off(0);ctx.xb=add(ctx.xb,mul(o,ctx.dxdyb));ctx.dxdya=slopes[0];ctx.dudya=add(mul(ctx.dxdya,ctx.dudx),dudy);ctx.dvdya=add(mul(ctx.dxdya,ctx.dvdx),dvdy);
      ctx.xa=add(add(x[0],mul(dy,ctx.dxdya)),mul(o,ctx.dxdya));ctx.ua=add(add(u[0],mul(dy,ctx.dudya)),mul(o,ctx.dudya));ctx.va=add(add(v[0],mul(dy,ctx.dvdya)),mul(o,ctx.dvdya));segment(yi[0],yi[1]);upper=true;
    }
    if(yi[1]<yi[2]) {
      const o=off(1);if(!upper)ctx.xb=add(ctx.xb,mul(o,ctx.dxdyb));ctx.dxdya=slopes[2];ctx.dudya=add(mul(ctx.dxdya,ctx.dudx),dudy);ctx.dvdya=add(mul(ctx.dxdya,ctx.dvdx),dvdy);dy=sub(1,sub(y[1],yi[1]));
      ctx.xa=add(add(x[1],mul(dy,ctx.dxdya)),mul(o,ctx.dxdya));ctx.ua=add(add(u[1],mul(dy,ctx.dudya)),mul(o,ctx.dudya));ctx.va=add(add(v[1],mul(dy,ctx.dvdya)),mul(o,ctx.dvdya));segment(yi[1],yi[2]);
    }
  }
}
export function traceTexmap(source=makeBitmap(),{matrix=[1.15,-.35,3,.45,1.1,1],filter='Bilinear',width=11,height=11,id='texmap'}={}) {
  const trace=scenario(id,source,width,height,matrix,filter),[a,b,tx,c,d,ty]=matrix.map(f);
  trace.vertices=[[0,0],[source.width,0],[source.width,source.height],[0,source.height]].map(([u,v])=>({x:add(add(mul(u,a),mul(v,b)),tx),y:add(add(mul(u,c),mul(v,d)),ty),u,v}));
  trace.triangles=[[0,1,3],[1,2,3]];trace.needAA=!rightAngle(a,c);
  trace.triangles.forEach((ids,i)=>triangle(trace,ids.map(j=>trace.vertices[j]),i,trace.needAA));return trace;
}
export function traceSolid({rle=true,fixture=rle?native.solidRle:native.solidRect}={}) {
  const width=fixture.width,height=fixture.height;
  const trace=scenario(rle?'solidRle':'solidRect',blank(1,1,fixture.color),width,height,[1,0,0,0,1,0]);
  trace.branch=rle?'rle':'rect';trace.spans=fixture.spans;trace.geometry=fixture.geometry;trace.bbox=fixture.bbox;
  for(let spanIndex=0;spanIndex<fixture.spans.length;spanIndex++) {
    const {x,y,len,coverage}=fixture.spans[spanIndex];
    for(let xx=x;xx<x+len;xx++)write(trace,xx,y,0,0,{taps:[tap(trace.source,0,0,coverage/255)],rgba:coverage===255?fixture.color:alphaBlend(fixture.color,coverage)},{coverage,spanIndex});
  }
  return trace;
}
// Replay fillLinear's fixed-point lookup using native LUT/coefficient fixtures.
// Captured samples independently verify lookup; coverage uses gradient INTERPOLATE.
export function traceGradient({rle=true,fixture=rle?native.gradientRle:native.gradientRect}={}) {
  const {width,height}=fixture;
  const trace=scenario(rle?'gradientRle':'gradientRect',{width,height,pixels:fixture.samples},width,height,[1,0,0,0,1,0]);
  trace.branch=rle?'rle':'rect';trace.fill='gradient';trace.spans=fixture.spans;trace.geometry=fixture.geometry;
  trace.colorTable=fixture.colorTable;
  const [dx,dy,offset]=fixture.linear, count=fixture.colorTable.length;
  for(const [spanIndex,span] of fixture.spans.entries()){
    const t=mul(add(add(mul(dx,span.x+.5),mul(dy,span.y+.5)),offset),count-1);
    let fixed=Math.trunc(mul(t,256));
    const increment=Math.trunc(mul(mul(dx,count-1),256));
    for(let x=span.x;x<span.x+span.len;x++,fixed+=increment){
      const tableIndex=Math.max(0,Math.min(count-1,(fixed+128)>>8));
      const raw=fixture.colorTable[tableIndex];
      const rgba=span.coverage===255?raw:interpolate(raw,[0,0,0,0],span.coverage);
      write(trace,x,span.y,x,span.y,{taps:[tap(trace.source,x,span.y,1)],rgba},{coverage:span.coverage,spanIndex,gradientSample:raw,tableIndex});
    }
  }
  return trace;
}
export function traceStroke({gradient=false,fixture=gradient?native.strokeGradient:native.strokeSolid}={}) {
  const trace=gradient?traceGradient({fixture}):traceSolid({fixture});
  trace.id=gradient?'strokeGradient':'strokeSolid';trace.stroke=true;
  return trace;
}
export function traceComposition(background=makeBitmap()) {
  const source=blank(6,6);
  for(let y=0;y<6;y++)for(let x=0;x<6;x++) source.pixels[y*6+x]=premultiply([224,70+x*7,77+y*5,64+x*24+y*8]);
  const trace=scenario('composition',source,6,6,[1,0,0,0,1,0],'Nearest');trace.initial=background;trace.target={...background,pixels:background.pixels.map(p=>[...p])};trace.opacity=160;
  for(let y=0;y<6;y++)for(let x=0;x<6;x++)write(trace,x,y,x,y,sampleNearest(source,x,y),sourceOver(at(source,x,y),at(background,x,y),160),160);
  return trace;
}
export function buildScenarios() {
  const source=makeBitmap();
  return {direct:traceDirect(source),nearest:traceScaled(source,{filter:'Nearest'}),bilinear:traceScaled(source),downscale:traceScaled(source,{scale:.25,id:'downscale'}),texmap:traceTexmap(source),solidRect:traceSolid({rle:false}),solidRle:traceSolid(),gradientRect:traceGradient({rle:false}),gradientRle:traceGradient(),strokeSolid:traceStroke(),strokeGradient:traceStroke({gradient:true}),composition:traceComposition()};
}
