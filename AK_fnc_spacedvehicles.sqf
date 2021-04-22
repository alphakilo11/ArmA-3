/* ----------------------------------------------------------------------------
Function: AK_fnc_spacedvehicles

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    0: _number		- Number of Vehicles <NUMBER> (default: 1)
    1: _type		- Type of Vehicle <STRING>
	2: _spawnpos	- Spawn Position <ARRAY>
	3: _destpos		- Destination <ARRAY>	
	4: _spacing		- Spacing <NUMBER> (default: 50 m)
	5: _behaviour	- Group behaviour [optional] <STRING> (default: "SAFE") 

Returns:
	ARRAY of spawned groups.

Example:
    (begin example)
		[14, "B_MBT_01_cannon_F", [23000,18000,0], [15000,17000,0], 50, "COMBAT"] call AK_fnc_spacedvehicles;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

//TODO align "formation" with destination and make the attackers keep formation (use "{_x addWaypoint [[15000,17500,0],500];} forEach _array;"?)
//TODO align vehicles with destination (use "[5000,5000,0] vectorAdd [5,4,0];"?)
//PROBLEM vehicles "loose" their waypoints when fighting on the way (solve with loop resetting the waypoints?)

AK_fnc_spacedvehicles = {
params [["_number", 1, [0]], ["_type", "", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "SAFE", [""]]];

private ["_xPos", "_yPos", "_spawnedgroups"]; 
 
_xPos = 0; 
_yPos = 0;
_spawnedgroups = []; 

for "_x" from 1 to _number do
{ 
    _yPos = _yPos + _spacing; 
    _veh = createVehicle [_type, [(_spawnpos select 0) + _xPos,(_spawnpos select 1) + _yPos, 0], [], 0, "None"]; 
    _grp = createVehicleCrew _veh;
	_grp setBehaviour _behaviour;
	_grp deleteGroupWhenEmpty true;
	_grp addWaypoint [_destpos,(_number*15)];
	_spawnedgroups pushBack _grp;
if (_yPos >= 550) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    };
};
_spawnedgroups
};