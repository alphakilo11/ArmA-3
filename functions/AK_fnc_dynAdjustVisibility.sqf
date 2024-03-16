/* ---------------------------------------------------------------------------- 
Function: AK_fnc_dynAdjustVisibility
 
Description: 
    A function used to adjust visibility based on given FPS.
    200 is the lowest value for setViewDistance. 
Parameters: 
    - FPS    <NUMBER>
 
Optional: 
    - Adjust setDynamicSimulationDistance    <BOOL>    (Default: false)   
    - Reference values [critical, low, high]    <ARRAY of NUMBERS>    (Default: [10, 25, 40])
    - Maximum View Distance in m   <NUMBER>    (Default: 7000)  

Example: 
    (begin example) 
    [{[{[diag_fps, true] remoteExec ["AK_fnc_dynAdjustVisibility", 2];}] remoteExec ["call", -2];}, 10] call CBA_fnc_addperFrameHandler;
    (end) 
 
Returns: 
    Adjustment of visibility in m. (0 if unchanged))
 
Author: 
    AK
---------------------------------------------------------------------------- */ 
AK_fnc_dynAdjustVisibility = {
    params [
    ["_fps", 0, [123]],
    ["_dynSim", false, [false]],
    ["_referenceValues", [10, 25, 40], [[]]],
    ["_maxViewDistance", 7000, [123]]
    ];
    
    //execute on server only
    if (isServer == false) exitWith {hint "AK_fnc_dynAdjustVisibility has to run on the server";};

    // check server load    
    _serverFPS = diag_fps;
    if (_serverFPS <= _fps) then {_fps = _serverFPS};

   // calculate values 
    _referenceValues params ["_verylow","_low", "_high"];
    _newViewDistance = viewDistance;
    _increment = floor (_newviewDistance / 10);
    
    if (_fps < _verylow) then {
        _newViewDistance = floor (viewDistance / 2);
    } else {
        if (_fps < _low) then {
            _newViewDistance = viewDistance - _increment;
        } else {
            if ((_fps > _high) and ((viewDistance + _increment) < _maxViewDistance)) then {
                _newViewDistance = viewDistance + _increment;
            };
        };
    };

    _adjustment = _newViewDistance - viewDistance;
    
    // set values
    _newViewDistance remoteExec ["setviewDistance", 0, "Viewdistance"]; 
    _newViewDistance remoteExec ["setObjectViewDistance", 0, "Objectdistance"];
    if (_dynSim == true) then {
        "Group" setDynamicSimulationDistance _newviewDistance;
        "Vehicle" setDynamicSimulationDistance _newviewDistance;
        "EmptyVehicle" setDynamicSimulationDistance _newviewDistance;
    };

    diag_log format ["AK_fnc_dynAdjustVisibility: FPS: %1. Adjusted visibility: %2 m.", _fps, _newViewDistance];
    _adjustment    
};