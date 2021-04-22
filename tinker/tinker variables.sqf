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

//test assignedVehicleRole
_array = [];
{_array pushBack assignedVehicleRole _x;}
forEach units _gruppe;
if ((_array select 1) == []) then {systemChat "true";}
else {systemChat "false";};