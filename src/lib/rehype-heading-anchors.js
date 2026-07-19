const HEADING_TAG = /^h[2-6]$/;

const nodeText = (node) => {
  if (node?.type === 'text') return node.value;
  if (node?.type === 'raw') return node.value.replace(/<[^>]*>/g, '');
  if (!Array.isArray(node?.children)) return '';
  return node.children.map(nodeText).join('');
};

const linkIcon = () => ({
  type: 'element',
  tagName: 'svg',
  properties: {
    viewBox: '0 0 24 24',
    width: 16,
    height: 16,
    fill: 'none',
    stroke: 'currentColor',
    strokeWidth: 2,
    strokeLinecap: 'round',
    strokeLinejoin: 'round',
    ariaHidden: 'true',
    focusable: 'false',
  },
  children: [
    {
      type: 'element',
      tagName: 'path',
      properties: { d: 'M10 13a5 5 0 0 0 7.07 0l3-3A5 5 0 0 0 13 2.93l-1.72 1.71' },
      children: [],
    },
    {
      type: 'element',
      tagName: 'path',
      properties: { d: 'M14 11a5 5 0 0 0-7.07 0l-3 3A5 5 0 0 0 11 21.07l1.71-1.71' },
      children: [],
    },
  ],
});

const addAnchor = (node) => {
  const id = node?.properties?.id;
  if (node?.type !== 'element' || !HEADING_TAG.test(node.tagName) || typeof id !== 'string') return;

  const label = nodeText(node).trim() || '제목';
  node.children.push({
    type: 'element',
    tagName: 'a',
    properties: {
      className: ['heading-anchor'],
      href: `#${id}`,
      ariaLabel: `${label} 섹션 링크`,
      title: '이 섹션 링크',
    },
    children: [linkIcon()],
  });
};

const walk = (node) => {
  addAnchor(node);
  if (!Array.isArray(node?.children)) return;
  for (const child of node.children) walk(child);
};

export default function rehypeHeadingAnchors({ contentPath } = {}) {
  return (tree, file) => {
    const normalizedPath = String(file?.path ?? '').replace(/\\/g, '/');
    if (contentPath && !normalizedPath.includes(contentPath)) return;
    walk(tree);
  };
}
