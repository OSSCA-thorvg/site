// node verify.mjs /path/to/conic-gradiant-sw /path/to/tmath-runtime
import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
import {pathToFileURL} from 'node:url';
const dir=import.meta.dirname,repo=path.resolve(process.argv[2]),bundle=path.resolve(process.argv[3]);
const {specs}=JSON.parse(await fs.readFile(path.join(dir,'manifest.json'),'utf8'));
const {createTMath}=await import(pathToFileURL(path.join(bundle,'client.js')));
const rt=await createTMath('return tmath.scene {width=960,height=1280}','boot.lua',{renderEngine:'cpu',wasmBinary:await fs.readFile(path.join(bundle,'tmath-wasm.wasm'))});
for(const [name,file] of [['Pretendard','Pretendard.ttf'],['Source Serif 4','SourceSerif4-Semibold.ttf'],['IBM Plex Sans KR','IBMPlexSansKR-SemiBold.ttf']])rt.font(name,await fs.readFile(path.join(bundle,file)),'ttf');
const results=[];
try{
for(const spec of specs){
 const original=await fs.readFile(path.join(repo,spec.upstream),'utf8');
 assert.equal(createHash('sha256').update(original).digest('hex'),spec.sha256,'upstream changed');
 const adapted=await fs.readFile(path.join(dir,spec.name+'.lua'),'utf8');
 const restored=adapted.split('\n').slice(3).join('\n')
  .replace(/\n    -- Blog adaptation:[^\n]*\n    local blogHidden = [^\n]*\n    if blogHidden\[id\] then value = "" end\n/,'')
  .replace(/(id = "(?:title-rule|header-rule)"[^\n]*\n)    opacity = 0,\n/g,'$1');
 assert.equal(restored,original,'geometry or timeline was modified');
 rt.loadLua(adapted,spec.name+'.lua');
 for(const clip of spec.clips){
  const cuts=new Set(),[x,y,w,h]=clip.crop;
  // Text is exhaustively checked by render.mjs; inspect geometry at every frame here.
  for(let f=0;f<=Math.ceil((clip.end??rt.duration)*30);f++){
   for(const o of rt.layoutReport(Math.min(f/30,clip.end??rt.duration),0).objects){
    if(!o.visible||['text','group','space','scene'].includes(o.type)||!o.paintBounds)continue;
    const b=o.paintBounds;
    if(b.x+b.width<=x||b.x>=x+w||b.y+b.height<=y||b.y>=y+h)continue;
    if(b.x<x-.1||b.y<y-.1||b.x+b.width>x+w+.1||b.y+b.height>y+h+.1)cuts.add(o.id);
   }
  }
  assert.deepEqual([...cuts],[],`geometry cut: ${clip.name}`);
  results.push({clip:clip.name,identicalGeometryAndTimeline:true,partialGeometry:[...cuts]});
 }
 if(spec.name==='_conicPixel'){
  const outputs=rt.layoutReport(27.45,0).objects.filter(o=>o.id?.startsWith('surface-output-')&&o.visible);
  assert.equal(outputs.length,48,'final hold must show all 48 filled pixels');
 }
}
console.log(JSON.stringify(results,null,2));
await fs.writeFile(path.join(dir,'temp/fidelity.json'),JSON.stringify(results,null,2));
}finally{rt.destroy();}
