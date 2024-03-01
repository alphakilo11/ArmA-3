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
    [
        { 
            //function 
            _veh = AK_battlingUnits select 0; 

            //additional exit condition
            // if empty and dead vehicles account for at least half the total vehicles
            if ((({side _x == east} count (AK_battlingUnits select 0)) + ({side _x == independent} count (AK_battlingUnits select 0))) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles) then {
                _AK_var_fnc_battlelogger_stopBattle = true;
            };
        }, 
        
        10, //delay in s 
        
        [], //parameters 
        
        // start 
        {
            _AK_var_fnc_battlelogger_Version = 1.10;
            _AK_var_fnc_battlelogger_numberOfStartingVehicles = 10;
            _AK_var_fnc_battlelogger_engagementDistance = [1000, 0, 0];
            _AK_var_fnc_battlelogger_vehSpacing = 25;
            _AK_var_fnc_battlelogger_breiteGefStr = 500;
            _AK_var_fnc_battlelogger_platoonSize = 1;
            _AK_var_fnc_battlelogger_timeout = 140; // seconds
            _AK_var_fnc_battlelogger_noFuel = true;
            _startFrameNo = diag_frameNo;
            //avoid impaired visibility
            0 setFog 0;
            0 setRain 0;
            [[2035, 06, 21, 12, 00]] call BIS_fnc_setDate;
            //set variables ENHANCE find another way
            _AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            _AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            _AK_var_fnc_battlelogger_startTime = systemTime;
            _AK_var_fnc_battlelogger_start_time_float = serverTime; // only for the timeout, new variable iot not break ABE_auswertung.py
            _AK_var_fnc_battlelogger_stopBattle = false;
            _PosSide1 = [AK_var_fnc_automatedBattleEngine_location, (AK_var_fnc_automatedBattleEngine_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance)];
            _PosSide2 = [(AK_var_fnc_automatedBattleEngine_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance), AK_var_fnc_automatedBattleEngine_location];

            diag_log format ["AKBL %1 Battlelogger starting! %2 vs. %3", _AK_var_fnc_battlelogger_Version, _AK_var_fnc_battlelogger_typeEAST, _AK_var_fnc_battlelogger_typeINDEP];
            //alternate locations
            if (random 1 >= 0.5) then { 
            _templocation = _PosSide1;
            _PosSide1 = _PosSide2; 
            _PosSide2 = _templocation; 
            };

            _spawnedgroups1 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            _spawnedgroups2 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            AK_battlingUnits = []; //initialize the global variable 
            { 
            AK_battlingUnits pushBack ((_spawnedgroups1 select _x) + (_spawnedgroups2 select _x));} forEach [0,1,2];

            {_x allowCrewInImmobile true} forEach (AK_battlingUnits select 0);

            if (_AK_var_fnc_battlelogger_noFuel == true) then {
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
            _east_veh_survivors = ({side _x == east} count (AK_battlingUnits select 0));
            _indep_veh_survivors = ({side _x == independent} count (AK_battlingUnits select 0));
            _duration = serverTime - _AK_var_fnc_battlelogger_start_time_float;
            _avgFps = (diag_frameNo - _startFrameNo) / _duration;
            _summary = [
                "AKBL Result: ", // Do not remove 'AKBL Result: ' - see readme.txt for details
                _AK_var_fnc_battlelogger_Version,
                _AK_var_fnc_battlelogger_typeEAST,
                _east_veh_survivors,
                _AK_var_fnc_battlelogger_typeINDEP,
                _indep_veh_survivors,
                _AK_var_fnc_battlelogger_numberOfStartingVehicles,
                worldName,
                AK_var_fnc_automatedBattleEngine_location,
                _AK_var_fnc_battlelogger_engagementDistance,
                _AK_var_fnc_battlelogger_vehSpacing,
                _AK_var_fnc_battlelogger_breiteGefStr,
                _AK_var_fnc_battlelogger_platoonSize,
                _AK_var_fnc_battlelogger_startTime,
                systemTime,
                sunOrMoon,
                moonIntensity,
                _AK_var_fnc_battlelogger_noFuel,
                _avgFps
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
            ((({alive _x} count (AK_battlingUnits select 1)) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles) or 
            (serverTime >= (_AK_var_fnc_battlelogger_timeout + _AK_var_fnc_battlelogger_start_time_float)) or //HEADSUP doesn't work in Singleplayer
            (_AK_var_fnc_battlelogger_stopBattle == true)) 
        }, 
        
        [
            "_AK_var_fnc_battlelogger_Version",
            "_AK_var_fnc_battlelogger_numberOfStartingVehicles",
            "_AK_var_fnc_battlelogger_engagementDistance",
            "_AK_var_fnc_battlelogger_vehSpacing",
            "_AK_var_fnc_battlelogger_breiteGefStr",
            "_AK_var_fnc_battlelogger_platoonSize",
            "_AK_var_fnc_battlelogger_timeout",
            "_AK_var_fnc_battlelogger_noFuel",
            "_AK_var_fnc_battlelogger_typeEAST",
            "_AK_var_fnc_battlelogger_typeINDEP",
            "_AK_var_fnc_battlelogger_startTime",
            "_AK_var_fnc_battlelogger_start_time_float",
            "_AK_var_fnc_battlelogger_stopBattle",
            "_startFrameNo"
        ] //List of local variables that are serialized between executions.  (optional) <CODE>
    ] call CBA_fnc_createPerFrameHandlerObject; 
};
