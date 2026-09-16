import logging
import psycopg2
import bcrypt
from app.database import NEON_TMS_URL
from app.auth import USERS_DB

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("IMBPS.InitAuthDB")

# Initial bootstrap passwords used ONLY to seed the database
INITIAL_PASSWORDS = {
    "railway_central": "RailBoard@2026",
    "zone_er": "ZonalER@2026",
    "zone_nr": "ZonalNR@2026",
    "div_asn": "DivASN@2026",
    "div_hwh": "DivHWH@2026",
    "div_umb": "DivUMB@2026",
    "tms_engineer": "TrackEng@2026",
    "tms_hwh": "TrackHWH@2026",
    "tms_umb": "TrackUMB@2026",
    "smms_engineer": "SignalEng@2026",
    "smms_hwh": "SignalHWH@2026",
    "smms_umb": "SignalUMB@2026",
    "tdms_engineer": "TrdEng@2026",
    "tdms_hwh": "TrdHWH@2026",
    "tdms_umb": "TrdUMB@2026"
}

def hash_pw(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

def init_and_seed():
    logger.info("Connecting to Neon PostgreSQL...")
    conn = psycopg2.connect(NEON_TMS_URL)
    conn.autocommit = True
    cursor = conn.cursor()

    logger.info("Creating app_users table if not exists...")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS app_users (
            id SERIAL PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            hashed_password VARCHAR(255) NOT NULL,
            name VARCHAR(100) NOT NULL,
            role VARCHAR(50) NOT NULL,
            role_display VARCHAR(100) NOT NULL,
            zone VARCHAR(50),
            zone_code VARCHAR(10),
            division VARCHAR(50),
            division_code VARCHAR(10),
            department VARCHAR(50),
            department_display VARCHAR(100),
            section VARCHAR(50),
            section_display VARCHAR(100),
            is_active BOOLEAN DEFAULT TRUE,
            created_by VARCHAR(50) DEFAULT 'system_seed',
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
    """)

    logger.info("Seeding initial accounts...")
    insert_sql = """
        INSERT INTO app_users (
            username, hashed_password, name, role, role_display,
            zone, zone_code, division, division_code,
            department, department_display, section, section_display,
            created_by
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'system_seed')
        ON CONFLICT (username) DO UPDATE SET
            hashed_password = EXCLUDED.hashed_password,
            name = EXCLUDED.name,
            role = EXCLUDED.role,
            role_display = EXCLUDED.role_display,
            zone = EXCLUDED.zone,
            zone_code = EXCLUDED.zone_code,
            division = EXCLUDED.division,
            division_code = EXCLUDED.division_code,
            department = EXCLUDED.department,
            department_display = EXCLUDED.department_display,
            section = EXCLUDED.section,
            section_display = EXCLUDED.section_display,
            is_active = TRUE;
    """

    for uname, data in USERS_DB.items():
        profile = data["profile"]
        plain_pw = INITIAL_PASSWORDS.get(uname, "Railway@2026")
        hashed = hash_pw(plain_pw)

        cursor.execute(insert_sql, (
            uname,
            hashed,
            profile["name"],
            profile["role"],
            profile["role_display"],
            profile.get("zone"),
            profile.get("zone_code"),
            profile.get("division"),
            profile.get("division_code"),
            profile.get("department"),
            profile.get("department_display"),
            profile.get("section"),
            profile.get("section_display")
        ))

    cursor.close()
    conn.close()
    logger.info("Successfully seeded all default accounts into Neon PostgreSQL.")

if __name__ == "__main__":
    init_and_seed()
