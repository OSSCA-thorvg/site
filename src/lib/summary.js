// 본문 Markdown에서 목록 카드와 메타 설명에 쓸 요약을 만든다.
// 제목, 이미지, 코드 블록을 건너뛰고 첫 번째 일반 문단을 사용한다.
const MAX_SUMMARY_LENGTH = 160;

const stripInline = (text) =>
  text
    .replace(/!\[[^\]]*\]\([^)]*\)/g, '')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/`([^`]*)`/g, '$1')
    .replace(/(\*\*|__|\*|_|~~)/g, '')
    .replace(/\s+/g, ' ')
    .trim();

export function deriveSummary(markdown = '', maxLength = MAX_SUMMARY_LENGTH) {
  const withoutCode = markdown.replace(/^(`{3,}|~{3,})[^\n]*\n[\s\S]*?\n\1\s*$/gm, '');

  for (const block of withoutCode.split(/\n\s*\n/)) {
    const lines = block
      .split('\n')
      .map((line) => line.replace(/^\s*(?:>\s*)?/, '').replace(/^(?:[-*+]|\d+\.)\s+/, '').trim())
      .filter(Boolean)
      .filter((line) => !/^#{1,6}\s/.test(line))
      .filter((line) => !/^\[!(?:NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]$/i.test(line))
      .filter((line) => !/^</.test(line));

    const text = stripInline(lines.join(' '));
    if (!text) continue;

    return text.length > maxLength ? `${text.slice(0, maxLength - 1).trimEnd()}…` : text;
  }

  return '';
}
