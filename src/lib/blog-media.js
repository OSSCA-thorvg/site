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
  const unfenced = body.replace(/(`{3,}|~{3,})[\s\S]*?\1/g, (block) => ' '.repeat(block.length));
  const source = unfenced.replace(/(`+)[^`\n]*\1/g, (code) => ' '.repeat(code.length));
  const candidates = [];
  const imports = new Map([...unfenced.matchAll(/^import\s+(\w+)\s+from\s+['"]([^'"]+)['"]/gm)]
    .map((match) => [match[1], match[2]]));
  // Resolve only declarative MDX forms. Never execute article expressions.
  const mediaAttribute = (tag, name) => {
    const literal = attribute(tag, name);
    if (literal) return literal;
    const expression = tag.match(new RegExp(`\\b${name}\\s*=\\s*\\{([\\s\\S]*?)\\}(?=\\s|/?>)`))?.[1]?.trim();
    if (!expression) return '';
    const quoted = expression.match(/^(['"])(.*?)\1$/);
    if (quoted) return quoted[2];
    const based = expression.match(/^import\.meta\.env\.BASE_URL\s*\+\s*(['"])(.*?)\1$/);
    if (based) return '/' + based[2].replace(/^\/+/, '');
    const template = expression.match(/^`\$\{import\.meta\.env\.BASE_URL\}([^`$]*)`$/);
    if (template) return '/' + template[1].replace(/^\/+/, '');
    const imported = expression.match(/^(\w+)(?:\.src)?$/);
    return imported ? imports.get(imported[1]) ?? '' : '';
  };

  for (const match of unfenced.matchAll(/<TMathPlayer\b[\s\S]*?\/>/g)) {
    if (source[match.index] !== '<') continue; // Inline code example.
    const tag = match[0];
    const scene = mediaAttribute(tag, 'scene');
    const explicitPoster = /\bposter\s*=/.test(tag);
    const src = mediaAttribute(tag, 'poster') || (!explicitPoster && scene ? defaultTMathPoster(scene) : '');
    if (!src) continue;
    const rawCrop = tag.match(/\bcrop\s*=\s*\{(\[[\d\s.,-]+\])\}/)?.[1];
    let crop;
    if (rawCrop) {
      try {
        const values = JSON.parse(rawCrop);
        if (values.length === 4 && values.every(Number.isInteger) && values[0] >= 0 && values[1] >= 0 && values[2] > 0 && values[3] > 0) crop = values;
      } catch { /* Ignore unsupported crop expressions. */ }
    }
    candidates.push({index: match.index, type: 'tmath', src,
      alt: mediaAttribute(tag, 'title') || mediaAttribute(tag, 'description'), ...(crop ? {crop} : {})});
  }

  for (const match of source.matchAll(/<lottie-player\b[^>]*>/gi)) {
    const src = mediaAttribute(match[0], 'src');
    if (src) candidates.push({ index: match.index ?? 0, type: 'lottie', src, alt: attribute(match[0], 'aria-label') });
  }

  for (const match of source.matchAll(/<img\b[^>]*>/gi)) {
    const src = mediaAttribute(match[0], 'src');
    if (src) candidates.push({ index: match.index ?? 0, type: typeForImage(src), src, alt: attribute(match[0], 'alt') });
  }

  for (const match of source.matchAll(/!\[([^\]]*)\]\(\s*([^\s)]+)(?:\s+[^)]*)?\)/g)) {
    const src = match[2];
    candidates.push({ index: match.index ?? 0, type: typeForImage(src), src, alt: match[1].trim() });
  }

  const first = candidates.sort((a, b) => a.index - b.index)[0];
  if (!first) return null;
  const {index, ...media} = first;
  return media;
}
import { defaultTMathPoster } from './tmath-media.js';
