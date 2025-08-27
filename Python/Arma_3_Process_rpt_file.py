#!/usr/bin/env python
# coding: utf-8

# # Description
# ## Purpose
# Utils to work Arma 3 .rpt logfiles.
# ## Definitions
# ### Run
# Data from one .rpt file.
# Each run usually includes one or more missions.
# There is metadata for each run that applies to all included missions and there is mission-specific metadata.
# ## Prerequisites
# CBA (For PreInit and PostInit Metadata)
# ## TODO
# * Extract Mission Metadata
# * Extract the run-shutdown paragraph
# 
# ## Findings
# * "#restartserver" will create a new rpt file
# * "#missions" and "#restart" do not differ in the rpt file
# * There is no marker to mark mission end in the rpt file
# * "if string in string" is more than 10 times faster than re.findall()
# 
# ## Changelog
# 20250820
# * REMOVED find_relevant_relevante_lines() (Obsolete)
# * ADDED keys_tree()
# * QOL for extract_run_data.
# 
# 20250818
# * Implemented ID_HANDLE by creating extract_marked_lines()
# * Removed the multimission parameter and corresponding code lines from extract_run_data() (not necessary)
# 
# 20250714
# * ADDED extract_run_data()
# * Transformed the whole .ipynb to be used like a module (using %run)
# * Tested with client rpt file
# 
# 20250713
# * RENAMED extract_mission_metadata() to extract_mission_data()
# * ADDED preinit group to mission-metadata
# * Replaced MISSIONINIT with r"Starting mission:\n"
# * ADDED split_rpt_file()
# * ADDED find_relevant_lines()
# 
# 20250712 MODIFIED extract_mission_metadata() (client rpts will not show mission id)
# 
# 20250712 ADDED extract_run_metadata()
# 
# 20250712 ADDED extract_mission_metadata()
# 
# 20250711 Chose extract_mod_list(), as it's much faster than the alternatives. See # Performance for Details.

# # Setup

# In[14]:


import re
from datetime import datetime
import json
from rich import print
from rich.tree import Tree
from timeit import default_timer as timer

ID_FUNCTIONS = {"bD": "AK_fnc_ballisticData"}
ID_HANDLE = "aKHa"
LOGFILE_NUMBER = r'\b(?:\d+\.\d*|\.\d+|\d+)(?:[eE][+-]?\d+)?\b' # catches scientific, float and integers


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
    result["Current_time"] = datetime.strptime(result["Current_time"].strip(), "%Y/%m/%d %H:%M:%S")
    return result


# In[3]:


