// 해커톤 데이터 규칙.
// 시작 공지: `Hackathon` + `Notice` 라벨이 함께 있고 제목이 `(YYYY-MM-DD)`로 끝나는 이슈.
// 종료 공지: 같은 라벨을 가지며 제목이 `(YYYY-MM-DD)(END)`로 끝나는 이슈.
// 프로젝트: `Notice` 없이 `Hackathon` 라벨만 붙은 이슈이며,
// 자기 생성일 이전에 만들어진 공지 중 가장 최근 것에 귀속된다.
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
    // Notice 라벨이 있으면(날짜가 깨진 공지 포함) 프로젝트 카드로 취급하지 않는다.
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

  // 표시 순서는 해커톤 개최일 최신순. 첫 항목이 기본 회차다.
  return events.sort((a, b) => b.date.localeCompare(a.date));
}

// 이슈 본문은 외부 입력이다. raw HTML은 <img>만 화이트리스트 속성으로 재조립해
// 통과시키고 나머지 노드는 제거한다. http(s)·mailto 외의 링크 대상은 비운다.
const SAFE_URL = /^(https?:|mailto:)/i;
const IMG_TAG = /<img\b[^>]*>/gi;

const attribute = (tag, name) =>
  tag.match(new RegExp(`\\b${name}\\s*=\\s*"([^"]*)"`, 'i'))?.[1]
    ?? tag.match(new RegExp(`\\b${name}\\s*=\\s*'([^']*)'`, 'i'))?.[1]
    ?? null;

// GitHub README 관용구인 <p align="center"><img width="..."> 를 지원한다.
// 태그를 그대로 신뢰하지 않고 src·alt·width·height만 뽑아 새로 만든다.
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
