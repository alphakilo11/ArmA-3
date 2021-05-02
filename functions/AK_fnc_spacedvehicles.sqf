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
	5: _behaviour	- Group behaviour [optional] <STRING> (default: "AWARE")
	6: _breitegefstr- Width of the Area of responsibility <NUMBER> (default: 500 m)
	7: _platoonsize	- Number of vehicles forming one group <NUMBER> (default: 1)

Returns:
	ARRAY of spawned groups.

Example:
    (begin example)
		[14, "B_MBT_01_cannon_F", [23000,18000,0], [20000,18000,0], 85, "AWARE", 500, 4] call AK_fnc_spacedvehicles;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

//TODO align "formation" with destination and make the attackers keep formation (use "{_x addWaypoint [[15000,17500,0],500];} forEach _array;"?)
//TODO align vehicles with destination (use "[5000,5000,0] vectorAdd [5,4,0];"?)
//PROBLEM vehicles "loose" their waypoints when fighting on the way (solve with loop resetting the waypoints?)

AK_fnc_spacedvehicles = {  
params [["_number", 1, [0]], ["_type", "B_MBT_01_cannon_F", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "AWARE", [""]], ["_breitegefstr", 500, [0]], ["_platoonsize", 1, [0]]];  
  
private ["_xPos", "_yPos", "_spawnedgroups"];   
   
_xPos = 0;   
_yPos = 0;  
_spawnedgroups = [];   
  
//spawn  
for "_x" from 1 to _number do {   
    _veh = createVehicle [_type, [(_spawnpos select 0) + _xPos,(_spawnpos select 1) + _yPos, 0], [], 0, "None"];   
    _spawnedgroups pushBack createVehicleCrew _veh;  
    _yPos = _yPos + _spacing;   
   
 if (_yPos > _breitegefstr) then {   
        _yPos = 0;   
        _xPos = _xPos + _spacing;   
    };  
};  
  
//group into platoons if requested  
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
//assign waypoints  
_xPos = 0;   
_yPos = 0;  
_spacing = _spacing * _platoonsize;  
{  
 _x setBehaviour _behaviour;  
 _x deleteGroupWhenEmpty true;  
 _x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];  
    _yPos = _yPos + _spacing;  
 if (_yPos > _breitegefstr) then {   
        _yPos = 0;   
        _xPos = _xPos + _spacing;   
    };  
} forEach _spawnedgroups;  
_spawnedgroups  
};  
