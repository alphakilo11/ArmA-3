#!/usr/bin/env python
# coding: utf-8

import re
from datetime import datetime
from datetime import timedelta
import json
from rich import print
from rich.tree import Tree
from timeit import default_timer as timer

ID_FUNCTIONS = {"bD": "AK_fnc_ballisticData", "Be": "AK_fnc_Benchmark"}
ID_HANDLE = "aKHa"
LOGFILE_NUMBER = r'\b(?:\d+\.\d*|\.\d+|\d+)(?:[eE][+-]?\d+)?\b'  # catches scientific, float and integers


# In[2]:


def extract_run_metadata(init_text: str) -> dict:
    search_elements = [
        r'(?s)'
        r'== "(?P<launch_prompt>.*?)(?=\n)',
        r'(.*?)',
        r'Current time:(?P<Current_time>.*?)(?=\n)',
        r'(.*?)',
        r'Version:(?P<Version>.*?)(?=\n)',
        r'(.*?)',
        r'Allocator:(?P<Allocator>.*?)(?=\n)',
        r'(.*?)',
        r'PhysMem:(?P<PhysMem>.*?)(?=\n)',
        r'(.*?)',
        rf'{58 * "-"} Dlcs {58 * "-"}\n(?P<DLCs_paragraph>(.*?))(?={122 * "-"}\n)',
        r'(.*?)',
        rf"{'=' * 93} List of mods {'=' * 95}\n(?P<Mods_paragraph>(.*?))(?={'=' * 202}\n)"
    ]
    pattern = "".join(search_elements)
    result = re.search(pattern, init_text).groupdict()
    result["Current_time"] = datetime.strptime(result["Current_time"].strip(),
                                               "%Y/%m/%d %H:%M:%S")
    return result


# In[3]:

'''
def extract_mission_data(postinit_text: str) -> dict:
    """ !!! NOT WORKING !!! """
    searchitems = [
        r"(?s)",
        rf"\n(?P<CBA_PreInit_startTime>(\d\d:\d\d:\d\d)) \[CBA\] \(xeh\) INFO: \[{LOGFILE_NUMBER},{LOGFILE_NUMBER},{LOGFILE_NUMBER}\] PreInit started\..*?\n",
        r"(?P<CBA_PreInit_paragraph>(.*?) PreInit finished\.)\n",  # does not contain the "PreInit started" line
        r'(.*?)',
        rf"\n(?P<CBA_PostInit_startTime>(\d\d:\d\d:\d\d)) \[CBA\] \(xeh\) INFO: \[{LOGFILE_NUMBER},{LOGFILE_NUMBER},{LOGFILE_NUMBER}\] (?=PostInit started\.)",
        r'(?P<CBA_PostInit_paragraph>(.*?PostInit finished.\n))',
        r'(?P<mission_rawdata>(.*))'
    ]
    """ NEEDS WORK
    if isServer == True:
        searchitems.append(r"Mission id: (?P<Mission_id>(.*?))(?=\n)")
    """
    pattern = "".join(searchitems)
    try:
        result = re.search(pattern, postinit_text).groupdict()
    except AttributeError as e:
        #print(f"extract_mission_data() ERROR: No missiondata found in {postinit_text}")
        raise "whatever"
    return result
'''

# In[4]:


def split_rpt_file(input_filepath: str, output_filepath=None, start_time=None) -> dict:
    if start_time is None:
        start_time = timer()
    print(f"Reading file '{input_filepath}'...")
    with open(input_filepath, 'r') as file:
        rawtext = file.read()
    print(f"{timer() - start_time} s.", end=" ")
    print("Splitting string in Run-Metadata and Missions...")
    logfile_parts = rawtext.split("Starting mission:\n")
    print(f"{timer() - start_time} s.", end=" ")
    print(f"{len(logfile_parts) - 1} missions found.", end=" ")
    print("Extracting Run-Metadata...")
    run_metadata = extract_run_metadata(logfile_parts.pop(0))
    print(f"{timer() - start_time} s.", end=" ")
    print(f"The run used ArmA 3 Version {run_metadata['Version']}", end=" ")
    if len(logfile_parts) < 1:
        print("WARNING: No mission data found. Skipping processing mission data.")
        return run_metadata
    missioncounter = 1
    missiondata = {}
    print("Processing missiondata...")
    for mission_rawdata in logfile_parts:
        print(f"Processing mission number {missioncounter}...")
        keystring = "Mission " + str(missioncounter)
        missiondata[keystring] = {}
        missiondata[keystring]['mission_rawdata'] = mission_rawdata
        print(f"{len(missiondata[keystring]['mission_rawdata'])} \
              chars of logentries found in mission {missioncounter}.")
        missioncounter += 1
        print(f"{timer() - start_time} s.", end=" ")

    print("Processing finished.")
    if output_filepath is not None:
        print("Saving results to '{output_filepath}'.")
        with open(output_filepath, "w") as file:
            json.dump(missiondata, file)
        print(f"{timer() - start_time} s.")
    return {"Run Metadata": run_metadata, "Run Missiondata": missiondata}


