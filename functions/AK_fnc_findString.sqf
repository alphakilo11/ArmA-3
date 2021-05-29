/* ----------------------------------------------------------------------------
Function: AK_fnc_findString

Description:
    Searches an array of strings for a certain string and returns an array containing all hits.
	
Parameters:
    0: _string	- string to search for <STRING> 
    1: _array	- array to search in <ARRAY>

Returns:
	<ARRAY>

Example:
    (begin example)
		["LIB_", ["LIB_P38","LIB_P08","LIB_M1896","WaltherPPK"]] call AK_fnc_findString;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_findString = {
params ["_string", "_array"];
private _hitArray = [];
{ 
if ([_string, _x] call BIS_fnc_inString) then {
_hitArray pushBack _x;}
} forEach _array;
_hitArray
};