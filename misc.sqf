Wenn du nicht mehr weiter weißt
und du drehst dich nur im Kreis
stell ich mich zu dir in den Wind
weil wir zusammen stärker sind.

Red Internet & Phone
50 Cable (Neukunden)


//Bulletcam for 60 s (does not work in vehicles)
_unit = player; 
_unit call BIS_fnc_diagBulletCam; 
_ehIndex = _unit getVariable "bis_fnc_diagBulletCam_fired"; 
sleep 60; 
_unit removeEventHandler ["fired", _ehIndex];

setviewDistance 5000;
setObjectViewDistance 5000;
setTerrainGrid 50;

//creates an empty vehicle at player position. 3.16404 ms
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
//31.75 ms
_gruppe = [[21000,14500,0], west, 8] call BIS_fnc_spawnGroup;
_gruppe addWaypoint [[21500,14500,0], 100]; 
};

//TODO





////General
//Create Jet overflight with gate climb

////Video
///Night
//