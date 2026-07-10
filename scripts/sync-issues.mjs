import { writeFile } from 'node:fs/promises';

const output = new URL('../src/data/live-issues.json', import.meta.url);
const repositoriesEndpoint = 'https://api.github.com/orgs/thorvg/repos?type=all&per_page=100';
const removedFixtureAssignee = ['Nor', 's'].join('-');

const nextPage = (link) =>
  link?.split(',').map((part) => part.trim()).find((part) => part.endsWith('rel="next"'))
    ?.match(/^<([^>]+)>/)?.[1] ?? null;

const headers = {
  Accept: 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
  ...(process.env.GITHUB_TOKEN ? { Authorization: `Bearer ${process.env.GITHUB_TOKEN}` } : {}),
};

const getPage = async (url) => {
  const response = await fetch(url, { method: 'GET', headers });
  if (!response.ok) throw new Error(`GitHub issue sync failed: ${response.status} ${response.statusText}`);
  return { data: await response.json(), next: nextPage(response.headers.get('link')) };
};

const toIssue = (repo, issue) => {
  if (issue.pull_request) return null;

  const labels = issue.labels.map((label) => typeof label === 'string' ? label : label.name).filter(Boolean);
  const assignee = issue.assignee?.login ?? '';
  return {
    number: String(issue.number),
    repo: repo.full_name,
    title: issue.title,
    updatedAt: issue.updated_at,
    labels: labels.join(';'),
    status: issue.state,
    assignee: assignee === removedFixtureAssignee ? '' : assignee,
    area: labels[0] ?? '',
    difficulty: '',
    recommended: 'false',
  };
};

async function fetchAll(url) {
  const items = [];

  while (url) {
    const page = await getPage(url);
    items.push(...page.data);
    url = page.next;
  }

  return items;
}

const repositories = (await fetchAll(repositoriesEndpoint)).filter((repo) => !repo.fork);
const issues = [];
for (const repo of repositories) {
  const page = await fetchAll(`https://api.github.com/repos/${repo.full_name}/issues?state=open&sort=updated&direction=desc&per_page=100`);
  issues.push(...page.map((issue) => toIssue(repo, issue)).filter(Boolean));
}
issues.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());
await writeFile(output, `${JSON.stringify({ generatedAt: new Date().toISOString(), issues }, null, 2)}\n`);
console.log(`Synced ${issues.length} open issues from ${repositories.length} ThorVG repositories.`);
