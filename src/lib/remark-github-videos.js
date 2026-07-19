// Replaces paragraphs made of a single video URL with a <video> player,
// matching how GitHub renders uploaded attachment videos in markdown.
const ATTACHMENT_URL = /^https:\/\/github\.com\/user-attachments\/assets\/[\w-]+$/i;
const VIDEO_EXTENSION = /\.(?:mp4|webm|mov)(?:[?#]|$)/i;

const isVideoUrl = (url = '') => ATTACHMENT_URL.test(url) || VIDEO_EXTENSION.test(url);

// A paragraph qualifies when its only child is a bare URL: a GFM autolink
// whose text equals its target, or a plain text node that is just the URL.
const soleVideoUrl = (paragraph) => {
  if (paragraph.children?.length !== 1) return null;
  const [child] = paragraph.children;
  if (
    child.type === 'link'
    && child.children?.length === 1
    && child.children[0].type === 'text'
    && child.children[0].value === child.url
  ) return isVideoUrl(child.url) ? child.url : null;
  if (child.type === 'text') {
    const value = child.value.trim();
    return isVideoUrl(value) ? value : null;
  }
  return null;
};

const videoElement = (url) => ({
  type: 'text',
  value: '',
  data: {
    hName: 'video',
    hProperties: {
      src: url,
      controls: true,
      preload: 'metadata',
      playsinline: true,
      ariaLabel: '첨부 영상',
    },
  },
});

export default function remarkGithubVideos() {
  return (tree) => {
    const visit = (node) => {
      if (!Array.isArray(node.children)) return;

      node.children = node.children.map((child) => {
        if (child.type === 'paragraph') {
          const url = soleVideoUrl(child);
          if (url) return videoElement(url);
        }

        visit(child);
        return child;
      });
    };

    visit(tree);
  };
}
