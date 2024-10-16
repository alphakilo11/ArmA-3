20210518
// works (sometimes will spawn no units)
private _cfgFaction = str text (selectRandom ([1] call AK_fnc_cfgFactionTable));
private _side = west;
private _numberOfUnits = 0;
private _timeout = 0;
private _spawnedgroups = [];
private _AZ = [21380, 16390, 0];
private _vfgrm = _AZ vectorAdd [-1000, 0, 0];
while { _numberOfUnits < 40 && _timeout < 41 } do {
	_cfggroup = selectRandom ([_cfgFaction] call AK_fnc_cfgGroupTable);
	_grp = [_vfgrm, _side, _cfggroup, [], [], [], [], [], 180, false, 0] call BIS_fnc_spawnGroup;
	_spawnedgroups pushBack _grp;
	_numberOfUnits = _numberOfUnits + count (units _grp);
	_grp deleteGroupWhenEmpty true;
	_grp addWaypoint [_AZ, 100];
	_timeout = _timeout + 1;
};
if (_timeout >= 41) then {
	diag_log "Spawning failed."
};
_spawnedgroups

// Only works from time to time...
_groups = [west, "West", [23000, 19000, 0]] call AK_fnc_spawnRandomInfPlatoon;
{
	[_x, [22000, 19000, 0], (28 * (count _groups))] call CBA_fnc_taskAttack
} forEach _groups;

20210514
// Proof of concept (works in MP)
{
	[] spawn {
		_AK_var_1 = [12, "B_MBT_01_cannon_F", [14000, 18000, 0], [12000, 18000, 0], east, 85, "AWARE", 500, 3] call AK_fnc_spacedvehicles;
		sleep 15;
		{
			deleteVehicle _x
		} forEach (_AK_var_1 select 0);
		{
			deleteVehicle _x
		} forEach (_AK_var_1 select 1);
		{
			deleteGroup _x
		} forEach (_AK_var_1 select 2);
		_AK_var_1 = nil;
	};
} remoteExec ["call", 6];

// params: _side, 
// select a random _faction of _side
// select random infantry groups of given _faction
// form a platoon by repeating to spawn units until hitting 40

private ["_cfgArray", "_xPos", "_yPos", "_veh"];

_cfgArray = "((getNumber (_x >> 'scope') >= 2) &&
{
	getNumber (_x >> 'side') == 1
}
)" configClasses (configFile >> "CfgVehicles");
_cfgArray;

// works as long as no vehicles are included
private ["_cfgArray", "_faction", "_group", "_groupname", "_soldiers"];

_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West");
_faction = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction);
_arm = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm);
_soldiers = 0;
while { _soldiers < 40 } do {
	_group = (selectRandom _cfgArray);
	_groupname = configName _group;
	_soldiers = _soldiers + (count ("true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm >> _groupname)));
	[[23000, 19000, 0], west, _group] call BIS_fnc_spawnGroup;
};

private ["_cfgArray", "_faction", "_group", "_groupname", "_units", "_soldiers"];

_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West");
_faction = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction);
_arm = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm);
_soldiers = 0;
while { _soldiers < 40 } do {
	_group = (selectRandom _cfgArray);
	_groupname = configName _group;
	_units = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm >> _groupname);
	_isman = [];
	{
		_isman pushback ((configName _x) typeOf "Man")
	} forEach _units;
	_soldiers = _soldiers + (count _units);
	// [[23000, 19000, 0], west, _group] call BIS_fnc_spawnGroup;
};
_isman

20210513
// works against Advanced Garbage collector ("spawned" number is not changing even when units die or get deleted)
// empty vehicles count as alive
// the number of groups is reduced when groups get deleted during battle.
_veh = AK_globalVar_1 select 0;
_units = AK_globalVar_1 select 1;
_groups = AK_globalVar_1 select 2;
systemChat ("number of units alive/dead/spawned: " + str ({
	alive _x
} count _units) + "/" + str ({
	!alive _x
} count _units) + "/" + str (count _units));
systemChat ("number of vehicles alive/dead/spawned: " + str ({
	alive _x
} count _veh) + "/" + str ({
	!alive _x
} count _veh) + "/" + str (count _veh));
systemChat ("number of groups: " + str (count _groups));

