import fs from 'node:fs/promises';import path from 'node:path';import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));const trace=JSON.parse(await fs.readFile(path.join(dir,'image-clip-trace.txt'),'utf8'));
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
await fs.writeFile(path.join(dir,'sw-image-clip-tasks.lua'),`-- Actual ThorVG clip task dependency and RLE intersection evidence.
-- No clip / viewport rectangle / circle clip are independent Canvas runs.
-- Beats: no clip; rectangle viewport; circle clip Shape RLE; task done;
-- raw image RLE; intersection preview then replace image.rle; fetch colors; write.
-- Completed preparation results are revealed; no CPU timing/scheduler trace claim.
-- Variant: independent engine run with circle cx=5.5. Text label_* standalone.
local trace=${lua(trace)}
local W,H=2400,1400
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function rgb(v) return string.format("#%02x%02x%02x",v%256,math.floor(v/256)%256,math.floor(v/65536)%256) end
local function gray(c) local v=255-math.floor(c*195/255);return string.format("#%02x%02x%02x",v,v,v) end
local function label(owner,id,text,x,y,size)
 return owner:text{id="label_"..id,text=text,point=p(x,y),font="Pretendard",role="text",size=size or 28,align={0,0.5},fill="#344158",layer=60}
end
local function rect(owner,id,x,y,w,h,fill,stroke,layer)
 return owner:rectangle{id=id,center=p(x,y),size={w,h},fill=fill,stroke=stroke or "#00000000",width=1,layer=layer or 20}
end
local bases={130,900,1670}
local gy,ry,cell=220,840,44
label(scene,"clip","Clip Shape",bases[1],160,32)
label(scene,"image","image.buf32 · Bitmap 8 × 6",bases[2],160,32)
label(scene,"surface","Surface",bases[3],160,32)
local output={}
for y=0,trace.h-1 do for x=0,trace.w-1 do
 local at=y*trace.stride+x
 rect(scene,"clip_grid_"..at,bases[1]+(x+.5)*cell,gy+(y+.5)*cell,cell-2,cell-2,"#ffffff","#d7dfe7")
 if x>=trace.tx and x<trace.tx+trace.iw and y>=trace.ty and y<trace.ty+trace.ih then
  rect(scene,"source_"..at,bases[2]+(x+.5)*cell,gy+(y+.5)*cell,cell-2,cell-2,rgb(trace.source[(y-trace.ty)*trace.iw+x-trace.tx+1]),"#cbd5df")
 end
 output[at]=rect(scene,"output_"..at,bases[3]+(x+.5)*cell,gy+(y+.5)*cell,cell-2,cell-2,rgb(trace.background),"#cbd5df")
end end
local states={}
local titles={"clip 없음","사각형 clip → viewport","원형 clip → Clip Task"}
for i=1,3 do
 states[i]=scene:group{id="state_"..i,opacity=0}
 label(states[i],"state_"..i,titles[i],130,80,32)
 label(states[i],"count_"..i,"clips.count = "..trace.cases[i].clipTasks,bases[2],660,28)
 if i<3 then label(states[i],"null_"..i,"image.rle = nullptr",bases[3],660,28) end
end
rect(states[2],"rect_clip",bases[1]+6*cell,gy+4*cell,6*cell,4*cell,"#00000000","#8858b8",42)
local c=trace.circle
states[3]:circle{id="circle_clip",center=p(bases[1]+c.cx*cell,gy+c.cy*cell),radius=c.r*cell,fill="#00000000",stroke="#8858b8",width=3,layer=42}
rect(states[3],"image_bounds",bases[1]+(trace.tx+trace.iw/2)*cell,gy+(trace.ty+trace.ih/2)*cell,trace.iw*cell,trace.ih*cell,"#00000000","#2078dc",40)
label(states[3],"bounds","파란 사각형 · 이미지 경계",bases[1],660,26)
local taskLabels=scene:group{id="task_labels",opacity=0}
label(taskLabels,"clip_task","clip.shape.rle",bases[1],745,27)
label(taskLabels,"before","image.rle",bases[2],745,27)
local previewLabel=label(taskLabels,"after","교집합 계산 결과",bases[3],745,27)
local done=scene:group{id="clip_done",opacity=0}
label(done,"done","done()",710,1000,24)
done:arrow{id="dependency",from=p(690,1050),to=p(860,1050),stroke="#526579",width=2,tip=10}
local function spanGlyph(id,s,base)
 local g=scene:group{id=id,opacity=0}
 local bx=base+(s.x+.5)*cell;local by=ry+(s.y+.5)*cell;local ex=bx+s.len*cell
 rect(g,id.."_begin",bx,by,cell-2,cell-2,gray(s.coverage),"#cbd5df",22)
 g:line{id=id.."_len",from=p(bx,by),to=p(ex,by),stroke="#526579",width=2.5,layer=28}
 g:line{id=id.."_end",from=p(ex,by-5),to=p(ex,by+5),stroke="#526579",width=1.5,layer=28}
 return g
end
local data=trace.cases[3]
local clips,raw,final,focus,copies={},{},{},{},{}
local prepare=scene:group{id="prepare_phase",opacity=0}
label(prepare,"prepare","Prepare · 영역 계산",1670,80,30)
local rendering=scene:group{id="render_phase",opacity=0}
label(rendering,"render","Rendering · 색상 읽기 / 합성",1670,80,30)
label(rendering,"fetch","image.buf32 → Surface",1670,745,28)
label(rendering,"coverage_role","위치 · coverage",900,1280,26)
local scans={}
for y=0,trace.h-1 do
 local g=scene:group{id="scan_"..y,opacity=0};scans[y]=g
 for lane=1,3 do rect(g,"scan_row_"..y.."_"..lane,bases[lane]+trace.w*cell/2,ry+(y+.5)*cell,trace.w*cell-3,cell-3,"#00000000","#cf8c30",45) end
end
for i,s in ipairs(data.clipRle) do clips[i]=spanGlyph("clip_span_"..i,s,bases[1]) end
for i,s in ipairs(data.rawRle) do raw[i]=spanGlyph("raw_span_"..i,s,bases[2]) end
for i,s in ipairs(data.imageRle) do
 final[i]=spanGlyph("final_span_"..i,s,bases[3])
 local g=scene:group{id="focus_"..i,opacity=0};focus[i]=g
 label(g,"record_"..i,"x "..s.x.." · y "..s.y.." · len "..s.len.." · coverage "..s.coverage,bases[3],1280,24)
 rect(g,"select_"..i,bases[2]+(s.x+s.len/2)*cell,ry+(s.y+.5)*cell,s.len*cell-3,cell-3,"#00000000","#cf8c30",45)
 for lane=2,3 do rect(g,"sample_"..i.."_"..lane,bases[lane]+(s.x+s.len/2)*cell,gy+(s.y+.5)*cell,s.len*cell-3,cell-3,"#00000000","#cf8c30",45) end
 local copy=scene:group{id="fetch_copy_"..i,opacity=0};copies[i]=copy
 for j=0,s.len-1 do
  local source=(s.y-trace.ty)*trace.iw+s.x+j-trace.tx+1
  rect(copy,"fetch_pixel_"..i.."_"..j,bases[2]+(s.x+j+.5)*cell,gy+(s.y+.5)*cell,cell-4,cell-4,rgb(trace.source[source]),"#526579",55)
 end
end
local counts=scene:group{id="rle_counts",opacity=0}
label(counts,"clip_count",#data.clipRle.." spans",bases[1],790,24)
label(counts,"final_count",#data.imageRle.." spans",bases[2],790,24)
local function paintCase(index)
 local ops={}
 for y=0,trace.h-1 do for x=0,trace.w-1 do local at=y*trace.stride+x;ops[#ops+1]={target=output[at],fill=rgb(trace.cases[index].pixels[at+1])} end end
 scene:play(ops,.35)
end
scene:fade(states[1],1,.15);paintCase(1);scene:wait(1.3)
scene:fade(states[1],0,.12);scene:fade(states[2],1,.2);paintCase(2);scene:wait(1.8)
scene:fade(states[2],0,.12)
local clear={};for y=0,trace.h-1 do for x=0,trace.w-1 do clear[#clear+1]={target=output[y*trace.stride+x],fill=rgb(trace.background)} end end
scene:play(clear,.2);scene:fade(states[3],1,.2);scene:fade(taskLabels,1,.15);scene:fade(prepare,1,.15)
for _,g in ipairs(clips) do scene:fade(g,1,.035) end
scene:fade(done,1,.2);scene:wait(.4)
for _,g in ipairs(raw) do scene:fade(g,1,.10) end
scene:wait(.4)
-- Preview the intersection while retaining both inputs; Surface remains blank.
for y=0,trace.h-1 do
 scene:fade(scans[y],1,.08)
 local ops={};for i,s in ipairs(data.imageRle) do if s.y==y then ops[#ops+1]={target=final[i],opacity=1} end end
 if #ops>0 then scene:play(ops,.20) else scene:wait(.20) end
 scene:wait(.25);scene:fade(scans[y],0,.08)
end
-- rleClip builds out, then replaces image.rle->spans. Clip RLE is unchanged.
local clearRaw={};for _,g in ipairs(raw) do clearRaw[#clearRaw+1]={target=g,opacity=0} end
scene:play(clearRaw,.15);scene:fade(previewLabel,0,.12);scene:fade(done,0,.12)
local commit={};for _,g in ipairs(final) do commit[#commit+1]={target=g,shift={bases[2]-bases[3],0,0}} end
scene:play(commit,.65);scene:fade(counts,1,.15);scene:wait(.6)
scene:fade(prepare,0,.12);scene:fade(rendering,1,.15)
-- Read colors from the retained Bitmap; only copies travel to Surface.
for i,s in ipairs(data.imageRle) do
 scene:fade(focus[i],1,.06);scene:fade(copies[i],1,.04)
 scene:shift(copies[i],{bases[3]-bases[2],0,0},.22)
 local ops={};for j=0,s.len-1 do ops[#ops+1]={target=output[s.y*trace.stride+s.x+j],fill=rgb(data.writes[i][j+1])} end
 scene:play(ops,.12);scene:fade(copies[i],0,.06)
 scene:wait(s.len>=4 and .3 or .06);scene:fade(focus[i],0,.06)
end
scene:wait(3)
return scene
`);
