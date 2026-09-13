-- Motion comparison: where the scene lives, and what crosses the API each frame.
-- Sources: Microsoft Learn retained-mode-versus-immediate-mode; Wikipedia Retained_mode;
-- THorVG-Lecture/2025/image-5.png (Canvas/Paint lifecycle), image-6.png (Scene ownership).
-- ThorVG 6cf10d4: tvgCanvas.h root Scene + add/update/draw. Durations are illustrative.
-- Solid shapes = stored scene / output. Outlined moving shapes = commands or updates.
-- Immediate: persistent application model; BOTH drawing commands sent for each redraw.
-- Retained: initial objects enter engine and keep identity; later only A update crosses API.
-- No claim that Immediate destroys resources or that retained rendering is automatic.
-- Canonical states below drive model, payload, and output. B never changes.
-- Coordinate convention: pixel-plan Y down -> fixed world Y up; no camera motion.
-- Bands: ownership regions 10, flow arrows 15, objects 30, payloads 40, text 50.
-- Beat ledger (seconds): opening 0; registration 2.7; first output 4.4;
-- position transfer 6.6; second output 9.8; color transfer 12.0; final hold 15.5..17.23.
-- @standalone: application_header library_header surface_header immediate_title retained_title
-- @standalone: immediate_caption retained_caption
-- @contain: im_scene=im_app:16 re_scene=re_library:16
local W,H=1600,860
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function mat(x,y) return {1,0,0,x,0,1,0,y,0,0,1,0,0,0,0,1} end
local function txt(id,value,x,y,size,align)
    return scene:text{id=id,text=value,point=p(x,y),font="Pretendard",role="text",
        size=size or 28,align=align or {0,0.5},fill="foreground",layer=50}
end
local function box(id,x,y)
    scene:rectangle{id=id,center=p(x+150,y+120),size={300,240},fill="#ffffff",
        stroke="#c1cad5",width=1.5,layer=10}
end
local appX,engineX,outX=275,735,1195
local imY,reY=190,520
local initialA={x=70,y=104,color="#2878db"}
local movedA={x=163,y=initialA.y,color=initialA.color}
local tintedA={x=movedA.x,y=movedA.y,color="#8254bc"}
local fixedB={x=211,y=153,color="#e9a53b"}
local states={
    {a=initialA,b=fixedB},
    {a=movedA,b=fixedB},
    {a=tintedA,b=fixedB},
}
local function glyph(owner,id,item,kind,x,y,outline)
    local fill=outline and "#00000000" or item.color
    local stroke=outline and item.color or "#00000000"
    if kind=="a" then
        return owner:circle{id=id,center={x,y},radius=35,fill=fill,stroke=stroke,width=3,layer=outline and 40 or 30}
    else
        return owner:rectangle{id=id,center={x,y},size={76,55},fill=fill,stroke=stroke,width=3,layer=outline and 40 or 31}
    end
end
local function pair(id,x,y,state,outline,opacity)
    local origin=p(x,y)
    local group=scene:group{id=id,matrix=mat(origin[1],origin[2]),opacity=opacity or 1}
    local a=glyph(group,id.."_a",state.a,"a",state.a.x,-state.a.y,outline)
    local b=glyph(group,id.."_b",state.b,"b",state.b.x,-state.b.y,outline)
    return {group=group,a=a,b=b}
end
local function flow(id,x,y)
    local arrow=scene:arrow{id=id,from=p(x,y),to=p(x+122,y),stroke="#798698",width=2,tip=11,layer=15}
    return arrow
end
-- Fixed layout: actual content moves, ownership regions and labels stay fixed.
txt("application_header","Application",appX+150,105,30,{0.5,0.5})
txt("library_header","Graphics library",engineX+150,105,30,{0.5,0.5})
txt("surface_header","Surface",outX+150,105,30,{0.5,0.5})
txt("immediate_title","Immediate",48,310,32)
txt("retained_title","Retained",48,640,32)
for _,v in ipairs({{"im",imY},{"re",reY}}) do
    box(v[1].."_app",appX,v[2]);box(v[1].."_library",engineX,v[2]);box(v[1].."_surface",outX,v[2])
    flow(v[1].."_api_flow",appX+320,v[2]+120)
    flow(v[1].."_render_flow",engineX+320,v[2]+120)
