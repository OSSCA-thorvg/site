# Site typography

- **Pretendard 1.3.9**: Korean and Latin body, headings and interface text.
  Official variable dynamic subsets are copied without font modifications from
  https://github.com/orioncactus/pretendard/tree/v1.3.9/packages/pretendard/dist/web/variable
  (`pretendardvariable-dynamic-subset.css` is stored as `pretendard/pretendard.css`).
  Unicode ranges load only the subsets needed by each page; Vite bundles local URLs.
- **JetBrains Mono 2.304 Regular**: code and monospace text, with Pretendard for Korean.
  https://github.com/JetBrains/JetBrainsMono/blob/v2.304/fonts/webfonts/JetBrainsMono-Regular.woff2

Both fonts use SIL Open Font License 1.1. Commercial use and web embedding
are permitted. Preserve the copyright and license notices when redistributing;
fonts may not be sold on their own. Modified fonts must obey reserved-name rules.
The license does not apply to blog content written using these fonts.

Full upstream notices are shipped in `public/licenses/fonts/Pretendard-OFL.txt`
and `public/licenses/fonts/JetBrainsMono-OFL.txt`, copied from the same release tags.
The previous Latin-only font files are retained but no longer loaded by global CSS.
