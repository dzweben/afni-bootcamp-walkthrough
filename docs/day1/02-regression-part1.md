# Lecture 2 — Regression, Part 1

**Status:** Stub — we'll build this out in Session 2.

**Official PDF:** [afni05_regression.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni05_regression.pdf)

## What this lecture answers

> "What does `3dDeconvolve` actually compute, and why that way?"

## Planned sections (to be filled in during Session 2)

- The GLM in 2 minutes, keyed off Danny's RSA background
- What a design matrix *is* (and why the HRF is convolved in, not just added)
- Regressors of interest vs. nuisance regressors
- Assumptions: linearity, additivity, known HRF shape
- Why AFNI separates `3dDeconvolve` (model setup + solve) from `3dREMLfit` (better noise model)
- Reading the output sub-bricks

## Exit criteria

- Write out what each row / column of a design matrix represents for a simple block design
- Explain why motion regressors go in the model rather than being "regressed out" first
- Identify `Coef`, `Tstat`, `Fstat`, `R^2` sub-bricks in a `3dDeconvolve` output
