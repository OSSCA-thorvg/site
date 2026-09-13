-- One canonical RGBA buffer -> Image crop -> pixel -> bytes -> 32 bits.
-- ThorVG 6cf10d47fbe13b45040f2c56feeafa0711f53b2b, ColorSpace/RenderSurface.
-- All label_* Text is standalone. Bit bars lie below their digit labels.
-- Screen plan: Y-down; p() maps to the fixed Y-up presentation camera.
-- See pixel-memory-README.txt for the seven-beat ledger and data contract.
local W,H=1280,720
local s=tmath.scene{width=W,height=H,fps=30,loop=false,theme="pro_white",camera={mode="fixed",view="2d",height=H}}
local function p(x,y) return {x-W/2,H/2-y} end
local function text(id,value,x,y,size,parent)
 return (parent or s):text{id="label_"..id,text=value,point=p(x,y),font="Pretendard",role="text",size=size or 24,align={0,.5},color="#202124",layer=50}
end
local function line(id,x,y,x2,y2,parent,color,width)
 return (parent or s):line{id=id,from=p(x,y),to=p(x2,y2),stroke=color or "#53616e",width=width or 1,layer=30}
end
local function rect(id,x,y,w,h,color,parent)
 return (parent or s):rectangle{id=id,center=p(x+w/2,y+h/2),size={w,h},fill=color,stroke="#00000000",layer=20}
end
local function outline(id,x,y,w,h)
 return s:rectangle{id=id,center=p(x+w/2,y+h/2),size={w,h},fill="#00000000",stroke="#202124",width=3,layer=40}
end
local function placement(x,y,scale)
 return {scale,0,0,x-W/2, 0,scale,0,H/2-y, 0,0,1,0, 0,0,0,1}
end
local function rgbhex(c) return string.format("#%02x%02x%02x%02x",c[1],c[2],c[3],c[4]) end

-- An original procedural landscape, stored as an actual row-major RGBA bitmap.
-- All colors opaque: this episode isolates byte order from premultiplication.
local iw,ih=160,96
local function rgba(x,y)
 local c={math.floor(57+y*.8),math.floor(119+y*.5),math.floor(173+y*.35),255}
 local sunx,suny,r=112,25,16
 if (x-sunx)^2+(y-suny)^2<r*r then c={math.floor(241-(y-9)*.4),math.floor(193-(y-9)*1.4),math.floor(87-(y-9)*.9),255} end
 local ridge=49+12*math.sin(x*.039)+6*math.sin(x*.09)
 if y>ridge then c={45+math.floor(x*.11),94+math.floor(y*.13),107+math.floor(x*.08),255} end
 local front=68+9*math.sin(x*.052+1.2)
 if y>front then c={27+math.floor(y*.08),66+math.floor(x*.09),68+math.floor(y*.12),255} end
 if y>78 and x>35+(y-78)*1.8 and x<130-(y-78)*1.7 then
  c={85+math.floor((y-78)*2),144+math.floor((y-78)*1.4),163+math.floor((y-78)*.8),255}
 end
 return c
