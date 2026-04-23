# Day 1 — Overview

Day 1 of the NIMH AFNI Bootcamp covers four large ideas, split across five lectures:

1. **The AFNI GUI** — how to look at your data, in two passes (basic navigation → interactive stats viewing).
2. **Regression** — the GLM as AFNI frames it, in two passes (theory → hands-on with `3dDeconvolve`).
3. **Alignment** — anatomical/functional and subject/template registration.

## The five lectures

| # | Lecture | Core question it answers |
|---|---------|--------------------------|
| 1 | [AFNI GUI — Part 1](01-gui-part1.md) | "How do I open my data and look at it?" |
| 2 | [Regression — Part 1](02-regression-part1.md) | "What does `3dDeconvolve` actually compute, and why that way?" |
| 3 | [Regression — Part 2](03-regression-part2.md) | "How do I fit a real model to real data, end to end?" |
| 4 | [AFNI GUI — Part 2](04-gui-part2.md) | "Now that I have stats maps, how do I explore them interactively?" |
| 5 | [Alignment](05-alignment.md) | "How do I get EPI, anatomy, and template into the same space?" |

## Pacing

One lecture per session. Each session ~45 min of our time (more if you pause to experiment, which is encouraged).

## Before you start

Work through [Setup → Cluster + AFNI install](../setup/cluster-setup.md) and skim [AFNI file formats](../setup/file-formats.md). Lecture 1 assumes you can SSH in and that `afni -ver` prints a version string.
