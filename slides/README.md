# slides

The deck for the Introduction to Analytics Engineering session. It is published at https://jeremychia.github.io/escp-mbd-intro-to-ae-questions/ on every push to `main` that changes this folder.

## build and present

- [ ] Run `python3 slides/build.py`.
- [ ] Open `slides/dist/index.html` in a browser. It works offline.
- [ ] Use → and ← to move through the slides, or add `#12` to the URL to jump to slide 12.

## where things live

**Sections:** `sections/*.html` holds one file per section, joined in filename order. Section 04 (dbt) is split into four parts, `04a` to `04d`.

**Slide-specific code:** a section's charts, diagrams and stepped slides sit in a `<script>` at the end of its file.

**Shared styles:** `deck.css`.

**Shared behaviour:** `deck.js` numbers the slides, adds the footers, draws the dbt project tree and handles navigation.

**Page frame:** `shell.html` holds the `<head>` and the nav bar.

**Images:** `assets/`.

## edit

**Add a slide:** put a `<section class="slide card">` where it belongs in its section file. Slide numbers and footers are worked out when the page loads.

**Add a section:** add a divider slide with `<div class="kicker">section 07</div>`. Then add its footer title to `SECTIONS` in `deck.js`.

**Make a stepped slide:** give the slide `data-steps="n" data-k="0"`. In the section's script, set `slide.step = k => { … }` to draw step `k`. The arrow keys step through it before moving on.

**Link to another slide:** add `<a class="goto" data-goto="slide-id"></a>`. It is numbered automatically.
