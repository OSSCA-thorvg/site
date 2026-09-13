export interface SeriesEntry {
  id: string;
  title: string;
  number: number;
}

export interface PostSeries {
  type: 'series';
  key: string;
  name: string;
  entries: SeriesEntry[];
  children: (PostSeries | (SeriesEntry & { type: 'post' }))[];
}

export function extractSeriesHeading(markdown?: string): string | null;
export function parseSeriesHeading(heading?: string | null): { key: string; name: string; number: number } | null;
export function createSeriesIndex(posts?: { id: string; title: string; heading: string | null }[]): Map<string, PostSeries>;
export function getSeriesTrail(series: PostSeries | null | undefined, postId: string): string[];
