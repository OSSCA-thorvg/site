-- Adapted from static/tmath/thorvg/rendering-modes.lua for scenes-on-thorvg-ver3,
-- drawn in the palette and type of the post's other figures.
-- Immediate: the application keeps the model and sends both drawing commands for each redraw.
-- Retained: the objects enter the library once; later only the circle's update crosses the API.
-- Solid shapes = stored scene / output. Outlined shapes = commands or updates.
-- Beat ledger (seconds): registration 0.7; first output 2.6; position update 4.6;
-- color update 8.8; final hold to the end.
local W,H=1200,675
local scene=tmath.scene{width=W,height=H,fps=25,loop=false,theme={preset="adaptive_vscode"},
    camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function mat(x,y) return {1,0,0,x,0,1,0,y,0,0,1,0,0,0,0,1} end
local function txt(id,value,x,y,size,align,color)
    return scene:text{id=id,text=value,point=p(x,y),font="CMUTypewriter-Regular",role="code",
        size=size or 22,align=align or {0,0.5},fill=color or "foreground",layer=50}
end
local BW,BH=250,200
local function box(id,x,y)
    scene:rectangle{id=id,center=p(x+BW/2,y+BH/2),size={BW,BH},fill="background",
        stroke="border",width=1,layer=10}
end
local appX,libX,outX=200,545,890
local imY,reY=120,400
local K=BW/300
local initialA={x=70*K,y=104*K,color="accent"}
local movedA={x=163*K,y=initialA.y,color=initialA.color}
local tintedA={x=movedA.x,y=movedA.y,color="foreground"}
local fixedB={x=211*K,y=153*K,color="border"}
local states={{a=initialA,b=fixedB},{a=movedA,b=fixedB},{a=tintedA,b=fixedB}}
local function glyph(owner,id,item,kind,x,y,outline)
    local fill=outline and "#00000000" or item.color
    local stroke=outline and item.color or "#00000000"
    if kind=="a" then
        return owner:circle{id=id,center={x,y},radius=29,fill=fill,stroke=stroke,width=2,layer=outline and 40 or 30}
    else
        return owner:rectangle{id=id,center={x,y},size={63,46},fill=fill,stroke=stroke,width=2,layer=outline and 40 or 31}
    end
end
local function pair(id,x,y,state,outline,opacity)
    local origin=p(x,y)
    local group=scene:group{id=id,matrix=mat(origin[1],origin[2]),opacity=opacity or 1}
    local a=glyph(group,id.."_a",state.a,"a",state.a.x,-state.a.y,outline)
    local b=glyph(group,id.."_b",state.b,"b",state.b.x,-state.b.y,outline)
    return {group=group,a=a,b=b}
end
local function flow(id,x1,x2,y)
    return scene:arrow{id=id,from=p(x1,y),to=p(x2,y),stroke="muted",width=1.4,tip=9,layer=15}
end
txt("application_header","Application",appX+BW/2,82,22,{0.5,0.5})
txt("library_header","Graphics Library",libX+BW/2,82,22,{0.5,0.5})
txt("surface_header","Surface",outX+BW/2,82,22,{0.5,0.5})
txt("immediate_title","Immediate",40,imY+BH/2,22)
txt("retained_title","Retained",40,reY+BH/2,22)
for _,v in ipairs({{"im",imY},{"re",reY}}) do
    box(v[1].."_app",appX,v[2]);box(v[1].."_library",libX,v[2]);box(v[1].."_surface",outX,v[2])
    flow(v[1].."_api_flow",appX+BW+14,libX-14,v[2]+BH/2)
    flow(v[1].."_render_flow",libX+BW+14,outX-14,v[2]+BH/2)
end
txt("im_scene","Scene",appX+16,imY+24,18,nil,"muted")
local retainedLabel=scene:text{id="re_scene",text="Scene",point=p(libX+16,reY+24),font="CMUTypewriter-Regular",
    role="code",size=18,align={0,0.5},fill="muted",opacity=0,layer=50}
local imModel=pair("im_model",appX,imY,states[1],false)
local reModel=pair("re_model",appX,reY,states[1],false)
local packets,resultPackets,outputs={},{},{}
for i,state in ipairs(states) do
    packets[i]=pair("im_commands_"..i,appX,imY,state,false,0)
    resultPackets[i]={pair("im_result_"..i,libX,imY,state,false,0),pair("re_result_"..i,libX,reY,state,false,0)}
    outputs[i]={pair("im_output_"..i,outX,imY,state,false,0),pair("re_output_"..i,outX,reY,state,false,0)}
end
local updates={}
for i=2,#states do
    local point=p(appX+BW/2,reY+BH/2)
    local g=scene:group{id="re_update_"..i,matrix=mat(point[1],point[2]),opacity=0}
    glyph(g,"re_update_glyph_"..i,states[i].a,"a",0,0,true)
    updates[i]=g
end
local function hideTargets(pairs)
    local d={};for _,v in ipairs(pairs) do d[#d+1]={target=v.group,opacity=0} end
    scene:play(d,0.18,"linear")
end
-- 1. The retained pair moves once into the library; the immediate commands are sent.
scene:wait(0.7)
scene:fade_in(packets[1].group,{duration=0.25})
scene:play({{target=packets[1].group,shift={libX-appX,0}},
            {target=reModel.group,shift={libX-appX,0}}},1.15,"ease_in_out")
scene:fade_in(retainedLabel,{duration=0.25})
scene:wait(0.35)
local function dispatchResults(index)
    local pairset=resultPackets[index]
    -- Immediate keeps no commands after the render starts; Retained keeps its Scene.
    scene:play({{target=pairset[1].group,opacity=1},{target=pairset[2].group,opacity=1},
                {target=packets[index].group,opacity=0}},0.22)
    -- Each render clears the surface and writes every paint again in both modes.
    if index>1 then hideTargets(outputs[index-1]) end
    scene:play({{target=pairset[1].group,shift={outX-libX,0}},
                {target=pairset[2].group,shift={outX-libX,0}}},0.7,"ease_in_out")
    scene:play({{target=pairset[1].group,opacity=0},{target=pairset[2].group,opacity=0},
                {target=outputs[index][1].group,opacity=1},{target=outputs[index][2].group,opacity=1}},0.18)
end
dispatchResults(1)
scene:wait(0.85)
for i=2,#states do
    local cur,prev=states[i],states[i-1]
    local dx,dy=cur.a.x-prev.a.x,prev.a.y-cur.a.y
    -- Same edit: immediate sends both commands again; retained sends one update
    -- to the circle the library already holds.
    scene:play({{target=imModel.a,shift={dx,dy},fill=cur.a.color}},0.55,"ease_in_out")
    scene:fade_in(packets[i].group,{duration=0.2})
    scene:fade_in(updates[i],{duration=0.2})
    scene:play({{target=packets[i].group,shift={libX-appX,0}},
                {target=updates[i],shift={libX+cur.a.x-(appX+BW/2),BH/2-cur.a.y}}},0.95,"ease_in_out")
    scene:play({{target=reModel.a,shift={dx,dy},fill=cur.a.color}},0.45,"ease_in_out")
    scene:fade_out(updates[i],{duration=0.18})
    scene:wait(0.35)
    dispatchResults(i)
    scene:wait(0.8)
end
scene:wait(1.5)
return scene
