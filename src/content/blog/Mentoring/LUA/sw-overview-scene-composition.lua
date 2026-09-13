-- ThorVG 6cf10d4: tvgScene.h needComposition/update/render;
-- tvgSwRenderer.cpp target/beginComposite/endComposite; thorvg.h Scene::add.
-- Model: root.children = [circle, nested], nested.children = [triangle, square].
-- Child indices mean sibling list order. Enclosures mean parent/child membership.
-- There are NO arrows between Paints. The only arrow means bitmap compositing.
-- Two simultaneous views of the same retained graph: Direct above, Group Opacity below.
-- All child paints opaque, Normal blend, no masks/effects, two nested children.
-- 255 draws all three shapes directly. 128 draws nested children to offscreen at
-- 255, then composites ONE flattened RGBA image at 128/255 over the root circle.
-- Image pixels derive from the same shape records (illustrative AA, not ThorVG AA).
-- Beats: both graphs -> circles together -> triangles together -> squares together
-- -> lower offscreen bitmap composite -> both results held for comparison.
-- Pixel-plan Y down -> world Y up. Bands: surfaces 10, paints 30+, proxy 45, text 60.
-- @contain: direct_root_label=direct_root_box:12
-- @contain: direct_circle_label=direct_circle_box:12
-- @contain: direct_nested_label=direct_nested_box:12
-- @contain: direct_triangle_child=direct_nested_box:12
-- @contain: direct_square_child=direct_nested_box:12
-- @contain: direct_opacity=direct_nested_box:12
-- @contain: group_root_label=group_root_box:12
-- @contain: group_circle_label=group_circle_box:12
-- @contain: group_nested_label=group_nested_box:12
-- @contain: group_triangle_child=group_nested_box:12
-- @contain: group_square_child=group_nested_box:12
-- @contain: group_opacity=group_nested_box:12
-- @standalone: direct_title group_title direct_buffer_label group_buffer_label intermediate_label composite_label
local W,H=2200,2100
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme={preset="pro_white",background="#f2f2f2"},
    camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function mat(x,y,s) local q=p(x,y);s=s or 1;return {s,0,0,q[1],0,s,0,q[2],0,0,1,0,0,0,0,1} end
local function label(g,id,text,x,y,size,color)
    return g:text{id=id,text=text,point=p(x,y),font="Pretendard",role="text",size=size or 30,
        align={0,0.5},fill=color or "#202020",layer=60}
end
local function box(g,id,x,y,w,h,fill)
    return g:rectangle{id=id,center=p(x+w/2,y+h/2),size={w,h},
        fill=fill or "#ffffff",stroke="#202020",width=1.5,layer=10}
end
local model={
    circle={kind="circle",x=-35,y=-15,r=78,color="#2878db"},
    square={kind="square",x=38,y=15,w=135,h=115,color="#e9a53b"},
    triangle={kind="triangle",x=0,y=-10,r=100,color="#8254bc"},
}
local rootOrder={"circle","nested"}
local nestedOrder={"square"}
table.insert(nestedOrder,1,"triangle") -- nested.add(triangle, square)
local drawOrder={rootOrder[1],nestedOrder[1],nestedOrder[2]}
assert(drawOrder[1]=="circle" and drawOrder[2]=="triangle" and drawOrder[3]=="square")
local groupOpacity=128
local function glyph(owner,id,item,centered,outline,layer)
    local x,y=centered and 0 or item.x,centered and 0 or -item.y
    local c={id=id,fill=outline and "#00000000" or item.color,
        stroke=outline and item.color or "#00000000",width=2.4,layer=layer or 30}
    if item.kind=="circle" then c.center={x,y};c.radius=item.r;return owner:circle(c)
    elseif item.kind=="square" then c.center={x,y};c.size={item.w,item.h};return owner:rectangle(c)
    else c.points={{x,y+item.r},{x-item.r*0.866,y-item.r*0.5},{x+item.r*0.866,y-item.r*0.5}};return owner:polygon(c) end
end
local lanes={}
for _,phase in ipairs({"direct","group"}) do
    local dy=phase=="direct" and 0 or 1000
    local lane={target={x=1830,y=590+dy},scratch={x=1250,y=590+dy},sources={},outputs={},proxies={}}
    lanes[phase]=lane
    local root=scene:group{id=phase.."_root_instance"}
    box(root,phase.."_root_box",60,170+dy,760,710)
    root:rectangle{id=phase.."_header",center=p(440,222+dy),size={760,104},fill="#202020",layer=12}
    label(root,phase.."_root_label","Scene",95,222+dy,32,"#ffffff")
    label(scene,phase.."_title",phase=="direct" and "Direct" or "Group Opacity",60,90+dy,36)
    local childCircle=root:group{id=phase.."_circle_instance"}
    box(childCircle,phase.."_circle_box",95,330+dy,240,275)
    label(childCircle,phase.."_circle_label","01  Shape",115,375+dy,27)
    local nested=root:group{id=phase.."_nested_instance"}
    box(nested,phase.."_nested_box",385,330+dy,395,440)
    label(nested,phase.."_nested_label","02  Scene",410,375+dy,27)
    label(nested,phase.."_triangle_child","01",468,630+dy,25)
    label(nested,phase.."_square_child","02",653,630+dy,25)
    label(nested,phase.."_opacity","opacity("..(phase=="direct" and 255 or groupOpacity)..")",410,720+dy,27)
    lane.sources={circle={205,510+dy},triangle={485,555+dy},square={670,555+dy}}
    for _,key in ipairs(drawOrder) do
        local at=lane.sources[key]
        local owner=key=="circle" and childCircle or nested
        local g=owner:group{id=phase.."_source_"..key,matrix=mat(at[1],at[2],0.45)}
        glyph(g,phase.."_source_"..key.."_paint",model[key],true,false,35)
        local proxy=scene:group{id=phase.."_proxy_"..key,matrix=mat(at[1],at[2],0.45),opacity=0}
        glyph(proxy,phase.."_proxy_"..key.."_paint",model[key],true,true,45)
        lane.proxies[key]=proxy
    end
    lane.border=box(scene,phase.."_buffer_box",lane.target.x-210,lane.target.y-210,420,420)
    label(scene,phase.."_buffer_label","Canvas",lane.target.x-210,330+dy,32)
