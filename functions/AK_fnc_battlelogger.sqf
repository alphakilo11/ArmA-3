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
