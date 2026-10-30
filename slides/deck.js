// draws the ESCP-style network of dots and lines; seeded so every load looks the same
function drawNetwork(svg, seed){
  let s = seed;
  const rand = () => (s = (s * 16807) % 2147483647) / 2147483647;
  const width = 1600, height = 900, points = [];
  for (let index = 0; index < 90; index++) points.push([rand() * width, rand() * height, 1.5 + rand() * 3.5]);
  svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
  svg.setAttribute('preserveAspectRatio', 'xMidYMid slice');
  let markup = '';
  points.forEach((point, index) => {
    points.slice(index + 1).forEach(other => {
      const distance = Math.hypot(point[0] - other[0], point[1] - other[1]);
      if (distance < 210) markup += `<line x1="${point[0]}" y1="${point[1]}" x2="${other[0]}" y2="${other[1]}" stroke="#fff" stroke-opacity="${(0.16 * (1 - distance / 210)).toFixed(3)}" stroke-width="1.2"/>`;
    });
  });
  points.forEach(point => markup += `<circle cx="${point[0]}" cy="${point[1]}" r="${point[2]}" fill="#fff" fill-opacity=".22"/>`);
  svg.innerHTML = markup;
}
document.querySelectorAll('svg.net').forEach((svg, index) => drawNetwork(svg, 7 + index * 101));

// ESCP logo, talk title and slide number on every framed slide
// footer shows the section a slide belongs to; dividers get their section numeral
const SECTIONS = ['', 'what is analytics engineering', 'the problems', 'where analytics engineers add value', 'dbt', 'artificial intelligence', 'other tools'];
const slides = [...document.querySelectorAll('.slide')];
let section = 0;
slides.forEach((slide, index) => {
  const kicker = slide.querySelector('.kicker');
  if (kicker) {
    section = parseInt(kicker.textContent.match(/\d+/)[0], 10);
    slide.insertAdjacentHTML('beforeend', `<div class="big-num" aria-hidden="true">0${section}</div>`);
  }
  slide.classList.add(`t${section || 1}`);
  slide.dataset.section = section || 1;
  const sheet = slide.querySelector('.sheet');
  if (!sheet) return;
  const footer = section ? `section 0${section} · ${SECTIONS[section]}` : 'how analytics engineers help transform data into insights';
  sheet.insertAdjacentHTML('beforeend',
    `<img class="logo" src="assets/escp.png" alt="ESCP Business School"><span class="foot">${footer}</span><span class="num">${index + 1}</span>`);
});

// each slide's content rises in, in reading order
const GROUPS = '.cols,.chips,.with-tree,.main';
function collectItems(parent, items){
  for (const child of parent.children) {
    if (child.matches('.sticker')) continue;
    if (child.matches(GROUPS)) collectItems(child, items); else items.push(child);
  }
  return items;
}
slides.forEach(slide => {
  const pad = slide.querySelector('.pad');
  if (pad) collectItems(pad, []).forEach((item, index) => { item.classList.add('anim'); item.style.setProperty('--i', Math.min(index, 12)); });
});
function enter(slide){ slide.classList.remove('enter'); void slide.offsetWidth; slide.classList.add('enter'); }

// the dbt project tree, with the folders a slide talks about outlined
const TREE = [['.github/workflows','dir'],['analyses','dir'],['docs','dir'],['macros','dir'],['models','dir'],['seeds','dir'],['snapshots','dir'],['tests','dir'],
  ['.gitignore','file'],['.pre-commit-config.yaml','file'],['LICENSE','file'],['README.md','file'],['dbt_project.yml','file'],['package-lock.yml','file'],['packages.yml','file'],['poetry.lock','file'],['pyproject.toml','file']];
document.querySelectorAll('ul.tree').forEach(tree => {
  const highlighted = tree.dataset.on.split(',');
  tree.setAttribute('aria-label', `dbt project folders, highlighting ${highlighted.join(', ')}`);
  tree.innerHTML = TREE.map(([name, kind]) => `<li class="${kind}${highlighted.includes(name) ? ' on' : ''}">${name}</li>`).join('');
});

// a stepped slide's own section script sets slide.step(k) to draw step k
let current = 0;
function show(index, fromEnd = false){
  current = Math.max(0, Math.min(slides.length - 1, index));
  slides.forEach((slide, position) => slide.classList.toggle('on', position === current));
  enter(slides[current]);
  document.documentElement.style.setProperty('--progress', `${(current + 1) / slides.length * 100}%`);
  document.documentElement.style.setProperty('--now', `var(--s${slides[current].dataset.section})`);
  const stepper = slides[current].step;
  if (stepper) stepper(fromEnd ? +slides[current].dataset.steps - 1 : 0);
  document.getElementById('count').textContent = `${current + 1} / ${slides.length}`;
  history.replaceState(null, '', `#${current + 1}`);
}
function next(){
  const slide = slides[current], stepper = slide.step;
  if (stepper && +slide.dataset.k < +slide.dataset.steps - 1) return stepper(+slide.dataset.k + 1);
  show(current + 1);
}
function prev(){
  const slide = slides[current], stepper = slide.step;
  if (stepper && +slide.dataset.k > 0) return stepper(+slide.dataset.k - 1);
  show(current - 1, true);
}
document.getElementById('next').onclick = next;
document.getElementById('prev').onclick = prev;
document.addEventListener('keydown', event => {
  if (['ArrowRight', ' ', 'PageDown'].includes(event.key)) { event.preventDefault(); next(); }
  if (['ArrowLeft', 'PageUp'].includes(event.key)) { event.preventDefault(); prev(); }
});
// links that jump back to an earlier slide, numbered from wherever that slide now sits
document.querySelectorAll('a[data-goto]').forEach(link => {
  const index = slides.indexOf(document.getElementById(link.dataset.goto));
  link.href = `#${index + 1}`;
  if (!link.textContent.trim()) link.textContent = `slide ${index + 1}`;
  link.addEventListener('click', event => { event.preventDefault(); show(index); });
});
document.querySelectorAll('.slide a[href^="http"]').forEach(link => { link.target = '_blank'; link.rel = 'noopener'; });
show((parseInt(location.hash.slice(1), 10) || 1) - 1);
