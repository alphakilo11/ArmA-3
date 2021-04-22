/* ----------------------------------------------------------------------------
Function: AK_fnc_flare

Description:
    Pops a small flare 150m overhead the given position.
	
Parameters:
    0: _position	- Position of flare <ARRAY>

Returns:
	NIL

Example:
    (begin example)
		[getPos player] call AK_fnc_flare;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_flare = {
params ["_position"];
_shell = "F_40mm_White" createVehicle (_position Vectoradd [0,0,150]);    
_shell setVelocity [0, 0, -1];
};
