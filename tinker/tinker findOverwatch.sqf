// finds elevated positions and assigns them as waypoints. Spawn because it's pretty hungry and it probably returns better positions.

[] spawn {
	for "_i" from 1 to 27 do {
		private _grp =[[9172.79, 21623.9, 0.00141239], independent, 1] call BIS_fnc_spawnGroup;
		_grp deleteGroupWhenEmpty true;
		private _wpPos = [[7000, 21000, 0], 1128] call BIS_fnc_findOverwatch;
		_grp addWaypoint [_wpPos, 0];
	};
};