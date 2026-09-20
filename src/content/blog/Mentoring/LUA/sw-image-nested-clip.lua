-- Actual ThorVG clip task dependency and RLE intersection evidence.
-- One circle clip; earlier no-clip/viewport fixtures are not shown.
-- Beats: circle clip Shape RLE; task done;
-- raw image RLE; intersection preview then replace image.rle; fetch colors; write.
-- Completed preparation results are revealed; no CPU timing/scheduler trace claim.
-- Variant: independent engine run with circle cx=5.5. Text label_* standalone.
local trace={w=12,h=8,stride=16,iw=8,ih=6,tx=2,ty=1,background=4292800762,circle={cx=6,cy=4,r=3.25},source={4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4282434810,4282434810,4286608722,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4286608722,4286608722,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4286608722,4286608722,4286608722,4286608722,4293906576,4286608722,4286608722,4286608722,4286608722,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993},cases={{clipTasks=0,fastTrack=false,clipRle={},rawRle={},imageRle={},writes={},pixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4282434810,4282434810,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4286608722,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4286608722,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4286608722,4286608722,4286608722,4293906576,4286608722,4286608722,4286608722,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762}},{clipTasks=0,fastTrack=true,clipRle={},rawRle={},imageRle={},writes={},pixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4293906576,4293906576,4293906576,4293906576,4293906576,4282434810,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4286608722,4286608722,4293906576,4286608722,4286608722,4286608722,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762}},{clipTasks=1,fastTrack=false,clipRle={{x=4,y=0,len=1,coverage=2},{x=5,y=0,len=2,coverage=39},{x=7,y=0,len=1,coverage=2},{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=209},{x=8,y=1,len=1,coverage=38},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=4,coverage=255},{x=8,y=2,len=1,coverage=208},{x=9,y=2,len=1,coverage=2},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=6,coverage=255},{x=9,y=3,len=1,coverage=37},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=6,coverage=255},{x=9,y=4,len=1,coverage=37},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=4,coverage=255},{x=8,y=5,len=1,coverage=207},{x=9,y=5,len=1,coverage=1},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=208},{x=5,y=6,len=2,coverage=255},{x=7,y=6,len=1,coverage=207},{x=8,y=6,len=1,coverage=37},{x=4,y=7,len=1,coverage=2},{x=5,y=7,len=2,coverage=37},{x=7,y=7,len=1,coverage=1}},rawRle={{x=2,y=1,len=8,coverage=255},{x=2,y=2,len=8,coverage=255},{x=2,y=3,len=8,coverage=255},{x=2,y=4,len=8,coverage=255},{x=2,y=5,len=8,coverage=255},{x=2,y=6,len=8,coverage=255}},imageRle={{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=209},{x=8,y=1,len=1,coverage=38},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=4,coverage=255},{x=8,y=2,len=1,coverage=208},{x=9,y=2,len=1,coverage=2},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=6,coverage=255},{x=9,y=3,len=1,coverage=37},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=6,coverage=255},{x=9,y=4,len=1,coverage=37},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=4,coverage=255},{x=8,y=5,len=1,coverage=207},{x=9,y=5,len=1,coverage=1},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=208},{x=5,y=6,len=2,coverage=255},{x=7,y=6,len=1,coverage=207},{x=8,y=6,len=1,coverage=37}},writes={{4292996073},{4293645986},{4293906576,4293906576},{4293711523},{4292996073},{4292800761},{4293645986},{4293906576,4293906576,4293906576,4293906576},{4284337658},{4292669690},{4291878367},{4293906576,4293906576,4293906576,4293906576,4293906576,4286608722},{4291878625},{4291878367},{4286608722,4293906576,4293906576,4293906576,4286608722,4286608722},{4291878625},{4292734968},{4287728496},{4286608722,4293906576,4286608722,4286608722},{4287794289},{4292800505},{4291486429},{4285638243},{4284060993,4284060993},{4285703779},{4291486686}},pixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292996073,4293645986,4293906576,4293906576,4293711523,4292996073,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800761,4293645986,4293906576,4293906576,4293906576,4293906576,4284337658,4292669690,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4291878625,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4291878625,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292734968,4287728496,4286608722,4293906576,4286608722,4286608722,4287794289,4292800505,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291486429,4285638243,4284060993,4284060993,4285703779,4291486686,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762}}}}
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
 output[at]=rect(scene,"output_"..at,bases[3]+(x+.5)*cell,gy+(y+.5)*cell,cell-2,cell-2,rgb(trace.cases[3].pixels[at+1]),"#cbd5df")
