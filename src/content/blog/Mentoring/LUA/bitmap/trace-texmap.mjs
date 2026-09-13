// Extract the pinned scan converter and record its actual per-triangle XY/UV order.
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {execFileSync} from 'node:child_process';
const dir=path.dirname(fileURLToPath(import.meta.url));
const root=path.resolve(dir,'../../../../../..');
const temp=path.join(dir,'temp');await fs.mkdir(temp,{recursive:true});
const header=execFileSync('git',['-C',path.join(root,'thorvg'),'show','6cf10d47fbe13b45040f2c56feeafa0711f53b2b:src/renderer/cpu_engine/tvgSwRasterTexmap.h'],{encoding:'utf8'});
const converter=header.slice(header.indexOf('static void _rasterPolygonImage(TexmapCtx&'),header.indexOf('\n} //namespace'));
const prelude=`#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstdint>
struct Point {float x,y;};
struct Vertex {Point pt,uv;};
struct Polygon {Vertex vertex[3];};
struct RenderRegion {struct {int x,y;} min,max;};
struct SwSurface {};
struct TexmapCtx {SwSurface* surface; RenderRegion bbox; float dudx,dvdx,dxdya,dxdyb,dudya,dvdya,xa,xb,ua,va;};
namespace tvg {bool zero(float f){return std::abs(f)<1e-6f;} bool equal(float a,float b){return zero(a-b);}}
bool _compositing(SwSurface*){return false;} bool _blending(SwSurface*){return false;} bool _matting(SwSurface*){return false;}
int triangle=0; bool first=true;
void _rasterPolygonImageSegment(TexmapCtx& c,int start,int end,bool,bool){
 for(int y=std::max(start,c.bbox.min.y);y<std::min(end,c.bbox.max.y);y++){
  int x1=std::max(int(c.xa),c.bbox.min.x),x2=std::min(int(c.xb),c.bbox.max.x);
  float dx=1-(c.xa-x1),u=c.ua+dx*c.dudx,v=c.va+dx*c.dvdx;
  for(int x=x1;x<x2;x++){
   if(uint32_t(int(u))>=8||uint32_t(int(v))>=8) continue;
   printf("%s[%d,%d,%d,%.9g,%.9g]",first?"":",",triangle,x,y,u,v); first=false;
   u+=c.dudx;v+=c.dvdx;
  }
  c.xa+=c.dxdya;c.xb+=c.dxdyb;c.ua+=c.dudya;c.va+=c.dvdya;
 }
}
void _rasterMaskedPolygonImageSegment(TexmapCtx&,int,int,bool){}
void _rasterBlendingPolygonImageSegment(TexmapCtx&,int,int,bool){}
`;
const main=`int main(){
 Vertex vs[4]; float a=25*3.14159265358979323846f/180,co=cosf(a),si=sinf(a);
 float u[4]={0,8,8,0},v[4]={0,0,8,8};
 for(int i=0;i<4;i++)vs[i]={{18+3*(co*(u[i]-4)-si*(v[i]-4)),18+3*(si*(u[i]-4)+co*(v[i]-4))},{u[i],v[i]}};
 TexmapCtx ctx{};ctx.bbox={{0,0},{36,36}}; Polygon p;
 int ids[2][3]={{0,1,3},{1,2,3}};printf("[");
 for(triangle=0;triangle<2;triangle++){for(int j=0;j<3;j++)p.vertex[j]=vs[ids[triangle][j]];_rasterPolygonImage(ctx,p,true);}
 printf("]\\n");
}`;
const cpp=path.join(temp,'texmap-trace.cpp'),bin=path.join(temp,'texmap-trace');
await fs.writeFile(cpp,prelude+converter+main);
execFileSync('clang++',['-std=c++17','-O0',cpp,'-o',bin]);
const trace=JSON.parse(execFileSync(bin,{encoding:'utf8'}));
if(!trace.length||!trace.some(p=>p[0]===1))throw Error('Missing triangle');
const firstSecond=trace.findIndex(p=>p[0]===1);
if(trace.slice(firstSecond).some(p=>p[0]===0))throw Error('Triangle order');
await fs.writeFile(path.join(dir,'texmap-trace.json'),JSON.stringify(trace));
console.log(`Captured ${trace.length} samples: T0=${firstSecond}, T1=${trace.length-firstSecond}.`);
