/* Has to run on the same machine as the battle - unless I make AK_battlingUnits global...
Requires: AK_fnc_battlelogger, AK_fnc_spacedvehicles
TODO stop AK_fnc_battlelogger when shutting down ABE (use prototype) ("(_AKBL getVariable "handle") call CBA_fnc_deletePerFrameHandlerObject;" didn't work) Likely reason: it was initialized inside an if statement
*/
AK_fnc_automatedBattleEngine = {

AK_ABE = [
{
private ["_var"];

_var = missionNamespace getVariable "AK_battlingUnits"; 
if (isNil "_var") then { 
	_AKBL = [] spawn AK_fnc_battlelogger;
	_round = _round + 1; 
	diag_log format ["AKBL round %1", _round];
};
},
	
60,
	
["some_params", [1,2,3]],

{diag_log format ["AKBL Battle Engine starting! %1", _this getVariable "params"];
_round = 0;},

{
 diag_log format ["AKBL stopping Battle Engine! params: %1",   _this getVariable "params"];
 },

{true},

{false},

["_round"]
] call CBA_fnc_createPerFrameHandlerObject;
};/* ---------------------------------------------------------------------------- 
Function: AK_fnc_battlelogger 
 
Description: 
    End and restart an automated battle and log events for later analysis. 
  
Parameters: 
    0: _number  - Number of Vehicles <NUMBER> (default: 1) 
    1: _type  - Type of Vehicle <STRING> 
 2: _spawnpos - Spawn Position <ARRAY> 
 3: _destpos  - Destination <ARRAY> 
    _side  - <SIDE> 
 4: _spacing  - Spacing <NUMBER> (default: 50 m) 
 5: _behaviour - Group behaviour [optional] <STRING> (default: "AWARE") 
 6: _breitegefstr- Width of the Area of responsibility <NUMBER> (default: 500 m) 
 7: _platoonsize - Number of vehicles forming one group <NUMBER> (default: 1) 
 
Returns: 
 [spawned crews, spawned vehicles, _spawnedgroups] 
 
Example: 
    (begin example) 
   
    (end) 
 
Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
 
// Also against Advanced Garbage collector ("spawned" number is not changing even when units die or get deleted) 
//TODO log round parameters (start position, type etc.)
//TODO consolidate data 
//TODO add params 
//TODO get sides automatically (use pushBackUnique) 
// make all local variables private 
//MINOR ISSUE the code works via Advanced Developer Tools console, but not via ZEN (Execute code) (likely reason: comments) 
//MINOR ISSUE pretty complicated to get the number of empty vehicles (use "systemChat str (gunner (_this select 1));" instead?) 
 
AK_fnc_battlelogger = { 
[{ 
//function 
_veh = AK_battlingUnits select 0; 
_units = AK_battlingUnits select 1; 
_groups = AK_battlingUnits select 2; 
//determine empty vehicles 
_alivevehicles = []; 
{if (alive _x) then {_alivevehicles pushBack _x}} forEach _veh;  
_alivevehcrews = []; 
{_alivevehcrews pushBack crew _x} forEach _alivevehicles; 
_number_alive_crews = []; 
{_number_alive_crews pushBack (count _x)} forEach _alivevehcrews; 
_emptyveh = {_x == 0} count _number_alive_crews; 
_timer = _timer +1; 
//data format:  units alive;dead;all vehicles alive;dead;empty;all groups all 
diag_log ("AKBL:" + str ({alive _x} count _units) + ";" + str ({!alive _x} count _units) + ";" + str (count _units) + ";" + str ({alive _x} count _veh) + ";" + str ({!alive _x} count _veh) + ";" + str _emptyveh + ";" + str (count _veh) + ";" + str (count _groups)); 
}, //the number of groups is not updated 
 
10, //delay in s 
 
[], //parameters 
 
// start 
{diag_log "AKBL Battlelogger starting!"; 
_PosSide1 = [];
_PosSide2 = [];
if (random 1 >= 0.5) then { 
 _PosSide1 = [[14000, 17500 ,0], [12000, 17500, 0]]; 
 _PosSide2 = [[12000, 17510 ,0], [14000, 17510, 0]]; 
} else { 
 _PosSide1 = [[12000, 17510 ,0], [14000, 17510, 0]]; 
 _PosSide2 = [[14000, 17500 ,0], [12000, 17500, 0]]; 
 
}; 
_spawnedgroups1 = [10, "B_MBT_01_cannon_F", (_PosSide1 select 0), (_PosSide1 select 1), east, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles; 
_spawnedgroups2 = [10, "B_MBT_01_cannon_F", (_PosSide2 select 0), (_PosSide2 select 1), independent, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles; 
AK_battlingUnits = []; //initialize the global variable 
_timer = 0; 
{ 
AK_battlingUnits pushBack ((_spawnedgroups1 select _x) + (_spawnedgroups2 select _x));} forEach [0,1,2]; 
{ 
 _wp = _x addWaypoint [[0,0,0], 0]; 
 _wp setWaypointType "CYCLE";} forEach (AK_battlingUnits select 2); 
}, 
 
//end 
{ 
//data format: vehicles remaining: East;West;Guer 
 diag_log format ["AKBL Result: %1;%2;%3. Battle over. Battlelogger shutting down", ({side _x == east} count (AK_battlingUnits select 0)), ({side _x == west} count (AK_battlingUnits select 0)), ({side _x == independent} count (AK_battlingUnits select 0)) ]; 
 {deleteVehicle _x} forEach (AK_battlingUnits select 0); 
 {deleteVehicle _x} forEach (AK_battlingUnits select 1); 
 {deleteGroup _x} forEach (AK_battlingUnits select 2); 
 AK_battlingUnits = nil;}, 
  
{true}, //Run condition 
 
//exit Condition 
{(({alive _x} count (AK_battlingUnits select 1)) <= (count (AK_battlingUnits select 1)/2)) or _timer >= 60}, 
 
"_timer" 
] call CBA_fnc_createPerFrameHandlerObject; 
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_cleangrouplist

Description:
    Cleans deleted groups from an array of groups. The input array will be altered.
	
Parameters:
    0: _groups	- Array of groups to cleanup <ARRAY>

Returns:
	An array of existing groups.

Example:
    (begin example)
		[getPos player] call AK_fnc_delete;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_cleangrouplist = {
params ["_groups"];
_deletedindex = [];
{if (isNull _x) then {_deletedindex pushBack _forEachIndex}} forEach _groups;
_deletedindex sort false;
{_groups deleteAt _x} forEach _deletedindex;
_groups;
};/* ----------------------------------------------------------------------------
Function: AK_fnc_flare

Description:
    Pops a small flare 150m overhead the given position.
	
Parameters:
    0: _position	- Position of flare <ARRAY>

Returns:
	NIL

Example:
    (begin example)
		[getPos player] call AK_fnc_flare;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_flare = {
params ["_position"];
_shell = "F_40mm_White" createVehicle (_position Vectoradd [0,0,150]);    
_shell setVelocity [0, 0, -1];
};
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
	   _side		- <SIDE>
	4: _spacing		- Spacing <NUMBER> (default: 50 m)
	5: _behaviour	- Group behaviour [optional] <STRING> (default: "AWARE")
	6: _breitegefstr- Width of the Area of responsibility <NUMBER> (default: 500 m)
	7: _platoonsize	- Number of vehicles forming one group <NUMBER> (default: 1)

Returns:
	[spawned crews, spawned vehicles, _spawnedgroups]

Example:
    (begin example)
		[4, "B_MBT_01_cannon_F", [23000, 18000 ,0], [22000, 18000, 0], west, 85, "SAFE", 500, 1] spawn AK_fnc_spacedvehicles;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
//TODO align "formation" with destination and make the attackers keep formation (use "{_x addWaypoint [[15000,17500,0],500];} forEach _array;"?)
//TODO avoid vehicles blowing up on spawn
AK_fnc_spacedvehicles = {  
params [["_number", 1, [0]], ["_type", "B_MBT_01_cannon_F", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_side", west], ["_spacing", 50, [0]], ["_behaviour", "AWARE", [""]], ["_breitegefstr", 500, [0]], ["_platoonsize", 1, [0]]];  
  
private ["_xPos", "_yPos", "_spawnedvehicles", "_spawnedunits", "_spawnedgroups"];   
   
_xPos = 0;   
_yPos = 0;
_spawnedunits = [];
_spawnedvehicles = [];  
_spawnedgroups = [];
  
//spawn  
for "_i" from 1 to _number do {
	_spawned = ([(_spawnpos vectorAdd [_xPos, _yPos, 0]), (_spawnpos getDir _destpos), _type, _side] call BIS_fnc_spawnVehicle);
	_spawnedvehicles pushBack (_spawned select 0);
	{_spawnedunits pushBack _x} forEach (_spawned select 1); 
	_spawnedgroups pushBack (_spawned select 2); 
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
	_x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];  
    _yPos = _yPos + _spacing;  
	if (_yPos > _breitegefstr) then {   
        _yPos = 0;   
        _xPos = _xPos + _spacing;   
    };
} forEach _spawnedgroups;  
[_spawnedvehicles, _spawnedunits, _spawnedgroups];
};  
