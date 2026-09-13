-- Actual ThorVG coverage/output, versus a hypothetical dense coverage traversal.
-- Draw-stage comparison only. Coverage entries and spans are different-size records.
-- Equal conceptual action slots: one coverage read/decision OR one pixel write.
-- Not equal CPU cycles or measured time. Dense: 54+44=98; RLE: 29+44=73.
-- Beat ledger: inspect same input; start both; reuse long spans; RLE completes
-- while dense continues; hold identical outputs and different action totals.
-- Measured on this arm64 host: sizeof(SwSpan)=16; capacity/allocation omitted.
-- Text ledger: label_* standalone. No Text is backed by a Rectangle.
-- Variant: the independently rerun engine trace with first vertex x=2.0.
-- BEGIN ENGINE TRACE
local trace={w=12,h=8,stride=16,background=4292800762,color=4292638752,polygon={{1.25,1.25},{9.5,2.75},{8.25,6.5},{2.25,5.75}},spans={{x=1,y=1,len=1,coverage=116,offset=17,writes={4292721046}},{x=2,y=1,len=1,coverage=135,offset=18,writes={4292653191}},{x=3,y=1,len=1,coverage=88,offset=19,writes={4292724399}},{x=4,y=1,len=1,coverage=42,offset=20,writes={4292730069}},{x=5,y=1,len=1,coverage=4,offset=21,writes={4292800246}},{x=1,y=2,len=1,coverage=122,offset=33,writes={4292720273}},{x=2,y=2,len=3,coverage=255,offset=34,writes={4292638752,4292638752,4292638752}},{x=5,y=2,len=1,coverage=247,offset=37,writes={4292639783}},{x=6,y=2,len=1,coverage=204,offset=38,writes={4292710475}},{x=7,y=2,len=1,coverage=158,offset=39,writes={4292650354}},{x=8,y=2,len=1,coverage=111,offset=40,writes={4292721563}},{x=9,y=2,len=1,coverage=36,offset=41,writes={4292730842}},{x=1,y=3,len=1,coverage=65,offset=49,writes={4292727234}},{x=2,y=3,len=7,coverage=255,offset=50,writes={4292638752,4292638752,4292638752,4292638752,4292638752,4292638752,4292638752}},{x=9,y=3,len=1,coverage=64,offset=57,writes={4292727491}},{x=1,y=4,len=1,coverage=12,offset=65,writes={4292799215}},{x=2,y=4,len=1,coverage=253,offset=66,writes={4292639009}},{x=3,y=4,len=5,coverage=255,offset=67,writes={4292638752,4292638752,4292638752,4292638752,4292638752}},{x=8,y=4,len=1,coverage=232,offset=72,writes={4292641588}},{x=9,y=4,len=1,coverage=3,offset=73,writes={4292800247}},{x=2,y=5,len=1,coverage=169,offset=82,writes={4292714601}},{x=3,y=5,len=1,coverage=231,offset=83,writes={4292641589}},{x=4,y=5,len=4,coverage=255,offset=84,writes={4292638752,4292638752,4292638752,4292638752}},{x=8,y=5,len=1,coverage=149,offset=88,writes={4292651642}},{x=4,y=6,len=1,coverage=9,offset=100,writes={4292799474}},{x=5,y=6,len=1,coverage=39,offset=101,writes={4292795864}},{x=6,y=6,len=1,coverage=71,offset=102,writes={4292726461}},{x=7,y=6,len=1,coverage=103,offset=103,writes={4292722594}},{x=8,y=6,len=1,coverage=42,offset=104,writes={4292730069}}},pixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292721046,4292653191,4292724399,4292730069,4292800246,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292720273,4292638752,4292638752,4292638752,4292639783,4292710475,4292650354,4292721563,4292730842,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292727234,4292638752,4292638752,4292638752,4292638752,4292638752,4292638752,4292638752,4292727491,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292799215,4292639009,4292638752,4292638752,4292638752,4292638752,4292638752,4292641588,4292800247,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292714601,4292641589,4292638752,4292638752,4292638752,4292638752,4292651642,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292799474,4292795864,4292726461,4292722594,4292730069,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762},verifiedCanvasMatch=true}
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
