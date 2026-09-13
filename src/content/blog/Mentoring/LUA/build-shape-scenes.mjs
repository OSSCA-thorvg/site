import fs from 'node:fs/promises';import path from 'node:path';import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));const data=JSON.parse(await fs.readFile(path.join(dir,'shape-engine-trace.txt'),'utf8'));
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':v&&typeof v==='object'?'{'+Object.entries(v).map(([k,v])=>`${k}=${lua(v)}`).join(',')+'}':JSON.stringify(v);
const common=`
local trace=${lua(data)}
local cases={};for _,c in ipairs(trace.cases) do cases[c.name]=c end
local W,H=1920,1080
local scene=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function rgb(v) return string.format("#%02x%02x%02x",v%256,math.floor(v/256)%256,math.floor(v/65536)%256) end
local function group(id,a) return scene:group{id=id,opacity=a==nil and 1 or a} end
local function label(o,id,text,x,y,size) return o:text{id="label_"..id,text=text,point=p(x,y),font="Pretendard",role="text",size=size or 28,align={0,.5},fill="#344158",layer=60} end
local function line(o,id,a,b,color,width) return o:line{id=id,from=p(a[1],a[2]),to=p(b[1],b[2]),stroke=color or "#a4afbc",width=width or 2,layer=35} end
local function dot(o,id,x,y,color,r) return o:circle{id=id,center=p(x,y),radius=r or 6,fill=color or "#2078dc",stroke="#00000000",layer=45} end
local function rect(o,id,x,y,w,h,fill,stroke,layer) return o:rectangle{id=id,center=p(x,y),size={w,h},fill=fill or "#00000000",stroke=stroke or "#a4afbc",width=1.5,layer=layer or 25} end
local function path(o,id,src,bx,by,u,color,width)
 local g=o:group{id=id};local commands={};local pi=1;local n=0
 local function pt(a) return p(bx+a[1]*u,by+a[2]*u) end
 local function emit() if #commands>0 then n=n+1;g:path{id=id.."_"..n,commands=commands,stroke=color or "#2078dc",fill="#00000000",width=width or 3,layer=30};commands={} end end
 for _,cmd in ipairs(src.cmds) do
  if cmd==1 then emit();commands[#commands+1]={type="move",to=pt(src.pts[pi])};pi=pi+1
  elseif cmd==2 then commands[#commands+1]={type="line",to=pt(src.pts[pi])};pi=pi+1
  elseif cmd==3 then commands[#commands+1]={type="cubic",control1=pt(src.pts[pi]),control2=pt(src.pts[pi+1]),to=pt(src.pts[pi+2])};pi=pi+3
  else commands[#commands+1]={type="close"} end
 end
 emit();return g
end
local function outline(o,id,src,bx,by,u,color,width)
 local rp={cmds={},pts={}};local first=1
 for k,last0 in ipairs(src.ends) do
  local last=last0+1;rp.cmds[#rp.cmds+1]=1;rp.pts[#rp.pts+1]=src.pts[first];local i=first+1
  while i<=last do
   if src.types[i]==1 then rp.cmds[#rp.cmds+1]=3;for j=i,i+2 do rp.pts[#rp.pts+1]=j<=last and src.pts[j] or src.pts[first] end;i=i+3
   else rp.cmds[#rp.cmds+1]=2;rp.pts[#rp.pts+1]=src.pts[i];i=i+1 end
  end
  if #src.closed==0 or src.closed[k] then rp.cmds[#rp.cmds+1]=0 end;first=last+1
 end
 return path(o,id,rp,bx,by,u,color,width)
end
local function grid(id,bx,by,u)
 local cells={};for y=0,trace.h-1 do for x=0,trace.w-1 do local at=y*trace.stride+x
  cells[at]=rect(scene,id.."_"..at,bx+(x+.5)*u,by+(y+.5)*u,u-2,u-2,rgb(trace.background),"#d7dfe7",20)
 end end;return cells
end
local function paint(cells,pixels,duration)
 local ops={};for y=0,trace.h-1 do for x=0,trace.w-1 do local at=y*trace.stride+x;ops[#ops+1]={target=cells[at],fill=rgb(pixels[at+1])} end end;scene:play(ops,duration)
end
local function box(o,id,b,bx,by,u,color) return rect(o,id,bx+(b[1]+b[3])*u/2,by+(b[2]+b[4])*u/2,(b[3]-b[1])*u,(b[4]-b[2])*u,"#00000000",color,40) end
`;
const scenes={};
scenes['01-path-storage']=`
-- Beats: MoveTo point; LineTo; three CubicTo points and curve; Close no point.
local c=cases.fill;local names={"MoveTo","LineTo","CubicTo","Close"}
label(scene,"path","Path",100,130);label(scene,"cmds","cmds",1040,130);label(scene,"pts","pts",1430,130)
local stages,copies={},{ };local starts={1,2,3,6};local counts={1,1,3,0};local ys={260,390,520,820}
for i=1,4 do
 local g=group("api_"..i,i==1 and 1 or 0);stages[i]=g;label(g,"cmd_"..i,names[i],1040,ys[i],30)
 for j=starts[i],starts[i]+counts[i]-1 do local a=c.path.pts[j];local y=240+(j-1)*110
  dot(g,"api_point_"..j,100+a[1]*28,240+a[2]*28,"#2078dc")
  label(g,"point_"..j,string.format("(%g, %g)",a[1],a[2]),1470,y,26)
  local cp=group("point_copy_"..j,0);copies[j]=cp;dot(cp,"copy_dot_"..j,100+a[1]*28,240+a[2]*28,"#2078dc",7)
 end
end
local segments={}
segments[2]=path(scene,"api_line",{cmds={1,2},pts={c.path.pts[1],c.path.pts[2]}},100,240,28)
segments[3]=path(scene,"api_curve",{cmds={1,3},pts={c.path.pts[2],c.path.pts[3],c.path.pts[4],c.path.pts[5]}},100,240,28)
segments[4]=path(scene,"api_close",{cmds={1,2},pts={c.path.pts[5],c.path.pts[1]}},100,240,28)
scene:wait(.5)
for i=1,4 do
 scene:fade(stages[i],1,.2)
 if segments[i] then scene:create(segments[i],.8) else scene:wait(.8) end
 for j=starts[i],starts[i]+counts[i]-1 do local a=c.path.pts[j];scene:fade(copies[j],1,.05);scene:shift(copies[j],{1430-(100+a[1]*28),(240+a[2]*28)-(240+(j-1)*110),0},.4) end
 scene:wait(.6)
end
scene:wait(2)
`;
scenes['02-bezier']=`
-- Beats: control polygon; de Casteljau interpolations; exact t=.5 split.
local b=trace.bezier;local left,right=100,1050;local y,u=220,28
label(scene,"control","P0 / P1 / P2 / P3",left,110);label(scene,"split","t = 0.5",right,110)
for i,a in ipairs(b.control) do dot(scene,"control_"..i,left+a[1]*u,y+a[2]*u);label(scene,"p_"..i,"P"..(i-1),left+a[1]*u-12,y+a[2]*u-27,23);if i>1 then local q=b.control[i-1];line(scene,"control_line_"..i,{left+q[1]*u,y+q[2]*u},{left+a[1]*u,y+a[2]*u}) end end
local states,traceLines={},{}
local function lerp(a,b,t) return {a[1]+(b[1]-a[1])*t,a[2]+(b[2]-a[2])*t} end
for k=1,59 do
 local t=k/60;local a={};for i=1,3 do a[i]=lerp(b.control[i],b.control[i+1],t) end
 local q={lerp(a[1],a[2],t),lerp(a[2],a[3],t)};local g=group("casteljau_"..k,0);states[k]=g
 for i=1,3 do dot(g,"lerp1_"..k.."_"..i,left+a[i][1]*u,y+a[i][2]*u,"#13877f",4);if i>1 then line(g,"lerp1_line_"..k.."_"..i,{left+a[i-1][1]*u,y+a[i-1][2]*u},{left+a[i][1]*u,y+a[i][2]*u},"#13877f") end end
 line(g,"lerp2_line_"..k,{left+q[1][1]*u,y+q[1][2]*u},{left+q[2][1]*u,y+q[2][2]*u},"#cf8c30")
 for i=1,2 do dot(g,"lerp2_"..k.."_"..i,left+q[i][1]*u,y+q[i][2]*u,"#cf8c30",4) end
 local a=b.samples[k+1];dot(g,"bezier_point_"..k,left+a[1]*u,y+a[2]*u,"#2078dc",7)
end
for k=1,60 do local a,c=b.samples[k],b.samples[k+1];traceLines[k]=line(scene,"trace_"..k,{left+a[1]*u,y+a[2]*u},{left+c[1]*u,y+c[2]*u},"#2078dc",4) end
local halves={};for i,pts in ipairs(b.split) do halves[i]=path(scene,"half_"..i,{cmds={1,3},pts=pts},right,y,u,i==1 and "#2078dc" or "#cf8c30",4) end
scene:wait(.7)
for k=1,60 do
 if k>1 and states[k-1] then scene:fade(states[k-1],0,.01) end
 if states[k] then scene:fade(states[k],1,.01) end
 scene:create(traceLines[k],.06)
 if k==30 then scene:wait(1) end
end
scene:create(halves[1],1);scene:create(halves[2],1);scene:wait(2.5)
`;
scenes['03-bounds']=`
-- Beats: true curve bounds vs control bounds; translate; intersect viewport.
local c=cases.fill;local b=cases.bounds;local u=28;local y=250
label(scene,"local","Path bounds / control bounds",100,110);label(scene,"device","Transform / viewport",1050,110)
path(scene,"bounds_local",c.path,100,y,u)
local controls=group("bounds_controls");for i=2,5 do local a=c.path.pts[i];dot(controls,"bound_pt_"..i,100+a[1]*u,y+a[2]*u,"#8858b8",5) end
local tight=box(scene,"tight",c.tight,100,y,u,"#2078dc");local hull=box(scene,"hull",c.controlBox,100,y,u,"#8858b8")
local device=group("device_path");path(device,"translated_path",c.path,1050,y,u)
local viewport=box(scene,"viewport",{0,0,trace.w,trace.h},1050,y,u,"#13877f")
local deviceHull=box(scene,"device_hull",b.controlBox,1050,y,u,"#8858b8");local renderBox=box(scene,"render_box",b.renderBox,1050,y,u,"#cf8c30")
label(scene,"hull_legend","Control bounds",100,890,26);label(scene,"tight_legend","Curve extrema",440,890,26);label(scene,"clip_legend","Render box = rounded bounds ∩ viewport",1050,890,25)
scene:wait(.7);scene:create(hull,.8);scene:wait(.7);scene:create(tight,.8);scene:wait(1)
scene:shift(device,{b.transform[3]*u,-b.transform[6]*u,0},1);scene:create(deviceHull,.7);scene:wait(.7);scene:create(renderBox,.8);scene:wait(2.5)
`;
scenes['04-path-rle']=`
-- Beats: same cubic outline; complete coverage spans; then Surface writes.
local c=cases.fill;local bases={90,720,1350};local u,y=18,290
label(scene,"outline","SwOutline",90,130);label(scene,"rle","shape.rle",720,130);label(scene,"surface","Surface",1350,130)
path(scene,"fill_outline",c.path,bases[1],y,u)
local cells=grid("fill_output",bases[3],y,u);local spans,focus={},{}
for i,s in ipairs(c.rle) do
 local g=group("fill_span_"..i,0);spans[i]=g;local gray=255-math.floor(s.coverage*195/255);local color=string.format("#%02x%02x%02x",gray,gray,gray)
 local bx=bases[2]+(s.x+.5)*u;local sy=y+(s.y+.5)*u
 rect(g,"fill_begin_"..i,bx,sy,u-2,u-2,color,"#b8c2ce");line(g,"fill_len_"..i,{bx,sy},{bx+s.len*u,sy},"#526579",2)
end
for yy=0,trace.h-1 do local g=group("fill_row_"..yy,0);focus[yy]=g;rect(g,"fill_row_cursor_"..yy,bases[2]+trace.w*u/2,y+(yy+.5)*u,trace.w*u-2,u-2,"#00000000","#cf8c30",45) end
scene:wait(.8);for _,g in ipairs(spans) do scene:fade(g,1,.045) end;scene:wait(.8)
for yy=0,trace.h-1 do scene:fade(focus[yy],1,.03);local ops={};for x=0,trace.w-1 do local at=yy*trace.stride+x;ops[#ops+1]={target=cells[at],fill=rgb(c.pixels[at+1])} end;scene:play(ops,.12);scene:fade(focus[yy],0,.03) end
scene:wait(2.5)
`;
scenes['05-stroke']=`
-- Beats: centerline; actual expanded outline; raster result; cap then join changes.
label(scene,"stroke_geometry","Centerline / stroke outline",100,120);label(scene,"surface","Surface",1050,120)
local cells=grid("stroke_output",1050,250,28);local groups,expanded={},{ };local names={"cap0","cap2","cap1","join0","join1","join2"};local labels={"Butt","Square","Round","Miter","Round","Bevel"}
for i,name in ipairs(names) do local c=cases[name];local g=group("stroke_case_"..i,i==1 and 1 or 0);groups[i]=g
 path(g,"center_"..i,c.path,100,250,28,"#8593a4",2);expanded[i]=outline(g,"expanded_"..i,c.expanded,100,250,28,"#cf8c30",3)
 label(g,"style_"..i,(i<=3 and "Cap: " or "Join: ")..labels[i],100,880,30);label(g,"width_"..i,"width = "..c.width,1050,880,28)
end
scene:wait(.5)
for i,name in ipairs(names) do if i>1 then scene:fade(groups[i-1],0,.2) end;scene:fade(groups[i],1,.6);if i==1 then scene:create(expanded[i],.8) end;scene:wait(.6);paint(cells,cases[name].pixels,.7);scene:wait(1.4) end
scene:wait(1.5)
`;
scenes['06-dash']=`
-- Beats: retained cubic; split by path length into on/gap pieces; offset changes.
local c=cases.dash0
label(scene,"path","Path / dash contours",100,120);label(scene,"surface","Surface",1050,120)
path(scene,"dash_original",c.path,100,250,28,"#c6ced8",2)
local cells=grid("dash_output",1050,250,28);local states={}
for offset=0,5 do local c=cases["dash"..offset];local g=group("dash_state_"..offset,0);states[offset]=g
 outline(g,"dash_center_"..offset,c.centerline,100,250,28,"#2078dc",6)
 label(g,"dash_pattern_"..offset,"Dash: ["..(4+trace.delta)..", 2]",100,880,28);label(g,"dash_offset_"..offset,"offset = "..offset,1050,880,28)
end
scene:wait(.7)
for offset=0,5 do if offset>0 then scene:fade(states[offset-1],0,.18) end;scene:fade(states[offset],1,.5);scene:wait(.5);paint(cells,cases["dash"..offset].pixels,.5);scene:wait(1) end
scene:wait(1.5)
`;
scenes['07-trim']=`
-- Beats: unequal subpaths; same trim percentage per contour vs total length.
label(scene,"sim_true","simultaneous = true",100,90);label(scene,"sim_false","simultaneous = false",1050,90)
local bases={100,1050};local cells={grid("trim_true",100,570,22),grid("trim_false",1050,570,22)}
for lane=1,2 do path(scene,"trim_original_"..lane,cases.trim1_4.path,bases[lane],160,22,"#c6ced8",2);label(scene,"trim_surface_"..lane,"Surface",bases[lane],530,27) end
local states={}
for e=1,4 do local g=group("trim_state_"..e,0);states[e]=g
 label(g,"end_"..e,"end = "..e*.25,800,160,26)
 outline(g,"trim_geom_true_"..e,cases["trim1_"..e].centerline,100,160,22,"#2078dc",6)
 outline(g,"trim_geom_false_"..e,cases["trim0_"..e].centerline,1050,160,22,"#2078dc",6)
end
scene:wait(.7)
for e=1,4 do if e>1 then scene:fade(states[e-1],0,.2) end;scene:fade(states[e],1,.6);scene:wait(.6);paint(cells[1],cases["trim1_"..e].pixels,.35);paint(cells[2],cases["trim0_"..e].pixels,.35);scene:wait(1.3) end
scene:wait(1.5)
`;
await fs.mkdir(path.join(dir,'../IMAGE/07-SW-Shape'),{recursive:true});
for(const [name,body]of Object.entries(scenes))await fs.writeFile(path.join(dir,'sw-shape-'+name+'.lua'),'-- Source: ./thorvg 6cf10d4; English standalone labels; no title/subtitle.\n'+common+body+'return scene\n');
await fs.writeFile(path.join(dir,'shape-scenes.txt'),JSON.stringify(Object.keys(scenes),null,2)+'\n');
