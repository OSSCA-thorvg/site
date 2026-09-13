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
plot(s,"rail",{{-360,-155},{360,-155}},gray,3,5)
text(s,"zero","0",-360,-205)
text(s,"one","1",360,-205)
local function state(id,b,e)
    local a,z=b*total,e*total
    return {
        plot(s,id.."-path",interval(a,z),green),
        plot(s,id.."-range",{{rail(a),-155},{rail(z),-155}},green,7),
        plot(s,id.."-begin",{{rail(a),-144},{rail(a),-166}},orange,3,20),
        plot(s,id.."-end",{{rail(z),-144},{rail(z),-166}},orange,3,20)
    }
end
local current=state("initial",0,0.15)
local final=s:group {id="final-labels"}
text(final,"begin",string.format("begin %.2f",beginValue),rail(beginValue*total),-105,green)
text(final,"end",string.format("end %.2f",endValue),rail(endValue*total),-105,green)
local step=0
local function change(b0,e0,b1,e1,seconds)
    local count=math.floor(seconds*30)
    for i=1,count do
        step=step+1
        local q=i/count
        local nextState=state("trim-"..step,b0+(b1-b0)*q,e0+(e1-e0)*q)
        s:morph(current,nextState,seconds/count,"linear")
        current=nextState
    end
end
s:wait(0.7)
change(0,0.15,0,1,2.5)
s:wait(0.65)
change(0,1,beginValue,1,1.7)
s:wait(0.55)
change(beginValue,1,beginValue,endValue,1.7)
s:fade_in(final,{duration=0.35})
s:wait(2)
return s
