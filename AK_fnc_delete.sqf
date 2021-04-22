/* ----------------------------------------------------------------------------
Function: AK_fnc_delete

Description:
    Deletes given groups.
	If the Parameters were handed over by means of a variable, the variable is not deleted.
	
Parameters:
    0: _groups	- Groups to delete <ARRAY>

Returns:
	?

Example:
    (begin example)
		[somegroups] call AK_fnc_delete;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_delete = {
params ["_groups"];
_vehlist = [];
{
	{
		_vehlist pushBackUnique vehicle _x;
		deleteVehicle _x;
	} forEach (units _x);
	deleteGroup _x;
} forEach _groups;
{deleteVehicle _x} forEach _vehlist;
};