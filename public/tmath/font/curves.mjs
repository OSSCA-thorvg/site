import {tmath} from '../runtime/client.js';
import {curveExample,quadratic} from './curves-model.mjs';
import {pathCommands} from './glyphs.mjs';

// Native Public Sans B points. Rotate and uniformly scale each local example
// so its endpoint chord reads left-to-right; no contour or control is reshaped.
// Six beats: quadratic, C1, C2, coincident cubic, implicit midpoint, two cubics.
export function buildCurves({still=false,example=curveExample()}={}) {
  const width=1280,height=1080,ink='#202020',muted='#626262',blue='#1f66c4',bg='#f2f2f2';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:bg,text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const id=name=>`font-curves-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const group=(name,visible=false)=>scene.group({id:id(name),opacity:still||visible?1:0});
  function text(parent,value,x,y,size=22,color=ink,align=[0,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]={standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),align,font:'Pretendard',role:'text',size,fill:color,layer:50});
  }
  function line(parent,a,b,color='#aaaaaa',dash=[],strokeWidth=1.3) {
    return parent.line({id:id('line'),from:p(...a),to:p(...b),stroke:color,width:strokeWidth,...(dash.length?{dash}:{}),layer:15});
  }
  function dot(parent,at,color=ink,hollow=false,r=5) {
    return parent.point({id:id('point'),point:p(...at),radius:r,fill:hollow?bg:color,stroke:color,width:1.6,layer:40});
  }
  function label(parent,name,at,offset=[0,25],color=ink) {
    return text(parent,name,at[0]+offset[0],at[1]+offset[1],23,color,[.5,.5]);
  }
  function project(a,b,x,y,length) {
    const d=b.map((v,i)=>v-a[i]),norm=Math.hypot(...d),scale=length/norm;
    return v=>{const r=v.map((n,i)=>n-a[i]);return [x+scale*(r[0]*d[0]+r[1]*d[1])/norm,y+scale*(d[0]*r[1]-d[1]*r[0])/norm];};
  }
  function nativeCurve(parent,s,map,color=blue,strokeWidth=3,layer=25) {
    return parent.path({id:id('cubic'),commands:[{type:'move',to:p(...map(s.start))},{type:'cubic',control1:p(...map(s.c1)),control2:p(...map(s.c2)),to:p(...map(s.end))}],samples:180,stroke:color,width:strokeWidth,fill:'#00000000',layer});
  }
  function quadraticGuide(parent,s,map) {
    return parent.route({id:id('quadratic'),points:Array.from({length:181},(_,i)=>p(...map(quadratic(s.start,s.q,s.end,i/180)))),stroke:'#999999',width:5,tip:0,tail:0,layer:20});
  }
  function wait(d){scene.wait(d);time+=d;}
  function play(spec,d=.5){scene.play(spec,d,'ease_in_out');time+=d;}
  function reveal(g,d=.5){play([{target:g,opacity:1}],d);}
  function create(g,d=1){scene.create(g,d,'linear');time+=d;}
  function beat(label,hold=1.2){beats.push({time:+time.toFixed(3),label});wait(hold);}

  text(scene,'TTF quadratic → Shape CubicTo',50,44,32);
  text(scene,'TtfReader::convert()',1230,44,22,muted,[1,.5]);
  line(scene,[50,80],[1230,80],'#cccccc');
  text(scene,'1. 하나의 제어점 → 두 개의 제어점',50,120,25);
  const s=example.single,map=project(s.start,s.end,115,500,620);
  const a=map(s.start),q=map(s.q),b=map(s.end),c1=map(s.c1),c2=map(s.c2);
  const guides=group('quadratic-input',true);
  line(guides,a,q);line(guides,q,b);quadraticGuide(guides,s,map);
  dot(guides,a);label(guides,'P0',a);dot(guides,b);label(guides,'P2',b);
  dot(guides,q,ink,true,6);label(guides,'Q',q,[0,-27]);
  text(guides,'Quadratic',455,536,20,muted,[.5,.5]);

  // One actual glyph inset identifies the selected native segment.
  const glyphMap=([x,y])=>[995+x*.12,365+y*.12];
  text(scene,`Public Sans · ${example.trace.letter}`,1080,148,21,muted,[.5,.5]);
  for(const commands of pathCommands(example.trace.path,v=>p(...glyphMap(v))))scene.path({id:id('glyph'),commands,stroke:'#999999',width:1.3,fill:'#00000000',layer:10});
  nativeCurve(scene,s,glyphMap,ink,3);

  const control1=group('control1'),control2=group('control2');
  const marker1=group('moving-control1'),marker2=group('moving-control2');
  dot(marker1,still?c1:a,blue,false,6);dot(marker2,still?c2:b,blue,false,6);
  line(control1,a,c1,blue,[],2);label(control1,'C1',c1,[-35,-6],blue);
  line(control2,b,c2,blue,[],2);label(control2,'C2',c2,[36,0],blue);
  text(control1,'C1 = P0 + (2/3)(Q − P0)',855,428,22,blue);
  text(control2,'C2 = P2 + (2/3)(Q − P2)',855,469,22,blue);
  const cubicPath=nativeCurve(scene,s,map);
  const result=group('cubic-result');
  text(result,'path.cubicTo(C1, C2, P2)',855,522,22);
  text(result,'같은 곡선',455,565,20,blue,[.5,.5]);

  line(scene,[50,604],[1230,604],'#cccccc');
  text(scene,'2. 연속된 off-curve 점 → 중점으로 연결',50,646,25);
  const [left,right]=example.pair,lower=project(left.start,right.end,115,927,620);
  const pa=lower(left.start),q1=lower(left.q),q2=lower(right.q),pb=lower(right.end),m=lower(left.end);
  const rawPair=group('consecutive-points');
  line(rawPair,pa,q1);line(rawPair,q2,pb);
  dot(rawPair,pa);label(rawPair,'P0',pa);dot(rawPair,pb);label(rawPair,'P2',pb);
  dot(rawPair,q1,ink,true,6);label(rawPair,'Q1',q1,[-10,-26]);
  dot(rawPair,q2,ink,true,6);label(rawPair,'Q2',q2,[12,-26]);
  const middle=group('implicit-midpoint');
  line(middle,q1,q2,muted,[5,5]);dot(middle,m,ink,false,6);label(middle,'M',m,[0,-26]);
  text(middle,'M = (Q1 + Q2) / 2',855,751,24);
  text(middle,'암시적인 on-curve 점',855,790,21,muted);
  const two=group('two-quadratics');
  quadraticGuide(two,left,lower);quadraticGuide(two,right,lower);
  const leftPath=nativeCurve(scene,left,lower),rightPath=nativeCurve(scene,right,lower);
  const pairResult=group('two-cubic-results');
  text(pairResult,'path.cubicTo(..., M)',855,864,22,blue);
  text(pairResult,'path.cubicTo(..., P2)',855,906,22,blue);
  text(pairResult,'각 구간에 같은 2/3 변환식 적용',855,952,20,muted);
  const final=group('invariant');
  text(final,'제어점 수만 바뀌고, 곡선의 모양은 그대로 유지됩니다.',640,1040,25,ink,[.5,.5]);
  dot(scene,[65,992]);text(scene,'On-curve',81,992,18,muted);
  dot(scene,[245,992],ink,true);text(scene,'Off-curve',261,992,18,muted);
  dot(scene,[425,992],blue);text(scene,'Cubic control',441,992,18,blue);

  if(still){beat('Native quadratic and equivalent cubic',1);return {scene,textIds,textPolicies,beats};}
  beat('One native quadratic segment: P0, Q, P2',1.5);
  reveal(marker1,.2);play([{target:marker1,shift:[(c1[0]-a[0])/100,(a[1]-c1[1])/100]}],1.1);reveal(control1,.4);
  beat('C1 lies two thirds from P0 toward Q',1.3);
  reveal(marker2,.2);play([{target:marker2,shift:[(c2[0]-b[0])/100,(b[1]-c2[1])/100]}],1.1);reveal(control2,.4);
  beat('C2 lies two thirds from P2 toward Q',1.3);
  create(cubicPath,1.5);reveal(result,.5);beat('CubicTo preserves the quadratic curve',1.8);
  reveal(rawPair,.6);reveal(middle,.8);reveal(two,.7);beat('Consecutive off-curve points imply midpoint M',1.8);
  create(leftPath,1.1);create(rightPath,1.1);reveal(pairResult,.5);reveal(final,.5);
  beat('Two cubic segments meet at the same implied endpoint',2.5);
  return {scene,textIds,textPolicies,beats};
}
