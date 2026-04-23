# Lecture 1 — Intro to AFNI and FMRI Data

**Official PDF:** [afni01_intro.pdf](https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts/afni01_intro.pdf)

**The one thing to walk away with:** AFNI has a very particular idea of what a **dataset** is, and every program in the package — all 750+ of them — is built around that idea. Until that clicks, the GUI and the command line both feel like noise. After it clicks, everything else is navigation.

---

## Framing: why this lecture comes first

Most tutorials start by launching the GUI, clicking through menus, and showing you brains. We're going to delay that by ~45 minutes. Reason: the GUI only makes sense once you know what an **AFNI dataset** actually *is*. Otherwise it's three little windows full of pixels and no way to tell "overlay vs underlay" from "axial vs coronal" from "sub-brick #7 vs sub-brick #8."

So the plan:

1. Quick context on what AFNI is and who made it (1 min).
2. Refresh on BOLD + the hemodynamic response (5 min) — the signal AFNI is built to analyze.
3. **The AFNI data model** — dataset / voxel / sub-brick / header (15 min). This is the lecture.
4. File formats on disk: `+orig`, `+tlrc`, `.HEAD/.BRIK`, `.nii.gz` (10 min).
5. The program landscape — GUI, batch programs, super-scripts, SUMA (5 min).
6. **Hands-on** — SSH in, inspect real FT datasets with `3dinfo` (10 min).
7. Checkpoints (5 min).

---

## What AFNI is (and who made it)

- Written by **Bob Cox**, SSCC/NIMH, starting in **1994**. Still in active development.
- **AFNI** is both:
    - A **GUI program** (literally the executable named `afni`) for looking at brain data.
    - The **whole package** — 750+ command-line programs written in C, Python, tcsh, and R.
