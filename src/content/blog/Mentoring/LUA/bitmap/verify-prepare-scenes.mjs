import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {source} from './bitmap-model.mjs';
import {fileURLToPath,pathToFileURL} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const bundle=process.argv[2];
const {createTMath}=await import(pathToFileURL(path.join(bundle,'client.js')));
const runtime=await createTMath('return tmath.scene{width=1280,height=720}', 'boot.lua',{renderEngine:'cpu',wasmBinary:await fs.readFile(path.join(bundle,'tmath-wasm.wasm'))});
runtime.font('Pretendard',await fs.readFile(path.join(bundle,'Pretendard.ttf')));
const result=[];
try {
 for(const name of ['06-colorspace','07-premultiplied-alpha','08-format-fast-path','09-update-prepare']){
  runtime.loadLua(await fs.readFile(path.join(dir,name+'.lua'),'utf8'),name+'.lua');
  const pixels=runtime.render(runtime.duration,true);
  const rgb=(x,y)=>Array.from(pixels.slice((y*1280+x)*4,(y*1280+x)*4+3));
  if(name==='06-colorspace')for(let y=0;y<8;y++)for(let x=0;x<8;x++)assert.deepEqual(rgb(111+x*23,171+y*23),rgb(801+x*23,171+y*23));
  if(name==='07-premultiplied-alpha'){
   assert.deepEqual(rgb(890,600),[100,50,100]);
   // Recovered channels: floor(100*255/128)=199, floor(50*255/128)=99.
   assert.deepEqual(rgb(372,165),[221,101,79]);
   assert.notDeepEqual(rgb(376,165),[221,101,79]);
   assert.deepEqual(rgb(272,250),[96,167,119]);
   assert.notDeepEqual(rgb(276,250),[96,167,119]);
   // Alpha remains 128 wide in both representations.
   assert.deepEqual(rgb(300,420),[147,158,170]);
   assert.deepEqual(rgb(925,420),[147,158,170]);
  }
  if(name==='08-format-fast-path')for(let i=0;i<4;i++)assert.deepEqual(rgb(1070,215+i*145),i<2?[200,100,40]:[135,111,110]);
  if(name==='09-update-prepare'){
   const obj=runtime.layoutReport(runtime.duration,4).objects.find(o=>o.id==='image_outline');
   const extent=176*(Math.cos(Math.PI/6)+Math.sin(Math.PI/6));
   assert.ok(obj.visible);assert.ok(Math.abs(obj.paintBounds.width-extent)<10);
  }
  if(name==='07-premultiplied-alpha'){
   for(const [time,alpha] of [[.5,255],[3.2,128],[5.7,0],[8.2,128]]){
    const frame=runtime.render(time,true);
    const at=(x,y)=>Array.from(frame.slice((y*1280+x)*4,(y*1280+x)*4+3));
    for(let y=0;y<24;y++)for(let x=0;x<24;x++){
     const bg=Math.floor(x/3)%2===Math.floor(y/3)%2?230:180;
     const expected=source(24,x,y).map(c=>Math.round((c*alpha+bg*(255-alpha))/255));
     const actual=at(410+x*20,120+y*20);
     for(let c=0;c<3;c++)assert.ok(Math.abs(actual[c]-expected[c])<=2, `${time}: ${x},${y} ${actual} != ${expected}`);
    }
    const dot=runtime.layoutReport(time,4).objects.find(o=>o.id==='point_9').paintBounds;
    assert.ok(Math.abs(dot.x+dot.width/2-(400+alpha/255*480))<.1);
   }
  }
  // Intro labels must clear actual graphics, not just other labels.
  if(name==='06-colorspace'||name==='07-premultiplied-alpha'){
   const end=name==='06-colorspace'?4.65:9;
   for(let time=0;time<=end;time+=1/30){
    const objects=runtime.layoutReport(time,4).objects.filter(o=>o.visible&&o.paintBounds);
    for(const label of objects.filter(o=>o.type==='text'))for(const shape of objects.filter(o=>['rectangle','line','cell','point'].includes(o.type))){
     const a=label.paintBounds,b=shape.paintBounds;
     const gap=Math.max(b.x-a.x-a.width,a.x-b.x-b.width,b.y-a.y-a.height,a.y-b.y-b.height);
     assert.ok(gap>=4, `${name} ${time}: ${label.id} overlaps ${shape.id}: ${gap}`);
    }
   }
  }
  result.push({name,verified:true,duration:runtime.duration});
 }
}finally{runtime.destroy();}
console.log(JSON.stringify(result,null,2));
