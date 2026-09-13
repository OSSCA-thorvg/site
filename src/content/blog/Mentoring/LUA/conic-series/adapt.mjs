// node adapt.mjs /path/to/conic-gradiant-sw
// Preserve upstream geometry, canonical data, IDs, and every timeline operation.
import fs from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
const dir=import.meta.dirname;
const repo=path.resolve(process.argv[2]);
const common=['title','subtitle','hook'];
const specs=[
 {name:'conicTitle',hide:['wrap-note','transform-title','transform-note','conclusion-title','conclusion-flow','conclusion-note'],keep:['wrap-title'],clips:[{name:'conic-paint',crop:[0,220,720,620],poster:4.7}]},
 {name:'_conicT',hide:['wrap-conclusion'],keep:['wrap-title','table-title'],clips:[{name:'conic-lookup',crop:[0,170,720,880],poster:8}]},
 {name:'_prepareConic',hide:['state-legend','normal-caption','matrix-caption','derivative-state-note'],clips:[
  {name:'math-dot-cross',crop:[0,238,960,210],poster:1.7},
  {name:'math-normal',crop:[0,448,960,216],poster:4.2},
  {name:'math-inverse',crop:[0,712,960,216],poster:4.2},
  {name:'math-derivatives',crop:[0,974,960,264],poster:1.7}]},
 {name:'conicFwidthAppendix',hide:['projection-caption','restored-conclusion','not-restored-conclusion'],keep:['ruler-a-title','ruler-b-title'],clips:[{name:'conic-fwidth',crop:[0,140,960,1010],poster:7.1}]},
 {name:'conicSeamProjectionAppendix',hide:['recurrence-boundary','ray-conclusion-a','ray-conclusion-b'],clips:[{name:'conic-projection',crop:[0,178,960,976],poster:6.8}]},
 {name:'conicAARangeGatesAppendix',hide:['normal-conclusion','seam-conclusion','final-conclusion'],clips:[{name:'conic-gates',crop:[0,178,960,974],poster:8.2}]},
 {name:'_conicPixel',hide:['surface-caption','math-caption','band-caption','color-caption'],clips:[{name:'conic-pixel-fill',crop:[0,170,720,1040],poster:27.3,end:27.45,hold:1.6}]},
];
for(const spec of specs){
 const relative=`.vscode/tmath/conic-sw-fill/animations/tvgSwFill.${spec.name}.lua`;
 const original=await fs.readFile(path.join(repo,relative),'utf8');
 const ids=[...original.matchAll(/(?:txt|text)\([^\n]*?"([\w-]+)"/g)].map(m=>m[1]);
 const hidden=[...new Set([...common,...spec.hide,...ids.filter(id=>id.endsWith('-title'))])].filter(id=>!(spec.keep||[]).includes(id));
 // Empty text preserves handles referenced later by the upstream timeline.
 const injection=`\n    -- Blog adaptation: prose lives in MDX; preserve the animated object handle.\n    local blogHidden = {${hidden.map(id=>`["${id}"]=true`).join(',')}}\n    if blogHidden[id] then value = "" end\n`;
 let adapted=original.replace(/(local function (?:txt|text)\([^\n]+\)\n)/,`$1${injection}`);
 if(adapted===original)throw Error('Missing text helper: '+spec.name);
 // Separators between the original portrait modules are unnecessary in isolated clips.
 adapted=adapted.replace(/(id = "(?:title-rule|header-rule)"[^\n]*\n)/g,'$1    opacity = 0,\n');
 const header=`-- Adapted from ${relative}\n-- Only title/prose visibility differs. Geometry and timeline are upstream originals.\n-- Export framing and optional final hold: manifest.json.\n`;
 await fs.writeFile(path.join(dir,`${spec.name}.lua`),header+adapted);
 spec.upstream=relative;spec.sha256=createHash('sha256').update(original).digest('hex');spec.hiddenText=hidden;
}
await fs.writeFile(path.join(dir,'manifest.json'),JSON.stringify({source:'conic-gradiant-sw',theme:'original adaptive_vscode light palette',specs},null,2)+'\n');
