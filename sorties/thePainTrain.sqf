// THE PAIN TRAIN 
// requires AK_fnc_populateMap and AK_fnc_dynAdjustVisibility 
#define RANDOM_CONFIG_CLASS(var) selectRandom ("true" configClasses (var))  

AK_var_attackers = []; 
_distance = 1600; 
_anchorPosition = [random worldSize, random worldSize, 0]; 
_size = sqrt 1500000;
_center = _anchorPosition vectorAdd [_size / 2, _size / 2, 0]; 
_ingressPosition = (_center vectorAdd [random _size, random _size, 0]); 
_attackerCount = 40; 
_defenderNumberOfGroups = 9; 
 
setviewDistance _distance;  
setObjectViewDistance _distance;  
setTerrainGrid 1; //50 removes grass, but the heightmap is very crude 
"Group" setDynamicSimulationDistance _distance; 
{[[(missionStart select [0,5]), time] call BIS_fnc_CalculateDateTime, true, true] call BIS_fnc_setDate;} remoteExec ["call", 2]; 
 
[_anchorPosition, _size, true, "random", independent, _defenderNumberOfGroups] spawn AK_fnc_populateMap; 
 
AK_fnc_countUnits = { 
    params ["_groups"]; 
    _sum = 0; 
    {_sum = _sum + count units _x} forEach _groups; 
    _sum; 
}; 
 
AK_handle_attackers = [     
    { 
        (_this select 0) params ["_ingressPosition", "_center", "_attackerCount"]; 
        if ([AK_var_attackers] call AK_fnc_countUnits <= _attackerCount) then { 
            _group = [_ingressPosition, west, RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(configFile >> "cfgGroups" >> "west")))] call BIS_fnc_spawnGroup;  
            _group deleteGroupWhenEmpty true;   
            _wp = _group addWaypoint [_center, 50]; 
            _wp setWaypointStatements ["true", "[this, [getPos (leader this), 500, 500, 0, true]] call CBA_fnc_taskSearchArea;"]; //ENHANCE find a way to pass the array area size. Area Array = [center, a, b, angle, isRectangle, c]
            AK_var_attackers pushBack _group; 
        }; 
    //hint format ["%1, %2, %3, %4", _ingressPosition, _center, _attackerCount, [AK_var_attackers] call AK_fnc_countUnits]; 
    }, 
    60, 
    [_ingressPosition, _center, _attackerCount] 
] call CBA_fnc_addPerFrameHandler; 
 
AK_handle_dynVis = [{[{[diag_fps, true] remoteExec ["AK_fnc_dynAdjustVisibility", 2];}] remoteExec ["call", -2];}, 10] call CBA_fnc_addperFrameHandler;