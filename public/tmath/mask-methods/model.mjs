import native,{variant,commit} from './native-trace.mjs';
export {native,variant,commit};
export const rgba=p=>[p&255,(p>>>8)&255,(p>>>16)&255,p>>>24];
export const mul=(a,b)=>(a*b+255)>>8;
export const attenuate=(c,q)=>(c*(q+1))>>8;
export const luma=p=>{const [r,g,b]=rgba(p);return (54*r+182*g+19*b)>>8;};
export const matteMethods=['Alpha','InvAlpha','Luma','InvLuma'];
export const combineMethods=['Add','Subtract','Intersect','Difference','Lighten','Darken'];
export const methods=[...matteMethods,...combineMethods];
export const operations={Add:(a,b)=>a+mul(b,255-a),Subtract:(a,b)=>mul(a,255-b),Intersect:mul,Difference:(a,b)=>mul(a,255-b)+mul(b,255-a),Lighten:Math.max,Darken:Math.min};
export const equations={Alpha:'q = b',InvAlpha:'q = 1 - b',Luma:'q = Y(B)',InvLuma:'q = 1 - Y(B)',Add:'q = a + b(1 - a)',Subtract:'q = a(1 - b)',Intersect:'q = ab',Difference:'q = a(1 - b) + b(1 - a)',Lighten:'q = max(a, b)',Darken:'q = min(a, b)'};
export const hex=c=>'#'+c.slice(0,3).map(v=>Math.max(0,Math.min(255,Math.round(v))).toString(16).padStart(2,'0')).join('');
export const display=(p,i,w)=>{const c=Array.isArray(p)?p:rgba(p),bg=(i%w+Math.floor(i/w))%2?244:231;return c.slice(0,3).map(v=>Math.min(255,Math.round(v+bg*(255-c[3])/255)));};
export const weightColor=q=>hex(Array(3).fill(255-Math.floor(q*195/255)));
export function model(trace=native){
  const {width:w,height:h,cases}=trace,N=w*h;
  for(const record of Object.values(cases))for(const task of [record.a,record.b].filter(Boolean)){
    const expanded=Array(N).fill(0);
    for(const [x,y,len,c] of task.spans){if(x<0||y<0||x+len>w||y>=h||len<1)throw Error('Out-of-bounds span');for(let j=0;j<len;j++)expanded[y*w+x+j]=c;}
    if(expanded.some((v,i)=>v!==task.coverage[i]))throw Error('Native RLE differs');
  }
  const a=cases.inputA.a.coverage.map(c=>mul(c,trace.alphaA));
  const b=cases.inputB.b.coverage.map(c=>mul(c,trace.alphaB));
  if(b.some((v,i)=>v!==cases.Alpha.buffers[0].pixels[i]))throw Error('B alpha differs from CPU');
  if(cases.inputB.pixels.some((v,i)=>v!==cases.Luma.buffers[0].pixels[i]))throw Error('B color differs from CPU');
  const y=cases.inputB.pixels.map(luma),source=cases.None.pixels.map(rgba),all={};
  for(const name of methods){
    const record=cases[name],q=name==='Alpha'?b:name==='InvAlpha'?b.map(v=>255-v):name==='Luma'?y:name==='InvLuma'?y.map(v=>255-v):a.map((v,i)=>operations[name](v,b[i]));
    if(combineMethods.includes(name)&&q.some((v,i)=>v!==record.buffers[0].pixels[i]))throw Error(name+' combined mask differs');
    const out=source.map((p,i)=>p.map(v=>attenuate(v,q[i])));
    if(record.pixels.some((p,i)=>rgba(p).some((v,k)=>v!==out[i][k])))throw Error(name+' output differs');
    if(!record.restored)throw Error('Compositor not restored');
    if(record.buffers.at(-1).pixels.some((v,i)=>v!==cases.None.pixels[i]))throw Error('Content group changed between methods');
    const expectedChannels=name.includes('Luma')?[4,4]:combineMethods.includes(name)?[1,1,4]:[1,4];
    if(JSON.stringify(record.buffers.map(b=>b.channels))!==JSON.stringify(expectedChannels))throw Error('Unexpected buffer types');
    all[name]={q,out,colors:out.map((p,i)=>hex(display(p,i,w))),weightColors:q.map(weightColor)};
  }
  const sample=a.findIndex((v,i)=>v===trace.alphaA&&b[i]===trace.alphaB);
  if(sample<0)throw Error('Missing overlap sample');
  return {trace,w,h,a,b,y,source,all,sample,point:[sample%w,Math.floor(sample/w)],sampleA:a[sample],sampleB:b[sample],sampleY:y[sample],sampleBColor:rgba(cases.inputB.pixels[sample]),
    inputs:Object.fromEntries(['None','inputA','inputB'].map(k=>[k,cases[k].pixels.map((p,i)=>hex(display(p,i,w)))]))};
}
