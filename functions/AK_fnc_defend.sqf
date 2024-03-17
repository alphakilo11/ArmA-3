//creates a number of groups at _AZ which will defend an area (size of which is based on taktik Handakt OPFOR values) . 
//Works local and on DS 
//REQUIRED: CBA 
//Params _AZ 3D position 
/* 
example: 
[getPos player, 5, side player, "I_MBT_03_cannon_F"] call AK_fnc_defend;  
*/ 
 
AK_fnc_defend = { 
	if (isNil "AK_fnc_differentiateClass") exitWith {diag_log "AK_fnc_defend ERROR: AK_fnc_differentiateClass required"}; 

	params ["_AZ", "_numberofgroups", "_side", "_grouptype"]; 
	for "_i" from 1 to _numberofgroups step 1 do { 
		private _radius = (_numberofgroups * 77); 
		private _vfgrm = [_AZ, 0, _radius] call BIS_fnc_findSafePos; 
		private _gruppe = nil; 
		if ((_grouptype call AK_fnc_differentiateClass) == "Group") then { 
			_gruppe = [_vfgrm, _side, _grouptype] call BIS_fnc_spawnGroup; 
		}; 
		if ((_grouptype call AK_fnc_differentiateClass) == "Vehicle") then { 
			_gruppe = ([_vfgrm, 0, _grouptype, _side] call BIS_fnc_spawnVehicle) select 2; 
		}; 
		if (isNull _gruppe) exitWith {diag_log "AK_fnc_defend ERROR: no groups spawned"}; 
		_gruppe deleteGroupWhenEmpty true; 
		[_gruppe, _AZ, _radius] call CBA_fnc_taskDefend; 
	}; 
}; 
