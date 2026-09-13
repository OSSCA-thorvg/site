-- ThorVG 6b94ffbd: illustrative non-wrapped, single-contour, positive dash model.
-- Canonical coordinates drive all geometry; 08 displays their cumulative length.
local s=tmath.scene {width=960,height=540,fps=30,loop=false,theme="pro_white",
    camera={mode="fixed",view="2d",height=540}}
local source={{-320,-40},{-80,-40},{-80,140},{220,140}}
local beginValue,endValue=0.25,0.75
local dashLength,gapLength,offsetValue=72,36,24
local gray,green,blue,orange,ink="#d7dee7","#0d9488","#2563eb","#ea580c","#475569"
local lens={0}
for i=2,#source do
    local dx,dy=source[i][1]-source[i-1][1],source[i][2]-source[i-1][2]
    lens[i]=lens[i-1]+math.sqrt(dx*dx+dy*dy)
end
local total=lens[#lens]
local function clamp(x,a,b) return math.max(a,math.min(b,x)) end
local function at(d)
    d=clamp(d,0,total)
    for i=2,#source do
        if d<=lens[i] then
            local q=(d-lens[i-1])/(lens[i]-lens[i-1])
            return {source[i-1][1]+q*(source[i][1]-source[i-1][1]),
                source[i-1][2]+q*(source[i][2]-source[i-1][2])}
        end
    end
    return source[#source]
end
local function interval(a,b)
    local pts={at(a)}
    for i=2,#source-1 do pts[#pts+1]=at(clamp(lens[i],a,b)) end
    pts[#pts+1]=at(b)
    return pts
end
local function plot(owner,id,pts,color,width,layer)
    return owner:plot {id=id,points=pts,stroke=color,width=width or 7,layer=layer or 15}
end
local function text(owner,id,value,x,y,color,align)
    return owner:text {id=id,text=value,point={x,y},font="IBM Plex Sans KR",role="code",
        size=23,color=color or ink,align=align or {0.5,0.5},layer=30}
end
local function rail(d) return -360+720*d/total end
local function dashRanges(a,b,offset)
    local out={}
    local period=dashLength+gapLength
    for k=0,math.ceil(total/period)+1 do
        local left=clamp(a+k*period-offset,a,b)
        local right=clamp(a+k*period-offset+dashLength,a,b)
        if right>left then out[#out+1]={left,right} end
    end
    return out
end

-- Arc-length lanes: XY bends are deliberately unrolled, not transformed.
local a,b=beginValue*total,endValue*total
local top,middle,bottom=155,0,-155
plot(s,"source",{{-360,top},{360,top}},gray,7,5)
text(s,"source-name","RenderShape.path",-360,top+45,ink,{0,0.5})
local trim=s:group {id="trim"}
plot(trim,"trim-interval",{{rail(a),top},{rail(b),top}},green)
local trimName=text(s,"trim-name","trimmedPath",-360,middle+45,green,{0,0.5})
local dashes=s:group {id="dashes"}
local segments={}
for i,r in ipairs(dashRanges(a,b,0)) do
    if r[2]>r[1] then
        segments[#segments+1]=plot(dashes,"dash-"..i,{{rail(r[1]),middle},{rail(r[2]),middle}},blue)
    end
end
local dashName=text(s,"dash-name","synth",-360,bottom+45,blue,{0,0.5})
local arrow1=s:arrow {id="trim-arrow",from={405,top-15},to={405,middle+15},stroke="#94a3b8",width=2,tip=9,layer=5}
local arrow2=s:arrow {id="dash-arrow",from={405,middle-15},to={405,bottom+15},stroke="#94a3b8",width=2,tip=9,layer=5}
s:wait(0.7)
s:create(trim,1.2)
s:wait(0.6)
s:shift(trim,{0,middle-top},1.1,"ease_in_out")
s:fade_in(trimName,{duration=0.3})
s:create(arrow1,0.45)
s:wait(0.6)
s:create(segments,0.5,"linear",0.17)
s:wait(0.65)
s:shift(dashes,{0,bottom-middle},1.1,"ease_in_out")
s:fade_in(dashName,{duration=0.3})
s:create(arrow2,0.45)
s:wait(2)
return s
