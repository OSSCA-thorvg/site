import type {HostThemePalette} from '../../public/tmath/runtime/client';
import {tmathPalette} from '../lib/tmath-palette.js';

/** Canvas colors follow the same semantic tokens as the surrounding article. */
export function readTMathPalette(): HostThemePalette {
  const root = document.documentElement;
  const styles = getComputedStyle(root);
  return tmathPalette(token => styles.getPropertyValue(token), root.dataset.theme === 'dark');
}
