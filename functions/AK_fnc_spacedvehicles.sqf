/* ----------------------------------------------------------------------------
Function: AK_fnc_spacedvehicles

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    0: _number		- Number of Vehicles <NUMBER> (default: 1)
    1: _type		- Type of Vehicle <STRING/ARRAY> (providing an array will override _number)
	2: _spawnpos	- Spawn Position <ARRAY>
	3: _destpos		- Destination. [] to stay at position. <ARRAY>
	4:   _side		- <SIDE>
	5: _spacing		- Spacing <NUMBER> (default: 50 m)
	6: _behaviour	- Group behaviour [optional] <STRING> (default: "AWARE")
	7: _breitegefstr- Width of the Area of responsibility <NUMBER> (default: 500 m)
	8: _platoonsize	- Number of vehicles forming one group <NUMBER> (default: 1)

Returns:
	[spawned crews, spawned vehicles, _spawnedgroups]

Example:
    (begin example)
		[4, "B_MBT_01_cannon_F", [23000, 18000 ,0], [22000, 18000, 0], west, 85, "SAFE", 500, 1] spawn AK_fnc_spacedvehicles;
    (end)
	
	(begin advanced example)

	//spawn units
	neuegruppen = [14, "B_MBT_01_cannon_F", [23000,18000,0], [15000,17000,0], 50, "COMBAT"] call AK_fnc_spacedvehicles;
	neuegruppen;

	//add additional Waypoint
	{_x addWaypoint [[10000,10000,0],500]} forEach neuegruppen;

	//delete
	[neuegruppen] call LM_fnc_delete;
	(end)

Author:
    AK

---------------------------------------------------------------------------- */
//TODO align "formation" with destination and make the attackers keep formation (use "{_x addWaypoint [[15000,17500,0],500];} forEach _array;"?)
//TODO avoid vehicles blowing up on spawn
//TODO add an option to return netID?

AK_fnc_spacedvehicles = {  
params [
["_number", 1, [0]],
["_type", "B_MBT_01_cannon_F"],
["_spawnpos", [], [[]]],
["_destpos", [], [[]]],
["_side", west],
["_spacing", 50, [0]],
["_behaviour", "AWARE", [""]],
["_breitegefstr", 500, [0]],
["_platoonsize", 1, [0]]
];  
  
private ["_xPos", "_yPos", "_spawnedvehicles", "_spawnedunits", "_spawnedgroups", "_typeList"];   
   
_xPos = 0;   
_yPos = 0;
_spawnedunits = [];
_spawnedvehicles = [];  
_spawnedgroups = [];

// check for an array of types
if (_type isEqualType []) then {
	_typeList = _type;
} else {
	_typeList = [];
	for "_i" from 1 to _number do {
		_typeList pushBack _type;
	}
};


//spawn  
{
	_spawned = ([(_spawnpos vectorAdd [_xPos, _yPos, 0]), (_spawnpos getDir _destpos/* This fails when the _destpos is no coordinate*/), _x, _side] call BIS_fnc_spawnVehicle);
	_spawnedvehicles pushBack (_spawned select 0);
	{_spawnedunits pushBack _x} forEach (_spawned select 1); 
	_spawnedgroups pushBack (_spawned select 2); 
    _yPos = _yPos + _spacing;   
   
	if (_yPos > _breitegefstr) then {   
        _yPos = 0;   
        _xPos = _xPos + _spacing;   
    };  
} forEach _typeList;  
  
//group into platoons if requested  
if (_platoonsize > 1) then {   
	private _nbrplatoons = floor ((count _spawnedgroups) / _platoonsize);  
	private _a = 0;
	private _b = (_platoonsize -1);
	for "_x" from 1 to _nbrplatoons do {  
		private _joiners = _spawnedgroups select [_a, _b];
			{(units _x) join (_spawnedgroups select (_b + _a));
		} forEach _joiners;
		_spawnedgroups deleteRange [_a, _b];
		_a = _a +1;
		};  
	};  
//assign waypoints etc  
_xPos = 0;   
_yPos = 0;  
_spacing = _spacing * _platoonsize;  
{
	_x setBehaviour _behaviour;  
	_x deleteGroupWhenEmpty true;
	if !(count _destpos == 0) then {
		_x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];
		_x addWaypoint [getPos leader _x,10];
		_waypoint = _x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];
		_waypoint setWaypointType "CYCLE";  
		_yPos = _yPos + _spacing;  
		if (_yPos > _breitegefstr) then {   
			_yPos = 0;   
			_xPos = _xPos + _spacing;   
		};
	};
} forEach _spawnedgroups;  
[_spawnedvehicles, _spawnedunits, _spawnedgroups];
};  
