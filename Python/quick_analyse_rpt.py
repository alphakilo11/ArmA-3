# compatible with aKHabD1 and aKHabD2
import A3_local_utility as arma_local
import Arma_3_Process_rpt_file as arma
from timeit import default_timer as timer
start_time = timer()
from datetime import datetime
import json
import re

arma.print(f"{timer() - start_time} finished imports")

run_data = arma.extract_run_data(arma_local.find_latest_rpt_file())

cumulated_data = []
for missiondata in run_data["Run Missiondata"]:
    cumulated_data.extend(run_data["Run Missiondata"][missiondata]["Extracted Lines"])

#arma.print(f"{timer() - start_time} Done Extracting!")
# analyze
shot_count, kill_count = 0, 0
shooter_unittypes = set()
MPKilled_events = []
CriticalDmg_events = []
for event in cumulated_data:
    keys = event["data_dict"].keys()
    if "FirerPosition" in keys:
        if not "ParentProjectile" in keys: # count shots
            shot_count += 1
        shooter_unittypes.add(event["data_dict"]["Unittype"])
    if "Event" in keys:
        if event["data_dict"]["Event"] == "MPKilled":
            kill_count += 1
            MPKilled_events.append(event)
        if event["data_dict"]["Event"] not in  ["Deflected", "MPKilled", 'VehicleCriticalDammaged'] and "<NULL-object>" in event["data_dict"].values(): # find incomplete data
            arma.print(event)
        if event["data_dict"]["Event"] == "Vehicle Critical Dammaged":
            CriticalDmg_events.append(event)
arma.print(f"{timer() - start_time} Analysis done!")
arma.print(f"{shot_count} total shots registered.")
arma.print(f"{kill_count} total kills registered.")
arma.print(f"Unique shooting unittypes: {len(shooter_unittypes)}")

#len(re.findall(pattern, data)))