end
local buffer,packed={},{ }
for y=0,ih-1 do for x=0,iw-1 do
 local c=rgba(x,y);buffer[y*iw+x+1]=c;packed[#packed+1]=rgbhex(c)
end end
local cropx,cropy,n,px,py=122,30,8,125,32
local picked=buffer[py*iw+px+1]
local crop,cropPatches={},{}
for y=0,n-1 do for x=0,n-1 do
 local color=packed[(cropy+y)*iw+cropx+x+1]
 crop[#crop+1]=color
 cropPatches[#cropPatches+1]={region={x,n-1-y,1,1},color=color}
end end
assert(crop[(py-cropy)*n+px-cropx+1]==rgbhex(picked))
local rgbaWord=picked[4]*16777216+picked[3]*65536+picked[2]*256+picked[1]
local bgraWord=picked[4]*16777216+picked[1]*65536+picked[2]*256+picked[3]
local function bits(v)
 local a={};for k=7,0,-1 do a[#a+1]=math.floor(v/2^k)%2 end;return a
end
for _,v in ipairs(picked) do
 local rebuilt=0;for _,b in ipairs(bits(v)) do rebuilt=rebuilt*2+b end
 assert(rebuilt==v)
end

local ix,iy,ik=48,64,2
local heroScale=6
local sourceOwner=s:group{id="source_owner",matrix=placement(W/2,H/2,heroScale)}
sourceOwner:image{id="source_image",pixels=packed,size={iw,ih},center={0,0},width=iw,filter="nearest",layer=10}
local roi=sourceOwner:rectangle{id="source_roi",center={cropx+n/2-iw/2,ih/2-cropy-n/2},size={n,n},fill="#00000000",stroke="#202124",width=3,layer=40}
local cx,cy,ck=432,64,28
local cropOwner=s:group{id="crop_owner",matrix=placement(W/2+(cropx+n/2-iw/2)*heroScale,H/2+(cropy+n/2-ih/2)*heroScale,heroScale)}
-- Cell is a direct view of the stored samples: no image-filter resampling.
cropOwner:cell{id="crop_pixels",origin={-n/2,-n/2},size={n,n},patches=cropPatches,mode="full",layer=15}
local grid=s:group{id="crop_grid"}
for i=0,n do
 line("col_"..i,cx+i*ck,cy,cx+i*ck,cy+n*ck,grid,"#ffffff99")
 line("row_"..i,cx,cy+i*ck,cx+n*ck,cy+i*ck,grid,"#ffffff99")
end
local cropLink=line("crop_link",ix+(cropx+n)*ik,iy+(cropy+n/2)*ik,cx,cy+n*ck/2)
local pickx,picky=cx+(px-cropx)*ck,cy+(py-cropy)*ck
local pickOutline=outline("selected_pixel",pickx,picky,ck,ck)
local fx,fy,fk=788,100,112
local pixelOwner=s:group{id="pixel_owner",matrix=placement(pickx+ck/2,picky+ck/2,ck)}
pixelOwner:image{id="pixel_image",pixels={rgbhex(picked)},size={1,1},center={0,0},width=1,filter="nearest",layer=20}
local pixelLink=line("pixel_link",pickx+ck,picky+ck/2,fx,fy+fk/2)

local names={"R","G","B","A"}
local colors={"#b64635","#21866a","#345aa1","#59636e"}
local orders={{1,2,3,4},{3,2,1,4}}
local labels,barRows,digits={},{},{}
local base,step=64,236
local rowY={356,528}
local words={s:group{id="rgba_word"},s:group{id="bgra_word"}}
text("rgba_enum","ABGR8888",1034,354,23,words[1]);text("rgba_word",string.format("0x%08X",rgbaWord),1034,392,25,words[1])
text("bgra_enum","ARGB8888",1034,526,23,words[2]);text("bgra_word",string.format("0x%08X",bgraWord),1034,564,25,words[2])
for row,order in ipairs(orders) do
 labels[row]={};barRows[row]={};digits[row]={}
 for slot,ch in ipairs(order) do
  local x=base+(slot-1)*step;local y=rowY[row]
  local g=s:group{id="byte_labels_"..row.."_"..slot};labels[row][slot]=g
  text("channel_"..row.."_"..slot,string.format("%s = %d  /  0x%02X",names[ch],picked[ch],picked[ch]),x,y,23,g)
  local marks=s:group{id="byte_bits_"..row.."_"..slot};barRows[row][slot]=marks
  local dg=s:group{id="byte_digits_"..row.."_"..slot};digits[row][slot]=dg
  for k,bit in ipairs(bits(picked[ch])) do
   local bx=x+(k-1)*22
   text("bit_"..row.."_"..slot.."_"..k,tostring(bit),bx+4,y+43,20,dg)
   rect("bitbar_"..row.."_"..slot.."_"..k,bx,y+(row==1 and 22 or 63),20,13,bit==1 and colors[ch] or "#e4e8ed",marks)
  end
 end
end
local channelStrips={}
for ch=1,4 do
 local owner=s:group{id="channel_strip_"..ch,matrix=placement(fx+(ch-.5)*fk/4,fy+fk/2,1)}
 owner:rectangle{id="channel_strip_body_"..ch,center={0,0},size={fk/4,fk},fill=colors[ch],stroke="#00000000",layer=35}
 channelStrips[ch]=owner
end
-- Copy proxies carry the same eight-bit pattern as the source byte.
local copies={}
for ch=1,4 do
 local g=s:group{id="byte_copy_"..ch};copies[ch]=g
 for k,bit in ipairs(bits(picked[ch])) do
  rect("copy_bit_"..ch.."_"..k,base+(ch-1)*step+(k-1)*22,rowY[1]+63,20,13,bit==1 and colors[ch] or "#e4e8ed",g)
 end
end

-- 1. The image is the opening, with no title or instruction overlay.
s:wait(.8);s:fade_in(roi,{duration=.35});s:wait(.5)
-- 2. Preserve the source while its selected samples expand into a visible grid.
s:fade_in(cropOwner,{duration=.15})
s:play({{target=sourceOwner,transform=placement(ix+iw*ik/2,iy+ih*ik/2,ik)},
        {target=cropOwner,transform=placement(cx+n*ck/2,cy+n*ck/2,ck)}},1.7,"ease_in_out")
s:create(cropLink,.35);s:fade_in(grid,{duration=.4});s:wait(.6)
-- 3. One selected texel becomes the persistent color swatch.
s:fade_in(pickOutline,{duration=.3});s:fade_in(pixelOwner,{duration=.15})
s:transform(pixelOwner,placement(fx+fk/2,fy+fk/2,fk),1.2,"ease_in_out")
s:create(pixelLink,.35);s:wait(.6)
-- 4–5. Each channel strip separates into its eight actual bit values.
for ch,strip in ipairs(channelStrips) do
 s:fade_in(strip,{duration=.12})
 local x=base+(ch-1)*step+87;local y=rowY[1]+22
 local matrix={174/(fk/4),0,0,x-W/2, 0,7/fk,0,H/2-y, 0,0,1,0, 0,0,0,1}
 s:transform(strip,matrix,.65,"ease_in_out");s:fade_in(labels[1][ch],{duration=.2})
 s:fade_in(barRows[1][ch],{duration=.15});s:fade_out(strip,{duration=.15})
 s:shift(barRows[1][ch],{0,-41},.5,"ease_in_out")
 s:fade_in(digits[1][ch],{duration=.2})
end
s:fade_in(words[1],{duration=.4});s:wait(1.2)
-- 6. Readable eight-bit patterns move to BGRA slots, preserving the RGBA row.
for slot,ch in ipairs(orders[2]) do
 s:fade_in(copies[ch],{duration=.15})
 s:shift(copies[ch],{(slot-ch)*step,rowY[1]-rowY[2]},1,"ease_in_out")
 s:fade_in(labels[2][slot],{duration=.2});s:fade_in(digits[2][slot],{duration=.2})
 s:fade_in(barRows[2][slot],{duration=.1})
end
-- 7. Same source color, different byte order and different packed integer.
s:fade_in(words[2],{duration=.4});s:wait(2.5)
return s
