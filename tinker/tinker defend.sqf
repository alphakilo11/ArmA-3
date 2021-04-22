//creates a number of groups at AZ which will defend the area.
//Works local and on DS
//REQUIRED: CBA, RHS
//TODO remove messages


[] spawn {
	AZ = [21100, 7400, 0]; //3D value required for CBA_fnc_task to work
	private _numberofgroups = 14;
	
	
	for "_i" from 1 to _numberofgroups step 1 do {
		uiSleep 0.1;
		[] spawn {
		private _side = West;
		private _grouptype = configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad";
		
		private _vfgrm = [AZ, 0, 846] call BIS_fnc_findSafePos;
		_gruppe = [_vfgrm, _side, _grouptype] call BIS_fnc_spawnGroup;
		_gruppe deleteGroupWhenEmpty true;
		systemChat format ["%1 spawned at %2.", _gruppe, _vfgrm];
		[_gruppe, AZ, 846] call CBA_fnc_taskDefend;
		};
	};
};
