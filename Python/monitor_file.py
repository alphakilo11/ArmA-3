import os
import time
import logging

LOGFILE_PATH = '/var/log/your_app.log'  # Update with your log file path
POLL_INTERVAL = 1.0  # in seconds

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s',
    handlers=[
        logging.FileHandler("log_monitor.log"),
        logging.StreamHandler()
    ]
)

def process_log_line(line: str):
    """
    This function defines how to process each line from the log file.
    You can customize this to send alerts, write to DB, etc.
    """
    logging.info(f"New log line: {line.strip()}")

def monitor_log_file(filepath: str):
    """
    Monitors a log file for new entries, handles log rotation.
    """
    logging.info(f"Starting to monitor {filepath}")

    try:
        with open(filepath, 'r') as file:
            file.seek(0, os.SEEK_END)  # Go to the end of the file

            inode = os.fstat(file.fileno()).st_ino

            while True:
                line = file.readline()
                if line:
                    process_log_line(line)
                else:
                    time.sleep(POLL_INTERVAL)

                    # Check for log rotation
                    try:
                        if os.stat(filepath).st_ino != inode:
                            logging.info("Log rotation detected. Reopening file...")
                            file.close()
                            file = open(filepath, 'r')
                            inode = os.fstat(file.fileno()).st_ino
                    except FileNotFoundError:
                        logging.warning(f"{filepath} not found. Waiting for file to appear...")
                        time.sleep(POLL_INTERVAL)

    except (PermissionError, FileNotFoundError) as e:
        logging.error(f"Failed to open log file: {e}")

if __name__ == '__main__':
    monitor_log_file(LOGFILE_PATH)
