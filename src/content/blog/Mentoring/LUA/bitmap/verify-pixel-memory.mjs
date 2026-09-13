// node verify-pixel-memory.mjs /path/to/tmath-skills/assets/wasm
import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {pathToFileURL,fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const bundle=path.resolve(process.argv[2]);
const {createTMath}=await import(pathToFileURL(path.join(bundle,'client.js')));
const rt=await createTMath('return tmath.scene {width=1280,height=720}','boot.lua',{renderEngine:'cpu',wasmBinary:await fs.readFile(path.join(bundle,'tmath-wasm.wasm'))});
rt.font('Pretendard',await fs.readFile(path.join(bundle,'Pretendard.ttf')));
const source=await fs.readFile(path.join(dir,'00-pixel-memory.lua'),'utf8');
function rgba(x,y){
 let c=[Math.floor(57+y*.8),Math.floor(119+y*.5),Math.floor(173+y*.35),255];
 if((x-112)**2+(y-25)**2<256)c=[Math.floor(241-(y-9)*.4),Math.floor(193-(y-9)*1.4),Math.floor(87-(y-9)*.9),255];
 if(y>49+12*Math.sin(x*.039)+6*Math.sin(x*.09))c=[45+Math.floor(x*.11),94+Math.floor(y*.13),107+Math.floor(x*.08),255];
 if(y>68+9*Math.sin(x*.052+1.2))c=[27+Math.floor(y*.08),66+Math.floor(x*.09),68+Math.floor(y*.12),255];
 if(y>78&&x>35+(y-78)*1.8&&x<130-(y-78)*1.7)c=[85+Math.floor((y-78)*2),144+Math.floor((y-78)*1.4),163+Math.floor((y-78)*.8),255];
 return c;
}
const checks=[];
try{
 for(const [name,cx,cy,px,py] of [['authored',122,30,125,32],['perturbed',80,40,82,44]]){
  rt.loadLua(source.replace('cropx,cropy,n,px,py=122,30,8,125,32',`cropx,cropy,n,px,py=${cx},${cy},8,${px},${py}`),name+'.lua');
  const pixels=Buffer.from(rt.render(rt.duration,true));
  const at=(x,y)=>[...pixels.subarray((Math.floor(y)*1280+Math.floor(x))*4,(Math.floor(y)*1280+Math.floor(x))*4+4)];
  const near=(actual,expected,where)=>assert.ok(actual.every((v,i)=>Math.abs(v-expected[i])<=1),`${where}: ${actual} vs ${expected}`);
  // The initial bitmap must already be visible; check every original texel before any ROI overlay.
  const initial=Buffer.from(rt.render(0,true));
  for(let y=0;y<96;y++)for(let x=0;x<160;x++){
   const offset=((72+y*6+3)*1280+160+x*6+3)*4;
   near([...initial.subarray(offset,offset+4)],rgba(x,y),'original '+x+','+y);
  }
  // Avoid selected-cell border / guide at exact grid lines, sample interiors.
  for(let y=0;y<8;y++)for(let x=0;x<8;x++){
   const expected=rgba(cx+x,cy+y);
   const candidates=[6,10,18,22].flatMap(dy=>[6,10,18,22].map(dx=>at(432+x*28+dx,64+y*28+dy)));
   assert.ok(candidates.some(c=>c.every((v,i)=>Math.abs(v-expected[i])<=1)),'crop '+name+': '+x+','+y);
  }
  near(at(830,150),rgba(px,py),'selected pixel');
  const c=rgba(px,py),rows=[[0,1,2,3],[2,1,0,3]],rgbColors=[[182,70,53,255],[33,134,106,255],[52,90,161,255],[89,99,110,255]];
  for(let row=0;row<2;row++)for(let slot=0;slot<4;slot++)for(let bit=0;bit<8;bit++){
   const ch=rows[row][slot],one=(c[ch]>>(7-bit))&1;
   near(at(64+slot*236+bit*22+10,[356,528][row]+69),one?rgbColors[ch]:[228,232,237,255],'bit '+row+','+slot+','+bit);
  }
  const hex=order=>'0x'+Buffer.from(order.map(i=>c[i])).readUInt32LE(0).toString(16).toUpperCase().padStart(8,'0');
  checks.push({variant:name,sourceTexels:15360,cropTexels:64,bitBars:64,pixel:c,rgba:hex(rows[0]),bgra:hex(rows[1]),offset:(py*160+px)*4,duration:rt.duration});
 }
 await fs.mkdir(path.join(dir,'temp'),{recursive:true});
 await fs.writeFile(path.join(dir,'temp/pixel-memory-values.json'),JSON.stringify(checks,null,2));
 console.log(JSON.stringify(checks));
}finally{rt.destroy();}
