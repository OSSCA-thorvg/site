import fs from 'node:fs/promises';import path from 'node:path';import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
const nested=JSON.parse(await fs.readFile(path.join(dir,'image-nested-clip-trace.txt'),'utf8'));
const old=await fs.readFile(path.join(dir,'sw-image-clip-tasks.lua'),'utf8');
let seed=old.slice(0,old.indexOf('scene:fade(states[1],1,.15)'));
seed=seed.replace('rgb(trace.background),"#cbd5df")','rgb(trace.cases[3].pixels[at+1]),"#cbd5df")');
seed=seed.replace('local states={}','local states={}\nlocal oldCounts,oldTitles={},{}');
seed=seed.replace('id="state_"..i,opacity=0','id="state_"..i,opacity=i==3 and 1 or 0');
seed=seed.replace('label(states[i],"state_"','oldTitles[i]=label(states[i],"state_"').replace('label(states[i],"count_"','oldCounts[i]=label(states[i],"count_"');
seed=seed.replace('id="task_labels",opacity=0','id="task_labels",opacity=1');
seed=seed.replace('local previewLabel=label(taskLabels,','local previewLabel=label(scene:group{id="hidden_preview_label",opacity=0},');
seed=seed.replace('id=id,opacity=0','id=id,opacity=(string.sub(id,1,10)=="clip_span_" or string.sub(id,1,11)=="final_span_") and 1 or 0');
seed=seed.replace('id="render_phase",opacity=0','id="render_phase",opacity=1');
seed=seed.replace('label(rendering,"fetch",','local fetchLabel=label(rendering,"fetch",');
seed=seed.replace('final[i]=spanGlyph("final_span_"..i,s,bases[3])','final[i]=spanGlyph("final_span_"..i,s,bases[2])');
seed=seed.replace('id="rle_counts",opacity=0','id="rle_counts",opacity=1');
seed=seed.replace('label(counts,"final_count",','local priorImageCount=label(counts,"final_count",');
const tail=`
-- Continuation: exact previous final frame, then a second clip. Original Bitmap
-- and clip A stay put. Image RLE is rebuilt and both clips are applied in order.
local nested=${lua(nested)}
local newState=scene:group{id="nested_state",opacity=0}
label(newState,"nested_title","Clip A + Clip B",130,80,32)
label(newState,"nested_tasks","clips.count = 2",900,660,28)
local clipB=scene:group{id="clip_b_shape",opacity=0}
for i=1,4 do local a,b=nested.polygon[i],nested.polygon[i%4+1]
 clipB:line{id="clip_b_edge_"..i,from=p(130+a[1]*cell,gy+a[2]*cell),to=p(130+b[1]*cell,gy+b[2]*cell),stroke="#13877f",width=3,layer=44}
end
local secondLabel=scene:group{id="second_labels",opacity=0}
label(secondLabel,"second_rle","clip B · shape.rle",1670,745,27)
label(secondLabel,"second_count",#nested.clipB.." spans",1670,790,24)
local rawLabel=scene:group{id="raw_label",opacity=0}
label(rawLabel,"raw_count",#nested.rawRle.." spans",900,790,24)
local finalLabel=scene:group{id="nested_final_label",opacity=0}
label(finalLabel,"nested_final_count",#nested.finalRle.." spans",900,790,24)
local second,newFinal,newFocus,newCopies={},{},{},{}
for i,s in ipairs(nested.clipB) do second[i]=spanGlyph("second_span_"..i,s,1670) end
for i,s in ipairs(nested.finalRle) do
 newFinal[i]=spanGlyph("nested_span_"..i,s,900)
 local g=scene:group{id="nested_focus_"..i,opacity=0};newFocus[i]=g
 label(g,"nested_record_"..i,"x "..s.x.." · y "..s.y.." · len "..s.len.." · coverage "..s.coverage,1670,1280,24)
 rect(g,"nested_select_"..i,900+(s.x+s.len/2)*cell,ry+(s.y+.5)*cell,s.len*cell-3,cell-3,"#00000000","#cf8c30",45)
 for lane=2,3 do rect(g,"nested_sample_"..i.."_"..lane,bases[lane]+(s.x+s.len/2)*cell,gy+(s.y+.5)*cell,s.len*cell-3,cell-3,"#00000000","#cf8c30",45) end
 local copy=scene:group{id="nested_copy_"..i,opacity=0};newCopies[i]=copy
 for j=0,s.len-1 do local idx=(s.y-trace.ty)*trace.iw+s.x+j-trace.tx+1
  rect(copy,"nested_pixel_"..i.."_"..j,900+(s.x+j+.5)*cell,gy+(s.y+.5)*cell,cell-4,cell-4,rgb(trace.source[idx]),"#526579",55)
 end
end
local function fadeList(list,value,seconds)
 local ops={};for _,g in ipairs(list) do ops[#ops+1]={target=g,opacity=value} end
 scene:play(ops,seconds)
end
scene:wait(2)
scene:play({{target=oldCounts[3],opacity=0},{target=oldTitles[3],opacity=0}},.15)
scene:fade(newState,1,.15);scene:fade(clipB,1,.4);scene:wait(.8)
scene:fade(rendering,0,.15);scene:fade(fetchLabel,0,.01);scene:fade(prepare,1,.15)
scene:fade(secondLabel,1,.15)
for _,g in ipairs(second) do scene:fade(g,1,.035) end
scene:wait(.4)
-- A Clip update rebuilds the image rectangle before applying A then B.
scene:fade(priorImageCount,0,.1);fadeList(final,0,.15)
fadeList(raw,1,.25);scene:fade(rawLabel,1,.1);scene:wait(.6)
scene:fade(rawLabel,0,.1);fadeList(raw,0,.15);fadeList(final,1,.25)
scene:fade(priorImageCount,1,.1);scene:wait(.6)
scene:fade(priorImageCount,0,.1)
for y=0,trace.h-1 do
 scene:fade(scans[y],1,.08)
 local ops={}
 for i,s in ipairs(data.imageRle) do if s.y==y then ops[#ops+1]={target=final[i],opacity=0} end end
 for i,s in ipairs(nested.finalRle) do if s.y==y then ops[#ops+1]={target=newFinal[i],opacity=1} end end
 if #ops>0 then scene:play(ops,.25) else scene:wait(.25) end
 scene:wait(.3);scene:fade(scans[y],0,.08)
end
scene:fade(finalLabel,1,.15);scene:wait(.7)
-- Prepare has not edited the old Surface. Rendering redraws from source colors.
scene:fade(prepare,0,.15);scene:fade(rendering,1,.15)
local clear={};for y=0,trace.h-1 do for x=0,trace.w-1 do clear[#clear+1]={target=output[y*trace.stride+x],fill=rgb(trace.background)} end end
scene:play(clear,.2)
for i,s in ipairs(nested.finalRle) do
 scene:fade(newFocus[i],1,.06);scene:fade(newCopies[i],1,.04)
 scene:shift(newCopies[i],{770,0,0},.22)
 local ops={};for j=0,s.len-1 do ops[#ops+1]={target=output[s.y*trace.stride+s.x+j],fill=rgb(nested.writes[i][j+1])} end
 scene:play(ops,.12);scene:fade(newCopies[i],0,.06)
 scene:wait(s.len>=4 and .3 or .06);scene:fade(newFocus[i],0,.06)
end
scene:wait(3.5)
return scene
`;
await fs.writeFile(path.join(dir,'sw-image-nested-clip.lua'),seed+tail);
