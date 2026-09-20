import assert from 'node:assert/strict';
import native,{variant,commit} from './native-trace.mjs';
import regions,{variant as shifted} from '../cpu-regions/native-trace.mjs';
import {maskAvatarModel,rgba,multiply,attenuate} from '../cpu-regions/model.mjs';
export {native,variant,commit,rgba,multiply,attenuate};
export const hex=c=>'#'+c.slice(0,3).map(v=>v.toString(16).padStart(2,'0')).join('');
export const gray=q=>hex([255-q,255-q,255-q]);
export const display=(rgba,i,w=16)=>hex(rgba.slice(0,3).map(v=>Math.min(255,v+Math.round(((i%w+Math.floor(i/w))%2?244:231)*(255-rgba[3])/255))));
const over=(s,d)=>s.map((v,k)=>v+attenuate(d[k],255-s[3]));
// The same Canvas pixel remains the sample under target-only perturbation.
const sample=regions.maskAvatar.badgeCoverage.findIndex((c,i)=>c>0&&c<255&&regions.maskAvatar.maskCoverage[i]>0&&regions.maskAvatar.maskCoverage[i]<255);
export function model(trace=native){
 const r=trace.transparent.maskStorage.every((q,i)=>q===regions.maskAvatar.maskStorage[i])?regions:shifted;
 const {w,h,a}=maskAvatarModel(r),n=trace.transparent,b=trace.background;
 assert.equal(commit,'4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad');
 for(const key of ['maskCoverage','maskSpans','badgeCoverage','badgeSpans','maskStorage','groupPixels','pixels'])assert.deepEqual(n[key],a[key]);
 const photo=a.sourcePixels.map(rgba),group=a.groupPixels.map(rgba),badge=[35,160,100,255];
 const out=group.map((s,i)=>s.map(v=>attenuate(v,a.maskStorage[i])));
 for(let i=0;i<w*h;i++){
  const covered=badge.map(v=>attenuate(v,a.badgeCoverage[i]));
  assert.deepEqual(over(covered,photo[i]),group[i]);
  assert.deepEqual(out[i],rgba(n.pixels[i]));
  assert.deepEqual(over(out[i],rgba(b.background)),rgba(b.pixels[i]));
 }
 assert.deepEqual(n.groupPixels,b.groupPixels);assert.deepEqual(n.maskStorage,b.maskStorage);
 assert(n.restored&&b.restored);
 const i=sample,q=a.maskStorage[i],src=group[i],tmp=out[i],dst=rgba(b.background),rest=dst.map(v=>attenuate(v,255-tmp[3]));
 assert(q>0&&q<255);
 return {trace,w,h,a,sample:i,point:[i%w,Math.floor(i/w)],q,src,tmp,dst,rest,result:rgba(b.pixels[i]),maskCoverage:a.maskCoverage[i],badgeCoverage:a.badgeCoverage[i],badgeCovered:badge.map(v=>attenuate(v,a.badgeCoverage[i])),photo:photo[i],
  groupColors:group.map((p,i)=>display(p,i)),outColors:out.map((p,i)=>display(p,i)),backgroundColors:b.pixels.map(p=>hex(rgba(p))),maskColors:a.maskStorage.map(gray)};
}
