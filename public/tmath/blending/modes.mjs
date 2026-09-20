import {tmath} from '../runtime/client.js';
import {input, buildModel, hex} from './modes-model.mjs';

// All modes are visible from frame zero. Shared geometry motion provides
// a simultaneous comparison; native opaque RGB colors never interpolate.
export function buildOverview(data = input) {
  const model = buildModel(data), width = 1280, height = 1360;
  const ink = '#202020', muted = '#626262';
  const scene = tmath.scene({width, height, fps: 30, loop: true,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(['h1','h2','h3','text','code'].map(r => [r, {font: 'Pretendard', color: ink}]))}});
  const textIds = [], textPolicies = {}, routes = [], pixelProbes = [], sampleChecks = [];
  const beats = [{time:0,label:'All 17 overlaps'}, {time:2.6,label:'All source shapes separated'}, {time:5.2,label:'All overlaps restored'}];
  const reviewTimes = [0,.8,1.55,2.3,2.6,3.4,3.7,4.45,5.2,6];
  const states = [[0,18],[.8,18],[2.3,90],[2.6,100],[3.4,100],[3.7,90],[5.2,18],[6,18]];
  let serial = 0;
  const p = (x,y) => [(x-width/2)/100,(height/2-y)/100];
  const id = n => `blend-modes-${n}-${serial++}`;
  const matrix = (x,y,sx=1,sy=1) => [sx,0,0,x,0,sy,0,y,0,0,1,0,0,0,0,1];
  function text(value,x,y,size=24,color=ink) {
    const key=id('text');textIds.push(key);textPolicies[key]={standalone:true};
    return scene.text({id:key,text:value,point:p(x,y),font:'Pretendard',size,fill:color,align:[.5,.5],layer:40});
  }
  function rect(parent,x,y,w,h,fill,layer=15) {
    return parent.rectangle({id:id('rect'),center:p(x+w/2,y+h/2),size:[w/100,h/100],fill,stroke:'#00000000',width:0,layer});
  }
  function overlapMatrix(x,y,shift) {
    const w=Math.max(0,90-shift);
    return matrix(...p(x+shift+w/2,y+55),Math.max(w,.0001)/100,.7);
  }
  text('BlendMethod · 17 modes',640,46,34);
  text('Same motion · different overlap colors',640,91,24,muted);
  text(`D  (${model.destination.join(', ')})`,300,148,24);
  text(`S  (${model.source.join(', ')})`,900,148,24);
  rect(scene,205,175,190,30,hex(model.destination));
  rect(scene,805,175,190,30,hex(model.source));
  scene.line({id:id('rule'),from:p(40,225),to:p(1240,225),stroke:'#cccccc',width:1});
  const objects=[];
  model.modes.forEach((mode,index)=>{
    const x=60+(index%4)*310,y=290+Math.floor(index/4)*210;
    text(mode.name,x+110,y-30,25);
    rect(scene,x,y,90,90,hex(model.destination));
    const source=scene.group({id:id('source'),matrix:matrix(...p(x+18+45,y+65))});
    source.rectangle({id:id('source-pixel'),center:[0,0],size:[.9,.9],fill:hex(model.source),stroke:'#00000000',width:0,layer:16});
    const overlap=scene.group({id:id('overlap'),matrix:overlapMatrix(x,y,18)});
    overlap.rectangle({id:id('blend-pixel'),center:[0,0],size:[1,1],fill:mode.color,stroke:'#00000000',width:0,layer:20});
    text(mode.rgba.slice(0,3).join(', '),x+110,y+143,21,muted);
    pixelProbes.push({x:x+54,y:y+55,color:mode.color});
    for(const time of reviewTimes) {
      let shift=18;
      for(let k=1;k<states.length;k++) if(time<=states[k][0]) {
        const [t0,s0]=states[k-1],[t1,s1]=states[k];shift=s0+(s1-s0)*(time-t0)/(t1-t0);break;
      }
      // Interior probe in D: after separation it must restore D, not retain B.
      sampleChecks.push({time,name:mode.name,x:x+45,y:y+55,color:shift<45?mode.color:hex(model.destination)});
      sampleChecks.push({time,name:mode.name+' source',x:x+shift+75,y:y+100,color:hex(model.source)});
    }
    objects.push({source,overlap,x,y});
  });
  text('Overlap RGB · native CPU samples · opaque schematic rectangles',640,1321,20,muted);
  for(let i=1;i<states.length;i++) {
    const [time,shift]=states[i], [previousTime,previousShift]=states[i-1];
    if(shift===previousShift)scene.wait(time-previousTime);
    else scene.play(objects.flatMap(({source,overlap,x,y})=>[
      {target:source,transform:matrix(...p(x+shift+45,y+65))},
      {target:overlap,transform:overlapMatrix(x,y,shift)},
    ]),time-previousTime,'linear');
  }
  return {scene,model,beats,reviewTimes,textIds,textPolicies,routes,pixelProbes,sampleChecks};
}
