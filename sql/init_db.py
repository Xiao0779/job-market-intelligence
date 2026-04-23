"""
Compatibility wrapper.

Preferred command:
    python scripts/refresh_public_analytics.py

This file stays as a stable entry point for older notes and notebooks.
"""

from pathlib import Path
import runpy


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "refresh_public_analytics.py"


if __name__ == "__main__":
    runpy.run_path(str(SCRIPT), run_name="__main__")
