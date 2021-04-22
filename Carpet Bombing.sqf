//both work in Achilles Execute Code Module (local&server) but not in Debug Console. u/s global (will spawn multiples).
//use: call bis_fnc_spawnVehicle ?
//TODO use CBA_fnc_perFrameHandler
_unlucky = "B_Plane_CAS_01_dynamicLoadout_F" createVehicle [8000,10100,150];
createVehicleCrew _unlucky;
_unlucky setVelocity [0,150,550];
(group _unlucky) addWaypoint [[8000,10100,0],500];
uisleep 5;
while {alive _unlucky} do {"Bo_GBU12_LGB" createVehicle (_unlucky getPos [0,0]); uisleep 5;};

//works on dedicated server
_flieger = createVehicle ["B_Plane_CAS_01_dynamicLoadout_F", [8000,10100,0], [], 0, "FLY"]; 
createVehicleCrew _flieger; 
(group _flieger) addWaypoint [[1000,12000,0],500]; 
uisleep 5; 
while {alive _flieger} do {"Bo_GBU12_LGB" createVehicle (_flieger getPos [0,0]); uisleep 5;};

//create a Vehicle at high altitude
"Anfang" setMarkerPos [8000,10100,500];
createVehicle ["B_Heli_Transport_03_unarmed_F", getMarkerPos "Anfang",[],0, "FLY"];

//works, but plane immediately dives
_flieger = createVehicle ["B_Plane_CAS_01_dynamicLoadout_F", [8000,10100,0], [], 0, "FLY"];  
createVehicleCrew _flieger; 
_flieger setPosATL [getPosATL _flieger select 0, getPosATL _flieger select 1, (getPosATL _flieger select 2) + 500];
(group _flieger) addWaypoint [[1000,12000,0],500];
_flieger flyinHeight 500;  
uisleep 5;  
while {alive _flieger} do {"Bo_GBU12_LGB" createVehicle (_flieger getPos [0,0]); uisleep 5;};

//works locally but doesnt drop bombs, doesn't work on dedicated server.
_flieger = createVehicle ["B_Plane_CAS_01_dynamicLoadout_F", [8000,10100,0], [], 0, "FLY"];
createVehicleCrew _flieger; 
_flieger setPosATL [getPosATL _flieger select 0, getPosATL _flieger select 1, (getPosATL _flieger select 2) + 500];
(group _flieger) addWaypoint [[1000,12000,0],500];
_flieger flyinHeight 500;  
uisleep 15;
if (alive _flieger) then {
		_group = group _flieger;
		_crew = crew _flieger;
		deletevehicle _flieger;
		{deletevehicle _x} foreach _crew;
		deletegroup _group;
	};

if (alive _plane) then {
		_group = group _plane;
		_crew = crew _plane;
		deletevehicle _plane;
		{deletevehicle _x} foreach _crew;
		deletegroup _group;
	};

"B_Heli_Transport_03_unarmed_F"