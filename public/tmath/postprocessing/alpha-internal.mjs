import {tmath} from '../runtime/client.js';

// Conceptual normalized arithmetic, not a native Gaussian pass/timing trace.
// Source-over: C'o = C's + C'd (1-As), Ao = As + Ad (1-As).
// Storing C'o = Co Ao removes output normalization; C's/C'd are already stored.
// Local cdc1c959: tvgSwRasterC.h:25-39; tvgSwPostEffect.cpp:63-112.
// Filtering example: two neighbors with weights w and 1-w, alpha 1 and 0.
// Their visible input is unchanged when the transparent neighbor's RGB changes.
export function internalExample({visible=[0,1,0],hidden=[1,0,0],weight=.5}={}) {
  const alpha=weight;
  const naive=visible.map((v,i)=>v*weight+hidden[i]*(1-weight));
  const premult=visible.map(v=>v*weight);
  return {visible,hidden,weight,alpha,naive,premult,
    wrong:naive.map(v=>v*alpha+1-alpha),correct:premult.map(v=>v+1-alpha)};
}

export function buildAlphaInternal(input) {
  const e=internalExample(input),width=1120,height=980,ink='#202020',muted='#626262';
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2'}});
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const matrix=(x,y,sx=1)=>[sx,0,0,p(x,y)[0],0,1,0,p(x,y)[1],0,0,1,0,0,0,0,1];
  const hex=c=>'#'+c.map(v=>Math.round(v*255).toString(16).padStart(2,'0')).join('');
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const id=()=>`alpha-internal-${serial++}`;
  const group=()=>scene.group({id:id(),opacity:0});
  function text(parent,value,x,y,size=23,fill=ink,align=[.5,.5]) {
    const key=id();textIds.push(key);textPolicies[key]={standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill,align,layer:40});
  }
  function rect(parent,x,y,w,h,fill,stroke='#00000000') {
    return parent.rectangle({id:id(),center:p(x,y),size:[w/100,h/100],fill,stroke,width:stroke==='#00000000'?0:1.5,layer:15});
  }
  function arrow(parent,x,y,xx,yy) {
    return parent.arrow({id:id(),from:p(x,y),to:p(xx,yy),stroke:ink,width:2,tip:9,layer:10});
  }
  function show(target,d=.4){scene.play([{target,opacity:1}],d);time+=d;}
  function hide(target){scene.play([{target,opacity:0}],.001);time+=.001;}
  function beat(label,hold=1){beats.push({time:+time.toFixed(3),label});scene.wait(hold);time+=hold;}

  text(scene,'1. Source-over · store RGB × alpha',50,42,28,ink,[0,.5]);
  text(scene,'C: RGB   A: alpha   s: source   d: destination',560,75,16,muted);
  text(scene,'Straight RGB',50,108,21,muted,[0,.5]);
  text(scene,'Cout = (Cs × As + Cd × Ad × (1 − As)) / Aout',635,108,24);
  text(scene,'Aout = As + Ad × (1 − As)     (Aout > 0)',560,157,20,muted);
  const storage=group();
  arrow(storage,560,185,560,224);
  text(storage,"Store C'out = Cout × Aout",805,204,21,muted);
  const expanded=group();
  text(expanded,"C'out = Cs × As + Cd × Ad × (1 − As)",560,264,26);
  const compact=group();
  text(compact,"C'out = C's + C'd × (1 − As)",560,264,28,'#23896d');
  text(compact,"C's and C'd already contain alpha · no RGB division by Aout",560,313,21,muted);

  scene.line({id:id(),from:p(50,355),to:p(1070,355),stroke:'#cccccc',width:1,layer:5});
  text(scene,'2. Filtering · neighboring samples',50,395,28,ink,[0,.5]);
  text(scene,'Visible pixels',175,458,21,muted);
  rect(scene,420,458,50,50,hex(e.visible));
  for(let y=0;y<2;y++)for(let x=0;x<2;x++)rect(scene,530+(x-.5)*25,458+(y-.5)*25,25,25,(x+y)%2?'#dddddd':'#ffffff');
  text(scene,'A = 1',420,507,18,muted);text(scene,'A = 0',530,507,18,muted);
  const stored=group();
  text(stored,'Stored RGB',175,552,21,muted);
  rect(stored,420,552,50,50,hex(e.visible));rect(stored,530,552,50,50,hex(e.hidden));
  text(stored,'Transparent pixels can still store red.',825,462,21,muted);
  text(stored,'Interpolation / blur mix neighbors.',825,510,19,muted);
  text(stored,'Channel average',750,585,19,muted);
  text(stored,'On white',980,585,19,muted);
  const comparisons=[];
  for(const [index,correct] of [false,true].entries()) {
    const y=665+index*175,row=group(),tokens=[];
    text(row,correct?'Premultiply → average':'Straight RGB average',50,y-18,23,correct?'#23896d':'#bc573a',[0,.5]);
    text(row,correct?'RGB × A before averaging':'No alpha weighting',50,y+19,18,muted,[0,.5]);
    for(const [i,rgb] of [e.visible,e.hidden].entries()) {
      const sample=rect(row,420+i*110,y,50,50,hex(rgb));
      // Moving strips are explicit copies; retain the input for final comparison.
      const token=row.group({id:id(),matrix:matrix(420+i*110,y)});
      const body=token.rectangle({id:id(),center:[0,0],size:[.5,.5],fill:hex(rgb),stroke:'#00000000',width:0,layer:25});
      tokens.push({token,body,sample});
    }
    arrow(row,595,y,690,y);arrow(row,810,y,920,y);
    const result=group();
    rect(result,750,y,80,50,hex(correct?e.premult:e.naive));
    const displayed=group();
    rect(displayed,980,y,80,80,hex(correct?e.correct:e.wrong),ink);
    text(displayed,correct?'Green edge':'Hidden red mixed in',980,y+68,18,correct?'#23896d':'#bc573a');
    text(result,`A = ${e.alpha}`,750,y+50,18,muted);
    comparisons.push({row,tokens,result,displayed,y,correct});
  }
  text(scene,'Two-sample weighted average · Straight is also correct with explicit alpha weighting.',560,950,18,muted);

  beat('Straight RGB normalizes by output alpha.',1.1);
  show(storage);show(expanded);
  beat('Store alpha-weighted output: multiplying by Aout cancels the denominator.',1.5);
  hide(expanded);show(compact);
  beat('Source and destination RGB already include alpha; the inner blend avoids normalization.',1.5);
  show(stored);
  beat('The second sample is invisible, but its stored RGB is red.',1.5);
  for(const c of comparisons) {
    show(c.row);
    if(c.correct){scene.play([c.tokens[1].body,c.tokens[1].sample].map(target=>({target,fill:'#000000'})),.65);time+=.65;}
    // The strips occupy exactly w and 1-w of the same 80px averaging window.
    scene.play(c.tokens.map(({token},i)=>({target:token,transform:matrix(
      i===0?710+40*e.weight:710+80*e.weight+40*(1-e.weight),c.y,
      80*(i===0?e.weight:1-e.weight)/50)})),.9,'ease_in_out');time+=.9;
    beat(c.correct?'Only the opaque neighbor contributes RGB.':'Both stored RGB values contribute despite the second alpha being zero.',.6);
    c.tokens.forEach(({token})=>hide(token));show(c.result);show(c.displayed);
    beat(c.correct?'The same output alpha preserves a green edge.':'Naive straight-channel averaging contaminates the edge with hidden red.',1.4);
  }
  return {scene,beats,textIds,textPolicies,model:e};
}
