"""join the shell, shared styles, section files and shared script into dist/index.html"""
import shutil
from pathlib import Path

ROOT = Path(__file__).parent
DIST = ROOT / 'dist'


def build():
    sections = sorted((ROOT / 'sections').glob('*.html'))
    page = (
        (ROOT / 'shell.html').read_text()
        .replace('{{ css }}', (ROOT / 'deck.css').read_text())
        .replace('{{ sections }}', '\n'.join(section.read_text() for section in sections))
        .replace('{{ js }}', (ROOT / 'deck.js').read_text())
    )
    DIST.mkdir(exist_ok=True)
    (DIST / 'index.html').write_text(page)
    shutil.copytree(ROOT / 'assets', DIST / 'assets', dirs_exist_ok=True)
    print(f'built {DIST / "index.html"} from {len(sections)} section files')


if __name__ == '__main__':
    build()
