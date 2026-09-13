import {tmath} from '../runtime/client.js';
import traces from './native-trace.mjs';

// Native _build() appends commands and translates each point by cursor + offset.
// Each committed path below is a prefix of the actual TextImpl::shape RenderPath.
// The moving outline is a copy: cached source glyphs remain where they started.
export function verifyTrace(trace) {
  const cmds=[],pts=[];
  let cursor=[0,0];
  for(const glyph of trace.glyphs) {
    if(glyph.cursor.some((v,i)=>v!==cursor[i]))throw Error('Cursor discontinuity');
    if(glyph.cmdRange[0]!==cmds.length||glyph.pointRange[0]!==pts.length)throw Error('Range discontinuity');
    cmds.push(...glyph.path.cmds);
    // Point::operator+ performs each addition in float32, including conversion
    // of the decimal trace's round-trippable float representation.
    pts.push(...glyph.path.pts.map(p=>p.map((v,i)=>Math.fround(Math.fround(Math.fround(v)+glyph.cursor[i])+glyph.offset[i]))));
    if(glyph.cmdRange[1]!==cmds.length||glyph.pointRange[1]!==pts.length)throw Error('Wrong append range');
    if(glyph.nextCursor[0]!==cursor[0]+glyph.advance+glyph.offset[0])throw Error('Wrong advance');
    cursor=glyph.nextCursor;
  }
  if(JSON.stringify(cmds)!==JSON.stringify(trace.result.cmds))throw Error('Native command mismatch');
  if(pts.length!==trace.result.pts.length||pts.some((p,j)=>p.some((v,i)=>v!==Math.fround(trace.result.pts[j][i]))))throw Error('Native point mismatch');
}

// Point conversion preserves native cubic control points, contour order and holes.
export function pathCommands(path,convert) {
  let next=0,contour=[];
  const contours=[];
  const point=()=>convert(path.pts[next++]);
  for(const cmd of path.cmds) {
    if(cmd==='M'||cmd==='L')contour.push({type:cmd==='M'?'move':'line',to:point()});
    else if(cmd==='C')contour.push({type:'cubic',control1:point(),control2:point(),to:point()});
    else if(cmd==='Z') {contour.push({type:'close'});contours.push(contour);contour=[];}
    else throw Error('Unknown native command');
  }
  if(contour.length)throw Error('Open native glyph contour');
  if(next!==path.pts.length)throw Error('Unconsumed native points');
  return contours;
}

