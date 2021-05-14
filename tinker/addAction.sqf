//adds an action to the selected object
(_this select 1) addAction ["Start Air Battle", {
systemChat "Air Battle commencing!";
_AK_Indep_Air = [4, "I_Plane_Fighter_04_F", [30000, 30000 ,15000], (position player), independent, 1000, "AWARE", 500, 4] spawn AK_fnc_spacedvehicles;
{ 
 _wp = _x addWaypoint [[0,0,0], 0]; 
 _wp setWaypointType "CYCLE";} forEach (_AK_Indep_Air select 2);
 
_AK_Indep_Air = [4, "rhs_mig29s_vmf", [0, 0 ,500], (position player), east, 1000, "AWARE", 500, 4] spawn AK_fnc_spacedvehicles;

{ 
 _wp = _x addWaypoint [[0,0,0], 0]; 
 _wp setWaypointType "CYCLE";} forEach (_AK_Indep_Air select 2);
}]





