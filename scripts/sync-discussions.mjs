import { readdir, rm, writeFile } from 'node:fs/promises';
import { fileURLToPath, pathToFileURL } from 'node:url';
import path from 'node:path';

import { deriveSummary } from '../src/lib/summary.js';

const root = fileURLToPath(new URL('../', import.meta.url));
const blogDir = path.join(root, 'src/content/blog');
const configFile = path.join(root, 'src/data/discussions-config.json');
const generatedPost = /^discussion-\d+\.md$/;

const section = (body, label) => {
  const startMarker = `### ${label}`;
  const start = body.indexOf(startMarker);
  if (start < 0) return '';
  return body.slice(start + startMarker.length).trim();
};

export function parseDiscussionBody(body = '') {
  // 예전 폼으로 작성된 글은 '### 본문' 아래만 본문으로 사용한다.
  // 지금은 폼 없이 자유롭게 작성하며, 요약은 본문에서 자동으로 만든다.
  const content = body.includes('### 본문') ? section(body, '본문') : body.trim();

  return {
    summary: deriveSummary(content),
    body: content,
  };
}

export function isPublishedDiscussion(discussion, category = 'Blog') {
  return discussion.category?.name?.toLowerCase() === category.toLowerCase()
    && !/\(WIP\)\s*$/i.test(discussion.title)
    && Boolean(discussion.author?.login);
}

export function renderDiscussionMarkdown(discussion) {
  const parsed = parseDiscussionBody(discussion.body);
  const tags = (discussion.labels?.nodes ?? []).map(({ name }) => name);
  const date = new Date(discussion.createdAt).toISOString();
  const frontmatter = [
    '---',
    `title: ${JSON.stringify(discussion.title)}`,
    `github: ${JSON.stringify(discussion.author.login)}`,
    `date: ${JSON.stringify(date)}`,
    `summary: ${JSON.stringify(parsed.summary)}`,
    `tags: ${JSON.stringify(tags)}`,
    'draft: false',
    `discussionNumber: ${discussion.number}`,
    '---',
  ];

  return `${frontmatter.join('\n')}\n\n${parsed.body}\n`;
}

async function fetchDiscussions(token, repository) {
  const [owner, name] = repository.split('/');
  if (!owner || !name) throw new Error('GITHUB_REPOSITORY must use owner/repository format.');

  const query = `
    query BlogDiscussions($owner: String!, $name: String!, $after: String) {
      repository(owner: $owner, name: $name) {
        id
        discussionCategories(first: 100) { nodes { id name } }
        discussions(first: 100, after: $after, orderBy: { field: CREATED_AT, direction: DESC }) {
          pageInfo { hasNextPage endCursor }
          nodes {
            number
            title
            body
            createdAt
            author { login }
            category { id name }
            labels(first: 100) { nodes { name } }
          }
        }
      }
    }
  `;
  const discussions = [];
  let after = null;
  let repositoryData;

  do {
    const response = await fetch('https://api.github.com/graphql', {
      method: 'POST',
      headers: {
        authorization: `Bearer ${token}`,
        'content-type': 'application/json',
        'user-agent': 'ossca-thorvg-site',
      },
      body: JSON.stringify({ query, variables: { owner, name, after } }),
    });
    if (!response.ok) throw new Error(`GitHub GraphQL request failed (${response.status}).`);

    const payload = await response.json();
    if (payload.errors?.length) throw new Error(payload.errors.map(({ message }) => message).join('; '));
    repositoryData = payload.data?.repository;
    if (!repositoryData) throw new Error(`GitHub repository ${repository} was not found.`);

    discussions.push(...repositoryData.discussions.nodes);
    after = repositoryData.discussions.pageInfo.hasNextPage
      ? repositoryData.discussions.pageInfo.endCursor
      : null;
  } while (after);

  return { repository: repositoryData, discussions };
}

export async function syncDiscussions({
  token = process.env.GITHUB_TOKEN,
  repository = process.env.GITHUB_REPOSITORY || 'OSSCA-thorvg/site',
  category = process.env.BLOG_DISCUSSION_CATEGORY || 'Blog',
} = {}) {
  if (!token) throw new Error('GITHUB_TOKEN is required to synchronize blog discussions.');

  const { repository: repositoryData, discussions } = await fetchDiscussions(token, repository);
  const categoryData = repositoryData.discussionCategories.nodes.find(
    ({ name }) => name.toLowerCase() === category.toLowerCase()
  );
  const published = discussions.filter((item) => isPublishedDiscussion(item, category));

  const existing = await readdir(blogDir);
  await Promise.all(existing.filter((name) => generatedPost.test(name)).map((name) => rm(path.join(blogDir, name))));
  await Promise.all(published.map((item) => (
    writeFile(path.join(blogDir, `discussion-${item.number}.md`), renderDiscussionMarkdown(item))
  )));
  await writeFile(configFile, `${JSON.stringify({
    repo: repository,
    repoId: repositoryData.id,
    category,
    categoryId: categoryData?.id ?? '',
  }, null, 2)}\n`);

  console.log(`Synchronized ${published.length} published Blog discussion(s).`);
  if (!categoryData) console.warn(`Discussion category ${category} does not exist yet.`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  syncDiscussions().catch((error) => {
    console.error(error instanceof Error ? error.message : error);
    process.exitCode = 1;
  });
}
