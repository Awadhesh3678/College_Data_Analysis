import pandas as pd
import os
import sys
from sqlalchemy import create_engine

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.config import CLEANED_FOLDER, MYSQL_URI, ensure_folders
from config.logger import log

ensure_folders()

engine = create_engine(MYSQL_URI)


def load_data():

    log("Starting data load into MySQL")

    if not os.path.exists(CLEANED_FOLDER):
        log(f"ERROR: CLEANED_FOLDER does not exist: {CLEANED_FOLDER}")
        return

    csv_files = [f for f in os.listdir(CLEANED_FOLDER) if f.endswith(".csv")]

    if not csv_files:
        log(f"WARNING: No cleaned CSV files found in {CLEANED_FOLDER}")
        return

    for file in csv_files:

        table_name = file.replace(".csv", "").lower()
        path = os.path.join(CLEANED_FOLDER, file)

        try:
            log(f"Processing {file}")

            df_new = pd.read_csv(path)

            if df_new.empty or len(df_new.columns) == 0:
                log(f"SKIPPED (empty or no columns): {file}")
                continue

            # Full replace - confirmed: no need to preserve historical
            # rows, every run regenerates the complete dataset from
            # raw CSVs, so the cleaned file is always the source of truth.
            df_new.to_sql(table_name, engine, if_exists="replace", index=False)

            log(f"Done: {table_name} ({len(df_new)} rows, {len(df_new.columns)} cols)")
            log(f"  Columns: {list(df_new.columns)}")

        except Exception as e:
            log(f"ERROR loading {file}: {e}")

    log("LOAD COMPLETED")


if __name__ == "__main__":
    load_data()