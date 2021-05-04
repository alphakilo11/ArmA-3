/* ----------------------------------------------------------------------------
Function: AK_fnc_battlelogger

Description:
    End and restart an automated battle and log events for later analysis.
	
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
		
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

//works on client, DS and HC. Also against Advanced Garbage collector ("spawned" number is not changing even when units die or get deleted)
//BUG logger only tracks one side (use flatten?)
//TODO replace AK_globalVar_1
//TODO Restart battle
//TODO remove systemChat
//TODO add diag_log (always to server?)
//MINOR ISSUE pretty complicated to get the number of empty vehicles

AK_fnc_battlelogger = {
[{
_veh = AK_globalVar_1 select 0;
_units = AK_globalVar_1 select 1;
_groups = AK_globalVar_1 select 2;
//determine empty vehicles
_alivevehicles = [];
{if (alive _x) then {_alivevehicles pushBack _x}} forEach _veh; 
_alivevehcrews = [];
{_alivevehcrews pushBack crew _x} forEach _alivevehicles;
_number_alive_crews = [];
{_number_alive_crews pushBack (count _x)} forEach _alivevehcrews;
_emptyveh = {_x == 0} count _number_alive_crews;

systemChat ("units alive/dead/all: " + str ({alive _x} count _units) + "/" + str ({!alive _x} count _units) + "/" + str (count _units));
systemChat ("vehicles alive/dead/empty/all: " + str ({alive _x} count _veh) + "/" + str ({!alive _x} count _veh) + "/" + str _emptyveh + "/" + str (count _veh));
systemChat ("groups all: " + str (count _groups));},
10,
[],
{systemChat "Battlelogger starting!";
AK_globalVar_1 = [3, "B_MBT_01_cannon_F", [14000, 18000 ,0], [12000, 18000, 0], east, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles;
AK_globalVar_1 = AK_globalVar_1 + ([3, "B_MBT_01_cannon_F", [12000, 18000 ,0], [14000, 18000, 0], independent, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles);
},
{
	systemChat "Battle over. Battlelogger shutting down";
	{deleteVehicle _x} forEach (AK_globalVar_1 select 0);
	{deleteVehicle _x} forEach (AK_globalVar_1 select 1);
	{deleteGroup _x} forEach (AK_globalVar_1 select 2);
	AK_globalVar_1 = nil;},
{true},
{({alive _x} count (AK_globalVar_1 select 1)) <= (count (AK_globalVar_1 select 1)/2)}
] call CBA_fnc_createPerFrameHandlerObject;
}
