/* ----------------------------------------------------------------------------
Function: AK_fnc_storeFPS

Description:
    Stores current FPS in a public Variable
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
	AK_var_ClientFPS = diag_fps;
	publicVariable "AK_var_ClientFPS";
};