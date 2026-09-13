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

return scene
