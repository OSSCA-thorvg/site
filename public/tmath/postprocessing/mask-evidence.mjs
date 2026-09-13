import {compositeTerms} from './native-evidence.mjs';

// _rasterDirectMattedImage: combine group opacity with the stored mask byte,
// then scale the premultiplied source before adding the Canvas remainder.
export function maskCompositeTerms(source, destination, maskAlpha, groupOpacity) {
  const effectiveOpacity = (groupOpacity * maskAlpha + 255) >> 8;
  return {maskAlpha, groupOpacity, effectiveOpacity,
    ...compositeTerms(source, destination, effectiveOpacity)};
}
