import { createHash } from 'node:crypto';
import { existsSync } from 'node:fs';
import path from 'node:path';

export const HACKATHON_THUMBNAIL_WIDTH = 640;
export const HACKATHON_THUMBNAIL_HEIGHT = 360;

const thumbnailDirectory = path.resolve(process.cwd(), 'public/hackathon-thumbnails');

export function thumbnailFileName(issueNumber, sourceUrl) {
  const hash = createHash('sha256').update(sourceUrl).digest('hex').slice(0, 12);
  return `${issueNumber}-${hash}.webp`;
}

export function resolveHackathonThumbnail(issueNumber, sourceUrl, base = '/') {
  if (!sourceUrl) return null;

  const fileName = thumbnailFileName(issueNumber, sourceUrl);
  const normalizedBase = base.endsWith('/') ? base : `${base}/`;
  const localSource = `${normalizedBase}hackathon-thumbnails/${fileName}`;

  return {
    src: existsSync(path.join(thumbnailDirectory, fileName)) ? localSource : sourceUrl,
    width: HACKATHON_THUMBNAIL_WIDTH,
    height: HACKATHON_THUMBNAIL_HEIGHT,
  };
}
