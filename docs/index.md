# AFNI Bootcamp — An Interactive Walkthrough

Welcome. This is a **living, concept-first** companion to the official [AFNI Bootcamp](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/educational/bootcamp_stuff.html) — built session-by-session with the help of Claude, and tuned for someone who is **pipeline-strong but wants to build the neuroimaging intuition underneath**.

## Why this exists

The official NIMH AFNI Bootcamp is excellent, but the videos are long and the PDFs alone lack narration. This site is the version I would have wanted: each lecture distilled into an interactive, dialogic walkthrough, with the *why* before the *how*, running on a real HPC cluster, with screenshots and working commands you can copy-paste.

## How to use it

- **Read in order.** Each lecture builds on the last.
- **Run the code blocks.** Every command here was tested on our setup.
- **Look for the callouts.** Admonitions flag common pitfalls:
  - !!! tip "Intuition"
  - !!! warning "Pitfall"
  - !!! note "Compare with DTI/FSL"
- The official AFNI PDFs are linked at the top of each lecture — use this site *alongside* them, not instead of them.

## Curriculum — Day 1

| # | Lecture | Official PDF | Status |
|---|---------|--------------|--------|
| 1 | Intro to AFNI + FMRI data | [afni01_intro.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni01_intro.pdf) | ✅ Complete |
| 2 | Regression — Part 1 | [afni05_regression.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni05_regression.pdf) | Pending |
| 3 | Regression — Part 2 | [RegressionHandsOn.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/RegressionHandsOn.pdf) | Pending |
| 4 | AFNI GUI — Part 2 | [afni03_interactive.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni03_interactive.pdf) | Pending |
| 5 | Alignment | [afni14_alignment.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni14_alignment.pdf) | Pending |

## Setup

Before starting Lecture 1, make sure you can SSH into the compute environment and that AFNI is installed. See [Cluster + AFNI install](setup/cluster-setup.md).

## Credits

- **Course materials:** © NIMH / NIH AFNI Team ([afni.nimh.nih.gov](https://afni.nimh.nih.gov)) — public domain.
- **Narration, structure, hands-on notes:** Danny Zweben, with [Claude](https://claude.com/claude-code).