# In[12]:


def extract_marked_lines(data, logfile_datetime):
    def transform(id_handle_content: dict):
        id_handle_content["function_handle"] = ID_FUNCTIONS[id_handle_content["function_handle"]]
        id_handle_content["version_number"] = int(id_handle_content["version_number"])
        return id_handle_content

    ID_PATTERN = re.compile(rf".*?{ID_HANDLE}(?P<function_handle>[a-zA-Z]{{2}})(?P<version_number>\d*)")
    cumulated_data = []
    lines = data.split('\n')
    for line in lines:
        ID_data = re.match(ID_PATTERN, line)
        if ID_data:
            split_line = line.strip().split(' ')
            if len(split_line[0]) > 0 and split_line[0][0] in [str(x) for x in range(0, 13)]:
                try:
                    log_timestamp = datetime.strptime(split_line[0], r"%H:%M:%S")
                except ValueError:
                    print(f"Could not convert {split_line[0]} to datetime object.")
                    raise

                log_line = "".join(split_line[1:])
                if len(log_line) > 0 and log_line[0] == "{":
                    try:
                        log_line_dict = json.loads(log_line)
                    except json.JSONDecodeError:
                        print(f'json could not decode {log_line}')
                        continue
                # modify data
                combined_dtg = datetime.combine(logfile_datetime.date(), log_timestamp.time())
                # Detect if the time implies a shift in day
                if log_timestamp.time() < logfile_datetime.time():
                    combined_dtg += timedelta(days=1)
                    # print(f"{__name__}: Detected shift in dtg. Adjusting...{combined_dtg}")

                cumulated_data.append({"Log Timestamp": combined_dtg, "data_dict": log_line_dict,
                                       "ID_HANDLE_dict": transform(ID_data.groupdict())})
    return cumulated_data


def build_tree(data, label="root"):
    """
    Build a Rich Tree view of nested dicts/lists.
    - Dicts: show key names.
    - Lists: only expand the first item (with a note if more exist).
    - Leaves: show data type instead of value.
    """
    # Root tree node
    tree = Tree(f"[bold]{label}[/]")

    def _add(node, value):
        if isinstance(value, dict):
            branch = node.add(f"dict ({len(value)} keys)")
            if len(value) > 10:
                branch.add("Omitting dict with more than 10 items.")
            else:
                for k, v in value.items():
                    child = branch.add(f"[cyan]{k}[/]:")
                    _add(child, v)

        elif isinstance(value, list):
            branch = node.add(f"list ({len(value)} items)")
            if value:  # show only the first element
                child = branch.add("[0]")
                _add(child, value[0])
                if len(value) > 1:
                    branch.add(f"... ({len(value)-1} more not shown)")
            else:
                branch.add("[empty]")

        else:  # primitive type
            node.add(f"[green]{type(value).__name__}[/]")

    _add(tree, data)
    return tree


# # Execution

# In[8]:


def extract_run_data(input_filepath: str) -> dict:

    start_time = timer()

    run_data = split_rpt_file(input_filepath, start_time=start_time)
    print(f"{timer() - start_time} s.", end=" ")
    print(f"Searching mission protocols for lines containing {ID_HANDLE}...")
    marked_for_removal = []
    for mission_designator in run_data["Run Missiondata"].keys():
        mission_lines = extract_marked_lines(run_data["Run Missiondata"][mission_designator]['mission_rawdata'],
                                             run_data["Run Metadata"]["Current_time"])
        if len(mission_lines) == 0:
            print(f"No relevant lines found in {mission_designator}. Removing Misiondata.")
            marked_for_removal.append(mission_designator)
        else:
            print(f"{len(mission_lines)} relevant lines found in {mission_designator}")
            run_data["Run Missiondata"][mission_designator]["Extracted Lines"] = mission_lines
            del run_data["Run Missiondata"][mission_designator]['mission_rawdata']
    if len(marked_for_removal) > 0:
        for key in marked_for_removal:
            del run_data["Run Missiondata"][key]
    print(f"{timer() - start_time} s extracting run data complete.")
    return (run_data)
