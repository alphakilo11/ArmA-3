"""
Companion program to inject live weather data into a running Arma 3 mission.

1. Determines the current worldName.
2. fetches the current Weather (openweathermap.org).
3. Determines and fetches closest METAR (aviationweather.gov)
4. Prepares the data for Arma 3
5. Saves it to a file, where Arma 3 can read it. (requires -filepatching)

Currently it has to be manually terminated.

CAVEATS
    When a dedicated Server and a Client are running different worldNames on the same machine, this program might fetch the wrong Weatherdata.
"""
#MISSING fog
#MISSING rain
#MISSING process METAR data
#ENHANCE add forecast
#ENHANCE cleanup logging

AIRPORT_DATA_FILEPATH = r"C:\Repositories\ArmA-3\data\airports.csv"
LOGFILE_FOLDER = r"C:\Users\krend\AppData\Local\Arma 3"
MAP_DATA_FILEPATH = r"C:\Repositories\ArmA-3\data\A3_worldnames.csv"
OUTPUT_FOLDER = r"C:\Spiele\Steam\steamapps\common\Arma 3\@AK_weatherdata"

import datetime
import logging
import math
from typing import Dict, List

def bearing_reverse(bearing):
    return (bearing - 180) % 360

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
        else:
            logging.WARNING(f"Unable to locate worldName in {latest_rpt}. Make sure, that a mission is running.")
            return None

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

def load_icao_latlon_from_file(filepath: str):
    """
    Load ICAO airport coordinates from a local OurAirports CSV file.
    "https://ourairports.com/data/airports.csv" is the file this function has in mind

    Args:
        filepath (str): Path to the 'airports.csv' file.

    Returns:
        dict: A dictionary with ICAO codes as keys and lat/lon as values:
              { "KJFK": {"lat": 40.6398, "lon": -73.7789}, ... }
    """
    import csv
    icao_coords = {}

    with open(filepath, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            icao = row["ident"].strip()
            if len(icao) == 4 and row["type"] in ("large_airport", "medium_airport", "small_airport"):
                try:
                    lat = float(row["latitude_deg"])
                    lon = float(row["longitude_deg"])
                    icao_coords[icao] = {"lat": lat, "lon": lon}
                except ValueError:
                    continue  # Skip malformed rows

    return icao_coords

def haversine(lat1, lon1, lat2, lon2):
    """Returns simple distance (Haversine)"""
    R = 6371.0 # km
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat/2)**2 + math.cos(math.radians(lat1))
        * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2)
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))

def get_nearest_METAR(lat: float, lon: float, icao_list, exclude_list=[]):
    logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
    best = {"dist": float("inf"), "station": None}
    logging.info(f"Searching {len(icao_list)} airports for the closest one.")
    for icao in icao_list.keys():
        if icao in exclude_list:
            continue
        logging.info(f"Checking {icao}...")
        d = haversine(lat, lon, 
                    float(icao_list[icao]["lat"]),
                    float(icao_list[icao]["lon"]))
        if d < best["dist"]:
            #info = fetch(icao)
            best = {"dist": d, "station": icao}
        #except Exception:
        #    continue
    if best["station"] is None:
        raise ValueError(f"No nearest airport with METAR found for {lat}, {lon}.")
    return best

def fetch_METAR(airport_list: list) -> str:
    """Fetch METAR data"""
    import requests
    if len(airport_list) == 0:
        return "ERROR: No items in provided list."
    if len(airport_list) == 1:
        ids = airport_list[0]
    else:
        ids = "%2C".join(airport_list)
    #try:
    url = f'https://aviationweather.gov/api/data/metar?ids={ids}'
    response = requests.get(url)
    response.raise_for_status()
    return response.text

