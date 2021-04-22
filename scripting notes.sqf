One-Way vehicles

CBA_fnc_waitAndExecute

createVehicle command

//does not work, because an empty vehicle is local to the server, and Waypoint Statments are executed on the clients
[{
private _position = [21100, 7500];
private _vehicle = "O_APC_Wheeled_02_rcws_F" createVehicle _position;
private _group = createVehicleCrew _vehicle;
private _wp = _group addWaypoint [_position, 300];
_wp setWaypointStatements ["true", "deleteVehicle this; {deleteVehicle _x} forEach (units (group this));
"];}, [], 5] call CBA_fnc_waitAndExecute;

You could make the real script a function that will call the function again. As a infinite loop with random numbers so like random (150) -> will be a random number under 150

private _vehicle = "LIB_Kfz1" createVehicle [0,0,0];   createVehicleCrew _vehicle;   
private _grp = group _vehicle;    
private _wp = _grp addWaypoint [[0,0,0], 50]; 
_wp setWaypointStatements ["true","deleteVehicle this;{deleteVehicle _x} forEach units group this;
"]; 

{deleteVehicle _x} forEach (units (group this));
deleteVehicle this;

[vehicle_22,1db08bfc200# 1813639: slingload_01_ammo_f.p3d REMOTE,vehicle_21]