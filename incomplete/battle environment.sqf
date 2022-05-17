//WIP Battlefield simulation
//aircraft seem to have a high performance impact
//TODO make aircraft disappear
//TODO use variables
//TODO use random groups / soldiers from a specific faction

AK_fnc_Battlesimulation = {

[[14600, 21700 ,0], 500] params ["_AZ", "_spawndistance"];

_spawnwest = _AZ vectorAdd [-_spawndistance, 0 , 0];

_AK_Indep_Air = [4, "I_Plane_Fighter_04_F", [30000, 30000 ,15000], _AZ, independent, 1000, "AWARE", 500, 4] spawn AK_fnc_spacedvehicles;
{ 
	_wp = _x addWaypoint [[0,0,0], 0]; 
	_wp setWaypointType "CYCLE";
} forEach (_AK_Indep_Air select 2);
 
_AK_East_Air = [4, "rhs_mig29s_vmf", [0, 0 ,500], _AZ, east, 1000, "AWARE", 500, 4] spawn AK_fnc_spacedvehicles;
{ 
	_wp = _x addWaypoint [[0,0,0], 0]; 
	_wp setWaypointType "CYCLE";
 } forEach (_AK_East_Air_Air select 2);
 
 AK_blufor = [{
[32, "LOP_GRE_Infantry_Rifleman", [14600, 21700 ,0], [14600, 20710, 0], west, 5, "AWARE", 500, 8] spawn AK_fnc_spacedvehicles;
}, 900] call CBA_fnc_addPerFrameHandler;

AK_Opfor = [{
[32, "LOP_BH_Infantry_Rifleman_lite", [14610, 19700 ,0], [14600, 20710, 0], east, 5, "AWARE", 500, 8] spawn AK_fnc_spacedvehicles;
},600] call CBA_fnc_addPerFrameHandler;
 
};
