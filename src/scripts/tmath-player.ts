import type {HostThemePalette, TMathScene} from '../../public/tmath/runtime/client';
import {readTMathPalette} from './tmath-theme';

type Modules = {
  createTMath: typeof import('../../public/tmath/runtime/client').createTMath;
  compileScene: typeof import('../../public/tmath/runtime/client').compileScene;
  tmath: typeof import('../../public/tmath/runtime/client').tmath;
  themeLua: (source: string, palette: HostThemePalette) => string;
  fonts: [string, ArrayBuffer][];
};
const fontFiles = [
  ['Pretendard', 'Pretendard.ttf'],
  ['Source Serif 4', 'SourceSerif4-Semibold.ttf'],
  ['IBM Plex Sans KR', 'IBMPlexSansKR-SemiBold.ttf'],
  ['CMUTypewriter-Regular', 'CMUTypewriter-Regular.ttf'],
] as const;
const assets = new Map<string, Promise<Modules>>();
function loadAssets(base: string) {
  let pending = assets.get(base);
  if (!pending) {
    pending = Promise.all([
      import(/* @vite-ignore */ `${base}tmath/runtime/client.js`),
      import(/* @vite-ignore */ `${base}tmath/theme.mjs`),
      Promise.all(fontFiles.map(async ([name, file]): Promise<[string, ArrayBuffer]> => {
        const response = await fetch(`${base}tmath/runtime/${file}`);
        if (!response.ok) throw new Error(`Font HTTP ${response.status}`);
        return [name, await response.arrayBuffer()];
      })),
    ]).then(([runtime, theme, fonts]) => ({...runtime, themeLua: theme.themeLua, fonts}));
    assets.set(base, pending);
    pending.catch(() => assets.delete(base));
  }
  return pending;
}

class TMathPlayer extends HTMLElement {
  private runtime?: TMathScene;
  private controller?: AbortController;
  private observer?: IntersectionObserver;
  private themeObserver?: MutationObserver;
  private reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
  private pending?: Promise<boolean>;
  private sceneSource?: string;
  private themeLua?: Modules['themeLua'];
  private paletteKey = '';
  private visible = false;
  private showingPoster = true;
  private renderCanvas = document.createElement('canvas');
  private get duration() {
    return (this.dataset.end ? Number(this.dataset.end) : this.runtime?.duration ?? 0) + Number(this.dataset.hold ?? 0);
  }
  private frame = 0;
  private time = 0;
  private playing = false;
  private loading = false;
  private autoplayPaused = false;
  private controlsTimer = 0;
  private get canvas() { return this.querySelector('canvas')!; }
  private get playButton() { return this.querySelector<HTMLButtonElement>('[data-play]')!; }
  private get seek() { return this.querySelector<HTMLInputElement>('[data-seek]')!; }

