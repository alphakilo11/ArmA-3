/* ---------------------------------------------------------------------------- 
Function: AK_fnc_battlelogger 
 
Description: 
    End and restart an automated battle and log events for later analysis. 
  
Parameters: 
    NIL
 
Returns: 
    ?
 
Example: 
    (begin example) 
    [] call AK_fnc_battlelogger
    (end) 
 
Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
 
// Also against Advanced Garbage collector ("spawned" number is not changing even when units die or get deleted) 
//TODO log round parameters (eg start position)
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
    diag_log ("AKBL:" + str ({alive _x} count _units) + ";" + str ({!alive _x} count _units) + ";" + str (count _units) + ";" + str ({alive _x} count _veh) + ";" + str ({!alive _x} count _veh) + ";" + str _emptyveh + ";" + str (count _veh) + ";" + str (count _groups)); //the number of groups is not updated
    //additional exit condition
    // if empty and dead vehicles account for at least half the total vehicles
    if ((({side _x == east} count (AK_battlingUnits select 0)) + ({side _x == independent} count (AK_battlingUnits select 0))) <= ((count _veh) / 2)) then {
        AK_var_fnc_battlelogger_stopBattle = true;
    };
}, 
 
    10, //delay in s 
 
    [], //parameters 
 
// start 
{
    //set variables ENHANCE find another way
    AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
    AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
    AK_var_fnc_battlelogger_stopBattle = false;
    _PosSide1 = [AK_var_fnc_automatedBattleEngine_location, (AK_var_fnc_automatedBattleEngine_location vectorAdd [1000, 0, 0])];
    _PosSide2 = [(AK_var_fnc_automatedBattleEngine_location vectorAdd [1000, 0, 0]), AK_var_fnc_automatedBattleEngine_location];

    diag_log format ["AKBL Battlelogger starting! %1 vs. %2", AK_var_fnc_battlelogger_typeEAST, AK_var_fnc_battlelogger_typeINDEP];
    //alternate locations
    if (random 1 >= 0.5) then { 
    _templocation = _PosSide1;
    _PosSide1 = _PosSide2; 
    _PosSide2 = _templocation; 
    };

    _spawnedgroups1 = [10, AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles; 
    _spawnedgroups2 = [10, AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, 85, "AWARE", 500, 1] call AK_fnc_spacedvehicles; 
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
    diag_log format ["AKBL Result: Survivors: %1;%2;%3;%4. Location : %5 %6 Battle over. Battlelogger shutting down", AK_var_fnc_battlelogger_typeEAST, ({side _x == east} count (AK_battlingUnits select 0)),  AK_var_fnc_battlelogger_typeINDEP, ({side _x == independent} count (AK_battlingUnits select 0)), worldName,  AK_var_fnc_automatedBattleEngine_location]; 
    {deleteVehicle _x} forEach (AK_battlingUnits select 0); 
    {deleteVehicle _x} forEach (AK_battlingUnits select 1); 
    {deleteGroup _x} forEach (AK_battlingUnits select 2); 
    AK_battlingUnits = nil;
 }, 
  
    {true}, //Run condition 
 
    //exit Condition 
    {(({alive _x} count (AK_battlingUnits select 1)) <= (count (AK_battlingUnits select 1)/2)) or _timer >= 60 or AK_var_fnc_battlelogger_stopBattle == true}, 
 
    "_timer" //List of local variables that are serialized between executions.  (optional) <CODE>
] call CBA_fnc_createPerFrameHandlerObject; 
};
