from datetime import datetime
from config.config import LOG_FILE, ensure_folders

ensure_folders()


def log(msg):
    time_now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{time_now}] {msg}"
    print(line)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(line + "\n")