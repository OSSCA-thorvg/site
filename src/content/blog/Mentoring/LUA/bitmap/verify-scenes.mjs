// node verify-scenes.mjs /path/to/tmath-skills/assets/wasm
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {source,sample,texColor,point} from './bitmap-model.mjs';
const dir=path.dirname(fileURLToPath(import.meta.url)),temp=path.join(dir,'temp');
const root=path.resolve(dir,'../../../../../..'),bundle=path.resolve(process.argv[2]);
await fs.mkdir(temp,{recursive:true});
const readPinned=file=>execFileSync('git',['-C',path.join(root,'thorvg'),'show','6cf10d47fbe13b45040f2c56feeafa0711f53b2b:'+file],{encoding:'utf8'});
const raster=readPinned('src/renderer/cpu_engine/tvgSwRaster.cpp');
const common=readPinned('src/renderer/cpu_engine/tvgSwCommon.h');
const helper=common.slice(common.indexOf('static inline uint32_t INTERPOLATE('),common.indexOf('static inline uint8_t INTERPOLATE8('));
const functions=raster.slice(raster.indexOf('static inline uint32_t _sampleSize('),raster.indexOf('using ImageScaleFilter'));
const srcArray=Array.from({length:576},(_,i)=>{const c=source(24,i%24,Math.floor(i/24));return ((0xff000000|(c[0]<<16)|(c[1]<<8)|c[2])>>>0)+'u';});
const srcSmall=Array.from({length:64},(_,i)=>{const c=source(8,i%8,Math.floor(i/8));return ((0xff000000|(c[0]<<16)|(c[1]<<8)|c[2])>>>0)+'u';});
const cpp=`#include <cstdint>\n#include <cstddef>\n#include <cmath>\n#include <cstdio>\n#include <algorithm>\n#define TVG_UNUSED\n#define A(c) ((c)>>24)\n#define C1(c) (((c)>>16)&255)\n#define C2(c) (((c)>>8)&255)\n#define C3(c) ((c)&255)\n${helper}\n${functions}\nint main(){uint32_t small[]={${srcSmall}},large[]={${srcArray}};for(int mode=0;mode<3;mode++){float scale=mode==2?1.0f/6:3;int n=mode==2?24:8,out=mode==2?4:24;auto image=mode==2?large:small;for(int y=0;y<out;y++)for(int x=0;x<out;x++){float sx=x/scale-.49f,sy=y/scale-.49f;int radius=_sampleSize(scale),my=nearbyint(sy);int miny=std::max(0,my-radius),maxy=std::min(n,my+radius);auto c=mode==0?_interpNoScaler(image,n,n,n,sx,sy,miny,maxy,radius):mode==1?_interpUpScaler(image,n,n,n,sx,sy,miny,maxy,radius):_interpDownScaler(image,n,n,n,sx,sy,miny,maxy,radius);printf("%u %u %u\\n",C1(c),C2(c),C3(c));}}}`;
await fs.writeFile(path.join(temp,'sample-reference.cpp'),cpp);
execFileSync('clang++',['-std=c++17','-O0',path.join(temp,'sample-reference.cpp'),'-o',path.join(temp,'sample-reference')]);
const native=execFileSync(path.join(temp,'sample-reference'),{encoding:'utf8'}).trim().split('\n').map(row=>row.split(' ').map(Number));
const {createTMath}=await import(pathToFileURL(path.join(bundle,'client.js')));
const rt=await createTMath('return tmath.scene {width=1280,height=720}','boot.lua',{renderEngine:'cpu',wasmBinary:await fs.readFile(path.join(bundle,'tmath-wasm.wasm'))});
rt.font('Pretendard',await fs.readFile(path.join(bundle,'Pretendard.ttf')));
let nativeIndex=0;const report=[];
const load=async name=>rt.loadLua(await fs.readFile(path.join(dir,name+'.lua'),'utf8'),name+'.lua');
function checkCell(pixels,x,y,k,expected,label){
 // Scan several interior points because structural guides can cross a pixel.
 const matches=[];
 for(const f of [.3,.5,.7])for(const g of [.3,.5,.7]){
  const offset=(Math.floor(y+g*k)*1280+Math.floor(x+f*k))*4;
  matches.push([0,1,2].every(ch=>Math.abs(pixels[offset+ch]-expected[ch])<=1));
 }
 assert.ok(matches.some(Boolean),label+' expected '+expected);
}
try{
 await load('01-direct');let pixels=Buffer.from(rt.render(rt.duration,true));
 for(let y=0;y<8;y++)for(let x=0;x<8;x++)checkCell(pixels,700+(x+2)*28,140+(y+1)*28,28,source(8,x,y),'direct');
 report.push({scene:'direct',pixels:64});
 for(const [name,mode,n,size,k,scale] of [['02-nearest','nearest',8,24,18,3],['03-bilinear','bilinear',8,24,18,3],['04-downscale','mean',24,4,36,1/6]]){
  await load(name);pixels=Buffer.from(rt.render(rt.duration,true));
  for(let y=0;y<size;y++)for(let x=0;x<size;x++){
   const c=sample(n,x,y,scale,mode);assert.deepEqual(c,native[nativeIndex++],'native '+mode+': '+x+','+y);
   checkCell(pixels,700+x*k,132+y*k,k,c,name+': '+x+','+y);
  }
  const firstScale=mode==='mean'?1/3:2,firstSize=mode==='mean'?8:16;
  const firstPixels=Buffer.from(rt.render(mode==='nearest'?7.2:10,true));
  for(let y=0;y<firstSize;y++)for(let x=0;x<firstSize;x++)checkCell(firstPixels,700+x*k,132+y*k,k,sample(n,x,y,firstScale,mode),'first '+mode);
  report.push({scene:mode,pixels:size*size,firstPixels:firstSize*firstSize,nativeMatch:true});
  if(mode==='bilinear'){
   // At fixed destination (10,6), the scale transition must follow inverse scale.
   for(let frame=1;frame<=30;frame++){
    const time=11.36+frame/30+.0001;
    const objs=rt.layoutReport(time,4).objects;
    const a=objs.find(o=>o.id==='source_sample').paintBounds,b=objs.find(o=>o.id==='target_sample').paintBounds;
    const [u,v]=point(10,6,2+frame/30);
    assert.ok(Math.abs(a.x+a.width/2-(80+(u+.5)*36))<.1,'source cursor X');
    assert.ok(Math.abs(a.y+a.height/2-(170+(v+.5)*36))<.1,'source cursor Y');
    assert.ok(Math.abs(b.x+b.width/2-(700+10.5*18))<.1,'fixed target X');
   }
   report.push({inverseScaleFrames:30,targetFixed:true});
  }
 }
 await load('05-texmap');pixels=Buffer.from(rt.render(rt.duration,true));
 const trace=JSON.parse(await fs.readFile(path.join(dir,'texmap-trace.json'),'utf8'));
 for(const [,x,y,u,v] of trace)checkCell(pixels,700+x*12,120+y*12,12,texColor(u,v),'texmap '+x+','+y);
 const rows0=new Set(trace.filter(r=>r[0]===0).map(r=>r[2])).size;
 const completedFirst=5.45+rows0*.27+1.5+.3+.6;
 const intermediate=Buffer.from(rt.render(completedFirst,true));
 for(const [tri,x,y,u,v] of trace)checkCell(intermediate,700+x*12,120+y*12,12,tri===0?texColor(u,v):[237,240,242],'triangle handoff '+tri);
 report.push({scene:'texmap',pixels:trace.length,triangleOrder:'0,1,3 then 1,2,3',firstTriangleCompleteSecondBlank:true,handoff:completedFirst});
 await fs.writeFile(path.join(temp,'source-target-verification.json'),JSON.stringify(report,null,2));console.log(JSON.stringify(report));
}finally{rt.destroy();}
