import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createTMath,compileScene} from '../public/tmath/runtime/client.js';
import {buildTintDetail,buildTritoneDetail,buildFillDetail} from '../public/tmath/postprocessing/effect-colors.mjs';
import {rgba} from '../public/tmath/postprocessing/native-evidence.mjs';

const runtime=await createTMath('return tmath.scene {}','bootstrap.lua',{renderEngine:'cpu',wasmBinary:await readFile(new URL('../public/tmath/runtime/tmath-wasm.wasm',import.meta.url))});
runtime.font('Pretendard',await readFile(new URL('../public/tmath/runtime/Pretendard.ttf',import.meta.url)),'ttf');
try {
  for(const build of [buildTintDetail,buildTritoneDetail,buildFillDetail]) {
    const episode=build(),{data}=episode;
    const source='local refs = {}\n'+compileScene(episode.scene).replace(/^local (object\d+) = /gm,'$1 = ').replace(/\bobject(\d+)\b/g,'refs[$1]');
    runtime.loadLua(source,data.id+'.lua');
    const checks=[{time:0,processed:-1},{time:runtime.duration,processed:Infinity}];
    for(const beat of episode.beats) {
      const match=/^Write pixel \((\d+), (\d+)\) back to its address$/.exec(beat.label);
      if(match)checks.push({time:beat.time+.01,processed:Number(match[2])*data.width+Number(match[1])});
    }
    assert.equal(checks.length,4,'Opening, final and both selected writes must be verified');
    for(const {time,processed} of checks) {
      const rendered=runtime.render(time,true);
      for(let i=0;i<data.input.length;i++) {
        const x=i%data.width,y=Math.floor(i/data.width),back=(x+y)%2?238:250;
        const c=rgba(i<=processed?data.output[i]:data.input[i]);
        const expected=c.slice(0,3).map(v=>Math.max(0,Math.min(255,Math.round(v+back*(1-c[3]/255)))));
        const px=Math.floor(40+(x+.5)*15),py=Math.floor(242+(y+.5)*15),offset=(py*960+px)*4;
        assert.deepEqual(Array.from(rendered.slice(offset,offset+3)),expected,`${data.id} t=${time} slot(${x},${y})`);
      }
    }
    console.log(`${data.id}: ${checks.length} Lua-rendered states × ${data.input.length} pixel slots exactly match native trace commits`);
  }
} finally {runtime.destroy();}
