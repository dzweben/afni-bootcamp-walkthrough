# Lecture 3 — Regression, Part 2 (Hands-on)

**Status:** Stub — we'll build this out in Session 3.

**Official PDF:** [RegressionHandsOn.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/RegressionHandsOn.pdf)

## What this lecture answers

> "How do I fit a real model to real data, end to end?"

## Planned sections (to be filled in during Session 3)

- Walk through `AFNI_data6/FT_analysis` — the canonical worked example
- Building the `3dDeconvolve` command piece by piece
- Stim timing files (`-stim_times`, `-stim_times_AM1`, `-stim_times_IM`)
- Basis functions: `BLOCK`, `TENT`, `GAM`, `SPMG`
- Contrasts with `-gltsym`
- Running, inspecting `Decon.xmat.1D`, and sanity-checking output

## Exit criteria

- Go from stim timing files + preprocessed EPI to a stats dataset
- Design a contrast and verify it maps to the expected columns of the design matrix
- Spot a broken design matrix (multicollinearity, empty regressor) before hitting `3dDeconvolve`
