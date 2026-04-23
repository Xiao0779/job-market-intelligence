-- Job Market Intelligence Database Schema
-- Built from two local sources:
--   1. Desktop/career.xlsx
--   2. Desktop/career-ops/*

DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS jobs;

CREATE TABLE jobs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    external_key    TEXT NOT NULL UNIQUE,
    date_found      TEXT,
    company         TEXT NOT NULL,
    role            TEXT NOT NULL,
    location        TEXT,
    remote          INTEGER DEFAULT 0,
    jd_url          TEXT,
    source          TEXT NOT NULL,          -- merged source labels
    source_detail   TEXT,                   -- excel / career-ops / pipeline
    score           REAL,
    report_path     TEXT,
    pdf_ready       INTEGER DEFAULT 0,
    in_pipeline     INTEGER DEFAULT 0,
    raw_status      TEXT,
    normalized_status TEXT,
    updated_at      TEXT NOT NULL
);

CREATE TABLE applications (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id            INTEGER NOT NULL,
    date_applied      TEXT,
    app_status        TEXT,                 -- applied / rejected / interview / offer / ...
    source_status     TEXT,                 -- raw source status before normalization
    linkedin_contact  TEXT,
    linkedin_status   TEXT,
    oa_status         TEXT,
    interview_status  TEXT,
    notes             TEXT,
    excel_present     INTEGER DEFAULT 0,
    career_ops_present INTEGER DEFAULT 0,
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

CREATE TABLE skills (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id      INTEGER NOT NULL,
    skill       TEXT NOT NULL,
    category    TEXT,
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);
