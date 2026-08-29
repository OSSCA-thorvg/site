import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const contentDir = fileURLToPath(new URL('../content/blog/', import.meta.url));
const mediaPattern = /\.(?:png|jpe?g|gif|webp|svg|json|lottie|pdf)$/i;

const contentTypes = {
  '.gif': 'image/gif',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.json': 'application/json',
  '.lottie': 'application/octet-stream',
  '.pdf': 'application/pdf',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
};

async function collectMediaFiles(dir = contentDir, prefix = '') {
  const entries = await readdir(dir, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const localPath = path.join(dir, entry.name);
    const relativePath = path.posix.join(prefix, entry.name);
    if (entry.isDirectory()) {
      files.push(...await collectMediaFiles(localPath, relativePath));
    } else if (entry.isFile() && mediaPattern.test(entry.name)) {
      files.push({ localPath, relativePath });
    }
  }

  return files;
}

async function copyBlogMediaAssets(outputDir) {
  const outRoot = path.join(fileURLToPath(outputDir), 'blog-assets');
  const files = await collectMediaFiles();

  for (const file of files) {
    const outputPath = path.join(outRoot, file.relativePath);
    await mkdir(path.dirname(outputPath), { recursive: true });
    await writeFile(outputPath, await readFile(file.localPath));
  }
}

export default function blogMediaAssets({ base = '/' } = {}) {
  const cleanBase = base.endsWith('/') ? base : `${base}/`;
  const prefixes = [...new Set(['/blog-assets/', `${cleanBase}blog-assets/`])];

  return {
    name: 'blog-media-assets',
    hooks: {
      'astro:server:setup': ({ server, logger }) => {
        server.watcher.add(contentDir);
        let reloadTimer;
        server.watcher.on('all', (event, filePath) => {
          if (
            ['add', 'change', 'unlink'].includes(event)
            && filePath.startsWith(contentDir)
            && mediaPattern.test(filePath)
          ) {
            clearTimeout(reloadTimer);
            reloadTimer = setTimeout(() => {
              logger.info(`Reloading after blog media update: ${path.relative(contentDir, filePath)}`);
              server.ws.send({ type: 'full-reload' });
            }, 150);
          }
        });

        server.middlewares.use(async (request, response, next) => {
          const pathname = decodeURIComponent(new URL(request.url ?? '/', 'http://localhost').pathname);
          const prefix = prefixes.find((candidate) => pathname.startsWith(candidate));
          if (!prefix) return next();

          const relativePath = path.posix.normalize(pathname.slice(prefix.length));
          if (!relativePath || relativePath.startsWith('../') || !mediaPattern.test(relativePath)) return next();

          try {
            const localPath = path.join(contentDir, relativePath);
            response.setHeader('Content-Type', contentTypes[path.extname(localPath).toLowerCase()] ?? 'application/octet-stream');
            response.setHeader('Cache-Control', 'no-store');
            response.end(await readFile(localPath));
          } catch {
            next();
          }
        });
      },
      'astro:build:done': async ({ dir }) => {
        await copyBlogMediaAssets(dir);
      },
    },
  };
}
