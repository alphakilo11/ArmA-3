/* ----------------------------------------------------------------------------
Function: AK_fnc_moveRandomPlatoons

Description:
    Spawns random platoons and lets them move toward an objective. When vehicles are spawned a _pltstrength = 40 platoon might end up with up to 20 vehicles.
	
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

Requires:
	AK_fnc_cfgFactionTable
	AK_fnc_cfgGroupTable

Author:
    AK

---------------------------------------------------------------------------- */
//BUG sometimes nothing is spawned, but groups are returned
//BUG server lags when spawning - probably to to reading the configtable every time
//REMARK auffaellig viele Lfz
//ENHANCE add GroupTable to veriable 
AK_fnc_moveRandomPlatoons = {
	params [
		["_cfgSide", 1, [0]],
		["_side", west, [west]], //east, west, resistance
		["_AZ", [500,500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]]
	];

	private ["_cfgFaction", "_numberOfUnits", "_timeout", "_spawnedgroups", "_vfgrm", "_facing"];

	if (isNil "AK_var_fnc_moveRandomPlatoons_factiontables") then {
		AK_var_fnc_moveRandomPlatoons_factiontables = [];
		{AK_var_fnc_moveRandomPlatoons_factiontables pushBack ([_x] call AK_fnc_cfgFactionTable)} forEach [0,1,2];
	};
	_cfgFaction = str text (selectRandom (AK_var_fnc_moveRandomPlatoons_factiontables select _cfgSide));
	_numberOfUnits = 0;
	_timeout = 0;
	_spawnedgroups = [];
	_vfgrm = _AZ vectorAdd [random [-1500, 0, 1500],random [-1500, 0, 1500],0];
	_facing = _vfgrm getDir _AZ;

	while {_numberOfUnits < _pltstrength && _timeout < (_pltstrength +1)} do {
		_cfggroup = selectRandom ([_cfgFaction] call AK_fnc_cfgGroupTable);
		_grp = [_vfgrm, _side, _cfggroup, [], [], [], [], [], _facing, false, _maxveh] call BIS_fnc_spawnGroup;
		_vfgrm = _vfgrm vectorAdd [10, 0, 0];
		_spawnedgroups pushBack _grp;
		_numberOfUnits = _numberOfUnits + count (units _grp);
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [_AZ, 100];
		_timeout = _timeout + 1;
	};
	if (_timeout >= (_pltstrength + 1)) then {
		/*_this call AK_fnc_moveRandomPlatoons;*/
		systemChat "AK_fnc_moveRandomPlatoons: Spawning failed.";
	};
	_spawnedgroups
};