/* ----------------------------------------------------------------------------
Function: AK_fnc_createDictionary

Description:
    Creates a dictionary-like string from two arrays of keys and values.
    The intention is to use it together with https://docs.python.org/3/library/ast.html?highlight=ast%20literal_eval#ast.literal_eval
	
Parameters:
    0: _keys	- Keys <ARRAY> 
    1: _values  - Values <ARRAY>

Returns:
	<STRING>

Example:
    (begin example)
		[["rhsgref_faction_chdkz", "CAManBase"], [5, 3]] call AK_fnc_createDictionary;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_createDictionary = {
    params [
        ["_keys"],
        ["_values"]
    ];
    step1 = []
    for "_i" from 0 to (count _keys) do {
        step1 pushBack (_keys select _i);
        step1 pushBack (_values select _i);
    }
}