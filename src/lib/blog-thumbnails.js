import { readFileSync, statSync } from 'node:fs';
import path from 'node:path';

const manifestPath = path.resolve(process.cwd(), 'public/blog-thumbnails/manifest.json');
let manifest;
let manifestVersion;

export const blogThumbnailKey = (postId, source) =>
  `${postId.toLowerCase()}|${source}`;

const loadManifest = () => {
  try {
    const {mtimeMs, size} = statSync(manifestPath);
    const version = `${mtimeMs}:${size}`;
    if (manifest && manifestVersion === version) return manifest;
    manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));
    manifestVersion = version;
  } catch {
    manifest = {};
    manifestVersion = undefined;
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
