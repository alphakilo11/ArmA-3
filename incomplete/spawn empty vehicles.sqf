// create an array of west (change 'side' number for other sides) vehicles and spawn them in front of the player in rows of 5
private ["_cfgArray", "_xPos", "_yPos", "_veh"];

_cfgArray = "((getNumber (_x >> 'scope') >= 2) &&
{
	getNumber (_x >> 'side') == 1 &&
	{
		getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air']
	}
}
)" configClasses (configFile >> "CfgVehicles");

_xPos = 0;
_yPos = 0;

{
	_yPos = _yPos + 20;
	_veh = createVehicle [(configName _x), player modelToWorld [_xPos, _yPos, 0], [], 0, "None"];
	if (_yPos >= 100) then {
		_yPos = 0;
		_xPos = _xPos + 20;
	};
} forEach _cfgArray;