end
txt("im_scene","Scene",appX+22,imY+32,23)
local retainedLabel=txt("re_scene","Scene",engineX+22,reY+32,23)
txt("immediate_caption","Every frame: send drawing commands",appX,465,27)
txt("retained_caption","Add once → update retained objects",appX,795,27)
local imModel=pair("im_model",appX,imY,states[1],false)
local reModel=pair("re_model",appX,reY,states[1],false)
local imOut=pair("im_output",outX,imY,states[1],false,0)
local reOut=pair("re_output",outX,reY,states[1],false,0)
local packets={}
local resultPackets={}
for i,state in ipairs(states) do
    packets[i]=pair("im_commands_"..i,appX,imY,state,true)
    resultPackets[i]={pair("im_result_"..i,engineX,imY,state,true,0),pair("re_result_"..i,engineX,reY,state,true,0)}
end
local updates={}
for i=2,#states do
    local state=states[i]
    local point=p(appX+150,reY+120)
    local g=scene:group{id="re_update_"..i,matrix=mat(point[1],point[2])}
    glyph(g,"re_update_glyph_"..i,state.a,"a",0,0,true)
    updates[i]=g
end
local function hideTargets(pairs)
    local d={};for _,v in ipairs(pairs) do d[#d+1]={target=v.group,opacity=0} end
    scene:play(d,0.18,"linear")
end
-- 1. The retained pair moves once into engine ownership, without reconstruction.
scene:wait(0.7)
scene:fade_in(packets[1].group,{duration=0.25})
scene:play({{target=packets[1].group,shift={engineX-appX,0}},
            {target=reModel.group,shift={engineX-appX,0}}},1.15,"ease_in_out")
scene:fade_in(retainedLabel,{duration=0.25})
scene:wait(0.35)
-- 2. Raster results travel from each engine to its target. The command is consumed;
-- the retained model stays. Payload silhouettes represent output generation, not objects moving out.
local function dispatchResults(index,first)
    local pairset=resultPackets[index]
    scene:play({{target=pairset[1].group,opacity=1},{target=pairset[2].group,opacity=1}},0.22)
    scene:play({{target=pairset[1].group,shift={outX-engineX,0}},
                {target=pairset[2].group,shift={outX-engineX,0}}},0.7,"ease_in_out")
    if first then
        scene:play({{target=imOut.group,opacity=1},{target=reOut.group,opacity=1}},0.18)
    else
        local prev,cur=states[index-1],states[index]
        local dx,dy=cur.a.x-prev.a.x,prev.a.y-cur.a.y
        scene:play({{target=imOut.a,shift={dx,dy},fill=cur.a.color},
                    {target=reOut.a,shift={dx,dy},fill=cur.a.color}},0.4,"ease_in_out")
    end
    hideTargets(pairset)
    scene:fade_out(packets[index].group,{duration=0.18})
end
-- Entrance-hide result packets from the beginning; factory opacity is zero.
-- They have no text, so semantic model/output labels remain legible throughout.
dispatchResults(1,true)
scene:wait(0.85) -- first output is settled by 4.4s
for i=2,#states do
    local cur,prev=states[i],states[i-1]
    local dx,dy=cur.a.x-prev.a.x,prev.a.y-cur.a.y
    -- 3/4. Same user edit: immediate application changes its scene;
    -- retained side sends ONE object update to the SAME engine-owned circle.
    scene:play({{target=imModel.a,shift={dx,dy},fill=cur.a.color}},0.55,"ease_in_out")
    scene:fade_in(packets[i].group,{duration=0.2})
    scene:fade_in(updates[i],{duration=0.2})
    scene:play({{target=packets[i].group,shift={engineX-appX,0}},
                {target=updates[i],shift={engineX+cur.a.x-(appX+150),120-cur.a.y}}},0.95,"ease_in_out")
    scene:play({{target=reModel.a,shift={dx,dy},fill=cur.a.color}},0.45,"ease_in_out")
    scene:fade_out(updates[i],{duration=0.18})
    scene:wait(0.35)
    dispatchResults(i,false)
    scene:wait(0.8)
end
scene:wait(1.5)
return scene
