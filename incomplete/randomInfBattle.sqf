/*
I want a Battlefield that feels authentic.
This is already very taxing in terms of performance - try without nice-to-have mods?
IDEA weather changes?
IDEA accelerate time?
TODO Spawn flares only at night
TODO add planes?
TODO add vehicles?
CHECK does the random number work with CBA_fnc_addPerFrameHandler?

*/

//I use global variables iot make changes on-the-fly.
AK_var_westunits = "configName _x isKindOf 'CAManBase' and getNumber (_x >> 'scope') == 2 and getNumber (_x >> 'side') == 1" configClasses (configFile >> "CfgVehicles") apply {configName _x};
AK_var_eastUnits = "configName _x isKindOf 'CAManBase' and getNumber (_x >> 'scope') == 2 and getNumber (_x >> 'side') == 0" configClasses (configFile >> "CfgVehicles") apply {configName _x};
AK_pos_Center = [14602, 20777, 0];
AK_pos_spawnWest = [13602, 20777, 0];
AK_pos_spawnEast = [15602, 20777, 0];

//almost the same code twice - this cries for a function
AK_blufor = [{ 
	for "_i" from 1 to 4 do {
		private _units = [];
		for "_i" from 1 to 8 do {
			_units pushBack (selectRandom AK_var_westunits);
		};
		private _grp =[AK_pos_spawnWest, west, _units] call BIS_fnc_spawnGroup; 
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [AK_pos_Center, 50];
	};
}, 600] call CBA_fnc_addPerFrameHandler; 
 
AK_Opfor = [{ 
	for "_i" from 1 to 4 do {
		private _units = [];
		for "_i" from 1 to 8 do {
			_units pushBack (selectRandom AK_var_eastUnits);
		};
		private _grp =[AK_pos_spawnEast, east, _units] call BIS_fnc_spawnGroup; 
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [AK_pos_Center, 50];
	};
},600] call CBA_fnc_addPerFrameHandler; 

AK_ambientArtillery = [{ 
_shelltype = "Sh_155mm_AMOS";    
_shellspread = 2000;           
_position = AK_pos_Center vectorAdd [0, 0, 150]; 
_shell = createVehicle [_shelltype, _position, [], _shellspread];       
_shell setVelocity [0, 0, -1];
},random [5, 10, 15]] call CBA_fnc_addPerFrameHandler;

AK_ambientFlares = [{ 
_shelltype = "F_40mm_White";    
_shellspread = 100;           
_position = AK_pos_Center vectorAdd [0, 0, 150]; 
_shell = createVehicle [_shelltype, _position, [], _shellspread];       
_shell setVelocity [0, 0, -1];
},random [5, 10, 15]] call CBA_fnc_addPerFrameHandler; 