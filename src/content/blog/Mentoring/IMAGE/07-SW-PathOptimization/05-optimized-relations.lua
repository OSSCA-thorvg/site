-- Source: 6b94ffbdb9d63f8032ebfc46bd233f792c4f8b8d.
-- Same node coordinates in both variants; relationships, not wall-clock time.
-- Type definitions: thorvg.h, tvgShape.h, tvgPaint.h, tvgRender.h, tvgSwCommon.h.
-- Flow: tvgSwShape.cpp shapeGenRle, tvgSwUtil.cpp utilExport, tvgSwRle.cpp.
local after=true
local W,H=1600,1100
local s=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",
 camera={mode="fixed",view="2d",height=H}}
local function p(x,y)return{x-W/2,H/2-y}end
local ink,muted,blue,green,amber="#273449","#8190a3","#4c83b9","#368b76","#bc7d36"
local nodes={
 Paint={x=190,y=95,w=240,h=72,family="api",fields={}},
 Shape={x=190,y=235,w=240,h=72,family="api",fields={}},
 ShapeImpl={x=190,y=450,w=290,h=200,fields={"impl: Paint::Impl","rs: RenderShape","opacity: uint8_t"}},
 PaintImpl={title="Paint::Impl",x=565,y=270,w=330,h=160,fields={"tr: transform","renderFlag, rd"}},
 RenderShape={x=565,y=545,w=400,h=280,fields={"path: RenderPath","fill: Fill*","color: RenderColor","stroke: RenderStroke*","rule: FillRule"}},
 RenderPath={x=565,y=835,w=380,h=160,fields={"cmds: PathCommand[]","pts: Point[]"}},
 SwMpool={x=1250,y=105,w=360,h=120,fields={"outlines: SwOutline[]"}},
 SwOutline={x=1250,y=535,w=460,h=380,fields=after and {"path: const RenderPath*","synth: RenderPath","out: SwPoint[]","fillRule: FillRule"} or
 {"in: Point[]","out: SwPoint[]","types: uint8_t[]","cntrs: uint32_t[]","closed: bool[]","fillRule: FillRule"}},
 SwRle={x=1250,y=865,w=350,h=120,fields={"spans: SwSpan[]"}},
}
local order={"Paint","Shape","ShapeImpl","PaintImpl","RenderShape","RenderPath","SwMpool","SwOutline","SwRle"}
local function label(parent,id,t,x,y,size,color)
 return parent:text{id=id,text=t,point=p(x,y),font="Pretendard",role="code",size=size or 25,
  align={0.5,0.5},fill=color or ink,layer=30}
