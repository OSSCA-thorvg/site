// Blog adaptations of cpu-gradient-sampling and conic-sw-fill; see README.txt.
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const common=String.raw`-- ThorVG 8c94c1f05. Educational float model, not an engine capture.
-- @standalone-pattern: ^label_.+$
-- All text is standalone on the scene background; no backing text panels.
local scene=tmath.scene{width=960,height=540,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=540}}
local function p(x,y) return {x-480,270-y} end
local function text(id,s,x,y,size,color)
 return scene:text{id="label_"..id,text=s,point=p(x,y),align={0,0.5},font="Pretendard",role="code",size=size or 25,color=color or "#202124",layer=50}
end
local function rect(id,x,y,w,h,c,stroke,layer)
 return scene:rectangle{id=id,center=p(x+w/2,y+h/2),size={w,h},fill=c,stroke=stroke or "#00000000",width=1,layer=layer or 10}
end
local function line(id,x1,y1,x2,y2,c,w)
 return scene:line{id=id,from=p(x1,y1),to=p(x2,y2),stroke=c or "#b9bec5",width=w or 2,layer=30}
end
local function dot(id,x,y,c,r)
 return scene:point{id=id,point=p(x,y),radius=r or 6,fill=c or "#202124",stroke="#ffffff",width=2,layer=40}
end
local colors={{209,55,65},{234,150,42},{24,158,164},{42,77,173}}
local offsets={0,.34,.68,1}
local function rgb(t)
 t=math.max(0,math.min(1,t)); local j=1
 while j<3 and t>offsets[j+1] do j=j+1 end
 local a=(t-offsets[j])/(offsets[j+1]-offsets[j]); local c={}
 for k=1,3 do c[k]=colors[j][k]*(1-a)+colors[j+1][k]*a end
 return c
end
local function hex(c) return string.format("#%02x%02x%02x",math.floor(c[1]+.5),math.floor(c[2]+.5),math.floor(c[3]+.5)) end
local function color(t) return hex(rgb(t)) end
local function mix(a,b,t) return {a[1]*(1-t)+b[1]*t,a[2]*(1-t)+b[2]*t,a[3]*(1-t)+b[3]*t} end
local function lut(x,y,w,h)
 local objects={}
 for i=0,127 do objects[#objects+1]=rect("lut_"..i,x+i*w/128,y,w/128+.1,h,color(i/127)) end
 text("lut0","0",x,y+h+26);text("lut1023","1023",x+w-60,y+h+26)
 return objects
end
local function wrap(t) return t-math.floor(t) end
local angle=27*math.pi/180
local function ct(x,y) return wrap(math.atan(y,x)/(2*math.pi)-angle/(2*math.pi)) end
`;
const scenes={};
scenes['01-color-table']=String.raw`
-- Beats: stops present (0); interpolate segments (1..4); lookup (5..8); hold (10).
local x,y,w=95,225,770
for i,t in ipairs(offsets) do
 dot("stop_"..i,x+t*w,125,hex(colors[i]),10)
 text("offset_"..i,string.format("%.2f",t),x+t*w-20,82)
 line("stop_link_"..i,x+t*w,141,x+t*w,y,"#b9bec5",1)
end
local cells=lut(x,y,w,52)
text("stops","ColorStop",95,36)
text("table","ctable[1024]",95,350)
scene:wait(.6)
scene:create(cells,.025,"linear",.023)
scene:wait(.7)
local first,second=.2,.73
local function lookupText(t) return string.format("t = %.2f    index = %d",t,math.floor(t*1023+.5)) end
local marker=dot("lookup",x+first*w,y+26,color(first),10)
local v=text("value",lookupText(first),380,350)
scene:fade_in(marker,{duration=.4});scene:fade_in(v,{duration=.4})
scene:remove(marker)
scene:remove(v)
local marker2=dot("lookup2",x+second*w,y+26,color(second),10)
text("value2",lookupText(second),380,350)
scene:fade_in(marker2,{duration=.6})
scene:wait(2)
`;
scenes['02-linear']=String.raw`
-- Beats: axis/field; one sample; normal projection; t to LUT; second sample.
local x1,y1,x2,y2=150,300,710,160
local dx,dy=x2-x1,y2-y1;local dd=dx*dx+dy*dy
for y=0,13 do for x=0,35 do
 local px,py=90+x*21,105+y*17
 rect("field_"..x.."_"..y,px,py,21,17,color(((px-x1)*dx+(py-y1)*dy)/dd))
end end
line("axis",x1,y1,x2,y2,"#202124",3);dot("p1",x1,y1);dot("p2",x2,y2)
text("p1","P1",115,345);text("p2","P2",724,146)
local px,py=430,145
local t=((px-x1)*dx+(py-y1)*dy)/dd; local qx,qy=x1+t*dx,y1+t*dy
local sample=dot("sample",px,py,"#ffffff",9)
text("p","P",px-10,py-28)
local proj=line("projection",px,py,qx,qy,"#ffffff",3)
local q=dot("q",qx,qy,color(t),8)
local bar=lut(120,421,720,26)
local pick=dot("pick",120+t*720,434,"#202124",8)
local value=text("value",string.format("t = dot(P - P1, d) / dot(d, d) = %.3f",t),120,385,24)
scene:wait(.8);scene:create(proj,1);scene:fade_in(q,{duration=.4})
scene:fade_in(value,{duration=.5});scene:fade_in(pick,{duration=.5});scene:wait(1)
-- Move P perpendicular to d: projection and t must remain fixed.
local px2,py2=px-dy*.3,py+dx*.3
local sample2=dot("sample2",px2,py2,"#ffffff",9)
local proj2=line("projection2",px2,py2,qx,qy,"#ffffff",3)
scene:fade_in(sample2,{duration=.6});scene:create(proj2,1.2)
scene:wait(2)
`;
scenes['03-radial']=String.raw`
-- Concentric, zero focal-radius variant of _prepareRadial/_calculateCoefficients.
-- Beats: center/outer circle; nested t circles; sample radius; lookup; hold.
local cx,cy,r=290,252,177
for i=96,1,-1 do
 scene:circle{id="field_"..i,center=p(cx,cy),radius=r*i/96,fill=color(i/96),stroke="#00000000",layer=10}
end
local rings={}
for i=1,4 do rings[i]=scene:circle{id="ring_"..i,center=p(cx,cy),radius=r*i/4,fill="#00000000",stroke="#ffffff",width=2,layer=30} end
local outer=scene:circle{id="outer",center=p(cx,cy),radius=r,fill="#00000000",stroke="#202124",width=2,layer=30}
dot("center",cx,cy);text("center","C = F",cx-32,cy+35)
text("variant","F = C    fr = 0",545,100)
local px,py=cx+r*.6,cy-r*.3
local t=math.sqrt((px-cx)^2+(py-cy)^2)/r
local ray=line("radius",cx,cy,px,py,"#202124",3);local sample=dot("sample",px,py,color(t),9)
local val=text("value",string.format("t = |P - C| / r = %.3f",t),545,205,24)
text("radius","r",cx+r+15,cy)
local objects=lut(545,295,305,40)
local pick=dot("pick",545+t*305,315,"#202124",9)
scene:wait(.6);scene:create(rings,.45,"linear",.4);scene:create(ray,1)
scene:fade_in(sample,{duration=.35});scene:fade_in(val,{duration=.5});scene:fade_in(pick,{duration=.5});scene:wait(2)
`;
scenes['04-shape-rle']=String.raw`
-- Circle coverage is an 8x8 illustrative model; RLE records are derived from it.
-- Beats: Shape contour; coverage field; selected span; inner x-loop; all spans; final buffer.
local cols,rows=24,18
local cx,cy,r=11.3,8.8,7.7
local runs={};local coverage={}
for y=0,rows-1 do
 coverage[y]={};local run=nil
 for x=0,cols-1 do
  local hits=0
  for sy=0,7 do for sx=0,7 do
   if (x+(sx+.5)/8-cx)^2+(y+(sy+.5)/8-cy)^2<r*r then hits=hits+1 end
  end end
  local a=math.floor(hits/64*255+.5);coverage[y][x]=a
  if a>0 then
   if run and run.coverage==a and run.x+run.len==x then run.len=run.len+1
   else run={x=x,y=y,len=1,coverage=a};runs[#runs+1]=run end
  else run=nil end
 end
end
local ox,oy,s=60,76,21
local outline=scene:circle{id="shape",center=p(ox+cx*s,oy+cy*s),radius=r*s,fill="#00000000",stroke="#202124",width=2,layer=35}
text("shape","Shape",65,36);text("array","SwSpan { x, y, len, coverage }",565,90,20)
local bases,filled={},{}
for y=0,rows-1 do for x=0,cols-1 do
 local a=coverage[y][x]/255
 bases[#bases+1]=rect("base_"..x.."_"..y,ox+x*s,oy+y*s,s-1,s-1,hex(mix({255,255,255},{165,169,176},a)))
 filled[y*cols+x]=rect("pixel_"..x.."_"..y,ox+x*s,oy+y*s,s-1,s-1,hex(mix({255,255,255},rgb((x+.5-3)/17),a)),nil,20)
end end
-- Pre-hide via scheduled entrance; no false complete buffer at t=0.
scene:wait(.7);scene:create(bases,.05,"linear",.001);scene:wait(.5)
local lastlabel=nil
for j,span in ipairs(runs) do
 if lastlabel then scene:remove(lastlabel) end
 lastlabel=text("run_"..j,string.format("[%d]  %d, %d, %d, %d",j-1,span.x,span.y,span.len,span.coverage),590,150,23)
 local active=rect("active_"..j,ox+span.x*s,oy+span.y*s,span.len*s,s,"#00000000","#9b3600",40)
 local trace=text("loop_"..j,"i < len    ++dst",590,219,23)
 local array={}
 for x=span.x,span.x+span.len-1 do array[#array+1]=filled[span.y*cols+x] end
 local slow=span.y==5 and span.len>3
 if slow then
  scene:remove(trace)
  for k,obj in ipairs(array) do
   local pixelLabel=text("pixelstep_"..j.."_"..k,string.format("i = %d    x = %d",k-1,span.x+k-1),590,219,23)
   scene:create(obj,.18);scene:wait(.18);scene:remove(pixelLabel)
  end
  scene:wait(.7)
 else scene:create(array,.035,"linear",.01);scene:remove(trace) end
 scene:remove(active)
end
-- Pixels outside Shape stay background; unvisited objects must never paint.
for y=0,rows-1 do for x=0,cols-1 do if coverage[y][x]==0 then scene:remove(filled[y*cols+x]) end end end
text("dst","dst = buf + y * stride + x",590,300,22)
text("count",string.format("%d spans",#runs),590,355)
scene:wait(2)
`;
scenes['05-conic']=String.raw`
-- Derived from _conicT. Screen coordinates: Y down, angle measured clockwise.
-- Beats: conic ring; sample on seam side; rotate sample; LUT wrap; final pair.
local cx,cy,r=280,245,170
for i=0,179 do
 local a=angle+2*math.pi*i/180;local b=angle+2*math.pi*(i+1)/180
 scene:polygon{id="sector_"..i,points={p(cx,cy),p(cx+r*math.cos(a),cy+r*math.sin(a)),p(cx+r*math.cos(b),cy+r*math.sin(b))},fill=color(i/179),stroke=color(i/179),width=1,layer=10}
end
local sx,sy=math.cos(angle),math.sin(angle)
line("seam",cx,cy,cx+(r+25)*sx,cy+(r+25)*sy,"#202124",3)
dot("center",cx,cy);text("center","C",cx-28,cy)
text("seam","seam",cx+(r+30)*sx,cy+(r+30)*sy,23)
text("formula","atan2(ry, rx) / 2pi",535,108,25)
text("offset","- angle / 360",535,151,25)
text("wrap","t - floor(t)",535,205,25)
lut(535,306,315,38)
local ray,mark,pick,label
for j,t in ipairs({.12,.38,.72,.97,.02}) do
 if ray then scene:remove(ray);scene:remove(mark);scene:remove(pick);scene:remove(label) end
 local a=angle+t*2*math.pi;local px,py=cx+r*.8*math.cos(a),cy+r*.8*math.sin(a)
 ray=line("ray_"..j,cx,cy,px,py,"#ffffff",3);mark=dot("sample_"..j,px,py,color(t),9)
 pick=dot("lookup_"..j,535+t*315,325,"#202124",9)
 label=text("t_"..j,string.format("t = %.2f   LUT[%d]",t,math.floor(t*1023+.5)),535,425,25)
 scene:wait(j==4 and 1.5 or 1.2)
end
scene:wait(1)
`;
scenes['06-aa-width']=String.raw`
-- Fixed angular interval vs screen-space band. Geometric proof, not blur capture.
-- Beats: seam; fixed angular wedge; radii measured; fixed-width band; hold comparison.
local cx,cy=95,400
local seamAngle,halfAngle=-.5,.09
local sx,sy=math.cos(seamAngle),math.sin(seamAngle)
text("angular","LUT: fixed dt",80,45);text("screen","SW: pixel footprint",535,45)
local wedges={}
for panel=0,1 do
 local ox=panel*455
 line("seam_"..panel,cx+ox,cy,cx+ox+340*sx,cy+340*sy,"#202124",2)
 dot("center_"..panel,cx+ox,cy)
 if panel==0 then
  local a,b=seamAngle-halfAngle,seamAngle+halfAngle
  wedges[#wedges+1]=scene:polygon{id="wedge",points={p(cx,cy),p(cx+355*math.cos(a),cy+355*math.sin(a)),p(cx+355*math.cos(b),cy+355*math.sin(b))},fill="#d1374140",stroke="#d13741",width=1,layer=15}
 else
  local nx,ny=-sy,sx;local h=9
  wedges[#wedges+1]=scene:polygon{id="band",points={p(cx+ox+nx*h,cy+ny*h),p(cx+ox+sx*355+nx*h,cy+sy*355+ny*h),p(cx+ox+sx*355-nx*h,cy+sy*355-ny*h),p(cx+ox-nx*h,cy-ny*h)},fill="#189ea440",stroke="#189ea4",width=1,layer=15}
 end
end
scene:wait(.7);scene:create(wedges[1],1)
local ms={}
for j,r in ipairs({105,300}) do
 local x,y=cx+r*sx,cy+r*sy;local h=r*math.tan(halfAngle)
 ms[#ms+1]=line("width_"..j,x+sy*h,y-sx*h,x-sy*h,y+sx*h,"#d13741",4)
 local v=text("width_"..j,string.format("%.0f",2*h),x-15,y-58,24,"#a62730")
 scene:fade_in(v,{duration=.4})
end
scene:create(ms,.5,"linear",.3)
local relation=text("relation","width ~ r * 2pi * dt",75,475,25)
scene:fade_in(relation,{duration=.6});scene:create(wedges[2],1)
text("pixel","|dot(n, q - C)| / fwidth < 0.5",520,475,22)
scene:wait(2.5)
`;
scenes['07-fwidth']=String.raw`
-- Identity inverse transform. An enlarged one-screen-pixel footprint, not a circle.
-- Beats: square; normal; projections of x/y steps; sum; band comparison.
local ox,oy,step=185,155,175
local nx,ny=-math.sin(angle),math.cos(angle)
local square=rect("pixel",ox,oy,step,step,"#f0f1f2","#b9bec5")
text("pixel","1 screen pixel",145,80)
line("xstep",ox,oy,ox+step,oy,"#d13741",4)
line("ystep",ox,oy,ox,oy+step,"#2a4dad",4)
text("x","xStep",300,128,23,"#a62730");text("y","yStep",90,245,23,"#2a4dad")
local cx,cy=ox+step/2,oy+step/2
local normal=line("normal",cx,cy,cx+nx*190,cy+ny*190,"#202124",3)
text("n","n",cx+nx*200-16,cy+ny*200,25)
local dfdx,dfdy=nx,ny;local fw=math.abs(dfdx)+math.abs(dfdy)
local segments={}
segments[1]=rect("dx",545,175,math.abs(dfdx)*200,25,"#d13741")
segments[2]=rect("dy",545+math.abs(dfdx)*200,175,math.abs(dfdy)*200,25,"#2a4dad")
local a=text("dx",string.format("|dot(n, xStep)| = %.3f",math.abs(dfdx)),525,255,24)
local b=text("dy",string.format("|dot(n, yStep)| = %.3f",math.abs(dfdy)),525,302,24)
local sum=text("sum",string.format("fwidth = %.3f",fw),525,384,25)
scene:wait(.7);scene:create(normal,.8);scene:create(segments[1],.8);scene:fade_in(a,{duration=.4})
scene:create(segments[2],.8);scene:fade_in(b,{duration=.4});scene:fade_in(sum,{duration=.6});scene:wait(2)
`;
scenes['08-aa-range']=String.raw`
-- _conicAARange: intersect normal-distance band, forward half-plane and span.
-- Enlarged 24x14 screen-pixel field; normalized band computed at pixel centers.
-- Beats: conic field; infinite band; ray gate; scanline; eligible samples; endpoint mix.
local cols,rows=24,14;local cx,cy=7.3,4.2;local s=25;local ox,oy=65,88
local nx,ny=-math.sin(angle),math.cos(angle);local sx,sy=ny,-nx
local fw=math.abs(nx)+math.abs(ny);local row=9;local selected={}
for y=0,rows-1 do for x=0,cols-1 do
 local rx,ry=x+.5-cx,y+.5-cy
 local d=(nx*rx+ny*ry)/fw;local f=rx*sx+ry*sy
 rect("pixel_"..x.."_"..y,ox+x*s,oy+y*s,s-1,s-1,color(ct(rx,ry)))
 if math.abs(d)<.5 then
  local gate=rect("gate_"..x.."_"..y,ox+x*s,oy+y*s,s-1,s-1,"#ffffff99","#202124",25)
  if f<0 then selected[#selected+1]={obj=gate,back=true}
  elseif y==row then selected[#selected+1]={obj=gate,x=x,d=d} end
 end
end end
local cpx,cpy=ox+cx*s,oy+cy*s
dot("center",cpx,cpy);text("center","C",cpx-30,cpy-20)
line("seam",cpx,cpy,cpx+450*sx,cpy+450*sy,"#202124",2)
local scan=line("scan",ox,oy+(row+.5)*s,ox+cols*s,oy+(row+.5)*s,"#9b3600",3)
text("scan","y = "..row,720,100)
text("band","-0.5 < d < 0.5",705,170,22)
text("ray","dot(q-C,s) >= 0",705,211,22)
scene:wait(.9)
for _,v in ipairs(selected) do if v.back then scene:fade_out(v.obj,{duration=.12}) end end
scene:create(scan,1)
local first,last=nil,nil
for _,v in ipairs(selected) do if v.x then
 first=first or v.x;last=v.x+1
 local c=hex(mix(colors[4],colors[1],v.d+.5))
 scene:fill(v.obj,c,.55)
 local out=rect("result_"..v.x,ox+v.x*s,oy+rows*s+30,s-1,35,c)
 scene:fade_in(out,{duration=.45})
end end
text("range",string.format("[%d, %d)",first,last),720,300,25)
text("begin","begin",ox+first*s-28,oy+rows*s+73,22)
text("end","end",ox+last*s+12,oy+rows*s+73,22)
scene:wait(2)
`;
for (const [name,body] of Object.entries(scenes)) await fs.writeFile(path.join(dir,name+'.lua'),common+body+'\nreturn scene\n');
console.log(`Wrote ${Object.keys(scenes).length} scenes`);
