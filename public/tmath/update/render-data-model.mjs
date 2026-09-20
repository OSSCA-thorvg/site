import glyphs from '../font/native-trace.mjs';
import {shapeEvidence} from './prepare-model.mjs';

export {shapeEvidence};
// Font input geometry is shared with the Font article's native Public Sans trace.
export const glyph=glyphs.ABC.glyphs[0].path;
export const bitmap={w:2,h:2,stride:2,pixels:['#e66121','#1f66c4','#dedede','#ffffff']};
export const stops=[[230,97,33],[31,102,196]];
// 4d5810cf tvgSwFill.cpp::_updateColorTable, opaque two-stop [0,1], Pad.
// INTERPOLATE weights are bytes; the last entry is explicitly the last stop.
export function opaquePadTable(colors=stops){
 const size=1024,[first,last]=colors,table=[first.slice()],inc=1/size;
 for(let i=1;i<size;i++){
  const pos=(i+.5)*inc,weight=255-Math.trunc(255*pos);
  table.push(first.map((v,c)=>last[c]+((v-last[c])*weight>>8)));
 }
 table[size-1]=last.slice();return table;
}
export const table=opaquePadTable();
export const rgb=v=>'#'+v.map(c=>c.toString(16).padStart(2,'0')).join('');
