import { createHash } from 'node:crypto';
import { access, mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import sharp from 'sharp';

import { extractFirstMedia } from '../src/lib/blog-media.js';
import { blogThumbnailKey } from '../src/lib/blog-thumbnails.js';
import { extractFirstImage, groupHackathons } from '../src/lib/hackathon.js';
import {
  HACKATHON_THUMBNAIL_HEIGHT,
  HACKATHON_THUMBNAIL_WIDTH,
  thumbnailFileName,
} from '../src/lib/hackathon-images.js';

const projectDirectory = fileURLToPath(new URL('../', import.meta.url));
const publicDirectory = path.join(projectDirectory, 'public');
const blogContentDirectory = path.join(projectDirectory, 'src/content/blog');
const blogOutputDirectory = path.join(publicDirectory, 'blog-thumbnails');
const hackathonOutputDirectory = path.join(publicDirectory, 'hackathon-thumbnails');
const concurrency = 6;

const exists = async (filePath) => {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
};

const isInside = (root, candidate) =>
  candidate === root || candidate.startsWith(`${root}${path.sep}`);

const collectBlogDocuments = async (directory = blogContentDirectory) => {
  const entries = await readdir(directory, { withFileTypes: true });
  const documents = [];

  for (const entry of entries) {
    const filePath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      documents.push(...await collectBlogDocuments(filePath));
    } else if (entry.isFile() && /\.(?:md|mdx)$/i.test(entry.name)) {
      documents.push(filePath);
    }
  }

  return documents;
};

const localBlogMediaPath = (documentPath, source) => {
  if (/^[a-z][a-z\d+.-]*:/i.test(source) || source.startsWith('//')) return null;

  try {
    const pathname = decodeURIComponent(source.split(/[?#]/, 1)[0]);
    const root = source.startsWith('/') ? publicDirectory : blogContentDirectory;
    const candidate = source.startsWith('/')
      ? path.resolve(publicDirectory, pathname.replace(/^\/+/, ''))
      : path.resolve(path.dirname(documentPath), pathname);
    return isInside(root, candidate) ? candidate : null;
  } catch {
    return null;
  }
};

const blogJobs = async () => {
  const jobs = [];

  for (const documentPath of await collectBlogDocuments()) {
    const body = await readFile(documentPath, 'utf8');
    const media = extractFirstMedia(body);
    if (!media || media.type === 'lottie' || /\.svg(?:[?#]|$)/i.test(media.src)) continue;

    const relativePath = path.relative(blogContentDirectory, documentPath).split(path.sep).join('/');
    const postId = relativePath.replace(/\.(?:md|mdx)$/i, '');
    const localPath = localBlogMediaPath(documentPath, media.src);
    const sourceUrl = /^https?:\/\//i.test(media.src)
      ? media.src
      : media.src.startsWith('//')
        ? `https:${media.src}`
        : null;
    if (!localPath && !sourceUrl) continue;

    let fingerprint;
    try {
      fingerprint = localPath ? await readFile(localPath) : sourceUrl;
    } catch (error) {
      console.warn(
        `[blog-thumbnails] uses the original image for ${postId}: ${error?.message ?? error}`
      );
      continue;
    }
    const fileName = `${createHash('sha256').update(fingerprint).digest('hex').slice(0, 12)}.webp`;
    jobs.push({
      key: blogThumbnailKey(postId, media.src),
      fileName,
      outputPath: path.join(blogOutputDirectory, fileName),
      localPath,
      sourceUrl,
    });
  }

  return jobs;
};

const hackathonJobs = async () => {
  const data = JSON.parse(
    await readFile(path.join(projectDirectory, 'src/data/live-hackathon.json'), 'utf8')
  );

  return groupHackathons(data.issues).flatMap((event) => event.projects).flatMap((project) => {
    const sourceUrl = extractFirstImage(project.body);
    if (!sourceUrl) return [];
    const fileName = thumbnailFileName(project.number, sourceUrl);
    return [{
      fileName,
      outputPath: path.join(hackathonOutputDirectory, fileName),
      sourceUrl,
    }];
  });
};

const loadSource = async ({ localPath, sourceUrl }) => {
  if (localPath) return readFile(localPath);

  const response = await fetch(sourceUrl, {
    headers: { Accept: 'image/*', 'User-Agent': 'OSSCA-ThorVG-site' },
    signal: AbortSignal.timeout(30_000),
  });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return Buffer.from(await response.arrayBuffer());
};

const optimize = async (job) => {
  if (await exists(job.outputPath)) return 'cached';

  const source = await loadSource(job);
  await sharp(source, { animated: false })
    .rotate()
    .resize(HACKATHON_THUMBNAIL_WIDTH, HACKATHON_THUMBNAIL_HEIGHT, {
      fit: 'cover',
      position: 'centre',
    })
    .webp({ quality: 72 })
    .toFile(job.outputPath);
  return 'generated';
};

const optimizeGroup = async (label, outputDirectory, jobs) => {
  await mkdir(outputDirectory, { recursive: true });
  const uniqueJobs = [...new Map(jobs.map((job) => [job.outputPath, job])).values()];
  const results = new Map();
  const totals = { generated: 0, cached: 0, failed: 0 };

  const run = async (job) => {
    try {
      const status = await optimize(job);
      totals[status] += 1;
      results.set(job.outputPath, true);
    } catch (error) {
      totals.failed += 1;
      results.set(job.outputPath, false);
      console.warn(`[${label}] uses the original image: ${error?.message ?? error}`);
    }
  };

  for (let index = 0; index < uniqueJobs.length; index += concurrency) {
    await Promise.all(uniqueJobs.slice(index, index + concurrency).map(run));
  }

  console.log(
    `[${label}] generated ${totals.generated}, cached ${totals.cached}, failed ${totals.failed}`
  );
  return results;
};

const blogs = await blogJobs();
const blogResults = await optimizeGroup('blog-thumbnails', blogOutputDirectory, blogs);
const manifest = Object.fromEntries(
  blogs
    .filter((job) => blogResults.get(job.outputPath))
    .map((job) => [job.key, job.fileName])
);
await writeFile(
  path.join(blogOutputDirectory, 'manifest.json'),
  `${JSON.stringify(manifest, null, 2)}\n`
);

await optimizeGroup(
  'hackathon-thumbnails',
  hackathonOutputDirectory,
  await hackathonJobs()
);
