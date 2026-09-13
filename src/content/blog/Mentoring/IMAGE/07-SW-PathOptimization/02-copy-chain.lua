-- Parent vs 6b94ffbd: ordinary fill, no dash/trim. No timing claim.
local s=tmath.scene {width=960,height=540,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=540}}
local blue,green,amber,ink="#2563eb","#0d9488","#d97706","#334155"
local model={{-62,-37},{40,-37},{65,28},{-38,48}}
local function label(id,t,x,y)
    return s:text {id=id,text=t,point={x,y},role="code",font="IBM Plex Sans KR",
        size=20,color=ink,layer=30}
end
local function geom(id,cx,cy,color,fixed)
    local g=s:group {id=id,matrix={1,0,0,cx,0,1,0,cy,0,0,1,0,0,0,0,1}}
    local points={}
    for i,p in ipairs(model) do
        -- Same affine transform for both output lanes.
        points[i]=fixed and {p[1]*0.84-p[2]*0.24,p[1]*0.24+p[2]*0.84} or p
    end
    for i,p in ipairs(points) do
        g:line {id=id.."-edge-"..i,from=p,to=points[i%#points+1],stroke=color,width=3,layer=10}
        g:point {id=id.."-point-"..i,point=p,radius=5,fill=color,layer=20}
    end
    return g
end
label("source","RenderPath",-310,225)
label("outline","SwOutline",0,225)
label("output","out[]",310,225)
label("before","4f968a5f",-364,178)
label("after","6b94ffbd",-364,-72)
s:line {from={-435,-15},to={435,-15},stroke="#cbd5e1",width=1}
local original1=geom("source-before",-310,80,blue,false)
local original2=geom("source-after",-310,-170,blue,false)
local copy1=geom("copy-before",-310,80,blue,false)
local copy2=geom("export-before",0,80,green,true)
local direct=geom("export-after",-310,-170,green,true)
local nameIn=label("in-label","in[] + metadata",0,156)
local pointer=label("path-label","path*",0,-94)
local ref=s:arrow {id="borrow-reference",from={-35,-170},to={-222,-170},
    stroke=blue,width=2,tip=9,layer=8}
local arrow1=s:arrow {id="copy-route",from={-225,80},to={-88,80},stroke=amber,width=2,tip=9}
local arrow2=s:arrow {id="export-route",from={85,80},to={225,80},stroke=green,width=2,tip=9}
local directRoute=s:route {id="direct-route",points={{-225,-210},{0,-235},{225,-210}},
    stroke=green,width=2,tip=9,layer=5}
s:wait(0.8)
s:fade_in(nameIn,{duration=0.3})
s:create(arrow1,0.4)
s:fade_in(copy1,{duration=0.15})
s:shift(copy1,{310,0},1.3,"ease_in_out")
s:wait(0.7)
s:create(arrow2,0.4)
s:fade_in(copy2,{duration=0.2})
s:shift(copy2,{310,0},1.3,"ease_in_out")
s:wait(0.8)
s:fade_in(pointer,{duration=0.3})
s:create(ref,0.7)
s:wait(0.7)
s:create(directRoute,0.6)
s:fade_in(direct,{duration=0.2})
s:shift(direct,{620,0},1.6,"ease_in_out")
s:wait(2.0)
return s
