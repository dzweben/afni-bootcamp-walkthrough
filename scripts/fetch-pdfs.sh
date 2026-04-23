#!/usr/bin/env bash
# Fetch the 5 official AFNI Bootcamp Day 1 handouts into day1/pdfs/.
# These are public NIMH materials; we don't re-host them, just mirror locally for offline use.

set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p day1/pdfs
cd day1/pdfs

base="https://afni.nimh.nih.gov/pub/dist/edu/data/CD.expanded/afni_handouts"

for pdf in afni01_intro.pdf afni05_regression.pdf RegressionHandsOn.pdf afni03_interactive.pdf afni14_alignment.pdf; do
  if [[ -f "$pdf" ]]; then
    echo "  ✓ $pdf (already present)"
  else
    echo "  ↓ $pdf"
    curl -fsSL -O "$base/$pdf"
  fi
done

echo "Done. PDFs in $(pwd)"
