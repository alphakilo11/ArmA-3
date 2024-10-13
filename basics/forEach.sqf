// example how to use _x from a higher scope
{
	_x1 = _x;
	{
		_x2 = _x;
		_x1 deleteVehicleCrew _x2
	} forEach crew _x1;
	deleteVehicle _x1;
} forEach (_vehArray);