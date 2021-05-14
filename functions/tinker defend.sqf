//creates a number of groups at _AZ which will defend an area (size of which is based on taktik Handakt OPFOR values) .
//Works local and on DS
//REQUIRED: CBA
//TODO remove messages
//Params _AZ 3D position
/*
example:
[[21100, 7400, 0], 12] call AK_fnc_defend;
*/

AK_fnc_defend ={
	params ["_AZ", "_numberofgroups"];
	
	
	for "_i" from 1 to _numberofgroups step 1 do {
		private _side = West;
		private _grouptype = configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad";
		private _radius = (_numberofgroups * 77);
		private _vfgrm = [_AZ, 0, _radius] call BIS_fnc_findSafePos;
		private _gruppe = [_vfgrm, _side, _grouptype] call BIS_fnc_spawnGroup;
		_gruppe deleteGroupWhenEmpty true;
		[_gruppe, _AZ, _radius] call CBA_fnc_taskDefend;
	};
};