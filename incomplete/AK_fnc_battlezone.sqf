/* ----------------------------------------------------------------------------
Function: AK_fnc_battlezone

Description:
    Creates a battle between east and resistance.
	Execute on the server.
	
Parameters:
    0: _AZ		- Objective <ARRAY> (default: [500,500,0])

Returns:
	nil

Example:
    (begin example)
		[1, west, [21380, 16390, 0], 40, 0] call AK_fnc_moveRandomPlatoons; 
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_battlezone = {
	[{AK_var_ServerFPS = diag_fps; publicVariable "AK_var_ServerFPS";}, 5] call CBA_fnc_addPerFrameHandler; //publish the servers FPS 

	[{AK_var_ServerFPS = diag_fps; publicVariable "AK_var_ServerFPS";}, 5] call CBA_fnc_addPerFrameHandler;
};