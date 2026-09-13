const decode = (value) => {
  try {
    return decodeURIComponent(value);
  } catch {
    return null;
  }
};

export function decodeFragment(hash = '') {
  const value = String(hash).replace(/^#/, '');
  return value ? decode(value) : null;
}

const normalizeTopic = (value) => {
  const decoded = decodeFragment(value);
  if (!decoded) return '';

  return decoded
    .normalize('NFKC')
    .toLocaleLowerCase('ko-KR')
    .replace(/^\d+(?:[.-]\d+)*[-._\s]+/u, '')
    .replace(/[^\p{Letter}\p{Number}]+/gu, '-')
    .replace(/^-+|-+$/g, '');
};

export function findHeadingAlias(fragment, headingIds = []) {
  const decoded = decodeFragment(fragment);
  if (!decoded) return null;
  if (headingIds.includes(decoded)) return decoded;

  const prefix = `${decoded}-`;
  const matches = headingIds.filter((id) => id.startsWith(prefix));
  return matches.length === 1 ? matches[0] : null;
}

export function findNavigationTarget(fragment, links = []) {
  const topic = normalizeTopic(fragment);
  if (!topic) return null;

  const matches = links.filter(({ label, href }) => href && normalizeTopic(label) === topic);
  return matches.length === 1 ? matches[0].href : null;
}
