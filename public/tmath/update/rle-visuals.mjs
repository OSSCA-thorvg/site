import {tmath} from '../runtime/client.js';
export const C={ink:'#202020',muted:'#707070',grid:'#cccccc',paper:'#f2f2f2',white:'#ffffff',orange:'#df792b',blue:'#3f7cce'};
export function lesson(prefix,title) {
  const width=1200,height=800,scene=tmath.scene({width,height,fps:30,loop:false,camera:{mode:'fixed',view:'2d',height:8},
    theme:{preset:'pro_white',background:C.paper,text:Object.fromEntries(['h1','h2','h3','text','code'].map(role=>[role,{font:'Pretendard',color:C.ink}]))}});
  const textIds=[],textPolicies={},beats=[];let seq=0,time=0;
  const id=name=>`${prefix}-${name}-${seq++}`,p=(x,y)=>[(x-600)/100,(400-y)/100];
  const group=()=>scene.group({id:id('group')});
  const text=(parent,value,x,y,size=23,color=C.ink,align=.5)=>{
    const key=id('text');textIds.push(key);textPolicies[key]={standalone:true};
    return parent.text({id:key,text:String(value),point:p(x,y),font:'Pretendard',role:'text',size,fill:color,align:[align,.5],layer:50});
  };
  const rect=(parent,x,y,w,h,fill='#00000000',stroke=C.ink,line=1.4,layer=15)=>parent.rectangle({id:id('rect'),center:p(x,y),size:[w/100,h/100],fill,stroke,width:line,layer});
  const line=(parent,x,y,xx,yy,color=C.ink,width=1.5,dash,layer=25)=>parent.line({id:id('line'),from:p(x,y),to:p(xx,yy),stroke:color,width,...(dash?{dash}:{}),layer});
  const arrow=(parent,x,y,xx,yy,color=C.ink,width=1.6,dash)=>parent.arrow({id:id('arrow'),from:p(x,y),to:p(xx,yy),stroke:color,width,tip:9,...(dash?{dash}:{}),layer:25});
  const wait=d=>{scene.wait(d);time+=d;};
  const show=(object,d=.4)=>{scene.fadeIn(object,{duration:d,curve:'ease_out'});time+=d;};
  const hide=(object,d=.25)=>{scene.fadeOut(object,{duration:d,curve:'ease_in'});time+=d;};
  const play=(actions,d=.6)=>{scene.play(actions,d,'linear');time+=d;};
  const create=(object,d=.7)=>{scene.create(object,d,'linear');time+=d;};
  const beat=(label,hold=.9)=>{beats.push({time,label});wait(hold);};
  const finish=data=>({scene,beats,textIds,textPolicies,duration:time,data});
  text(scene,title,600,42,30);line(scene,45,80,1155,80,C.grid,1);
  return {scene,p,id,group,text,rect,line,arrow,wait,show,hide,play,create,beat,finish};
}
export function pathGrid(v,input,{left=70,top=180,step=70,rows=6,columns=7}={}) {
  const {group,p,id,line,text}=v,base=group();
  const at=([x,y])=>[left+x*step,top+y*step];
  for(let x=0;x<=columns;x++){line(base,left+x*step,top,left+x*step,top+rows*step,C.grid,1);text(base,x,left+x*step,top-20,16,C.muted);}
  for(let y=0;y<=rows;y++){line(base,left,top+y*step,left+columns*step,top+y*step,C.grid,1);text(base,y,left-22,top+y*step,16,C.muted);}
  const [a,b,c,d,e]=input.points;
  const shape=base.path({id:id('outline'),commands:[{type:'move',to:p(...at(a))},{type:'line',to:p(...at(b))},{type:'cubic',control1:p(...at(c)),control2:p(...at(d)),to:p(...at(e))},{type:'close'}],fill:'#df792b12',stroke:C.ink,width:2.2,layer:20});
  return {base,shape,at,left,top,step};
}
export function gray(coverage) {const v=Math.round(242-(242-32)*coverage/255).toString(16).padStart(2,'0');return '#'+v+v+v;}
