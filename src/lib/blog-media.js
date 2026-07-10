const attribute = (tag, name) =>
  tag.match(new RegExp(`${name}\\s*=\\s*(["'])(.*?)\\1`, 'i'))?.[2]?.trim() ?? '';

const typeForImage = (src) => /\.(?:json|lottie)(?:[?#]|$)/i.test(src)
  ? 'lottie'
  : /\.gif(?:[?#]|$)/i.test(src)
    ? 'gif'
    : 'image';

const baseUrl = (base = '/') => {
  if (!base || base === '/') return '/';
  return base.endsWith('/') ? base : `${base}/`;
};

const withBase = (src, base = '/') => {
  const cleanBase = baseUrl(base);
  const cleanSrc = src.replace(/^\/+/, '');
  return `${cleanBase}${cleanSrc}`;
};

const isExternal = (src = '') => /^[a-z][a-z\d+.-]*:/i.test(src) || src.startsWith('//') || src.startsWith('#');

const splitUrl = (src = '') => {
  const match = src.match(/^([^?#]*)([?#].*)?$/);
  return { pathname: match?.[1] ?? src, suffix: match?.[2] ?? '' };
};

const normalizeParts = (parts) => {
  const output = [];
  for (const part of parts) {
    if (!part || part === '.') continue;
    if (part === '..') {
      if (!output.length) return null;
      output.pop();
      continue;
    }
    output.push(part);
  }
  return output.join('/');
};

const postDirectory = (postId = '') => postId.split('/').slice(0, -1).join('/');

export function resolveBlogMediaUrl(src = '', postId = '', base = '/') {
  if (!src || isExternal(src)) return src;
  if (src.startsWith('/')) return withBase(src, base);

  const { pathname, suffix } = splitUrl(src);
  const normalized = normalizeParts([...postDirectory(postId).split('/'), ...pathname.split('/')]);
  if (!normalized) return src;
  return withBase(`blog-assets/${normalized}${suffix}`, base);
}

export function resolveBlogMediaUrlFromFile(src = '', filePath = '', base = '/') {
  if (!src || isExternal(src) || src.startsWith('/')) return resolveBlogMediaUrl(src, '', base);

  const normalizedPath = filePath.split('\\').join('/');
  const relativeFile = normalizedPath.split('/src/content/blog/').pop() ?? '';
  const postId = relativeFile.replace(/\.(?:md|mdx)$/i, '');
  return resolveBlogMediaUrl(src, postId, base);
}

export function extractFirstMedia(body = '') {
  const source = body
    .replace(/(`{3,}|~{3,})[\s\S]*?\1/g, (block) => ' '.repeat(block.length))
    .replace(/(`+)[^`\n]*\1/g, (code) => ' '.repeat(code.length));
  const candidates = [];

  for (const match of source.matchAll(/<lottie-player\b[^>]*>/gi)) {
    const src = attribute(match[0], 'src');
    if (src) candidates.push({ index: match.index ?? 0, type: 'lottie', src, alt: attribute(match[0], 'aria-label') });
  }

  for (const match of source.matchAll(/<img\b[^>]*>/gi)) {
    const src = attribute(match[0], 'src');
    if (src) candidates.push({ index: match.index ?? 0, type: typeForImage(src), src, alt: attribute(match[0], 'alt') });
  }

  for (const match of source.matchAll(/!\[([^\]]*)\]\(\s*([^\s)]+)(?:\s+[^)]*)?\)/g)) {
    const src = match[2];
    candidates.push({ index: match.index ?? 0, type: typeForImage(src), src, alt: match[1].trim() });
  }

  const first = candidates.sort((a, b) => a.index - b.index)[0];
  return first ? { type: first.type, src: first.src, alt: first.alt } : null;
}
