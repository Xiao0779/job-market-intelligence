-- Job Market Intelligence Database Schema
-- 三张表：职位、技能、申请记录

-- 职位表
CREATE TABLE IF NOT EXISTS jobs (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    date_found  TEXT NOT NULL,          -- 发现日期
    company     TEXT NOT NULL,          -- 公司名
    role        TEXT NOT NULL,          -- 岗位名称
    location    TEXT,                   -- 地点
    remote      INTEGER DEFAULT 0,      -- 是否远程 (0/1)
    salary_min  INTEGER,                -- 薪资下限
    salary_max  INTEGER,                -- 薪资上限
    source      TEXT,                   -- 数据来源
    status      TEXT DEFAULT 'open'     -- open / closed
);

-- 技能标签表（每个职位对应多个技能）
CREATE TABLE IF NOT EXISTS skills (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id      INTEGER NOT NULL,
    skill       TEXT NOT NULL,
    category    TEXT,                   -- Programming / ML / Stats / Tools / Soft
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

-- 申请记录表
CREATE TABLE IF NOT EXISTS applications (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id           INTEGER NOT NULL,
    date_applied     TEXT,
    app_status       TEXT DEFAULT 'waiting',  -- waiting / rejected / interview / offer
    linkedin_contact TEXT,
    linkedin_status  TEXT,                    -- sent / replied / none
    notes            TEXT,
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);
