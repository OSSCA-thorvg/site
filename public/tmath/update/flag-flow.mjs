// Shared layout for initial preparation and selective invalidation.
// Shapes and result bars denote Paint/RenderData identities, not measured RLE.
export function buildFlagFlow(d, model, initial) {
  const {scene, group, text, rect, line, arrow, shape, show, hide, play, beat, finish} = d;
  const ink = '#222222', muted = '#757575';
  text(scene, initial ? 'First update' : 'Update A', 640, 70, 30);
  text(scene, 'Paint', 400, 170, 22, muted);
  text(scene, 'Flags', 650, 170, 22, muted);
  text(scene, 'RenderData', 1040, 170, 22, muted);
  const root = rect(scene, 140, 440, 170, 64, ink, ink);
  text(scene, 'Scene', 140, 440, 24, '#ffffff', root.key);
  line(scene, [[225, 440], [280, 440]], ink);
  const flags = group(), results = group(), empty = group();
  const changed = group(), updated = group();
  const paintings = [], glyphs = [];
  for (const [i, paint] of model.paints.entries()) {
    const y = 290 + i * 300, color = i ? '#1f6bc4' : '#e66121';
    arrow(scene, [[280, 440], [280, y], [320, y]], ink, []);
    const painting = group();
    shape(painting, paint.id, 400, y, color);
    text(scene, paint.id, 400, y + 90, 24, color);
    paintings.push(painting);
    arrow(flags, [[460, y], [535, y]], ink, []);
    const flag = rect(flags, 650, y, 220, 80, '#ffffff', color);
    const parts = paint.effectiveFlag.split(' | ');
    if (parts.length > 1) {
      text(flags, parts.slice(0, 2).join(' | '), 650, y - 17, 20, color, flag.key);
      text(flags, parts.slice(2).join(' | '), 650, y + 17, 20, color, flag.key);
    } else text(flags, paint.effectiveFlag, 650, y, 22, color, flag.key);
    arrow(results, [[770, y], [925, y]], color, []);
    text(results, initial ? 'prepare' : i ? 'reuse' : 'update', 846, y - 32, 21, color);
    rect(scene, 1040, y, 210, 140, '#ffffff', ink);
    text(scene, paint.id + ' · rd', 1040, y + 100, 22, color);
    if (initial) text(empty, 'Empty', 1040, y, 23, muted);
    const glyph = group();
    for (let row = 0; row < 4; row++) rect(glyph, 1040, y - 36 + row * 24,
      i ? 130 : 40 + row * 30, 12, color, '#00000000', 0);
    glyphs.push(glyph);
  }
  if (!initial) text(changed, `${model.rotation}°  ·  ×${model.scale}`, 400, 410, 21, '#e66121');
  text(updated, 'Ready', 640, 780, 23, muted);
  if (initial) {
    // Keep the initial empty records visible, then reveal flags and prepared data.
    beat('Both Paints start without prepared data.', .8);
    show(flags);
    show(results);
    hide(empty);
    for (const glyph of glyphs) show(glyph);
    beat('Both Paints prepare their own RenderData.', 1.2);
  } else {
    beat('Both Paints retain prepared RenderData.', .8);
    show(changed);
    const angle = model.rotation * Math.PI / 180;
    const c = Math.cos(angle) * model.scale, s = Math.sin(angle) * model.scale;
    const [cx, cy] = d.p(400, 290);
    // Rotate and scale around A's display anchor, not the scene origin.
    play([{target: paintings[0], transform: [c,s,0,cx-c*cx-s*cy, -s,c,0,cy+s*cx-c*cy, 0,0,1,0, 0,0,0,1]}], 1);
    show(flags);
    show(results);
    beat('A changes; B reuses its existing RenderData.', 1.2);
    const next = group();
    // Horizontal slices remain horizontal after the path transforms.
    // These are compact symbolic records, not native RLE samples.
    const vertices = [[-10,-37],[-38,32],[39,32]].map(([x,y]) => [c*x-s*y,s*x+c*y]);
    const low = Math.min(...vertices.map(v => v[1])), high = Math.max(...vertices.map(v => v[1]));
    for (let row = 0; row < 4; row++) {
      const y = low + (row + .5) * (high-low) / 4, hits = [];
      for (let i = 0; i < 3; i++) {
        const a = vertices[i], b = vertices[(i+1)%3];
        if ((a[1] <= y && y < b[1]) || (b[1] <= y && y < a[1]))
          hits.push(a[0] + (y-a[1]) * (b[0]-a[0]) / (b[1]-a[1]));
      }
      const left = Math.min(...hits), right = Math.max(...hits);
      rect(next, 1040 + (left+right)/2, 290-36+row*24, right-left, 12, '#e66121', '#00000000', 0);
    }
    hide(glyphs[0], .2);
    show(next, .5);
  }
  show(updated);
  beat('Prepared data remains available for Draw.', 1.5);
  return finish(model);
}
