import { decodeString } from 'micromark-util-decode-string';

const seriesCollator = new Intl.Collator('ko-KR', {
  numeric: true,
  sensitivity: 'base',
});

const normalizeSeriesKey = (title) => title
  .normalize('NFKC')
  .replace(/\s+/g, ' ')
  .trim()
  .toLocaleLowerCase('ko-KR');

const markdownHeadingText = (heading) => decodeString(heading
  .replace(/[ \t]+#+[ \t]*$/, '')
  .replace(/!\[([^\]]*)\]\([^)]*\)/g, '$1')
  .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')
  .replace(/<[^>]+>/g, '')
  .replace(/[`*_~]/g, '')
).trim();

export function extractSeriesHeading(markdown = '') {
  let fence = null;

  for (const line of String(markdown).split(/\r?\n/)) {
    const marker = line.match(/^ {0,3}(`{3,}|~{3,})/)?.[1];
    if (fence) {
      if (
        marker
        && marker[0] === fence.character
        && marker.length >= fence.length
        && line.slice(line.indexOf(marker) + marker.length).trim() === ''
      ) fence = null;
      continue;
    }
    if (marker) {
      fence = { character: marker[0], length: marker.length };
      continue;
    }

    const heading = line.match(/^ {0,3}#(?:[ \t]+|$)(.*)$/)?.[1];
    if (heading !== undefined) return markdownHeadingText(heading);

    const strong = line.match(/^ {0,3}(?:\*\*(.+)\*\*|__(.+)__)[ \t]*$/);
    if (strong) return markdownHeadingText(strong[1] ?? strong[2]);
  }

  return null;
}

export function parseSeriesHeading(heading = '') {
  const match = String(heading).trim().match(/^(.*?)(?:\s*-\s*(\d+)|\s*\(\s*(\d+)\s*\)|\s+(\d+))$/u);
  if (!match) return null;

  const path = match[1].split('>').map((part) => part.replace(/\s+/g, ' ').trim());
  if (path.some((part) => !part)) return null;
  const name = path.join(' > ');
  const number = Number(match[2] ?? match[3] ?? match[4]);
  if (!name || !Number.isSafeInteger(number) || number < 0) return null;

  return {
    key: normalizeSeriesKey(name),
    name,
    number,
  };
}

const compareEntries = (a, b) => (
  a.number - b.number
  || seriesCollator.compare(a.title, b.title)
  || seriesCollator.compare(a.id, b.id)
);

const newSeries = (name, key) => ({ type: 'series', name, key, entries: [], children: [] });

export function createSeriesIndex(posts = []) {
  const roots = new Map();

  for (const post of posts) {
    const parsed = parseSeriesHeading(post.heading);
    if (!parsed) continue;

    const path = parsed.name.split(' > ');
    const rootKey = normalizeSeriesKey(path[0]);
    if (!roots.has(rootKey)) roots.set(rootKey, newSeries(path[0], rootKey));
    let node = roots.get(rootKey);
    const entry = { id: post.id, title: post.title, number: parsed.number };
    node.entries.push(entry);

    for (let depth = 1; depth < path.length; depth++) {
      const key = path.slice(0, depth + 1).map(normalizeSeriesKey).join(' > ');
      let child = node.children.find((item) => item.type === 'series' && item.key === key);
      if (!child) {
        child = newSeries(path[depth], key);
        node.children.push(child);
      }
      child.entries.push(entry);
      node = child;
    }
    node.children.push({ type: 'post', ...entry });
  }

  const sortTree = (node) => {
    node.entries.sort(compareEntries);
    for (const child of node.children) if (child.type === 'series') sortTree(child);
    // A group occupies the position of its earliest numbered descendant.
    node.children.sort((a, b) => compareEntries(
      a.type === 'series' ? a.entries[0] : a,
      b.type === 'series' ? b.entries[0] : b,
    ));
  };
  const index = new Map();
  for (const root of roots.values()) {
    sortTree(root);
    for (const entry of root.entries) index.set(entry.id, root);
  }
  return index;
}

export function getSeriesTrail(series, postId) {
  if (!series?.entries.some((entry) => entry.id === postId)) return [];
  const child = series.children.find((item) => (
    item.type === 'series' && item.entries.some((entry) => entry.id === postId)
  ));
  return [series.name, ...(child ? getSeriesTrail(child, postId) : [])];
}
