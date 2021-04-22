"rhs_t80"
"rhs_t72ba_tv"
"B_T_MBT_01_TUSK_F"
"B_MBT_01_mlrs_F"
"rhs_t90_tv"
"LOP_ISTS_OPF_T72BA"
"LOP_ISTS_T55" (desert camo)
"LOP_ISTS_OPF_BMP2" (desert camo)

//worked fine
//TODO refine loop
//TODO create unique group names (currently all created groups have the same name)
//TODO use CBA_attack_module
//TODO make group name auto-changable

//Version 4
//ADDED Group loop
//ADDED RemoteExec


{
private _groupnumber = 3;
for "_i" from 1 to _groupnumber do {
private _vfgrm = position vfgrm;
private _radius = 500;
private _side = east;
private _number = 3;
private _type = "LOP_ISTS_OPF_BMP2";
private _marschziel = position AZ;

_gruppe = createGroup [_side, true];
for "_i" from 1 to _number do
{
private _position = [_vfgrm, 0 , _radius, 0, 0, 0.1] call BIS_fnc_findSafePos;
[_position, (_position getDir _marschziel), _type, _gruppe] call BIS_fnc_spawnVehicle;
};

_gruppe addWaypoint [_marschziel, 500];

_gruppe setSpeedMode "FULL"
};
} remoteExec ["call", 2];



//Version 3
//23.8095 ms
//ADDED loop
//works on server, headless client and clients
private _center = [23500, 16500, 0];
private _radius = 500;
private _side = west;
private _number = 2;
private _type = "B_T_MBT_01_TUSK_F";
private _marschziel = [14500,16500,0];

//create group and delete it when empty
_gruppe = createGroup [_side, true];
//find a safe Position on land
for "_i" from 1 to _number do
{
private _position = [_center, 0 , _radius, 0, 0, 0.1] call BIS_fnc_findSafePos;
//spawn the vehicle
[_position, (_positon getDir _marschziel), _type, _gruppe] call BIS_fnc_spawnVehicle;
};

//assign a move waypoint
_gruppe addWaypoint [_marschziel, 500];

//units will not wait for their group (helps to speed up the whole thing, because some AI tends to disembark and slowdown the whole group)
_gruppe setSpeedMode "FULL" 



//Version 2
//works on server, headless client and clients
private _center = [26950, 24950, 0];
private _radius = 1000;
private _side = west;
private _type = "B_T_MBT_01_TUSK_F";
private _marschziel = [20300,11700,0];

//create group and delete it when empty
_gruppe = createGroup [_side, true];
//find a safe Position on land
private _position = [_center, 0 , _radius, 0, 0, 0.1] call BIS_fnc_findSafePos;
//spawn the vehicle
[_position, (_positon getDir _marschziel), _type, _gruppe] call BIS_fnc_spawnVehicle;
//assign a move waypoint
_gruppe addWaypoint [_marschziel, 500];


//Version 1
private _position = screenToWorld [0.5,0.5];
private _side = west;
private _type = "B_T_MBT_01_TUSK_F";
private _kanone = createVehicle [_type, _position, [], 50, "NONE"]

Gruppe3 = createGroup east;
private _position = [(screenToWorld [0.5,0.5]), 0 , 100, 0, 0, 0.1] call BIS_fnc_findSafePos;
private _type = "rhs_t80";
[_position, 180, _type, Gruppe3] call BIS_fnc_spawnVehicle;

private _position = [(screenToWorld [0.5,0.5]), 0 , 100, 0, 0, 0.1] call BIS_fnc_findSafePos;
private _type = "rhs_t80";
[_position, 180, _type, Gruppe3] call BIS_fnc_spawnVehicle;

private _position = [(screenToWorld [0.5,0.5]), 0 , 100, 0, 0, 0.1] call BIS_fnc_findSafePos;
private _type = "rhs_t80";
[_position, 180, _type, Gruppe3] call BIS_fnc_spawnVehicle;

private _marschziel = [20300,11700,0];
Gruppe3 addWaypoint [_marschziel, 500];
