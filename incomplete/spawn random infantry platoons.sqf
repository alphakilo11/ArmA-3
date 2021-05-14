//TODO replace global vars
//make sure no vehicles are spawned 
//PARAMS "_side", "_configside", "_position"
//find a way to skip invalid groups (repeating everything until the soldier count is fullfilled should work but will result in mixed platoons. To get homogenous platoons there should be a way to only reshuffle groups inside arms)
//Return spawned units
//All spawned units have to be deleted after some time, because they wander around and/or run out of ammo
//outsource the actual spawn?
//all spawn at the same position
//Sometimes this return invalid groups - the _timeout failsafe should avoid any problems
//assign CBA_assault waypoint or do something that they start guarding their objective

private ["_cfgArray", "_faction", "AK_group", "AK_groupname", "_units", "_soldiers", "_vehicles", "AK_isman"]; 
 
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West");   
_faction = configName (selectRandom _cfgArray);  
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction);  
_arm = configName (selectRandom _cfgArray);  
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm);  
_soldiers = 0;
_timeout = 0;
while { (_soldiers < 40) && (_timeout < 100)} do { 
	AK_group = (selectRandom _cfgArray); 
	AK_groupname = configName AK_group;
	_units = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm >> AK_groupname);
	_vehicles = [];
	{	_vehicles pushBack ((configFile >> "CfgGroups" >> "West" >> _faction >> _arm >> AK_groupname >> (configName _x) >> "vehicle") call BIS_fnc_getCfgData);
	} forEach _units;
	AK_isman = [];
		{AK_isman pushback ([1,0] select (_x isKindOf "Man")); // 0 if the unit is a man
	} forEach _vehicles;
	_soldiers = _soldiers + (count _units); //does not care if anything actually spawned
	[[23000, 19000, 0], west, AK_group] call BIS_fnc_spawnGroup;
	_timeout = _timeout + 1;
};


count AK_isman == 0; // catches invalid groups
ceil (AK_isman call BIS_fnc_arithmeticMean); // if 0 group has no vehicles