"""
初始化数据库，并从 career.xlsx 导入申请记录
运行一次即可：python sql/init_db.py
"""
import sqlite3
import pandas as pd
from pathlib import Path

DB_PATH = Path(__file__).parent.parent / "data" / "jobs.db"
SCHEMA_PATH = Path(__file__).parent / "schema.sql"
EXCEL_PATH = Path.home() / "Desktop" / "career.xlsx"

# 建库
conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

# 执行 schema
with open(SCHEMA_PATH) as f:
    cur.executescript(f.read())
conn.commit()
print("数据库建好了:", DB_PATH)

# 从 career.xlsx 读取数据
df = pd.read_excel(EXCEL_PATH)
df.columns = ['date_found', 'company', 'role', 'location', 'oa', 'interview',
              'app_status', 'linkedin_contact', 'linkedin_status']
df = df.dropna(subset=['company'])

# 判断是否 remote
df['remote'] = df['location'].fillna('').str.lower().str.contains('remote').astype(int)

# 导入 jobs 表 + applications 表
for _, row in df.iterrows():
    # INSERT jobs
    cur.execute("""
        INSERT INTO jobs (date_found, company, role, location, remote, source, status)
        VALUES (?, ?, ?, ?, ?, 'career.xlsx', 'open')
    """, (
        str(row['date_found'])[:10] if pd.notna(row['date_found']) else None,
        str(row['company']).strip(),
        str(row['role']).strip(),
        str(row['location']) if pd.notna(row['location']) else None,
        int(row['remote'])
    ))
    job_id = cur.lastrowid

    # INSERT applications
    status = str(row['app_status']).strip() if pd.notna(row['app_status']) else 'waiting'
    li_contact = str(row['linkedin_contact']).strip() if pd.notna(row['linkedin_contact']) else None
    li_status = str(row['linkedin_status']).strip() if pd.notna(row['linkedin_status']) else None

    cur.execute("""
        INSERT INTO applications (job_id, date_applied, app_status, linkedin_contact, linkedin_status)
        VALUES (?, ?, ?, ?, ?)
    """, (job_id, str(row['date_found'])[:10] if pd.notna(row['date_found']) else None,
          status, li_contact, li_status))

conn.commit()
conn.close()

print(f"导入完成：{len(df)} 条记录")
print("\n-- 现在可以用 SQL 查询了，例如：")
print("   SELECT company, role, app_status FROM applications JOIN jobs ON jobs.id = applications.job_id;")
