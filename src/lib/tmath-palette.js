/**
 * @param {(token: string) => string} readToken
 * @param {boolean} dark
 * @returns {import('../../public/tmath/runtime/client').HostThemePalette}
 */
export function tmathPalette(readToken, dark = false) {
  const color = (...tokens) => {
    for (const token of tokens) {
      const value = readToken(token).trim();
      if (/^#[\da-f]{3}$/i.test(value)) {
        return `#${[...value.slice(1)].map(channel => channel + channel).join('')}`.toLowerCase();
      }
      if (value) return value.toLowerCase();
    }
    throw new Error(`Missing animation theme token: ${tokens.join(', ')}`);
  };
  const accent = color('--animation-accent', '--primary');
  const azure = color('--animation-info', '--cat-azure');
  const violet = color('--cat-violet');
  const teal = color('--animation-success', '--cat-teal');
  const amber = color('--animation-warning', '--cat-amber');
  return {
    dark,
    background: color('--animation-canvas', '--canvas'),
    foreground: color('--animation-ink', '--ink'),
    muted: color('--animation-muted', '--ink-subtle'),
    accent,
    secondary: violet,
    success: teal,
    warning: amber,
    danger: color('--status-closed'),
    info: azure,
    surface: color('--animation-surface', '--surface-1'),
    line: color('--animation-line', '--hairline'),
    result: teal,
    focus: accent,
    objects: [azure, violet, teal, amber, accent],
  };
}
