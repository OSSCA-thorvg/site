import native,{variant,commit} from './native-trace.mjs';
export {native,variant,commit};
export const rgba=p=>[p&255,(p>>>8)&255,(p>>>16)&255,p>>>24];
export const multiply=(a,b)=>(a*b+255)>>8;
export const attenuate=(v,a)=>(v*(a+1))>>8;
export const luma=p=>{const [r,g,b]=rgba(p);return (54*r+182*g+19*b)>>8;};
export function model(trace=native){
  const {width:w,height:h,cases:c}=trace;
  const source=[230,97,33,255];
  const inBox=(i,b)=>{const x=i%w,y=Math.floor(i/w);return x>=b[0]&&x<b[2]&&y>=b[1]&&y<b[3];};
  const clipped=c.sourceEllipse.coverage.map((v,i)=>multiply(v,c.clipGeometry.coverage[i]));
  const expect=(condition,msg)=>{if(!condition)throw Error(msg);};
  expect(clipped.every((v,i)=>v===c.clipCurve.coverage[i]),'RLE coverage intersection differs from CPU');
  for(const name of ['maskAlpha','maskInv','maskLuma']) {
    const data=c[name];
    expect(data.contextRestored&&data.compositors===1,'Mask context was not restored');
    const weights=data.maskStorage.map(v=>name==='maskLuma'?luma(v):name==='maskInv'?255-v:v);
    const output=weights.map((v,i)=>c.sourceRect.coverage[i]?source.map(channel=>attenuate(channel,v)):[0,0,0,0]);
    expect(output.every((p,i)=>p.every((v,k)=>v===rgba(data.pixels[i])[k])),`${name} output differs from CPU`);
    data.weights=weights;
  }
  for(const name of ['clipRect','maskRect'])expect(c[name].fastTrack&&c[name].clipCount===0&&c[name].compositors===0,`${name} did not take viewport fast path`);
  expect(c.clipCurve.clipCount===1&&!c.clipCurve.fastTrack&&c.clipCurve.compositors===0,'Curve did not use clip stack');
  expect(c.clipCurve.targetCoverage.every((v,i)=>v===c.clipGeometry.coverage[i]),'Clip must ignore target color/opacity');
  for(const name of ['viewportKeep','viewportClear']){
    const data=c[name];
    expect(data.coverage.every((v,i)=>v===(inBox(i,data.clipBox)?c.sourceEllipse.coverage[i]:0)),'Viewport altered geometry coordinates');
    expect(data.pixels.every((v,i)=>inBox(i,data.clipBox)||(v===(name==='viewportKeep'?0xfff0eae5:0))),`${name} outside pixels differ`);
  }
  const candidates=clipped.map((v,i)=>({i,v,a:c.sourceEllipse.coverage[i],b:c.clipGeometry.coverage[i]}));
  const sample=candidates.find(p=>p.a>0&&p.a<255&&p.b>0&&p.b<255)??candidates.find(p=>p.v>0&&p.v<255);
  const maskSample=c.maskAlpha.weights.findIndex((a,i)=>a>0&&a<255&&c.sourceRect.coverage[i]===255);
  const rows=Array.from({length:h},(_,y)=>({y,source:c.sourceEllipse.coverage.slice(y*w,(y+1)*w),clip:c.clipGeometry.coverage.slice(y*w,(y+1)*w),output:clipped.slice(y*w,(y+1)*w)}));
  return {w,h,c,commit,inBox,clipped,sample,maskSample,rows};
}

// One practical Scene example is the authority for the Clipping overview.
export function avatarModel(trace=native){
  const a=trace.avatar,{width:w,height:h}=a;
  const expect=(ok,message)=>{if(!ok)throw Error(message);};
  expect(a.sameClipTask&&a.clipperFlag&&!a.clipFastTrack,'Avatar clipper task identity/role differs');
  expect(JSON.stringify(a.clipCounts)==='[1,1]','Both avatar children must retain one clip');
  expect(a.compositors===0,'Avatar clipping unexpectedly allocated a compositor');
  expect(a.photoCoverage.every((v,i)=>v===a.clipCoverage[i]),'Photo RLE differs from roundClip RLE');
  expect(a.badgeCoverage.every((v,i)=>v===multiply(a.badgeRaw[i],a.clipCoverage[i])),'Badge RLE intersection differs');
  for(const [name,key] of [['clip','clipCoverage'],['photo','photoCoverage'],['badge','badgeCoverage'],['badgeRaw','badgeRaw']]){
    const expanded=Array(w*h).fill(0);
    for(const [x,y,len,c] of a[name+'Spans'])for(let i=0;i<len;i++)expanded[y*w+x+i]=c;
    expect(expanded.every((v,i)=>v===a[key][i]),`${name} SwSpan expansion differs`);
  }
  expect(a.finalPixels.every((v,i)=>a.clipCoverage[i]||v===a.background),'Clip modified outside background');
  expect(a.finalPixels.every((v,i)=>a.badgeCoverage[i]||v===a.photoPixels[i]),'Shape draw changed pixels outside the badge');
  const i=a.badgeCoverage.findIndex((v,i)=>v>0&&a.badgeRaw[i]<255&&a.clipCoverage[i]<255);
  expect(i>=0,'Missing fractional badge/clip sample');
  const sample={i,raw:a.badgeRaw[i],clip:a.clipCoverage[i],out:a.badgeCoverage[i]};
  const spans=a.clipSpans.filter(s=>s[1]===Math.floor(i/w));
  const changedRows=Array.from({length:h},(_,y)=>y).filter(y=>a.finalPixels.slice(y*w,(y+1)*w).some((p,x)=>p!==a.photoPixels[y*w+x]));
  return {w,h,a,sample,spans,changedRows,commit};
}

