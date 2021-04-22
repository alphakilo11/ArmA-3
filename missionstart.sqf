////Server "init"
//TODO make this run automatically
//TODO create custom loadouts
//TODO create combatzone at random location and add teleporters or respawnpoints with arsenal
//TODO use CBA_fnc_globalEvent and CBA_fnc_globalEventJIP
//set Global&JIP ViewDistance (0.0142 ms)
5500 remoteExec ["setviewDistance", -2, "Viewdistance"];
5500 remoteExec ["setObjectViewDistance", -2, "Objectdistance"];
2 remoteExec ["setTerrainGrid", -2, "Terraingrid"];
//set real time (0.0789 ms)
//TODO rewrite to execute it on the server
[[(missionStart select [0,5]), time] call BIS_fnc_CalculateDateTime, true, true] call BIS_fnc_setDate;
//set real weather
//add Campfire 10m in front of player (2.82486 ms)
_pos = player modelToWorld [0,10,0];  
"Campfire_burning_F" createVehicle _pos;
//set AI skill
//add container 20 m left of player (18.3636 ms)
//TODO make Marker only visible to ownside
private _pos = player modelToWorld [-20,0,0];  
private _container = "B_Slingload_01_Ammo_F" createVehicle _pos;
_container setDir (_container getDir player);
[_container, true] call ace_arsenal_fnc_initBox;
private _markerstr = createMarker [(str time),(getPos _container)];
_markerstr setMarkerShape "ICON";
_markerstr setMarkerType "hd_dot";
_markerstr setMarkerText "Arsenal";

//auto delete empty groups (0.0018 ms)
//TODO remoteExec
deleteemptygroups = [{
{
_x deleteGroupWhenEmpty true
} forEach allgroups;
diag_log "Deleting empty groups";
}, 600] call CBA_fnc_addPerFrameHandler;

/*Add auto-transfer ownership of Zeus-placed units to Server/HC
check if HC is available
avoid leaders disembarking by temp locking vehicle
this addEventHandler ["CuratorGroupPlaced", {
	params ["_curator", "_group"];
}];
*/
//Add Vehicle Respawn
//Add Vehicle usable as Respawn and respawning
//auto-distribute Zeus-created groups