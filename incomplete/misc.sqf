//use on a vehicle to make it respawn
[_this select 1] call BIS_fnc_moduleRespawnVehicle;

//Array of tanks
(("configName _x isKindOf 'tank' and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles")) apply {(configName _x)})

//Bulletcam for 60 s (does not work in SP or vehicles)
_unit = player; 
_unit call BIS_fnc_diagBulletCam; 
_ehIndex = _unit getVariable "bis_fnc_diagBulletCam_fired"; 
sleep 60; 
_unit removeEventHandler ["fired", _ehIndex];

//View Distance
setviewDistance 5500;
setObjectViewDistance 5500;
setTerrainGrid 2; //50 removes grass, but the heightmap is very crude

// prints the class name of the vehicle that the code is executed on
systemChat format ["This is a %1", typeOf vehicle (_this select 1)]

//Create an empty vehicle at player position. 3.16404 ms
private _position = position player;
private _type = "rhs_t80";
private _kanone = createVehicle [_type, _position, [], 20, "NONE"]


//enables projectile tracking of vehicles
 private _eventId = [vehicle unlucky] call CBA_fnc_addUnitTrackProjectiles;

//get the center position of the screen (PosAGL). 0.0009 ms
screenToWorld [0.5,0.5];

//enable Bullettracing
[player, 10] spawn BIS_fnc_traceBullets;

//lets the targeted object face the player
cursorTarget setDir (cursorTarget getDir player);

//checks visibility of player by unit1 (return true or false)
([objNull, "VIEW"] checkVisibility [eyePos player, eyePos unit1]) == 1

//spawns groups of 8 random NATO units each and assigns a move waypoint
for "_i" from 1 to 12 do {
	_gruppe = [[21000,14500,0], west, 8] call BIS_fnc_spawnGroup;
	_gruppe addWaypoint [[21500,14500,0], 100]; 
}; //31.75 ms

// Variables can be created in the "Namespace" of a unit (or object). Example from https://github.com/FreestyleBuild/A3-map-tracking:
_unit setVariable ["trackingData", [[getPos _unit, getDir _unit, date, speed _unit]]];
	private _x = (_unit getVariable "trackingData");
	_x append [[getPos _unit, getDir _unit, date, speed _unit]];
