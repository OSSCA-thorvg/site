-- 6b94ffbd: Shape API -> RenderPath, illustrative coordinates.
local s = tmath.scene {width=960, height=540, fps=30, loop=false,
    theme="pro_white", camera={mode="fixed", view="2d", height=540}}
local blue, green, ink = "#2563eb", "#0d9488", "#334155"
local function txt(id, str, x, y, color)
    return s:text {id=id, text=str, point={x,y}, role="code", font="IBM Plex Sans KR",
        size=22, color=color or ink, layer=30}
end
local source = {A={20,230}, B={205,230}, K1={305,230}, K2={285,20}, C={135,20}, D={20,80}}
local p = {}
for _,name in ipairs({"A","B","K1","K2","C","D"}) do
    p[name]={source[name][1]-375,145-source[name][2]}
end
local rows = {
    {cmd="MoveTo", names={"A"}}, {cmd="LineTo", names={"B"}},
    {cmd="CubicTo", names={"K1","K2","C"}},
    {cmd="LineTo", names={"D"}}, {cmd="Close", names={}}
}
txt("cmds", "cmds[]", 88, 217)
txt("pts", "pts[]", 304, 217)
s:line {id="separator", from={-15,-195}, to={-15,195}, stroke="#cbd5e1", width=1}
local slots, marks = {}, {}
for i,row in ipairs(rows) do
    local y = 153-(i-1)*72
    local g=s:group {id="row-"..i}
    g:text {id="command-"..i, text=row.cmd, point={88,y}, role="code",
        font="IBM Plex Sans KR", size=22, color=ink, layer=30}
    for j,name in ipairs(row.names) do
        local x=242+(j-1)*61
        g:point {id="operand-"..name, point={x,y+7}, radius=6, fill=green, layer=20}
        g:text {id="operand-name-"..name, text=name, point={x,y-20}, role="code",
            font="IBM Plex Sans KR", size=18, color=green, layer=30}
    end
    slots[i]=g
end
for _,name in ipairs({"A","B","K1","K2","C","D"}) do
    local point=p[name]
    local g=s:group {id="vertex-"..name}
    g:point {id="point-"..name, point=point, radius=5, fill=blue, layer=20}
    local labelPoint=name=="A" and {point[1]-22,point[2]-22} or {point[1],point[2]+23}
    g:text {id="name-"..name, text=name, point=labelPoint,
        role="code", font="IBM Plex Sans KR", size=18, color=blue, layer=30}
    marks[name]=g
end
local line=s:line {id="edge-ab",from=p.A,to=p.B,stroke=blue,width=4,layer=10}
local curve=s:curve {id="edge-bc",from=p.B,control1=p.K1,control2=p.K2,to=p.C,stroke=blue,width=4,layer=10}
local endline=s:line {id="edge-cd",from=p.C,to=p.D,stroke=blue,width=4,layer=10}
local close=s:line {id="edge-da",from=p.D,to=p.A,stroke=blue,width=4,layer=10}
local guides=s:group {id="handles"}
guides:line {from=p.B,to=p.K1,stroke="#94a3b8",width=1,dash={5,5},layer=5}
guides:line {from=p.K2,to=p.C,stroke="#94a3b8",width=1,dash={5,5},layer=5}
-- A and row 1 are the meaningful opening; each following row is revealed
-- in the same semantic beat as its generated geometry.
s:wait(0.7)
s:create(line,1.1)
s:fade_in(marks.B,{duration=0.25})
s:fade_in(slots[2],{duration=0.3})
s:wait(0.5)
s:fade_in(guides,{duration=0.3})
s:fade_in(marks.K1,{duration=0.25})
s:fade_in(marks.K2,{duration=0.25})
s:create(curve,1.5)
s:fade_in(marks.C,{duration=0.25})
s:fade_in(slots[3],{duration=0.3})
s:wait(0.6)
s:create(endline,0.9)
s:fade_in(marks.D,{duration=0.25})
s:fade_in(slots[4],{duration=0.3})
s:wait(0.5)
s:create(close,0.9)
s:fade_in(slots[5],{duration=0.3})
s:wait(2.0)
return s
