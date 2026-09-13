-- @contain: lottie_caption=lottie_panel:12 lottie_note=lottie_panel:12
-- @contain: lottie_root_label=lottie_root_box:12
-- @contain: lottie_shape_layer_label=lottie_shape_layer_box:12
-- @contain: lottie_image_layer_label=lottie_image_layer_box:12
-- @contain: lottie_shape_label=lottie_shape_box:12
-- @contain: lottie_image_label=lottie_image_box:12
-- @contain: svg_caption=svg_panel:12 svg_note=svg_panel:12
-- @contain: svg_root_label=svg_root_box:12
-- @contain: svg_group_label=svg_group_box:12
-- @contain: svg_image_label=svg_image_box:12
-- @contain: svg_rect_label=svg_rect_box:12
-- @contain: svg_path_label=svg_path_box:12
-- @contain: label_PictureRoot=box_PictureRoot:12
-- @contain: label_ImageLoader=box_ImageLoader:12
-- @contain: label_VectorPaint=box_VectorPaint:12
-- @contain: label_RenderSurface=box_RenderSurface:12
-- @contain: label_PixelBuffer=box_PixelBuffer:12
-- @contain: tree_caption=tree_panel:12
-- @contain: label_Canvas=box_Canvas:12
-- @contain: label_SwCanvas=box_SwCanvas:12
-- @contain: label_GlCanvas=box_GlCanvas:12
-- @contain: label_WgCanvas=box_WgCanvas:12
-- @contain: label_CanvasImpl=box_CanvasImpl:12
-- @contain: label_MainScene=box_MainScene:12
-- @contain: label_RenderMethod=box_RenderMethod:12
-- @contain: label_SwRenderer=box_SwRenderer:12
-- @contain: label_GlRenderer=box_GlRenderer:12
-- @contain: label_WgRenderer=box_WgRenderer:12
-- @contain: label_Scene=box_Scene:12
-- @contain: label_Paint=box_Paint:12
-- @contain: label_Matrix=box_Matrix:12
-- @contain: label_Picture=box_Picture:12
-- @contain: label_Text=box_Text:12
-- @contain: label_Shape=box_Shape:12
-- @contain: label_ChildShape=box_ChildShape:12
-- @contain: label_ChildScene=box_ChildScene:12
-- @contain: label_Animation=box_Animation:12
-- @contain: label_LottieAnimation=box_LottieAnimation:12
-- @contain: label_TreeRoot=box_TreeRoot:12
-- @contain: label_TreeShape=box_TreeShape:12
-- @contain: label_TreeScene=box_TreeScene:12
-- @contain: label_TreeText=box_TreeText:12
-- @contain: label_TreePicture=box_TreePicture:12
-- @contain: label_RenderShape=box_RenderShape:12
-- @contain: label_RenderPath=box_RenderPath:12
-- @contain: label_Fill=box_Fill:12
-- @contain: label_Point=box_Point:12
-- @contain: label_PathCommand=box_PathCommand:12
-- @contain: label_ColorStop=box_ColorStop:12
-- @contain: label_LinearGradient=box_LinearGradient:12
-- @contain: label_RadialGradient=box_RadialGradient:12
-- @standalone: heading_canvas heading_scene heading_shape heading_picture vector_formats bitmap_formats bitmap_source legend label_picture_loader label_picture_vector label_picture_bitmap label_bitmap_data label_canvas_impl label_impl_method label_canvas_scene label_scene_children label_paint_matrix label_animation_picture label_text_shape label_shape_render label_render_path label_render_fill label_pts label_cmds label_stops
-- ThorVG 6cf10d4: existing API ownership and inheritance relationships.
-- Four horizontal sections; arrows denote references, hollow triangles inheritance.
-- Picture: tvgPicture.h PictureImpl::{loader,vector,bitmap}; tvgRender.h RenderSurface::data.
-- Static diagram: all relationships are visible at time zero.
-- Tree nodes are illustrative instances, separate from the API type graph.
local W,H=2400,5160
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme={preset="pro_white",background="#f1f1f1"},camera={mode="fixed",view="2d",height=H}}
local function p(x,y)return{x-W/2,H/2-y}end
-- Match raster/dispatch.lua at the same displayed width (1280px reference).
local styleScale=W/1280
local ink,muted="#191919","#686868"
local nodeStroke,arrowStroke,arrowTip=2*styleScale,2.5*styleScale,9*styleScale
local dash={7*styleScale,6*styleScale}
local function text(g,id,value,x,y,size)
 return g:text{id=id,text=value,point=p(x,y),font="Pretendard",role="text",size=size or 24,align={.5,.5},fill=muted,layer=30}
