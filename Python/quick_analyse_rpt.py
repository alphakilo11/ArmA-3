# compatible with aKHabD1 and aKHabD2
import A3_local_utility as arma
from timeit import default_timer as timer
start_time = timer()
from datetime import datetime
import json
import re

print(f"{timer() - start_time} finished imports")

ID_PATTERN = re.compile(r'.*?aKHa(?P<function_handle>[a-zA-Z]{2})(?P<number>\d*)')

print(f"{timer() - start_time} finished static variables")


with open(arma.find_latest_rpt_file(), encoding='utf-8') as file:
    data = file.readlines()
print(f"{timer() - start_time} finished reading file.")
cumulated_data = []
for line in data:
    if re.match(ID_PATTERN, line):
        split_line = line.strip().split(' ')
        if len(split_line[0]) > 0 and split_line[0][0] in [str(x) for x in range(1,13)]:
            try:
                log_timestamp = datetime.strptime(split_line[0], r"%H:%M:%S")
            except ValueError:
                print(f"Could not convert {split_line[0]} to datetime object.")
                raise
            log_line = "".join(split_line[1:])
            if len(log_line) > 0 and log_line[0] == "{":
                try:
                    cumulated_data.append((log_timestamp, json.loads(log_line)))
                except json.JSONDecodeError:
                    print(f'Could not load {"".join(line.split(" ")[2:])}')
print(f'{len(cumulated_data)} data lines extracted.' )
print(f"{timer() - start_time} Done Extracting!")
# analyze
shot_count, kill_count = 0, 0
shooter_unittypes = set()
MPKilled_events = []
CriticalDmg_events = []
for event in cumulated_data:
    data_dict = event[1]
    keys = data_dict.keys()
    if "FirerPosition" in keys:
        if not "ParentProjectile" in keys: # count shots
            shot_count += 1
        shooter_unittypes.add(data_dict["Unittype"])
    if "Event" in keys:
        if data_dict["Event"] == "MPKilled":
            kill_count += 1
            MPKilled_events.append(event)
        if data_dict["Event"] not in  ["Deflected", "MPKilled", 'VehicleCriticalDammaged'] and "<NULL-object>" in data_dict.values(): # find incomplete data
            print(event)
        if data_dict["Event"] == "Vehicle Critical Dammaged":
            CriticalDmg_events.append(event)
print(f"{timer() - start_time} Analysis done!")
print(f"{shot_count} total shots registered.")
print(f"{kill_count} total kills registered.")
print(f"Unique shooting unittypes: {len(shooter_unittypes)}")

#len(re.findall(pattern, data)))
