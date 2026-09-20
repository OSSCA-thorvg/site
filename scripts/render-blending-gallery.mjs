import fs from 'node:fs/promises';
import path from 'node:path';
import {execFileSync} from 'node:child_process';
import sharp from 'sharp';
const commit = '4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad';
if (execFileSync('git', ['-C', 'thorvg', 'rev-parse', 'HEAD'], {encoding: 'utf8'}).trim() !== commit) throw Error('Use the pinned ThorVG checkout');
const output = path.resolve('public/tmath/blending/gallery');
const temp = path.join(output, 'temp');
await fs.mkdir(temp, {recursive: true});
const trace = JSON.parse(execFileSync(process.argv[2] ?? '/tmp/thorvg-blending-gallery-native', [temp], {encoding: 'utf8'}));
for (const record of trace.records) {
  const source = await fs.readFile(path.join(temp, record.file.replace('.webp', '.rgba')));
  const display = Buffer.alloc(source.length);
  // Premultiplied RGBA over a display-only checkerboard. It is not a Paint
  // and therefore cannot change the destination used by the blend operation.
  for (let i = 0; i < trace.width * trace.height; i++) {
    const x = i % trace.width, y = Math.floor(i / trace.width);
    const bg = ((Math.floor(x / 8) + Math.floor(y / 8)) % 2) ? 222 : 245;
    const a = source[i * 4 + 3];
    for (let c = 0; c < 3; c++) display[i * 4 + c] = Math.min(255, source[i * 4 + c] + Math.round(bg * (255 - a) / 255));
    display[i * 4 + 3] = 255;
  }
  await sharp(display, {raw: {width: trace.width, height: trace.height, channels: 4}}).webp({lossless: true}).toFile(path.join(output, record.file));
}
await fs.writeFile(path.join(output, 'manifest.json'), JSON.stringify({commit, exampleCommit: '8df10a059239b033f82961af9294b3f9bea0a350', ...trace}, null, 2) + '\n');
console.log(`Rendered ${trace.records.length} native comparisons (${trace.width}×${trace.height}), lossless WebP.`);
