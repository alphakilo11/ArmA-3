/*Gefangennahme
//fade out
//Strip players of equipment (except Map, Watch, pistol)

//teleport them to (random) position (maybe a random building)
// let Zeus check if it isn't a bridge or something (but Zeus also gets a Black screen)

//create hostiles (camp/patrol)
//fade in
//create extraction point (with respawn and arsenal, to allow dead prisoners a "relief mission")
*/

//"-2" will not work in SP and includes Headless Clients
{
 cutText ["A black cat went past us, and then another that looked just like it.","BLACK IN", 10];
    } remoteexeccall ["call", -2];
	
private _pos = [] call BIS_fnc_randomPos; 
private _building = nearestBuilding _pos; 
_pos = (_building buildingPos -1); 
{ _x setPos selectRandom _pos;
} forEach allplayers;

{
_x setUnitLoadout (configFile >> "EmptyLoadout");
} forEach allplayers;





