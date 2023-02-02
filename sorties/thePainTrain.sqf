// THE PAIN TRAIN
// requires AK_fnc_populateMap and AK_fnc_dynAdjustVisibility
AK_var_attackers = [];
_distance = 1600;
_anchorPosition = [5500, 3700, 0];
_size = 1000;
_ingressPosition = [6400, 4800, 0];
_center = _anchorPosition vectorAdd [_size / 2, _size / 2, 0];
_attackerCount = 40;
_defenderNumberOfGroups = 36;

setviewDistance _distance; 
setObjectViewDistance _distance; 
setTerrainGrid 1; //50 removes grass, but the heightmap is very crude
"Group" setDynamicSimulationDistance _distance;
{[[(missionStart select [0,5]), time] call BIS_fnc_CalculateDateTime, true, true] call BIS_fnc_setDate;} remoteExec ["call", 2];

[_anchorPosition, _size, true, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditCombatGroup", independent, _defenderNumberOfGroups] spawn AK_fnc_populateMap;

AK_fnc_countUnits = {
    params ["_groups"];
    _sum = 0;
    {_sum = _sum + count units _x} forEach _groups;
    _sum;
};

AK_handle_attackers = [    
    {
        (_this select 0) params ["_ingressPosition", "_center", "_attackerCount"];
        while {[AK_var_attackers] call AK_fnc_countUnits <= _attackerCount} do {
            _group = [_ingressPosition, west, configFile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad"] call BIS_fnc_spawnGroup; 
            _group deleteGroupWhenEmpty true;  
            _group addWaypoint [_center, 50];
            AK_var_attackers pushBack _group;
        };
    //hint format ["%1, %2, %3, %4", _ingressPosition, _center, _attackerCount, [AK_var_attackers] call AK_fnc_countUnits];
    },
    60,
    [_ingressPosition, _center, _attackerCount]
] call CBA_fnc_addPerFrameHandler;

AK_handle_dynVis = [{[{[diag_fps, true] remoteExec ["AK_fnc_dynAdjustVisibility", 2];}] remoteExec ["call", -2];}, 10] call CBA_fnc_addperFrameHandler;