// clumsy
_arguments = [[12, "B_MBT_01_cannon_F", [14000, 18000, 0], [12000, 18000, 0], east, 85, "AWARE", 500, 3], [12, "B_MBT_01_cannon_F", [12000, 18000, 0], [14000, 18000, 0], independent, 85, "AWARE", 500, 4], 6, 2];

_arguments select 0 remoteExec ["AK_fnc_spacedvehicles", _arguments select 2];
_arguments select 1 remoteExec ["AK_fnc_spacedvehicles", _arguments select 3];

// 20210503
AK_fnc_spacedvehicles = {
	params [["_number", 1, [0]], ["_type", "B_MBT_01_cannon_F", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "AWARE", [""]], ["_breitegefstr", 500, [0]], ["_platoonsize", 1, [0]]];

	private ["_xPos", "_yPos", "_spawnedgroups"];

	_xPos = 0;
	_yPos = 0;
	_spawnedgroups = [];

	// spawn  
	for "_x" from 1 to _number do {
		_veh = createVehicle [_type, [(_spawnpos select 0) + _xPos, (_spawnpos select 1) + _yPos, 0], [], 0, "None"];
		_spawnedgroups pushBack createVehicleCrew _veh;
		_yPos = _yPos + _spacing;

		if (_yPos > _breitegefstr) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	};

	// group into platoons if requested  
	if (_platoonsize > 1) then {
		private _nbrplatoons = floor ((count _spawnedgroups) / _platoonsize);
		private _a = 0;
		private _b = (_platoonsize -1);
		for "_x" from 1 to _nbrplatoons do {
			private _joiners = _spawnedgroups select [_a, _b];
			{
				(units _x) join (_spawnedgroups select (_b + _a));
			} forEach _joiners;
			_spawnedgroups deleteRange [_a, _b];
			_a = _a +1;
		};
	};
	// assign waypoints  
	_xPos = 0;
	_yPos = 0;
	_spacing = _spacing * _platoonsize;
	{
		_x setBehaviour _behaviour;
		_x deleteGroupWhenEmpty true;
		_x addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
		_yPos = _yPos + _spacing;
		if (_yPos > _breitegefstr) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	} forEach _spawnedgroups;
	_spawnedgroups
};

