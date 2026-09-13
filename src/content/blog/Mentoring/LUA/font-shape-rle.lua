-- ThorVG v1.1.1 / f9a618047bc31360d921dd05dcc0979c01fc8cf8.
-- PublicSans-Regular.ttf glyph B; font SHA256:
-- b577e9bc9887284e90aae5ad0699689ce36b5cd96207efbec68f77f8aed88379.
-- A construction/data trace, not slide panels and NOT a framebuffer animation.
-- Original Q records are decomposed font outlines. Degree elevation is exact.
-- Coverage uses 12 segments/Q and 8x8 NonZero samples: educational approximation.
-- SwSpan fields and append/merge conditions match v1.1.1, not its area integrator.
-- The complete 16x21 coverage grid is scanned; records retain global indices.
-- Stable identities: source segments; row sample; span record; incrementing len.
-- Fixed Y-up camera, pixel-plan conversion. Blue=path, orange=active data/control.
-- Text owned by record backing rectangles retains a 12px production inset.
-- @standalone: quad_note cubic_note array_title array_type coverage_note merge_note skip_note append_note cmd_move_1 cmd_line_1 cmd_cubic_1 cmd_close_1 cmd_move_2 cmd_line_2 cmd_cubic_2 cmd_close_2 cmd_move_3 cmd_line_3 cmd_cubic_3 cmd_close_3 cmd_quadratic_1 cmd_path
-- @standalone-pattern: ^count_\d+$ ^axis_[xy]_\d+$ ^probe_\d+_\d+$ ^row_label_\d+$
-- @contain-pattern: ^record_(\d+)_data_\d+$=record_box_$1:12
-- Beats: 1 draw B; 2 Q->C; 3 close contours; 4 reveal the aligned grid;
-- 5 extend center-origin span lines while appending/merging; 6 retain the span map.
-- Overview convention: begin=(x+.5,y+.5), end=begin+(len,0), exclusive end.
local glyph={advance=1341,unitsPerEm=2000,contours={{{"M",191,0},{"L",191,1446},{"L",656,1446},{"Q",920,1446,1055.5,1349},{"Q",1191,1252,1191,1069},{"Q",1191,954,1131,872},{"Q",1071,790,923,737},{"Q",1094,700,1160.5,605.5},{"Q",1227,511,1227,389},{"Q",1227,0,671,0},{"Z"}},{{"M",376,810},{"L",691,810},{"Q",766,810,840,831},{"Q",914,852,963,903},{"Q",1012,954,1012,1046},{"Q",1012,1172,915.5,1232.5},{"Q",819,1293,665,1293},{"L",376,1293},{"Z"}},{{"M",376,154},{"L",669,154},{"Q",850,154,944.5,213.5},{"Q",1039,273,1039,397},{"Q",1039,488,992.5,544.5},{"Q",946,601,867,627},{"Q",788,653,691,653},{"L",376,653},{"Z"}}}}
local scene=tmath.scene{width=1600,height=900,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=900}}
local function p(x,y) return {x-800,450-y} end
local function txt(owner,id,s,x,y,size,color)
    return owner:text{id=id,text=s,point=p(x,y),align={0,0.5},font="Pretendard",
        role="code",size=size or 24,fill=color or "foreground",layer=50}
end
local function line(owner,id,a,b,color,width,layer)
    return owner:line{id=id,from=a,to=b,stroke=color or "border",width=width or 1,layer=layer or 15}
end
local function rect(owner,id,x,y,w,h,fill,stroke,layer)
    return owner:rectangle{id=id,center=p(x+w/2,y+h/2),size={w,h},
        fill=fill,stroke=stroke or "#00000000",width=1,layer=layer or 20}
end
local blue,orange="#2078dc","#b55a18"
-- Bounds are derived from the original endpoints and controls.
local xmin,ymin,xmax,ymax=math.huge,math.huge,-math.huge,-math.huge
for _,contour in ipairs(glyph.contours) do
    for _,cmd in ipairs(contour) do
        for i=2,#cmd,2 do
            xmin=math.min(xmin,cmd[i]); xmax=math.max(xmax,cmd[i])
            ymin=math.min(ymin,cmd[i+1]); ymax=math.max(ymax,cmd[i+1])
        end
    end
