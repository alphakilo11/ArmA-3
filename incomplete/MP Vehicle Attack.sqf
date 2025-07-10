"rhs_t80"
"rhs_t72ba_tv"
"B_T_MBT_01_TUSK_F"
"B_MBT_01_mlrs_F"
"rhs_t90_tv"
"LOP_ISTS_OPF_T72BA"
"LOP_ISTS_T55" (desert camo)
"LOP_ISTS_OPF_BMP2" (desert camo)

// worked fine
// TODO refine loop
// TODO create unique group names (currently all created groups have the same name)
// TODO use CBA_attack_module
// TODO make group name auto-changable
// TODO convert to function

// Version 4
// ADDED group loop
// ADDED remoteExec

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
			private _position = [_vfgrm, 0, _radius, 0, 0, 0.1] call BIS_fnc_findSafePos;
			[_position, (_position getDir _marschziel), _type, _gruppe] call BIS_fnc_spawnVehicle;
		};

		_gruppe addWaypoint [_marschziel, _radius];

		_gruppe setSpeedMode "FULL"
	};
} remoteExec ["call", 2];