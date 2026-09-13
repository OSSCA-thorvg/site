// Source-backed cross-cutting branches and Surface operations. No temporal flow
// is implied between these independent groups. See raster-map source anchors.
export function buildRasterMap({scene,p,rect,line,text,key,contain}) {
  function group(x,y,w,h){scene.rectangle({id:key('raster-family'),center:p(x,y),size:[w/100,h/100],fill:'#00000000',stroke:'#191919',width:1.5,dash:[7,6],layer:3});}
  function box(label,x,y,w=150){
    const block=rect(scene,x,y,w,44,'#ffffff','#191919',1.5,18);
    text(scene,label,x,y,14,'#191919','map-node');
    contain(block);
  }
  function arrow(points,label,x,y){line(scene,points,'#191919',1.7,'map-route',7);if(label)text(scene,label,x,y,12,'#686868','map-condition');}
  group(329,2740,618,420);group(956,2740,604,420);
  text(scene,'Image · RLE clip',329,2557,18);
  box('Direct',110,2630,126);box('DirectRle',470,2630,170);
  arrow([[173,2630],[385,2630]],'image.rle',276,2604);
  box('Scaled',110,2730,126);box('ScaledRle',470,2730,170);
  arrow([[173,2730],[385,2730]],'image.rle',276,2704);
  box('Texmap',110,2850,126);box('Temporary',320,2850,148);box('DirectRle',535,2850,158);
  arrow([[173,2850],[246,2850]]);arrow([[394,2850],[456,2850]]);
  text(scene,'image.rle',329,2812,12,'#686868');
  text(scene,'Output selection',956,2557,18);
  box('Compositor?',765,2630,172);
  box('Matting',1142,2610,166);box('Mask',1142,2700,166);
  arrow([[851,2630],[900,2630],[900,2610],[1059,2610]],'method < Add',975,2586);
  arrow([[900,2630],[900,2700],[1059,2700]],'method ≥ Add',975,2676);
  box('Blend?',765,2768,172);box('Custom Blend',1142,2768,166);
  arrow([[765,2652],[765,2746]],'no',786,2709);
  arrow([[851,2768],[1059,2768]],'yes',961,2746);
  // Direct-image matting can additionally use a custom blender.
  scene.route({id:key('matting-blend'),points:[[1225,2610],[1242,2610],[1242,2768],[1225,2768]].map(v=>p(...v)),stroke:'#686868',width:1.3,dash:[5,5],tip:6,layer:20});
  box('Normal',765,2895,172);box('Opaque',1142,2850,166);box('Translucent',1142,2915,166);
  arrow([[765,2790],[765,2873]],'no',786,2830);
  arrow([[851,2895],[914,2895],[914,2850],[1059,2850]]);
  arrow([[914,2895],[914,2915],[1059,2915]]);
  group(639,3122,1238,260);
  text(scene,'Surface operations',639,3018,18);
  for(const [label,x,y,w] of [
    ['Convert CS',140,3080,188],['Premultiply',410,3080,188],['Clear',680,3080,188],['Compositor setup',1004,3080,228],
    ['Pixel32 / alpha',140,3190,188],['Grayscale8',410,3190,188],['XY Flip',680,3190,188],['Unpremultiply',1004,3190,228],
  ])box(label,x,y,w);
  arrow([[234,3080],[316,3080]]);
}