- Free, open source (GPL-2), lives on [GitHub](https://github.com/afni/AFNI).

Design principles that matter for how the rest of this course feels:

- **Stay close to the data.** Every intermediate can be inspected — there are no opaque binary blobs.
- **Mechanism, not policy.** AFNI gives you sharp tools; it doesn't hide defaults from you.
- **Educate the user.** This is why the bootcamp exists at all — Bob's position is that handing you a one-click pipeline without explaining it is malpractice.

!!! tip "Compare with FSL / SPM / MRtrix"
    FSL and SPM are more opinionated — more "here is *the* way." AFNI's stance is "here are the pieces, we'll show you three ways to assemble them, you pick." This is why people say AFNI has a steeper initial curve. The bootcamp is the cost of that philosophy.

---

## FMRI in five minutes

You know the gist from your RSA work, but let's nail the vocabulary we'll use for the rest of the week.

**BOLD signal** (Blood Oxygen Level Dependent):

- **1991** (Kwong et al.): MRI-measurable signal increases by a few percent *locally* a few seconds after neurons in that region fire more.
- The mechanism is indirect: active neurons → increased local blood flow → *more* oxygenated hemoglobin relative to deoxy → different magnetic susceptibility → measurable signal change.
- Crucial: we're measuring **hemodynamics**, not neurons. Anything that changes blood flow (caffeine, breathing, heart rate, vascular anatomy) shows up in the signal.

**The hemodynamic response function (HRF)** — internalize this shape, it shows up everywhere:

| Phase | Duration (approx) | What's happening |
|-------|-------------------|------------------|
| A — pre-activation baseline | — | resting signal |
| B — neural activity | ~20 s in the example | stimulus is "on" |
| C — delay | ~2 s | vascular response lags neural firing |
| D — rise | ~15 s | BOLD climbs |
| E — plateau | ~5 s | near peak |
| F — fall | ~15 s | return toward baseline |
| G — post-stimulus undershoot | variable | BOLD dips below baseline before recovering |

The full transient lasts ~30 seconds for a brief stimulus. This is why FMRI designs have long "blocks" or spaced events — you need the signal time to rise and fall.

**Pattern-matching in time.** Once you accept the HRF shape, the whole of task FMRI is:

> Convolve your stimulus timeseries with a canonical HRF. That's your predicted BOLD. Now for every voxel in the brain, ask: how well does the voxel's measured timeseries match this predicted timeseries?

Every voxel gets a regression coefficient ("beta") and a t-stat. Activation maps are thresholded t-stat maps. That's it — everything in regression land is a variation on this theme.

!!! note "Compare with DTI"
    In DTI you fit a tensor at each voxel from a *spatial* sampling of directions. In task FMRI you fit a linear model at each voxel from a *temporal* sampling of volumes. Different variable being the "repeated measure" (gradient direction vs. TR), same underlying massively-univariate spirit.

**Typical experiment scale:**

- ~500 volumes per run (at TR ≈ 2 s → 15-20 min of scanning).
- Multiple runs per subject — gives scanner + subject a break, and gives you independent estimates.
- Signal changes due to neural activity are **small** (a few percent). The battle is signal vs. physiological noise, head motion, scanner drift.

The Cox quote from the PDF: *"Be vigilant."* Non-optional.

---

## The AFNI data model — the core of this lecture

Here's where we slow down. These four terms are the entire conceptual load:

### Dataset

> The basic unit of data in AFNI. **A collection of one or more 3D arrays of numbers**, with auxiliary metadata, treated as one logical object.

A dataset can be:

- An **image dataset** — voxel values are scanner intensities (anatomicals, EPI timepoints).
- A **derived dataset** — voxel values are computed from other datasets (t-stats, betas, masks, ROIs).

Key idea: derived datasets are first-class. A stats map from `3dDeconvolve` isn't a "result file," it's a dataset, with the same structure and the same tools operating on it.

### Voxel

> A 3D pixel. One number per voxel per sub-brick.

Obvious but worth naming — neuroimaging-wide vocabulary.

### Sub-brick

> Each 3D array inside a dataset is a **sub-brick**. The dataset is the stack; each sub-brick is one slab of the stack.

```
dataset  =  [ sub-brick 0,  sub-brick 1,  sub-brick 2,  ...,  sub-brick N-1 ]
                 ↑
             each one is a full 3D volume:  (x, y, z) voxel grid
```

Indexed from 0. Referenced in the shell as `dataset+view'[3]'` — single-quote the brackets so the shell leaves them alone.

**What sub-bricks represent depends on the dataset type:**

| Dataset type | What a sub-brick is |
|--------------|---------------------|
| EPI timeseries (`3D+time`) | One volume = one TR (timepoint) |
| Anatomical | Usually 1 sub-brick (one structural volume) |
| `3dDeconvolve` stats output | A statistical quantity: `Coef`, `Tstat`, `Fstat`, `R^2`, ... each has its own sub-brick |
| Mask / ROI | Usually 1 sub-brick of integer labels |

!!! tip "Why this matters"
    AFNI doesn't have "separate files for the beta map and the t-map." They're sub-bricks of one `stats.*+tlrc` dataset, with labels. This is why you'll see `stats.FT+tlrc'[Vrel#0_Coef]'` — pull a specific *named* sub-brick. Much less bookkeeping than file-per-quantity workflows.

### Header

> All the auxiliary information about the dataset: voxel size, orientation, origin in scanner coordinates, time between sub-bricks (for 3D+time), statistical parameters per sub-brick, and a lot more.

The header is not optional decoration — it's what makes the voxel values *mean* something. Two datasets with identical numbers but different orientation headers will render in different parts of space.

Critical header fields you'll interact with constantly:

- **xyz voxel dimensions** (in mm).
- **Orientation**, encoded as a 3-letter code. `RAI` = first axis goes **R**ight-to-Left, second **A**nterior-to-Posterior, third **I**nferior-to-Superior — i.e. axial slicing. Our sample EPI is RAI; our sample anatomical is `ASL` (A-P, S-I, L-R — sagittal slicing).
- **Location in scanner coordinates** — the real-world origin. Needed for any kind of overlay.
- **TR** — time between sub-bricks, only meaningful for `3D+time` datasets.
- **Sub-brick labels** — e.g. `Vrel#0_Coef`, `Full_Fstat`.
- **Stat parameters per sub-brick** — e.g. a t-stat sub-brick stores its degrees of freedom so you don't have to remember them later. `3dinfo` will print them out.

---

## File formats on disk

### BRIK + HEAD (the AFNI native format)

Every native AFNI dataset is **two files**:

```
FT_anat+orig.HEAD       ← ASCII metadata
FT_anat+orig.BRIK       ← raw voxel data (often .BRIK.gz if compressed)
```

Both travel together. Losing one orphans the other.

### Views

A dataset lives in one of two **views** (coordinate systems), tagged in the filename:

| Tag | Meaning |
|-----|---------|
| `+orig` | Original scanner space |
| `+tlrc` | Aligned to a standard template (Talairach, MNI, ...). The header records which template. |

(`+acpc` used to be a third view — dataset rotated so the AC-PC line is horizontal. It's deprecated; everyone goes straight from `+orig` to `+tlrc` now.)

### Filenames

AFNI filenames are three parts:

```
prefix   +   view   .   suffix
──────       ────       ──────
FT_anat    +orig      .HEAD
stats.FT   +tlrc      .BRIK.gz
```

When you run any AFNI program that creates a dataset, you give the **prefix** (`-prefix foo`) and AFNI fills in the view and writes both the `.HEAD` and `.BRIK` / `.BRIK.gz`.

### NIfTI

AFNI reads and writes NIfTI-1 (`.nii` / `.nii.gz`) transparently. To write NIfTI instead of BRIK/HEAD, just end your prefix in `.nii` or `.nii.gz`:

```bash
3dcalc -a FT_anat+orig -expr 'a' -prefix anat_copy.nii.gz   # writes NIfTI
3dcalc -a FT_anat+orig -expr 'a' -prefix anat_copy          # writes anat_copy+orig.HEAD/.BRIK
```

One thing to know: the NIfTI spec's header can't cleanly represent per-slice timing in all cases. Tools like `dcm2niix_afni` sometimes lose this information on conversion. Fix: after conversion, use `3drefit -Tslices ...` to add it back (AFNI uses a NIfTI extension to store this). More in Lecture 5 when we get to alignment.

!!! tip "When to use which format"
    Stay in BRIK/HEAD while you're inside an AFNI pipeline — richer per-sub-brick metadata (labels, stat params). Export to NIfTI when handing datasets off to FSL, SPM, Python (`nibabel`), or sharing publicly.

### Other formats AFNI can ingest

ANALYZE 7.5 (`.hdr` / `.img`), MINC-1 (`.mnc`), CTF MEG (`.mri`, `.svl`), and ASCII (`.1D`, for timeseries and 1D text tables — you'll see these for stim timing files).

---

## From DICOM to AFNI dataset

You won't do this much in this course (we have preprocessed data), but worth knowing the shape:

| Tool | Use |
|------|-----|
| `Dimon` | Rick Reynolds' program; originally for realtime FMRI, also does offline DICOM → AFNI conversion. Strong with Siemens/GE stock. |
| `dcm2niix_afni` | Chris Rorden's converter, vendored into AFNI. Handles more DICOM variants than `Dimon`. Writes NIfTI. |
| `3drefit` | Edit a dataset's header in place. Used to patch slice-timing info that `dcm2niix_afni` couldn't preserve. |

Rule of thumb: start with `dcm2niix_afni`, check the output with `3dinfo`, and use `3drefit` if anything is missing or wrong.

---

## The AFNI program landscape (orientation)

You interact with AFNI in three modes:

1. **The GUI** (`afni`) — interactive viewer. We'll use this a lot in Lecture 4.
2. **Batch programs** — one-shot command-line tools. These are where all the real work happens. Names follow a pattern: programs starting with `3d` act on 3D datasets (`3dinfo`, `3dDeconvolve`, `3dvolreg`, `3dcalc`, `3dSkullStrip`, ...). You'll memorize ~15-20 of them over the week.
3. **Super-scripts** — Python wrappers that chain many `3d*` programs into standard pipelines. You'll mostly use two:
    - **`afni_proc.py`** — end-to-end single-subject preprocessing + first-level GLM.
    - **`align_epi_anat.py`** — EPI ↔ anatomical co-registration.

!!! tip "Danny — this is the analog of your DTI workflow"
    Your DTI pipeline was probably a shell script of `dwidenoise`, `dwifslpreproc`, `dwibiascorrect`, `dwi2tensor`, `tckgen`, ... That's the same pattern. `afni_proc.py` is the equivalent wrapper — each flag maps to a specific `3d*` call, and the script writes the full `proc.subj.*` tcsh file so you can inspect and edit it. We'll read one in Lecture 3.

**SUMA** deserves a mention: it's the AFNI *surface* viewer. It renders cortical surface meshes (imported from FreeSurfer / BrainVoyager / Caret) and can "talk" to an open `afni` GUI session so that clicking in one jumps the other. We won't touch SUMA today but it's there.

**AFNI Batch Programs (the starter set you'll learn this week):**

| Program | Purpose |
|---------|---------|
| `3dinfo` | Print a dataset's header. Your most-used command. |
| `3dDeconvolve` | Linear regression / GLM on 3D+time data. |
| `3dREMLfit` | Same GLM but with a better (ARMA) noise model. Runs after `3dDeconvolve`. |
| `3dvolreg` | Motion correction — register every sub-brick to a reference. |
| `3dcalc` | Voxel-wise calculator. `3dcalc -a X -b Y -expr 'a-b'` to subtract. |
| `3dresample` | Re-orient or re-grid a dataset. |
| `3dSkullStrip` | Strip skull from T1. |
| `3dANOVA` / `3dLME` / `3dLMEr` | Group-level mixed-effects. |
| `3dDWItoDT` | DTI tensor fit — AFNI's DTI toolbox (Bob had a DTI phase). |
| `3dsvm` | SVM-based MVPA. |

---

## Hands-on — look at real data with `3dinfo`

Everything up to here has been abstract. Now we actually put hands on the FT dataset. You'll SSH into the cluster, look at a raw EPI and a raw anatomical, and make the concepts concrete.

### 1. Connect

From your Mac terminal (Temple VPN connected):

```bash
expect -c '
spawn ssh -o StrictHostKeyChecking=no tur50045@155.247.67.31
expect "password:"
send "Milolab123!\r"
interact
'
```

Once inside, confirm AFNI is on `PATH`:

```bash
afni -ver
# Precompiled binary linux_ubuntu_16_64: May 23 2025 (Version AFNI_25.1.11 'Maximinus')
```

If that errors, `source ~/.bashrc` and try again.

### 2. Walk to the FT dataset

The "FT" subject is the canonical example throughout the AFNI bootcamp. Two runs of a visual/auditory paradigm ("visual reliable" vs "audio reliable"), standard T1.

```bash
cd /data/AFNIBootcamp_2025/CD/AFNI_data6/FT_analysis/FT
ls *.HEAD
# FT_anat+orig.HEAD  FT_epi_r1+orig.HEAD  FT_epi_r2+orig.HEAD  FT_epi_r3+orig.HEAD
```

Four datasets: one anatomical, three EPI runs. Each has a matching `.BRIK` right next to the `.HEAD` (or `.BRIK.gz`).

### 3. Inspect the anatomical

```bash
3dinfo -verb FT_anat+orig | head -20
```

What to notice in the output:

- `Dataset Type: Anat Bucket (-abuc)` — AFNI knows this is an anatomical.
- `Data Axes Orientation: [-orient ASL]` — Anterior-to-Posterior / Superior-to-Inferior / Left-to-Right. **Not RAI.** Real datasets come in whatever orientation the scanner sat in.
- Voxel grid: `256 × 256 × 175`, step `0.938 × 0.938 × 1.000 mm` — high-res isotropic-ish T1.
- `Number of values stored at each pixel = 1` — **one sub-brick.** A plain anatomical is a single 3D volume.

### 4. Inspect the EPI

```bash
3dinfo -verb FT_epi_r1+orig | head -25
```

Compare against the anat:

- `Dataset Type: Echo Planar (-epan)`.
- `80 × 80 × 33` voxels, `2.75 × 2.75 × 3.0 mm` — much coarser, because we're trading spatial resolution for speed (TR = 2 s).
- `-orient RAI` — different from the anat, as promised. Alignment (Lecture 5) exists precisely to reconcile these.
- `Number of time steps = 152  Time step = 2.00000s` — **this dataset has 152 sub-bricks, one per TR.** Scroll the 3dinfo output and you'll see them enumerated: `sub-brick #0`, `#1`, ..., `#151`. Each is a full 3D volume.

### 5. Pull a single sub-brick

You can extract one timepoint without copying the whole file. The selector syntax is `name+view'[index]'`:

```bash
3dinfo -nv  FT_epi_r1+orig          # just the number of sub-bricks
3dinfo -tr  FT_epi_r1+orig          # just the TR
3dBrickStat -mean  FT_epi_r1+orig'[0]'    # mean intensity of the first volume
3dBrickStat -mean  FT_epi_r1+orig'[75]'   # mean of volume 75
```

Notice the single quotes around `[0]` — that's shielding the brackets from the shell. If you forget, you'll get a glob error.

### 6. Peek at the HEAD file

```bash
head -40 FT_anat+orig.HEAD
```

It's ASCII — literal key/value attribute records. You can read it. You generally shouldn't edit it by hand (use `3drefit`), but you can tell how much AFNI is keeping.

---

## Checkpoint questions

Answer these without scrolling back:

1. **What two files make up an AFNI dataset, and what lives in each?**

    ??? answer "Show answer"
        `.HEAD` = ASCII metadata (orientation, voxel size, origin, sub-brick labels, stat params). `.BRIK` (or `.BRIK.gz`) = raw voxel numbers for all sub-bricks. Both travel together.

2. **A `3dDeconvolve` output dataset called `stats.FT+tlrc` has 80 sub-bricks. What might those sub-bricks be, and why would AFNI bundle them in one dataset?**

    ??? answer "Show answer"
        Each stimulus condition gets (at minimum) a `Coef` sub-brick (the beta) and a `Tstat` sub-brick. With multiple conditions, multiple basis functions per condition, a full-F, and several contrasts (`GLT`s), you quickly get into the dozens. Bundling them in one dataset with labels beats juggling dozens of separate files — same grid, same mask, same provenance.

3. **You run `ls` and see `FT_anat+orig.HEAD` but no `.BRIK`. What do you do?**

    ??? answer "Show answer"
        Don't touch the HEAD file — it's metadata only. The BRIK is either (a) compressed as `.BRIK.gz` (check with `ls *.BRIK*`) or (b) actually missing, in which case the dataset is broken and you need to recover the BRIK from backup.

4. **Danny-specific: you do RSA on first-level betas. In AFNI, where do those betas come from, and how would you subset them?**

    ??? answer "Show answer"
        They're `Coef` sub-bricks of the `stats.*+tlrc` dataset produced by `3dDeconvolve`. To subset, use label-based indexing: `stats.FT+tlrc'[Vrel#0_Coef]'` or find the numeric index with `3dinfo -label2index Vrel#0_Coef stats.FT+tlrc`. For a bucket of betas across conditions for RSA, write a tiny shell loop extracting each with `3dbucket -prefix betas_for_rsa ...`.

5. **Why does AFNI store sub-brick labels and stat parameters in the header instead of a sidecar file?**

    ??? answer "Show answer"
        So the dataset is self-describing — move it to another machine, hand it to a collaborator, come back to it in three years, and `3dinfo` still tells you what each number means. Sidecars go missing; headers don't. This is the "stay close to the data" principle in action.

---

## Exit criteria

Before moving to Lecture 2, you should be able to:

- [x] Explain — in one paragraph, no notes — what a dataset / voxel / sub-brick / header are and how they relate.
- [x] Read a `3dinfo` output and identify: orientation, voxel dimensions, TR (if 3D+time), number of sub-bricks.
- [x] Reference a specific sub-brick at the shell with `'[index]'` syntax.
- [x] Explain why BRIK/HEAD is two files and why losing one orphans the other.
- [x] Tell someone the difference between `+orig` and `+tlrc`.
- [x] Name at least five AFNI `3d*` programs and what they do.

Got all six? Onward to [Lecture 2 — Regression, Part 1](02-regression-part1.md).
