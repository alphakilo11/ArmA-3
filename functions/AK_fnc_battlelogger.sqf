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

Caveats:
    the code works via Advanced Developer Tools console, but not via ZEN (Execute code) (likely reason: comments)

Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
AK_fnc_battlelogger = {
    AK_var_fnc_battlelogger_Version = '1.01';
    AK_var_fnc_battlelogger_numberOfStartingVehicles = 10; // how many vehicles are spawned on each side
    AK_var_fnc_battlelogger_engagementDistance = [1000, 0, 0]; // how is the away teams spawn location displaced from AK_var_fnc_automatedBattleEngine_location
    AK_var_fnc_battlelogger_vehSpacing = 85;
    AK_var_fnc_battlelogger_breiteGefStr = 500;
    AK_var_fnc_battlelogger_platoonSize = 1;
    AK_var_fnc_battlelogger_loggerInterval = 10; // s
    AK_var_fnc_battlelogger_timeout = 600; // s
    [
        { 
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
            diag_log ("AKBL " + AK_var_fnc_battlelogger_Version + ":" + str ({alive _x} count _units) + ";" + str ({!alive _x} count _units) + ";" + str (count _units) + ";" + str ({alive _x} count _veh) + ";" + str ({!alive _x} count _veh) + ";" + str _emptyveh + ";" + str (count _veh) + ";" + str (count _groups)); //the number of groups is not updated
            //additional exit condition
            // if empty and dead vehicles account for at least half the total vehicles
            if ((({side _x == east} count (AK_battlingUnits select 0)) + ({side _x == independent} count (AK_battlingUnits select 0))) <= ((count _veh) / 2)) then {
                AK_var_fnc_battlelogger_stopBattle = true;
            };
        }, 
        
        AK_var_fnc_battlelogger_loggerInterval, //delay in s 
        
        [], //parameters 
        
        // start 
        {
            //set variables ENHANCE find another way
            AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            AK_var_fnc_battlelogger_stopBattle = false;
            _PosSide1 = [AK_var_fnc_automatedBattleEngine_location, (AK_var_fnc_automatedBattleEngine_location vectorAdd AK_var_fnc_battlelogger_engagementDistance)];
            _PosSide2 = [(AK_var_fnc_automatedBattleEngine_location vectorAdd AK_var_fnc_battlelogger_engagementDistance), AK_var_fnc_automatedBattleEngine_location];

            diag_log format ["AKBL %1 Battlelogger starting! %2 vs. %3;%4", AK_var_fnc_battlelogger_Version, AK_var_fnc_battlelogger_typeEAST, AK_var_fnc_battlelogger_typeINDEP, systemTime];
            //alternate locations
            if (random 1 >= 0.5) then { 
            _templocation = _PosSide1;
            _PosSide1 = _PosSide2; 
            _PosSide2 = _templocation; 
            };

            _spawnedgroups1 = [AK_var_fnc_battlelogger_numberOfStartingVehicles, AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, AK_var_fnc_battlelogger_vehSpacing, "AWARE", AK_var_fnc_battlelogger_breiteGefStr, AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            _spawnedgroups2 = [AK_var_fnc_battlelogger_numberOfStartingVehicles, AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, AK_var_fnc_battlelogger_vehSpacing, "AWARE", AK_var_fnc_battlelogger_breiteGefStr, AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
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
            east_veh_survivors = ({side _x == east} count (AK_battlingUnits select 0));
            indep_veh_survivors = ({side _x == independent} count (AK_battlingUnits select 0));
            _summary = [
                "AKBL Result: ",
                AK_var_fnc_battlelogger_Version,
                AK_var_fnc_battlelogger_typeEAST,
                east_veh_survivors,
                AK_var_fnc_battlelogger_typeINDEP,
                indep_veh_survivors,
                AK_var_fnc_battlelogger_numberOfStartingVehicles,
                worldName,
                AK_var_fnc_automatedBattleEngine_location,
                AK_var_fnc_battlelogger_engagementDistance,
                AK_var_fnc_battlelogger_vehSpacing,
                AK_var_fnc_battlelogger_breiteGefStr,
                AK_var_fnc_battlelogger_platoonSize
            ];
            diag_log _summary; // Do not remove 'AKBL Result: ' - see readme.txt for details
            {deleteVehicle _x} forEach (AK_battlingUnits select 0); 
            {deleteVehicle _x} forEach (AK_battlingUnits select 1); 
            {deleteGroup _x} forEach (AK_battlingUnits select 2); 
            AK_battlingUnits = nil;
        }, 
        
        {true}, //Run condition 
        
        //exit Condition 
        {(({alive _x} count (AK_battlingUnits select 1)) <= (count (AK_battlingUnits select 1)/2)) or _timer >= (AK_var_fnc_battlelogger_timeout / AK_var_fnc_battlelogger_loggerInterval) or AK_var_fnc_battlelogger_stopBattle == true}, 
        
        "_timer" //List of local variables that are serialized between executions.  (optional) <CODE>
    ] call CBA_fnc_createPerFrameHandlerObject; 
};
