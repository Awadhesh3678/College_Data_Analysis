import pandas as pd
import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.config import RAW_FOLDER, CLEANED_FOLDER, ensure_folders
from config.logger import log

ensure_folders()





# =========================================================
# 1. STUDENT ACADEMICS
# =========================================================

def clean_student_academics(path):
    df = pd.read_csv(path)
    df = df.drop_duplicates()
    df = df.dropna(how="all")

    if "StudentName" in df.columns:
        df["StudentName"] = df["StudentName"].str.strip().str.title()

    if "FinalCGPA" in df.columns:
        df["FinalCGPA"] = pd.to_numeric(df["FinalCGPA"], errors="coerce")
        df["FinalCGPA"] = df["FinalCGPA"].fillna(df["FinalCGPA"].mean())
        df["grade"] = df["FinalCGPA"].apply(
            lambda x: "A" if x >= 8 else ("B" if x >= 6 else ("C" if pd.notna(x) else None))
        )

    for col in ["10thMarks", "12thMarks"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
            df[col] = df[col].fillna(df[col].mean())
            df[col + "_result"] = df[col].apply(lambda x: "Pass" if x >= 40 else "Fail")

    if "CGPA BLOCK" in df.columns:
        df = df.drop(columns=["CGPA BLOCK"])

    return df


# =========================================================
# 2. STUDENT ATTENDANCE
# =========================================================

def clean_attendance(path):
    df = pd.read_csv(path)
    df = df.drop_duplicates()

    if "Average_Attendance" in df.columns:
        df["Average_Attendance"] = pd.to_numeric(df["Average_Attendance"], errors="coerce")
        df["Average_Attendance"] = df["Average_Attendance"].fillna(df["Average_Attendance"].mean())

    return df


# =========================================================
# 3. PLACED STUDENTS
# =========================================================

def clean_placed(path):
    df = pd.read_csv(path)
    df = df.drop_duplicates()

    if "ctc_lpa" in df.columns:
        df["ctc_lpa"] = pd.to_numeric(df["ctc_lpa"], errors="coerce")
        df["ctc_lpa"] = df["ctc_lpa"].fillna(df["ctc_lpa"].median())
    elif "CTC_LPA" in df.columns:
        df["CTC_LPA"] = pd.to_numeric(df["CTC_LPA"], errors="coerce")
        df["CTC_LPA"] = df["CTC_LPA"].fillna(df["CTC_LPA"].median())

    if "CompanyName" in df.columns:
        df["CompanyName"] = df["CompanyName"].str.strip().str.title()

    if "Name" in df.columns:
        df["Name"] = df["Name"].str.strip().str.title()

    # Reverting to the raw schema because Power Query expects these names in the Source step!
    df = df.rename(columns={
        "Hometown": "Hometown/City",
        "ctc_lpa": "CTC_LPA"
    })

    return df


# =========================================================
# 4. STUDENT RECORDS
# =========================================================

def clean_student_records(path):
    df = pd.read_csv(path)

    if "StudentName" in df.columns:
        df["StudentName"] = df["StudentName"].str.strip().str.title()

    # Removed pd.to_datetime conversion on "dob" to preserve the raw format for Power BI dashboards.

    return df


# =========================================================
# 5. SKILL TABLE
# =========================================================

def clean_skill(path):
    df = pd.read_csv(path)

    for col in df.columns:
        if df[col].dtype == "object":
            df[col] = df[col].str.strip().str.title()

    return df


# =========================================================
# 6. STUDENT APPLICABLE
# =========================================================

def clean_applicable(path):
    df = pd.read_csv(path)
    df = df.drop_duplicates()
    return df


# =========================================================
# 7. COMPANY DETAILS
# =========================================================

def clean_company(path):
    df = pd.read_csv(path)

    for col in df.columns:
        if df[col].dtype == "object":
            df[col] = df[col].str.strip().str.title()

    return df


# =========================================================
# MAIN PROCESSING FUNCTION
# =========================================================

def process_all():

    log("STARTING DATA CLEANING PIPELINE")

    if not os.path.exists(RAW_FOLDER):
        log(f"ERROR: RAW_FOLDER does not exist: {RAW_FOLDER}")
        return

    csv_files = [f for f in os.listdir(RAW_FOLDER) if f.endswith(".csv")]

    if not csv_files:
        log(f"WARNING: No CSV files found in {RAW_FOLDER}")
        return

    for file in csv_files:

        log(f"Processing: {file}")
        path = os.path.join(RAW_FOLDER, file)
        file_lower = file.lower()

        try:
            if "academics" in file_lower:
                df = clean_student_academics(path)
            elif "attendance" in file_lower:
                df = clean_attendance(path)
            elif "placed" in file_lower:
                df = clean_placed(path)
            elif "records" in file_lower:
                df = clean_student_records(path)
            elif "skill" in file_lower:
                df = clean_skill(path)
            elif "applicable" in file_lower:
                df = clean_applicable(path)
            elif "company" in file_lower:
                df = clean_company(path)
            else:
                df = pd.read_csv(path)
                log(f"NOTE: '{file}' matched no known keyword - no custom cleaning applied")

            # ---------------------------------------------
            # SCHEMA SAFETY LOG
            # This is the check that was missing before.
            # Log exactly what columns are about to be saved,
            # so a silent rename/drop is visible immediately
            # instead of surfacing later as a broken Power BI
            # visual.
            # ---------------------------------------------
            log(f"  -> {len(df)} rows, columns: {list(df.columns)}")

            if df.empty:
                log(f"  WARNING: '{file}' produced an empty dataframe after cleaning")

            save_path = os.path.join(CLEANED_FOLDER, file)
            df.to_csv(save_path, index=False)
            log(f"Saved: {file}")

        except Exception as e:
            log(f"ERROR processing {file}: {e}")

    log("DATA CLEANING PIPELINE COMPLETED")


if __name__ == "__main__":
    process_all()