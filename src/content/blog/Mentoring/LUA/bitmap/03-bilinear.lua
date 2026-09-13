-- ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b.
-- All label_* Text is standalone. Fixed Y-up camera, screen plan converted by p().
local W,H=1280,720
local s=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local counter=0
local function id(prefix) counter=counter+1;return prefix.."_"..counter end
local function p(x,y) return {x-W/2,H/2-y} end
local function text(value,x,y,parent)
 return (parent or s):text{id=id("label"),text=value,point=p(x,y),font="Pretendard",role="text",size=25,align={0,.5},color="#30373d",layer=60}
end
local function line(x,y,x2,y2,parent,color,width)
 return (parent or s):line{id=id("line"),from=p(x,y),to=p(x2,y2),stroke=color or "#67727b",width=width or 2,layer=40}
end
local function dot(x,y,parent,r,color)
 return (parent or s):point{id=id("point"),point=p(x,y),radius=r or 6,fill=color or "#202124",stroke="#fff",width=2,layer=50}
end
local function outline(x,y,w,h,parent,color)
 return (parent or s):rectangle{id=id("outline"),center=p(x+w/2,y+h/2),size={w,h},fill="#00000000",stroke=color or "#202124",width=2,layer=45}
end
local function matrix(x,y,w,h) return {w,0,0,x-W/2, 0,h or w,0,H/2-y, 0,0,1,0, 0,0,0,1} end
local function tile(x,y,w,h,color,parent)
 local g=(parent or s):group{id=id("tile"),matrix=matrix(x,y,w,h)}
 g:rectangle{id=id("color"),center={0,0},size={1,1},fill=color,stroke="#00000000",layer=35}
 return g
