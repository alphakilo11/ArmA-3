AK_fnc_spawnBasecamp = {
	// creates a fire and ACE Arsenal container
	params ["_firePos", "_arsenalPos"];
	"Campfire_burning_F" createVehicle _firePos;
	// add container 
	private _container = "B_Slingload_01_Ammo_F" createVehicle _arsenalPos;
	[_container, true] call ace_arsenal_fnc_initBox;
};