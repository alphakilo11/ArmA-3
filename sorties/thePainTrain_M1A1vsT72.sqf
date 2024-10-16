// THE PAIN TRAIN 
// requires AK_fnc_populateMap and AK_fnc_dynAdjustVisibility 
// ENHANCE check if center is water
#define RANDOM_CONFIG_CLASS(var) selectRandom ("true" configClasses (var))

AK_var_attackers = [];
_distance = 1600;
_anchorPosition = [0, 0, 0];
_size = worldSize;
_center = _anchorPosition vectorAdd [_size / 2, _size / 2, 0];
_ingressPosition = (_center vectorAdd [random _size, random _size, 0]);
_attackerCount = 40;
_defenderNumberOfGroups = 64;

_distance remoteExec ["setviewDistance", 0, "Viewdistance"];
_distance remoteExec ["setObjectViewDistance", 0, "Objectdistance"];
1.5 remoteExec ["setTerrainGrid", 0, "TerrainGrid"];// 50 removes grass, but the heightmap is very crude 
"Group" setDynamicSimulationDistance _distance;
{
	[[(missionStart select [0, 5]), time] call BIS_fnc_calculateDateTime, true, true] call BIS_fnc_setDate;
} remoteExec ["call", 2];
// spawn defenders
[_anchorPosition, _size, true, configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_72" >> "RHS_T72baSection", independent, _defenderNumberOfGroups] call AK_fnc_populateMap;
// enable dynamic visiblity adjustment
AK_handle_dynVis = [{
	[{
		[diag_fps, true, [10, 20, 26]] remoteExec ["AK_fnc_dynAdjustVisibility", 2];
	}] remoteExec ["call", -2];
}, 10] call CBA_fnc_addperFrameHandler;

AK_fnc_countUnits = {
	params ["_groups"];
	_sum = 0;
	{
		_sum = _sum + count units _x
	} forEach _groups;
	_sum;
};
// check if _ingressPosition is on land
_counter = 0;
while { surfaceIsWater _ingressPosition == true } do {
	_ingressPosition = (_center vectorAdd [random _size, random _size, 0]);
	_counter = _counter + 1;
	if (_counter >= 1000) exitWith {
		diag_log "THE PAIN TRAIN ERROR: Could not find a land position. Skipping attacker spawning.";
	};
};
// spawn attackers 
AK_handle_attackers = [
	{
		(_this select 0) params ["_ingressPosition", "_center", "_attackerCount"];
		if ([AK_var_attackers] call AK_fnc_countUnits <= _attackerCount) then {
			_group = [(_ingressPosition vectorAdd [random 200, random 200, 0]), west, configFile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_m1a1" >> "RHS_M1A1FEP_wd_Section"] call BIS_fnc_spawnGroup;// RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(configFile >> "cfgGroups" >> "west")))  
			_group deleteGroupWhenEmpty true;
			_wp = _group addWaypoint [_center, 50];
			            _wp setWaypointStatements ["true", "[this, [getPos (leader this), 500, 500, 0, true]] call CBA_fnc_taskSearchArea;"];// ENHANCE find a way to pass the array area size. Area Array = [center, a, b, angle, isRectangle, c]
			AK_var_attackers pushBack _group;
		};
		   // hint format ["%1, %2, %3, %4", _ingressPosition, _center, _attackerCount, [AK_var_attackers] call AK_fnc_countUnits];
	},
	60,
	[_ingressPosition, _center, _attackerCount]
] call CBA_fnc_addPerFrameHandler;