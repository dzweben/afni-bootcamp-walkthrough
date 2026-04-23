# Lecture 5 — Alignment

**Status:** Stub — we'll build this out in Session 5.

**Official PDF:** [afni14_alignment.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni14_alignment.pdf)

## What this lecture answers

> "How do I get EPI, anatomy, and template into the same space — and how do I know it worked?"

## Planned sections (to be filled in during Session 5)

- The three alignments you need: EPI→EPI (motion), EPI→anat (co-registration), anat→template (normalization)
- Why the order matters, and what a concatenated warp is
- `align_epi_anat.py` — the workhorse, and its cost functions (`lpc`, `lpa`, `lpc+ZZ`)
- `@SSwarper` for template alignment (vs. older `@auto_tlrc`)
- **QC is everything** — looking at alignment with `@chauffeur_afni`, overlay flickers
- Common failure modes: skull left on, wrong obliquity, swapped L/R

## Exit criteria

- Run EPI→anat alignment on the FT dataset and QC the result
- Explain why we almost never register EPI directly to template
- Identify an obviously-failed alignment from a QC snapshot
- Connect this to what DTI registration had to solve (and where the tradeoffs differ)
