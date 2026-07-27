import { writeFile } from 'node:fs/promises';

const output = new URL('../src/data/live-hackathon.json', import.meta.url);
const repository = process.env.GITHUB_REPOSITORY || 'OSSCA-thorvg/site';

const nextPage = (link) =>
  link?.split(',').map((part) => part.trim()).find((part) => part.endsWith('rel="next"'))
    ?.match(/^<([^>]+)>/)?.[1] ?? null;

const headers = {
  Accept: 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
  ...(process.env.GITHUB_TOKEN ? { Authorization: `Bearer ${process.env.GITHUB_TOKEN}` } : {}),
};

async function fetchAll(url) {
  const items = [];

  while (url) {
    const response = await fetch(url, { method: 'GET', headers });
    if (!response.ok) throw new Error(`GitHub hackathon sync failed: ${response.status} ${response.statusText}`);
    items.push(...await response.json());
    url = nextPage(response.headers.get('link'));
  }

  return items;
}

const raw = await fetchAll(
  `https://api.github.com/repos/${repository}/issues?labels=Hackathon&state=all&per_page=100`
);
const issues = raw
  .filter((issue) => !issue.pull_request)
  .map((issue) => ({
    number: String(issue.number),
    title: issue.title,
    body: issue.body ?? '',
    state: issue.state,
    createdAt: issue.created_at,
    labels: issue.labels.map((label) => (typeof label === 'string' ? label : label.name)).filter(Boolean),
    assignees: (issue.assignees ?? []).map((assignee) => assignee.login).filter(Boolean),
    url: issue.html_url,
  }));

await writeFile(output, `${JSON.stringify({ generatedAt: new Date().toISOString(), repository, issues }, null, 2)}\n`);
console.log(`Synced ${issues.length} hackathon issue(s) from ${repository}.`);
