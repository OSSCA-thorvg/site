// Hackathon data rules:
// A start notice has both `Hackathon` and `Notice` labels and ends with `(YYYY-MM-DD)`.
// An end notice has the same labels and ends with `(YYYY-MM-DD)(END)`.
// A project has only the `Hackathon` label and belongs to the latest earlier notice.
const NOTICE_DATE = /\((\d{4}-\d{2}-\d{2})\)\s*$/;
const END_NOTICE_DATE = /\((\d{4}-\d{2}-\d{2})\)\s*\(END\)\s*$/i;

export const parseNoticeDate = (title = '') => title.match(NOTICE_DATE)?.[1] ?? null;
export const parseEndNoticeDate = (title = '') => title.match(END_NOTICE_DATE)?.[1] ?? null;

const noticeName = (title, pattern) => title.replace(pattern, '').trim().toLowerCase();

const hasLabel = (issue, label) =>
  (issue.labels ?? []).some((name) => name.toLowerCase() === label);

export const extractFirstImage = (body = '') =>
  body.match(/!\[[^\]]*\]\(\s*(https?:\/\/[^\s)]+)\s*(?:"[^"]*")?\)/)?.[1]
    ?? body.match(/<img\b[^>]*\bsrc\s*=\s*["'](https?:\/\/[^"']+)["']/i)?.[1]
    ?? null;

export function extractShowcases(body = '') {
  return body.split(/\r?\n/).flatMap((line) => {
    const cells = line.split('|').map((cell) => cell.trim());
    if (cells[0] === '') cells.shift();
    if (cells.at(-1) === '') cells.pop();
    if (cells.length < 2) return [];

    const [repo, rawLink] = cells;
    if (repo.toLowerCase() === 'repo' || /^:?-{2,}:?$/.test(repo)) return [];

    const markdownLink = rawLink.match(/^\[[^\]]*\]\((https?:\/\/[^\s)]+)\)$/i);
    const link = (markdownLink?.[1] ?? rawLink).replace(/^<|>$/g, '');

    try {
      const url = new URL(link);
      if (!['http:', 'https:'].includes(url.protocol)) return [];
      return [{ repo, link: url.href }];
    } catch {
      return [];
    }
  });
}

export function groupHackathons(issues = []) {
  const hackathonIssues = issues.filter((issue) => hasLabel(issue, 'hackathon'));
  const events = hackathonIssues
    .filter((issue) => hasLabel(issue, 'notice') && parseNoticeDate(issue.title))
    .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
    .map((notice) => ({
      notice,
      date: parseNoticeDate(notice.title),
      title: notice.title.replace(NOTICE_DATE, '').trim(),
      projects: [],
      closingNotice: null,
      endDate: null,
      showcases: [],
    }));

  const closingNotices = hackathonIssues
    .filter((issue) => hasLabel(issue, 'notice') && parseEndNoticeDate(issue.title))
    .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());

  for (const closingNotice of closingNotices) {
    const created = new Date(closingNotice.createdAt).getTime();
    const name = noticeName(closingNotice.title, END_NOTICE_DATE);
    const event = events.findLast((candidate) =>
      !candidate.closingNotice
      && noticeName(candidate.notice.title, NOTICE_DATE) === name
      && new Date(candidate.notice.createdAt).getTime() <= created
    );
    if (!event) continue;

    event.closingNotice = closingNotice;
    event.endDate = parseEndNoticeDate(closingNotice.title);
    event.showcases = extractShowcases(closingNotice.body);
  }

  for (const issue of hackathonIssues) {
    // Never treat notices, including notices with invalid dates, as project cards.
    if (hasLabel(issue, 'notice')) continue;
    const created = new Date(issue.createdAt).getTime();
    const event = events.findLast(
      (candidate) => new Date(candidate.notice.createdAt).getTime() <= created
    );
    event?.projects.push(issue);
  }

  for (const event of events) {
    event.projects.sort(
      (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );
  }

  // Sort hackathons newest first; the first entry is the default event.
  return events.sort((a, b) => b.date.localeCompare(a.date));
}

// Issue bodies are untrusted. Rebuild only `<img>` tags with allowed attributes,
// strip other raw HTML, and reject link protocols other than HTTP(S) and mailto.
const SAFE_URL = /^(https?:|mailto:)/i;
const IMG_TAG = /<img\b[^>]*>/gi;

const attribute = (tag, name) =>
  tag.match(new RegExp(`\\b${name}\\s*=\\s*"([^"]*)"`, 'i'))?.[1]
    ?? tag.match(new RegExp(`\\b${name}\\s*=\\s*'([^']*)'`, 'i'))?.[1]
    ?? null;

// Support centered images commonly used in GitHub README files.
// Rebuild each tag using only src, alt, width, and height.
const htmlImages = (value = '') => {
  const centered = /align\s*=\s*["']center["']/i.test(value);
  return [...value.matchAll(IMG_TAG)].flatMap((match) => {
    const tag = match[0];
    const src = attribute(tag, 'src');
    if (!src || !SAFE_URL.test(src)) return [];
    const hProperties = {
      src,
      alt: attribute(tag, 'alt') ?? '',
      loading: 'lazy',
      decoding: 'async',
      ...(centered ? { style: 'display:block;margin-inline:auto;' } : {}),
    };
    for (const name of ['width', 'height']) {
      const size = attribute(tag, name);
      if (size && /^\d+$/.test(size)) hProperties[name] = size;
    }
    return [{ type: 'text', value: '', data: { hName: 'img', hProperties } }];
  });
};

export const stripUnsafeMarkdown = () => (tree) => {
  const walk = (node) => {
    if (!Array.isArray(node.children)) return;
    node.children = node.children.flatMap((child) =>
      child.type === 'html' ? htmlImages(child.value) : [child]
    );
    for (const child of node.children) {
      if ((child.type === 'link' || child.type === 'image') && !SAFE_URL.test(child.url ?? '')) {
        child.url = '';
      }
      walk(child);
    }
  };
  walk(tree);
};