def extract_mission_data(postinit_text: str) -> dict:
    """ !!! NOT WORKING !!! """
    searchitems = [
        r"(?s)",
        rf"\n(?P<CBA_PreInit_startTime>(\d\d:\d\d:\d\d)) \[CBA\] \(xeh\) INFO: \[{LOGFILE_NUMBER},{LOGFILE_NUMBER},{LOGFILE_NUMBER}\] PreInit started\..*?\n",
        r"(?P<CBA_PreInit_paragraph>(.*?) PreInit finished\.)\n", # does not contain the "PreInit started" line
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


# In[4]:


def split_rpt_file(input_filepath: str, output_filepath=None, start_time=None) -> dict:
    if start_time == None:
        start_time = timer()
    print(f"Reading file '{input_filepath}'...")
    with open(input_filepath, 'r') as file:
        rawtext = file.read()
    print(f"{timer() - start_time} s.", end=" ")
    print(f"Splitting string in Run-Metadata and Missions...")
    logfile_parts = rawtext.split("Starting mission:\n")
    print(f"{timer() - start_time} s.", end=" ")
    print(f"{len(logfile_parts) - 1} missions found.", end= " ")
    print(f"Extracting Run-Metadata...")
    run_metadata = extract_run_metadata(logfile_parts.pop(0))
    print(f"{timer() - start_time} s.", end=" ")
    print(f"The run used ArmA 3 Version {run_metadata['Version']}", end=" ")
    if len(logfile_parts) < 1:
        print("WARNING: No mission data found. Skipping processing mission data.")
        return run_metadata
    missioncounter = 1
    missiondata = {}
    print(f"Processing missiondata...")
    for mission_rawdata in logfile_parts:
        print(f"Processing mission number {missioncounter}...")
        keystring = "Mission " + str(missioncounter)
        missiondata[keystring] = {}
        #DISABLED missiondata[keystring] = extract_mission_data(mission_rawdata)
        missiondata[keystring]['mission_rawdata'] = mission_rawdata
        print(f"{len(missiondata[keystring]['mission_rawdata'])} chars of logentries found in mission {missioncounter}.")
        missioncounter += 1
        print(f"{timer() - start_time} s.", end=" ")

    print(f"Processing finished.")
    if output_filepath != None:
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
            if len(split_line[0]) > 0 and split_line[0][0] in [str(x) for x in range(1,13)]:
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
                #modify data
                combined_dtg = datetime.combine(logfile_datetime.date(), log_timestamp.time()) #BUG will not properly work for daychanges
                # Detect if the time implies a shift in day
                if log_timestamp.time() < logfile_datetime.time():
                    combined_dtg += timedelta(days=1)

                cumulated_data.append({"Log Timestamp":combined_dtg, "data_dict": log_line_dict, "ID_HANDLE_dict": transform(ID_data.groupdict())})
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
                branch.add(f"Omitting dict with more than 10 items.")
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

    run_data = split_rpt_file(input_filepath,start_time=start_time)
    print(f"{timer() - start_time} s.", end=" ")
    print(f"Searching mission protocols for lines containing {ID_HANDLE}...")
    relevant_lines = []
    marked_for_removal = []
    for mission_designator in run_data["Run Missiondata"].keys():
        mission_lines = extract_marked_lines(run_data["Run Missiondata"][mission_designator]['mission_rawdata'], run_data["Run Metadata"]["Current_time"])
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
    print(f"{timer() - start_time} s.", end=" ")
    return (run_data)


# # Testing

# In[16]:


if __name__ == "__main__":
    filepath = "/content/drive/MyDrive/ArmA 3/Homebrew/Ballistik/AK_fnc_ballisticData/incoming/Arma3_x64_2025-08-19_06-53-32_aKHabD3.rpt"
    spam = extract_run_data(filepath)
    print(build_tree(spam))


# In[18]:


if __name__ == "__main__":
    spam['Run Missiondata']["Mission 1"]["Extracted Lines"][0]["ID_HANDLE_dict"]["version_number"]


# # Archive
# To keep obsolete functions iot allow performance replication.

# In[ ]:


'''
def fetch_between(text, start_marker, end_marker):
    start_escaped = re.escape(start_marker.strip())
    end_escaped = re.escape(end_marker.strip())
    pattern = re.compile(
        rf"{start_escaped}\n(.*?)(?={end_escaped})",
        re.DOTALL
    )
    return re.search(pattern, text).group(1)

def extract_mod_list(text):
    """
    Extracts all text between two long divider lines in a given string.

    Returns the content in between or an empty string if not found.
    """
    start_marker = f"{'=' * 93} List of mods {'=' * 95}"
    end_marker = f"{'=' * 202}"

    start_index = text.find(start_marker)
    end_index = text.find(end_marker, start_index + len(start_marker))

    if start_index == -1 or end_index == -1:
        return ""  # One or both markers not found

    # Extract the content between the markers
    return text[start_index + len(start_marker):end_index].strip()

def process_mod_list(text):
    pattern = re.compile(rf"\d\d:\d\d:\d\d (.*?)(?=\n)")
    result = pattern.search(text)
    return result.group(1)

def extract_text_between_markers(text, start_marker, end_marker):
    """
    Extracts all text between two given marker strings using regular expressions.

    Parameters:
        text (str): The full input text.
        start_marker (str): The exact start marker line.
        end_marker (str): The exact end marker line.

    Returns:
        str: The content between the start and end markers, or an empty string if not found.
    """
    import re
    # Escape the markers for safe regex use
    start_escaped = re.escape(start_marker.strip())
    end_escaped = re.escape(end_marker.strip())

    # Build a regex pattern to match text between the markers
    pattern = re.compile(
        rf"{start_escaped}\n(.*?)(?={end_escaped})",
        re.DOTALL
    )

    match = pattern.search(text)
    return match.group(1).strip() if match else ""
'''


# # Performance

# In[ ]:


'''
%%timeit
lall = blub.split("\n")
relevant_lines = []
for line in lall:
    if '"Function":"AK_fnc_ballisticData"' in line:
        relevant_lines.append(line)

%%timeit
re.findall(r'(?<=\n).*?"Function":"AK_fnc_ballisticData".*?(?=\n)', blub)

%%timeit
rawtext.split(start_marker)[1].split(end_marker)[0]

%%timeit
extract_mod_list(rawtext)

%%timeit
extract_text_between_markers(rawtext, start_marker, end_marker)

%%timeit
fetch_between(rawtext, start_marker, end_marker)

%%timeit
all_in_one_exctract(rawtext)
'''

