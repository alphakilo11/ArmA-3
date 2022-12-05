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
	
["some_params", [1,2,3]], //Artefakt

{diag_log format ["AKBL Battle Engine starting! %1", _this getVariable "params"];
_round = 0;},

{
 diag_log format ["AKBL stopping Battle Engine! params: %1",   _this getVariable "params"];
 },

{true},

{false},

["_round"]
] call CBA_fnc_createPerFrameHandlerObject;
};
/* ---------------------------------------------------------------------------- 
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
   no example?
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
Function: AK_fnc_cfgFactionTable

Description:
    Creates a table of factions.
	Use to provide input to AK_fnc_cfgGroupTable.
	
Parameters:
    0: _side		- 0 = OPFOR, 1 = BLUFOR, 2 = Independent <NUMBER>
	1: _configName	- false = full config entry, true = configName <BOOLEAN> (default: true)

Returns:
	<ARRAY>

Example:
    (begin example)
		[2] call AK_fnc_cfgFactionTable;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgFactionTable = {
params ["_side", ["_configName", 1]];
switch (_configName) do {
	case 1: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses") apply {configName _x};};
	case 0: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses");};
};
};

/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgGroupTable

Description:
    Creates a table of all groups from a given faction. Some factions have no defined groups.
	
Parameters:
    0: _cfgfaction	- Faction <STRING> (default: "BLU_F")

Returns:
	<ARRAY>

Example:
    (begin example)
		["BLU_F"] call AK_fnc_cfgGroupTable; 
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgGroupTable = {
params [["_cfgfaction","BLU_F", []]];
private ["_cfgSide", "_newCfgEntry", "_arm", "_groups"];

//get side of _cfgfaction
_cfgSide = getNumber (configFile >> "CfgFactionClasses" >> _cfgfaction >> "side"); 
_newCfgEntry = ("getNumber (_x >> 'side') == _cfgSide" configClasses (configFile >> "CfgGroups") apply {configName _x}) select 0; 
_newCfgEntry = configFile >> "CfgGroups" >> _newCfgEntry;
//iterate through arms and get all groups that have matching sides
_arm = "true" configClasses (_newCfgEntry >> _cfgfaction) apply {configName _x}; 
_groups = []; 
{_groups pushBack ("getNumber (_x >> 'side') == _cfgSide" configClasses (_newCfgEntry >> _cfgfaction >> _x));} forEach _arm; 
flatten _groups; 
};/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgUnitTable

Description:
    Creates a table of units. Use with createUnit.
	
Parameters:
    0: _cfgfaction	- Faction <STRING> (default: "BLU_F")
    1: _cfgkind		- Kind of Vehicle <STRING> (default: "CAManBase")

Returns:
	<ARRAY>

Example:
    (begin example)
		["rhsgref_faction_chdkz", "CAManBase"] call AK_fnc_cfgUnitTable;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgUnitTable = {
params [["_cfgfaction", "BLU_F", []], ["_cfgkind", "CAManBase", []]];
private _unittable = "getText (_x >> 'faction') == _cfgfaction and configName _x isKindOf _cfgkind and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles") apply {configName _x};
_unittable
};/* ----------------------------------------------------------------------------
Function: AK_fnc_cleangrouplist

Description:
    Cleans deleted groups from an array of groups. The input array will be altered.
	
Parameters:
    0: _groups	- Array of groups to cleanup <ARRAY>

Returns:
	An array of existing groups.

Example:
    (begin example)
		[list_of_groups] call AK_fnc_delete;
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
};
/*
The Achilles Execute Code Module doesn't like double-slashes, therefore I have to put all comments in here and the code has to be copy-pasted without this block.

Inspired by the toilet paper shortage in Austria in 2020 this scenario has the players defending a toilet paper factory
This will create a huge building and 2 + _numberofprivates hostiles approaching it.
The hostiles will spawn within a radius of _radius.
_pos is the ground zero of the whole scenario and is defined as the players position.

Klopapier-Lager bewachen
    "Land_Factory_Main_F" größer und cooler weil man raufklettern kann
    "Land_dp_smallFactory_F"
Raum mit Leuten die nix tun (Stab)

Add 1 Group of defenders (for flair) (Police with waypoint dismissed)
Add task
Add triggerable waves
Add Blackout at Missionstart
Add Arsenal/Equipment
Change hostiles
Add random clothes and gear to hostiles


*/
AK_fnc_defendToiletPaperFactory = {
private _pos = getPosATL player;
private _objective = createVehicle ["Land_Factory_Main_F", _pos, [], 100, 'NONE'];
private _markerstr = createMarker ["military1",(getPos _objective)];
_markerstr setMarkerShape "ICON";
_markerstr setMarkerType "n_support";
_markerstr setMarkerText "Klopapierlager";
private _numberofprivates = 10;
private _radius = 2000;
private _typeofunit = ["LOP_BH_Infantry_model_OFI_TRI","LOP_BH_Infantry_model_OFI_M81",'LOP_BH_Infantry_model_OFI_LIZ',"LOP_BH_Infantry_model_OFI_FWDL","LOP_BH_Infantry_model_OFI_ACU","LOP_BH_Infantry_model_M81_TRI","LOP_BH_Infantry_model_M81_LIZ","LOP_BH_Infantry_model_M81_FWDL","LOP_BH_Infantry_model_M81_CHOCO","LOP_BH_Infantry_model_M81_ACU","LOP_BH_Infantry_model_M81","LOP_BH_Infantry_AR","LOP_BH_Infantry_AR_2","LOP_BH_Infantry_AR_Asst","LOP_BH_Infantry_AR_Asst_2","LOP_BH_Infantry_AT","LOP_BH_Infantry_base","LOP_BH_Infantry_Corpsman","LOP_BH_Infantry_Driver","LOP_BH_Infantry_GL","LOP_BH_Infantry_IED","LOP_BH_Infantry_Marksman"];
 private _newGroup = createGroup east;
 _newUnit = _newGroup createUnit ["LOP_BH_Infantry_SL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'SERGEANT';
 _newUnit setFormDir 210.828;
 _newUnit setDir 210.828;
_newUnit = _newGroup createUnit ["LOP_BH_Infantry_TL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'CORPORAL';
 _newUnit setFormDir 180.016;
 _newUnit setDir 180.016;
 private _a =0;
 while {_a = _a + 1; _a < (_numberofprivates + 1)} do {
_newUnit = _newGroup createUnit [(selectRandom _typeofunit), _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'PRIVATE';
 _a + 1;
 };
_newGroup setFormation 'STAG COLUMN';
 _newGroup setCombatMode 'RED';
 _newGroup setBehaviour 'AWARE';
 _newGroup setSpeedMode 'FULL';
_newWaypoint = _newGroup addWaypoint [_pos, 0];
 _newWaypoint setWaypointType "SAD";
 };
/* ----------------------------------------------------------------------------
Function: AK_fnc_endlessconvoy

Description:
    Create a vehicle moving from A to B. Upon reaching B it is deleted

Parameters:
    - Type of Vehicle (Config Entry)
    - Starting Position (XYZ)
- End Location (XYZ)

Optional:
- Speed Limit (km/h)

Example:
    (begin example)
    ["B_Truck_01_box_F", [23500,18400,0], [23000,17000,0]] call AK_fnc_endlessconvoy
    (end)

Returns:
    Nil

Author:
    AK

---------------------------------------------------------------------------- */

//1.initiate function
AK_fnc_endlessconvoy = {
params ["_verhicletype", "_startloc", "_endloc", ["_speedlimit", -1]];
private _vehicle = _verhicletype createVehicle _startloc;
_vehicle setDir (_startloc getDir _endloc);
createVehicleCrew _vehicle;
_vehicle limitSpeed _speedlimit;
private _grp = group _vehicle;
_grp setBehaviour "SAFE";
private _wp = _grp addWaypoint [_endloc, 50];  
_wp setWaypointStatements ["true", "_vehicleleader = vehicle leader this; {deleteVehicle _x} forEach crew _vehicleleader + [_vehicleleader]; deleteGroup (group this);"] ;
};

//2. loop function
Testversuch = [] spawn {
for "_x" from 0 to 1 step 0 do {
["B_Truck_01_box_F", [23500,18400,0], [23000,17000,0]] call AK_fnc_endlessconvoy;
sleep 15;
};
};

//3. stop function
terminate Testversuch;


//Multiplayer Code (works on Dedicated Server)
[[],{ AK_fnc_endlessconvoy = {
params ["_verhicletype", "_startloc", "_endloc", ["_speedlimit", -1]];
private _vehicle = _verhicletype createVehicle _startloc;
_vehicle setDir (_startloc getDir _endloc);
createVehicleCrew _vehicle;
_vehicle limitSpeed _speedlimit;
private _grp = group _vehicle;
_grp setBehaviour "SAFE";
private _wp = _grp addWaypoint [_endloc, 50];  
_wp setWaypointStatements ["true", "_vehicleleader = vehicle leader this; {deleteVehicle _x} forEach crew _vehicleleader + [_vehicleleader]; deleteGroup (group this);"] ;
};
 
}  ]
remoteExec ["spawn", 2];

[[],{Testversuch = [] spawn {
for "_x" from 0 to 1 step 0 do {
["B_Truck_01_box_F", [23500,18400,0], [23000,17000,0]] call AK_fnc_endlessconvoy;
sleep 15;
};
};}] remoteExec ["call", 2];

[[],{terminate Testversuch;}] remoteExec ["call", 2];
/* ----------------------------------------------------------------------------
Function: AK_fnc_findString

Description:
    Searches an array of strings for a certain string and returns an array containing all hits.
	
Parameters:
    0: _string	- string to search for <STRING> 
    1: _array	- array to search in <ARRAY>

Returns:
	<ARRAY>

Example:
    (begin example)
		["LIB_", ["LIB_P38","LIB_P08","LIB_M1896","WaltherPPK"]] call AK_fnc_findString;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_findString = {
params ["_string", "_array"];
private _hitArray = [];
{ 
if ([_string, _x] call BIS_fnc_inString) then {
_hitArray pushBack _x;}
} forEach _array;
_hitArray
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
Function: AK_fnc_moveRandomPlatoons

Description:
    Spawns random platoons and lets them move toward an objective. When vehicles are spawned a _pltstrength = 40 platoon might end up with up to 20 vehicles.
	
Parameters:
    0: _cfgSide		- 0 = OPFOR, 1 = BLUFOR, 2 = Independent Config's Side <NUMBER> (default: 1)
	1: _side		- Affiliation of the spawned units. <SIDE> (default: west)
	2: _AZ			- Objective <ARRAY> (default: [500,500,0])
	3: _pltstrength	- Minimum Number of Units per platoon (max. depends on group strength) <NUMBER> (default: 40)
	4: _maxveh		- Maximum number of vehicles per group. <NUMBER> (default: 0)

Returns:
	<ARRAY>

Example:
    (begin example)
		[1, west, [21380, 16390, 0], 40, 0] call AK_fnc_moveRandomPlatoons; 
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
//TODO repair spawn BUG
AK_fnc_moveRandomPlatoons = {
params [
	["_cfgSide", 1, [0]],
	["_side", west, [west]],
	["_AZ", [500,500,0], [[]]],
	["_pltstrength", 40, [0]],
	["_maxveh", 0, [0]]
];

private ["_cfgFaction", "_numberOfUnits", "_timeout", "_spawnedgroups", "_vfgrm", "_facing"];

_cfgFaction = str text (selectRandom ([_cfgSide, 1] call AK_fnc_cfgFactionTable));
_numberOfUnits = 0;
_timeout = 0;
_spawnedgroups = [];
_vfgrm = _AZ vectorAdd [random [-1500, 0, 1500],random [-1500, 0, 1500],0];
_facing = _vfgrm getDir _AZ;

while {_numberOfUnits < _pltstrength && _timeout < (_pltstrength +1)} do {
	_cfggroup = selectRandom ([_cfgFaction] call AK_fnc_cfgGroupTable);
	_grp = [_vfgrm, _side, _cfggroup, [], [], [], [], [], _facing, false, _maxveh] call BIS_fnc_spawnGroup;
	_spawnedgroups pushBack _grp;
	_numberOfUnits = _numberOfUnits + count (units _grp);
	_grp deleteGroupWhenEmpty true;
	_grp addWaypoint [_AZ, 100];
	_timeout = _timeout + 1;
};
if (_timeout >= (_pltstrength + 1)) then {
	/*_this call AK_fnc_moveRandomPlatoons;*/
	diag_log "Spawning failed.";
};
_spawnedgroups
};/* ----------------------------------------------------------------------------
Function: AK_fnc_spacedvehicles

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    0: _number		- Number of Vehicles <NUMBER> (default: 1)
    1: _type		- Type of Vehicle <STRING>
	2: _spawnpos	- Spawn Position <ARRAY>
	3: _destpos		- Destination. [] to stay at position. <ARRAY>
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
["_type", "B_MBT_01_cannon_F", [""]],
["_spawnpos", [], [[]]],
["_destpos", [], [[]]],
["_side", west],
["_spacing", 50, [0]],
["_behaviour", "AWARE", [""]],
["_breitegefstr", 500, [0]],
["_platoonsize", 1, [0]]
];  
  
private ["_xPos", "_yPos", "_spawnedvehicles", "_spawnedunits", "_spawnedgroups"];   
   
_xPos = 0;   
_yPos = 0;
_spawnedunits = [];
_spawnedvehicles = [];  
_spawnedgroups = [];
  
//spawn  
for "_i" from 1 to _number do {
	_spawned = ([(_spawnpos vectorAdd [_xPos, _yPos, 0]), (_spawnpos getDir _destpos/* This fails when the _destpos is no coordinate*/), _type, _side] call BIS_fnc_spawnVehicle);
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
	if !(count _destpos == 0) then {
		_x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];  
		_yPos = _yPos + _spacing;  
		if (_yPos > _breitegefstr) then {   
			_yPos = 0;   
			_xPos = _xPos + _spacing;   
		};
	};
} forEach _spawnedgroups;  
[_spawnedvehicles, _spawnedunits, _spawnedgroups];
};  
//creates a number of groups at _AZ which will defend an area (size of which is based on taktik Handakt OPFOR values) .
//Works local and on DS
//REQUIRED: CBA
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