end end
local states={[3]=scene:group{id="state_3"}}
local stateTitle=label(states[3],"state_3","Circle Clip → Clip Task",130,80,32)
local stateCount=label(states[3],"count_3","clips.count = "..trace.cases[3].clipTasks,bases[2],660,28)
local c=trace.circle
local circleClip=states[3]:circle{id="circle_clip",center=p(bases[1]+c.cx*cell,gy+c.cy*cell),radius=c.r*cell,fill="#00000000",stroke="#8858b8",width=3,layer=42}
rect(states[3],"image_bounds",bases[1]+(trace.tx+trace.iw/2)*cell,gy+(trace.ty+trace.ih/2)*cell,trace.iw*cell,trace.ih*cell,"#00000000","#2078dc",40)
label(states[3],"bounds","파란 사각형 · 이미지 경계",bases[1],660,26)
local taskLabels=scene:group{id="task_labels",opacity=1}
local clipLabel=label(taskLabels,"clip_task","clip.shape.rle",bases[1],745,27)
label(taskLabels,"before","image.rle",bases[2],745,27)
local previewLabel=label(scene:group{id="hidden_preview_label",opacity=0},"after","교집합 계산 결과",bases[3],745,27)
local done=scene:group{id="clip_done",opacity=0}
label(done,"done","done()",710,1000,24)
done:arrow{id="dependency",from=p(690,1050),to=p(860,1050),stroke="#526579",width=2,tip=10}
local function spanGlyph(id,s,base)
 local g=scene:group{id=id,opacity=(string.sub(id,1,10)=="clip_span_" or string.sub(id,1,11)=="final_span_") and 1 or 0}
 local bx=base+(s.x+.5)*cell;local by=ry+(s.y+.5)*cell;local ex=bx+(s.len-1)*cell
 rect(g,id.."_begin",bx,by,cell-2,cell-2,gray(s.coverage),"#cbd5df",22)
 if s.len > 1 then
 g:line{id=id.."_len",from=p(bx,by),to=p(ex,by),stroke="#526579",width=2.5,layer=28}
 g:line{id=id.."_end",from=p(ex,by-5),to=p(ex,by+5),stroke="#526579",width=1.5,layer=28}
 end
 return g
end
local data=trace.cases[3]
local clips,raw,final,focus,copies={},{},{},{},{}
local prepare=scene:group{id="prepare_phase",opacity=0}
label(prepare,"prepare","Prepare · 영역 계산",1670,80,30)
local rendering=scene:group{id="render_phase",opacity=1}
label(rendering,"render","Rendering · 색상 읽기 / 합성",1670,80,30)
local fetchLabel=label(rendering,"fetch","image.buf32 → Surface",1670,745,28)
label(rendering,"coverage_role","위치 · coverage",900,1280,26)
local scans={}
for y=0,trace.h-1 do
 local g=scene:group{id="scan_"..y,opacity=0};scans[y]=g
 for lane=1,2 do rect(g,"scan_row_"..y.."_"..lane,bases[lane]+trace.w*cell/2,ry+(y+.5)*cell,trace.w*cell-3,cell-3,"#00000000","#cf8c30",45) end
