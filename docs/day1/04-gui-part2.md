# Lecture 4 — AFNI GUI, Part 2 (Interactive)

**Status:** Stub — we'll build this out in Session 4.

**Official PDF:** [afni03_interactive.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni03_interactive.pdf)

## What this lecture answers

> "Now that I have stats maps, how do I explore them interactively?"

## Planned sections (to be filled in during Session 4)

- The stats sub-brick picker — choosing what to overlay and what to threshold on
- Graph viewer: timeseries under the crosshair, model fit overlay
- "Cluster" panel — thresholding + cluster-extent logic
- Talairach Daemon atlas lookup at the crosshair
- `plugout` — driving AFNI from the command line while it stays open (scripting demos)
- ROI drawing with the Draw Dataset plugin

## Exit criteria

- Load a `stats.*+tlrc` dataset and inspect a specific contrast
- Threshold at a given t-value + cluster-extent, and read off cluster table
- Pull up the model fit for a single voxel in the graph window
- Explain how AFNI's cluster-extent differs from AFNI's own `3dClusterize` output (preview for Day 2/3)
