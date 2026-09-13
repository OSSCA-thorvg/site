-- ThorVG 6cf10d4: Canvas::Impl::renderer, tvgCanvas.cpp gen() factories,
-- RenderMethod virtual interface and SwRenderer/GlRenderer/WgRenderer inheritance.
-- Reference lecture image-8: abstraction separates upper drawing logic from backend.
-- Three INDEPENDENT canvases with equivalent Paints, not a runtime backend switch
-- or shared Paint ownership. All arrows mean request/output flow, not inheritance.
-- Fixed canonical lane records provide labels, slots, routes and output positions.
-- One pair model supplies retained source icons, travelling data and output icons.
-- Beats: interface -> backend/platform rows -> SW -> GL -> WG -> final comparison.
-- Timing and output icons are illustrative; this is not a CPU/GPU performance or AA test.
-- @contain: canvas_sw_label=canvas_sw_box:12 canvas_gl_label=canvas_gl_box:12 canvas_wg_label=canvas_wg_box:12
-- @contain: method_label=method_box:12
-- @contain: renderer_sw_label=renderer_sw_box:12 renderer_gl_label=renderer_gl_box:12 renderer_wg_label=renderer_wg_box:12
-- @contain: platform_sw_label=platform_sw_box:12 platform_gl_label=platform_gl_box:12 platform_wg_label=platform_wg_box:12
local W,H=2400,1600
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function mat(x,y) local q=p(x,y);return {1,0,0,q[1],0,1,0,q[2],0,0,1,0,0,0,0,1} end
local lanes={
    {id="sw",x=450,canvas="SwCanvas",renderer="SwRenderer",platform="CPU",color="#7199c8"},
    {id="gl",x=1200,canvas="GlCanvas",renderer="GlRenderer",platform="OpenGL / ES",color="#9380b7"},
    {id="wg",x=1950,canvas="WgCanvas",renderer="WgRenderer",platform="WebGPU",color="#729f8b"},
}
local model={circle={x=-40,y=-8,r=30,color="#2878db"},square={x=38,y=10,w=58,h=52,color="#e9a53b"}}
local function label(g,id,value,x,y,size)
    return g:text{id=id,text=value,point=p(x,y),font="Pretendard",role="text",size=size or 38,
        align={0,0.5},fill="#344158",layer=50}
end
local function box(g,id,x,y,w,h,fill)
    return g:rectangle{id=id,center=p(x,y),size={w,h},corner=12,fill=fill or "#ffffff",
        stroke="#b3c0cf",width=1.8,layer=10}
end
local function pair(id,x,y,outline,opacity)
    local g=scene:group{id=id,matrix=mat(x,y),opacity=opacity or 1}
    local a,b=model.circle,model.square
    g:circle{id=id.."_circle",center={a.x,-a.y},radius=a.r,fill=outline and "#00000000" or a.color,
        stroke=outline and a.color or "#00000000",width=2.5,layer=40}
    g:rectangle{id=id.."_square",center={b.x,-b.y},size={b.w,b.h},fill=outline and "#00000000" or b.color,
        stroke=outline and b.color or "#00000000",width=2.5,layer=40}
    return g
end
local method=scene:group{id="method"}
box(method,"method_box",1200,472.5,2040,145,"#f2f6fb")
label(method,"method_label","RenderMethod",825,470,40)
local structure=scene:group{id="backend_structure"}
local function pointOn(c,t)
    local u=1-t
    return {u*u*u*c.a[1]+3*u*u*t*c.c1[1]+3*u*t*t*c.c2[1]+t*t*t*c.b[1],
        u*u*u*c.a[2]+3*u*u*t*c.c1[2]+3*u*t*t*c.c2[2]+t*t*t*c.b[2]}
end
local function route(id,a,b,c1,c2)
    local c={a=a,b=b,c1=c1,c2=c2}
    local g=structure:group{id=id}
    g:path{id=id.."_shaft",commands={{type="move",to=p(a[1],a[2])},
        {type="cubic",control1=p(c1[1],c1[2]),control2=p(c2[1],c2[2]),to=p(b[1],b[2])}},
        stroke="#bdc7d3",width=2,fill="#00000000",layer=15}
    local dx,dy=b[1]-c2[1],b[2]-c2[2];local n=math.sqrt(dx*dx+dy*dy);dx,dy=dx/n,dy/n
    g:polygon{id=id.."_tip",points={p(b[1],b[2]),p(b[1]-dx*14-dy*6,b[2]-dy*14+dx*6),p(b[1]-dx*14+dy*6,b[2]-dy*14-dx*6)},
        fill="#bdc7d3",layer=16}
    return c
end
for _,lane in ipairs(lanes) do
    local id,x=lane.id,lane.x
    box(scene,"canvas_"..id.."_box",x,200,500,250,"#f9fbfe")
    label(scene,"canvas_"..id.."_label",lane.canvas,x-220,125)
    lane.source=pair("source_"..id,x,240,false)
    lane.rendererBox=box(structure,"renderer_"..id.."_box",x,760,500,120)
    label(structure,"renderer_"..id.."_label",lane.renderer,x-220,760,35)
    lane.platformBox=box(structure,"platform_"..id.."_box",x,940,500,100)
    label(structure,"platform_"..id.."_label",lane.platform,x-220,940,35)
    box(structure,"output_"..id.."_box",x,1280,340,240)
    lane.output=pair("output_"..id,x,1280,false,0)
    lane.packet=pair("packet_"..id,x,240,true,0)
    local port=x+170
    lane.paths={
        route("api_"..id,{x,240},{port,500},{x,350},{port,350}),
        route("dispatch_"..id,{port,500},{port,760},{port,600},{port,650}),
        route("execute_"..id,{port,760},{port,940},{port,820},{port,875}),
        route("result_"..id,{port,940},{x,1280},{port,1070},{x,1120}),
    }
end
local function travel(g,c,duration)
    for i=1,24 do
        local q=pointOn(c,i/24)
        scene:transform(g,mat(q[1],q[2]),duration/24,"linear")
    end
end
-- First frame already has three distinct canvases and their own retained geometry.
scene:wait(0.6)
scene:fade_in(method,{duration=0.6})
scene:fade_in(structure,{duration=0.7})
scene:wait(0.6)
for _,lane in ipairs(lanes) do
    scene:fade(lane.packet,1,0.2)
    travel(lane.packet,lane.paths[1],0.9)
    scene:wait(0.3)
    travel(lane.packet,lane.paths[2],0.8)
    scene:stroke(lane.rendererBox,lane.color,0.25)
    travel(lane.packet,lane.paths[3],0.6)
    scene:stroke(lane.platformBox,lane.color,0.2)
    travel(lane.packet,lane.paths[4],1.0)
    scene:fade(lane.output,1,0.25)
    scene:fade(lane.packet,0,0.2)
    scene:wait(0.55)
end
scene:wait(2.5)
return scene
