# Cluster + AFNI install

This walkthrough runs on Temple University's Milo lab HPC node:

- **Host:** `cla19097.tu.temple.edu` (IP: `155.247.67.31`)
- **OS:** Ubuntu 20.04 LTS, x86_64, glibc 2.31
- **Auth:** keyboard-interactive (you need Temple VPN connected)

All heavy I/O and AFNI GUI rendering happens on the cluster — our Mac stays clean.

## SSH access

Because Temple requires keyboard-interactive auth, `sshpass` doesn't work. We use `expect`:

```bash
expect -c '
spawn ssh -o StrictHostKeyChecking=no tur50045@cla19097.tu.temple.edu "YOUR_COMMAND"
expect "password:"
send "YOUR_PASSWORD\r"
expect eof
'
```

!!! tip "DNS quirk on macOS + Tailscale"
    If `cla19097.tu.temple.edu` fails to resolve (`NXDOMAIN`) even on Temple VPN, it's because macOS is routing `.tu.temple.edu` DNS queries through Tailscale instead of Temple's internal DNS. Fix: SSH by IP (`155.247.67.31`) or add an entry to `/etc/hosts`.

## Where the data already lives

The cluster already has the full 2025 AFNI Bootcamp CD mirrored:

```
/data/AFNIBootcamp_2025/CD/
├── AFNI_data6/              ← the canonical bootcamp dataset
│   ├── FT_analysis/         ← ready-to-run preprocessed example
│   ├── DICOM_T1/            ← raw anatomical
│   ├── EPI_run1/            ← raw functional
│   ├── roi_demo/
│   ├── run1.afni/
│   └── ...
├── bootcamp_qc_sub_*/       ← QC exercise datasets
├── std_meshes/              ← SUMA surface meshes
└── suma_demo/
```

**No need to download AFNI_data6 — we just reference it in place.**

## AFNI is already installed — just point PATH at it

AFNI is pre-installed system-wide at `/usr/local/abin` (version 25.1.11 "Maximinus", May 2025 build, 935 binaries — full install including `afni`, `3dDeconvolve`, `align_epi_anat.py`, `@SSwarper`, etc.). **You do not need to re-install it.** Just add it to your `PATH`:

```bash
# Append to ~/.bashrc on the cluster
echo 'export PATH=/usr/local/abin:$PATH' >> ~/.bashrc
source ~/.bashrc
afni -ver
# → Precompiled binary linux_ubuntu_16_64: May 23 2025 (Version AFNI_25.1.11 'Maximinus')
```

!!! tip "Use the system install, not a personal one"
    Several other users on the node do have their own `~/abin` — useful if you need a bleeding-edge version or a custom patch, but for the bootcamp the system install is fine and saves ~2 GB in your home directory.

## GUI over SSH

AFNI's GUI is a major focus of lectures 1 and 3. Three options:

1. **X11 forwarding** (`ssh -Y`) + XQuartz on Mac — simplest, but laggy across a VPN.
2. **Citrix** — Danny already uses this for cluster GUI work; full desktop session, fastest for interactive windows.
3. **Headless batch** — `@djunct_*` and `@chauffeur_afni` scripts render snapshot figures from the command line; we SCP the PNGs back.

We use **option 2 (Citrix)** for live GUI lectures and **option 3** for captured examples in this site.
