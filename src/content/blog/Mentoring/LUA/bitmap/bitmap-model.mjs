// Numerical model for the pinned opaque, normal-blend image demonstrations.
export function source(n,x,y){
 const u=(x+.5)/n,v=(y+.5)/n;
 let c=[75+Math.floor(v*40),136+Math.floor(v*30),174+Math.floor(v*20)];
 if((u-.73)**2+(v-.23)**2<.16**2)c=[235,174,65];
 if(v>.55+.16*Math.sin(5*u+1))c=[38,126,108];
 if(v>.75+.14*Math.sin(8*u))c=[32,67,109];
 if(n>8&&v>.8&&(x+y)%2)c=c.map(v=>v+24);
 return c;
}
export const point=(x,y,scale)=>[x/scale-.49,y/scale-.49];
const blend=(s,d,a)=>s.map((v,i)=>Math.floor(d[i]+(v-d[i])*a/256));
export function sample(n,x,y,scale,mode){
 const [u,v]=point(x,y,scale),rx=Math.max(0,Math.trunc(u)),ry=Math.max(0,Math.trunc(v));
 if(mode==='nearest')return source(n,rx,ry);
 if(mode==='mean'){
  const radius=Math.max(1,Math.trunc(.5/scale)),inc=Math.floor(radius/2)+1,my=Math.round(v);
  const colors=[];
  for(let sy=Math.max(0,my-radius);sy<Math.min(n,my+radius);sy+=inc)
   for(let sx=Math.max(0,Math.trunc(u)-radius);sx<Math.min(n,Math.trunc(u)+radius);sx+=inc)colors.push(source(n,sx,sy));
  return [0,1,2].map(ch=>Math.floor(colors.reduce((sum,c)=>sum+c[ch],0)/colors.length));
 }
 const ix=Math.min(n-1,rx+1),iy=Math.min(n-1,ry+1);
 const dx=u>0?Math.trunc((u-rx)*255):0,dy=v>0?Math.trunc((v-ry)*255):0;
 return blend(blend(source(n,ix,iy),source(n,rx,iy),dx),blend(source(n,ix,ry),source(n,rx,ry),dx),dy);
}
export function texColor(u,v){
 const x=Math.trunc(u),y=Math.trunc(v),ar=255-(Math.trunc(u*256)&255),ab=255-(Math.trunc(v*256)&255);
 let top=source(8,x,y),bottom=source(8,x,Math.min(y+1,7));
 if(x+1<8){top=blend(top,source(8,x+1,y),ar);bottom=blend(bottom,source(8,x+1,Math.min(y+1,7)),ar);}
 const c=y+1<8?blend(top,bottom,ab):top;
 return c; // Deliberately excludes edge feathering; the trace preserves XY/UV and triangle order.
}