  connectedCallback() {
    if (this.controller) return;
    this.controller = new AbortController();
    const {signal} = this.controller;
    this.playButton.addEventListener('click', () => this.toggle(), {signal});
    const screen = this.querySelector<HTMLButtonElement>('[data-toggle]')!;
    screen.addEventListener('click', () => this.toggle(), {signal});
    screen.addEventListener('pointerup', event => {
      if (event.pointerType === 'touch') {
        this.dataset.controls = 'visible';
        window.clearTimeout(this.controlsTimer);
        this.controlsTimer = window.setTimeout(() => delete this.dataset.controls, 2200);
      }
    }, {signal});
    screen.addEventListener('keydown', event => {
      if (!this.runtime || !['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;
      event.preventDefault(); this.autoplayPaused = true; this.pause();
      this.showingPoster = false;
      this.time = event.key === 'Home' ? 0 : event.key === 'End' ? this.duration
        : Math.max(0, Math.min(this.duration, this.time + (event.key === 'ArrowLeft' ? -5 : 5)));
      this.draw();
    }, {signal});
    this.querySelector('.tmath-controls-zone')!.addEventListener('click', event => {
      if (event.target === event.currentTarget) this.toggle();
    }, {signal});
    this.addEventListener('keydown', event => {
      if (event.key === 'Escape') this.querySelector<HTMLDetailsElement>('[data-settings]')!.open = false;
    }, {signal});
    this.querySelector('[data-speed]')!.addEventListener('change', () => {
      this.querySelector<HTMLDetailsElement>('[data-settings]')!.open = false;
    }, {signal});
    this.seek.addEventListener('input', () => {
      this.autoplayPaused = true; this.pause();
      this.showingPoster = false;
      const value = Number(this.seek.value);
      const duration = this.runtime ? this.duration : value;
      this.time = duration - value < Number(this.seek.step) ? duration : value;
      this.draw();
    }, {signal});
    this.querySelector('[data-fullscreen]')!.addEventListener('click', async () => {
      try {
        if (document.fullscreenElement === this) await document.exitFullscreen();
        else await this.requestFullscreen();
      } catch { this.querySelector('[data-status]')!.textContent = '이 브라우저에서는 전체 화면을 지원하지 않습니다.'; }
    }, {signal});
    window.addEventListener('tmath:play', (event) => { if ((event as CustomEvent).detail !== this) this.pause(); }, {signal});
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) this.pause();
      else void this.present();
    }, {signal});
    this.reducedMotion.addEventListener('change', () => {
      if (this.reducedMotion.matches) this.pause();
      else this.autoplay();
    }, {signal});
    window.addEventListener('pagehide', () => this.release(), {signal});
    window.addEventListener('pageshow', () => { void this.present(); }, {signal});
    this.themeObserver = new MutationObserver(() => {
      if (!this.visible) return;
      if (this.runtime) {
        try { this.applyTheme(); this.draw(); }
        catch (error) { this.pause(); this.showError(error); }
      } else void this.present();
    });
    this.themeObserver.observe(document.documentElement, {attributes: true, attributeFilter: ['data-theme']});
    this.observer = new IntersectionObserver(entries => {
      this.visible = entries[0].isIntersecting;
      if (!this.visible) this.release();
      else void this.present();
    });
    this.observer.observe(this);
  }

  disconnectedCallback() {
    this.controller?.abort(); this.controller = undefined;
    this.visible = false;
    this.observer?.disconnect(); this.themeObserver?.disconnect();
    window.clearTimeout(this.controlsTimer); this.release();
  }

  private playbackState(playing: boolean) {
    this.playing = playing;
    this.dataset.state = playing ? 'playing' : 'paused';
    for (const button of this.querySelectorAll('[data-play], [data-toggle]')) {
      button.setAttribute('aria-label', playing ? '일시정지' : '재생');
      button.setAttribute('aria-pressed', String(playing));
    }
    this.querySelector('[data-status]')!.textContent = playing ? '재생 중' : '일시정지';
  }

  private pause() {
    cancelAnimationFrame(this.frame);
    if (!this.loading) this.playbackState(false);
  }

  private release() {
    this.pause(); this.runtime?.destroy(); this.runtime = undefined;
    this.seek.disabled = true; delete this.dataset.ready;
  }

  private autoplay() {
    if (this.dataset.autoplay !== 'true' || this.reducedMotion.matches || this.autoplayPaused || this.playing || this.loading || document.hidden) return;
    const bounds = this.getBoundingClientRect();
    if (bounds.bottom > 0 && bounds.top < window.innerHeight) void this.toggle(true);
  }

  private async toggle(automatic = false) {
    if (!automatic) this.autoplayPaused = this.playing;
    if (this.playing) { this.pause(); return; }
    if (!await this.initialize()) return;
    if (this.playing) return;
    if (!this.runtime || !this.isConnected) return;
    const bounds = this.getBoundingClientRect();
    if (document.hidden || bounds.bottom <= 0 || bounds.top >= window.innerHeight) { this.release(); return; }
    this.showingPoster = false;
    if (this.time >= this.duration) this.time = 0;
    window.dispatchEvent(new CustomEvent('tmath:play', {detail: this}));
    this.playbackState(true);
    let last = performance.now();
    const tick = (now: number) => {
      if (!this.runtime || !this.playing) return;
      const speed = Number(this.querySelector<HTMLSelectElement>('[data-speed]')!.value);
      this.time = Math.min(this.duration, this.time + Math.max(0, Math.min((now - last) / 1000, 0.1)) * speed);
      last = now; this.draw();
      if (this.time >= this.duration) {
        if (this.dataset.loop === 'true') this.time = 0;
        else { this.pause(); return; }
      }
      this.frame = requestAnimationFrame(tick);
    };
    this.draw(); this.frame = requestAnimationFrame(tick);
  }

  /** A visible, paused player shows the authored final frame in the current theme. */
  private async present() {
    if (!this.visible || document.hidden || !await this.initialize()) return;
    if (!this.visible || !this.isConnected) { this.release(); return; }
    this.applyTheme(); this.draw(); this.autoplay();
  }

  private initialize(): Promise<boolean> {
    if (this.runtime) return Promise.resolve(true);
    if (this.pending) return this.pending;
    this.loading = true; this.playButton.disabled = true; this.dataset.state = 'loading';
    const signal = this.controller!.signal;
    this.pending = (async () => {
      let runtime: TMathScene | undefined;
      try {
        const {createTMath, compileScene, tmath, themeLua, fonts} = await loadAssets(this.dataset.base!);
        if (signal.aborted) return false;
        runtime = await createTMath(tmath.scene({width: 960, height: 640}), 'bootstrap.js', {renderEngine: 'cpu'});
        if (signal.aborted) { runtime.destroy(); return false; }
        for (const [name, font] of fonts) runtime.font(name, font, 'ttf');
        if (!this.sceneSource) {
          if (this.dataset.source) {
            const response = await fetch(this.dataset.source, {signal});
            if (!response.ok) throw new Error(`Scene HTTP ${response.status}`);
            this.sceneSource = await response.text();
          } else {
            const {buildEpisode} = await import(/* @vite-ignore */ `${this.dataset.base}tmath/postprocessing/scenes.mjs`);
            if (signal.aborted) { runtime.destroy(); return false; }
            this.sceneSource = compileScene(buildEpisode(this.dataset.scene!).scene);
          }
        }
        if (signal.aborted) { runtime.destroy(); return false; }
        this.themeLua = themeLua; this.runtime = runtime; this.paletteKey = '';
        this.applyTheme();
        this.seek.max = String(this.duration); this.seek.disabled = false;
        this.querySelector<HTMLElement>('[data-error]')!.hidden = true;
        this.dataset.ready = 'true';
        if (!this.visible) { this.release(); return false; }
        return true;
      } catch (error) {
        runtime?.destroy(); this.runtime = undefined;
        if (!signal.aborted) this.showError(error);
        return false;
      } finally {
        this.pending = undefined; this.loading = false; this.playButton.disabled = false; this.pause();
      }
    })();
    return this.pending;
  }

  private applyTheme() {
    if (!this.runtime || !this.sceneSource || !this.themeLua) return;
    const palette = readTMathPalette();
    const key = JSON.stringify(palette);
    if (key === this.paletteKey) return;
    this.runtime.hostTheme(palette);
    this.runtime.loadLua(this.themeLua(this.sceneSource, palette), `${this.dataset.scene}.${this.dataset.source ? 'lua' : 'js'}`);
    this.paletteKey = key;
  }

  private showError(error: unknown) {
    const message = this.querySelector<HTMLElement>('[data-error]')!;
    message.textContent = '애니메이션을 불러오지 못했습니다. 재생을 눌러 다시 시도해 주세요.';
    message.hidden = false;
    console.error('tmath player initialization failed', error);
  }

  private draw() {
    if (!this.runtime) return;
    const end = this.dataset.end ? Number(this.dataset.end) : this.runtime.duration;
    const time = this.showingPoster ? end : Math.min(this.time, end);
    if (this.dataset.crop) {
      const [x, y, width, height] = this.dataset.crop.split(',').map(Number);
      this.runtime.draw(this.renderCanvas, time);
      if (this.canvas.width !== width) this.canvas.width = width;
      if (this.canvas.height !== height) this.canvas.height = height;
      const context = this.canvas.getContext('2d')!;
      context.clearRect(0, 0, width, height);
      context.drawImage(this.renderCanvas, x, y, width, height, 0, 0, width, height);
    } else {
      this.runtime.draw(this.canvas, time);
    }
    this.canvas.hidden = false; this.querySelector('img')!.hidden = true;
    this.seek.value = String(this.time);
    const format = (t: number) => `${Math.floor(t / 60)}:${String(Math.floor(t % 60)).padStart(2, '0')}`;
    this.querySelector('output')!.textContent = `${format(this.time)} / ${format(this.duration)}`;
    this.seek.setAttribute('aria-valuetext', `${this.time.toFixed(1)}초 / ${this.duration.toFixed(1)}초`);

  }
}

if (!customElements.get('tmath-player')) customElements.define('tmath-player', TMathPlayer);
