import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const trace=JSON.parse(await fs.readFile(path.join(dir,'image-path-trace.txt'),'utf8'));
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
await fs.writeFile(path.join(dir,'sw-image-paths.lua'),`-- Actual clip-free ThorVG CPU output. No RLE is generated in any stage.
-- Beat ledger: retain source; show transformed image boundary; reveal actual
-- Direct/Scale rows; Rotation diagonal split; T1 then T2 texture output; hold.
-- Row reveal is an exposition of completed Canvas pixels, not an instrumented
-- texture raster loop or stored span traversal. Variant: actual 45-degree run.
-- All label_* Text is standalone. Outline selection is not text containment.
local trace=${lua(trace)}
local W,H=1800,1100
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function rgb(v) return string.format("#%02x%02x%02x",v%256,math.floor(v/256)%256,math.floor(v/65536)%256) end
local function label(owner,id,text,x,y,size)
 return owner:text{id="label_"..id,text=text,point=p(x,y),font="Pretendard",role="text",size=size or 28,align={0,0.5},fill="#344158",layer=60}
end
local function rect(owner,id,x,y,w,h,fill,stroke,layer)
 return owner:rectangle{id=id,center=p(x,y),size={w,h},fill=fill,stroke=stroke or "#00000000",width=1,layer=layer or 20}
end
local sx,sy,sc=120,350,40
local dx,dy,dc=850,160,32
label(scene,"image","Image · 12 × 8",sx,275,32)
label(scene,"surface","SwSurface · 24 × 20",dx,85,32)
label(scene,"rle","image.rle = nullptr",sx,850,29)
label(scene,"clips","clips.count = 0",sx,905,29)
scene:arrow{id="sample_flow",from=p(650,510),to=p(790,510),stroke="#526579",width=2.5,tip=12}
for y=0,trace.ih-1 do for x=0,trace.iw-1 do
 rect(scene,"source_"..(y*trace.iw+x),sx+(x+.5)*sc,sy+(y+.5)*sc,sc-2,sc-2,rgb(trace.source[y*trace.iw+x+1]),"#cbd5df")
end end
local outputs={}
for y=0,trace.h-1 do for x=0,trace.w-1 do
 local at=y*trace.stride+x
 outputs[at]=rect(scene,"output_"..at,dx+(x+.5)*dc,dy+(y+.5)*dc,dc-2,dc-2,rgb(trace.background),"#cbd5df")
end end
local stages={}
local rotation=trace.stages[3]
local triangles={}
local uv={{0,0},{trace.iw,0},{trace.iw,trace.ih},{0,trace.ih}}
local previous={};for i=1,#rotation.pixels do previous[i]=trace.background end
for k,t in ipairs(rotation.triangles) do
 local g=scene:group{id="triangle_"..k,opacity=0}
 local dest=scene:group{id="triangle_dest_"..k,opacity=0}
 local color=k==1 and "#cf8c30" or "#8858b8"
 label(g,"triangle_"..k,"T"..k.." · UV → color",sx,745,28)
 for j=1,3 do
  local a,b=t.indices[j]+1,t.indices[j%3+1]+1
  g:line{id="uv_edge_"..k.."_"..j,from=p(sx+uv[a][1]*sc,sy+uv[a][2]*sc),to=p(sx+uv[b][1]*sc,sy+uv[b][2]*sc),stroke=color,width=3,layer=42}
  dest:line{id="triangle_edge_"..k.."_"..j,from=p(dx+rotation.quad[a][1]*dc,dy+rotation.quad[a][2]*dc),to=p(dx+rotation.quad[b][1]*dc,dy+rotation.quad[b][2]*dc),stroke=color,width=3,layer=42}
 end
 local rows={}
 for y=0,trace.h-1 do
  local first,last=nil,nil
  for x=0,trace.w-1 do local at=y*trace.stride+x+1;if t.pixels[at]~=previous[at] then first=first or x;last=x end end
  if first then
   local row=scene:group{id="triangle_row_"..k.."_"..y,opacity=0}
   rect(row,"triangle_cursor_"..k.."_"..y,dx+(first+(last-first+1)/2)*dc,dy+(y+.5)*dc,(last-first+1)*dc-3,dc-3,"#00000000",color,45)
   rows[#rows+1]={y=y,group=row}
  end
 end
 triangles[k]={group=g,dest=dest,rows=rows,pixels=t.pixels}
 previous=t.pixels
end
local split=scene:group{id="triangle_split",opacity=0}
for _,v in ipairs({{sx,sy,sc,uv},{dx,dy,dc,rotation.quad}}) do
 split:line{from=p(v[1]+v[4][2][1]*v[3],v[2]+v[4][2][2]*v[3]),to=p(v[1]+v[4][4][1]*v[3],v[2]+v[4][4][2]*v[3]),stroke="#526579",width=3,layer=42}
end
local methods={"rasterDirectImage()","rasterScaledImage()","rasterTexmapPolygon()"}
for i,s in ipairs(trace.stages) do
 local g=scene:group{id="stage_"..i,opacity=0}
 label(g,"stage_"..i,s.name..(s.name=="Rotation" and " · "..s.angle.."°" or ""),dx,920,32)
 label(g,"method_"..i,methods[i],dx,980,28)
 local edges={}
 for j=1,4 do
  local a,b=s.quad[j],s.quad[j%4+1]
  edges[j]=g:line{id="edge_"..i.."_"..j,from=p(dx+a[1]*dc,dy+a[2]*dc),to=p(dx+b[1]*dc,dy+b[2]*dc),stroke="#2078dc",width=2.5,layer=40}
 end
 local rows={}
 for y=0,trace.h-1 do
  rows[y]=scene:group{id="row_"..i.."_"..y,opacity=0}
  rect(rows[y],"row_cursor_"..i.."_"..y,dx+trace.w*dc/2,dy+(y+.5)*dc,trace.w*dc-3,dc-3,"#00000000","#cf8c30",45)
 end
 stages[i]={group=g,rows=rows,edges=edges}
end
scene:wait(.8)
for i,s in ipairs(trace.stages) do
 if i>1 then
  scene:fade(stages[i-1].group,0,.15)
  local clear={}
  for y=0,trace.h-1 do for x=0,trace.w-1 do clear[#clear+1]={target=outputs[y*trace.stride+x],fill=rgb(trace.background)} end end
  scene:play(clear,.20)
 end
 scene:fade(stages[i].group,1,.30)
 scene:wait(.5)
 local fadeEdges={}
 for _,edge in ipairs(stages[i].edges) do fadeEdges[#fadeEdges+1]={target=edge,opacity=0} end
 scene:play(fadeEdges,.15)
 if i==3 then
  scene:fade(split,1,.2);scene:wait(.6);scene:fade(split,0,.1)
  for _,t in ipairs(triangles) do
   scene:play({{target=t.group,opacity=1},{target=t.dest,opacity=1}},.15);scene:wait(.4);scene:fade(t.dest,0,.1)
   for _,row in ipairs(t.rows) do
    scene:fade(row.group,1,.04)
    local writes={}
    for x=0,trace.w-1 do local at=row.y*trace.stride+x;writes[#writes+1]={target=outputs[at],fill=rgb(t.pixels[at+1])} end
    scene:play(writes,.14);scene:wait(.06);scene:fade(row.group,0,.04)
   end
   scene:wait(.7);scene:fade(t.group,0,.12)
  end
 else
 for y=0,trace.h-1 do
  scene:fade(stages[i].rows[y],1,.04)
  local writes={}
  for x=0,trace.w-1 do local at=y*trace.stride+x;writes[#writes+1]={target=outputs[at],fill=rgb(s.pixels[at+1])} end
  scene:play(writes,.08)
  scene:wait(.04)
  scene:fade(stages[i].rows[y],0,.04)
 end
 end
 scene:wait(i==#trace.stages and 3 or 1.5)
end
return scene
`);
