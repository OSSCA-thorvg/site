import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const trace=JSON.parse(await fs.readFile(path.join(dir,'rle-color-trace.txt'),'utf8'));
trace.lanes=trace.lanes.slice(0,2);
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
await fs.writeFile(path.join(dir,'sw-rle-color-sources.lua'),`-- ThorVG 6cf10d4 CPU trace: identical spans, two independent Shape color sources.
-- The upper gradient grid displays actual fillLinear samples at pixel positions,
-- not a literal 2D ctable. Only the solid/gradient trace lanes are used here.
-- Copies are sampled colors; source/RLE objects remain retained. Color transition
-- previews actual composition with the beige destination, not elapsed CPU time.
-- Beat ledger: inspect sources; sample active span; apply coverage; commit output;
-- repeat all 29 actual records; retain two distinct surfaces with same coverage.
-- Variant: independent engine run with first polygon vertex x=2.0.
-- Text ledger: all label_* are standalone, no backing text panels.
local trace=${lua(trace)}
local W,H=1800,1600
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function rgb(v) return string.format("#%02x%02x%02x",v%256,math.floor(v/256)%256,math.floor(v/65536)%256) end
local function gray(c) local v=255-math.floor(c*195/255);return string.format("#%02x%02x%02x",v,v,v) end
local function label(owner,id,value,x,y,size)
 return owner:text{id="label_"..id,text=value,point=p(x,y),font="Pretendard",role="text",size=size or 28,align={0,0.5},fill="#344158",layer=60}
end
local function rect(owner,id,x,y,w,h,fill,stroke,layer)
 return owner:rectangle{id=id,center=p(x,y),size={w,h},fill=fill,stroke=stroke or "#00000000",width=1.5,layer=layer or 20}
end
local bases={130,1000}
local inputY,outputY,gateY,cell=210,1050,820,50
local names={"단색 · RenderColor","Gradient · 위치별 ctable 조회"}
local outputs,events={},{}
for lane,base in ipairs(bases) do
 local data=trace.lanes[lane];outputs[lane]={};events[lane]={}
 label(scene,"source_"..lane,names[lane],base,115,32)
 label(scene,"rle_"..lane,"RLE",base,680,28)
 label(scene,"surface_"..lane,"Surface",base,995,32)
 for y=0,trace.h-1 do for x=0,trace.w-1 do
  local at=y*trace.stride+x
  rect(scene,"source_"..lane.."_"..at,base+(x+.5)*cell,inputY+(y+.5)*cell,cell-2,cell-2,rgb(data.source[at+1]),"#cbd5df")
  outputs[lane][at]=rect(scene,"output_"..lane.."_"..at,base+(x+.5)*cell,outputY+(y+.5)*cell,cell-2,cell-2,rgb(trace.background),"#cbd5df")
 end end
 for i,s in ipairs(data.spans) do
  local g=scene:group{id="focus_"..lane.."_"..i,opacity=0}
  label(g,"span_"..lane.."_"..i,"x "..s.x.." · y "..s.y.." · len "..s.len.." · coverage "..s.coverage,base,730,25)
  rect(g,"read_range_"..lane.."_"..i,base+(s.x+s.len/2)*cell,inputY+(s.y+.5)*cell,s.len*cell-4,cell-4,"#00000000","#cf8c30",45)
  rect(g,"write_range_"..lane.."_"..i,base+(s.x+s.len/2)*cell,outputY+(s.y+.5)*cell,s.len*cell-4,cell-4,"#00000000","#cf8c30",45)
  local bx=base+(s.x+.5)*cell;local ex=bx+s.len*cell
  -- Full pixel at begin; the length line starts at its center.
  rect(g,"span_begin_"..lane.."_"..i,bx,gateY,cell-2,cell-2,gray(s.coverage),"#adb8c5",25)
  g:line{id="span_len_"..lane.."_"..i,from=p(bx,gateY),to=p(ex,gateY),stroke=gray(s.coverage),width=3,layer=26}
  g:line{id="span_end_"..lane.."_"..i,from=p(ex,gateY-6),to=p(ex,gateY+6),stroke=gray(s.coverage),width=2,layer=26}
  local tokens={}
  for j=0,s.len-1 do
   local at=s.offset+j
   local token=scene:group{id="token_"..lane.."_"..i.."_"..j,opacity=0}
   local body=rect(token,"sample_"..lane.."_"..i.."_"..j,base+(s.x+j+.5)*cell,inputY+(s.y+.5)*cell,cell-8,cell-8,rgb(data.source[at+1]),"#ffffff",38)
   tokens[#tokens+1]={owner=token,body=body,at=at,result=s.writes[j+1]}
  end
  events[lane][i]={focus=g,tokens=tokens,span=s}
 end
end
scene:wait(1)
for i=1,#trace.lanes[1].spans do
 local reveal,toGate,blend,toSurface,commit,hide={},{},{},{},{},{}
 for lane=1,#bases do
  local e=events[lane][i];local s=e.span
  reveal[#reveal+1]={target=e.focus,opacity=1}
  hide[#hide+1]={target=e.focus,opacity=0}
  for _,token in ipairs(e.tokens) do
   reveal[#reveal+1]={target=token.owner,opacity=1}
   toGate[#toGate+1]={target=token.owner,shift={0,-(gateY-inputY-(s.y+.5)*cell)}}
   blend[#blend+1]={target=token.body,fill=rgb(token.result)}
   toSurface[#toSurface+1]={target=token.owner,shift={0,-(outputY+(s.y+.5)*cell-gateY)}}
   commit[#commit+1]={target=outputs[lane][token.at],fill=rgb(token.result)}
   commit[#commit+1]={target=token.owner,opacity=0}
  end
 end
 scene:play(reveal,.12)
 scene:play(toGate,.30,"ease_in_out")
 scene:wait(i==1 and .50 or .12)
 scene:play(blend,.18)
 scene:play(toSurface,.30,"ease_in_out")
 scene:play(commit,.08)
 scene:wait(trace.lanes[1].spans[i].len>=3 and .35 or .08)
 -- Keep the last actual span as the settled coverage reference.
 if i<#trace.lanes[1].spans then scene:play(hide,.06) end
end
-- Final comparison retains the longest shared span for easy source inspection.
local longest=1
for i,s in ipairs(trace.lanes[1].spans) do if s.len>trace.lanes[1].spans[longest].len then longest=i end end
local finalOut,finalIn={},{}
for lane=1,#bases do
 if longest~=#trace.lanes[1].spans then
  finalOut[#finalOut+1]={target=events[lane][#trace.lanes[1].spans].focus,opacity=0}
  finalIn[#finalIn+1]={target=events[lane][longest].focus,opacity=1}
 end
end
if #finalOut>0 then scene:play(finalOut,.06);scene:play(finalIn,.06) else scene:wait(.12) end
scene:wait(3)
return scene
`);
