// //Server "init"
// TODO make this run automatically
// TODO create custom loadouts
// TODO create combatzone at random location and add teleporters or respawnpoints with arsenal
// TODO use CBA_fnc_globalEvent and CBA_fnc_globalEventJIP
// TODO set real weather
// TODO set AI skill

// Hints: Flagpoles might be teleporters, Look for (ACE)Arsenals in ammo vehicles/crates 

// set Global&JIP viewDistance (0.0142 ms)
5500 remoteExec ["setviewDistance", -2, "Viewdistance"];
5500 remoteExec ["setObjectViewDistance", -2, "Objectdistance"];
2 remoteExec ["setTerrainGrid", -2, "Terraingrid"];

// set real time (0.0789 ms)
{
	[[(missionStart select [0, 5]), time] call BIS_fnc_calculateDateTime, true, true] call BIS_fnc_setDate;
} remoteExec ["call", 2];

// get IDs and check FPS once a minute
AK_handle_fps = [{
	{
		[
			[clientOwner, (!hasInterface && !isDedicated), diag_fps],
			{
				systemChat format
				[
					"ClientOwner: %1. HC: %2. FPS: %3",
					_this select 0, _this select 1, _this select 2
				];
			}
		]
		remoteExec ["call", remoteExecutedOwner];
	}
	remoteExec ["call", 0];
}, 60, []] call CBA_fnc_addPerFrameHandler;

/*
// add Campfire 10m in front of player (2.82486 ms)
	_pos = player modelToWorld [0, 10, 0];  
	"Campfire_burning_F" createVehicle _pos;
// add container 20 m left of player (18.3636 ms)
// TODO make Marker only visible to ownside
	private _pos = player modelToWorld [-20, 0, 0];  
	private _container = "B_Slingload_01_Ammo_F" createVehicle _pos;
	_container setDir (_container getDir player);
	[_container, true] call ace_arsenal_fnc_initBox;
	private _markerstr = createMarker [(str time), (getPos _container)];
	_markerstr setMarkerShape "ICON";
	_markerstr setMarkerType "hd_dot";
	_markerstr setMarkerText "Arsenal";
	
// auto delete empty groups (0.0018 ms)
// TODO remoteExec
	deleteemptygroups = [{
		{
			_x deleteGroupWhenEmpty true
		} forEach allGroups;
		diag_log "Deleting empty groups";
	}, 600] call CBA_fnc_addPerFrameHandler;
	
*/