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

[eyePos player, 3, viewDistance, false, true] call AK_fnc_LookoutPosition;
