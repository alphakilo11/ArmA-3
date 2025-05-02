/* ---------------------------------------------------------------------------- 
	Function: AK_fnc_getAA 
	 
	Description: 
		Returns the Aspect Angle. 
	  
	Parameters: 
		0: _fighter - Fighter <OBJECT>
		1: _tgt - Target <OBJECT>
	 
	Returns: 
		Float positive means left hemisphere, negative right ~
	 
	Example: 
		(begin example) 
		onEachFrame {hintSilent str round ([player, unlucky] call AK_fnc_getAA)};
		(end) 
	
	Author: 
		AK 
	 
---------------------------------------------------------------------------- */ 
AK_fnc_getAA = {
	params ["_fighter", "_tgt"];
	_tgtHDG = getDir _tgt;
	_bearing = _tgt getDir _fighter;
	_clockwiseAngle = (_bearing + 360 - _tgtHDG) % 360;
	_Aangle = _clockwiseAngle - 180;
	_Aangle
};
