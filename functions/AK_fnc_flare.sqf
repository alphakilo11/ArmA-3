/* ---------------------------------------------------------------------------- 
Function: AK_fnc_flare 
 
Description: 
    Pops a small flare 150m overhead the given position. 
  
Parameters: 
    0: _position    - Position of flare <ARRAY>  (Default:[0, 0, 0]))
    1: _color       - Color of flare <STRING> (default: "WHITE")("WHITE", "RED", "GREEN", "YELLOW", "IR")
    2: _height      - Height AGL <NUMBER> (default: 120) 
 
Returns: 
 NIL 
 
Example: 
    (begin example) 
        [player modelToWorld [0, 100, 0], "RED"] call AK_fnc_flare; 
    (end) 
 
Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
AK_fnc_flare = {
	params [
		["_position", [0, 0, 0]],
		["_color", "WHITE"],
		["_height", 120],
		["_sinkrate", -2]
	];

	_shell = createVehicle [("F_40mm_" + _color), (_position vectorAdd [0, 0, _height]), [], 0, "NONE"];
	_shell setVelocity [0, 0, _sinkrate];
};