end
for _,id in ipairs(order)do
 local n=nodes[id];n.top=n.y-n.h/2;n.bottom=n.y+n.h/2;n.left=n.x-n.w/2;n.right=n.x+n.w/2
 local g=s:group{id="node_"..id};n.g=g
 g:rectangle{id="box_"..id,center=p(n.x,n.y),size={n.w,n.h},corner=10,
  fill=n.family=="api" and "#f7f4fc" or "#ffffff",stroke=n.family=="api" and "#b9a8d0" or "#bdc6d1",
  width=1.8,dash=n.family~="api" and {7,5} or nil,layer=20}
 label(g,"label_"..id,n.title or id,n.x,n.top+(#n.fields==0 and n.h/2 or 30),31)
 if #n.fields>0 then
  g:line{from=p(n.left+20,n.top+57),to=p(n.right-20,n.top+57),stroke="#e2e8f0",width=1,layer=22}
  local step=id=="SwOutline" and 47 or 40
  for i,t in ipairs(n.fields)do
   local col=ink
   if id=="SwOutline"then
    if t:sub(1,4)=="out:"then col=green
    elseif t:sub(1,5)=="path:"then col=blue
    elseif not after and i~=6 then col=amber end
   end
   label(g,"field_"..id.."_"..i,t,n.x,n.top+84+(i-1)*step,25,col)
  end
 end
end
local edges={}
local function edge(id,kind,points,color)
 local g=s:group{id="edge_"..id};color=color or muted
 local world={};for _,q in ipairs(points)do world[#world+1]=p(q[1],q[2])end
 g:route{id="shaft_"..id,points=world,stroke=color,width=2.4,dash=kind=="borrow"and{9,7}or nil,
  tip=kind=="flow"and 11 or nil,layer=10}
 local a,b=points[#points-1],points[#points]
 if kind=="owns"then a,b=points[2],points[1]end
 local dx,dy=b[1]-a[1],b[2]-a[2];local d=math.sqrt(dx*dx+dy*dy);dx,dy=dx/d,dy/d
 local ux,uy=-dy,dx;local cap
 if kind=="extends"then cap={{b[1],b[2]},{b[1]-dx*20+ux*10,b[2]-dy*20+uy*10},{b[1]-dx*20-ux*10,b[2]-dy*20-uy*10}}
 elseif kind=="owns"then cap={b,{b[1]-dx*13+ux*7,b[2]-dy*13+uy*7},{b[1]-dx*26,b[2]-dy*26},{b[1]-dx*13-ux*7,b[2]-dy*13-uy*7}}
 elseif kind=="borrow"then cap={{b[1]-dx*15+ux*7,b[2]-dy*15+uy*7},b,{b[1]-dx*15-ux*7,b[2]-dy*15-uy*7}}end
 if cap then
  local pts={};for _,q in ipairs(cap)do pts[#pts+1]=p(q[1],q[2])end
  if kind=="borrow"then g:route{id="cap_"..id,points=pts,stroke=color,width=2.4,layer=11}
  else g:polygon{id="cap_"..id,points=pts,stroke=color,fill=kind=="owns"and color or"#ffffff",width=2,layer=11}end
 end
 -- Port/route evidence: no shaft may cross a non-incident type boundary.
 edges[id]=g;return g
end
edge("shape_paint","extends",{{190,199},{190,131}},"#9c84b9")
edge("impl_shape","extends",{{190,350},{190,271}},"#9c84b9")
edge("paint_impl","owns",{{335,400},{350,400},{350,270},{400,270}})
edge("render_shape","owns",{{335,480},{350,480},{350,545},{365,545}})
edge("public_impl","borrow",{{310,95},{565,95},{565,190}},blue)
local pl=label(s,"public_impl_label","pImpl",443,71,23,blue)
edge("render_path","owns",{{565,685},{565,755}})
edge("pool_outline","owns",{{1250,165},{1250,345}})
local ol=label(s,"pool_label","outlines[tid]",1370,253,23,muted)
local flow,view,fl,vl
if after then
 view=edge("path_reference","borrow",{{1020,429},{880,429},{880,735},{665,735},{665,755}},blue)
 vl=label(s,"reference_label","path*",780,709,23,blue)
 flow=edge("export","flow",{{755,865},{950,865},{950,523},{1020,523}},green)
 fl=label(s,"flow_label","utilExport()",850,911,23,green)
else
 flow=edge("copy","flow",{{755,835},{940,835},{940,429},{1020,429}},amber)
 fl=label(s,"flow_label","_genOutline()",865,883,23,amber)
end
edge("rle","flow",{{1250,725},{1250,805}},green)
local rl=label(s,"rle_label","rleRender()",1400,765,23,green)
for i,kind in ipairs({"extends","owns","borrow","flow"})do
 local x=75+(i-1)*395
 edge("legend_"..kind,kind,{{x,1040},{x+65,1040}},kind=="flow"and green or muted)
 label(s,"legend_"..kind,({extends="Extends",owns="Owns",borrow="Refers to",flow="Data flow"})[kind],x+165,1040,25,muted)
end
-- Six source-anchored beats; stable positions across revision variants.
s:wait(0.6)
s:create(edges.shape_paint,0.6);s:fade_in(nodes.Shape.g,{duration=0.35})
s:create(edges.impl_shape,0.6);s:fade_in(nodes.ShapeImpl.g,{duration=0.45});s:wait(0.45)
s:create(edges.paint_impl,0.7);s:fade_in(nodes.PaintImpl.g,{duration=0.4})
s:create(edges.public_impl,0.6);s:fade_in(pl,{duration=0.25})
s:create(edges.render_shape,0.6);s:fade_in(nodes.RenderShape.g,{duration=0.45});s:wait(0.6)
s:create(edges.render_path,0.65);s:fade_in(nodes.RenderPath.g,{duration=0.45});s:wait(0.6)
s:fade_in(nodes.SwMpool.g,{duration=0.4});s:create(edges.pool_outline,0.85)
s:fade_in(ol,{duration=0.3});s:fade_in(nodes.SwOutline.g,{duration=0.6});s:wait(0.7)
if after then s:create(view,1.4);s:fade_in(vl,{duration=0.3});s:wait(0.6)end
s:create(flow,1.5);s:fade_in(fl,{duration=0.3});s:wait(0.7)
s:create(edges.rle,0.65);s:fade_in(rl,{duration=0.3});s:fade_in(nodes.SwRle.g,{duration=0.45})
s:wait(2.5)
return s
