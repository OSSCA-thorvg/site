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

return scene
