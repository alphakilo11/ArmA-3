//creates a number of groups 1 km from AZ which move until reaching LdA. There, passengers will dismount and charge the AZ. Behavior when under fire before reaching LdA is unpredictable.
//REQUIRED: CBA, RHS
//GLITCH dismount sometimes happens delayed - but that's the fog of war
//BUG does not work with >1 vehicle/group
//CHECK is _absitzen even necessary? Infantry might dismount on their own as soon as combat starts.
//TODO fix units not dismounting on server (The OnActivation code is executed globally, a.k.a on every client!)
//TODO make _vfgrm flexible
//TODO remove messages and diag_log
//TODO include GKGF-density factor 28,2 [what? apples?]
//IDEA convert to defence after taking objective
//IDEA create an array as a single global variable for each spawned group
//IDEA Make speeds according to Handakt Taktik
//IDEA Space platoons iot avoid ingress in single file (changing behaviour to "COMBAT" does not really change anything)
//IDEA pass _numberofgroups as param

//Version 6
//WORKS on DS
//CHANGED BMP2 to BTR80 by Default  (to avoid Mod-related problems)
//ADDED passed _numberofgroups to the spawn function BUT it is presumably not defined when the _absitzen Waypoint is executed.

[] spawn {
	AZ = [21100, 7400, 0]; //3D value required for CBA_fnc_task to work
	private _numberofgroups = 1;
	
	
	for "_i" from 1 to _numberofgroups step 1 do {
		uiSleep 0.1;
		[_numberofgroups] spawn {
			diag_log format ["%1 ist die Zahl!", _this];
			private _side = East;
			private _grouptype = configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Mechanized" >> "OIA_MechInfSquad";
			
			private _vfgrm = [[(AZ select 0), ((AZ select 1) + 1000)], 0, 100] call BIS_fnc_findSafePos;
			private _gruppe = [_vfgrm, _side, _grouptype,[],[],[],[],[],(_vfgrm getDir AZ)] call BIS_fnc_spawnGroup;
			_gruppe deleteGroupWhenEmpty true;
			systemChat format ["%1 spawned at %2. Will attack %3.", _gruppe, _vfgrm, AZ];
			private _LdA = [(AZ select 0), ((AZ select 1) + 300)];
			private _absitzen = _gruppe addWaypoint [_LdA, 100];
			_absitzen setWaypointStatements ["true", "
			private _gruppe = group this;
			private _vehicle = vehicle this;
			systemChat format ['Group %1 dismounts from vehicle %2 and will attack %3! AZ radius: %4 m.', _gruppe, _vehicle, AZ, _this]; 
			private _passengers = fullCrew [_vehicle, 'cargo']; 
			private _array = []; 
			{_array pushBack (_x select 0)} 
			forEach _passengers; 
			{unassignVehicle _x} forEach _array; 
			[(group this), AZ, (_this * 28.2)] call CBA_fnc_taskAttack;
			"]; 


			//mount (teleport)
			private _array = [];
			private _kfz = "";
			{ 
				if (isNull objectParent _x) then { 
					_array pushBack _x; 
				} else { 
					_kfz = (objectParent _x); 
					systemChat format ["%1 is already in %2.", _x, _kfz];
				}; 
			} forEach units _gruppe; 
			{
				_x moveInCargo _kfz;
			} forEach _array;

			systemChat format ["Vehicle: %1", _kfz]; 
			systemChat format ["%1 mounted", _gruppe];
		};
	};
};
*/



//Version 5
//WORKS in local MP and on DS
//FIXED rearranged code
//INCLUDED align vehicles into BIS_fnc_spawnGroup
//ADDED Spawn
//ADDED loop
//ADDED _grouptype and _side variable
//ADDED BIS_fnc_findSafePos
//ADDED 3. dimension to AZ
/*
[] spawn {
	AZ = [21100, 7400, 0];
	private _numberofgroups = 10;
	
	
	for "_i" from 1 to _numberofgroups step 1 do {
		uiSleep 0.1;
		[] spawn {
		private _side = East;
		private _grouptype = configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper";
		
		private _vfgrm = [[(AZ select 0), ((AZ select 1) + 1000)], 0, 100] call BIS_fnc_findSafePos;
		private _gruppe = [_vfgrm, _side, _grouptype,[],[],[],[],[],(_vfgrm getDir AZ)] call BIS_fnc_spawnGroup;
		_gruppe deleteGroupWhenEmpty true;
		systemChat format ["%1 spawned at %2. Will attack %3.", _gruppe, _vfgrm, AZ];
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


		//mount (teleport)
		private _array = [];
		private _kfz = "";
		{ 
			if (isNull objectParent _x) then { 
				_array pushBack _x; 
			} else { 
				_kfz = (objectParent _x); 
				systemChat format ["%1 is already in %2.", _x, _kfz];
			}; 
		} forEach units _gruppe; 
		{
			_x moveInCargo _kfz;
			} 
		forEach _array;

		systemChat format ["Vehicle: %1", _kfz]; 
		systemChat format ["%1 mounted", _gruppe];
		};
	};
};
*/

//Version 4
//WORKS in DS MP and local, (on NON-dedicated Server soldiers will dismount when reaching AZ)
//ADDED align vehicle
/*
AZ = [21100, 7400];
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
{
	_x moveInCargo _kfz;
	} 
forEach _array;

systemChat format ["Vehicle: %1", _kfz]; 
systemChat format ["%1 mounted", _gruppe];
//align vehicle
_kfz setDir ((getPosATL _kfz) getDir AZ);
*/



/*Version 3
WORKS in DS MP
CHANGED all variables to local except for AZ
*/
/*
AZ = [21100, 7400];
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
{
	_x moveInCargo _kfz;
	} 
forEach _array;
systemChat format ["Vehicle: %1", _kfz]; 
systemChat format ["%1 mounted", _gruppe];
*/


//Version 2
//MP works
/*
AZ = [1000, 1000];
private _vfgrm = [(AZ select 0), ((AZ select 1) + 400)];
gruppe = [_vfgrm, East, (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_bmp2" >> "rhs_group_rus_msv_bmp2_squad_mg_sniper")] call BIS_fnc_spawnGroup;
gruppe deleteGroupWhenEmpty true;
private _LdA = [(AZ select 0), ((AZ select 1) + 300)];
private _absitzen = gruppe addWaypoint [_LdA, 100];
_absitzen setWaypointStatements ["true", "
systemChat format ['%1 sitzt ab!', gruppe];
_passengers = fullCrew [kfz, 'cargo']; 
_array = []; 
{_array pushBack (_x select 0)} 
forEach _passengers; 
{unassignVehicle _x} forEach _array; 
[gruppe, AZ, 100] call CBA_fnc_taskAttack;
"];
systemChat format ["%1 spawned at %2. Will attack %3.", gruppe, _vfgrm, AZ];

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
*/


//Version 1
//TODO when reaching the waypoint _gruppe and _AZ is no longer defined
//TODO units will not mount the vehicle
/*
private _AZ = position unlucky;
private _vfgrm = [(_AZ select 0), ((_AZ select 1) + 1000)];
private _LdA = [(_AZ select 0), ((_AZ select 1) + 300)]; 
private _side = West;
private _grp = configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad";
private _gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup;
private _absitzen = _gruppe addWaypoint [_LdA, 100];
_absitzen setWaypointStatements ["true", "systemChat format ['%1 sitzt ab!', _gruppe];[_gruppe, _AZ, 100] call CBA_fnc_taskAttack;
"];
_gruppe deleteGroupWhenEmpty true; 
systemChat format ["%1 spawned at %2. Will attack %3.", _gruppe, _vfgrm, _AZ];

_position = [13000, 18000];
_side = West;
_grp = B_W_InfSquad;
[_position, _side, _grp] call BIS_fnc_spawnGroup;


[[4000, 4000, 0], West, (configFile >> "CfgGroups" >> "West" >> "LOP_CDF" >> "Mechanized" >> "LOP_CDF_Mech_squad_BMP1")] call BIS_fnc_spawnGroup; 


//works
_groups = [];  
{  
 _faction = _x;  
 {  
  _type = _x;  
  {  
   _groups pushBack _x;  
  } forEach ("true" configClasses _type);  
 } forEach ("true" configClasses _faction);  
} forEach ("true" configClasses (configFile >> "CfgGroups" >> "West"));  
_grp = selectRandom _groups; 
 //spawn group  
private _vfgrm = [4000, 4200];  
private _marschziel = [5000, 5200]; 
private _side = West;  
_gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup;  
_gruppe addWaypoint [_marschziel, 100];  
_gruppe deleteGroupWhenEmpty true;  
diag_log format ["%1 spawned at %2. Will move to %3.", _gruppe, _vfgrm, _marschziel];
_grp;
*/