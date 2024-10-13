/* ----------------------------------------------------------------------------
Function: AK_fnc_endlessconvoy

Description:
    Create a vehicle moving from A to B. Upon reaching B it is deleted

Parameters:
    - Type of Vehicle (Config Entry)
    - Starting Position (XYZ)
    - End Location (XYZ)

Optional:
- Speed Limit (km/h)

Example:
    (begin example)
    ["B_Truck_01_box_F", [0,0,0], [5000,5000,0]] call AK_fnc_endlessconvoy
    (end)

Advanced Example:
    (begin example)
    [[],{Testversuch = [] spawn {
    for "_x" from 0 to 1 step 0 do {
    ["B_Truck_01_box_F", [0,0,0], [5000,5000,0]] call AK_fnc_endlessconvoy;
    sleep 15;
    };
    };}] remoteExec ["call", 2];

    [[],{terminate Testversuch;}] remoteExec ["call", 2];
    (end)
Returns:
    Nil

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_endlessconvoy = {
	params [
		"_verhicletype",
		"_startloc",
		"_endloc",
		["_speedlimit", -1]
	];
	private _vehicle = _verhicletype createVehicle _startloc;
	_vehicle setDir (_startloc getDir _endloc);
	createVehicleCrew _vehicle;
	_vehicle limitSpeed _speedlimit;
	private _grp = group _vehicle;
	_grp setBehaviour "SAFE";
	private _wp = _grp addWaypoint [_endloc, 50];
	_wp setWaypointStatements ["true", "_vehicleleader = vehicle leader this;
		{
			deleteVehicle _x
		} forEach crew _vehicleleader + [_vehicleleader];
	deleteGroup (group this);"];
};
