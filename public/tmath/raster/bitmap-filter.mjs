import {tmath} from '../runtime/client.js';
import {buildScenarios} from './model.mjs';
import {color} from './scenes.mjs';

// ThorVG cdc1c959: tvgSwImage.cpp:62-80; tvgSwRaster.cpp:301-305.
// Reuse the native-checked sampling fixtures from Picture. Independent cases,
// not successive filters. Equal screen size per pixel preserves relative scale.
// Five beats reveal Direct, Nearest, Bilinear, Downscale, then Texture Mapping.
// Reveal timing is illustrative; final buffers are the existing model results.
export function buildBitmapFilter(data=buildScenarios()) {
  const width=960,height=870,ink='#191919',muted='#686868',cell=9;
  const scene=tmath.scene({width,height,fps:30,loop:false,
    camera:{mode:'fixed',view:'2d',height:height/100},
    theme:{preset:'pro_white',background:'#f1f1f1'}});
  const p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const textIds=[],textPolicies={},beats=[],cases=[];
  let serial=0,time=0;
  const id=()=>`bitmap-filter-${serial++}`;
  function text(value,x,y,size=20,fill=ink,align=[.5,.5]) {
    const key=id();textIds.push(key);textPolicies[key]={standalone:true};
    return scene.text({id:key,text:value,point:p(x,y),font:'Pretendard',role:'text',size,fill,align,layer:40});
  }
  function pixel(parent,x,y,fill,layer=15) {
    return parent.rectangle({id:id(),center:p(x,y),size:[(cell-.5)/100,(cell-.5)/100],fill,
      stroke:'#00000000',width:0,layer});
  }
  function grid(bitmap,cx,cy,output=false) {
    const rows=[];
    for(let y=0;y<bitmap.height;y++) {
      const row=output?scene.group({id:id(),opacity:0}):scene;
      if(output)rows.push(row);
      for(let x=0;x<bitmap.width;x++) {
        const px=cx+(x-(bitmap.width-1)/2)*cell,py=cy+(y-(bitmap.height-1)/2)*cell;
        pixel(scene,px,py,(x+y)%2?'#dfe4e7':'#fafafa',5);
        pixel(row,px,py,color(bitmap.pixels[y*bitmap.width+x]));
      }
    }
    return rows;
  }
  text('Bitmap · Transform & Filter',40,40,28,ink,[0,.5]);
  text('Input bitmap',440,96,20,muted);
  text('Surface',795,96,20,muted);
  const definitions=[
    ['direct','Direct','Translation only'],
    ['nearest','Scale · Nearest','Filter: Nearest'],
    ['bilinear','Scale · Bilinear','Bilinear · scale >= 0.5'],
    ['downscale','Scale · Downscale','Bilinear · scale < 0.5'],
    ['texmap','Texture Mapping','Rotation / shear'],
  ];
  for(const [i,[key,title,condition]] of definitions.entries()) {
    const d=data[key],y=170+i*145;
    if(i)scene.line({id:id(),from:p(40,y-72.5),to:p(920,y-72.5),stroke:'#cccccc',width:1,layer:5});
    text(title,40,y-19,24,ink,[0,.5]);
    text(condition,40,y+18,19,muted,[0,.5]);
    grid(d.source,440,y);
    const rows=grid(d.target,795,y,true);
    scene.arrow({id:id(),from:p(525,y),to:p(695,y),stroke:ink,width:2,tip:10,layer:20});
    const transform=d.direct?`move (${d.matrix[2]}, ${d.matrix[5]})`:d.scaled?`${d.scale}×`:'transform';
    text(transform,610,y-28,19,muted);
    cases.push({key,title,rows});
  }
  text('Independent cases · same display size per pixel',480,840,20,muted);
  scene.wait(.5);time+=.5;
  for(const example of cases) {
    for(const target of example.rows)scene.play([{target,opacity:1}],.9/example.rows.length);
    time+=.9;
    beats.push({time:+time.toFixed(3),label:example.title});
    scene.wait(.7);time+=.7;
  }
  scene.wait(1.2);
  return {scene,beats,textIds,textPolicies};
}
