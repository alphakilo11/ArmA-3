//should I split AK_fnc_spacedvehicles
[] spawn {
	AZ = [11850, 20750, 0]; //3D value required for CBA_fnc_task to work
	private _numberofgroups = 10;
	
	
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

//spawns groups and lets them move to a point
testvar = {
for "_x" from 1 to 12 do {
	_gruppe = [[14431.2,17051.4,0], EAST, configFile >> "CfgGroups" >> "East" >> "rhs_faction_vmf" >> "rhs_group_rus_vmf_infantry" >> "rhs_group_rus_vmf_infantry_squad"] call BIS_fnc_spawnGroup;
	_gruppe deleteGroupWhenEmpty true;
	_gruppe addWaypoint [[11845.3,20761.6,0], 500];
}
};
