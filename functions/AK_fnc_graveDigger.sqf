/*
 * Function: AK_fnc_graveDigger
 * Description: Replaces all dead men with graves at their respective positions and orientations.
 * Parameters: None
 * Returns: None
 * Author: Your Name
 * Example:
 *   [] remoteExec ["AK_fnc_graveDigger", 2]; 
 */
AK_fnc_graveDigger = {
	{
		private _grave = ("ACE_Grave" createVehicle getPos _x);
		_grave setDir (getDir _x);
		deleteVehicle _x;
	} forEach allDeadMen;
};
