import {buildClippingOverview} from './clipping-overview.mjs';
import {buildMaskOverview} from './mask-overview.mjs';
import {buildViewportOverview} from './viewport-overview.mjs';
import {native} from './model.mjs';

export function buildOverview(kind,trace=native,options={}){
  if(kind==='clipping')return buildClippingOverview(trace,options);
  if(kind==='mask')return buildMaskOverview(trace,options);
  if(kind==='viewport')return buildViewportOverview(trace,options);
  throw Error('Unknown CPU feature '+kind);
}
