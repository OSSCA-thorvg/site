// ThorVG PR #4797, commit 1b96000210eda02e12f2a59fac140e08d449f2bb.
// Arithmetic port: MIT, ThorVG project; see ../runtime/LICENSE-ThorVG.txt.
export const commit='1b96000210eda02e12f2a59fac140e08d449f2bb';
export const channels=['A','C1','C2','C3'];
export const byteChannels=['C3','C2','C1','A','C3','C2','C1','A'];
export const unpack=p=>[p>>>24,(p>>>16)&255,(p>>>8)&255,p&255];
export const pack=c=>((c[0]<<24)|(c[1]<<16)|(c[2]<<8)|c[3])>>>0;
export const hex=p=>'0x'+p.toString(16).padStart(8,'0').toUpperCase();
export const color=p=>'#'+unpack(p).slice(1).map(v=>v.toString(16).padStart(2,'0')).join('');
export function bitmap(w=72,h=48,stride=w){
 const pixels=Array(stride*h).fill(0);
 for(let y=0;y<h;y++)for(let x=0;x<w;x++){
  const u=(x+.5)*72/w,v=(y+.5)*48/h;
  let rgb=[232,243,251];
  if(v>=40)rgb=[197,209,216];
  if((u-59)**2+(v-9)**2<16)rgb=[230,97,33];
  if(u>=22&&u<50&&v>=23&&v<40)rgb=[31,102,196];
  if(v>=8&&v<24&&Math.abs(u-36)<(v-8)*19/16)rgb=[230,97,33];
  if(u>=27&&u<33&&v>=27&&v<33)rgb=[245,248,250];
  if(u>=40&&u<46&&v>=29&&v<40)rgb=[35,49,65];
  pixels[y*stride+x]=pack([255,...rgb]);
 }
 return {w,h,stride,pixels};
}
export function sample(image,{sx,sy,miny,maxy,n}){
 const minx=Math.max(0,Math.trunc(sx)-n),maxx=Math.min(image.w,Math.trunc(sx)+n),inc=Math.trunc(n/2)+1;
 const samples=[],sum=[0,0,0,0],lanes=Array(8).fill(0);
 for(let y=miny;y<maxy;y+=inc)for(let x=minx;x<maxx;x+=inc){
  const pixel=image.pixels[y*image.stride+x],values=unpack(pixel),bytes=[...values].reverse();
  values.forEach((v,i)=>sum[i]+=v);
  for(let i=0;i<8;i++)lanes[i]+=bytes[i%4];
  samples.push({x,y,pixel,values,bytes:[...bytes,...bytes],sum:[...sum],lanes:[...lanes]});
 }
 if(!samples.length)throw Error('Downscale input must contain a sample.');
 const means=sum.map(v=>Math.trunc(v/samples.length));
 return {sx,sy,minx,maxx,miny,maxy,n,inc,samples,sum,lanes,means,pixel:pack(means)};
}
const roundEven=v=>v%1===.5?(Math.floor(v)%2===0?Math.floor(v):Math.ceil(v)):Math.round(v);
export function downscale(image=bitmap(),scale=1/6){
 const f=Math.fround,s=f(scale),inverse=f(1/s),n=Math.max(1,Math.trunc(f(.5/s)));
 const w=Math.ceil(image.w*scale),h=Math.ceil(image.h*scale),outputs=[];
 for(let y=0;y<h;y++)for(let x=0;x<w;x++){
  const sx=f(f(x*inverse)-f(.49)),sy=f(f(y*inverse)-f(.49)),my=roundEven(sy);
  outputs.push({x,y,...sample(image,{sx,sy,miny:Math.max(0,my-n),maxy:Math.min(image.h,my+n),n})});
 }
 return {image,w,h,scale:s,n,outputs};
}
export const example=downscale();
export const focus=example.outputs.find(p=>p.x===5&&p.y===3);
