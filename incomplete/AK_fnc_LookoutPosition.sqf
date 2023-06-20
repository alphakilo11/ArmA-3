AK_fnc_LookoutPosition = {
  params [
    ["_candidatePos", [0, 0, 0]],
	["_targetHeight", 3],
    ["_radius", 100],
    ["_visualize", false]
  ];

  _visibilitySum = 0;
  for "_i" from 330 to 360 do {
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

[eyePos player, 3, 800, true] call AK_fnc_LookoutPosition;
