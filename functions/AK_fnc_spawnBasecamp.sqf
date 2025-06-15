AK_fnc_spawnBasecamp = {
	params ["_firePos", "_arsenalPos"];
	"Campfire_burning_F" createVehicle _firePos;
	// add container 
	private _container = "B_Slingload_01_Ammo_F" createVehicle _arsenalPos;
	[_container, true] call ace_arsenal_fnc_initBox;
	_lantern = createVehicle ["Lantern_01_Black_F", getPos _container, [], 0, "CAN_COLLIDE"];
	_lantern attachTo [_container, [0, 0, 1.5]];
};
