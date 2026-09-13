import {tmath} from '../runtime/client.js';
import {states,playbackEvents,apiRows,verifyStates} from './model.mjs';

// Representative success edges above; complete status gates for valid inputs
// and successful backend calls below. Timing is educational, not worker timing.
export function buildLifecycle({still=false}={}) {
  verifyStates();
  const width=1280,height=1150,ink='#202020',muted='#626262',blue='#1f66c4',red='#b33a32';
  const scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f2f2f2',text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:ink}]))}});
  const textIds=[],textPolicies={},beats=[],nodes={},edges={};
  let serial=0,time=0;
  const id=name=>`canvas-state-${name}-${serial++}`;
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  function text(parent,value,x,y,size=22,color=ink,owner,align=[.5,.5]) {
    const key=id('text');textIds.push(key);textPolicies[key]=owner?{owner:owner.id,inset:12}:{standalone:true};
    return parent.text({id:key,text:value,point:p(x,y),align,font:'Pretendard',role:'text',size,fill:color,layer:50});
  }
  function line(a,b,color='#cccccc') {scene.line({id:id('line'),from:p(...a),to:p(...b),stroke:color,width:1,layer:5});}
  function edge(from,to,points,label,at) {
    edges[from+'/'+to]=scene.route({id:id('edge'),points:points.map(v=>p(...v)),stroke:'#999999',width:1.8,tip:9,layer:15});
    text(scene,label,...at,20,muted);
  }
  text(scene,'Canvas state machine',50,44,32,ink,undefined,[0,.5]);
  text(scene,'Canvas::Impl::status',1230,44,23,muted,undefined,[1,.5]);
  line([50,80],[1230,80]);
  text(scene,'Representative transitions · API state rules below',50,110,18,muted,undefined,[0,.5]);
  text(scene,'Black: current state',1230,110,18,muted,undefined,[1,.5]);
  const descriptions={Synced:'Initial / synced',Damaged:'Target / viewport',Painting:'Paint list changed',Updating:'Update requested',Drawing:'Draw submitted'};
  for(const [i,state] of states.entries()) {
    const x=145+i*245,active=state==='Synced';
    const box=scene.rectangle({id:id('node'),center:p(x,375),size:[1.9,1],fill:active?ink:'#ffffff',stroke:ink,width:1.5,layer:30});
    const title=text(scene,state,x,356,24,active?'#ffffff':ink,box);
    const detail=text(scene,descriptions[state],x,396,17,active?'#dddddd':muted,box);
    nodes[state]={box,title,detail};
  }
  const mainLabels=['target()','add()','update()','draw()'];
  for(let i=0;i<4;i++)edge(states[i],states[i+1],[[241+i*245,375],[294+i*245,375]],mainLabels[i],[267.5+i*245,299]);
  edge('Drawing','Synced',[[1125,324],[1125,165],[145,165],[145,324]],'sync() · renderer succeeds',[635,140]);
  edge('Synced','Updating',[[205,324],[205,243],[880,243],[880,324]],'update()',[565,216]);
  edge('Damaged','Updating',[[390,426],[390,493],[880,493],[880,426]],'update() · RenderUpdateFlag::All',[635,522]);

  line([50,660],[1230,660]);
  text(scene,'API',65,698,22,ink,undefined,[0,.5]);
  text(scene,'Allowed states',315,698,22,ink,undefined,[0,.5]);
  text(scene,'State on success',1110,698,22);
  line([50,722],[1230,722]);
  for(const [i,row] of apiRows().entries()) {
    const y=753+i*52;
    text(scene,row.label,65,y,21,ink,undefined,[0,.5]);
    text(scene,row.allowed.join(' · '),315,y,20,muted,undefined,[0,.5]);
    text(scene,row.result,1110,y,22);
    line([50,y+26],[1230,y+26]);
  }
  text(scene,'Valid arguments and successful backend calls · viewport requires a changed region',50,1061,18,muted,undefined,[0,.5]);
  text(scene,'No state change: update() in Updating, sync() in Synced, or an unchanged viewport.',50,1101,20,muted,undefined,[0,.5]);

  const events=playbackEvents(),captions=(still?[events.at(-1)]:events).map(e=>{
    const g=scene.group({id:id('event'),opacity:0});
    text(g,e.api,640,585,27,e.result==='Success'?ink:red);
    text(g,e.detail,640,628,21,e.result==='Success'?muted:red);
    return g;
  });
  function play(spec,d=.4){scene.play(spec,d,'ease_in_out');time+=d;}
  function beat(event,hold){beats.push({time:+time.toFixed(3),label:event.api,state:event.after,result:event.result});scene.wait(hold);time+=hold;}
  if(still){scene.play([{target:captions.at(-1),opacity:1}],.01);time+=.01;beat(events.at(-1),1);return {scene,textIds,textPolicies,beats};}
  scene.play([{target:captions[0],opacity:1}],.01);time+=.01;
  beat(events[0],1.5);
  for(let i=1;i<events.length;i++) {
    const e=events[i];scene.remove(captions[i-1]);play([{target:captions[i],opacity:1}],.3);
    if(e.before!==e.after) {
      const route=edges[e.before+'/'+e.after];
      if(!route)throw Error('Missing state edge: '+e.before+'/'+e.after);
      play([{target:route,stroke:blue}],.75);
      const previous=nodes[e.before],next=nodes[e.after];
      play([{target:previous.box,fill:'#ffffff'},{target:previous.title,fill:ink},{target:previous.detail,fill:muted},
        {target:next.box,fill:ink},{target:next.title,fill:'#ffffff'},{target:next.detail,fill:'#dddddd'}],.3);
      beat(e,i===events.length-1?2.7:1.5);
      play([{target:route,stroke:'#999999'}],.25);
    } else beat(e,2.2);
  }
  return {scene,textIds,textPolicies,beats};
}