function checkSpans(spans,coverage,w,h){
  const expanded=Array(w*h).fill(0);
  for(const [x,y,len,c] of spans)for(let k=0;k<len;k++)expanded[y*w+x+k]=c;
  if(!expanded.every((v,i)=>v===coverage[i]))throw Error('Native span expansion differs');
}
export function maskAvatarModel(trace=native){
  const a=trace.maskAvatar,w=16,h=12;
  const expect=(ok,message)=>{if(!ok)throw Error(message);};
  expect(a.sceneMasking&&a.compositors===2&&a.contextRestored,'Scene mask composition/context differs');
  expect(a.childOpacity.every(v=>v===255)&&a.clipCounts.every(v=>v===0),'Mask children have unexpected preparation state');
  checkSpans(a.maskSpans,a.maskCoverage,w,h);checkSpans(a.badgeSpans,a.badgeCoverage,w,h);
  expect(a.maskStorage.every((v,i)=>v===multiply(a.maskCoverage[i],a.alpha)),'Mask storage differs from coverage × fill alpha');
  expect(a.pixels.every((v,i)=>rgba(v).every((c,k)=>c===attenuate(rgba(a.groupPixels[i])[k],a.maskStorage[i]))),'Group composition differs from native masked output');
  expect(a.groupPixels.every((v,i)=>a.badgeCoverage[i]||v===a.sourcePixels[i]),'Group Shape draw changed pixels outside badge');
  return {w,h,a,changedRows:Array.from({length:h},(_,y)=>y).filter(y=>a.groupPixels.slice(y*w,(y+1)*w).some((p,x)=>p!==a.sourcePixels[y*w+x]))};
}
export function viewportAvatarModel(trace=native){
  const a=trace.viewportAvatar,w=16,h=12,b=a.photoClipBox;
  const expect=(ok,message)=>{if(!ok)throw Error(message);};
  const inside=i=>i%w>=b[0]&&i%w<b[2]&&Math.floor(i/w)>=b[1]&&Math.floor(i/w)<b[3];
  expect(!a.imageRle&&a.compositors===0&&a.clipCounts.every(v=>v===0),'Viewport created unexpected RLE/clip/compositor');
  expect(JSON.stringify(a.badgeClipBox)===JSON.stringify(b)&&JSON.stringify(a.photoBounds)===JSON.stringify(b),'Task bounds differ from viewport');
  checkSpans(a.badgeSpans,a.badgeCoverage,w,h);
  expect(a.badgeCoverage.every((v,i)=>v===(inside(i)?trace.avatar.badgeRaw[i]:0)),'Viewport moved or resampled Shape coverage');
  for(const clear of [false,true]){
    const photo=clear?a.clearPhotoPixels:a.keepPhotoPixels,final=clear?a.clearPixels:a.keepPixels;
    expect(photo.every((v,i)=>v===(inside(i)?a.sourcePixels[i]:clear?0:a.background)),'Viewport moved image coordinates or changed outside pixels');
    expect(final.every((v,i)=>a.badgeCoverage[i]||v===photo[i]),'Shape draw changed pixels outside its prepared RLE');
  }
  expect(a.keepPixels.every((v,i)=>!inside(i)||v===a.clearPixels[i]),'Clear policy changed inside-viewport pixels');
  return {w,h,a,b,inside,rows:Array.from({length:b[3]-b[1]},(_,i)=>b[1]+i),changedRows:Array.from({length:h},(_,y)=>y).filter(y=>a.keepPixels.slice(y*w,(y+1)*w).some((p,x)=>p!==a.keepPhotoPixels[y*w+x]))};
}
