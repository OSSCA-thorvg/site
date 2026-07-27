// 해커톤 데이터 규칙.
// 공지: `Hackathon` + `Notice` 라벨이 함께 있고 제목이 `(YYYY-MM-DD)`로 끝나는 이슈.
// 프로젝트: `Notice` 없이 `Hackathon` 라벨만 붙은 이슈이며,
// 자기 생성일 이전에 만들어진 공지 중 가장 최근 것에 귀속된다.
const NOTICE_DATE = /\((\d{4}-\d{2}-\d{2})\)\s*$/;

export const parseNoticeDate = (title = '') => title.match(NOTICE_DATE)?.[1] ?? null;

const hasLabel = (issue, label) =>
  (issue.labels ?? []).some((name) => name.toLowerCase() === label);

export const extractFirstImage = (body = '') =>
  body.match(/!\[[^\]]*\]\(\s*(https?:\/\/[^\s)]+)\s*(?:"[^"]*")?\)/)?.[1] ?? null;

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
    }));

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

// 이슈 본문은 외부 입력이다. raw HTML 노드를 제거하고
// http(s)·mailto 외의 링크 대상을 비워 마크다운 문법만 렌더링한다.
const SAFE_URL = /^(https?:|mailto:)/i;

export const stripUnsafeMarkdown = () => (tree) => {
  const walk = (node) => {
    if (!Array.isArray(node.children)) return;
    node.children = node.children.filter((child) => child.type !== 'html');
    for (const child of node.children) {
      if ((child.type === 'link' || child.type === 'image') && !SAFE_URL.test(child.url ?? '')) {
        child.url = '';
      }
      walk(child);
    }
  };
  walk(tree);
};
