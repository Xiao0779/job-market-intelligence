-- SQL Practice Queries — Job Market Intelligence
-- Practiced 2026-04-20 | Topics: SELECT, JOIN, GROUP BY, HAVING, LEFT JOIN,
--   subqueries, CASE WHEN, ROW_NUMBER() window function, INSERT, UPDATE

-- 1. Basic SELECT + WHERE + JOIN
-- Rejected applications with company and role
SELECT j.company, j.role, a.app_status
FROM jobs j
JOIN applications a ON j.id = a.job_id
WHERE a.app_status = 'rejected';

-- 2. GROUP BY + COUNT + ORDER BY + LIMIT
-- Top companies by application volume
SELECT j.company, COUNT(*) AS num_apps
FROM jobs j
JOIN applications a ON j.id = a.job_id
GROUP BY j.company
ORDER BY num_apps DESC
LIMIT 10;

-- 3. HAVING — companies with more than 1 application
SELECT j.company, COUNT(*) AS num_apps
FROM jobs j
JOIN applications a ON j.id = a.job_id
GROUP BY j.company
HAVING num_apps > 1
ORDER BY num_apps DESC;

-- 4. LEFT JOIN with IS NULL — data integrity check
-- Jobs with no corresponding application record
SELECT j.id, j.company, j.role
FROM jobs j
LEFT JOIN applications a ON j.id = a.job_id
WHERE a.id IS NULL;

-- 5. Subquery + CASE WHEN — rejection rate by company
SELECT company, total_apps, rejected,
    CASE WHEN total_apps > 0 THEN ROUND(rejected * 100.0 / total_apps, 1) END AS rejection_rate_pct
FROM (
    SELECT j.company,
        COUNT(*) AS total_apps,
        SUM(CASE WHEN a.app_status = 'rejected' THEN 1 ELSE 0 END) AS rejected
    FROM jobs j
    JOIN applications a ON j.id = a.job_id
    GROUP BY j.company
) sub
WHERE rejection_rate_pct > 50
ORDER BY rejection_rate_pct DESC;

-- 6. ROW_NUMBER() window function
-- First application per company (chronologically)
SELECT * FROM (
    SELECT j.company, j.role, a.date_applied,
        ROW_NUMBER() OVER (PARTITION BY j.company ORDER BY a.date_applied, j.id) AS app_order
    FROM jobs j
    JOIN applications a ON j.id = a.job_id
) t
WHERE app_order = 1
ORDER BY company;

-- 7. INSERT — add a new job + application using last_insert_rowid()
-- BEGIN TRANSACTION;
-- INSERT INTO jobs (date_found, company, role, location, remote, source, status)
-- VALUES ('2026-04-18', 'Qualcomm', 'IT Data Scientist', 'San Diego, CA', 0, 'LinkedIn', 'open');
-- INSERT INTO applications (job_id, date_applied, app_status, linkedin_contact, linkedin_status)
-- VALUES (last_insert_rowid(), '2026-04-18', 'waiting', NULL, NULL);
-- COMMIT;

-- 8. UPDATE — change application status
-- UPDATE applications SET app_status = 'interview' WHERE job_id = 54;
