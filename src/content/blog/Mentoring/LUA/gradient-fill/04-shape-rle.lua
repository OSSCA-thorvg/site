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

return scene
