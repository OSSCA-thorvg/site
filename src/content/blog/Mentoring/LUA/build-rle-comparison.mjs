import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const trace=JSON.parse(await fs.readFile(path.join(dir,'rle-engine-trace.txt'),'utf8'));
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
await fs.writeFile(path.join(dir,'sw-rle-comparison.lua'),`-- Actual ThorVG coverage/output, versus a hypothetical dense coverage traversal.
-- Draw-stage comparison only. Coverage entries and spans are different-size records.
-- Equal conceptual action slots: one coverage read/decision OR one pixel write.
-- Not equal CPU cycles or measured time. Dense: 54+44=98; RLE: 29+44=73.
-- Beat ledger: inspect same input; start both; reuse long spans; RLE completes
-- while dense continues; hold identical outputs and different action totals.
-- Measured on this arm64 host: sizeof(SwSpan)=16; capacity/allocation omitted.
-- Text ledger: label_* standalone. No Text is backed by a Rectangle.
-- Variant: the independently rerun engine trace with first vertex x=2.0.
-- BEGIN ENGINE TRACE
local trace=${lua(trace)}
-- END ENGINE TRACE
local W,H=2400,1500
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function rgb(v) return string.format("#%02x%02x%02x",v%256,math.floor(v/256)%256,math.floor(v/65536)%256) end
local function gray(c) local v=255-math.floor(c*195/255);return string.format("#%02x%02x%02x",v,v,v) end
local function label(owner,id,value,x,y,size)
 return owner:text{id="label_"..id,text=value,point=p(x,y),font="Pretendard",role="text",size=size or 28,align={0,0.5},fill="#344158",layer=60}
end
local function rect(owner,id,x,y,w,h,fill,stroke,layer,opacity)
 return owner:rectangle{id=id,center=p(x,y),size={w,h},fill=fill,stroke=stroke or "#00000000",width=1,layer=layer or 20,opacity=opacity == nil and 1 or opacity}
end
local left,right,inputY,outputY,cell=200,1400,330,950,64
local minx,miny,maxx,maxy=trace.w,trace.h,0,0
local coverage,ownerSpan={},{}
local writes=0
for i,s in ipairs(trace.spans) do
 minx=math.min(minx,s.x);miny=math.min(miny,s.y);maxx=math.max(maxx,s.x+s.len);maxy=math.max(maxy,s.y+1)
 for j=0,s.len-1 do local at=s.y*trace.stride+s.x+j;coverage[at]=s.coverage;ownerSpan[at]=i;writes=writes+1 end
end
local cols,rows=maxx-minx,maxy-miny
local area=cols*rows
label(scene,"dense","No RLE (dense)",left,110,36)
label(scene,"rle","ThorVG RLE",right,110,36)
label(scene,"dense_count",area.." coverage values",left,230,30)
label(scene,"span_count",#trace.spans.." spans",right,230,30)
label(scene,"surface_left","Surface",left,860,30)
label(scene,"surface_right","Surface",right,860,30)
label(scene,"model","작업 단계 모델",1020,110,25)
label(scene,"legend_read","주황: 조회·판정",1020,750,24)
label(scene,"legend_write","파랑: 픽셀 쓰기",1020,795,24)
local done,totals={},{}
for lane,base in ipairs({left,right}) do
 done[lane]=scene:group{id="done_"..lane,opacity=0}
 label(done[lane],"done_"..lane,"완료",base+460,860,30)
 totals[lane]=scene:group{id="totals_"..lane,opacity=0}
 local reads=lane==1 and area or #trace.spans
 label(totals[lane],"total_"..lane,reads.." + "..writes.." = "..(reads+writes).." 단계",base,780,30)
 label(totals[lane],"writes_"..lane,writes.." pixel writes",base,1400,30)
end
local outputs={{},{}}
local denseFocus={}
for y=miny,maxy-1 do for x=minx,maxx-1 do
 local at=y*trace.stride+x;local dx=(x-minx+.5)*cell;local dy=(y-miny+.5)*cell
 rect(scene,"coverage_"..at,left+dx,inputY+dy,cell-2,cell-2,gray(coverage[at] or 0),"#ccd5df")
 denseFocus[at]=rect(scene,"dense_read_"..at,left+dx,inputY+dy,cell-5,cell-5,"#00000000","#cf8c30",40,0)
 for lane,base in ipairs({left,right}) do
  outputs[lane][at]=rect(scene,"output_"..lane.."_"..at,base+dx,outputY+dy,cell-2,cell-2,rgb(trace.background),"#ccd5df")
 end
end end
local rleFocus={}
for i,s in ipairs(trace.spans) do
 local bx=right+(s.x-minx+.5)*cell;local by=inputY+(s.y-miny+.5)*cell;local ex=bx+s.len*cell
 rect(scene,"span_"..i.."_begin",bx,by,cell*.36,cell*.36,gray(s.coverage))
 scene:line{id="span_"..i.."_len",from=p(bx,by),to=p(ex,by),stroke=gray(s.coverage),width=2.5,layer=25}
 scene:line{id="span_"..i.."_end",from=p(ex,by-5),to=p(ex,by+5),stroke=gray(s.coverage),width=2,layer=25}
 local g=scene:group{id="rle_read_"..i,opacity=0};rleFocus[i]=g
 rect(g,"rle_cursor_"..i,bx,by,30,30,"#00000000","#cf8c30",40)
 g:line{id="rle_len_cursor_"..i,from=p(bx,by),to=p(ex,by),stroke="#cf8c30",width=3,layer=40}
end
-- Build independent action streams from the same engine coverage.
local actions={{},{}}
for y=miny,maxy-1 do for x=minx,maxx-1 do
 local at=y*trace.stride+x
 table.insert(actions[1],{kind="read",at=at,focus=denseFocus[at]})
 if coverage[at] then table.insert(actions[1],{kind="write",at=at,focus=denseFocus[at]}) end
end end
for i,s in ipairs(trace.spans) do
 table.insert(actions[2],{kind="read",focus=rleFocus[i]})
 for j=0,s.len-1 do table.insert(actions[2],{kind="write",at=s.y*trace.stride+s.x+j,focus=rleFocus[i]}) end
end
local slots=math.max(#actions[1],#actions[2])
local tokens={{},{}}
for lane,base in ipairs({left,right}) do
 for i=1,#actions[lane] do
  tokens[lane][i]=rect(scene,"action_"..lane.."_"..i,base+(i-.5)*576/slots,175,576/slots-1,14,"#dfe5ec")
 end
end
scene:wait(1)
local active={}
for step=1,slots do
 local focusOps,workOps={},{}
 for lane=1,2 do
  local action=actions[lane][step]
  local nextFocus=action and action.focus or nil
  if active[lane]~=nextFocus then
   if active[lane] then table.insert(focusOps,{target=active[lane],opacity=0}) end
   if nextFocus then table.insert(focusOps,{target=nextFocus,opacity=1}) end
   active[lane]=nextFocus
  end
  if action then
   table.insert(workOps,{target=tokens[lane][step],fill=action.kind=="read" and "#cf8c30" or "#2078dc"})
   if action.kind=="write" then table.insert(workOps,{target=outputs[lane][action.at],fill=rgb(trace.pixels[action.at+1])}) end
   if step==#actions[lane] then
    table.insert(workOps,{target=done[lane],opacity=1})
    table.insert(workOps,{target=totals[lane],opacity=1})
   end
  end
 end
 if #focusOps>0 then scene:play(focusOps,0.06) else scene:wait(0.06) end
 scene:play(workOps,0.12)
 scene:wait(0.06)
end
local cleanup={}
for lane=1,2 do if active[lane] then table.insert(cleanup,{target=active[lane],opacity=0}) end end
scene:play(cleanup,0.12)
scene:wait(3)
return scene
`);
