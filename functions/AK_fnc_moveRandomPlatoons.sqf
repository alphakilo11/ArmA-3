/* ----------------------------------------------------------------------------
Function: AK_fnc_moveRandomPlatoons

Description:
    Spawns random platoons and lets them move toward an objective.
	
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
//TODO change _vfgrm
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
_vfgrm = _AZ vectorAdd [1000,0,0];
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
	_this call AK_fnc_moveRandomPlatoons;
	diag_log "Spawning failed.";
};
_spawnedgroups
};