// Five beats: empty Shape; append A; append B; append C; shared ownership.
// Y-down native font coordinates map to a fixed Y-up presentation camera.
export function buildGlyphs({trace=traces.ABC,still=false}={}) {
  verifyTrace(trace);
  const width=1280,height=860,ink='#202020',muted='#626262',scale=.135;
  const colors=['#e66121','#1f66c4','#288773'];
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[],commits=[];
  let serial=0,time=0;
  const id=name=>`font-glyphs-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  function text(parent,value,x,y,size=22,color=ink,align=[0,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]={standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align,layer:50});
  }
  function rect(parent,x,y,w,h,fill='#00000000',stroke=ink,layer=10) {
    return parent.rectangle({id:id('rect'),center:p(x+w/2,y+h/2),size:[w/100,h/100],fill,stroke,width:1.5,layer});
  }
  function line(parent,x1,y1,x2,y2,color='#aaaaaa',strokeWidth=1,layer=12) {
    return parent.line({id:id('line'),from:p(x1,y1),to:p(x2,y2),stroke:color,width:strokeWidth,layer});
  }
  // Portable tmath Path supports one contour. These exact vector contours share
  // one semantic owner for the native RenderPath; no bitmap or hole masks.
  function outlines(parent,contours,name,stroke,width,layer) {
    for(const commands of contours)parent.path({id:id(name),commands,fill:'#00000000',stroke,width,layer});
  }
  function wait(d){scene.wait(d);time+=d;}
  function play(spec,d){scene.play(spec,d,'ease_in_out');time+=d;}
  function beat(label,hold=1.1){beats.push({time:+time.toFixed(3),label});wait(hold);}
  const output={x:135,baseline:706};
  const array={x:905,width:310,cmdY:559,ptsY:673,height:30};

  text(scene,`Text("${trace.text}") → one Shape`,50,43,32);
  text(scene,'Public Sans · glyph paths',1230,43,21,muted,[1,.5]);
  line(scene,50,80,1230,80,'#cccccc');
  text(scene,'point + cursor + offset',905,212,22,ink);
  text(scene,'→ out.pts',905,248,22,ink);
  text(scene,'commands → out.cmds',905,296,22,ink);
  // Keep the mechanism captions on two short lines within the side column.
  rect(scene,55,433,790,337);
  text(scene,'TextImpl::shape',905,411,26);
  text(scene,'Shape',820,464,21,muted,[1,.5]);
  text(scene,'RenderPath',905,464,26);
  text(scene,'cmds',array.x,525,21);
  text(scene,'pts',array.x,639,21);
  rect(scene,array.x,array.cmdY,array.width,array.height);
  rect(scene,array.x,array.ptsY,array.width,array.height);
  line(scene,100,output.baseline,800,output.baseline,'#cccccc');
  text(scene,'baseline',805,output.baseline+23,16,muted,[1,.5]);
  text(scene,'cursor.x',80,813,20,muted);
  text(scene,'font units',400,813,17,muted);
  text(scene,'cmds / pts accumulate in the same path',1230,813,20,muted,[1,.5]);

  const cursor=scene.group({id:id('cursor')});
  const initialCursor=output.x+(still?trace.glyphs.at(-1).nextCursor[0]*scale:0);
  line(cursor,initialCursor,output.baseline+5,initialCursor,output.baseline+27,colors[0],2.4,35);
  const prefixes=[],tokens=[],segments=[],counts=[],cursorValues=[];
  function counterState(commandCount,pointCount,cursorX,index) {
    if(still&&index!==trace.glyphs.length)return;
    const group=scene.group({id:id('counts'),opacity:still?Number(index===trace.glyphs.length):Number(index===0)});
    text(group,String(commandCount),array.x+array.width,525,22,ink,[1,.5]);
    text(group,String(pointCount),array.x+array.width,639,22,ink,[1,.5]);
    counts.push(group);
    const position=scene.group({id:id('position'),opacity:still?Number(index===trace.glyphs.length):Number(index===0)});
    text(position,String(cursorX),190,813,24);
    cursorValues.push(position);
  }
  counterState(0,0,0,0);

  for(const [index,glyph] of trace.glyphs.entries()) {
    const color=colors[index%colors.length],slot=195+index*245;
    const origin={x:slot-glyph.advance*scale/2,y:354};
    const commands=pathCommands(glyph.path,([x,y])=>p(origin.x+x*scale,origin.y+y*scale));
    outlines(scene,commands,'source','#929292',1.5,20);
    text(scene,`${glyph.letter}  ·  advance ${glyph.advance}`,slot,120,20,color,[.5,.5]);

    const token=scene.group({id:id('glyph-copy'),opacity:0});
    outlines(token,commands,'moving-outline',color,2,30);
    tokens.push({handle:token,shift:[(output.x+(glyph.cursor[0]+glyph.offset[0])*scale-origin.x)/100,
      -(output.baseline+(glyph.cursor[1]+glyph.offset[1])*scale-origin.y)/100]});

    const prefix=scene.group({id:id('shape-prefix'),opacity:still?Number(index===trace.glyphs.length-1):0});
    outlines(prefix,pathCommands({cmds:trace.result.cmds.slice(0,glyph.cmdRange[1]),pts:trace.result.pts.slice(0,glyph.pointRange[1])},
      ([x,y])=>p(output.x+x*scale,output.baseline+y*scale)),'shape-contour',ink,1.5,25);
    prefixes.push({handle:prefix});

    const segment=scene.group({id:id('appended-ranges'),opacity:still?1:0});
    for(const [range,total,y] of [[glyph.cmdRange,trace.result.cmds.length,array.cmdY],[glyph.pointRange,trace.result.pts.length,array.ptsY]]) {
      rect(segment,array.x+range[0]/total*array.width,y,(range[1]-range[0])/total*array.width,array.height,color,'#00000000',20);
    }
    segments.push(segment);
    counterState(glyph.cmdRange[1],glyph.pointRange[1],glyph.nextCursor[0],index+1);
  }
  const finalLabel=scene.group({id:id('shared-path'),opacity:still?1:0});
  text(finalLabel,`1 Shape · ${trace.result.cmds.filter(c=>c==='Z').length} contours`,905,752,24);

  if(still) {
    beat('Final single Shape',1);
    return {scene,textIds,textPolicies,beats,commits};
  }
  beat('Three cached glyph paths; one empty output Shape',1.3);
  for(const [index,glyph] of trace.glyphs.entries()) {
    const token=tokens[index];
    play([{target:token.handle,opacity:1}],.35);
    play([{target:token.handle,shift:token.shift}],1.45);
    // Preserve the old prefix throughout the append reveal, then remove its
    // visual proxy. Settled output has exactly one RenderPath owner.
    scene.remove(counts[index]);
    play([{target:prefixes[index].handle,opacity:1},{target:segments[index],opacity:1},{target:counts[index+1],opacity:1}],.25);
    scene.remove(token.handle);
    if(index)scene.remove(prefixes[index-1].handle);
    commits.push({time:+time.toFixed(3),glyph:glyph.letter,commands:glyph.cmdRange[1],points:glyph.pointRange[1]});
    wait(.35);
    play([{target:cursor,shift:[(glyph.nextCursor[0]-glyph.cursor[0])*scale/100,0]}],.55);
    scene.remove(cursorValues[index]);
    play([{target:cursorValues[index+1],opacity:1}],.15);
    beat(`Append ${glyph.letter}: ${glyph.cmdRange[1]} commands, ${glyph.pointRange[1]} points`,1.1);
  }
  play([{target:finalLabel,opacity:1}],.5);
  beat(`All ${trace.result.cmds.filter(c=>c==='Z').length} contours belong to one Shape`,2.5);
  return {scene,textIds,textPolicies,beats,commits};
}
