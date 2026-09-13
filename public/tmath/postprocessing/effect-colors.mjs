import {tmath} from '../runtime/client.js';
import {buildColorTrace, interpolateBytes, tritoneMap} from './effect-colors-model.mjs';
import nativeColors from './effect-colors-native.mjs';

const C = {ink:'#202020', muted:'#626262', line:'#777777', shades:['#444444','#818181','#bcbcbc']};
const hex = c => '#' + c.map(v => Math.max(0,Math.min(255,Math.round(v))).toString(16).padStart(2,'0')).join('');
// Flatten premultiplied bytes onto the same checkerboard in every duplicate view.
const displayed = (c, backdrop=246) => hex(c.slice(0,3).map(v => v + backdrop * (1-c[3]/255)));
const rgba = p => [p&255,p>>>8&255,p>>>16&255,p>>>24];
const tuple = c => c.join(', ');

/**
 * Evidence ledger (all snapshots derive from buildColorTrace before choreography):
 * 1. API registers Blur then this effect; existing blurred Offscreen is the subject.
 * 2. Row-major prefix writes settle before inspecting the selected source pixel.
 * 3. Tint/Tritone map stored RGB through luma; Fill reads alpha and replaces RGB.
 * 4. Stored alpha and the configured factor scale bytes; write back to that slot.
 * 5. Repeat with a blue edge pixel, then accelerate the remaining canonical writes.
 * 6. Hold the completed Offscreen and the last expanded pixel operation together.
 * Fill uses fixed read/compute/write sections and commits directly to the same slot.
 * No LUT is attributed to Tritone: its ramp visualizes _trintone(l) as a function.
 */
