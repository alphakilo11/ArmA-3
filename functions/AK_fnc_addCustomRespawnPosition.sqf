AK_fnc_addCustomRespawnPosition = {
	/*
		Description:
			Adds a custom respawn position using BIS_fnc_addRespawnPosition and optionally locks all crew positions (except passengers).
	
		Parameters:
			_target	 - Namespace, Side, Group or Object: Receiver of the respawn position (e.g., missionNamespace for all)
			_position   - Array, Object or String: Location of the respawn position (ATL array, object, or marker)
			_name	   - String: Name shown for the respawn position
			_lockCrew   - Boolean: Whether to lock all crew positions (driver, gunner, etc., passengers remain unlocked)
	
		Returns:
			Array - [id, name] for use with BIS_fnc_removeRespawnPosition
		Example:
			[BLUFOR, helicopter, getText (configFile >> "CfgVehicles" >> typeOf helicopter >> "displayName"), true] call AK_fnc_addCustomRespawnPosition; 
	*/
	
	params [
		"_target",	  // Namespace, Side, Group or Object
		"_position",	// Array, Object, or String
		"_name",		// String
		["_lockCrew", true] // Boolean (optional)
	];
	
	// Validate basic input
	if (isNil "_target" || isNil "_position" || isNil "_name") exitWith {
		diag_log "[fnc_addCustomRespawnPosition] Error: Invalid parameters.";
		[]
	};
	
	// Add the respawn position
	private _respawnID = [_target, _position, _name] call BIS_fnc_addRespawnPosition;
	
	// Lock crew positions if enabled and _position is an object
	if (_lockCrew && { _position isKindOf "AllVehicles" }) then {
		private _vehicle = _position;
	
		_paths = allTurrets _vehicle;
		{_vehicle lockTurret [_x, true]} forEach _paths;
		_vehicle lockDriver true;};
	
	[_respawnID, _name]
};