end
scene:line{id="comparison_divider",from=p(60,1000),to=p(2140,1000),stroke="#cccccc",width=1,layer=10}
local target,scratch=lanes.group.target,lanes.group.scratch
local intermediate=scene:group{id="intermediate_surface"}
local scratchBorder=box(intermediate,"intermediate_box",scratch.x-210,scratch.y-210,420,420)
label(intermediate,"intermediate_label","Offscreen",scratch.x-210,1330,32)
-- Checkerboard conveys transparent storage, not a white background.
for row=0,13 do for col=0,13 do
    intermediate:rectangle{id="checker_"..row.."_"..col,center=p(scratch.x-195+col*30,scratch.y-195+row*30),size={30,30},
        fill=(row+col)%2==0 and "#f0f2f5" or "#ffffff",layer=11}
end end
for _,phase in ipairs({"direct","group"}) do
    local lane=lanes[phase]
    for i,key in ipairs(drawOrder) do
        local offscreen=phase=="group" and key~="circle"
        local destination=offscreen and scratch or lane.target
        local id=offscreen and "offscreen_"..key or phase.."_"..key
        local owner=offscreen and intermediate or scene
        local g=owner:group{id=id,matrix=mat(destination.x,destination.y),opacity=0}
        glyph(g,id.."_paint",model[key],false,false,30+i)
        lane.outputs[key]=g
    end
end
-- Flatten into ONE image before applying group opacity, so the triangle is not
-- blended again beneath the square. No per-child-opacity shortcut is used.
local pixels={}
local resolution,imageWidth=128,300
local tri,sq=model.triangle,model.square
local squareColor=sq.color.."ff"
local triangleColor=tri.color.."ff"
for row=0,resolution-1 do
    local y=(row+0.5)*imageWidth/resolution-imageWidth/2
    local inTriangleRow=y>=tri.y-tri.r and y<=tri.y+tri.r*0.5
    local halfWidth=(y-(tri.y-tri.r))*0.866/1.5
    local inSquareRow=y>=sq.y-sq.h/2 and y<=sq.y+sq.h/2
    for col=0,resolution-1 do
        local x=(col+0.5)*imageWidth/resolution-imageWidth/2
        if inSquareRow and x>=sq.x-sq.w/2 and x<=sq.x+sq.w/2 then pixels[#pixels+1]=squareColor
        elseif inTriangleRow and x>=tri.x-halfWidth and x<=tri.x+halfWidth then pixels[#pixels+1]=triangleColor
        else pixels[#pixels+1]="#00000000" end
    end
end
local bitmap=scene:group{id="composited_bitmap",matrix=mat(scratch.x,scratch.y),opacity=0}
bitmap:image{id="composited_image",pixels=pixels,size={resolution,resolution},center={0,0},width=imageWidth,filter="bilinear",layer=40}
local compositeArrow=scene:arrow{id="bitmap_composite_arrow",from=p(1485,target.y),to=p(1595,target.y),stroke="#202020",width=1.8,tip=9,layer=15}
local compositeLabel=label(scene,"composite_label","opacity × "..groupOpacity.."/255",1270,1895,30)
-- Corresponding Paints are drawn together, so only the destination differs.
scene:wait(0.8)
for _,key in ipairs(drawOrder) do
    local entrances,moves,outputs,exits={},{},{},{}
    for _,phase in ipairs({"direct","group"}) do
        local lane=lanes[phase]
        local destination=phase=="group" and key~="circle" and scratch or lane.target
        local item,proxy=model[key],lane.proxies[key]
        entrances[#entrances+1]={target=proxy,opacity=1}
        moves[#moves+1]={target=proxy,transform=mat(destination.x+item.x,destination.y+item.y)}
        outputs[#outputs+1]={target=lane.outputs[key],opacity=1}
        exits[#exits+1]={target=proxy,opacity=0}
    end
    scene:play(entrances,.15)
    scene:play(moves,1.0,"ease_in_out")
    scene:play(outputs,.25)
    scene:play(exits,.15)
    scene:wait(.5)
end
-- Direct stays complete while the lower lane composites a single flattened image.
scene:create(compositeArrow,.4)
scene:fade_in(compositeLabel,{duration=.25})
scene:fade(bitmap,1,.2)
scene:shift(bitmap,{target.x-scratch.x,0},1.2,"ease_in_out")
scene:fade(bitmap,groupOpacity/255,.7)
scene:stroke(lanes.group.border,"#202020",.3)
scene:wait(2.5)
return scene
