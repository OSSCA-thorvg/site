import { writeFile } from 'node:fs/promises';

const output = new URL('../src/data/core-contributions.json', import.meta.url);
const organization = 'thorvg';
const contributionSince = '2026-06-01';
const repositoriesEndpoint = `https://api.github.com/orgs/${organization}/repos?type=all&per_page=100`;
const coreMembers = [
  'alpakaDurumi',
  'J-unStiN',
  'jeongsunyong',
  'DaengDo',
  'Saususge',
  'tcpark11',
];
// Home dashboard audience. Keep this list explicit: assignment authors are not
// inferred from content files, and the Core members above are already included.
const assignmentAuthors = [
  'alpakaDurumi',
  'J-unStiN',
  'jeongsunyong',
  'DaengDo',
  'Saususge',
  'tcpark11',
  'autlyr21',
  'chae-dahee',
  'hd1534',
  'hwiskim',
  'inmare',
  'jinlee0310',
  'juyonLee00',
  'KimSH39',
  'mnchnk',
  'mungjin01',
  'nowgnuesLeee',
  'numkite',
  'seobinpark',
  'taejun0',
  'YoungB0',
  'zurdhva',
];

const nextPage = (link) =>
  link?.split(',').map((part) => part.trim()).find((part) => part.endsWith('rel="next"'))
    ?.match(/^<([^>]+)>/)?.[1] ?? null;

const headers = {
  Accept: 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
  ...((process.env.GITHUB_TOKEN || process.env.GH_TOKEN)
    ? { Authorization: `Bearer ${process.env.GITHUB_TOKEN || process.env.GH_TOKEN}` }
    : {}),
};

const memberNames = assignmentAuthors;

class GitHubRequestError extends Error {
  constructor(response, detail) {
    super(`GitHub contribution sync failed: ${response.status} ${response.statusText} (${response.url})`);
    this.status = response.status;
    this.detail = detail;
  }
}

const getPage = async (url) => {
  const response = await fetch(url, { method: 'GET', headers });
  if (!response.ok) {
    throw new GitHubRequestError(response, await response.text());
  }

  return { data: await response.json(), next: nextPage(response.headers.get('link')) };
};

const fetchAll = async (url, selectItems = (data) => data) => {
  const items = [];

  while (url) {
    const page = await getPage(url);
    items.push(...selectItems(page.data));
    url = page.next;
  }

  return items;
};

const repositoryName = (item) =>
  item.repository_url.replace('https://api.github.com/repos/', '');

const toActivity = (member, item) => {
  const authored = item.user.login.toLowerCase() === member.toLowerCase();
  const pullRequest = Boolean(item.pull_request);

  // The dashboard tracks authored PRs, while issue participation also includes
  // assignments, mentions, and comments returned by GitHub's `involves:` search.
  if (pullRequest && !authored) return null;

  const state = pullRequest
    ? item.state === 'open'
      ? 'open'
      : item.pull_request.merged_at
        ? 'merged'
        : 'closed'
    : item.state;

  return {
    number: item.number,
    title: item.title,
    url: item.html_url,
    repo: repositoryName(item),
    kind: pullRequest ? 'pullRequest' : 'issue',
    state,
    authored,
    createdAt: item.created_at,
    updatedAt: item.updated_at,
  };
};

const repositories = (await fetchAll(repositoriesEndpoint))
  .filter((repository) => !repository.fork && !repository.private)
  .map((repository) => repository.full_name)
  .sort((a, b) => a.localeCompare(b));
const repositorySet = new Set(repositories);

const members = [];
for (const name of memberNames) {
  const query = new URL('https://api.github.com/search/issues');
  query.searchParams.set('q', `org:${organization} involves:${name} updated:>=${contributionSince}`);
  query.searchParams.set('sort', 'updated');
  query.searchParams.set('order', 'desc');
  query.searchParams.set('per_page', '100');

  let searchItems = [];
  try {
    searchItems = await fetchAll(query.href, (data) => data.items);
  } catch (error) {
    const userCannotBeSearched = error instanceof GitHubRequestError &&
      error.status === 422 && error.detail.includes('listed users cannot be searched');
    if (!userCannotBeSearched) throw error;
    console.warn(`GitHub Search cannot query ${name}; keeping the assignment author with 0 activities.`);
  }

  const activities = searchItems
    .map((item) => toActivity(name, item))
    .filter((item) => item && repositorySet.has(item.repo))
    .sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());

  members.push({
    name,
    profile: `https://github.com/${name}`,
    activities,
  });
}

await writeFile(output, `${JSON.stringify({
  generatedAt: new Date().toISOString(),
  organization,
  contributionSince,
  repositories,
  coreMembers,
  assignmentAuthors,
  members,
}, null, 2)}\n`);

console.log(`Synced ${members.reduce((total, member) => total + member.activities.length, 0)} activities for ${members.length} assignment authors across ${repositories.length} ThorVG repositories.`);
