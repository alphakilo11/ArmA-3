//Example of how to interact with AK_fnc_spacedvehicles

//spawn units
neuegruppen = [14, "B_MBT_01_cannon_F", [23000,18000,0], [15000,17000,0], 50, "COMBAT"] call AK_fnc_spacedvehicles;
neuegruppen;

//add additional Waypoint
{_x addWaypoint [[10000,10000,0],500]} forEach neuegruppen;

//delete
[neuegruppen] call AK_fnc_delete;

