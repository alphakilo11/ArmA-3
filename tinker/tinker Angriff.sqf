//creates a number of groups 1 km from AZ which move until reaching LdA. There, passengers will dismount and charge the AZ.
//Behavior when receiving fire before reaching LdA is unpredictable.
//REQUIRED: CBA, RHS
//GLITCH dismount sometimes happens delayed - but that's the fog of war
//BUG does not work with >1 vehicle/group
//CHECK is _absitzen even necessary? Infantry might dismount on their own as soon as combat starts.
//TODO fix units not dismounting on server (The OnActivation code is executed globally, a.k.a on every client!)
//TODO make _vfgrm flexible
//TODO remove messages and diag_log
//TODO include GKGF-density factor 28,2 [what? apples?]
//TODO remove RHS dependency
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