end
text(scene,"heading_canvas","01  Canvas",220,65,32)
text(scene,"heading_scene","02  Scene",220,1040,32)
text(scene,"heading_shape","03  Shape",220,2200,32)
text(scene,"legend","△ Inherits from     → Holds / references     ┄ Internal implementation",1200,5100,25)
for i,y in ipairs({980,2140,3060})do scene:line{id="divider_"..i,from=p(60,y),to=p(2340,y),stroke="#aaaaaa",width=styleScale,layer=1}end
text(scene,"heading_picture","04  Picture",220,3120,32)
local nodes={
PictureRoot={210,3780,260,true,"Picture",false},
ImageLoader={1190,3580,360,false,nil,true},
VectorPaint={1190,3780,360,false,"Paint",false},
RenderSurface={1190,4020,360,false,nil,true},
PixelBuffer={1920,4020,360,false,"Pixel buffer",false},
Canvas={210,620,260,true,nil,false},
SwCanvas={670,180,300,false,nil,false},
GlCanvas={670,320,300,false,nil,false},
WgCanvas={670,460,300,false,nil,false},
CanvasImpl={670,620,300,false,"Canvas::Impl",true},
MainScene={1190,860,330,false,"Scene · main",false},
RenderMethod={1190,620,330,false,nil,true},
SwRenderer={1920,460,330,false,nil,true},
GlRenderer={1920,620,330,false,nil,true},
WgRenderer={1920,780,330,false,nil,true},
Scene={210,1400,260,true,nil,false},
Paint={670,1400,300,false,nil,false},
Matrix={1190,1140,300,false,nil,false},
Picture={1190,1300,300,false,nil,false},
Text={1190,1460,300,false,nil,false},
Shape={210,2500,260,true,nil,false},
ChildShape={1190,1620,300,false,"Shape",false},
ChildScene={1190,1780,300,false,"Scene",false},
Animation={210,3340,300,true,nil,false},
LottieAnimation={670,3340,370,false,nil,false},
TreeRoot={1860,1680,270,false,"Scene · root",false},
TreeShape={1650,1840,250,false,"Shape · A",false},
TreeScene={2070,1840,310,false,"Scene · group",false},
TreeText={1920,2000,220,false,"Text · B",false},
TreePicture={2200,2000,240,false,"Picture · C",false},
RenderShape={670,2500,330,false,nil,true},
RenderPath={1190,2350,330,false,nil,true},
Fill={1190,2800,330,false,nil,false},
Point={1920,2280,360,false,nil,false},
PathCommand={1920,2440,360,false,nil,false},
ColorStop={1920,2640,360,false,nil,false},
LinearGradient={1920,2800,360,false,nil,false},
RadialGradient={1920,2960,360,false,nil,false},
}
local order={"PictureRoot","ImageLoader","VectorPaint","RenderSurface","PixelBuffer","Canvas","SwCanvas","GlCanvas","WgCanvas","CanvasImpl","MainScene","RenderMethod","SwRenderer","GlRenderer","WgRenderer","Scene","Paint","Matrix","Picture","Text","Shape","ChildShape","ChildScene","Animation","LottieAnimation","TreeRoot","TreeShape","TreeScene","TreeText","TreePicture","RenderShape","RenderPath","Fill","Point","PathCommand","ColorStop","LinearGradient","RadialGradient"}
local function port(id,side,off)
 local n=nodes[id];off=off or 0
 if side=="l"then return{n[1]-n[3]/2,n[2]+off}elseif side=="r"then return{n[1]+n[3]/2,n[2]+off}
 else return{n[1]+off,n[2]+(side=="t" and -42 or 42)*(n.scale or 1)}end
