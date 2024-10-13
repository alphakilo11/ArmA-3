/*
	ALTERNATIVE create a global array of usable arms on first run of the function
	BUG in ~50% of executions _spawnedgroups will return [] (even when units have been spawned. As of now I don't know if this is caused by slow execution or (more likely) something wrong about the function itself. It's strange, as the deleteGroupWhenEmpty (and other functions i executed for testing like addWaypoint) work every single time.
	BUG sometimes nothing will be spawned.
// find a way to skip invalid groups (repeating everything until the soldier count is fullfilled should work but will result in mixed platoons. to get homogenous platoons there should be a way to only reshuffle groups inside arms)
// All spawned units have to be deleted after some time, because they wander around and/or run out of ammo
// outsource the actual spawn?
// all spawn at the same position
// Sometimes this return invalid groups - the _timeout failsafe should avoid any problems
// assign CBA_assault waypoint or do something that they start guarding their objective
// any step that results in (count array) == 0 should be redone immidiatly
count _isNoMan == 0; // catches invalid groups
	as some fractions appear on multiple sides, it might be hard for players to IFF
	if some arms have groups with infantry and groups with vehicles inhomogenous platoons might be spawned
	
	example
	[west, "West", [23000, 19000, 0], [23000, 18000, 0], 40] call AK_fnc_spawnRandomInfPlatoon;
	end
*/

AK_fnc_spawnRandomInfPlatoon = {
	params ["_side", "_configside", "_position", "_attackposition", "_platoon_size"];

	private ["_cfgArray", "_cfg_faction", "_cfg_arm", "_cfg_group", "_cfg_groupname", "_cfg_units", "_soldiers", "_vehicles", "_isNoMan", "_timeout", "_spawnedgroups"];

	_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> _configside);
	_cfg_faction = configName (selectRandom _cfgArray);
	_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> _configside >> _cfg_faction);
	_cfg_arm = configName (selectRandom _cfgArray);
	_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> _configside >> _cfg_faction >> _cfg_arm);
	_soldiers = 0;
	_timeout = 0;
	_spawnedgroups = [];
	while { (_soldiers < _platoon_size) && (_timeout < 100) } do {
		_cfg_group = (selectRandom _cfgArray);
		_cfg_groupname = configName _cfg_group;
		_cfg_units = "true" configClasses (configFile >> "CfgGroups" >> _configside >> _cfg_faction >> _cfg_arm >> _cfg_groupname);
		_vehicles = [];
		{
			_vehicles pushBack ((configFile >> "CfgGroups" >> _configside >> _cfg_faction >> _cfg_arm >> _cfg_groupname >> (configName _x) >> "vehicle") call BIS_fnc_getCfgData);
		} forEach _cfg_units;
		_isNoMan = [];
		 {
			_isNoMan pushback ([1, 0] select (_x isKindOf "Man")); // 0 if the unit is a man
		} forEach _vehicles;
		if ((ceil (_isNoMan call BIS_fnc_arithmeticMean)) == 1) exitWith {
			[_side, _configside, _position] call AK_fnc_spawnRandomInfPlatoon;
		};
		_soldiers = _soldiers + (count _cfg_units);// does not care if anything actually spawned
		_spawnedgroups pushBack ([_position, _side, _cfg_group] call BIS_fnc_spawnGroup);
		_timeout = _timeout + 1;
	};
	{
		_x deleteGroupWhenEmpty true;
		_x addWaypoint [_attackposition, 50];
	} forEach _spawnedgroups;
	_spawnedgroups;
};