import fs from 'node:fs/promises';
import path from 'node:path';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import sharp from 'sharp';
import {revision,model,radialAt} from '../public/tmath/gl-fill/model.mjs';

const root=path.resolve(import.meta.dirname,'..');
const source=path.resolve(process.env.THORVG_SOURCE || path.join(root,'thorvg'));
const out=path.join(root,'public/tmath/gl-fill');
const temp=path.resolve(process.env.GL_FILL_REVIEW_DIR || '/tmp/thorvg-gl-fill-review'), build=path.resolve(process.env.THORVG_BUILD || path.join(temp,'engine-build'));
assert.equal(process.platform,'darwin','This native readback fixture uses macOS CGL.');
assert.equal(execFileSync('git',['-C',source,'rev-parse','HEAD'],{encoding:'utf8'}).trim(),revision);
await fs.mkdir(temp,{recursive:true});
if (!await fs.access(path.join(build,'build.ninja')).then(()=>true,()=>false)) {
  execFileSync('meson',['setup',build,source,'-Dengines=gl','-Dloaders=','-Dsavers=','-Dbindings=',
    '-Dextra=','-Ddefault_library=shared','-Dbuildtype=release','-Dlog=false'],{stdio:'inherit'});
}
execFileSync('ninja',['-C',build],{stdio:'inherit'});
const binary=path.join(temp,'native');
// A shared library keeps ThorVG's internal GL function pointers private.
execFileSync('c++',['-std=c++17','-O2','-I'+path.join(source,'inc'),path.join(root,'scripts/gl-fill-native.cpp'),
  path.join(build,'src/libthorvg-1.dylib'),'-Wl,-rpath,'+path.join(build,'src'),'-framework','OpenGL','-o',binary],{stdio:'inherit'});
const captures=[];
for (const [name,scale] of [['example',1/16],['variant',3/32]]) {
  const file=path.join(temp,name+'.rgba');
  const device=JSON.parse(execFileSync(binary,[file,String(scale)],{encoding:'utf8'}));
  const data=await fs.readFile(file), m=model({scale});
  const {width,height}=device;
  const crop={x:335,y:334,width:24,height:24};
  const cases=[];
  for (const entry of m.cases) {
    const points=[];
    // Verify the actual displayed magnification, not only a scalar AA formula.
    for (let y=crop.y;y<crop.y+crop.height;++y) for (let x=crop.x;x<crop.x+crop.width;++x) {
      const wx=x+entry.offset[0], wy=y+entry.offset[1], index=(wy*width+wx)*4;
      const actual=[...data.subarray(index,index+4)];
      const expected=radialAt(entry,[wx+.5,wy+.5]).premultiplied.map(Math.round);
      const error=Math.max(...actual.map((v,i)=>Math.abs(v-expected[i])));
      assert.ok(error<=2,`${name}/${entry.label} (${x},${y}): ${actual} vs ${expected}`);
      points.push({x,y,rgba:actual,error});
    }
    const sample=points.find(p=>p.x===Math.floor(m.sample[0])&&p.y===Math.floor(m.sample[1]));
    cases.push({label:entry.label,margin:entry.screenMargin,sample:sample.rgba,
      maxChannelError:Math.max(...points.map(p=>p.error)),cropPixels:points.map(p=>p.rgba)});
  }
  assert.deepEqual(cases[0].cropPixels,cases[1].cropPixels,'F and S scaling must agree in the native crop');
  assert.notDeepEqual(cases[0].cropPixels,cases[2].cropPixels,'The native readback must exhibit the seam difference');
  const target=name==='example'?out:temp;
  await sharp(data,{raw:{width,height,channels:4}}).png().toFile(path.join(target,name+'.png'));
  const capture={revision,...device,crop,sample:m.sample,cases};
  await fs.writeFile(path.join(target,name+'.json'),JSON.stringify(capture,null,2)+'\n');
  captures.push({name,renderer:device.renderer,verifiedPixels:cases.length*crop.width*crop.height,
    samples:cases.map(c=>c.sample),maxChannelError:Math.max(...cases.map(c=>c.maxChannelError))});
}
console.log(JSON.stringify(captures));
