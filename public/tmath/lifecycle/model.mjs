import trace from './native-trace.mjs';

export const states=['Synced','Damaged','Painting','Updating','Drawing'];
export function transition(before,api) {
  if(api==='sync')return 'Synced'; // Successful renderer->sync(), or already Synced.
  if(api==='update')return before==='Drawing'?null:'Updating';
  if(api==='draw')return ['Painting','Damaged','Updating'].includes(before)?'Drawing':null;
  if(api==='add'||api==='remove')return before==='Drawing'?null:'Painting';
  if(api==='target')return ['Updating','Drawing'].includes(before)?null:'Damaged';
  if(api==='viewport')return ['Synced','Damaged'].includes(before)?'Damaged':null; // Changed region.
  throw Error('Unknown API: '+api);
}

export function verifyStates() {
  for(const event of [...trace.matrix,...trace.example]) {
    const expected=transition(event.before,event.api);
    if(event.after!==(expected??event.before)||event.result!==(expected?'Success':'InsufficientCondition'))throw Error('Native Canvas status mismatch: '+JSON.stringify(event));
  }
  if(trace.matrix.length!==35||new Set(trace.matrix.map(e=>e.before+'/'+e.api)).size!==35)throw Error('Incomplete native API/state matrix');
  return trace;
}

// Native snapshots bracket each public call. The intermediate Updating state
// inside draw() comes from Canvas::Impl::draw/update's unchanged source code.
export function playbackEvents(example=verifyStates().example) {
  const events=[{api:'Canvas construction',before:'Synced',after:'Synced',result:'Success',detail:'The initial status is Synced.'}];
  for(const e of example) {
    if(e.api==='draw'&&e.result==='Success'&&['Painting','Damaged'].includes(e.before)) {
      events.push({...e,api:'draw() → internal update()',after:'Updating',detail:'Painting and Damaged call update() first.'});
      events.push({...e,api:'draw() → render',before:'Updating',detail:'Scene render and postRender() succeed → Drawing.'});
    } else events.push({...e,api:e.api+'()',detail:e.result!=='Success'?'InsufficientCondition · status remains Drawing.':
      e.api==='target'?'Target setup succeeds → Damaged requires a full update.':
      e.api==='add'?'Add to the Paint list → Painting.':
      e.api==='sync'?'renderer->sync() succeeds → return to Synced.':'update() succeeds → Updating.'});
  }
  return events;
}

export function apiRows() {
  const operations=[['update','update()','Updating'],['draw','draw()','Drawing'],['sync','sync()','Synced'],['add','add() / remove()','Painting'],['target','target()','Damaged'],['viewport','viewport() change','Damaged']];
  return operations.map(([api,label,result])=>({label,result,allowed:states.filter(s=>trace.matrix.some(e=>e.api===api&&e.before===s&&e.result==='Success'))}));
}
