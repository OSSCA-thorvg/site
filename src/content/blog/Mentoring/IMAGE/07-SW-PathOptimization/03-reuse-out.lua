-- 6b94ffbd: one fixed output consumed repeatedly by RLE bands.
-- Polygon/cell visualization is illustrative, not an AA raster capture.
local s=tmath.scene {width=960,height=540,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=540}}
local blue,green,ink="#2563eb","#0d9488","#334155"
local pts={{1,1},{10,2},{9,11},{3,9}}
local unit,ox,oy=22,95,-140
local function label(id,t,x,y)
    return s:text {id=id,text=t,point={x,y},role="code",font="IBM Plex Sans KR",
        size=22,color=ink,layer=30}
end
label("out","out[]",-273,207)
label("rle","RLE",222,207)
local arr=s:group {id="fixed-points"}
for i,p in ipairs(pts) do
    local x,y=-352+(i-1)*53,86
    arr:point {id="fixed-"..i,point={x,y},radius=8,fill=green,layer=20}
    arr:text {id="fixed-label-"..i,text=string.char(64+i),point={x,y-32},
        role="code",font="IBM Plex Sans KR",size=20,color=green,layer=30}
end
local outline=s:group {id="outline"}
for i,p in ipairs(pts) do
    local q=pts[i%#pts+1]
    outline:line {id="edge-"..i,from={ox+p[1]*unit,oy+p[2]*unit},
        to={ox+q[1]*unit,oy+q[2]*unit},stroke=blue,width=3,layer=20}
end
for i=0,12 do
    s:line {from={ox+i*unit,oy},to={ox+i*unit,oy+12*unit},stroke="#e2e8f0",width=1,layer=1}
    s:line {from={ox,oy+i*unit},to={ox+12*unit,oy+i*unit},stroke="#e2e8f0",width=1,layer=1}
end
local function inside(x,y)
    local hit=false
    for i,a in ipairs(pts) do
        local b=pts[i%#pts+1]
        if (a[2]>y)~=(b[2]>y) and x<(b[1]-a[1])*(y-a[2])/(b[2]-a[2])+a[1] then hit=not hit end
    end
    return hit
end
local groups,focus,reads,titles,traces={},{},{},{},{}
for band=1,3 do
    local row=12-band*4
    groups[band]=s:group {id="band-fill-"..band}
    for y=row,row+3 do
        for x=0,11 do
            if inside(x+0.5,y+0.5) then
                groups[band]:rectangle {id="cell-"..x.."-"..y,
                    center={ox+(x+0.5)*unit,oy+(y+0.5)*unit},size={unit-3,unit-3},
                    fill="#b6e1d8",stroke="#b6e1d8",width=0,layer=5}
            end
        end
    end
    focus[band]=s:rectangle {id="band-window-"..band,center={ox+6*unit,oy+(row+2)*unit},
        size={12*unit+12,4*unit},stroke=green,width=2,fill="#00000000",layer=10}
    titles[band]=label("band-label-"..band,"band "..(band-1),-258,-26-(band-1)*60)
    reads[band]=s:arrow {id="band-read-"..band,from={-164,-26-(band-1)*60},
        to={ox-22,oy+(row+2)*unit},stroke=green,width=2,tip=9,layer=8}
    traces[band]=s:group {id="band-trace-"..band}
    for i,p in ipairs(pts) do
        local q=pts[i%#pts+1]
        traces[band]:line {from={ox+p[1]*unit,oy+p[2]*unit},
            to={ox+q[1]*unit,oy+q[2]*unit},stroke=green,width=5,layer=25}
    end
end
s:wait(0.8)
for band=1,3 do
    s:fade_in(titles[band],{duration=0.2})
    s:create(reads[band],0.7)
    s:create(focus[band],0.4)
    s:create(traces[band],0.9)
    s:fade_in(groups[band],{duration=0.65})
    s:wait(0.5)
    s:fade_out(focus[band],{duration=0.25})
    s:fade_out(traces[band],{duration=0.25})
end
s:wait(2)
return s
