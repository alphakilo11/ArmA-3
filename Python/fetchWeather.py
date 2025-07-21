import datetime
import logging
from typing import Dict, List

def read_csv_to_dict(file_path: str, delimiter: str = ',') -> Dict[str, List[str]]:
    """
    Reads a CSV file and returns a dictionary with the first column as keys
    and the remaining columns as values in a list.

    Parameters:
        file_path (str): Path to the CSV file to read.
        delimiter (str): Delimiter used in the CSV file (default is ',').

    Returns:
        Dict[str, List[str]]: A dictionary mapping keys to lists of values.

    Raises:
        FileNotFoundError: If the file is not found.
        ValueError: If a row has fewer than 2 columns.
        IOError: If there's a problem reading the file.
    """
    import csv
    result: Dict[str, List[str]] = {}

    try:
        with open(file_path, mode='r', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile, delimiter=delimiter)
            for row_number, row in enumerate(reader, start=1):
                if not row:
                    continue  # skip empty lines

                if len(row) < 2:
                    raise ValueError(f"Row {row_number} has fewer than 2 columns: {row}")

                key = row[0]
                values = row[1:]

                if key in result:
                    print(f"Warning: Duplicate key '{key}' found on row {row_number}, overwriting previous entry.")
                if key == 'worldName':
                    continue # skip header
                result[key] = values

        return result

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        raise
    except Exception as e:
        print(f"Error reading file '{file_path}': {e}")
        raise

def find_latest_rpt_file(directory):
    """Find the most recently modified .rpt file in a directory."""
    import glob
    import os
    rpt_files = glob.glob(os.path.join(directory, "*.rpt"))
    if not rpt_files:
        raise FileNotFoundError("No .rpt files found in the directory.")

    latest_file = max(rpt_files, key=os.path.getmtime)
    return latest_file

def find_world_name_from_bottom(file_path):
    """Search for the first occurrence of 'worldName=' from the bottom of the file."""
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
    except Exception as e:
        raise IOError(f"Error reading file {file_path}: {e}")

    for line in reversed(lines):
        if "worldName=" in line:
            return line.strip()

    raise ValueError("'worldName=' not found in the file.")

def fetch_current_worldName(folderpath):
    logging.basicConfig(level=logging.WARNING, format="%(asctime)s - %(levelname)s - %(message)s")

    try:
        latest_rpt = find_latest_rpt_file(folderpath)
        logging.info(f"Latest .rpt file: {latest_rpt}")

        result_line = find_world_name_from_bottom(latest_rpt)
        logging.info(f"Found line: {result_line}")

        # Optional: Extract just the world name (assuming format: "worldName=SomeWorld")
        if "worldName=" in result_line:
            world_name = result_line.split("worldName=", 1)[1].split(', ')[0].strip()
            return world_name

    except Exception as e:
        logging.error(f"An error occurred: {e}")

def request_current_weather(lat, lon):
    import requests
    with open(r"C:\Users\krend\OneDrive\Openweathermap_API_Key.txt") as file:
        API_key = file.read()
    url = f"https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&appid={API_key}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code}")
        return None
def createOuputFileName(worldName, ending):
    current_UTC_time = datetime.datetime.now(datetime.UTC)
    filename = f'{datetime.datetime.strftime(current_UTC_time, "%Y%m%d%H")}{"30" if current_UTC_time.minute >=30 else "00"}_{worldName.lower()}{ending}'
    return filename

def updateWeather():
    #BUG wind probably needs 180° correction
    #MISSING fog
    #MISSING rain
    #ENHANCE add forecast

    LOGFILE_FOLDER = r"C:\Users\krend\AppData\Local\Arma 3"
    OUTPUT_FOLDER = r"C:\Spiele\Steam\steamapps\common\Arma 3\@AK_weatherdata"
    MAP_DATA_FILEPATH = r"C:\Repositories\ArmA-3\data\A3_worldnames.csv"
    logging.basicConfig(level=logging.CRITICAL, format="%(asctime)s - %(levelname)s - %(message)s")


    import math
    from pathlib import Path
    from timeit import default_timer as timer
    start_time = timer()
    logging.info(f"Fetching the worldName of the running Arma 3 session...")
    worldName = fetch_current_worldName(LOGFILE_FOLDER)
    logging.info(f"{timer() - start_time} s.", end = " ")
    logging.info(f"worldName={worldName}.")
    logging.info(f"Reading map data from {MAP_DATA_FILEPATH}...")
    map_data = read_csv_to_dict(MAP_DATA_FILEPATH, delimiter=';')
    logging.info(f"{timer() - start_time} s.", end = " ")
    output_filepath = rf"{OUTPUT_FOLDER}\{createOuputFileName(worldName, r"_weatherdata.sqf")}"
    file_path = Path(output_filepath)
    if file_path.exists() and file_path.is_file():
        logging.warning(f"File {file_path} already exists. Skipping...")
        return None
    print(f"Requesting current weather at {map_data[worldName]} from Openweathermap.org...")

    print("HEADSUP LOCATION OVERRIDE ACTIVE")
    current_weather = request_current_weather(47.347532, 13.209203)#(*map_data[worldName][1:3])


    print(f"{timer() - start_time} s.", end = " ")
    print(f"{current_weather['current']}")
    print(f"Extracting and converting weather data for Arma 3 use...")
    windX = current_weather['current']["wind_speed"] * math.sin(current_weather['current']["wind_deg"])
    windY = current_weather['current']["wind_speed"] * math.cos(current_weather['current']["wind_deg"])
    gustX = windX if "wind_gust" not in current_weather['current'].keys() else current_weather['current']["wind_gust"] * math.sin(current_weather['current']["wind_deg"])
    gustY = windY if "wind_gust" not in current_weather['current'].keys() else current_weather['current']["wind_gust"] * math.cos(current_weather['current']["wind_deg"])
    visibility = (current_weather['current']["visibility"] if current_weather['current']["visibility"] < 7000 else 7000) # set FFT3 view range limit for performance
    clouds = current_weather['current']['clouds'] / 100
    fog = 0
    rain = 0 / 100
    precipitationType = 0 #rain
    final_string = f"['{worldName}', {windX}, {windY}, {gustX}, {gustY}, {visibility}, {clouds}, {fog}, {rain}, {precipitationType}]"
    print(f"{timer() - start_time} s.", end = " ")
    print(f"Writing {final_string} to {output_filepath}...")
    try:
        with open(output_filepath, 'w') as file:
            file.write(final_string)
    except:
        print("WARNING: Could not write file.")
    print(f"{timer() - start_time} s.", end = " ")
    print(f'DONE!')
    return None

def main():
    import time
    updateWeather()
    while True:
        time.sleep(15)
        updateWeather()
        print('.', end='', flush=True) # to see that the script is still awake
        

if __name__ == '__main__':
    main()