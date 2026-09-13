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

return scene