end
for i,s in ipairs(data.clipRle) do clips[i]=spanGlyph("clip_span_"..i,s,bases[1]) end
for i,s in ipairs(data.rawRle) do raw[i]=spanGlyph("raw_span_"..i,s,bases[2]) end
for i,s in ipairs(data.imageRle) do
 final[i]=spanGlyph("final_span_"..i,s,bases[2])
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
local counts=scene:group{id="rle_counts",opacity=1}
local clipCount=label(counts,"clip_count",#data.clipRle.." spans",bases[1],790,24)
local priorImageCount=label(counts,"final_count",#data.imageRle.." spans",bases[2],790,24)

-- Continuation: exact previous final frame, then a second clip. Original Bitmap
-- stays put. Show the captured image RLE after A, then intersect with B.
-- The left lane always shows the currently discussed clip; it changes A -> B.
local nested={w=12,h=8,stride=16,iw=8,ih=6,tx=2,ty=1,background=4292800762,source={4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4293906576,4282434810,4282434810,4286608722,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4286608722,4286608722,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4286608722,4286608722,4286608722,4286608722,4293906576,4286608722,4286608722,4286608722,4286608722,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993,4284060993},firstPixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292996073,4293645986,4293906576,4293906576,4293711523,4292996073,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800761,4293645986,4293906576,4293906576,4293906576,4293906576,4284337658,4292669690,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4293906576,4293906576,4293906576,4293906576,4293906576,4286608722,4291878625,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4286608722,4293906576,4293906576,4293906576,4286608722,4286608722,4291878625,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292734968,4287728496,4286608722,4293906576,4286608722,4286608722,4287794289,4292800505,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291486429,4285638243,4284060993,4284060993,4285703779,4291486686,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762},firstRle={{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=209},{x=8,y=1,len=1,coverage=38},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=4,coverage=255},{x=8,y=2,len=1,coverage=208},{x=9,y=2,len=1,coverage=2},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=6,coverage=255},{x=9,y=3,len=1,coverage=37},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=6,coverage=255},{x=9,y=4,len=1,coverage=37},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=4,coverage=255},{x=8,y=5,len=1,coverage=207},{x=9,y=5,len=1,coverage=1},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=208},{x=5,y=6,len=2,coverage=255},{x=7,y=6,len=1,coverage=207},{x=8,y=6,len=1,coverage=37}},polygon={{0,0},{9,0},{4,8},{0,8}},clipA={{x=4,y=0,len=1,coverage=2},{x=5,y=0,len=2,coverage=39},{x=7,y=0,len=1,coverage=2},{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=209},{x=8,y=1,len=1,coverage=38},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=4,coverage=255},{x=8,y=2,len=1,coverage=208},{x=9,y=2,len=1,coverage=2},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=6,coverage=255},{x=9,y=3,len=1,coverage=37},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=6,coverage=255},{x=9,y=4,len=1,coverage=37},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=4,coverage=255},{x=8,y=5,len=1,coverage=207},{x=9,y=5,len=1,coverage=1},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=208},{x=5,y=6,len=2,coverage=255},{x=7,y=6,len=1,coverage=207},{x=8,y=6,len=1,coverage=37},{x=4,y=7,len=1,coverage=2},{x=5,y=7,len=2,coverage=37},{x=7,y=7,len=1,coverage=1}},clipB={{x=0,y=0,len=8,coverage=255},{x=8,y=0,len=1,coverage=176},{x=0,y=1,len=7,coverage=255},{x=7,y=1,len=1,coverage=243},{x=8,y=1,len=1,coverage=29},{x=0,y=2,len=7,coverage=255},{x=7,y=2,len=1,coverage=111},{x=0,y=3,len=6,coverage=255},{x=6,y=3,len=1,coverage=205},{x=7,y=3,len=1,coverage=4},{x=0,y=4,len=5,coverage=255},{x=5,y=4,len=1,coverage=253},{x=6,y=4,len=1,coverage=51},{x=0,y=5,len=5,coverage=255},{x=5,y=5,len=1,coverage=143},{x=0,y=6,len=4,coverage=255},{x=4,y=6,len=1,coverage=227},{x=5,y=6,len=1,coverage=13},{x=0,y=7,len=4,coverage=255},{x=4,y=7,len=1,coverage=80}},rawRle={{x=2,y=1,len=8,coverage=255},{x=2,y=2,len=8,coverage=255},{x=2,y=3,len=8,coverage=255},{x=2,y=4,len=8,coverage=255},{x=2,y=5,len=8,coverage=255},{x=2,y=6,len=8,coverage=255}},afterCircle={{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=209},{x=8,y=1,len=1,coverage=38},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=4,coverage=255},{x=8,y=2,len=1,coverage=208},{x=9,y=2,len=1,coverage=2},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=6,coverage=255},{x=9,y=3,len=1,coverage=37},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=6,coverage=255},{x=9,y=4,len=1,coverage=37},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=4,coverage=255},{x=8,y=5,len=1,coverage=207},{x=9,y=5,len=1,coverage=1},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=208},{x=5,y=6,len=2,coverage=255},{x=7,y=6,len=1,coverage=207},{x=8,y=6,len=1,coverage=37}},finalRle={{x=3,y=1,len=1,coverage=39},{x=4,y=1,len=1,coverage=210},{x=5,y=1,len=2,coverage=255},{x=7,y=1,len=1,coverage=199},{x=8,y=1,len=1,coverage=5},{x=2,y=2,len=1,coverage=2},{x=3,y=2,len=1,coverage=210},{x=4,y=2,len=3,coverage=255},{x=7,y=2,len=1,coverage=111},{x=2,y=3,len=1,coverage=39},{x=3,y=3,len=3,coverage=255},{x=6,y=3,len=1,coverage=205},{x=7,y=3,len=1,coverage=4},{x=2,y=4,len=1,coverage=39},{x=3,y=4,len=2,coverage=255},{x=5,y=4,len=1,coverage=253},{x=6,y=4,len=1,coverage=51},{x=2,y=5,len=1,coverage=2},{x=3,y=5,len=1,coverage=209},{x=4,y=5,len=1,coverage=255},{x=5,y=5,len=1,coverage=143},{x=3,y=6,len=1,coverage=38},{x=4,y=6,len=1,coverage=185},{x=5,y=6,len=1,coverage=13}},writes={{4292996073},{4293645986},{4293906576,4293906576},{4293646247},{4292800504},{4292800761},{4293645986},{4293906576,4293906576,4293906576},{4293255884},{4291878367},{4293906576,4293906576,4293906576},{4293711524},{4292800760},{4291878367},{4286608722,4293906576},{4293906576},{4292995813},{4292734968},{4287728496},{4286608722},{4293385919},{4291486429},{4286426740},{4292275184}},finalPixels={4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292996073,4293645986,4293906576,4293906576,4293646247,4292800504,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800761,4293645986,4293906576,4293906576,4293906576,4293255884,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4293906576,4293906576,4293906576,4293711524,4292800760,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291878367,4286608722,4293906576,4293906576,4292995813,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292734968,4287728496,4286608722,4293385919,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4291486429,4286426740,4292275184,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762,4292800762}}
local newState=scene:group{id="nested_state",opacity=0}
label(newState,"nested_title","Clip A + Clip B",130,80,32)
label(newState,"nested_tasks","clips.count = 2",900,660,28)
local clipB=scene:group{id="clip_b_shape",opacity=0}
for i=1,4 do local a,b=nested.polygon[i],nested.polygon[i%4+1]
 clipB:line{id="clip_b_edge_"..i,from=p(130+a[1]*cell,gy+a[2]*cell),to=p(130+b[1]*cell,gy+b[2]*cell),stroke="#13877f",width=3,layer=44}
