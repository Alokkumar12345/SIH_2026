# SIH_2026/backend/init_users_db.py
import logging
from passlib.context import CryptContext
import psycopg2
from psycopg2.extras import RealDictCursor

# Import existing Neon DB URL from app.database
from app.database import NEON_TMS_URL
# Import current in-memory accounts to seed
from app.auth import USERS_DB

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("IMBPS.InitAuthDB")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS app_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(64) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    name VARCHAR(128) NOT NULL,
    role VARCHAR(32) NOT NULL,
    role_display VARCHAR(128) NOT NULL,
    zone VARCHAR(64),
    zone_code VARCHAR(16),
    division VARCHAR(64),
    division_code VARCHAR(16),
    department VARCHAR(32),
    department_display VARCHAR(128),
    section VARCHAR(64),
    section_display VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(64) DEFAULT 'SYSTEM',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_app_users_username ON app_users(username);
"""

def init_and_seed():
    logger.info("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(NEON_TMS_URL)
    conn.autocommit = True
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    logger.info("Creating app_users table...")
    cursor.execute(CREATE_TABLE_SQL)

    logger.info("Seeding initial accounts...")
    insert_sql = """
    INSERT INTO app_users (
        username, hashed_password, name, role, role_display,
        zone, zone_code, division, division_code,
        department, department_display, section, section_display,
        created_by
    ) VALUES (
        %(username)s, %(hashed_password)s, %(name)s, %(role)s, %(role_display)s,
        %(zone)s, %(zone_code)s, %(division)s, %(division_code)s,
        %(department)s, %(department_display)s, %(section)s, %(section_display)s,
        'SYSTEM_SEED'
    ) ON CONFLICT (username) DO NOTHING;
    """

    for uname, data in USERS_DB.items():
        profile = data["profile"]
        hashed = pwd_context.hash(data["password"])
        
        record = {
            "username": uname,
            "hashed_password": hashed,
            "name": profile.get("name"),
            "role": profile.get("role"),
            "role_display": profile.get("role_display"),
            "zone": profile.get("zone"),
            "zone_code": profile.get("zone_code"),
            "division": profile.get("division"),
            "division_code": profile.get("division_code"),
            "department": profile.get("department"),
            "department_display": profile.get("department_display"),
            "section": profile.get("section"),
            "section_display": profile.get("section_display"),
        }
        cursor.execute(insert_sql, record)
        logger.info(f"Account '{uname}' verified/seeded.")

    cursor.close()
    conn.close()
    logger.info("Authentication Database Initialization Complete.")

if __name__ == "__main__":
    init_and_seed()