end
-- Scale the independent example as a whole around its panel center.
local treeScale=.8
local treeCenter=p(1890,1810)
local treeExample=scene:group{id="tree_example",matrix={
 treeScale,0,0,treeCenter[1]*(1-treeScale),
 0,treeScale,0,treeCenter[2]*(1-treeScale),
 0,0,1,0, 0,0,0,1,
}}
for _,id in ipairs(order)do
 local n=nodes[id];local owner=id:sub(1,4)=="Tree"and treeExample or scene
 n.g=owner:group{id="node_"..id,opacity=1}
 local pixelScale=owner==treeExample and treeScale or 1
 n.g:rectangle{id="box_"..id,center=p(n[1],n[2]),size={n[3],84*(n.scale or 1)},fill=n[4]and ink or "#ffffff",stroke=ink,width=nodeStroke*pixelScale,dash=n[6]and dash or nil,layer=20}
 n.g:text{id="label_"..id,text=n[5]or id,point=p(n[1],n[2]),font="Pretendard",role="text",size=18*styleScale*(n.scale or 1)*pixelScale,align={.5,.5},fill=n[4]and "#ffffff"or ink,layer=30}
end
local function edge(id,a,b,label,kind,via)
 local owner=id:sub(1,4)=="Tree"and treeExample or scene
 local g=owner:group{id="edge_"..id}
 local pixelScale=owner==treeExample and treeScale or 1
 local pts={a};for _,v in ipairs(via or {})do pts[#pts+1]=v end;pts[#pts+1]=b
 local world={};for _,v in ipairs(pts)do world[#world+1]=p(v[1],v[2])end
 if kind=="inherit"then
  local prev=pts[#pts-1];local dx,dy=b[1]-prev[1],b[2]-prev[2];local d=math.sqrt(dx*dx+dy*dy);dx,dy=dx/d,dy/d
  world[#world]=p(b[1]-arrowTip*dx,b[2]-arrowTip*dy)
  g:polygon{id=id.."_tip",points={p(b[1],b[2]),p(b[1]-dx*arrowTip-dy*arrowTip/2,b[2]-dy*arrowTip+dx*arrowTip/2),p(b[1]-dx*arrowTip+dy*arrowTip/2,b[2]-dy*arrowTip-dx*arrowTip/2)},fill="#ffffff",stroke=ink,width=arrowStroke,layer=11}
 end
 g:route{id=id.."_shaft",points=world,stroke=ink,width=arrowStroke*pixelScale,tip=kind=="inherit"and 0 or kind=="plain"and 0 or arrowTip,layer=10}
 if label then text(g,"label_"..id,label[1],label[2],label[3],13*styleScale)end
end
local function family(id,parent,children,busX,parentSide,via)
 local first,last=nodes[children[1]],nodes[children[#children]]
 edge(id.."_bus",{busX,first[2]},{busX,last[2]},nil,"plain")
 for _,child in ipairs(children)do
  edge(id.."_"..child,port(child,"l"),{busX,nodes[child][2]},nil,"plain")
 end
 local parentNode=nodes[parent]
 local startY=parentSide=="t" and nodes[children[2]][2] or parentNode[2]
 edge(id.."_parent",{busX,startY},port(parent,parentSide),nil,"inherit",via)
end
family("canvas_family","Canvas",{"SwCanvas","GlCanvas","WgCanvas"},430,"t",{{210,320}})
edge("canvas_impl",port("Canvas","r"),port("CanvasImpl","l"),{"impl",430,580},nil,nil)
edge("impl_method",port("CanvasImpl","r"),port("RenderMethod","l"),{"renderer",925,580},nil,nil)
edge("canvas_scene",port("CanvasImpl","b"),port("MainScene","l"),{"scene",925,820},nil,{{670,860}})
family("renderer_family","RenderMethod",{"SwRenderer","GlRenderer","WgRenderer"},1530,"r")
edge("scene_children",port("Scene","r"),port("Paint","l"),{"paints · children",430,1325},nil,nil)
edge("paint_matrix",port("Paint","t"),port("Matrix","l"),{"transform",920,1100},nil,{{670,1140}})
family("paint_family","Paint",{"Picture","Text","ChildShape","ChildScene"},940,"r")
edge("lottie_animation",port("LottieAnimation","l"),port("Animation","r"),nil,"inherit",nil)
-- Reuse the public Shape type, with a curved reference outside the sibling column.
local from,to=port("Text","r"),port("ChildShape","r")
local bend=100
local points={}
for i=0,48 do
 local t=i/48;local u=1-t
 points[#points+1]=p(u*u*u*from[1]+3*u*u*t*(from[1]+bend)+3*u*t*t*(to[1]+bend)+t*t*t*to[1],
                      u*u*u*from[2]+3*u*u*t*from[2]+3*u*t*t*to[2]+t*t*t*to[2])
end
scene:route{id="text_shape_shaft",points=points,stroke=ink,width=arrowStroke,tip=arrowTip,layer=10}
text(scene,"label_text_shape","TextImpl::shape",1580,1480,13*styleScale)
local treePanel=treeExample
treePanel:rectangle{id="tree_panel",center=p(1890,1810),size={900,540},fill="#e7e7e7",stroke=ink,width=1.8*styleScale*treeScale,dash={dash[1]*treeScale,dash[2]*treeScale},layer=2}
text(treePanel,"tree_caption","Scene tree example",1890,1585,25*treeScale)

edge("TreeRootTreeShape",port("TreeRoot","b"),port("TreeShape","t"),nil,"plain",{{1860,1760},{1650,1760}})
edge("TreeRootTreeScene",{1860,1760},port("TreeScene","t"),nil,"plain",{{2070,1760}})
edge("TreeSceneTreeText",port("TreeScene","b"),port("TreeText","t"),nil,"plain",{{2070,1920},{1920,1920}})
edge("TreeSceneTreePicture",{2070,1920},port("TreePicture","t"),nil,"plain",{{2200,1920}})
edge("shape_render",port("Shape","r"),port("RenderShape","l"),{"ShapeImpl::rs",425,2425},nil,nil)
edge("render_path",port("RenderShape","r"),port("RenderPath","l"),{"path",965,2310},nil,{{920,2500},{920,2350}})
edge("render_fill",port("RenderShape","b"),port("Fill","l"),{"fill",930,2760},nil,{{670,2800}})
edge("pts",port("RenderPath","r"),port("Point","l"),{"pts",1620,2240},nil,{{1510,2350},{1510,2280}})
edge("cmds",{1510,2350},port("PathCommand","l"),{"cmds",1620,2400},nil,{{1510,2440}})
edge("stops",port("Fill","t"),port("ColorStop","l"),{"colorStops",1580,2600},nil,{{1190,2640}})
family("fill_family","Fill",{"LinearGradient","RadialGradient"},1530,"r")
-- Animation owns Picture; LottieAnimation extends its playback API.
edge("animation_picture",port("Animation","b"),port("PictureRoot","t"),{"picture()",330,3560},nil,nil)
-- Loader and content pointers belong to PictureImpl; vector and bitmap are content alternatives.
edge("picture_loader",port("PictureRoot","r"),port("ImageLoader","l"),{"PictureImpl::loader",700,3540},nil,{{430,3780},{430,3580}})
edge("picture_vector",{430,3780},port("VectorPaint","l"),{"PictureImpl::vector",700,3740},nil,nil)
edge("picture_bitmap",{430,3780},port("RenderSurface","l"),{"PictureImpl::bitmap",700,3980},nil,{{430,4020}})
edge("bitmap_data",port("RenderSurface","r"),port("PixelBuffer","l"),{"data / buf32 / buf8",1550,3980},nil,nil)
text(scene,"vector_formats","Vector · Lottie (JSON), SVG",1190,3870,27)
text(scene,"bitmap_formats","Bitmap · JPG / JPEG, WebP, PNG, …",1190,4110,27)
text(scene,"bitmap_source","Source image pixels",1920,4110,25)
-- Illustrative loaded content, not an exact dump of a particular file.
-- 6cf10d4: LottieLoader::paint, LottieBuilder::build/updateLayer/updateImage;
-- SvgLoader::paint, _sceneBuildHelper, _shapeBuildHelper, _imageBuildHelper.
-- Additional clip/mask/group wrappers are omitted; image leaves use PNG assets here.
local examples={
 {id="lottie",title="Lottie structure example",x=610,nodes={
  {"root","Scene · composition",0,4510,360},
  {"shape_layer","Scene · shape layer",-235,4690,360,"root"},
  {"image_layer","Scene · image layer",235,4690,360,"root"},
  {"shape","Shape",-235,4870,280,"shape_layer"},
  {"image","Picture · PNG asset",235,4870,360,"image_layer"},
 }},
 {id="svg",title="SVG structure example",x=1790,nodes={
  {"root","Scene · <svg>",0,4510,360},
  {"group","Scene · <g>",-160,4690,300,"root"},
  {"image","Picture · <image>",320,4690,360,"root"},
  {"rect","Shape · <rect>",-330,4870,280,"group"},
  {"path","Shape · <path>",0,4870,280,"group"},
 }},
}
for _,example in ipairs(examples)do
 local group=scene:group{id=example.id.."_example"}
 group:rectangle{id=example.id.."_panel",center=p(example.x,4670),size={1080,660},fill="#e7e7e7",stroke=ink,width=1.8*styleScale*treeScale,dash={dash[1]*treeScale,dash[2]*treeScale},layer=2}
 text(group,example.id.."_caption",example.title,example.x,4390,25)
 text(group,example.id.."_note","Simplified loaded Paint tree · wrappers omitted",example.x,4950,22)
 local byId={}
 for _,node in ipairs(example.nodes)do
  local id=example.id.."_"..node[1]
  local x=example.x+node[3];node.x=x;byId[node[1]]=node
  local box=group:rectangle{id=id.."_box",center=p(x,node[4]),size={node[5],68},fill="#ffffff",stroke=ink,width=nodeStroke*treeScale,layer=20}
  box:text{id=id.."_label",text=node[2],point=p(x,node[4]),font="Pretendard",role="text",size=18*styleScale*treeScale,align={.5,.5},fill=ink,layer=30}
 end
 for _,parent in ipairs(example.nodes)do
  local children={}
  for _,node in ipairs(example.nodes)do if node[6]==parent[1]then children[#children+1]=node end end
  if #children>0 then
   local busY=(parent[4]+children[1][4])/2
   group:route{id=example.id.."_"..parent[1].."_stem",points={p(parent.x,parent[4]+34),p(parent.x,busY)},stroke=ink,width=arrowStroke*treeScale,tip=0,layer=10}
   local left,right=parent.x,parent.x
   for _,child in ipairs(children)do left=math.min(left,child.x);right=math.max(right,child.x)end
   if right>left then group:route{id=example.id.."_"..parent[1].."_bus",points={p(left,busY),p(right,busY)},stroke=ink,width=arrowStroke*treeScale,tip=0,layer=10}end
   for _,child in ipairs(children)do group:route{id=example.id.."_"..child[1].."_branch",points={p(child.x,busY),p(child.x,child[4]-34)},stroke=ink,width=arrowStroke*treeScale,tip=0,layer=10}end
  end
 end
end
return scene
