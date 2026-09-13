import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {writeFile} from 'node:fs/promises';

const binary = process.argv[2];
if (!binary) throw new Error('Pass the compiled postprocessing-native-trace executable.');
const run = args => JSON.parse(execFileSync(binary, args, {encoding: 'utf8', maxBuffer: 8 * 1024 * 1024}));
const trace = run([]), variant = run(['perturbed']);
for (const sample of [trace, variant]) {
  assert.ok(sample.verifiedCanvasMatch && sample.verifiedSpanReplay && sample.verifiedBlurReplay);
  assert.ok(sample.verifiedDeferredComposition && sample.verifiedParentRestored);
  assert.deepEqual(sample.parentBeforeComposite, sample.background);
  assert.equal(sample.buffers.temporaryPeak, 2);
  assert.ok(sample.buffers.reusedNextDraw && sample.buffers.fillInPlace);
}
assert.notDeepEqual(trace.tasks[1].spans, variant.tasks[1].spans);
assert.notDeepEqual(trace.final, variant.final);
trace.sourceCommit = 'b4471844c3c2f849ce82e0825798e2696a4a2cad';
trace.point = [14, 14];
await writeFile(new URL('../public/tmath/postprocessing/native-trace.mjs', import.meta.url),
  '// Generated from the unmodified ThorVG CPU engine by scripts/generate-postprocessing-trace.mjs.\nexport default ' + JSON.stringify(trace) + ';\n');
console.log('Native chain and parent composition match Canvas::draw(); asymmetric variant verified.');
