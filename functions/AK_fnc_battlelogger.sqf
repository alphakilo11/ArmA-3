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
    does NOT work in singleplayer (see HEADSUP)

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
    AK_var_fnc_battlelogger_timeout = 140; // s
    AK_var_fnc_battlelogger_noFuel = true;
    [
        { 
            //function 
            _veh = AK_battlingUnits select 0; 

            //additional exit condition
            // if empty and dead vehicles account for at least half the total vehicles
            if ((({side _x == east} count (AK_battlingUnits select 0)) + ({side _x == independent} count (AK_battlingUnits select 0))) <= AK_var_fnc_battlelogger_numberOfStartingVehicles) then {
                AK_var_fnc_battlelogger_stopBattle = true;
            //increment timer
            //_timer = _timer +1; 

            };
        }, 
        
        AK_var_fnc_battlelogger_loggerInterval, //delay in s 
        
        [], //parameters 
        
        // start 
        {
            //avoid impaired visibility
            0 setFog 0;
            0 setRain 0;
            [[2035, 06, 21, 12, 00]] call BIS_fnc_setDate;
            //set variables ENHANCE find another way
            AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            AK_var_fnc_battlelogger_startTime = systemTime;
            AK_var_fnc_battlelogger_start_time_float = serverTime; // only for the timeout, new variable iot not break ABE_auswertung.py
            AK_var_fnc_battlelogger_stopBattle = false;
            _PosSide1 = [AK_var_fnc_automatedBattleEngine_location, (AK_var_fnc_automatedBattleEngine_location vectorAdd AK_var_fnc_battlelogger_engagementDistance)];
            _PosSide2 = [(AK_var_fnc_automatedBattleEngine_location vectorAdd AK_var_fnc_battlelogger_engagementDistance), AK_var_fnc_automatedBattleEngine_location];

            diag_log format ["AKBL %1 Battlelogger starting! %2 vs. %3", AK_var_fnc_battlelogger_Version, AK_var_fnc_battlelogger_typeEAST, AK_var_fnc_battlelogger_typeINDEP];
            //alternate locations
            if (random 1 >= 0.5) then { 
            _templocation = _PosSide1;
            _PosSide1 = _PosSide2; 
            _PosSide2 = _templocation; 
            };

            _spawnedgroups1 = [AK_var_fnc_battlelogger_numberOfStartingVehicles, AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, AK_var_fnc_battlelogger_vehSpacing, "AWARE", AK_var_fnc_battlelogger_breiteGefStr, AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            _spawnedgroups2 = [AK_var_fnc_battlelogger_numberOfStartingVehicles, AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, AK_var_fnc_battlelogger_vehSpacing, "AWARE", AK_var_fnc_battlelogger_breiteGefStr, AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            AK_battlingUnits = []; //initialize the global variable 
            //_timer = 0; 
            { 
            AK_battlingUnits pushBack ((_spawnedgroups1 select _x) + (_spawnedgroups2 select _x));} forEach [0,1,2];

            {_x allowCrewInImmobile true} forEach (AK_battlingUnits select 0);

            if (AK_var_fnc_battlelogger_noFuel == true) then {
                { // set fuel
                    _x setFuel 0;
                } forEach (AK_battlingUnits select 0);
            } else {
                { // let the vehicles move back and forth
                _wp = _x addWaypoint [[0,0,0], 0]; 
                _wp setWaypointType "CYCLE";} forEach (AK_battlingUnits select 2);
            };

        }, 
        
        //end 
        { 
            east_veh_survivors = ({side _x == east} count (AK_battlingUnits select 0));
            indep_veh_survivors = ({side _x == independent} count (AK_battlingUnits select 0));
            _summary = [
                "AKBL Result: ", // Do not remove 'AKBL Result: ' - see readme.txt for details
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
                AK_var_fnc_battlelogger_platoonSize,
                AK_var_fnc_battlelogger_startTime,
                systemTime,
                sunOrMoon,
                moonIntensity
            ];
            diag_log _summary;
            
            //cleanup
            {deleteVehicle _x} forEach (AK_battlingUnits select 0); 
            {deleteVehicle _x} forEach (AK_battlingUnits select 1); 
            {deleteGroup _x} forEach (AK_battlingUnits select 2); 
            AK_battlingUnits = nil;
        }, 
        
        {true}, //Run condition 
        
        //exit Condition 
        {
            ((({alive _x} count (AK_battlingUnits select 1)) <= AK_var_fnc_battlelogger_numberOfStartingVehicles) or 
            (serverTime >= (AK_var_fnc_battlelogger_timeout + AK_var_fnc_battlelogger_start_time_float)) or //HEADSUP doesn't work in Singleplayer
            (AK_var_fnc_battlelogger_stopBattle == true)) 
        }, 
        
        [] //List of local variables that are serialized between executions.  (optional) <CODE>
    ] call CBA_fnc_createPerFrameHandlerObject; 
};
