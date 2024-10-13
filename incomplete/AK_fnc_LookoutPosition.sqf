/*
	Function: AK_fnc_LookoutPosition
	Description:
		Calculates the visibility from a candidate position to various points around it within a specified radius and height.
	Parameters:
		_candidatePos - Array: The position to evaluate [x, y, z].
		_targetHeight - Number: The height above the ground to check visibility (default: 3).
		_radius - Number: The radius within which to check visibility (default: viewDistance).
		_left_boundary - Number: The starting angle for visibility checks (default: 1).
		_right_boundary - Number: The ending angle for visibility checks (default: 360).
		_visualize - Boolean: Whether to visualize the visibility checks with flares (default: false).
	Returns:
		Number: The sum of visibility values from the candidate position.
	Example:
		[eyePos player, 3, viewDistance, 1, 360, true] call AK_fnc_LookoutPosition;
*/
AK_fnc_LookoutPosition = {
	params [
		["_candidatePos", [0, 0, 0]],
		["_targetHeight", 3],
		["_radius", viewDistance],
		["_left_boundary", 1],
		["_right_boundary", 360],
		["_visualize", false]
	];

	_visibilitySum = 0;
	for "_i" from _left_boundary to _right_boundary do {
		_destination = (AGLToASL (_candidatePos getPos [_radius, _i])) vectorAdd [0, 0, _targetHeight];
		_visibilityValue = [objNull, "VIEW"] checkVisibility [_candidatePos, _destination];
		_visibilitySum = _visibilitySum + _visibilityValue;

		if (_visualize == true) then {
			if (_visibilityValue == 1) then {
				[_destination, "GREEN", _targetHeight, 0] call AK_fnc_flare;
			} else {
				[_destination, "RED", _targetHeight, 0] call AK_fnc_flare;
			};
		};
	};

	_visibilitySum;
};

// WIP 
_spawnPositions = [];
for "_x" from 1 to 6 do {
	_LookoutValueList = [];
	_LookoutPosList = [];
	for "_i" from 1 to 32 do {
		_pos = [4400, 2300, 1.1] vectorAdd [random 400, random 300, 0]; // define the area for positions
		_value = [AGLToASL _pos, 3, 900, 170, 190, false] call AK_fnc_LookoutPosition; // parameters for avenue of fire
		_LookoutValueList pushBack _value;
		_LookoutPosList pushBack _pos;
	};
	_maxValue = selectMax _LookoutValueList;
	_maxIndex = _LookoutValueList find _maxValue;
	_spawnPositions pushBack (_LookoutPosList select _maxIndex);
};

_type = "LIB_DAK_Pak40";
{
	_vehicle = [[_x select 0, _x select 1, 0], 180, _type, west] call BIS_fnc_spawnVehicle;
	_vehicle select 0 setFuel 0;
} forEach _spawnPositions;
/*
	}
// Create a map marker  
	_marker = createMarker [str(random 1), _candidatePos];  
	
// set the text property of the marker to the desired number  
	_marker setMarkerText str(_visibilitySum);  
	
	sleep 10; 
	
	deleteMarker _marker;
*/
[eyePos player, 3, viewDistance, 1, 360, true] call AK_fnc_LookoutPosition;