end
local cubics,polygons={},{}
local focus
for ci,contour in ipairs(glyph.contours) do
    local out,poly={},{}
    local start,last
    for _,cmd in ipairs(contour) do
        if cmd[1]=="M" then
            last={cmd[2],cmd[3]};start=last
            out[#out+1]={"M",last};poly[#poly+1]=last
        elseif cmd[1]=="L" then
            last={cmd[2],cmd[3]}
            out[#out+1]={"L",last};poly[#poly+1]=last
        elseif cmd[1]=="Q" then
            local q,to={cmd[2],cmd[3]},{cmd[4],cmd[5]}
            local c1={last[1]+2/3*(q[1]-last[1]),last[2]+2/3*(q[2]-last[2])}
            local c2={to[1]+2/3*(q[1]-to[1]),to[2]+2/3*(q[2]-to[2])}
            out[#out+1]={"C",c1,c2,to}
            if not focus then focus={last,c1,c2,to,q} end
            for i=1,12 do
                local t=i/12; local u=1-t
                local a={u*u*last[1]+2*u*t*q[1]+t*t*to[1],u*u*last[2]+2*u*t*q[2]+t*t*to[2]}
                local b={u*u*u*last[1]+3*u*u*t*c1[1]+3*u*t*t*c2[1]+t*t*t*to[1],
                         u*u*u*last[2]+3*u*u*t*c1[2]+3*u*t*t*c2[2]+t*t*t*to[2]}
                assert(math.abs(a[1]-b[1])<0.000001 and math.abs(a[2]-b[2])<0.000001)
                poly[#poly+1]=b
            end
            last=to
        elseif cmd[1]=="Z" then
            out[#out+1]={"Z"};last=start
        else error("Unexpected source curve type") end
    end
    cubics[ci]=out;polygons[ci]=poly
end
assert(#cubics==3)

-- One independent input controls glyph position, coverage and all span values.
local xOffset=1.1
local model={height=18.5,ox=xOffset,oy=1.2,columns=16,rows=21,samples=8}
local factor=model.height/(ymax-ymin)
local rows,runs,events={},{},{}
for y=0,model.rows-1 do
    local row={coverage={},events={}}
    local hits={}
    for x=1,model.columns do hits[x]=0 end
    -- Reject edges outside this row once, not once for each subpixel sample.
    local edges={}
    local top=ymax-(y-model.oy)/factor
    local bottom=ymax-(y+1-model.oy)/factor
    for _,poly in ipairs(polygons) do
        for i,a in ipairs(poly) do
            local b=poly[i%#poly+1]
            if a[2]~=b[2] and math.max(a[2],b[2])>bottom and math.min(a[2],b[2])<top then
                edges[#edges+1]={a,b}
            end
        end
    end
    for sy=0,model.samples-1 do
        local py=ymax-(y+(sy+0.5)/model.samples-model.oy)/factor
        local crossings={}
        for _,edge in ipairs(edges) do
            local a,b=edge[1],edge[2]
            if (a[2]<=py and b[2]>py) or (b[2]<=py and a[2]>py) then
                crossings[#crossings+1]={x=a[1]+(py-a[2])*(b[1]-a[1])/(b[2]-a[2]),w=b[2]>a[2] and 1 or -1}
            end
        end
        table.sort(crossings,function(a,b) return a.x<b.x end)
        local next,w=1,0
        for sample=0,model.columns*model.samples-1 do
            local px=((sample+0.5)/model.samples-model.ox)/factor+xmin
            while crossings[next] and crossings[next].x<=px do w=w+crossings[next].w;next=next+1 end
            if w~=0 then local col=math.floor(sample/model.samples)+1;hits[col]=hits[col]+1 end
        end
    end
    for x=0,model.columns-1 do
        local c=math.floor(255*hits[x+1]/(model.samples*model.samples)+0.5)
        row.coverage[x+1]=c
        local event={x=x,y=y,coverage=c,op="skip",count=#runs}
        if c>0 then
            local last=runs[#runs]
            if last and last.y==y and last.x+last.len==x and last.coverage==c then
                last.len=last.len+1;event.op="merge"
            else
                runs[#runs+1]={x=x,y=y,len=1,coverage=c}
                event.op="append"
            end
            event.run=#runs;event.len=runs[#runs].len;event.count=#runs
        end
        events[#events+1]=event;row.events[#row.events+1]=event
    end
    rows[y+1]=row
end
-- Keep every pixel in the model. After the first examples, animate an equal-
-- coverage interval in one sweep, just as _sweep can emit aCount > 1.
for y,row in ipairs(rows) do
    row.steps={}
    for _,e in ipairs(row.events) do
        local previous=row.steps[#row.steps]
        if y-1~=4 and y-1~=10 and previous and previous.coverage==e.coverage then
            previous.last=e.x;previous.len=e.len
        else
            row.steps[#row.steps+1]={x=e.x,last=e.x,y=e.y,coverage=e.coverage,
                op=e.op,count=e.count,run=e.run,len=e.len}
        end
    end
end
-- Independently replay commits, including skipped holes and row boundaries.
local replay={}
for _,e in ipairs(events) do
    if e.op=="append" then
        replay[#replay+1]={x=e.x,y=e.y,len=1,coverage=e.coverage}
    elseif e.op=="merge" then
        local r=replay[#replay]
        assert(r.y==e.y and r.x+r.len==e.x and r.coverage==e.coverage)
        r.len=r.len+1
    else assert(e.coverage==0) end
    assert(#replay==e.count)
end
local decoded={}
for y=0,model.rows-1 do
    decoded[y+1]={}
    for x=1,model.columns do decoded[y+1][x]=0 end
end
for i,r in ipairs(runs) do
    local q=replay[i]
    assert(q.x==r.x and q.y==r.y and q.len==r.len and q.coverage==r.coverage)
    for x=r.x+1,r.x+r.len do decoded[r.y+1][x]=r.coverage end
end
for y=1,model.rows do for x=1,model.columns do assert(decoded[y][x]==rows[y].coverage[x]) end end
local cell,gx,gy=26,200,155
local function xy(a)
    return p(gx+(model.ox+(a[1]-xmin)*factor)*cell,gy+(model.oy+(ymax-a[2])*factor)*cell)
end
-- A faint outline is context; independent blue segments actually grow in order.
local ghost=scene:group{id="glyph_reference"}
local paths=scene:group{id="constructed_path"}
local segments,starts={},{}
for ci,contour in ipairs(cubics) do
    local all={}
    local previous,first
    segments[ci]={}
    for j,c in ipairs(contour) do
        local cmd
        if c[1]=="M" then
            previous=c[2];first=c[2]
            cmd={type="move",to=xy(c[2])}
            starts[ci]=paths:point{id="start_"..ci,point=xy(c[2]),radius=5,color=blue,layer=40}
        else
            if c[1]=="L" then cmd={type="line",to=xy(c[2])}
            elseif c[1]=="C" then cmd={type="cubic",control1=xy(c[2]),control2=xy(c[3]),to=xy(c[4])}
            else cmd={type="line",to=xy(first)} end
            local s=paths:path{id="segment_"..ci.."_"..j,commands={{type="move",to=xy(previous)},cmd},
                fill="#00000000",stroke=blue,width=4,layer=30}
            segments[ci][#segments[ci]+1]={object=s,op=c[1]}
            if c[1]=="L" then previous=c[2] elseif c[1]=="C" then previous=c[4] else previous=first end
        end
        all[#all+1]=cmd
    end
    ghost:path{id="reference_"..ci,commands=all,fill="#00000000",stroke="#e3e8ef",width=2,layer=10}
end
-- Command labels are transient and never constitute a separate slide.
local commands={}
for ci=1,3 do
    commands[ci]={}
    for _,op in ipairs({"move","line","cubic","close"}) do
        local names={move="MoveTo()",line="LineTo()",cubic="CubicTo()",close="Close()"}
        commands[ci][op]=txt(scene,"cmd_"..op.."_"..ci,names[op],190,108,34,blue)
    end
end
local qcmd=txt(scene,"cmd_quadratic_1","quadratic",190,108,34,orange)
local pathcmd=txt(scene,"cmd_path","RenderPath",190,108,34,blue)
local qGuide=scene:group{id="quadratic_guide"}
line(qGuide,"q_leg_1",xy(focus[1]),xy(focus[5]),"#8793a2",2,35)
line(qGuide,"q_leg_2",xy(focus[5]),xy(focus[4]),"#8793a2",2,35)
qGuide:point{id="q_point",point=xy(focus[5]),radius=6,color=orange,layer=40}
local qnote=txt(qGuide,"quad_note","quadratic · 제어점 1개",780,180,26,"muted")
local cGuide=scene:group{id="cubic_guide"}
local c1=cGuide:point{id="c1",point=xy(focus[1]),radius=6,color=orange,layer=40}
local c2=cGuide:point{id="c2",point=xy(focus[4]),radius=6,color=orange,layer=40}
txt(cGuide,"cubic_note","cubic · 제어점 2개, 같은 곡선",780,230,26,orange)
-- A real glyph-aligned pixel coordinate system, not a detached numeric input.
local grid=scene:group{id="coverage_grid"}
for x=0,model.columns do line(grid,"grid_x_"..x,p(gx+x*cell,gy),p(gx+x*cell,gy+model.rows*cell),"#d7dee7",1,22) end
for y=0,model.rows do line(grid,"grid_y_"..y,p(gx,gy+y*cell),p(gx+model.columns*cell,gy+y*cell),"#d7dee7",1,22) end
for _,x in ipairs({0,4,8,12,15}) do txt(grid,"axis_x_"..x,tostring(x),gx+x*cell+6,gy-8,18,"muted") end
for _,y in ipairs({0,4,8,10,12,16,20}) do txt(grid,"axis_y_"..y,tostring(y),gx-40,gy+(y+0.5)*cell,18,"muted") end
local scanline=line(scene,"scanline",p(gx-7,gy+cell/2),p(gx+model.columns*cell+7,gy+cell/2),orange,2,35)
local cursor=rect(scene,"scan_cursor",gx,gy,cell,cell,"#f5debc66",orange,45)
local rowLabels,probes={},{}
for y=0,model.rows-1 do
    rowLabels[y]=txt(scene,"row_label_"..y,"coverage 격자 · y = "..y,200,733,24)
    probes[y]={}
    for _,e in ipairs(rows[y+1].steps) do
        probes[y][e.x]=txt(scene,"probe_"..y.."_"..e.x,
            "x = "..e.x..(e.last>e.x and ".."..e.last or "").."     y = "..y.."     coverage = "..e.coverage,80,790,26,orange)
    end
end
local array=scene:group{id="array_structure"}
txt(array,"array_title","SwRle::spans",820,175,34)
txt(array,"array_type","Array<SwSpan>",820,224,24,"muted")
line(array,"array_spine",p(799,321),p(799,706),"#a7b0bd",2)
local records,values,counters,marks,lengths,ends={},{},{},{},{},{}
for count=0,#runs do counters[count]=txt(scene,"count_"..count,"spans.count = "..count,1230,272,24,orange) end
for i,r in ipairs(runs) do
    local yy=326+math.min(i-1,4)*76
    records[i]=scene:group{id="record_"..i}
    rect(records[i],"record_box_"..i,820,yy,690,64,"#f7f9fc","#ccd3dc",20)
    values[i]={}
    for n=(r.y==4 or r.y==10) and 1 or r.len,r.len do
        values[i][n]=txt(records[i],"record_"..i.."_data_"..n,
            "["..(i-1).."]   x="..r.x.."   y="..r.y.."   len="..n.."   coverage="..r.coverage,840,yy+32,24)
    end
    -- Same spanGlyph notation as the Overview: a small start pixel, a horizontal
    -- length line from its CENTER, and a tick at the exclusive end.
    local beginX,centerY=gx+(r.x+0.5)*cell,gy+(r.y+0.5)*cell
    local initialLen=(r.y==4 or r.y==10) and 1 or r.len
    local endX=beginX+initialLen*cell
    local v=255-math.floor(r.coverage*195/255)
    local gray=string.format("#%02x%02x%02x",v,v,v)
    marks[i]=rect(scene,"span_begin_"..i,beginX-cell*.18,centerY-cell*.18,
        cell*.36,cell*.36,gray,nil,40)
    lengths[i]=line(scene,"span_length_"..i,p(beginX,centerY),p(endX,centerY),gray,2.5,39)
    ends[i]=line(scene,"span_end_"..i,p(endX,centerY-5),p(endX,centerY+5),gray,2,39)
end
local hints=scene:group{id="data_hints"}
txt(hints,"coverage_note","uint8_t · 0~255",1100,729,24,"muted")
local merge=txt(scene,"merge_note","같은 y + 인접 + 같은 coverage → len 증가",780,112,25,orange)
local skip=txt(scene,"skip_note","coverage = 0 → 기록 없음",780,112,25,"muted")
local append=txt(scene,"append_note","새 구간 → spans.next()",780,112,25,orange)
-- Timeline. Non-overlapping label changes; no whole-slide transition.
local current=commands[1].move
local function command(next)
    if current==next then return end
    scene:fade_out(current,{duration=0.08})
    scene:fade_in(next,{duration=0.08})
    current=next
end
scene:wait(0.6)
command(commands[1].line)
scene:create(segments[1][1].object,0.9,"linear")
scene:create(segments[1][2].object,0.55,"linear")
command(qcmd)
scene:fade_in(qGuide,{duration=0.45})
scene:wait(0.65)
scene:fade_in(cGuide,{duration=0.3})
local a,b,c,d=xy(focus[1]),xy(focus[2]),xy(focus[4]),xy(focus[3])
scene:play({{target=c1,shift={b[1]-a[1],b[2]-a[2]}},{target=c2,shift={d[1]-c[1],d[2]-c[2]}}},0.9,"linear")
scene:wait(0.6)
command(commands[1].cubic)
scene:create(segments[1][3].object,0.85,"linear")
scene:fade_out(qGuide,{duration=0.25})
scene:fade_out(cGuide,{duration=0.25})
for j=4,#segments[1]-1 do scene:create(segments[1][j].object,0.22,"linear") end
command(commands[1].close)
scene:create(segments[1][#segments[1]].object,0.6,"linear")
scene:wait(0.35)
for ci=2,3 do
    command(commands[ci].move)
    scene:fade_in(starts[ci],{duration=0.15})
    scene:wait(0.2)
    for _,s in ipairs(segments[ci]) do
        command(commands[ci][s.op=="L" and "line" or (s.op=="C" and "cubic" or "close")])
        scene:create(s.object,s.op=="Z" and 0.4 or 0.2,"linear")
    end
end
command(pathcmd)
scene:wait(0.7)
scene:fade_in(grid,{duration=0.5})
scene:fade_in(array,{duration=0.4})
scene:fade_in(counters[0],{duration=0.12})
scene:fade_in(hints,{duration=0.3})
scene:fade_in(scanline,{duration=0.25})
scene:fade_in(cursor,{duration=0.25})
local previousProbe,previousHint
local px=0
local window={}
local function hint(next,duration)
    if next==previousHint then return end
    if previousHint then scene:fade_out(previousHint,{duration=duration}) end
    scene:fade_in(next,{duration=duration});previousHint=next
end
for y=0,model.rows-1 do
    local slow=y==4 or y==10
    local step=slow and 0.18 or 0.035
    if y>0 then
        scene:fade_out(rowLabels[y-1],{duration=0.02})
        -- Return to x=0, then advance y. No diagonal "scan".
        scene:shift(cursor,{-px*cell,0},0.09,"linear")
        scene:play({{target=cursor,shift={0,-cell}},{target=scanline,shift={0,-cell}}},0.11,"linear")
        px=0
    end
    scene:fade_in(rowLabels[y],{duration=0.02})
    for _,e in ipairs(rows[y+1].steps) do
        if previousProbe then scene:fade_out(previousProbe,{duration=0.015}) end
        if e.x~=px then
            scene:shift(cursor,{(e.x-px)*cell,0},step,"linear")
        end
        px=e.x
        scene:fade_in(probes[y][e.x],{duration=0.015});previousProbe=probes[y][e.x]
        if e.last>e.x then
            scene:shift(cursor,{(e.last-e.x)*cell,0},0.09,"linear")
            px=e.last
        end
        scene:wait(0.02)
        if e.op=="skip" then
            hint(skip,0.02)
            if slow then scene:wait(0.08) end
        else
            local i=e.run
            local r=runs[i]
            if e.op=="append" then
                hint(append,0.02)
                -- Slots are only a viewport; global record indices/count never reset.
                if #window==5 then
                    scene:fade_out(records[window[1]],{duration=0.035})
                    table.remove(window,1)
                    local moves={}
                    for _,id in ipairs(window) do moves[#moves+1]={target=records[id],shift={0,76}} end
                    scene:play(moves,slow and 0.16 or 0.04,"linear",0)
                end
                scene:fade_in(marks[i],{duration=0.02})
                scene:create(lengths[i],slow and 0.20 or 0.035,"linear")
                scene:fade_in(ends[i],{duration=0.02})
                scene:fade_in(records[i],{duration=slow and 0.18 or 0.035})
                scene:fade_out(counters[i-1],{duration=0.015})
                scene:fade_in(counters[i],{duration=0.015})
                window[#window+1]=i
                scene:wait(slow and 0.12 or 0.025)
            else
                hint(merge,0.02)
                local beginX=gx+(r.x+0.5)*cell-800
                scene:play({
                    {target=lengths[i],transform={e.len,0,0,(1-e.len)*beginX,0,1,0,0,0,0,1,0,0,0,0,1}},
                    {target=ends[i],shift={cell,0}},
                },step,"linear",0)
                scene:fade_out(values[i][e.len-1],{duration=0.015})
                scene:fade_in(values[i][e.len],{duration=0.015})
            end
            if slow then scene:wait(0.10) end
            if e.len==r.len then
                if slow and r.len>1 then scene:wait(0.45) end
                -- Keep completed span marks and length lines in the grid.
                scene:wait(0.025)
            end
        end
    end
    if slow then scene:wait(0.45) end
end
if previousHint then scene:fade_out(previousHint,{duration=0.15}) end
scene:fade_out(previousProbe,{duration=0.15})
scene:fade_out(cursor,{duration=0.15})
scene:fade_out(scanline,{duration=0.15})
scene:wait(0.35)
scene:wait(2.5)
return scene
