import {tmath} from '../runtime/client.js';

export const colors = {ink: '#202020', muted: '#626262', line: '#555555',
  green: '#23896d', warning: '#bc573a', channels: ['#cc6452', '#389575', '#4a79ae', '#82919d']};
export const hex = c => '#' + c.map(v => Math.max(0, Math.min(255, Math.round(v))).toString(16).padStart(2, '0')).join('');
export const unpremultiply = c => c[3] === 0 || c[3] === 255 ? [...c] :
  c.slice(0, 3).map(v => Math.min(255, Math.floor(v * 255 / c[3]))).concat(c[3]);
export function displayed(c, mode = 'premul', background = 255) {
  const a = c[3] / 255;
  return c.slice(0, 3).map(v => mode === 'rgb' ? v :
    Math.min(255, Math.round((mode === 'straight' ? v * a : v) + background * (1 - a))));
}
export function crop(buffer, width, x, y, size) {
  return Array.from({length: size * size}, (_, i) => buffer[(y + Math.floor(i / size)) * width + x + i % size]);
}

// Screen plan in px, local geometry at 100 px/world unit. Images and pixel crops
// share the same canonical RGBA arrays; moving proxies are explicit snapshots.
export function alphaStage(id, width = 960, height = 720) {
  const scene = tmath.scene({width, height, fps: 30, loop: false,
    camera: {mode: 'fixed', view: '2d', height: height / 100},
    theme: {preset: 'pro_white', background: '#f2f2f2', text: Object.fromEntries(
      ['h1', 'h2', 'h3', 'text', 'code'].map(role => [role, {font: 'Pretendard', color: colors.ink}]))}});
  let serial = 0, time = 0;
  const textIds = [], textPolicies = {}, imageRegions = [], beats = [];
  const key = name => `${id}-${name}-${serial++}`;
  const point = (x, y) => [(x - width / 2) / 100, (height / 2 - y) / 100];
  const matrix = (x, y, size = 100) => {
    const [px, py] = point(x, y), s = size / 100;
    return [s,0,0,px, 0,s,0,py, 0,0,1,0, 0,0,0,1];
  };
  const group = () => scene.group({id: key('group')});
  function text(value, x, y, size = 20, parent = scene, color = colors.ink) {
    const name = key('label'); textIds.push(name); textPolicies[name] = {standalone: true};
    return parent.text({id: name, text: value, point: point(x, y), size, font: 'Pretendard',
      fill: color, role: 'text', align: [.5,.5], layer: 50});
  }
  function rect(x, y, w, h, fill = '#00000000', stroke = colors.line, parent = scene, border = 2, layer = 30) {
    return parent.rectangle({id: key('rect'), center: point(x, y), size: [w / 100, h / 100], fill, stroke, width: border, layer});
  }
  function line(x, y, xx, yy, parent = scene, color = colors.line, tip = 0) {
    return parent.route({id: key('line'), points: [point(x,y), point(xx,yy)], stroke: color, width: tip ? 2.5 : 2, tip, layer: 35});
  }
  function picture(buffer, n, x, y, size, {mode = 'premul', checker = true, parent = scene, tracked = true, layer = 20, transparent = false, opacity = 1, origin = [0,0], checkerStep = Math.max(2,Math.round(n/8))} = {}) {
    const owner = parent.group({id: key('picture'), matrix: matrix(x,y,size)});
    const name = key('pixels');
    const pixels = buffer.map((c, i) => transparent ? hex(mode==='premul'?unpremultiply(c):c) :
      hex(displayed(c, mode, checker ?
        ((Math.floor(((i % n)+origin[0])/checkerStep) + Math.floor((Math.floor(i/n)+origin[1])/checkerStep)) % 2 ? 224 : 247) : 255)));
    if (tracked) imageRegions.push(name);
    if (transparent) {
      // The frozen runtime reloads Image RGBA with a shared straight buffer,
      // premultiplying that buffer again on later draws. Immutable Cell patches
      // preserve the same RGBA grid when a transparent proxy moves or is replayed.
      // A nested owner retains group alpha while FadeIn reveals the outer owner.
      const paint = owner.group({id: name, opacity,
        matrix: [1/n,0,0,0, 0,1/n,0,0, 0,0,1,0, 0,0,0,1]});
      paint.cell({id: key('pixel-grid'), origin: [-n/2,-n/2], size: [n,n],
        mode: 'full', color: '#00000000', layer,
        patches: buffer.flatMap((c,i) => c[3] ? [{region: [i%n,n-1-Math.floor(i/n),1,1], color: pixels[i]}] : []),
      });
      return owner;
    }
    // FadeIn animates the owner to opacity 1. Keep the source-over multiplier
    // on its image so revealing or moving the proxy cannot replace it.
    owner.image({id: name, pixels, size: [n,n], center: [0,0], width: 1, filter: 'nearest', layer, opacity});
    owner.rectangle({id: key('image-border'), center: [0,0], size: [1,1],
      fill: '#00000000', stroke: colors.line, width: 2, layer: layer + 1});
    return owner;
  }
  function mark(x, y, size, n, px, py, count = 1, parent = scene) {
    const unit = size / n;
    return rect(x - size / 2 + (px + count / 2) * unit,
      y - size / 2 + (py + count / 2) * unit, count * unit, count * unit,
      '#00000000', colors.ink, parent, 2, 40);
  }
  function grid(x, y, size, n, parent) {
    for (let i=1;i<n;i++) {
      line(x-size/2+i*size/n,y-size/2,x-size/2+i*size/n,y+size/2,parent,'#ffffff88');
      line(x-size/2,y-size/2+i*size/n,x+size/2,y-size/2+i*size/n,parent,'#ffffff88');
    }
    rect(x,y,size,size,'#00000000',colors.line,parent);
  }
  function bytes(values, x, y, parent = scene, step = 56) {
    values.forEach((value,i) => {
      const xx=x+(i-1.5)*step;
      text('RGBA'[i],xx,y,13,parent,colors.channels[i]);
      text(String(value),xx,y+27,20,parent);
    });
  }
  function bars(values, x, y, parent = scene, length = 175) {
    return values.map((value,i) => {
      const yy=y+i*40;
      text('RGBA'[i],x-23,yy,17,parent,colors.channels[i]);
      rect(x+length/2,yy,length,11,'#dddddd','#00000000',parent,0);
      const owner=parent.group({id:key('bar'),matrix:matrix(x+Math.max(.5,value/255*length)/2,yy)});
      owner.rectangle({id:key('bar-body'),size:[Math.max(.5,value/255*length)/100,.11],
        fill:colors.channels[i],stroke:'#00000000',layer:32});
      text(String(value),x+length+33,yy,18,parent);
      return owner;
    });
  }
  function wait(seconds) {scene.wait(seconds);time+=seconds;}
  function show(target,seconds=.35) {scene.fadeIn(target,{duration:seconds});time+=seconds;}
  function hide(target,seconds=.15) {scene.fadeOut(target,{duration:seconds});time+=seconds;}
  function play(spec,seconds=.9) {scene.play(spec,seconds,'ease_in_out');time+=seconds;}
  function replace(old,next,seconds=.001) {hide(old,seconds);show(next,seconds);}
  function beat(label,hold=1.2) {beats.push({time:+time.toFixed(4),label});wait(hold);}
  function finish() {return {scene,beats,textIds,textPolicies,imageRegions,duration:time};}
  return {scene,key,point,matrix,group,text,rect,line,picture,mark,grid,bytes,bars,wait,show,hide,play,replace,beat,finish};
}
