AK_sortie_ambushSouthPyrgos = {
	/* An ambush along the track from Pyrgos through the hills towards Panagia
	Convoy is set to random OPFOR vehicles
	If there are crossections in the Convoy start area, collisions are to be expected
	The number of convoy vehicles is limited by the number of valid positions that have been found by nearestTerrainObjects
	
	ENHANCE
		Implement an optional faction filter 
		ADD side as parameter
		ADD Player triggered illumination
		Wehrmacht vehicles by yearly count
	EXAMPLE
		[[23700,20000,0], [26000,21600,0], 30, 30] spawn AK_sortie_ambushSouthPyrgos 
	*/
	params [
		["_convoyStartPos", [17325.6,12388.8,0], [[]]],
		["_convoyDestinationPos", [20218.5,9806.16,0], [[]]],
		["_vehicleNumber", 10, [0]],
		["_convoySpeedLimit", 30, [0]]
		];
		
	_convoySpawnDiameter = 200;
	// get list of vehicles for convoy
	_cfgArray = "((getNumber (_x >> 'scope') >= 2) && 
		configName _x isKindOf 'landvehicle' &&
		getNumber (_x >> 'side') == 0 &&
		getNumber (_x >> 'maxSpeed') > 0		
		)" configClasses (configFile >> "CfgVehicles");
	_cfgArray = _cfgArray apply {configName _x};
	// get possible spawnpositions for convoy
	_convSpawnPos = nearestTerrainObjects [_convoyStartPos, ["MAIN ROAD", "ROAD", "TRACK"], _convoySpawnDiameter];
	for "_i" from 1 to _vehicleNumber do {
		if (count _convSpawnPos < 1) exitWith {
			_message = "AK_sortie_ambushSouthPyrgos WARNING: Not enough valid spawnPos found.";
			systemChat _message;
			diag_log _message
		};
		_vehicle = (selectRandom _cfgArray) createVehicle (getPos (_convSpawnPos select 0));
		_convSpawnPos deleteAt 0;
		_vehicle limitSpeed _convoySpeedLimit; 
		_vehicle allowCrewInImmobile [true, false];
		_vehicle setDir (_vehicle getDir _convoyDestinationPos);
		_group = createVehicleCrew _vehicle;
		_group deleteGroupWhenEmpty true;
		_group setBehaviour "SAFE";
		_group addWaypoint [_convoyDestinationPos, _vehicleNumber * 10];
	};
};
