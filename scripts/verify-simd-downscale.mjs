// Extract and execute the unchanged PR functions on an Arm NEON host.
import {execFileSync} from 'node:child_process';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import assert from 'node:assert/strict';
import {commit,bitmap,sample,example,focus,pack} from '../public/tmath/simd/model.mjs';
if(process.arch!=='arm64')throw Error('This native check needs an Arm64 NEON host.');
const repo=path.resolve(process.argv[2]||'../../thorvg');
const get=(file,name)=>{
 const source=execFileSync('git',['-C',repo,'show',commit+':src/renderer/cpu_engine/'+file],{encoding:'utf8'});
 const start=source.indexOf('static inline uint32_t '+name+'('),brace=source.indexOf('{',start);
 assert.ok(start>=0);let depth=1,end=brace+1;
 while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}
 return source.slice(start,end);
};
const cases=example.outputs.map(args=>({image:example.image,args}));
const padded=bitmap(72,48,77);
for(const args of [focus,{sx:8.4,sy:5.2,miny:2,maxy:10,n:4},{sx:.2,sy:1,miny:0,maxy:4,n:3}])cases.push({image:padded,args});
cases.push({image:{w:18,h:18,stride:18,pixels:Array(324).fill(0xffffffff)},args:{sx:9,sy:9,miny:0,maxy:18,n:9}});
const asymmetric=bitmap();asymmetric.pixels=asymmetric.pixels.map((p,i)=>pack([128+i%127,(p>>>16)&127,(p>>>8)&127,p&127]));
cases.push({image:asymmetric,args:focus});
const temp=await fs.mkdtemp(path.join(os.tmpdir(),'thorvg-simd-check-'));
const cpp=['#include <arm_neon.h>','#include <cstdint>','#include <cstddef>','#include <cassert>','#include <cstdio>',
 '#define TVG_UNUSED','#define A(p) ((p)>>24)','#define C1(p) (((p)>>16)&255)','#define C2(p) (((p)>>8)&255)','#define C3(p) ((p)&255)',
 get('tvgSwRasterC.h','cInterpDownScaler'),get('tvgSwRasterNeon.h','neonInterpDownScaler'),'int main(){'];
for(const {image,args} of cases){
 const expected=sample(image,args);
 assert.ok(expected.samples.length<=16);assert.ok(expected.sum.every(v=>v<=4080));
 cpp.push(`{uint32_t data[]={${image.pixels.map(v=>v+'u').join(',')}};`);
 const parameters=`data,${image.stride},${image.w},${image.h},${Math.fround(args.sx).toFixed(8)}f,${Math.fround(args.sy).toFixed(8)}f,${args.miny},${args.maxy},${args.n}`;
 cpp.push(`auto scalar=cInterpDownScaler(${parameters});auto neon=neonInterpDownScaler(${parameters});assert(scalar==${expected.pixel}u);assert(neon==scalar);`);
 cpp.push('uint16x8_t sums=vdupq_n_u16(0);');
 for(const p of expected.samples)cpp.push(`sums=vaddw_u8(sums,vreinterpret_u8_u32(vdup_n_u32(${p.pixel}u)));`);
 cpp.push(`uint16_t lanes[8];vst1q_u16(lanes,sums);uint16_t expected[]={${expected.lanes.join(',')}};for(int k=0;k<8;k++)assert(lanes[k]==expected[k]);}`);
}
cpp.push(`puts("${cases.length} native cases passed: scalar = NEON = model; all eight accumulator lanes match.");}`);
const file=path.join(temp,'probe.cpp'),binary=path.join(temp,'probe');await fs.writeFile(file,cpp.join('\n'));
execFileSync('c++',['-std=c++17','-O2',file,'-o',binary],{stdio:'inherit'});
process.stdout.write(execFileSync(binary,{encoding:'utf8'}));
