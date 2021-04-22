//HINT While Condition code is evaluated on the group owner's machine, OnActivation code is executed globally, a.k.a on every client!

//MP works fine if locally executed
//Version 5
AZ = [4000, 4000];
private _vfgrm = [(AZ select 0), ((AZ select 1) + 400)];
private _gruppe = [_vfgrm, East, (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper")] call BIS_fnc_spawnGroup;
_gruppe deleteGroupWhenEmpty true;
private _LdA = [(AZ select 0), ((AZ select 1) + 300)];
private _absitzen = _gruppe addWaypoint [_LdA, 100];
_absitzen setWaypointStatements ["true", "
private _gruppe = group this;
private _vehicle = vehicle this;
systemChat format ['Group %1 dismounts from vehicle %2 and will attack %3!', _gruppe, _vehicle, AZ]; 
private _passengers = fullCrew [_vehicle, 'cargo']; 
private _array = []; 
{_array pushBack (_x select 0)} 
forEach _passengers; 
{unassignVehicle _x} forEach _array; 
[(group this), AZ, 100] call CBA_fnc_taskAttack;
"]; 
systemChat format ["%1 spawned at %2. Will attack %3.", _gruppe, _vfgrm, AZ];

//mount (teleport)
private _array = [];
private _kfz = "bla"; 
{ 
	if (isNull objectParent _x) then { 
		_array pushBack _x; 
	} else { 
		_kfz = (objectParent _x); 
		systemChat format ["%1 is already in %2.", _x, _kfz];
	}; 
} forEach units _gruppe; 
//mount units
{
	_x moveInCargo _kfz;
	} 
forEach _array; 
systemChat format ["Vehicle: %1", _kfz]; 
systemChat format ["%1 mounted", _gruppe];



//Version 4
gruppe = [[11800, 20000], East, (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper")] call BIS_fnc_spawnGroup; 
//mount (teleport)
_array = []; 
{ 
 if (isNull objectParent _x) then { 
  _array pushBack _x; 
 } else { 
  kfz = (objectParent _x); 
  systemChat format ["%1 is already in a vehicle.", _x]; 
 }; 
} forEach units gruppe; 
//mount units 
{_x moveInCargo (kfz)} 
forEach _array; 
systemChat format ["Vehicle: %1", kfz]; 
systemChat format ["%1 mounted", gruppe];


//mount (animated)
_array = []; 
{ 
 if (isNull objectParent _x) then { 
  _array pushBack _x; 
 } else { 
  kfz = (objectParent _x); 
  systemChat format ["%1 is already in a vehicle.", _x]; 
 }; 
} forEach units gruppe; 
//mount units 
{_x assignAsCargo kfz;
[_x] orderGetIn true;} 
forEach _array; 
systemChat format ["Vehicle: %1", kfz]; 
systemChat format ["%1 mounted", gruppe]; 


//dismount (animated) 
_passengers = fullCrew [kfz, "cargo"]; 
_array = []; 
{_array pushBack (_x select 0)} 
forEach _passengers; 
{unassignVehicle _x} forEach _array; 


// Version 3
//ADDED mount (animated)
//MP works fine
gruppe = [[11800, 20000], East, (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper")] call BIS_fnc_spawnGroup; 
//mount (teleport)
_array = []; 
{ 
 if (isNull objectParent _x) then { 
  _array pushBack _x; 
 } else { 
  kfz = (objectParent _x); 
  systemChat format ["%1 is already in a vehicle.", _x]; 
 }; 
} forEach units gruppe; 
//mount units 
{_x moveInCargo (kfz)} 
forEach _array; 
systemChat format ["Vehicle: %1", kfz]; 
systemChat format ["%1 mounted", gruppe];


//mount (animated)
_array = []; 
{ 
 if (isNull objectParent _x) then { 
  _array pushBack _x; 
 } else { 
  kfz = (objectParent _x); 
  systemChat format ["%1 is already in a vehicle.", _x]; 
 }; 
} forEach units gruppe; 
//mount units 
{_x assignAsCargo kfz;
[_x] orderGetIn true;} 
forEach _array; 
systemChat format ["Vehicle: %1", kfz]; 
systemChat format ["%1 mounted", gruppe]; 


//dismount (animated) 
_passengers = fullCrew [kfz, "cargo"]; 
_array = []; 
{_array pushBack (_x select 0)} 
forEach _passengers; 
{unassignVehicle _x} forEach _array; 



//Version 2
//SP works, but units immediately start to dismount
gruppe = [[11800, 20000], East, (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper")] call BIS_fnc_spawnGroup;

//mount (teleport)
_array = [];
{
	if (isNull objectParent _x) then {
		_array pushBack _x;
	} else {
		kfz = (objectParent _x);
		systemChat format ["%1 is already in a vehicle.", _x];
	};
} forEach units gruppe;
//mount units
{_x moveInCargo (kfz)}
forEach _array;
systemChat format ["Vehicle: %1", kfz];
systemChat format ["%1 mounted", gruppe];

//dismount (animated)
_passengers = fullCrew [kfz, "cargo"];
_array = [];
{_array pushBack (_x select 0)}
forEach _passengers;
{unassignVehicle _x} forEach _array;


//Version 1
_array = [];
{
	if (isNull objectParent _x) then {
		_array pushBack _x;
	} else {
		kfz = (objectParent _x);
		systemChat format ["%1 is already in a vehicle.", _x];
	};
} forEach units gruppe;
//mount units
{_x moveInAny (kfz)}
forEach _array;
systemChat format ["Vehicle: %1", kfz];
systemChat format ["%1 mounted", gruppe];



//dismount vehicle
//when the crew forms a different group, than the passengers they will not remount. if not than some do and some don't remount... tested with unassignVehicle, commandGetOut, doGetOut, moveOut.
//leaveVehicle will make everyone disembark
//TODO sometimes crew sits in turrets
_passengers = fullCrew [unlucky, "cargo"];
_array = [];
{_array pushBack (_x select 0)}
forEach _passengers;
{unassignVehicle _x} forEach _array;


//mount vehicle
//works
//TODO change group leader if mounted
//determine which units are not mounted
_array = [];
{
	if (isNull objectParent _x) then {
		_array pushBack _x;
	} else {
		systemChat format ["%1 is already in a vehicle.", _x];
	};
} forEach units unlucky;
//mount units
{_x moveInAny (vehicle unlucky)}
forEach _array;




//works
_array = [];
{
	if (isNull objectParent _x) then {
		_array pushBack _x;
	} else {
		systemChat format ["%1 is already in a vehicle.", _x];
	};
} forEach units unlucky;
_array;



//returns the vehicle for mounted units and NULL-object for unmounted units

_array = [];
{_array pushBack objectParent _x;}
forEach units unlucky;
_array;
//result = [B Alpha 1-2:3,B Alpha 1-2:3,B Alpha 1-2:3,<NULL-object>,<NULL-object>,<NULL-object>,<NULL-object>,<NULL-object>,<NULL-object>,<NULL-object>,<NULL-object>]

