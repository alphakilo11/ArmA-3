AK_fnc_isLazy = {
	// check if a unit didn't move; possibly stuck
	params ["_candidate"];
	_testPos = getPosWorld _candidate;
	systemChat format ["%1 saved.", _testPos];
	sleep 5;
	_movementDistance = _candidate distance _testPos;
	if (_movementDistance < 5) then {
		systemChat "didn't move";
	};
	systemChat "5 s later.";
};