# Job Market Intelligence

A GitHub-backed, AWS-deployed analytics product that syncs messy local job-search data into a privacy-safe public reporting workflow with Python, SQLite, S3 cloud storage, and EC2 scheduled execution.

## What I Built

This project turns a messy personal operating workflow into a usable analytics product:

- ingest data from multiple local sources with different formats
- normalize statuses and merge duplicate records into one clean model
- define a privacy boundary between private operational data and public outputs
- generate daily summaries, machine-readable snapshots, CSV exports, and charts
- automate refreshes so the reporting layer stays current with minimal manual work

## Overview

The workflow merges two local sources:

1. `~/Desktop/career.xlsx` — manual application tracker
2. `~/Desktop/career-ops/*` — AI-assisted job search system with pipeline, reports, and tailored materials

From those inputs, the project rebuilds a local SQLite database, generates public charts, and writes sanitized markdown/json snapshots that can be committed to GitHub daily.

## Why This Exists

This project reflects how I like to build:

- start from a real workflow, not a toy dataset
- design the data model and sync logic end-to-end
- make complex information legible for decision-making
- ship something useful enough to run every day

It is both a working job-search tool and a portfolio piece for analytics, AI-native workflow, and product-minded engineering roles.

## Stack

| Layer | Technology |
|-------|-----------|
| Sources | Excel, Markdown trackers, YAML profile config |
| Database | SQLite |
| Sync pipeline | Python, openpyxl, PyYAML, boto3 |
| Analytics | Python, matplotlib |
| Public outputs | Markdown, JSON, PNG charts |
| Cloud storage | AWS S3 |
| Scheduled execution | AWS EC2 (cron, daily) |

## Why It Is Product-Like

Even though the domain is job search, the underlying problem is a classic product/data problem:

- users generate fragmented operational data across tools
- raw data contains duplicates, inconsistent statuses, and private information
- stakeholders need a clean, trustworthy view of what matters now
- the system has to be useful repeatedly, not just correct once

I built this repo around those constraints: define the schema, clean the pipeline, enforce privacy rules, and publish outputs that are lightweight but actionable.

## Refresh Workflow

### Local (Mac)

Run after updating application records:

```bash
python scripts/refresh_public_analytics.py
```

This will:

- rebuild `data/jobs.db` from local sources
- generate `data/daily_summary.md`, `public_dashboard.json`, `top_pipeline.csv`, charts
- upload source files to S3 (`inputs/` prefix) so the cloud instance stays in sync
- upload all outputs to S3

### Cloud (AWS EC2)

An EC2 instance (`t3.micro`, Amazon Linux 2023) runs the same pipeline automatically every day at UTC 02:00 via cron:

1. Downloads latest source files from S3
2. Runs `refresh_public_analytics.py`
3. Outputs are uploaded back to S3 automatically

No manual intervention required after the local run uploads updated sources.

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

Actively maintained as part of a live job search (298 tracker entries as of June 2026, across Applied, SKIP, and Interview stages). Pipeline runs locally after each update and automatically on AWS EC2 (t3.micro, UTC 02:00 cron) daily — zero manual intervention end-to-end.
