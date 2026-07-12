import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

// Blog: participants drop an .mdx (or .md) file into src/content/blog/.
// Frontmatter drives the filterable board and GitHub-attributed cards.
const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    github: z.string().trim().min(1).regex(/^(?!-)(?!.*--)[A-Za-z0-9](?:[A-Za-z0-9-]{0,37}[A-Za-z0-9])?$/),
    date: z.coerce.date(),
    summary: z.string().default(''),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
    discussionNumber: z.number().int().positive().optional(),
  }),
});

// AI review: per-issue analysis markdown named `<issueNumber>-<difficulty>.md`.
// Files carry no frontmatter; the issue number comes from the file name.
const aiReview = defineCollection({
  loader: glob({ pattern: '*.md', base: './ai-review-issue/core' }),
  schema: z.object({}),
});

export const collections = { blog, aiReview };
