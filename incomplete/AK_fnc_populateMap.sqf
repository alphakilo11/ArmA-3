AK_fnc_populateMap = {
	/*
		_groupCounter is not reliable, as it counts up, even if no group has been spawned (eg due to spawn limit)

		288 is the group limit for each side

		Example:
			[[0, 0, 0], worldSize, true, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", independent, 287] spawn AK_fnc_populateMap;
	*/

	params [
		["_referencePosition", [0,0,0], [[]]],
		["_areaSideLength", worldSize, [0]],
		["_spacing", true],
		["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile]],
		["_side", east, [east]], 
		["_numberOfGroups", 128, [0]] 
	];
	// auto determine spacing
	if (_spacing == true) then {
		_spacing = _areaSideLength / (sqrt _numberOfGroups);
	};

	enableDynamicSimulationSystem true;
	
	private _x = 0;
	private _y = 0;
	private _groupCounter = 0;	
	while {_y < _areaSideLength} do {
		while {_x < _areaSideLength} do {
			_spawnPosition = _referencePosition vectorAdd [_x, _y, 0]; 
			_group = [_spawnPosition, _side, _groupType] call BIS_fnc_spawnGroup;
			_group deleteGroupWhenEmpty true; 
			_group enableDynamicSimulation true;
			[_group, _spawnPosition, _spacing * 0.66, 3, 0.5, 0.5] call CBA_fnc_taskDefend;
			_groupCounter = _groupCounter + 1;
			_x = _x + _spacing;
		};
	_x = 0;
	_y = _y + _spacing;
	};
	[_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter] 
};
[] spawn AK_fnc_populateMap;