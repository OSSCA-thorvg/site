import { parseSeriesHeading } from './post-series.js';

const nodeText = (node) => {
  if (typeof node?.value === 'string') return node.value;
  if (typeof node?.alt === 'string') return node.alt;
  if (!Array.isArray(node?.children)) return '';
  return node.children.map(nodeText).join('');
};

const seriesHeading = (node) => {
  if (node?.type === 'heading' && node.depth === 1) return nodeText(node);
  if (
    node?.type === 'paragraph'
    && node.children?.length === 1
    && node.children[0].type === 'strong'
  ) return nodeText(node.children[0]);
  return null;
};

export default function remarkSeriesHeading() {
  return (tree) => {
    if (!Array.isArray(tree?.children)) return;

    const index = tree.children.findIndex((node) => seriesHeading(node) !== null);
    if (index < 0 || !parseSeriesHeading(seriesHeading(tree.children[index]))) return;
    tree.children.splice(index, 1);
  };
}