function buildColorDetail(id, data = buildColorTrace(id)) {
  const width=960,height=800;
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:8},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:C.ink}]))}});
  const textIds=[],textPolicies={},beats=[];
  let serial=0,time=0;
  const key=name=>`detail-${id}-${name}-${serial++}`;
  const p=(x,y)=>[(x-480)/100,(400-y)/100];
  const group=(opacity=0)=>scene.group({id:key('group'),opacity});
  function text(parent,value,x,y,size=20,color=C.ink) {
    const id=key('text');textIds.push(id);textPolicies[id]={standalone:true};
    return parent.text({id,text:value,point:p(x,y),align:[.5,.5],size,font:'Pretendard',role:'text',fill:color,layer:40});
  }
  function rect(parent,x,y,w,h,fill='#00000000',stroke=C.line,border=1,layer=12) {
    return parent.rectangle({id:key('rect'),center:p(x,y),size:[w/100,h/100],fill,stroke,width:border,layer});
  }
  function line(parent,x1,y1,x2,y2,color=C.line,border=1) {
    return parent.line({id:key('line'),from:p(x1,y1),to:p(x2,y2),stroke:color,width:border,layer:8});
  }
  function wait(duration) {scene.wait(duration);time+=duration;}
  function play(spec,duration=.45,curve='ease_in_out') {scene.play(spec,duration,curve);time+=duration;}
  function show(target,duration=.45) {play([{target,opacity:1}],duration);}
  function shift(target,x,y,duration=.55) {scene.shift(target,[x/100,-y/100],duration,'ease_in_out');time+=duration;}
  function beat(label,hold=.9) {beats.push({time:+time.toFixed(3),label});wait(hold);}
  const cfg=data.config;
  const api=id==='tint' ? `scene->add(SceneEffect::Tint, ${cfg.black.slice(0,3).join(',')}, ${cfg.white.slice(0,3).join(',')}, ${cfg.intensity.toFixed(1)});`
    : id==='tritone' ? `scene->add(SceneEffect::Tritone, ${cfg.shadow.slice(0,3).join(',')}, ${cfg.midtone.slice(0,3).join(',')}, ${cfg.highlight.slice(0,3).join(',')}, ${cfg.blender});`
    : `scene->add(SceneEffect::Fill, ${cfg.color.join(',')});`;
  text(scene,'scene->add(SceneEffect::GaussianBlur, 1.4, 0, 0, 100);',480,37,18,C.muted);
  text(scene,api,480,73,id==='tritone'?17:18);
  text(scene,`SceneImpl::render() → render(cmp, ${cfg.name}, false)`,480,116,20);
  line(scene,40,144,920,144,'#b9b9b9');
  text(scene,'Offscreen',220,177,23);
  if(id==='fill') {
    text(scene,'One pixel · in place',700,177,22);
    line(scene,485,344,915,344,'#cccccc');
    line(scene,485,625,915,625,'#cccccc');
  } else {
    text(scene,'Read',540,177,22);text(scene,'Map',700,177,22);text(scene,'Write',860,177,22);
  }
  const stage=id==='fill'?null:rect(scene,540,197,54,2,C.ink,'#00000000',0,30);
  let stageX=540;
  function focusStage(x) {if(stage&&x!==stageX){shift(stage,x-stageX,0,.22);stageX=x;}}
  text(scene,`24 × 24 · Scene opacity ${data.opacity}`,220,212,18,C.muted);
  line(scene,445,205,445,735,'#cccccc');
  const left=40,top=242,cell=15;
  const centers=data.input.map((_,i)=>[left+(i%data.width+.5)*cell,top+(Math.floor(i/data.width)+.5)*cell]);
  const pixelColors=data.input.map((value,i)=> {
    const x=i%data.width,y=Math.floor(i/data.width),back=(x+y)%2?238:250;
    return displayed(rgba(value),back);
  });
  const slots=data.input.map((_,i)=>rect(scene,...centers[i],cell,cell,pixelColors[i],'#00000000',0,10));
  rect(scene,220,422,360,360,'#00000000',C.ink,1.5,18);
  const [x0,y0,x1,y1]=data.bbox;
  scene.rectangle({id:key('bbox'),center:p(left+(x0+x1)*cell/2,top+(y0+y1)*cell/2),size:[(x1-x0)*cell/100,(y1-y0)*cell/100],fill:'#00000000',stroke:C.ink,width:1.5,dash:[5,4],layer:19});
  text(scene,`bbox · x ${x0}..${x1-1} · y ${y0}..${y1-1}`,220,633,18,C.muted);
  text(scene,'dst[y × stride + x]',220,669,20);
  if(id==='fill')text(scene,'Group opacity is applied later',220,709,17,C.muted);
  const cursor=scene.group({id:key('cursor')});
  cursor.rectangle({id:key('cursor-white'),center:[0,0],size:[.17,.17],fill:'#00000000',stroke:'#ffffff',width:5,layer:31});
  cursor.rectangle({id:key('cursor-black'),center:[0,0],size:[.17,.17],fill:'#00000000',stroke:C.ink,width:2,layer:32});
  const matrix=([x,y])=>{const [a,b]=p(x,y);return [1,0,0,a,0,1,0,b,0,0,1,0,0,0,0,1];};
  cursor.moveTo(p(...centers[data.steps[0].index]));

  const mapping=group();
  if(id!=='fill') {
    const colors=Array.from({length:256},(_,l)=>hex((id==='tint'?interpolateBytes(cfg.white,cfg.black,l):tritoneMap(l,cfg).mapped).slice(0,3)));
    rect(mapping,700,386,400,34,'#00000000',C.line,1,12);
    // Each strip is one evaluation of the source function; this is not a LUT allocation.
    for(let l=0;l<256;l++)rect(mapping,500+(l+.5)*400/256,386,400/256+.1,32,colors[l],'#00000000',0,13);
    text(mapping,id==='tint'?'black':'shadow',520,422,17,C.muted);
    text(mapping,id==='tint'?'white':'highlight',875,422,17,C.muted);
    if(id==='tritone') {line(mapping,700,367,700,404,C.ink,1.5);text(mapping,'midtone · 128',700,422,17,C.muted);}
  } else {
    text(mapping,'02  Compute new RGBA',700,370,21);
    rect(mapping,540,425,64,64,hex(cfg.color.slice(0,3)),C.ink,1,12);
    text(mapping,`Fill RGB (${cfg.color.slice(0,3).join(', ')})`,755,411,19);
    text(mapping,`Effect opacity = ${data.parameter}`,755,445,18,C.muted);
  }

  const first=data.steps.findIndex(step=>step.source[3]>150&&step.source[3]<230);
  const second=data.steps.findIndex((step,i)=>i>first+80&&step.source[3]>100&&step.source[3]<180);
  const selected=[first,second].filter(index=>index>=0);
  if(selected.length!==2) throw new Error('Need two non-degenerate native detail pixels.');
  const variantNative=id==='tritone'?nativeColors.perturbed.find(sample=>sample.id===id):null;
  const variantTrace=variantNative?buildColorTrace(id,{input:variantNative.input,opacity:variantNative.opacity,parameter:variantNative.parameter,bbox:variantNative.bbox}):null;
  const variantStep=variantTrace?.steps.find(step=>step.luma>160&&step.source[3]>220);
  const detailRecords=selected.map(index=>({index,step:data.steps[index],sample:data}));
  if(variantStep)detailRecords.push({index:'bright',step:variantStep,sample:variantTrace});
  const details=new Map(detailRecords.map(({index,step,sample})=> {
    const {source,luma,mapped,mixed,factor,result}=step;
    const read=group(),weights=group(),map=group(),mix=group(),alpha=group(),out=group(),mixedTile=group(),mappedTile=group();
    const [cx,cy]=centers[step.index];
    // A separate proxy travels; the source slot keeps its original value until commit.
    const traveller=group();
    if(id!=='fill')rect(traveller,cx,cy,cell,cell,displayed(source),C.ink,1,35);
    if(id==='fill')text(read,'01  Read stored alpha',700,217,21);
    text(read,index==='bright'?`Bright input (${step.x}, ${step.y}) · L = ${luma}`:`(${step.x}, ${step.y}) · RGBA (${tuple(source)})`,700,id==='fill'?253:217,19);
    rect(read,520,id==='fill'?303:269,id==='fill'?44:64,id==='fill'?44:64,displayed(source),C.ink,1,20);
    for(let k=0;k<(id==='fill'?1:3);k++) {
      const y=id==='fill'?289:248+k*21;
      text(read,id==='fill'?'A':'RGB'[k],579,y,16,C.muted);
      line(read,596,y,901,y,'#d3d3d3',10);
      const w=source[id==='fill'?3:k]/255*305;
      if(w)rect(read,596+w/2,y,w,10,C.shades[k],'#00000000',0,20);
    }
    const contributions=group(),terms=[];
    let offset=500;
    if(id!=='fill') {
      text(weights,`(54R + 182G + 19B) >> 8 = ${luma}`,700,316,20);
      line(weights,500,340,900,340,'#d3d3d3',14);
      [54,182,19].forEach((weight,k)=>{
        const w=weight*source[k]/65536*400;
        if(w) {
          rect(weights,offset+w/2,340,w,14,C.shades[k],'#00000000',0,20);
          const token=rect(contributions,596+w/2,248+k*21,w,10,C.shades[k],'#00000000',0,33);
          terms.push({target:token,shift:[(offset-596)/100,(248+k*21-340)/100]});
        }
        offset+=w;
      });
      const marker=map.group({id:key('luma-marker')});
      marker.route({id:key('luma-index'),points:[p(500+luma/255*400,358),p(500+luma/255*400,370)],stroke:C.ink,width:2,tip:7,layer:29});
      text(map,id==='tritone'?(step.lower?`L < 128 → a = 2 × ${luma} = ${step.weight}`:`L ≥ 128 → a = 2 × (${luma} - 128)`):`INTERPOLATE(white, black, ${luma})`,700,458,19);
      rect(mappedTile,540,504,58,58,displayed(mapped),C.ink,1,20);
      rect(map,860,504,58,58,displayed(source),C.ink,1,20);
      const share=id==='tint'?sample.parameter:256-sample.parameter;
      const a=218*share/256,b=218-a;
      rect(mix,590+a/2,495,a,18,displayed(mapped),'#00000000',0,20);
      rect(mix,590+a+b/2,495,b,18,displayed(source),'#00000000',0,20);
      text(mix,id==='tint'?`intensity = ${sample.parameter}`:`blender = ${sample.parameter} (original)`,700,527,18,C.muted);
      rect(mixedTile,700,573,58,58,displayed(mixed),C.ink,1,21);
      text(mixedTile,`RGBA (${tuple(mixed)})`,700,620,18);
      text(alpha,`MULTIPLY(${sample.opacity}, ${source[3]}) = ${factor}`,700,653,19);
    } else {
      text(weights,`A = ${source[3]} · existing RGB is replaced`,740,321,17,C.muted);
      text(map,`A' = MULTIPLY(${data.parameter}, ${source[3]}) = ${factor}`,700,486,20);
      // The alpha bar's extent is a byte value, not a second image or allocation.
      line(map,500,519,900,519,'#d3d3d3',22);
      rect(map,500+factor/255*200,519,factor/255*400,22,C.ink,'#00000000',0,20);
      text(mix,`RGB' = floor(RGB × (${factor} + 1) / 256)`,700,559,19);
      text(alpha,`ALPHA_BLEND(color, ${factor})`,700,598,20);
      text(out,'03  Overwrite the same pixel',700,653,21);
    }
    rect(out,550,699,54,54,displayed(result),C.ink,1,22);
    text(out,`${id==='fill'?'RGBA':'→'} (${tuple(result)})`,745,698,20);
    const write=group();
    if(id!=='fill')rect(write,550,699,cell,cell,displayed(result),C.ink,1,35);
    const mappedProxy=group(),mixLeft=group(),mixRight=group();
    const share=id==='tint'?sample.parameter:256-sample.parameter,a=58*share/256,b=58-a;
    if(id!=='fill') {
      rect(mappedProxy,500+luma/255*400,386,16,32,displayed(mapped),C.ink,1,34);
      rect(mixLeft,540,504,a,58,displayed(mapped),'#00000000',0,34);
      rect(mixRight,860,504,b,58,displayed(source),'#00000000',0,34);
    }
    return [index,{step,read,weights,map,mix,alpha,out,traveller,write,cx,cy,mappedTile,mixedTile,mappedProxy,mixLeft,mixRight,contributions,terms,a,b}];
  }));
  const opening=group(1),final=group(),variantCaption=group();
  text(opening,`GaussianBlur → ${cfg.name}`,480,764,21);
  text(final,`${data.steps.length} pixels written → endComposite()`,480,764,21);
  if(variantStep)text(variantCaption,`Separate bright input · opacity ${variantTrace.opacity} · blender ${variantTrace.parameter}`,480,764,20);

  beats.push({time:0,label:'API and blurred Offscreen'});wait(1.2);
  let previous;
  for(let i=0;i<data.steps.length;i++) {
    const step=data.steps[i],detail=details.get(i),back=(step.x+step.y)%2?238:250;
    if(detail) {
      focusStage(540);
      if(previous)play([previous.read,previous.weights,previous.map,previous.mix,previous.alpha,previous.out,previous.mappedTile,previous.mixedTile].map(target=>({target,opacity:0})),.18);
      play([{target:cursor,transform:matrix(centers[step.index])}],.08,'linear');
      if(id==='fill')show(detail.read,.25);
      else {
        show(detail.traveller,.12);shift(detail.traveller,520-detail.cx,269-detail.cy,.65);
        play([{target:detail.traveller,opacity:0},{target:detail.read,opacity:1}],.15);
      }
      focusStage(700);
      if(id!=='fill') {
        show(detail.contributions,.15);play(detail.terms,.65);
        play([{target:detail.contributions,opacity:0},{target:detail.weights,opacity:1}],.15);
      } else show(detail.weights,.35);
      wait(.55);
      if(i===selected[0])show(mapping,.35);
      show(detail.map,.4);
      if(id!=='fill') {
        show(detail.mappedProxy,.08);shift(detail.mappedProxy,540-(500+step.luma/255*400),118,.5);
        play([{target:detail.mappedProxy,opacity:0},{target:detail.mappedTile,opacity:1}],.08);
      }
      wait(.45);
      if(i===selected[0])beat(id==='fill'?'Alpha scales Fill RGB':'Weighted RGB selects the mapped color',.75);
      show(detail.mix,.35);
      if(id!=='fill') {
        play([{target:detail.mixLeft,opacity:1},{target:detail.mixRight,opacity:1}],.08);
        play([{target:detail.mixLeft,shift:[(671+detail.a/2-540)/100,-.69]},{target:detail.mixRight,shift:[(671+detail.a+detail.b/2-860)/100,-.69]}],.55);
        play([{target:detail.mixLeft,opacity:0},{target:detail.mixRight,opacity:0},{target:detail.mixedTile,opacity:1}],.1);
      }
      wait(.4);show(detail.alpha,.55);wait(.6);
      show(detail.out,.45);
      if(i===selected[0])beat('Integer byte operations produce the pixel',.8);
      focusStage(860);
      if(id!=='fill') {show(detail.write,.08);shift(detail.write,detail.cx-550,detail.cy-699,.75);}
      play([{target:detail.write,opacity:0},{target:slots[step.index],fill:displayed(step.result,back)}],.05,'linear');
      beat(`Write pixel (${step.x}, ${step.y}) back to its address`,.6);
      previous=detail;
      if(id==='tritone'&&i===selected[0]) {
        focusStage(700);
        const bright=details.get('bright');
        play([detail.read,detail.weights,detail.map,detail.mix,detail.alpha,detail.out,detail.mappedTile,detail.mixedTile,cursor,opening].map(target=>({target,opacity:0})),.18);
        show(variantCaption,.2);show(bright.read,.4);show(bright.weights,.5);show(bright.map,.55);show(bright.mappedTile,.35);
        show(bright.mix,.3);show(bright.mixedTile,.3);show(bright.alpha,.3);show(bright.out,.3);
        beat('Separate bright input takes the midtone → highlight branch',1);
        play([bright.read,bright.weights,bright.map,bright.mappedTile,bright.mix,bright.mixedTile,bright.alpha,bright.out,variantCaption].map(target=>({target,opacity:0})),.18);
        show(opening,.2);show(cursor,.15);focusStage(860);previous=null;
      }
    } else {
      // Each write commits in native y/x order; there is no reconstructed final overlay.
      play([{target:slots[step.index],fill:displayed(step.result,back)},{target:cursor,transform:matrix(centers[step.index])}],.016,'linear');
    }
  }
  play([{target:cursor,opacity:0},{target:opening,opacity:0}],.15);show(final,.15);
  beat('Completed Offscreen and selected write',2.5);
  return {scene,beats,textIds,textPolicies,imageRegions:[],data,duration:time};
}

export const buildTintDetail = data => buildColorDetail('tint',data);
export const buildTritoneDetail = data => buildColorDetail('tritone',data);
export const buildFillDetail = data => buildColorDetail('fill',data);
