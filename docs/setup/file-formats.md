# AFNI file formats — a short primer

Before we open the GUI, you need to understand the one thing about AFNI that confuses newcomers: **a single dataset is two files**.

## BRIK + HEAD

AFNI's native format splits a dataset into:

- `*.HEAD` — ASCII metadata (orientation, voxel size, stats, sub-brick labels)
- `*.BRIK` (often `.BRIK.gz`) — the raw voxel data

They always travel together. Losing one orphans the other.

```
anat+orig.HEAD
anat+orig.BRIK.gz
```

The `+orig` suffix is a **space tag**: the dataset is in original scanner space. Other tags: `+acpc` (AC-PC aligned) and `+tlrc` (Talairach / template space).

!!! note "Compare with FSL/SPM"
    FSL and SPM use NIfTI (`.nii` or `.nii.gz`) — a single file with a header prefix. AFNI reads and writes NIfTI fine; BRIK/HEAD is just the native format with richer metadata baked in.

## Sub-bricks

An AFNI dataset is a **4D volume**: (x, y, z, t). That "t" axis holds "sub-bricks":

- For functional timeseries, sub-bricks are timepoints (TRs).
- For stats outputs (e.g. from `3dDeconvolve`), each sub-brick is a different quantity: beta coefficient, t-stat, F-stat, etc.

You reference a sub-brick with square brackets:

```bash
3dinfo stats.FT+tlrc'[3]'            # info on sub-brick 3
3dcalc -a stats.FT+tlrc'[Vrel#0_Coef]' -expr 'a' -prefix beta_vrel
```

The single quotes protect the brackets from the shell.

## Common files you'll see in AFNI_data6

| File | What it is |
|------|-----------|
| `FT_anat+orig.{HEAD,BRIK.gz}` | T1 anatomical in original space |
| `FT_epi_r1+orig.{HEAD,BRIK.gz}` | EPI run 1, raw |
| `pb00.FT.r01.tcat+orig` | "pb00" = preprocessing block 0; tcat = timeseries concatenation |
| `stats.FT+tlrc` | Regression output — many sub-bricks |
| `TT_N27+tlrc` | The Talairach template brain |

## Quick inspection commands

```bash
3dinfo anat+orig                  # dump header
3dinfo -label2index "Vrel#0_Coef" stats.FT+tlrc   # find sub-brick index by label
3dBrickStat -mean -mask mask+tlrc stats.FT+tlrc'[0]'   # mean within mask
```

!!! tip "Intuition"
    Think of a BRIK/HEAD pair as one logical "dataset object" — the GUI treats it that way, and so should you. When you `cp` or `mv`, always move both files.
