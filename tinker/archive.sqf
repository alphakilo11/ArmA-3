//works but vehicles are not deleted
AK_fnc_delete = {
params ["_groups"];
{
	{
		deleteVehicle _x;
	} forEach (units _x);
	deleteGroup _x;
} forEach _groups;
};

//works to delete vehicles
_vehlist = [];
{
	{
		_vehlist pushBackUnique vehicle _x;
	} forEach (units _x);
} forEach neuegruppen;
_vehlist


/* doesn't work
while {alive player} do {  
private _vehicle = "B_MRAP_01_F" createVehicle [23500,18400,0];   
createVehicleCrew _vehicle;  
private _grp = group _vehicle;   
private _wp = _grp addWaypoint [[23500,18400,0], 50];  
_wp setWaypointStatements ["true", "{this deleteVehicleCrew _x} forEach crew this;  
deleteVehicle this;"] ;} 
private _time = random [10, 60,120];
sleep _time;};

private _auto = "B_MRAP_01_F" createVehicle [8000,10100,0];   
createVehicleCrew _auto;  
private _grp = group _auto;   
private _wp = _grp addWaypoint [[8000,10100,0], 50];  
_wp setWaypointStatements ["true", "deleteVehicle _auto; {deleteVehicle _x} forEach (crew _auto);  
deletegroup (group _auto)"] ;} 


if (alive _plane) then {
		_group = group _plane;
		_crew = crew _plane;
		deletevehicle _plane;
		{deletevehicle _x} foreach _crew;
		deletegroup _group;
*/


//does not work, because an empty vehicle is local to the server, and Waypoint Statments are executed on the clients
[{
private _position = [21100, 7500];
private _vehicle = "O_APC_Wheeled_02_rcws_F" createVehicle _position;
private _group = createVehicleCrew _vehicle;
private _wp = _group addWaypoint [_position, 300];
_wp setWaypointStatements ["true", "deleteVehicle this; {deleteVehicle _x} forEach (units (group this));
"];}, [], 5] call CBA_fnc_waitAndExecute;
