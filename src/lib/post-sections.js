export const ASSIGNMENT_TAG = '과제';

const normalizeTag = (tag) => String(tag).trim().normalize('NFKC');
const tagCollator = new Intl.Collator('ko-KR', {
  numeric: true,
  sensitivity: 'base',
});

export const isAssignmentTag = (tag) => normalizeTag(tag) === ASSIGNMENT_TAG;

export const hasAssignmentTag = (tags = []) => tags.some(isAssignmentTag);

export const sortPostTags = (tags = []) => (
  [...new Set(tags.map(normalizeTag).filter(Boolean))].sort(tagCollator.compare)
);
