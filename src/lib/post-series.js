const seriesCollator = new Intl.Collator('ko-KR', {
  numeric: true,
  sensitivity: 'base',
});

const normalizeSeriesKey = (title) => title
  .normalize('NFKC')
  .replace(/\s+/g, ' ')
  .trim()
  .toLocaleLowerCase('ko-KR');

const markdownHeadingText = (heading) => heading
  .replace(/[ \t]+#+[ \t]*$/, '')
  .replace(/!\[([^\]]*)\]\([^)]*\)/g, '$1')
  .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')
  .replace(/<[^>]+>/g, '')
  .replace(/[`*_~]/g, '')
  .replace(/\\([\\`*_[\]{}()#+\-.!])/g, '$1')
  .trim();

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
  const match = String(heading).trim().match(/^(.*?)\s*(?:-\s*(\d+)|\(\s*(\d+)\s*\))$/u);
  if (!match) return null;

  const name = match[1].replace(/\s+/g, ' ').trim();
  const number = Number(match[2] ?? match[3]);
  if (!name || !Number.isSafeInteger(number) || number < 1) return null;

  return {
    key: normalizeSeriesKey(name),
    name,
    number,
  };
}

export function createSeriesIndex(posts = []) {
  const groups = new Map();

  for (const post of posts) {
    const parsed = parseSeriesHeading(post.heading);
    if (!parsed) continue;

    const entries = groups.get(parsed.key) ?? [];
    entries.push({
      id: post.id,
      title: post.title,
      number: parsed.number,
      name: parsed.name,
    });
    groups.set(parsed.key, entries);
  }

  const index = new Map();
  for (const entries of groups.values()) {
    entries.sort((a, b) => (
      a.number - b.number
      || seriesCollator.compare(a.title, b.title)
      || seriesCollator.compare(a.id, b.id)
    ));
    const series = {
      name: entries[0].name,
      entries: entries.map(({ id, title, number }) => ({ id, title, number })),
    };
    for (const entry of entries) index.set(entry.id, series);
  }

  return index;
}
