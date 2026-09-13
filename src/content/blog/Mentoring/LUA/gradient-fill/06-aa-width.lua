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

return scene
