// using AK_fnc_cfgFactionTable to get a random faction and AK_fnc_cfgGroupTable to get a random group and spawn it without vehicles.
_cfgFaction = str text (selectRandom ([1] call AK_fnc_cfgFactionTable));
_cfggroup = selectRandom ([_cfgFaction] call AK_fnc_cfgGroupTable);
_grp = [[23000, 19000, 0], independent, _cfggroup, [], [], [], [], [], 180, false, 0] call BIS_fnc_spawnGroup;
_grp deleteGroupWhenEmpty true;