import { resolveBlogMediaUrlFromFile } from './blog-media.js';

const isLottie = (url = '') => /\.(?:json|lottie)(?:[?#]|$)/i.test(url);

const lottiePlayer = (image) => ({
  type: 'text',
  value: '',
  data: {
    hName: 'lottie-player',
    hProperties: {
      src: image.url,
      ariaLabel: image.alt || 'Lottie 애니메이션',
      autoplay: true,
      loop: true,
    },
  },
});

const imageElement = (image) => ({
  ...image,
  data: { hProperties: { loading: 'lazy', decoding: 'async' } },
});

const figcaption = (image) => image.alt
  ? {
      type: 'text',
      value: image.alt,
      data: { hName: 'figcaption' },
    }
  : null;

const mediaFigure = (image) => ({
  type: 'parent',
  data: { hName: 'figure', hProperties: { className: ['media-figure'] } },
  children: [
    isLottie(image.url) ? lottiePlayer(image) : imageElement(image),
    figcaption(image),
  ].filter(Boolean),
});

export default function remarkLottieImages({ base = '/' } = {}) {
  return (tree, file) => {
    const visit = (node) => {
      if (!Array.isArray(node.children)) return;

      node.children = node.children.map((child) => {
        if (child.type === 'paragraph' && child.children.length === 1) {
          const [image] = child.children;
          if (image.type === 'image') image.url = resolveBlogMediaUrlFromFile(image.url, file.path, base);
          if (image.type === 'image') return mediaFigure(image);
        }

        visit(child);
        return child;
      });
    };

    visit(tree);
  };
}
