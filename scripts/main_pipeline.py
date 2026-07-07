import subprocess
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.logger import log

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(BASE_DIR, "scripts")


def run_script(script_name, step_name):

    log(f"STARTING: {step_name}")

    script_path = os.path.join(SCRIPTS_DIR, script_name)

    result = subprocess.run(
        [sys.executable, script_path],
        capture_output=True,
        text=True
    )

    if result.stdout:
        print(result.stdout)

    if result.returncode == 0:
        log(f"COMPLETED: {step_name}")
        return True
    else:
        log(f"FAILED: {step_name}")
        log(result.stderr)
        return False


def run_pipeline():

    log("FULL PIPELINE STARTED")

    # STEP 1: ensure database exists
    if not run_script("create_database.py", "Database Setup"):
        log("PIPELINE STOPPED: database setup failed")
        return

    # STEP 2: clean raw local CSVs
    if not run_script("data_cleaning.py", "Data Cleaning & Transformation"):
        log("PIPELINE STOPPED: cleaning failed")
        return

    # STEP 3: load cleaned data into MySQL
    if not run_script("load_to_mysql.py", "MySQL Data Loading"):
        log("PIPELINE STOPPED: MySQL load failed")
        return

    log("FULL PIPELINE COMPLETED SUCCESSFULLY")


if __name__ == "__main__":
    run_pipeline()