end
local function hex(c) return string.format("#%02x%02x%02x",c[1],c[2],c[3]) end
local inputs8={{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{235,174,65},{235,174,65},{82,141,177},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{235,174,65},{235,174,65},{87,145,180},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{38,126,108},{38,126,108},{92,149,182},{97,152,185},{97,152,185},{97,152,185},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{102,156,187},{102,156,187},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109}}
local inputs24={{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{75,136,174},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{77,137,175},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{79,139,176},{79,139,176},{79,139,176},{79,139,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{80,140,176},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{80,140,176},{80,140,176},{80,140,176},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{82,141,177},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{82,141,177},{82,141,177},{82,141,177},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{84,142,178},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{84,142,178},{84,142,178},{84,142,178},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{85,144,179},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{85,144,179},{85,144,179},{85,144,179},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{87,145,180},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{87,145,180},{87,145,180},{87,145,180},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{235,174,65},{89,146,181},{89,146,181},{89,146,181},{89,146,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{38,126,108},{38,126,108},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{90,147,181},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{92,149,182},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{92,149,182},{92,149,182},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{94,150,183},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{94,150,183},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{95,151,184},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{97,152,185},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{99,154,186},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{100,155,186},{100,155,186},{100,155,186},{100,155,186},{100,155,186},{100,155,186},{100,155,186},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{102,156,187},{102,156,187},{102,156,187},{102,156,187},{102,156,187},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{32,67,109},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{38,126,108},{56,91,133},{38,126,108},{62,150,132},{38,126,108},{62,150,132},{38,126,108},{62,150,132},{38,126,108},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{62,150,132},{38,126,108},{62,150,132},{38,126,108},{32,67,109},{56,91,133},{32,67,109},{62,150,132},{38,126,108},{62,150,132},{38,126,108},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{62,150,132},{38,126,108},{62,150,132},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109},{56,91,133},{32,67,109}}
local function rgb(n,x,y) return (n==8 and inputs8 or inputs24)[y*n+x+1] end
local function grid(x,y,cols,rows,k,fn,parent)
 local patches={}
 for row=0,rows-1 do for col=0,cols-1 do patches[#patches+1]={region={col,rows-1-row,1,1},color=fn(col,row)} end end
 local g=(parent or s):group{id=id("field"),matrix=matrix(x+cols*k/2,y+rows*k/2,k)}
 g:cell{id=id("cells"),origin={-cols/2,-rows/2},size={cols,rows},patches=patches,mode="padd",padding=.018,layer=10}
 return g
end
local function trunc(v) return v<0 and math.ceil(v) or math.floor(v) end
local function interp(a,b,w)
 return {math.floor(b[1]+(a[1]-b[1])*w/256),math.floor(b[2]+(a[2]-b[2])*w/256),math.floor(b[3]+(a[3]-b[3])*w/256)}
end
local function sampling(n,x,y,scale,mode)
 local u,v=x/scale-.49,y/scale-.49
 local rx,ry=math.max(0,trunc(u)),math.max(0,trunc(v))
 local values={};local color
 if mode=="nearest" then values={{rx,ry,1}};color=rgb(n,rx,ry)
 elseif mode=="bilinear" then
  local xx,yy=math.min(n-1,rx+1),math.min(n-1,ry+1)
  local dx=u>0 and math.floor((u-rx)*255) or 0
  local dy=v>0 and math.floor((v-ry)*255) or 0
  local a,b=dx/256,dy/256
  values={{rx,ry,(1-a)*(1-b)},{xx,ry,a*(1-b)},{rx,yy,(1-a)*b},{xx,yy,a*b}}
  color=interp(interp(rgb(n,xx,yy),rgb(n,rx,yy),dx),interp(rgb(n,xx,ry),rgb(n,rx,ry),dx),dy)
 else
  local radius=math.max(1,math.floor(.5/scale));local inc=math.floor(radius/2)+1
  local my=math.floor(v+.5)
  for yy=math.max(0,my-radius),math.min(n-1,my+radius-1),inc do
   for xx=math.max(0,trunc(u)-radius),math.min(n-1,trunc(u)+radius-1),inc do values[#values+1]={xx,yy,1} end
  end
  color={0,0,0}
  for _,q in ipairs(values) do q[3]=1/#values;local c=rgb(n,q[1],q[2]);for ch=1,3 do color[ch]=color[ch]+c[ch] end end
  for ch=1,3 do color[ch]=math.floor(color[ch]/#values) end
 end
 return {u=u,v=v,color=color,values=values}
end

local mode="bilinear"
local n=mode=="mean" and 24 or 8
local sx,sy,sk=80,170,mode=="mean" and 14 or 36
local tx,ty,tk=700,132,mode=="mean" and 36 or 18
text(string.format("Source  %d x %d",n,n),sx,110);text("Target",tx,62)
grid(sx,sy,n,n,sk,function(x,y)return hex(rgb(n,x,y))end)
local scales=mode=="mean" and {1/3,1/6} or {2,3}
local testx,testy=mode=="mean" and 2 or 10,mode=="mean" and 2 or 6
local start=sampling(n,testx,testy,scales[1],mode)
local lastS={sx+(start.u+.5)*sk,sy+(start.v+.5)*sk}
local lastT={tx+(testx+.5)*tk,ty+(testy+.5)*tk}
local sp=s:point{id="source_sample",point=p(lastS[1],lastS[2]),radius=6,fill="#202124",stroke="#fff",width=2,layer=50}
local dp=s:rectangle{id="target_sample",center=p(lastT[1],lastT[2]),size={tk,tk},fill="#00000000",stroke="#202124",width=2,layer=45}
local function cursors(x,y,scale,duration)
 local q=sampling(n,x,y,scale,mode)
 local ps={sx+(q.u+.5)*sk,sy+(q.v+.5)*sk};local pt={tx+(x+.5)*tk,ty+(y+.5)*tk}
 s:play({{target=sp,shift={ps[1]-lastS[1],-(ps[2]-lastS[2])}},
         {target=dp,shift={pt[1]-lastT[1],-(pt[2]-lastT[2])}}},duration,"linear")
 lastS,lastT=ps,pt;return q
end
local function transfer(x,y,scale,parent)
 local q=cursors(x,y,scale,.35)
 local marks=s:group{id=id("footprint")};local minx,miny,maxx,maxy=n,n,0,0
 for _,v in ipairs(q.values) do
  minx=math.min(minx,v[1]);miny=math.min(miny,v[2]);maxx=math.max(maxx,v[1]);maxy=math.max(maxy,v[2])
  outline(sx+v[1]*sk,sy+v[2]*sk,sk,sk,marks,"#ffffff")
  if mode=="bilinear" then dot(sx+(v[1]+.5)*sk,sy+(v[2]+.5)*sk,marks,2+9*math.sqrt(v[3]),hex(rgb(n,v[1],v[2]))) end
 end
 if mode=="mean" then
  local r=math.max(1,math.floor(.5/scale));local my=math.floor(q.v+.5)
  minx=math.max(0,trunc(q.u)-r);miny=math.max(0,my-r)
  maxx=math.min(n,trunc(q.u)+r)-1;maxy=math.min(n,my+r)-1
 end
 outline(sx+minx*sk,sy+miny*sk,(maxx-minx+1)*sk,(maxy-miny+1)*sk,marks)
 s:fade_in(marks,{duration=.2})
 if mode=="nearest" then
  local v=q.values[1];local copy=tile(sx+(v[1]+.5)*sk,sy+(v[2]+.5)*sk,sk*.8,sk*.8,hex(q.color),parent)
  s:fade_in(copy,{duration=.1});s:transform(copy,matrix(lastT[1],lastT[2],tk*.96),.6,"ease_in_out")
 else
  local pieces=s:group{id=id("contributions")};local clips={};local sum=0
  for _,v in ipairs(q.values) do
   local copy=tile(sx+(v[1]+.5)*sk,sy+(v[2]+.5)*sk,sk*.7,sk*.7,hex(rgb(n,v[1],v[2])),pieces)
   local w=64*v[3]
   clips[#clips+1]={target=copy,transform=matrix(505+sum+w/2,565,math.max(.01,w),64)};sum=sum+w
  end
  s:fade_in(pieces,{duration=.12});s:play(clips,.55,"ease_in_out")
  local mixed=tile(537,565,64,64,hex(q.color),parent)
  s:fade_in(mixed,{duration=.3});s:fade_out(pieces,{duration=.1})
  s:transform(mixed,matrix(lastT[1],lastT[2],tk*.96),.55,"ease_in_out")
 end
 s:fade_out(marks,{duration=.15})
end
local previous
s:wait(.7);s:fade_in(sp,{duration=.2});s:fade_in(dp,{duration=.2})
for phase,scale in ipairs(scales) do
 local out=math.floor(n*scale+.5)
 local owner=s:group{id="phase_"..phase}
 grid(tx,ty,out,out,tk,function()return "#edf0f2"end,owner)
 text((mode=="mean" and (phase==1 and "Scale 1/3" or "Scale 1/6") or (phase==1 and "Scale 2x" or "Scale 3x"))..string.format("  /  %d x %d",out,out),tx,103,owner)
 if previous then
  cursors(testx,testy,scales[phase-1],.3)
  s:fade_out(previous,{duration=.3})
  local old=math.floor(n*scales[phase-1]+.5)*tk
  local box=s:group{id=id("resize"),matrix=matrix(tx+old/2,ty+old/2,old)}
  box:rectangle{id=id("resize_border"),center={0,0},size={1,1},fill="#00000000",stroke="#89939c",width=2,layer=20}
  s:fade_in(box,{duration=.1})
  for frame=1,30 do
   local a=frame/30;local k=scales[phase-1]+(scale-scales[phase-1])*a
   local q=sampling(n,testx,testy,k,mode)
   local ps={sx+(q.u+.5)*sk,sy+(q.v+.5)*sk};local width=n*k*tk
   s:play({{target=box,transform=matrix(tx+width/2,ty+width/2,width)},
           {target=sp,shift={ps[1]-lastS[1],-(ps[2]-lastS[2])}}},1/30,"linear")
   lastS=ps
  end
  s:fade_out(box,{duration=.1});s:fade_in(owner,{duration=.3})
 end
 for j=0,(mode=="mean" and phase==2) and 1 or 2 do transfer(testx+j,testy,scale,owner) end
 local rows={}
 for y=0,out-1 do rows[y+1]=grid(tx,ty+y*tk,out,1,tk,function(x)return hex(sampling(n,x,y,scale,mode).color)end,owner) end
 for _,row in ipairs(rows) do s:fade_in(row,{duration=1.6/out}) end
 s:wait(1);previous=owner
end
s:fade_out(sp,{duration=.2});s:fade_out(dp,{duration=.2});s:wait(2)

return s
