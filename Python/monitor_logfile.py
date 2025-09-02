import os
import time
import logging
import A3_local_utility as arma_local
import Arma_3_Process_rpt_file as arma
import numpy as np

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
    def projectile_summary(projectile_dict):
        if "Parent Projectile" in projectile_dict[0].keys():
            return "Submunition not implemented yet"
        try:
            shooter_pos = projectile_dict[0]["FirerPosition"]
        except KeyError:
            print(f"Error processing {projectile_dict[0]}. Skipping...")
            return None
        deleted_pos = projectile_dict[-1]["Position"]
        total_distance = np.linalg.norm(np.array(shooter_pos) - np.array(deleted_pos))
        report = f'Time alive: {round(projectile_dict[-1]["tickTime"] - projectile_dict[0]["tickTime"], 2)}'\
            f'Projectile Travel: {round(total_distance)} m.'
        return report

    global counter
    logging.info(f"New log line: {line.strip()}")
    log_event_dict = arma.extract_marked_lines(line, RUN_METADATA["Current_time"])
    if log_event_dict:
        data_dict = log_event_dict[0]["data_dict"]
        if "FirerPosition" in data_dict.keys():
            for key in ["Unit", "Unittype", "Weapon", "Ammo"]:
                arma.print(f"{key}: {data_dict[key]}", end=", ")
            print()
            pending_projectiles[data_dict["Projectile"]] = [data_dict]
            counter += 1
        elif "Event" in data_dict.keys():
            if data_dict["Projectile"] in pending_projectiles.keys():
                pending_projectiles[data_dict["Projectile"]].append(data_dict)
            else:
                pending_projectiles[data_dict["Projectile"]] = [data_dict]

            if data_dict["Event"] == "Deleted":
                print(projectile_summary(pending_projectiles[data_dict["Projectile"]]))
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
                    arma.print(f"{counter} total shots fired. {len(pending_projectiles)} pending projectiles.")
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