def updateWeather(ICAO_station_data, map_data):
    logging.basicConfig(level=logging.CRITICAL, format="%(asctime)s - %(levelname)s - %(message)s")

    from pathlib import Path
    from timeit import default_timer as timer

    start_time = timer()
    logging.info(f"Fetching the worldName of the running Arma 3 session...")
    worldName = fetch_current_worldName(LOGFILE_FOLDER)
    if worldName == None:
        return None
    logging.info(f"{timer() - start_time} s.")
    logging.info(f"worldName={worldName}.")
    logging.info(f"{timer() - start_time} s.")
    output_filepath = rf"{OUTPUT_FOLDER}\{createOuputFileName(worldName, r"_weatherdata.sqf")}"
    file_path = Path(output_filepath)
    if file_path.exists() and file_path.is_file():
        logging.warning(f"File {file_path} already exists. Skipping...")
        return None
    current_map_lat = float(map_data[worldName][1])
    current_map_lon = float(map_data[worldName][2])
    print(f"Requesting current weather at {map_data[worldName]} from Openweathermap.org...")
    current_weather = request_current_weather(current_map_lat, current_map_lon)
    print(f"{timer() - start_time} s.", end = " ")
    print(f"{current_weather['current']}")
    print(timer() - start_time)
    print(f"✅ Loaded {len(ICAO_station_data)} ICAO airport entries.")
    nearest_airport = get_nearest_METAR(current_map_lat, current_map_lon, ICAO_station_data)
    print(timer() - start_time)
    metar_cache = fetch_METAR([nearest_airport["station"]]).strip()
    airport_exclude_list = []
    # try different airports until a METAR is fetched.
    while metar_cache == "":
        airport_exclude_list.append(nearest_airport["station"])
        nearest_airport = get_nearest_METAR(current_map_lat, current_map_lon, ICAO_station_data, airport_exclude_list)
        metar_cache = fetch_METAR([nearest_airport["station"]]).strip()
    print(nearest_airport)
    print(metar_cache)
    # METAR is fetched but not used
    print(timer() - start_time)   
    print(f"Extracting and converting weather data for Arma 3 use...")
    current_weather_main = current_weather['current']["weather"][0]["main"].lower()
    windX = current_weather['current']["wind_speed"] * math.sin(bearing_reverse(current_weather['current']["wind_deg"]))
    windY = current_weather['current']["wind_speed"] * math.cos(bearing_reverse(current_weather['current']["wind_deg"]))
    gustX = windX if "wind_gust" not in current_weather['current'].keys() else current_weather['current']["wind_gust"] * math.sin(bearing_reverse(current_weather['current']["wind_deg"]))
    gustY = windY if "wind_gust" not in current_weather['current'].keys() else current_weather['current']["wind_gust"] * math.cos(bearing_reverse(current_weather['current']["wind_deg"]))
    visibility = (current_weather['current']["visibility"] if current_weather['current']["visibility"] < 7000 else 7000) # set FFT3 view range limit for performance
    clouds = current_weather['current']['clouds'] / 100
    if clouds > 0.5 and ("rain" not in current_weather_main and "thunderstorm" not in current_weather_main): # avoid unintentional rain
        clouds = 0.5
    fog = 0
    if ("rain" in current_weather_main or "thunderstorm" in current_weather_main):
        rain = 1
    else:
        rain = 0
    precipitationType = 1 if "snow" in current_weather_main else 0
    lightning = 1 if "thunderstorm" in current_weather_main else 0
    final_string = f"['{worldName}', {windX}, {windY}, {gustX}, {gustY}, {visibility}, {clouds}, {fog}, {rain}, {precipitationType}, {lightning}]"
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
    logging.basicConfig(level=logging.CRITICAL, format="%(asctime)s - %(levelname)s - %(message)s")
    
    import time

    print("AK's updateWeather Companion for Arma 3 is running.")
    logging.info(f"Reading airport data from {AIRPORT_DATA_FILEPATH}...")
    ICAO_station_data = load_icao_latlon_from_file(AIRPORT_DATA_FILEPATH)
    logging.info(f"Reading map data from {MAP_DATA_FILEPATH}...")
    map_data = read_csv_to_dict(MAP_DATA_FILEPATH, delimiter=';')
    updateWeather(ICAO_station_data, map_data)
    while True:
        time.sleep(15)
        updateWeather(ICAO_station_data, map_data)
        print('.', end='', flush=True) # to see that the script is still awake
     

if __name__ == '__main__':
    main()