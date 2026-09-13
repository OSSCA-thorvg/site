// Standalone Lua scenes. Rebuild texmap-trace.json with trace-texmap.mjs first.
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import assert from 'node:assert/strict';
import {source,sample,point,texColor} from './bitmap-model.mjs';
const dir=path.dirname(fileURLToPath(import.meta.url));
const trace=JSON.parse(await fs.readFile(path.join(dir,'texmap-trace.json'),'utf8'));
const lua=v=>Array.isArray(v)?'{'+v.map(lua).join(',')+'}':JSON.stringify(v);
const common=`-- ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b.
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
local inputs8=${lua(Array.from({length:64},(_,i)=>source(8,i%8,Math.floor(i/8))))}
local inputs24=${lua(Array.from({length:576},(_,i)=>source(24,i%24,Math.floor(i/24))))}
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
`;
const direct=`
local sx,sy,dx,dy,k=96,190,700,140,28
text("Source",sx,125);text("Target",dx,95)
grid(sx,sy,8,8,k,function(x,y)return hex(rgb(8,x,y))end)
grid(dx,dy,12,10,k,function()return "#edf0f2"end)
local rows,marks={},{}
for y=0,7 do
 rows[y+1]=grid(sx,sy+y*k,8,1,k,function(x)return hex(rgb(8,x,y))end)
 marks[y+1]=outline(sx,sy+y*k,8*k,k)
end
s:wait(.7)
for y=0,7 do
 s:fade_in(marks[y+1],{duration=.12});s:fade_in(rows[y+1],{duration=.1})
 s:shift(rows[y+1],{dx+2*k-sx,sy-(dy+k)},y<2 and .9 or .45,"ease_in_out")
 s:fade_out(marks[y+1],{duration=.12})
end
s:wait(2)
`;
const scaling=mode=>`
local mode="${mode}"
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
`;
const texmap=`
local trace=${lua(trace.map(([t,x,y,u,v])=>[t,x,y,u,v,texColor(u,v)]))}
local sx,sy,sk,tx,ty,tk=80,185,36,700,120,12
text("UV",sx,110);text("XY",tx,65)
grid(sx,sy,8,8,sk,function(x,y)return hex(rgb(8,x,y))end)
grid(tx,ty,36,36,tk,function()return "#edf0f2"end)
local angle=25*math.pi/180;local co,si=math.cos(angle),math.sin(angle)
local uv={{0,0},{8,0},{8,8},{0,8}}
local xy={}
for i,v in ipairs(uv) do xy[i]={18+3*(co*(v[1]-4)-si*(v[2]-4)),18+3*(si*(v[1]-4)+co*(v[2]-4))} end
local function uvp(i)return sx+uv[i][1]*sk,sy+uv[i][2]*sk end
local function xyp(i)return tx+xy[i][1]*tk,ty+xy[i][2]*tk end
local proxy=s:group{id="quad",matrix=matrix(sx+4*sk,sy+4*sk,sk)}
proxy:rectangle{id="quad_outline",center={0,0},size={8,8},fill="#00000000",stroke="#202124",width=2,layer=40}
s:wait(.6)
s:transform(proxy,{3*tk*co,3*tk*si,0,tx+18*tk-W/2, -3*tk*si,3*tk*co,0,H/2-ty-18*tk, 0,0,1,0, 0,0,0,1},1.4,"ease_in_out")
local ux1,uy1=uvp(2);local ux2,uy2=uvp(4)
local xx1,xy1=xyp(2);local xx2,xy2=xyp(4)
local ud=line(ux1,uy1,ux2,uy2);local xd=line(xx1,xy1,xx2,xy2)
s:create(ud,.5);s:create(xd,.5);s:wait(.5)
local triangles={{1,2,4},{2,3,4}}
for tri,indices in ipairs(triangles) do
 local focus=s:group{id="triangle_focus_"..tri}
 local srcPts,dstPts={},{}
 for _,i in ipairs(indices) do
  local ux,uy=uvp(i);local xx,yy=xyp(i)
  srcPts[#srcPts+1]=p(ux,uy);dstPts[#dstPts+1]=p(xx,yy)
  dot(ux,uy,focus,7);dot(xx,yy,focus,7)
 end
 focus:polygon{id=id("uv_triangle"),points=srcPts,fill="#20816b18",stroke="#20816b",width=3,layer=30}
 focus:polygon{id=id("xy_triangle"),points=dstPts,fill="#20816b10",stroke="#20816b",width=3,layer=30}
 s:fade_in(focus,{duration=.3})
 -- Three corner pairs define the affine UV field; show those exact correspondences.
 for _,i in ipairs(indices) do
  local ux,uy=uvp(i);local xx,yy=xyp(i)
  local link=line(ux,uy,xx,yy,nil,"#20816b",1)
  s:create(link,.3);s:wait(.1);s:fade_out(link,{duration=.15})
 end
 local rows={};local order={}
 for _,rec in ipairs(trace) do if rec[1]==tri-1 then
  local y=rec[3]
  if not rows[y] then rows[y]={};order[#order+1]=y end
  rows[y][#rows[y]+1]=rec
 end end
 for ri,y in ipairs(order) do
  local records=rows[y];local first,last=records[1],records[#records]
  local g=s:group{id=id("scanline")}
  local a=first[2];local count=last[2]-a+1;local colors={}
  for _,r in ipairs(records) do colors[r[2]]=hex(r[6]) end
  grid(tx+a*tk,ty+y*tk,count,1,tk,function(x)return colors[a+x] or "#00000000"end,g)
  local destLine=line(tx+(a+.5)*tk,ty+(y+.5)*tk,tx+(last[2]+.5)*tk,ty+(y+.5)*tk)
  local sourceLine=line(sx+first[4]*sk,sy+first[5]*sk,sx+last[4]*sk,sy+last[5]*sk)
  s:create(destLine,.055);s:create(sourceLine,.055)
  if ri==math.floor(#order/2) then
   local aDot=dot(tx+(a+.5)*tk,ty+(y+.5)*tk)
   local bDot=dot(sx+first[4]*sk,sy+first[5]*sk)
   s:fade_in(aDot,{duration=.1});s:fade_in(bDot,{duration=.1})
   s:play({{target=aDot,shift={(last[2]-a)*tk,0}},
           {target=bDot,shift={(last[4]-first[4])*sk,-(last[5]-first[5])*sk}}},1.1,"linear")
   s:fade_out(aDot,{duration=.1});s:fade_out(bDot,{duration=.1})
  end
  s:fade_in(g,{duration=.07})
  s:fade_out(destLine,{duration=.045});s:fade_out(sourceLine,{duration=.045})
 end
 s:fade_out(focus,{duration=.3});s:wait(tri==1 and 1.2 or .5)
end
s:wait(2)
`;
for(const [name,body] of Object.entries({'01-direct':direct,'02-nearest':scaling('nearest'),'03-bilinear':scaling('bilinear'),'04-downscale':scaling('mean'),'05-texmap':texmap}))await fs.writeFile(path.join(dir,name+'.lua'),common+body+'\nreturn s\n');
// Independent endpoints, asymmetric input changes, and no duplicate triangle writes.
assert.notDeepEqual(point(7,7,2),point(7,7,3));
assert.deepEqual(sample(8,7,7,2,'nearest'),source(8,3,3));
assert.notDeepEqual(sample(8,8,7,2,'bilinear'),sample(8,8,7,3,'bilinear'));
const seen=new Set();for(const [,x,y] of trace){assert.ok(!seen.has(x+','+y));seen.add(x+','+y);}
console.log('Built five source-to-target scenes; scale and triangle invariants passed.');
