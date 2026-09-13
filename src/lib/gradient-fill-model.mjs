// Educational floating-point reconstruction of ThorVG 8c94c1f05.
// Pixel colors approximate the packed integer LUT/blend arithmetic.
export const stops = [
  {offset:0, rgb:[209,55,65]}, {offset:.34, rgb:[234,150,42]},
  {offset:.68, rgb:[24,158,164]}, {offset:1, rgb:[42,77,173]},
];
export const mix = (a,b,t) => a.map((v,i)=>v*(1-t)+b[i]*t);
export const wrap = t => t-Math.floor(t);
export function color(t) {
  t=Math.max(0,Math.min(1,t));
  const i=Math.min(2,stops.findIndex((_,j)=>j<3 && t<=stops[j+1].offset));
  const a=stops[i],b=stops[i+1];
  return mix(a.rgb,b.rgb,(t-a.offset)/(b.offset-a.offset));
}
export function prepare(angle=27,rotation=0,sx=1,sy=1) {
  const r=rotation*Math.PI/180,a=angle*Math.PI/180;
  // inverse of rotation * scale; translation is handled at the sample center.
  const a11=Math.cos(r)/sx,a12=Math.sin(r)/sx,a21=-Math.sin(r)/sy,a22=Math.cos(r)/sy;
  const seam=[Math.cos(a),Math.sin(a)],normal=[-seam[1],seam[0]];
  const dFdx=normal[0]*a11+normal[1]*a21,dFdy=normal[0]*a12+normal[1]*a22;
  const fwidth=Math.abs(dFdx)+Math.abs(dFdy);
  const invFwidth=Math.abs(dFdx)<1e-6||Math.abs(dFdy)<1e-6?0:1/fwidth;
  return {angle,a11,a12,a21,a22,seam,normal,fwidth,invFwidth,
    distanceDx:dFdx*invFwidth,seamProjectionDx:seam[0]*a11+seam[1]*a21};
}
export function sample(p,x,y) {
  const rx=p.a11*x+p.a12*y,ry=p.a21*x+p.a22*y;
  const t=wrap(Math.atan2(ry,rx)/(2*Math.PI)-p.angle/360);
  return {rx,ry,t,index:Math.floor(t*1023+.5),
    distance:(p.normal[0]*rx+p.normal[1]*ry)*p.invFwidth,
    projection:p.seam[0]*rx+p.seam[1]*ry};
}
export function conicColor(p,x,y,mode='sw') {
  const q=sample(p,x,y);
  if(mode==='sw' && p.invFwidth>0 && Math.abs(q.distance)<.5 && q.projection>=0)
    return mix(stops[3].rgb,stops[0].rgb,q.distance+.5);
  // Deliberately fixed angular width for comparison, not ThorVG's conic path.
  if(mode==='lut') {
    const signed=q.t>.5?q.t-1:q.t;
    const margin=.028;
    if(Math.abs(signed)<margin) return mix(color(1-margin),color(margin),(signed+margin)/(2*margin));
  }
  return color(q.t);
}
export function aaRange(p,rx,ry,len) {
  if(p.invFwidth<=0||len===0)return {begin:0,end:0,distance:0};
  const distance=(p.normal[0]*rx+p.normal[1]*ry)*p.invFwidth;
  let begin=0,end=len;
  const dx=p.distanceDx;
  if(Math.abs(dx)<1e-6){if(distance<=-.5||distance>=.5)return {begin:0,end:0,distance:0};}
  else {
    let first=(-.5-distance)/dx,last=(.5-distance)/dx;
    if(first>last)[first,last]=[last,first];
    begin=Math.max(begin,Math.floor(first)+1);end=Math.min(end,Math.ceil(last));
  }
  const projection=rx*p.seam[0]+ry*p.seam[1],step=p.seamProjectionDx;
  if(Math.abs(step)<1e-6){if(projection<0)return {begin:0,end:0,distance:0};}
  else if(step>0)begin=Math.max(begin,Math.ceil(-projection/step));
  else end=Math.min(end,Math.floor(-projection/step)+1);
  return begin<end?{begin,end,distance:distance+begin*dx}:{begin:0,end:0,distance:0};
}
export function shapeRle(offsetX=0,offsetY=0) {
  const cols=28,rows=20,cx=13.3,cy=9.8;
  // A concave outline and an inner contour expose separate runs on one row.
  const contours=[
    [[3.25,2.25],[21.75,2.25],[25.25,5.75],[25.25,9.25],[21.25,9.25],[21.25,13.25],[25.25,13.25],[25.25,17.75],[3.25,17.75]],
    [[9.25,6.25],[16.75,6.25],[16.75,13.75],[9.25,13.75]],
  ].map(contour=>contour.map(([x,y])=>[x+offsetX,y+offsetY]));
  const inside=(x,y)=>{
    let filled=false;
    for(const contour of contours)for(let i=0,j=contour.length-1;i<contour.length;j=i++){
      const [ax,ay]=contour[i],[bx,by]=contour[j];
      if((ay>y)!==(by>y)&&x<(bx-ax)*(y-ay)/(by-ay)+ax)filled=!filled;
    }
    return filled;
  };
  const spans=[],pixels=[];
  for(let y=0;y<rows;y++) {
    let run;
    for(let x=0;x<cols;x++) {
      let hits=0;
      for(let sy=0;sy<8;sy++)for(let sx=0;sx<8;sx++)
        if(inside(x+(sx+.5)/8,y+(sy+.5)/8))hits++;
      const coverage=Math.round(hits/64*255);
      if(!coverage){run=undefined;continue;}
      if(run && run.x+run.len===x && run.coverage===coverage)run.len++;
      else {run={x,y,len:1,coverage,start:pixels.length};spans.push(run);}
      pixels.push({x,y,coverage,span:spans.length-1,i:x-run.x});
    }
  }
  return {cols,rows,cx,cy,spans,pixels};
}
