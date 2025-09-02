import os
import time
import logging
import A3_local_utility as arma_local
import Arma_3_Process_rpt_file as arma
import numpy as np
from timeit import default_timer as timer

LOGFILE_FOLDER = r"C:\Users\krend\AppData\Local\Arma 3"
FILEPATH = arma_local.find_latest_rpt_file()
POLL_INTERVAL = 1  # s. Don't change this, as it will break the other intervals
CLEANUP_INTERVAL = 180
STATS_INTERVAL = 60
START_TIME = timer()
RUN_METADATA = arma.extract_run_data(FILEPATH)["Run Metadata"]

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
        event_info = log_event_dict[0]["data_dict"]
        try:
            projectile_id = event_info["Projectile"]
        except KeyError:
            print(f"{__name__} KeyError processing: {event_info}")
            return None
        if "FirerPosition" in event_info.keys():
            for key in ["Unit", "Unittype", "Weapon", "Ammo"]:
                arma.print(f"{key}: {event_info[key]}", end=", ")
            print()
            pending_projectiles[projectile_id] = [event_info]
            counter += 1
        else:
            if "Event" in event_info.keys():
                try:
                    if projectile_id in pending_projectiles.keys():
                        pending_projectiles[projectile_id].append(event_info)
                    else:
                        pending_projectiles[projectile_id] = [event_info]
                except KeyError:
                    print(f"{__name__} KeyError: {event_info}")
                    return None

                if event_info["Event"] == "Deleted":
                    print(projectile_summary(pending_projectiles[projectile_id]))
                    del pending_projectiles[projectile_id]


def projectile_summary(projectile_dict):
    try:
        shooter_pos = projectile_dict[0]["FirerPosition"]
    except KeyError:
        print(f"Error processing {projectile_dict[0]} in {projectile_dict}. Skipping...")
        return None
    deleted_pos = projectile_dict[-1]["Position"]
    total_distance = np.linalg.norm(np.array(shooter_pos) - np.array(deleted_pos))
    time_alive = projectile_dict[-1]["tickTime"] - projectile_dict[0]["tickTime"]
    avg_speed = total_distance / (time_alive if time_alive > 0 else 0.01)

    report = f'Time alive: {round(time_alive, 2)} '\
        f'Projectile Travel: {round(total_distance, 2)} m '\
        f'Avg. Speed: {round(avg_speed)} m/s.'
    return report


def display_stats():
    arma.print(f"{counter} total shots fired. {len(pending_projectiles)} pending projectiles.")


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
                    if (round(timer() - START_TIME)) % STATS_INTERVAL == 0:
                        display_stats()
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
