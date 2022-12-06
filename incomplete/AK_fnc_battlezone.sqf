/* ----------------------------------------------------------------------------
Function: AK_fnc_battlezone

Description:
    Creates a battle between east and west. The player can fight alongside one of the parties or choose independent and fight both.
	Execute on the server.
	
Parameters:
    0: _AZ		- Objective <ARRAY> (default: [500,500,0])
    1: _pltstrength	- Minimum Number of Units per platoon (max. depends on group strength) <NUMBER> (default: 40)
	2: _maxveh		- Maximum number of vehicles per group. <NUMBER> (default: 0)
    3: _spawndelay  - Time in seconds between spawn attemtps. <NUMBER> (default: 300)

Returns:
	nil

Example:
    (begin example)
		[[21380, 16390, 0], 40, 1, 300] call AK_fnc_battlezone;
    (end)

Requires:
	AK_fnc_moveRandomPlatoons

Author:
    AK

---------------------------------------------------------------------------- */
//ENHANCE choose factions
//ENHANCE let allies spawn on the same side of the battlefield
//ENHANCE dynamically adapt to number of clients
//ENHANCE consider client FPS
//BUG default values of AK_fnc_moveRandomPlatoons are used 
//BUG in some cycles one side doesn't spawn 
//VALIDATE no vehicles spawning?
AK_fnc_battlezone = {
    params [
		["_AZ", [1500,1500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]],
        ["_spawndelay", 300, [0]]
	];

	[{AK_var_ServerFPS = diag_fps; publicVariable "AK_var_ServerFPS";}, (_spawndelay / 10)] call CBA_fnc_addPerFrameHandler; //publish the servers FPS 

	[{
        [_this select 0] params [
		["_AZ", [1500,1500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]]
		];
		if (AK_var_ServerFPS < 25) exitWith {diag_log 'AK_fnc_battlezone: low FPS, skipping spawn.'}; //check performance and skip spawning if too low
			
		//debug
		diag_log format ['Hello I am the server executing AK_fnc_battlezone and these are my variables: %1 - %2 - %3', _this select 0 select 0, _this select 0 select 1, _this select 0 select 2];

		[0, east, _this select 0 select 0, _this select 0 select 1, _this select 0 select 2] call AK_fnc_moveRandomPlatoons;
		[1, west, _this select 0 select 0, _this select 0 select 1, _this select 0 select 2] call AK_fnc_moveRandomPlatoons; //spawn

    }, _spawndelay, [_AZ, _pltstrength, _maxveh]] call CBA_fnc_addPerFrameHandler;
};