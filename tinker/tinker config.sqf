//creates an array of configNames of units of a faction
private _cfgfaction = 'BLU_F';
private _cfgkind = 'CAManBase';
"getText (_x >> 'faction') == _cfgfaction and configName _x isKindOf _cfgkind and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles") apply {configName _x}

//gets the vehicleClass of an object
_test = getText ((configFile >> "CfgVehicles" >> "rhs_t80") >> "vehicleClass");
_test;

//Example of how to extract data from the config (eg:  WEST vehicles of Class Armored, Car and Air).
_cfgArray = "( 
	(getNumber (_x >> 'scope') >= 2) && 
	{
		getNumber (_x >> 'side') == 1 && 
		{ getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air'] }
	}
)" configClasses (configFile >> "CfgVehicles");
