// Presentation clocks only. Geometry and values belong to each native trace.
export const clamp = x => Math.max(0, Math.min(1, x));
export const smooth = x => { x = clamp(x); return x * x * (3 - 2 * x); };
export function localLoops(scene, {still = false, duration = 8, prefix = 'local'} = {}) {
  const tracks = [];
  let serial = 0;
  function track(sample, phase = 0) {
    const state = t => sample(((t + phase) % duration + duration) % duration);
    const first = state(still ? duration - phase - 1 : 0);
    const group = scene.group({id: `${prefix}-${serial++}`, opacity: first.opacity ?? 1,
      ...(first.transform ? {matrix: first.transform} : {})});
    if (!still) tracks.push({target: group, state});
    return group;
  }
  // Hold the completed construction, then clear locally before the next pass.
  const amount = (t, start, span = .3) => smooth((t - start) / span) * (1 - smooth((t - duration + .6) / .6));
  function reveal(phase, start, span = .25) {
    return still ? scene : track(t => ({opacity: amount(t, start, span)}), phase);
  }
  function finish() {
    if (still) return scene.wait(duration);
    let previous = tracks.map(t => t.state(0));
    for (let k = 1; k <= duration * 12; k++) {
      const changes = [];
      tracks.forEach(({target, state}, i) => {
        const next = state(k / 12), changed = {};
        for (const key of Object.keys(next)) if (JSON.stringify(next[key]) !== JSON.stringify(previous[i][key])) changed[key] = next[key];
        if (Object.keys(changed).length) changes.push({target, ...changed});
        previous[i] = next;
      });
      if (changes.length) scene.play(changes, 1 / 12, 'linear');
      else scene.wait(1 / 12);
    }
  }
  return {track, reveal, amount, finish, duration};
}