end
local secondLabel=scene:group{id="second_labels",opacity=0}
label(secondLabel,"second_rle","clip B · shape.rle",130,745,27)
label(secondLabel,"second_count",#nested.clipB.." spans",130,790,24)
local finalLabel=scene:group{id="nested_final_label",opacity=0}
label(finalLabel,"nested_final_count",#nested.finalRle.." spans",900,790,24)
local second,newFinal,newFocus,newCopies={},{},{},{}
for i,s in ipairs(nested.clipB) do second[i]=spanGlyph("second_span_"..i,s,130) end
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
scene:wait(2)
local replaceClip={{target=stateCount,opacity=0},{target=stateTitle,opacity=0},{target=circleClip,opacity=0},{target=clipLabel,opacity=0},{target=clipCount,opacity=0}}
for _,g in ipairs(clips) do replaceClip[#replaceClip+1]={target=g,opacity=0} end
scene:play(replaceClip,.15)
scene:fade(newState,1,.15);scene:fade(clipB,1,.4);scene:wait(.8)
scene:fade(rendering,0,.15);scene:fade(fetchLabel,0,.01);scene:fade(prepare,1,.15)
scene:fade(secondLabel,1,.15)
for _,g in ipairs(second) do scene:fade(g,1,.035) end
scene:wait(.4)
-- The captured result after A is unchanged; apply B to that current Image RLE.
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
