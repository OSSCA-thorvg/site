import {tmath} from '../runtime/client.js';
import {rgba} from './model.mjs';

export function overviewKit(kind,{w=16,h=12,width=1440,height=3260,still=false}={}){
  const C={ink:'#24292e',muted:'#646d75',blue:'#236caa',orange:'#bc6728',grid:'#d5dde3',bg:'#f6f7f8'};
  const scene=tmath.scene({width,height,fps:30,loop:true,camera:{mode:'fixed',view:'2d',height:height/100},theme:{preset:'pro_white',background:C.bg,text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:C.ink}]))}});
  const textIds=[],textPolicies={},tracks=[],regions=[],imageRegions=[],pixelChecks=[],spanChecks=[],beats=[];
  const owners=new WeakMap();let serial=0;
  const id=label=>`${kind}-${label}-${serial++}`,p=(x,y)=>[(x-width/2)/100,(height/2-y)/100];
  const matrix=(x=0,y=0,sx=1,sy=1)=>[sx,0,0,x,0,sy,0,y,0,0,1,0,0,0,0,1];
  const clamp=v=>Math.max(0,Math.min(1,v)),smooth=v=>{v=clamp(v);return v*v*(3-2*v);};
  const gate=(t,a=.2,b=7.7)=>smooth((t-a)/.2)*smooth((b-t)/.3);
  const hex=rgb=>'#'+rgb.map(v=>Math.max(0,Math.min(255,Math.round(v))).toString(16).padStart(2,'0')).join('');
  const packed=a=>a.map(rgba);
  const blank=Array.from({length:w*h},()=>[0,0,0,0]);
  const display=(pixel,i)=>{const bg=(i%w+Math.floor(i/w))%2?235:248;return pixel.slice(0,3).map(v=>Math.min(255,Math.round(v+bg*(1-pixel[3]/255))));};
  function text(value,x,y,size=22,color=C.ink,parent=scene){const key=id('text');textIds.push(key);textPolicies[key]={standalone:true};return parent.text({id:key,text:value,point:p(x,y),size,font:'Pretendard',align:[0,.5],fill:color,layer:80});}
  function rect(parent,x,y,ww,hh,fill,stroke='#00000000',layer=10,strokeWidth=1){const key=id('rect'),handle=parent.rectangle({id:key,center:p(x+ww/2,y+hh/2),size:[ww/100,hh/100],fill,stroke,width:strokeWidth,layer});owners.set(handle,key);return handle;}
  function line(a,b,color=C.grid,width=1,parent=scene,layer=40){return parent.line({id:id('line'),from:p(...a),to:p(...b),stroke:color,width,layer});}
  function arrow(a,b,color=C.blue,parent=scene){return parent.arrow({id:id('arrow'),from:p(...a),to:p(...b),stroke:color,width:4.5,tip:12,layer:50});}
  function animated(parent,phase,state){const sample=t=>state((t+phase)%8),initial=sample(0);const g=parent.group({id:id('motion'),opacity:initial.opacity??1,...(initial.transform?{matrix:initial.transform}:{})});tracks.push({target:g,state:sample});return g;}
  function loop(phase){return animated(scene,phase,t=>({opacity:still?0:gate(t)}));}
  function bitmap(parent,x,y,ww,rows,pixels,layer){
    parent.image({id:id('pixels'),center:p(x+ww/2,y+rows*ww/w/2),width:ww/100,size:[w,rows],pixels:pixels.map((pixel,i)=>hex(display(pixel,i))),filter:'nearest',layer});
  }
  function grid(x,y,pixels,label,{u=18,verify=true}={}){
    const ww=w*u,hh=h*u;imageRegions.push({x,y,width:ww,height:hh});text(label,x,y-27,22);
    bitmap(scene,x,y,ww,h,pixels,10);
    if(verify)pixels.forEach((pixel,i)=>pixelChecks.push({x:x+i%w*u+u/2,y:y+Math.floor(i/w)*u+u/2,rgb:display(pixel,i)}));
    for(let i=1;i<w;i++)line([x+i*u,y],[x+i*u,y+hh],C.bg,2,scene,35);
    for(let i=1;i<h;i++)line([x,y+i*u],[x+ww,y+i*u],C.bg,2,scene,35);
    rect(scene,x,y,ww,hh,'#00000000',C.grid,35,1);
    return {x,y,u,ww,hh,pixels};
  }
  function rleGrid(x,y,spans,label,{u=18,phase=0,reveal=false,scanRows=Array.from({length:h},(_,i)=>i)}={}){
    const g=grid(x,y,Array.from({length:w*h},()=>[255,255,255,255]),label,{u,verify:false});
    const colors=Array(w*h).fill(255),rows=new Map();
    for(const [sx,sy,len,coverage] of spans){
      if(!rows.has(sy))rows.set(sy,reveal?animated(scene,phase,t=>({opacity:still?1:1-gate(t)*(1-smooth((t-(.8+scanRows.indexOf(sy)*4.9/Math.max(1,scanRows.length-1)))/.2))})):scene);
      const parent=rows.get(sy),shade=255-Math.floor(coverage*195/255),key=id('span');
      const bx=x+(sx+.5)*u,by=y+(sy+.5)*u,ex=bx+(len-1)*u;
      colors[sy*w+sx]=shade;
      rect(parent,bx-u/2+1,by-u/2+1,u-2,u-2,hex([shade,shade,shade]),C.grid,40,1);
      if(len>1){
        parent.line({id:key+'-len',from:p(bx,by),to:p(ex,by),stroke:'#526579',width:2.5,layer:45});
        parent.line({id:key+'-end',from:p(ex,by-u*.16),to:p(ex,by+u*.16),stroke:'#526579',width:1.5,layer:45});
      }
      spanChecks.push({key,len,bx,by,ex});
    }
    // Sample away from the center line, preserving coverage as pixel intensity.
    colors.forEach((shade,i)=>pixelChecks.push({x:x+i%w*u+u*.25,y:y+Math.floor(i/w)*u+u*.25,rgb:[shade,shade,shade]}));
    return g;
  }
  function regionBox(g,b,parent=scene,color=C.orange){return rect(parent,g.x+b[0]*g.u,g.y+b[1]*g.u,(b[2]-b[0])*g.u,(b[3]-b[1])*g.u,'#00000000',color,55,3.5);}
  function scan(g,phase,{rows=Array.from({length:h},(_,i)=>i),start=.8,end=5.7,parent=loop(phase)}={}){
    const cursor=animated(parent,phase,t=>{const k=clamp((t-start)/(end-start))*(rows.length-1),a=Math.floor(k),b=Math.min(rows.length-1,a+1);return {transform:matrix(0,-(rows[a]+(rows[b]-rows[a])*(k-a))*g.u/100),opacity:gate(t,start-.2,end+.5)};});
    rect(cursor,g.x,g.y,g.ww,g.u,'#00000000',C.blue,65,3.5);
  }
  function write(g,phase,{rows=Array.from({length:h},(_,i)=>i),start=.8,end=5.7,initial,scanCursor=true,hold=false}={}){
    // Keep completed row images in place; fading to a full bitmap can shift sampling.
    const parent=hold?scene.group({id:id('write'),opacity:still?0:1}):loop(phase);
    rect(parent,g.x,g.y,g.ww,g.hh,C.bg,'#00000000',20);
    if(initial)bitmap(parent,g.x,g.y,g.ww,h,initial,21);
    for(let y=0;y<h;y++){
      const rank=rows.indexOf(y),at=start+rank*(end-start)/Math.max(1,rows.length-1);
      const row=rank<0?parent:animated(parent,phase,t=>({opacity:smooth((t-at)/.2)}));
      // Flatten using the original canvas row so checkerboard parity is stable.
      const values=g.pixels.slice(y*w,(y+1)*w).map((v,x)=>[...display(v,y*w+x),255]);
      bitmap(row,g.x,g.y+y*g.u,g.ww,1,values,25);
    }
    if(scanCursor)scan(g,phase,{rows,start,end,parent});
  }
  function node(x,y,ww,hh,labels,{dark=false,size=20}={}){
    hh=Math.max(hh,labels.length===3?128:labels.length>1?86:60);
    const box=rect(scene,x,y,ww,hh,dark?C.ink:'#ffffff',C.ink,10,1.5);
    labels.forEach((label,i)=>{text(label,x+15,y+hh/2+(i-(labels.length-1)/2)*32,size,dark?'#ffffff':C.ink);textPolicies[textIds.at(-1)]={owner:owners.get(box),inset:12};});
    return {x,y,w:ww,h:hh};
  }
  function scope(x,y,ww,hh,title){
    const box=rect(scene,x,y,ww,hh,'#00000000',C.ink,4,1.8);
    text(title,x+16,y+27,22);textPolicies[textIds.at(-1)]={owner:owners.get(box),inset:12};
    return {x,y,w:ww,h:hh};
  }
  function route(points,color=C.muted){return scene.route({id:id('route'),points:points.map(q=>p(...q)),stroke:color,width:2.5,tip:10,layer:7});}
  function down(a,b){scene.arrow({id:id('call-arrow'),from:p(a.x+a.w/2,a.y+a.h+3),to:p(b.x+b.w/2,b.y-4),stroke:C.muted,width:3.2,tip:6,layer:7});}
  const violet='#7953a5',green='#23a064',bands=[145,735,1145,1645,2115,2665],phases=[.4,1.5,2.6,3.7,4.8,6.0];
  function section(index,title){
    const y=bands[index],end=bands[index+1]??3160;
    line([445,y],[1400,y]);text(`${String(index+1).padStart(2,'0')}  ${title}`,460,y+28,23,C.muted);
    regions.push({name:title,x:455,y:y+65,w:960,h:end-y-80});beats.push({time:index*1.2,label:title});return y;
  }
  function circle(x,y,r,color,parent=scene,fill='#00000000'){
    return parent.circle({id:id('shape-circle'),center:p(x,y),radius:r/100,fill,stroke:color,width:3.5,layer:40});
  }
  function field(x,y,label,width=240){node(x,y,width,60,[label],{size:20});}
  // Copy a retained reference or captured task context along its dependency.
  function handleCopy(from,to,phase,start,end,color=violet){
    const g=animated(loop(phase),phase,t=>{const z=smooth((t-start)/(end-start));return {transform:matrix((to[0]-from[0])*z/100,-(to[1]-from[1])*z/100),opacity:gate(t,start-.2,end+.7)};});
    rect(g,from[0]-7,from[1]-7,14,14,color,'#00000000',65);
  }
  function finish(){
  if(still)scene.wait(8);
  else{
    const previous=tracks.map(({state})=>state(0));
    for(let k=1;k<=96;k++){
      const changes=[];
      tracks.forEach(({target,state},i)=>{const next=state(k/12),changed={};for(const key of Object.keys(next))if(JSON.stringify(next[key])!==JSON.stringify(previous[i][key]))changed[key]=next[key];if(Object.keys(changed).length)changes.push({target,...changed});previous[i]=next;});
      if(changes.length)scene.play(changes,1/12,'linear');else scene.wait(1/12);
    }
  }
  return {scene,textIds,textPolicies,regions,imageRegions,pixelChecks,spanChecks,beats};
  }
  return {C,scene,width,height,w,h,p,id,matrix,clamp,smooth,gate,hex,packed,blank,display,text,rect,line,arrow,animated,loop,grid,rleGrid,regionBox,scan,write,node,scope,route,down,violet,green,bands,phases,section,circle,field,handleCopy,finish};
}
