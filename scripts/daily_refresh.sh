#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAREER_OPS_DIR="$HOME/Desktop/career-ops"

echo "[1/2] Refreshing career-ops scan..."
if [[ -d "$CAREER_OPS_DIR" ]]; then
  (
    cd "$CAREER_OPS_DIR"
    node scan.mjs
  )
else
  echo "career-ops directory not found at $CAREER_OPS_DIR" >&2
fi

echo "[2/2] Rebuilding public analytics..."
python3 "$ROOT_DIR/scripts/refresh_public_analytics.py"

echo "Daily refresh complete."
