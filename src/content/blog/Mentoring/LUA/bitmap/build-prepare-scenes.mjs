// Four short, deterministic scenes grounded in ThorVG 6cf10d4.
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
// Reuse the established scene primitives, without executing the other generator.
const existing=await fs.readFile(path.join(dir,'01-direct.lua'),'utf8');
const common=existing.slice(0,existing.indexOf('\nlocal sx,sy,dx,dy,k=')).replace('local counter=0','local stage\nlocal counter=0').replaceAll('(parent or s)', '(parent or stage or s)');
const scenes={
 '06-colorspace':`
stage=s:group{id="shared_intro"}
text("Memory",130,245)
local readerLabel=text("Renderer",130,505)
local channels={"R","G","B","A"}
local colors={"#dd654f","#60a777","#537eb8","#939eaa"}
local readers={}
for i,ch in ipairs(channels) do
 local x=450+(i-1)*140
 text(ch,x-8,185)
 tile(x,245,96,50,colors[i])
 local reader=stage:group{id="reader_"..ch}
 outline(x-54,475,108,60,reader)
 text(ch,x-8,555,reader)
 readers[#readers+1]={target=reader,shift={0,260}}
end
readers[#readers+1]={target=readerLabel,shift={0,200}}
s:wait(1)
s:play(readers,1.5,"ease_in_out")
local shared=text("Same buffer",580,425);s:fade_in(shared,{duration=.3});s:wait(1.5)
s:fade_out(stage,{duration=.4})
stage=s:group{id="swap_stage"};s:fade_in(stage,{duration=.3})

text("ABGR8888",100,95);text("ARGB8888",790,95)
local src=grid(100,160,8,8,23,function(x,y)return hex(rgb(8,x,y))end)
local dst=grid(790,160,8,8,23,function(x,y)return hex(rgb(8,x,y))end)
local c={200,100,40,255};local colors={"#c86428","#64a264","#4678cf","#9ba5ae"}
text("Little-endian",100,405)
local bytes={}
for i,name in ipairs({"R","G","B","A"}) do
 local g=stage:group{id="byte_"..name};bytes[i]=g
 tile(130+(i-1)*145,575,100,30,colors[i],g)
 text(name.." "..tostring(c[i]),90+(i-1)*145,525,g)
end
local old=text("0xFF2864C8",100,680)
local new=text("0xFFC86428",790,680)
s:wait(1)
-- Both byte owners travel in separate lanes before exchanging occupied slots.
s:play({{target=bytes[1],shift={0,65}},{target=bytes[3],shift={0,-65}}},.5,"ease_in_out")
s:play({{target=bytes[1],shift={290,0}},{target=bytes[3],shift={-290,0}}},1,"ease_in_out")
s:play({{target=bytes[1],shift={0,-65}},{target=bytes[3],shift={0,65}}},.5,"ease_in_out")
s:fade_in(new,{duration=.4})
local arrow=line(320,250,750,250);s:create(arrow,.7)
s:fade_in(dst,{duration=.7});s:wait(2)
`,
 '07-premultiplied-alpha':`
stage=s:group{id="alpha_intro"}
-- One stable checkerboard and one image. Only source opacity changes.
grid(400,110,24,24,20,function(x,y)return math.floor(x/3)%2==math.floor(y/3)%2 and "#e6e6e6" or "#b4b4b4"end)
local foreground=grid(400,110,24,24,20,function(x,y)return hex(rgb(24,x,y))end)
text("A",325,645);text("0",390,690);text("255",855,690)
line(400,645,880,645,nil,"#b4bcc4",4)
local cursor=dot(880,645,nil,10,"#30373d")
local previousValue=text("255",930,645)
s:wait(1)
local last=255
for _,alpha in ipairs({128,0,128}) do
 s:fade_out(previousValue,{duration=.12})
 s:play({{target=foreground,opacity=alpha/255},{target=cursor,shift={(alpha-last)/255*480,0}}},1.5,"linear")
 previousValue=text(tostring(alpha),930,645);s:fade_in(previousValue,{duration=.12});s:wait(.8)
 last=alpha
end
s:fade_out(stage,{duration=.4})
stage=s:group{id="alpha_storage_stage"};s:fade_in(stage,{duration=.3})

text("Straight",90,80);text("Premultiplied",720,80)
local vals={200,100,0,128};local out={100,50,0,128}
local colors={"#dd654f","#60a777","#537eb8","#939eaa"}
local originals,originalValues={},{}
for i,name in ipairs({"R","G","B","A"}) do
 local y=165+(i-1)*85
 text(name,90,y);originalValues[i]=text(tostring(vals[i]),490,y)
 originals[i]=tile(175+vals[i]/2,y,math.max(1,vals[i]),26,colors[i])
 local bar=tile(175+vals[i]/2,y,math.max(1,vals[i]),26,colors[i])
 local value=text(tostring(out[i]),1100,y)
 s:fade_in(bar,{duration=.05})
 s:transform(bar,matrix(800+out[i]/2,y,math.max(1,out[i]),26),.8,"ease_in_out")
 s:fade_in(value,{duration=.15})
end
local eq=text("RGB x 128 / 256",720,495);s:fade_in(eq,{duration=.4})
s:wait(.8);s:fade_out(eq,{duration=.25})
local inverse=text("RGB x 255 / 128",720,495);s:fade_in(inverse,{duration=.3})
local restored={199,99,0,128}
for i=1,4 do
 local y=165+(i-1)*85
 s:fade_out(originals[i],{duration=.15});s:fade_out(originalValues[i],{duration=.15})
 local copy=tile(800+out[i]/2,y,math.max(1,out[i]),26,colors[i])
 s:fade_in(copy,{duration=.1})
 s:transform(copy,matrix(175+restored[i]/2,y,math.max(1,restored[i]),26),.8,"ease_in_out")
 local value=text(tostring(restored[i]),490,y);s:fade_in(value,{duration=.15})
end
s:wait(1)

local source=tile(185,600,100,70,"#643200")
local dest=tile(535,600,100,70,"#000064")
local plus=text("+",350,600);local equals=text("=",700,600)
local result=tile(890,600,100,70,"#643264")
local formula=text("(100, 50, 0) + (0, 0, 100)",90,495)
s:fade_in(formula,{duration=.3});s:fade_in(source,{duration=.3});s:fade_in(dest,{duration=.3})
s:fade_in(plus,{duration=.1});s:fade_in(equals,{duration=.1})
s:play({{target=source,shift={705,0}},{target=dest,shift={355,0}}},.9,"ease_in_out")
s:fade_in(result,{duration=.3});s:fade_out(source,{duration=.1});s:fade_out(dest,{duration=.1})
local label=text("(100, 50, 100)",985,600);s:fade_in(label,{duration=.3});s:wait(2)
`,
'08-format-fast-path':`
text("Surface",80,65);text("premultiplied",325,65);text("alphaIgnored",620,65);text("opacity = 255",965,65)
local rows={{"JPG",true,true},{"WebP",true,true},{"WebP + alpha",true,false},{"PNG (static)",false,false}}
for i,row in ipairs(rows) do
 local y=150+(i-1)*145
 text(row[1],80,y)
 local pre=text(tostring(row[2]),355,y);local alpha=text(tostring(row[3]),665,y)
 local route=line(260,y+35,925,y+35,nil,"#98a4af")
 s:create(route,.35);s:fade_in(pre,{duration=.25})
 if not row[2] then
  local op=text("RGB x A",340,y+60);s:fade_in(op,{duration=.3});s:wait(.5)
 else
  local skip=line(330,y+50,510,y+50,nil,"#60a777",3);s:create(skip,.25)
 end
 s:fade_in(alpha,{duration=.25})
 local op=text(row[3] and "Copy" or "Source-over",965,y)
 local bg=tile(1070,y+65,150,38,"#477ab5");local fg=tile(900,y+65,90,38,row[3] and "#c86428" or "#643214")
 s:fade_in(bg,{duration=.15});s:fade_in(fg,{duration=.15});s:shift(fg,{170,0},.5,"ease_in_out")
 if not row[3] then
  local blended=tile(1070,y+65,90,38,"#876f6e");s:fade_in(blended,{duration=.2});s:fade_out(fg,{duration=.1})
 end
 s:fade_in(op,{duration=.2})
end
s:wait(2)
`,
'09-update-prepare':`
text("update",85,85);text("prepare",485,85);text("run",875,85)
local a=line(205,85,450,85);local b=line(615,85,840,85)
local source=grid(85,390,8,8,22,function(x,y)return hex(rgb(8,x,y))end)
text("Source buffer",85,620)
local mat=text("M = T x R x S",85,190)
local task=text("SwImageTask",475,190)
local alias=line(545,230,173,365)
local ptr=text("source",340,310)
local conversion=text("ColorSpace / Alpha",855,190)
local ready=text("renderBox",865,620)
local poly=s:group{id="transformed_outline",matrix=matrix(980,420,1)}
poly:rectangle{id="image_outline",center={0,0},size={176,176},fill="#00000000",stroke="#4678cf",width=3,layer=35}
local angle=math.pi/6;local extent=176*(math.cos(angle)+math.sin(angle))
local box=outline(980-extent/2,420-extent/2,extent,extent,nil,"#202124")
s:wait(.5);s:fade_in(mat,{duration=.4});s:create(a,.6);s:fade_in(task,{duration=.4})
s:create(alias,.6);s:fade_in(ptr,{duration=.3});s:create(b,.6);s:fade_in(conversion,{duration=.5})
s:fade_in(poly,{duration=.4})
s:transform(poly,{math.cos(angle),-math.sin(angle),0,980-W/2,math.sin(angle),math.cos(angle),0,H/2-420,0,0,1,0,0,0,0,1},1.4,"ease_in_out")
s:create(box,.8);s:fade_in(ready,{duration=.3});s:wait(2)
`};
for(const [name,body] of Object.entries(scenes))await fs.writeFile(path.join(dir,name+'.lua'),common+body+'\nreturn s\n');