// creates 45 tanks and saves their crews in a 1-dimensional array called AK_var_crews
private _a = 0;
AK_var_crews = [];
for "_x" from 1 to 45 do {
	_crews = (([[26872.5, 24555.5+_a, 0], 180, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle) select 1);
	{
		AK_var_crews pushBack _x
	} forEach _crews;
	_a = _a +10;
};

// saves the group of created vehicle as _myvariable
_myvariable = [[26872.5, 24595.5, 0], 180, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle select 2;

// saves the vehicle as _myvariable (can be used to delete the manned/empty/dead vehicle)
_myvariable = [[26872.5, 24595.5, 0], 180, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle select 0;

// adds the created vehicle to _myvariable
_myvariable =[];
_myvariable pushBack (([[26872.5, 24545.5, 0], 180, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle) select 0);

AK_fnc_spacedvehicles = {
	params [["_number", 1, [0]], ["_type", "", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "SAFE", [""]]];

	private ["_xPos", "_yPos", "_spawnedgroups"];

	_xPos = 0;
	_yPos = 0;
	_spawnedgroups = [];

	for "_x" from 1 to _number do
	{
		_yPos = _yPos + _spacing;
		_veh = createVehicle [_type, [(_spawnpos select 0) + _xPos, (_spawnpos select 1) + _yPos, 0], [], 0, "None"];
		_grp = createVehicleCrew _veh;
		_grp setBehaviour _behaviour;
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
		_spawnedgroups pushBack _grp;
		if (_yPos >= 550) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	};
	_spawnedgroups
};

// TODO only creates groups of 3
AK_fnc_spacedvehicles = {
	params [["_number", 1, [0]], ["_type", "B_MBT_01_cannon_F", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "AWARE", [""]], ["_breitegefstr", 500, [0]], ["_platoonsize", 1, [0]]];
	private ["_xPos", "_yPos", "_spawnedgroups"];

	_xPos = 0;
	_yPos = 0;
	_spawnedgroups = [];

	// spawn 
	for "_x" from 1 to _number do {
		_veh = createVehicle [_type, [(_spawnpos select 0) + _xPos, (_spawnpos select 1) + _yPos, 0], [], 0, "None"];
		_spawnedgroups pushBack createVehicleCrew _veh;
		_yPos = _yPos + _spacing;

		if (_yPos > _breitegefstr) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	};

	// group into platoons if requested 
	if (_platoonsize > 1) then {
		private _nbrplatoons = floor ((count _spawnedgroups) / _platoonsize);
		private _a = 1;
		for "_x" from 1 to _nbrplatoons do {
			private _index1 = (count _spawnedgroups) - _a;
			private _index2 = _index1 -1;
			private _index3 = _index1 -2;
			(units (_spawnedgroups select _index1) + units (_spawnedgroups select _index2)) join (_spawnedgroups select _index3);
			_spawnedgroups deleteAt _index1;
			_spawnedgroups deleteAt _index2;
			_a = _a +1;
		};
	};
	// assign waypoints 
	_xPos = 0;
	_yPos = 0;
	_spacing = _spacing * _platoonsize;
	{
		_x setBehaviour _behaviour;
		_x deleteGroupWhenEmpty true;
		_x addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
		_yPos = _yPos + _spacing;
		if (_yPos > _breitegefstr) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	} forEach _spawnedgroups;
	_spawnedgroups
};

// works but vehicles are not deleted
AK_fnc_delete = {
	params ["_groups"];
	{
		{
			deleteVehicle _x;
		} forEach (units _x);
		deleteGroup _x;
	} forEach _groups;
};

// works to delete vehicles
_vehlist = [];
{
	{
		_vehlist pushBackUnique vehicle _x;
	} forEach (units _x);
} forEach neuegruppen;
_vehlist

/* doesn't work
	while { alive player } do {
		private _vehicle = "B_MRAP_01_F" createVehicle [23500, 18400, 0];   
		createVehicleCrew _vehicle;  
		private _grp = group _vehicle;   
		private _wp = _grp addWaypoint [[23500, 18400, 0], 50];  
		_wp setWaypointStatements ["true", "{
			this deleteVehicleCrew _x
		} forEach crew this;  
	deleteVehicle this;"];
	} 
	private _time = random [10, 60, 120];
	sleep _time;
	};
	
	private _auto = "B_MRAP_01_F" createVehicle [8000, 10100, 0];   
	createVehicleCrew _auto;  
	private _grp = group _auto;   
	private _wp = _grp addWaypoint [[8000, 10100, 0], 50];  
	_wp setWaypointStatements ["true", "deleteVehicle _auto; {
		deleteVehicle _x
	} forEach (crew _auto);  
	deletegroup (group _auto)"];
	} 
	
	
	if (alive _plane) then {
		_group = group _plane;
		_crew = crew _plane;
		deleteVehicle _plane;
		{
			deleteVehicle _x
		} forEach _crew;
		deleteGroup _group;
	*/

	// does not work, because an empty vehicle is local to the server, and Waypoint Statments are executed on the clients
	[{
		private _position = [21100, 7500];
		private _vehicle = "O_APC_Wheeled_02_rcws_F" createVehicle _position;
		private _group = createVehicleCrew _vehicle;
		private _wp = _group addWaypoint [_position, 300];
		_wp setWaypointStatements ["true", "deleteVehicle this;
			{
				deleteVehicle _x
			} forEach (units (group this));
		"];
	}, [], 5] call CBA_fnc_waitAndExecute;