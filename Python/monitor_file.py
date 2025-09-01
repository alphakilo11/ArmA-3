import os
import time
import logging
import A3_local_utility as arma_local
import Arma_3_Process_rpt_file as arma

LOGFILE_FOLDER = r"C:\Users\krend\AppData\Local\Arma 3"
FILEPATH = arma_local.find_latest_rpt_file()
POLL_INTERVAL = 5  # in seconds
RUN_METADATA = run_data = arma.extract_run_data(FILEPATH)["Run Metadata"]

logging.basicConfig(
    level=logging.WARNING,
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
    global counter
    logging.info(f"New log line: {line.strip()}")
    log_event_dict = arma.extract_marked_lines(line, RUN_METADATA["Current_time"])
    if log_event_dict:
        data_dict = log_event_dict[0]["data_dict"]
        if "FirerPosition" in data_dict.keys():
            for key in ["Unit", "Unittype", "Weapon", "Ammo"]:
                print(f"{key}: {data_dict[key]}", end=", ")
            print()
            pending_projectiles[data_dict["Projectile"]] = []
            counter += 1
        if "Event" in data_dict.keys() and data_dict["Event"] == "Deleted":
            del pending_projectiles[data_dict["Projectile"]]


def monitor_log_file():
    """
    Monitors a log file for new entries, handles log rotation.
    """
    logging.info(f"Starting to monitor {FILEPATH}")
    try:
        with open(FILEPATH, 'r') as file:
            file.seek(0, os.SEEK_END)  # Go to the end of the file

            inode = os.fstat(file.fileno()).st_ino

            while True:
                line = file.readline()
                if line:
                    process_log_line(line)
                else:
                    print(f"{counter} total shots fired. {len(pending_projectiles)} pending projectiles.")
                    time.sleep(POLL_INTERVAL)

                    # Check for log rotation
                    try:
                        if os.stat(FILEPATH).st_ino != inode:
                            logging.info("Log rotation detected. Reopening file...")
                            file.close()
                            file = open(FILEPATH, 'r')
                            inode = os.fstat(file.fileno()).st_ino
                    except FileNotFoundError:
                        logging.warning(f"{FILEPATH} not found. Waiting for file to appear...")
                        time.sleep(POLL_INTERVAL)

    except (PermissionError, FileNotFoundError) as e:
        logging.error(f"Failed to open log file: {e}")


if __name__ == '__main__':
    counter = 0
    pending_projectiles = {}
    monitor_log_file()
