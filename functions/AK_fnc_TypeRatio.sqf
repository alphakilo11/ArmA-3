/* ----------------------------------------------------------------------------
Function: AK_fnc_TypeRatio

Description:
    Returns an array of strings with X elements preserving the ratio. (Intended for unit types but will work with all strings)

Example:
    (begin example)
		[["BMP2", "BMP2", "T72"], 15] call AK_fnc_TypeRatio;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_TypeRatio = {  
params ["_unitTypes", "_numberOfUnits"];   
_unitCounts = count _unitTypes;  
_unitDuplicates = _numberOfUnits / _unitCounts; 
_res = []; 
{  
	_x = _x;  
	for "_i" from 1 to floor _unitDuplicates do {  
	   _res pushBack _x;  
	};  
} forEach _unitTypes; 
while {count _res < _numberOfUnits} do { 
	{  
		if (count _res >= _numberOfUnits) then {  
			break;  
		};  
		_res pushBack _x;  
	} forEach _unitTypes; 
};  
_res  
}; 
