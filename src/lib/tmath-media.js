export const defaultTMathPoster = (scene, base = '/') =>
  `${base.endsWith('/') ? base : `${base}/`}tmath/postprocessing/posters/${scene}.webp`;
