// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import { rehypeHeadingIds, unified } from '@astrojs/markdown-remark';
import { remarkAlert } from 'remark-github-blockquote-alert';
import remarkLottieImages from './src/lib/remark-lottie-images.js';
import remarkGithubVideos from './src/lib/remark-github-videos.js';
import remarkSeriesHeading from './src/lib/remark-series-heading.js';
import rehypeHeadingAnchors from './src/lib/rehype-heading-anchors.js';
import blogMediaAssets from './src/lib/blog-media-assets.js';

// GitHub Pages: for a PROJECT page (https://<user>.github.io/<repo>/) set
// BASE_PATH=/<repo>/ in the deploy workflow. For a user/org page or a custom
// domain, leave it as '/'. SITE_URL only affects absolute URLs (sitemap, RSS).
const baseSegment = (process.env.BASE_PATH || '/').replace(/^\/+|\/+$/g, '');
const base = baseSegment ? `/${baseSegment}/` : '/';
const site = process.env.SITE_URL || 'https://thorvg.github.io';

// https://astro.build/config
export default defineConfig({
  site,
  base,
  trailingSlash: 'ignore',
  markdown: {
    processor: unified({
      remarkPlugins: [remarkAlert, [remarkLottieImages, { base }], remarkGithubVideos, remarkSeriesHeading],
      // Run ID generation before our custom rehype plugin. Astro's built-in pass
      // runs again later to collect the same IDs for the table of contents.
      rehypePlugins: [
        rehypeHeadingIds,
        [rehypeHeadingAnchors, { contentPath: 'src/content/blog/' }],
      ],
    }),
  },
  integrations: [mdx(), blogMediaAssets({ base })],
});
