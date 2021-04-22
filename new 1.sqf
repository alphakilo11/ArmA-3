[] spawn {
	AZ = [21100, 7400, 0]; //3D value required for CBA_fnc_task to work
	private _numberofgroups = 30;
	
	
	for "_i" from 1 to _numberofgroups step 1 do {
		uiSleep 1;
		[_numberofgroups] spawn {
		diag_log format ["%1 ist die Zahl!", _this];
		private _side = East;
		private _grouptype = configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Mechanized" >> "OIA_MechInfSquad";
		
		private _vfgrm = [[(AZ select 0), ((AZ select 1) + 10000)], 0, 846] call BIS_fnc_findSafePos;
		private _gruppe = [_vfgrm, _side, _grouptype,[],[],[],[],[],(_vfgrm getDir AZ)] call BIS_fnc_spawnGroup;
		_gruppe deleteGroupWhenEmpty true;
		systemChat format ["%1 spawned at %2. Will attack %3.", _gruppe, _vfgrm, AZ];
		_gruppe setBehaviour "COMBAT";
		[_gruppe, AZ, 846] call CBA_fnc_taskAttack;


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
