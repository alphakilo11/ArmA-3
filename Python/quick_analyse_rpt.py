from datetime import datetime
import json
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.animation import FuncAnimation
import numpy as np
import pandas as pd
import re

ID_PATTERN = re.compile(r'.*?aKHa(?P<function_handle>[a-zA-Z]{2})(?P<number>\d*)')



with open(r'C:\Users\krend\AppData\Local\Arma 3\Arma3_x64_2025-08-18_09-47-02.rpt') as file:
    data = file.readlines()
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
                    cumulated_data.append(json.loads(log_line))
                except json.JSONDecodeError:
                    print(f'Could not load {"".join(line.split(" ")[2:])}')
print(len(cumulated_data))
#len(re.findall(pattern, data)))
