AK_sortie_CircleOfDeath = { 
/* Create diverse vehicles and spread them in an area 
Example 
[] spawn {
	AK_switch_ServerDiag = true;
	while {AK_switch_ServerDiag == true} do {
	
		if (diag_fps >= 100) then {
			[] spawn AK_sortie_CircleOfDeath;
		};
	
		private _nonMovers = [];
		{
			if ((vectorMagnitudeSqr (velocity _x)) <= 1) then {_nonMovers pushBack _x};
		} forEach (vehicles select {alive _x});
		private _message = createHashMapFromArray [["All Units", count allUnits], ["West", {side _x == west} count allUnits], ["East", {side _x == east} count allUnits],
		["Indep", {side _x == independent} count allUnits], ["Civ", {side _x == civilian} count allUnits], ["Non-Movers", count _nonMovers],
		["Mover Ratio", (({alive _x} count vehicles) - count _nonMovers) / ({alive _x} count vehicles)], ["Server-owned groups", {groupOwner _x == 2} count allGroups],
		["Vehicles", count vehicles], ["FPS", diag_fps], ["Corpses", count allDeadMen], ["TimeUTC", systemTimeUTC]];
		[str _message] remoteExec ["systemChat", 0];
		diag_log _message;
		sleep 30;
	};
}; 
 
 */ 
 
// Create vehicle types array 
private _spawnCenter = [20340, 8140, 0]; 
private _spawnRadius = 1500; 
private _minSpawnRadius = 300; 
/* Inf only DISABLED 
 
private _vehicleTypes = "(  
 (getNumber (_x >> 'scope') >= 2) &&   
  {'Man' in ([_x, true] call BIS_fnc_returnParents)}; 
)" configClasses (configFile >> "CfgVehicles"); 
*/ 
private _vehicleTypes = "( 
	(getNumber (_x >> 'scope') >= 2) &&   
	{ 
		 ( 
			'LOP_' in (configName _x) || 
			'rhs' in (configName _x)			 
		 
		) && 
		{ 
			'LandVehicle' in ([_x, true] call BIS_fnc_returnParents) ||  
			'Air' in  ([_x, true] call BIS_fnc_returnParents) || 
			'Man' in ([_x, true] call BIS_fnc_returnParents) 
		} 
	} 
)" configClasses (configFile >> "CfgVehicles"); 
 
for "_i" from 1 to (round diag_fps) do {  
	private _pos = _spawnCenter getPos [_spawnRadius, random 36000 / 100];// [[[_spawnCenter, _spawnRadius]]] call BIS_fnc_randomPos; 
	while {_pos distance _spawnCenter > _minSpawnRadius && {[objNull, "VIEW"] checkVisibility [AGLtoASL _pos, AGLToASL (_spawnCenter vectorAdd [0,0,6])] < 1}} do { 
		_pos = _pos getPos [10, _pos getDir _spawnCenter]; 
	}; 
	private _dir = _pos getDir _spawnCenter; 
	private _type = selectRandom _vehicleTypes; 
	private _side = [getNumber (_type >>'side')] call BIS_fnc_sideType; 
	// exclude specific sides 
	/* DISABLED 
	while {_side == west} do { 
		_type = selectRandom _vehicleTypes; 
		_side = [getNumber (_type >>'side')] call BIS_fnc_sideType; 
	}; 
	*/ 
	private _spawnData = [_pos, _dir, configName _type, _side, false] call BIS_fnc_spawnVehicle; 
	private _group = (_spawnData select 2); 
	_group deleteGroupWhenEmpty true; 
	//_group setBehaviour "SAFE"; 
	(_spawnData select 0) allowCrewInImmobile true; 
	[_group, _spawnCenter, _spawnRadius / 5, 3, "MOVE", "SAFE", "YELLOW", "FULL", "STAG COLUMN", "", [3, 6, 9]] call CBA_fnc_taskPatrol; 
	/* DISABLED 
	private _wpPos = _spawnCenter; //[[[_spawnCenter, _spawnRadius]]] call BIS_fnc_randomPos; 
	while {surfaceIsWater _wpPos == true} do {_wpPos = [[[_spawnCenter, _spawnRadius]]] call BIS_fnc_randomPos}; 
	_group addWaypoint [_wpPos, _spawnRadius / 5]; 
	private _waypoint = _group addWaypoint [getPos leader _group, 0]; 
	_waypoint setWaypointType "CYCLE"; 
	*/  
};
/* use this?
{
  {
    if (waypointPosition _x isEqualTo [0,0,0]) then { deleteWaypoint _x };
  } forEachReversed waypoints _x;
} forEach allGroups;
*/
/* DISABLED 
[_spawnCenter, _spawnRadius] spawn { 
	params ["_spawnCenter", "_spawnRadius"]; 
	sleep 60; 
	private _counter = 0; 
	{  
		private _waypoints = waypoints _x;  
		private _i = count _waypoints - 1;   
		while {_i >= 0} do { 
			private _wp =  _waypoints select _i; 
			private _pos = waypointPosition _wp;  
			if ((_pos select 0 == 0) || (_pos select 1 == 0)) then {   
				deleteWaypoint _wp; 
				private _wpPos = _spawnCenter; //[[[_spawnCenter, _spawnRadius]]] call BIS_fnc_randomPos; 
				while {surfaceIsWater _wpPos == true} do {_wpPos = [[[_spawnCenter, _spawnRadius]]] call BIS_fnc_randomPos}; 
				private _newWp = _x addWaypoint [_wpPos, 0, 0]; 
				_x setCurrentWaypoint _newWp; 
				_counter = _counter + 1;  
			};  
			_i = _i - 1;  
		};   
	} forEach allGroups; 
	[format ["%1 waypoints replaced.", _counter]] remoteExec ["systemChat", 0]; 
}; 
 
[] spawn { 
	private _nonMovers = []; 
	{ 
		if ((vectorMagnitudeSqr (velocity _x)) <= 1) then {_nonMovers pushBack _x}; 
	} forEach allUnits; 
	private _message = format ["%1 non-Movers amount to %2 % of allUnits", count _nonMovers, count _nonMovers / count allUnits]; 
	systemChat _message; 
	diag_log _message; 
}; 
//[typeOf _vehicle, typeName _vehicle, _vehicle] 
*/ 
};
