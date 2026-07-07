import os
from dotenv import load_dotenv

# =========================================================
# BASE DIRECTORY
# =========================================================
# This file lives in Project/config/config.py, so BASE_DIR
# is Project/ itself. Every other script imports paths from
# here, so there is exactly ONE place that defines folder
# structure. No more path-mismatch bugs between scripts.
# =========================================================

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Load environment variables from .env file
load_dotenv(os.path.join(BASE_DIR, '.env'))

# ===== DATA FOLDERS =====
RAW_FOLDER = os.path.join(BASE_DIR, "data", "raw", "local_csv")
CLEANED_FOLDER = os.path.join(BASE_DIR, "data", "processed", "cleaned_data")

# ===== LOGS =====
LOG_FILE = os.path.join(BASE_DIR, "logs", "pipeline_log.txt")

# ===== MYSQL CONFIG =====
HOST = os.environ.get("MYSQL_HOST", "localhost")
USER = os.environ.get("MYSQL_USER", "root")
PASSWORD = os.environ.get("MYSQL_PASSWORD", "")   # Loaded from .env
DATABASE = os.environ.get("MYSQL_DATABASE", "college")

MYSQL_URI = f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}/{DATABASE}"


def ensure_folders():
    """Create every folder this pipeline needs, if missing."""
    os.makedirs(RAW_FOLDER, exist_ok=True)
    os.makedirs(CLEANED_FOLDER, exist_ok=True)
    os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)