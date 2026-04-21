-- Application Insights Queries
-- Tracks patterns across 59 applications (as of 2026-04-21)

-- 1. Overall status breakdown
SELECT app_status, COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM applications), 1) AS pct
FROM applications
GROUP BY app_status
ORDER BY count DESC;

-- 2. Application volume by week
SELECT
    SUBSTR(date_applied, 1, 7) AS month,
    STRFTIME('%W', date_applied) AS week,
    COUNT(*) AS apps_that_week
FROM applications
WHERE date_applied IS NOT NULL
GROUP BY month, week
ORDER BY date_applied;

-- 3. Rejection rate by company size / type
-- (manually tagged via source field for now)
SELECT j.source, COUNT(*) AS total,
    SUM(CASE WHEN a.app_status = 'rejected' THEN 1 ELSE 0 END) AS rejected,
    ROUND(SUM(CASE WHEN a.app_status = 'rejected' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS rejection_rate
FROM jobs j
JOIN applications a ON j.id = a.job_id
GROUP BY j.source
ORDER BY total DESC;

-- 4. LinkedIn outreach conversion
-- How many contacted leads have replied vs. no response
SELECT
    linkedin_status,
    COUNT(*) AS count
FROM applications
WHERE linkedin_contact IS NOT NULL
GROUP BY linkedin_status;

-- 5. Remote vs. on-site application breakdown
SELECT
    CASE WHEN j.remote = 1 THEN 'Remote' ELSE 'On-site / Hybrid' END AS work_type,
    COUNT(*) AS total,
    SUM(CASE WHEN a.app_status = 'rejected' THEN 1 ELSE 0 END) AS rejected,
    SUM(CASE WHEN a.app_status = 'interview' THEN 1 ELSE 0 END) AS interviews
FROM jobs j
JOIN applications a ON j.id = a.job_id
GROUP BY work_type;

-- 6. Top locations applied to
SELECT j.location, COUNT(*) AS apps
FROM jobs j
JOIN applications a ON j.id = a.job_id
WHERE j.location IS NOT NULL
GROUP BY j.location
ORDER BY apps DESC
LIMIT 10;

-- 7. Days since application with no response (waiting > 14 days)
SELECT j.company, j.role, a.date_applied,
    CAST(JULIANDAY('now') - JULIANDAY(a.date_applied) AS INTEGER) AS days_waiting
FROM jobs j
JOIN applications a ON j.id = a.job_id
WHERE a.app_status = 'waiting'
    AND a.date_applied IS NOT NULL
    AND JULIANDAY('now') - JULIANDAY(a.date_applied) > 14
ORDER BY days_waiting DESC;
