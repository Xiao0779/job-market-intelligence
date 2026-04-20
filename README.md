# Job Market Intelligence Dashboard

An AI-powered analytics tool for tracking and analyzing the data science / ML job market — built as a live project during an active job search (2026).

## Overview

This project simulates what a data analyst would build to monitor a job market: a SQL database backend, Python analytics pipelines, and an AI-assisted insight layer. Data is updated regularly from real job postings.

**Workplace narrative:** As a job seeker and analyst, I serve as both the data engineer (collecting and storing job data) and the analyst (extracting insights for career strategy). Downstream users: job seekers targeting DS/ML roles; upstream: public job boards and personal application tracking.

## Stack

| Layer | Technology |
|-------|-----------|
| Database | SQLite (SQL — schema design, joins, aggregations) |
| Data pipeline | Python, pandas, openpyxl |
| Analytics | SQL queries, pandas, matplotlib, seaborn |
| AI insights | LLM-powered skill extraction and trend analysis (in progress) |
| Dashboard | Streamlit (in progress) |

## Database Schema

3 tables:
- **jobs** — company, role, location, salary, source
- **skills** — skill tags per job (SQL, Python, ML, etc.)
- **applications** — application status, LinkedIn outreach tracking

## Key Analyses (so far)

- Application status breakdown (waiting / rejected / interview)
- Top companies by application volume
- LinkedIn outreach tracking
- _Coming: skill frequency analysis, salary distribution, rejection rate by company type_

## Project Status

Actively being developed. New data and analyses added weekly.
