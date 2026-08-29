import { readFileSync } from 'node:fs';
import path from 'node:path';

const manifestPath = path.resolve(process.cwd(), 'public/blog-thumbnails/manifest.json');
let manifest;

export const blogThumbnailKey = (postId, source) =>
  `${postId.toLowerCase()}|${source}`;

const loadManifest = () => {
  if (manifest) return manifest;

  try {
    manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));
  } catch {
    manifest = {};
  }
  return manifest;
};

export function resolveBlogThumbnail(postId, media, base = '/') {
  if (!media || media.type === 'lottie') return null;

  const fileName = loadManifest()[blogThumbnailKey(postId, media.src)];
  if (!fileName) return null;

  const normalizedBase = base.endsWith('/') ? base : `${base}/`;
  return `${normalizedBase}blog-thumbnails/${fileName}`;
}
