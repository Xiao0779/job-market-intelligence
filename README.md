# Job Market Intelligence Dashboard

A privacy-safe analytics layer on top of my active job search. This repo turns local job-search data into a public-facing, GitHub-backed dashboard without publishing raw personal trackers, resumes, or recruiter contact details.

## Overview

The workflow merges two local sources:

1. `~/Desktop/career.xlsx` — manual application tracker
2. `~/Desktop/career-ops/*` — AI-assisted job search system with pipeline, reports, and tailored materials

From those inputs, the project rebuilds a local SQLite database, generates public charts, and writes a sanitized markdown/json snapshot that can be committed to GitHub daily.

## Why This Exists

This project shows the kind of analytics workflow I would build for a real team:

- ingest messy source data from multiple systems
- normalize statuses and merge duplicate records
- separate local operational data from public reporting
- publish a clean summary that helps decision-making

It is both a working job-search tool and a portfolio piece for data / analytics roles.

## Stack

| Layer | Technology |
|-------|-----------|
| Sources | Excel, Markdown trackers, YAML profile config |
| Database | SQLite |
| Sync pipeline | Python, openpyxl, PyYAML |
| Analytics | Python, matplotlib |
| Public outputs | Markdown, JSON, PNG charts |

## Refresh Workflow

Run:

```bash
python scripts/refresh_public_analytics.py
```

or use the daily wrapper:

```bash
bash scripts/daily_refresh.sh
```

That command will:

- rebuild `data/jobs.db` from local sources
- generate `data/daily_summary.md`
- generate `data/public_dashboard.json`
- export `data/top_pipeline.csv`
- refresh the charts in `data/`

Compatibility note:

```bash
python sql/init_db.py
```

still works and now forwards to the new refresh script.

## Privacy Boundary

This repo is designed for GitHub sync, so the public outputs stay sanitized:

- no email addresses
- no phone numbers
- no recruiter contact names in reports
- no raw resumes or cover letters
- no private tracker files copied into the repo

The local operational files remain in `career-ops` and on the desktop.

## Current Outputs

- `data/daily_summary.md` — public daily snapshot
- `data/public_dashboard.json` — machine-readable metrics
- `data/top_pipeline.csv` — current opportunity queue
- `data/fig1_status_breakdown.png`
- `data/fig2_weekly_cadence.png`
- `data/fig3_top_companies.png`
- `data/fig4_location_distribution.png`

## Project Status

Actively maintained as part of a live job search workflow, with daily-refresh automation layered on top of the local `career-ops` system.
