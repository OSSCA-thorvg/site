-- ThorVG 8c94c1f05. Educational float model, not an engine capture.
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

return scene
