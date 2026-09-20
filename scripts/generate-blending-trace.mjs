import fs from 'node:fs/promises';
import {execFileSync} from 'node:child_process';
const commit = '4d5810cf6f8d1c62dff4d9d3d291d3c2984074ad';
if (execFileSync('git', ['-C', 'thorvg', 'rev-parse', 'HEAD'], {encoding: 'utf8'}).trim() !== commit) throw Error('Use the pinned ThorVG checkout');
const binary = process.argv[2] ?? '/tmp/thorvg-blending-native';
const baseline = JSON.parse(execFileSync(binary, [], {encoding: 'utf8'}));
const variant = JSON.parse(execFileSync(binary, ['variant'], {encoding: 'utf8'}));
await fs.writeFile('public/tmath/blending/native-trace.mjs', `// Generated from pinned native CPU execution.\nexport const commit = '${commit}';\nexport default ${JSON.stringify(baseline)};\nexport const variant = ${JSON.stringify(variant)};\n`);
