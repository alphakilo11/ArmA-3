/*
I want a Battlefield that feels authentic.
This is already very taxing in terms of performance - try without nice-to-have mods?
GLITCH the random spawning can result in the battle not starting for some time.
BUG spawning (even on dedicated server) studders clients - spawn instead of call?
BUG when the function runs for a long time, it will completely overwhelm the game engine
IDEA weather changes?
IDEA accelerate time?
TODO Spawn flares only at night
TODO use https://community.bistudio.com/wiki/BIS_fnc_randomPos and https://community.bistudio.com/wiki/BIS_fnc_findSafePos
TODO add planes?
TODO add vehicles?


*/

//I use global variables iot make changes on-the-fly.
AK_var_westunits = "configName _x isKindOf 'CAManBase' and getNumber (_x >> 'scope') == 2 and getNumber (_x >> 'side') == 1" configClasses (configFile >> "CfgVehicles") apply {configName _x};
AK_var_eastUnits = "configName _x isKindOf 'CAManBase' and getNumber (_x >> 'scope') == 2 and getNumber (_x >> 'side') == 0" configClasses (configFile >> "CfgVehicles") apply {configName _x};
AK_pos_Center = [14602, 20777, 0];
AK_pos_spawnWest = AK_pos_Center vectorAdd [-1000, 0, 0];
AK_pos_spawnEast = AK_pos_Center vectorAdd [1000, 0, 0];

//almost the same code twice - this cries for a function
AK_blufor = [{
if (random 1 <= (1/6)) then {
	for "_i" from 1 to 4 do {
		private _units = [];
		for "_i" from 1 to 8 do {
			_units pushBack (selectRandom AK_var_westunits);
		};
		private _grp =[AK_pos_spawnWest, west, _units] call BIS_fnc_spawnGroup; 
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [AK_pos_Center, 50];
	};
};
}, 100] call CBA_fnc_addPerFrameHandler; 
 
AK_Opfor = [{
if (random 1 <= (1/6)) then {
	for "_i" from 1 to 4 do {
		private _units = [];
		for "_i" from 1 to 8 do {
			_units pushBack (selectRandom AK_var_eastUnits);
		};
		private _grp =[AK_pos_spawnEast, east, _units] call BIS_fnc_spawnGroup; 
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [AK_pos_Center, 50];
	};
};
}, 100] call CBA_fnc_addPerFrameHandler; 

AK_ambientArtillery = [{ 
if (random 1 <= 0.1) then {
	_shelltype = "Sh_155mm_AMOS";    
	_shellspread = 1000;           
	_position = AK_pos_Center vectorAdd [0, 0, 150]; 
	_shell = createVehicle [_shelltype, _position, [], _shellspread];       
	_shell setVelocity [0, 0, -1];
};
}, 10] call CBA_fnc_addPerFrameHandler;

AK_ambientFlares = [{
if (random 1 >= 0.3) then {
	_shelltype = "F_40mm_White";    
	_shellspread = 100;           
	_position = AK_pos_Center vectorAdd [0, 0, 150]; 
	_shell = createVehicle [_shelltype, _position, [], _shellspread];       
	_shell setVelocity [0, 0, -1];
};
}, 15] call CBA_fnc_addPerFrameHandler; 