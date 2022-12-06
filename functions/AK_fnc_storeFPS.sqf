/* ----------------------------------------------------------------------------
Function: AK_fnc_storeFPS

Description:
    Stores current FPS in a public Variable if it's lower than the curren value
	Probably won't work with multiple clients.
	
Parameters:
    nil

Returns:
	nil

Example:
    (begin example)
		[] call AK_fnc_storeFPS;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_storeFPS = {
	_fps = diag_fps;
	if !(isNil "AK_var_MinFPS" or _fps < AK_var_MinFPS) exitWith {}; //skip if fps are higher than current value
	AK_var_MinFPS = _fps;
	publicVariable "AK_var_MinFPS";
};