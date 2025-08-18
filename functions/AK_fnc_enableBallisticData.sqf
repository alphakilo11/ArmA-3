AK_fnc_enableBallisticData = {
    #define ID_HANDLE aKHabD3
    {
        // check if entity alread uses AK_fnc_ballisticData
        if (local _x) then {
            if (_x getVariable ["AK_switch_ballisticData", false] == false) then {
                _x addEventHandler ["Fired", {  
                    [
                        _this,  
                        [ 
                            diag_tickTime, // shotTime 
                            getPosASL (_this select 6), // shooter position 
                            velocity (_this select 6), // V0
                            typeOf (_this select 0) // unitType 
                        ] 
                    ] call AK_fnc_ballisticData; 
                }];
                _x setVariable ["AK_switch_ballisticData", true];
            };
            if (_x getVariable ["AK_switch_MPKilledHandler", false] == false) then {
                    _x addMPEventHandler ["MPKilled", {
                        params ["_unit", "_killer", "_instigator", "_useEffects"];
                        _MPKValues = [str _unit, str _killer, str _instigator, str _useEffects, diag_tickTime, 'ID_HANDLE', "MPKilled"];
                        _MPKMessage = ["_unit", "_killer", "_instigator", "_useEffects", "tickTime", "ID", "Event"] createHashMapFromArray _MPKValues;
                        _MPKMessage spawn AK_fnc_logHashMap; 
                    }];
                    _x setVariable ["AK_switch_MPKilledHandler", true];
                };    
        };
    } forEach (vehicles + allUnits);
}
