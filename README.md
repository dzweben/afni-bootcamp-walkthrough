# AFNI Bootcamp — Interactive Walkthrough

A concept-first, session-by-session companion to the [NIMH AFNI Bootcamp](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/educational/bootcamp_stuff.html), built as an MkDocs site.

**Live site:** https://dzweben.github.io/afni-bootcamp-walkthrough/

## Why

The official AFNI Bootcamp is excellent but the videos are long. This is the walkthrough I wanted: distilled concepts, working code, screenshots, and the *why* behind each step. Built alongside Claude, session by session.

## Layout

```
day1/pdfs/         — local mirror of official NIMH PDFs (gitignored; fetch with scripts/fetch-pdfs.sh)
docs/              — MkDocs source (becomes the site)
  index.md
  setup/           — cluster + file-format primers
  day1/            — one markdown file per lecture
assets/            — screenshots, figures
scripts/           — reusable shell snippets
mkdocs.yml
.github/workflows/ — GH Actions deploy
```

## Run locally

```bash
pip install --user mkdocs-material
python3 -m mkdocs serve
# → http://127.0.0.1:8000
```

## Deploy

Pushing to `main` triggers the GH Actions workflow in `.github/workflows/deploy.yml`, which builds and publishes to the `gh-pages` branch. GitHub Pages serves from there.

## Credits

Course materials © NIMH/NIH AFNI Team — public domain. Narration & structure: Danny Zweben with [Claude](https://claude.com/claude-code).
