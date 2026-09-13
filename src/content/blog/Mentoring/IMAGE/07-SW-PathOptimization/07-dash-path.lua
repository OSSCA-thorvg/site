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

plot(s,"source",source,gray,7,5)
local period=dashLength+gapLength
local keyScale=2.6
local x=-period*keyScale/2
plot(s,"dash-key",{{x,-135},{x+dashLength*keyScale,-135}},blue,7)
plot(s,"gap-key",{{x+dashLength*keyScale,-135},{x+period*keyScale,-135}},gray,3)
text(s,"dash",string.format("dash %g",dashLength),x+dashLength*keyScale/2,-183,blue)
text(s,"gap",string.format("gap %g",gapLength),x+(dashLength+gapLength/2)*keyScale,-183)
local initialLabel=text(s,"offset-zero","offset 0",0,215)
local finalLabel=text(s,"offset-final",string.format("offset %g",offsetValue),0,215)
local function state(id,offset)
    local out={}
    for i,r in ipairs(dashRanges(0,total,offset)) do
        out[i]=plot(s,id.."-"..i,interval(r[1],r[2]),blue)
    end
    return out
end
local current=state("dash-initial",0)
s:wait(0.7)
s:create(current,0.45,"linear",0.16)
s:wait(0.8)
s:fade_out(initialLabel,{duration=0.25})
for step=1,90 do
    local nextState=state("dash-offset-"..step,offsetValue*step/90)
    s:morph(current,nextState,1/30,"linear")
    current=nextState
end
s:fade_in(finalLabel,{duration=0.35})
s:wait(2)
return s
