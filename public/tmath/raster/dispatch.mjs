import {tmath} from '../runtime/client.js';
import {classifyImage, classifyShape, buildScenarios} from './model.mjs';
import {buildDispatchPreview} from './dispatch-preview.mjs';
import {buildFillPreview} from './fill-preview.mjs';
import {buildRasterMap} from './raster-map.mjs';

// Each leaf has its own persistent, independent native-checked demonstration.
// Parallel previews compare alternatives; they do not form a rendering pipeline.
export function buildDispatch(scenarios = buildScenarios()) {
  const cases = [
    {id: 'rect', kind: 'shape', shape: {fastTrack: true}, data: scenarios.solidRect},
    {id: 'rle', kind: 'shape', shape: {fastTrack: false}, data: scenarios.solidRle},
    {id: 'gradient-rect', kind: 'shape', shape: {fastTrack: true, gradient: true}, data: scenarios.gradientRect},
    {id: 'gradient-rle', kind: 'shape', shape: {fastTrack: false, gradient: true}, data: scenarios.gradientRle},
    {id:'stroke-solid',kind:'shape',shape:{stroke:true},data:scenarios.strokeSolid},
    {id:'stroke-gradient',kind:'shape',shape:{stroke:true,gradient:true},data:scenarios.strokeGradient},
    ...['direct', 'nearest', 'downscale', 'bilinear', 'texmap'].map(id => ({
      id, kind: 'image', matrix: scenarios[id].matrix, filter: scenarios[id].filter, data: scenarios[id],
    })),
  ];
  const width = 1280, height = 3300;
  const scene = tmath.scene({width, height, fps: 30, loop: true,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f1f1f1'}});
  const p = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const textIds = [], textPolicies = {}, beats = [], rectangleIds = new WeakMap();
  let serial = 0, time = 0;
  const key = value => 'dispatch-' + value + '-' + serial++;
  function text(parent, value, x, y, size = 18, fill = '#191919', name = 'text') {
    const id = key(name); textIds.push(id); textPolicies[id] = {standalone: true};
    return parent.text({id, text: value, point: p(x, y), font: 'Pretendard', role: 'text',
      size, fill, align: [.5, .5], layer: 40});
  }
  function line(parent, points, stroke = '#191919', strokeWidth = 2, name = 'route', tip = 0) {
    return parent.route({id: key(name), points: points.map(v => p(...v)), stroke,
      width: strokeWidth, tip, layer: 20});
  }
  function rect(parent, x, y, w, h, fill, stroke = '#00000000', strokeWidth = 0, layer = 10) {
    const id = key('rect');
    const result = parent.rectangle({id, center: p(x, y), size: [w / 100, h / 100],
      fill, stroke, width: strokeWidth, layer});
    rectangleIds.set(result, id);
    return result;
  }
  const nodes = {
    shape: {label: 'Shape Fill', x: 105, y: 550, width: 150},
    solid: {label: 'Solid', x: 295, y: 290, width: 128},
    gradient: {label: 'Gradient', x: 295, y: 810, width: 128},
    stroke:{label:'Stroke',x:105,y:1330,width:150},
    'stroke-color':{label:'Solid',x:295,y:1200,width:128},
    'stroke-fill':{label:'Gradient',x:295,y:1460,width:128},
    image: {label: 'Image', x: 105, y: 2060, width: 116},
    scaled: {label: 'Scaled', x: 295, y: 2060, width: 128},
    ...Object.fromEntries([['rect','Rect',160],['rle','RLE',420],['gradient-rect','Rect',680],['gradient-rle','RLE',940],
      ['stroke-solid','RLE',1200],['stroke-gradient','RLE',1460],
      ['direct','Direct',1700],['nearest','Nearest',1880],['downscale','Downscale',2060],['bilinear','Bilinear',2240],['texmap','Texmap',2420]]
      .map(([id,label,y]) => [id, {label, x: 550, y, width: 154}])),
  };
  const edges = {
    solid: {points: [[180,550],[195,550],[195,290],[231,290]], labels: []},
    gradient: {points: [[180,550],[195,550],[195,810],[231,810]], labels: []},
    rect: {points: [[359,290],[370,290],[370,160],[473,160]], labels: [['fastTrack',420,125]]},
    rle: {points: [[359,290],[370,290],[370,420],[473,420]], labels: [['else',420,395]]},
    'gradient-rect': {points: [[359,810],[370,810],[370,680],[473,680]], labels: [['fastTrack',420,645]]},
    'gradient-rle': {points: [[359,810],[370,810],[370,940],[473,940]], labels: [['else',420,915]]},
    'stroke-color':{points:[[180,1330],[195,1330],[195,1200],[231,1200]],labels:[]},
    'stroke-fill':{points:[[180,1330],[195,1330],[195,1460],[231,1460]],labels:[]},
    'stroke-solid':{points:[[359,1200],[473,1200]],labels:[['strokeRle',416,1165]]},
    'stroke-gradient':{points:[[359,1460],[473,1460]],labels:[['strokeRle',416,1425]]},
    direct: {points: [[163,840],[180,840],[180,480],[473,480]], labels: [['direct',330,455]]},
    scaled: {points: [[163,840],[231,840]], labels: [['scaled',209,792]]},
    texmap: {points: [[163,840],[180,840],[180,1200],[473,1200]], labels: [['else',330,1175]]},
    nearest: {points: [[359,840],[370,840],[370,660],[473,660]], labels: [['filter = Nearest',404,625]]},
    downscale: {points: [[359,840],[473,840]], labels: [['Bilinear',422,792],['scale < 0.5',422,814]]},
    bilinear: {points: [[359,840],[370,840],[370,1020],[473,1020]], labels: [['Bilinear',422,972],['scale ≥ 0.5',422,994]]},
  };
  for(const name of ['direct','scaled','texmap','nearest','downscale','bilinear']) {
    edges[name].points=edges[name].points.map(([x,y])=>[x,y+1220]);
    edges[name].labels=edges[name].labels.map(([label,x,y])=>[label,x,y+1220]);
  }
  for (const [name, y, h] of [['shape',550,1020],['stroke',1330,500],['image',2060,860]])
    scene.rectangle({id: key('group-'+name), center: p(329,y), size: [6.18,h/100],
      fill: '#00000000', stroke: '#191919', width: 1.8, dash: [7,6], layer: 3});
  for (const [name, edge] of Object.entries(edges)) {
    line(scene, edge.points, '#191919', 2.5, name, 9);
    for (const label of edge.labels) text(scene,...label,13,'#686868','condition');
  }
  // fillFetchSolid() redirects a constant Gradient to rasterShape().
  for(let y=782;y>342;y-=12)line(scene,[[295,y],[295,Math.max(342,y-7)]],'#191919',2,'solid-fallback');
  line(scene,[[295,342],[295,318]],'#191919',2.5,'solid-fallback-arrow',12);
  text(scene,'fillFetchSolid() = true',425,536,13,'#191919','fallback');
  text(scene,'one stop / degenerate',425,560,13,'#686868','fallback-condition');
  // rasterGradientStroke() uses the same solid shortcut before its RLE lookup.
  for(let y=1432;y>1252;y-=12)line(scene,[[295,y],[295,Math.max(1252,y-7)]],'#191919',2,'stroke-solid-fallback');
  line(scene,[[295,1252],[295,1228]],'#191919',2.5,'stroke-solid-fallback-arrow',12);
  text(scene,'fillFetchSolid() = true',425,1316,13,'#191919','stroke-fallback');
  text(scene,'one stop / degenerate',425,1340,13,'#686868','stroke-fallback-condition');
  text(scene,'Linear / Radial',286,856,12,'#686868','gradient-types');
  for (const [name,node] of Object.entries(nodes)) {
    const root = name === 'shape' || name === 'image' || name === 'stroke';
    const block = rect(scene,node.x,node.y,node.width,56,root?'#191919':'#ffffff','#191919',2,18);
    text(scene,node.label,node.x,node.y,18,root?'#ffffff':'#191919','node-'+name);
    textPolicies[textIds.at(-1)]={owner:rectangleIds.get(block),inset:8};
  }
  buildRasterMap({scene,p,rect,line,text,key,contain:(block)=>{
    textPolicies[textIds.at(-1)]={owner:rectangleIds.get(block),inset:8};
  }});
  const trace=cases.map(input=>{
    const result=input.kind==='shape'?classifyShape(input.shape):classifyImage(input.matrix,input.filter);
    const route=input.shape?.stroke?['stroke',result.fill==='gradient'?'stroke-fill':'stroke-color',input.id]:input.kind==='shape'?['shape',result.fill,result.fill==='gradient'?'gradient-'+result.branch:result.branch]:result.branch==='scaled'?['image','scaled',result.sampler]:['image',result.branch];
    if(route.at(-1)!==input.id)throw new Error('Preview does not match the selected leaf: '+input.id);
    return {input,result,route};
  });
  const previews=trace.map(({input})=>{
    const y=nodes[input.id].y;
    const panel=rect(scene,956,y,604,input.kind==='shape'?238:152,'#ffffff','#a0a0a0',1,2);
    line(scene,[[627,y],[654,y]],'#191919',1.5,'leaf-preview');
    const parent=scene.group({id:key('preview-'+input.id)});
    return (input.kind==='shape'?buildFillPreview:buildDispatchPreview)({parent,input,rowY:y,p,rect,line,key,text:(...args)=>{
      const handle=text(...args);
      textPolicies[textIds.at(-1)]={owner:rectangleIds.get(panel),inset:12};
      return handle;
    }});
  });
  // All eleven dedicated row previews remain visible and loop together. Timing is
  // presentation only: no algorithm output or execution order is fabricated.
  scene.wait(.6);time+=.6;
  for(let i=0;i<2;i++){
    const actions=previews.map(preview=>preview.actions[i]);
    scene.play(actions.map(a=>({target:a.focus,opacity:1})),.3,'linear');time+=.3;
    scene.wait(.65);time+=.65;
    scene.play(actions.map(a=>({target:a.result,opacity:1})),.4,'linear');time+=.4;
    beats.push({time,label:'Independent queries '+i+': computed samples in every row'});
    scene.wait(.45);time+=.45;
    scene.play(actions.map(a=>({target:a.token,opacity:1})),.04,'linear');time+=.04;
    scene.play(actions.map(a=>({target:a.token,shift:[(a.dx-a.homeX)/100,(a.homeY-a.dy)/100]})),.65,'ease_in_out');time+=.65;
    scene.wait(.5);time+=.5;
    scene.play(actions.flatMap(a=>[{target:a.focus,opacity:0},{target:a.token,opacity:0}]),.25,'linear');time+=.25;
  }
  scene.wait(.8);time+=.8;
  return {scene,beats,textIds,textPolicies,trace,width,height,duration:time,loop:true};
}
