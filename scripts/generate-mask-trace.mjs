import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {writeFile} from 'node:fs/promises';
import {trace as original, compositeTerms, pack} from '../public/tmath/postprocessing/native-evidence.mjs';

const binary = process.argv[2];
if (!binary) throw new Error('Pass the compiled mask-native-trace executable.');
const run = args => JSON.parse(execFileSync(binary, args, {encoding: 'utf8'}));
const baseline = run([]), shifted = run(['96', '1.25']), transparent = run(['0']);
for (const sample of [baseline, shifted, transparent]) {
  assert.ok(sample.verifiedCanvasMatch && sample.verifiedContextRestore && sample.verifiedMaskEndNoWrite);
  assert.equal(sample.maskBuffers, 1);
  assert.equal(sample.temporaryPeak, 3);
  assert.deepEqual(sample.filled, original.compositionInput);
  assert.deepEqual(sample.background, original.background);
  for (let i = 0; i < sample.final.length; i++) {
    const opacity = (sample.groupOpacity * sample.mask[i] + 255) >> 8;
    assert.equal(pack(compositeTerms(sample.filled[i], sample.background[i], opacity).result), sample.final[i]);
  }
}
assert.notDeepEqual(baseline.mask, shifted.mask);
assert.notDeepEqual(baseline.final, shifted.final);
assert.deepEqual(transparent.final, transparent.background);
baseline.sourceCommit = original.sourceCommit;
await writeFile(new URL('../public/tmath/postprocessing/mask-trace.mjs', import.meta.url),
  '// Native Alpha mask + effect trace; regenerate with scripts/generate-mask-trace.mjs.\nexport default ' + JSON.stringify(baseline) + ';\n');
console.log('Mask + effect nesting matches public Canvas; shifted/transparent variants and every output pixel verified.');
