/*Spieler ausleuchten
	TODO
	MERGE the code
	randomize intervall
	disable during daylight
	use "last known position"
	optional include AI skill
	include:
	AK_ausleuchten = [{
		private _shell = "rhs_ammo_flare_m485" createVehicle ([14600, 20700, 0] vectorAdd [0, 0, 500]);      
		_shell setVelocity [0, 0, -1];
	}, 120] call CBA_fnc_addperFrameHandler;
	transform to function
*/

// Version 1
randomflare = [{
	private _allHCs = entities "HeadlessClient_F";
	private _humanPlayers = allPlayers - _allHCs;
	_humanPlayers = count _humanPlayers;
	if (_humanPlayers > 0) then {
		private ["_shelltype", "_shellspread", "_nshell", "_shell", "_i", "_delay", "_altitude"];
		_shelltype = "F_40mm_White";// "Flare_82mm_AMOS_White" does not work
		_shellspread = 250;
		_position = [14500, 17600, 150];
		_shell = createVehicle [_shelltype, _position, [], _shellspread];
		_shell setVelocity [0, 0, -1];
	} else {
		diag_log "No players present - random flares cancelled";
	};
}, 20] call CBA_fnc_addPerFrameHandler;

/* 
    File: fn_spawnRandomFlare.sqf 
    Description: Spawns a random flare over a random unit every 60 seconds 
*/ 
[] spawn { 
// CONFIGURATION 
private _unitArray = allUnits;        // or use: playableUnits, allPlayers, etc.
private _sinkRate = -1; 
// Fetch all flare class names from CfgAmmo
private _flareClasses =  'getText (_x >> "simulation") == "shotIlluminating" and getNumber (_x >> "timeToLive") <= 360' configClasses (configFile >> "CfgAmmo"); 
 
if (_flareClasses isEqualTo []) exitWith { 
    diag_log "No flares found in config."; 
}; 
AK_switch_randomFlare = true; 
while {AK_switch_randomFlare == true} do {
    // Choose a random unit 
    private _target = selectRandom _unitArray; 
    if (isNull _target) exitWith {}; 
 
    // Choose a random flare class 
    private _flareConfig = selectRandom _flareClasses; 
    private _flareClass = configName _flareConfig;
    private _timeToLive = getNumber (_flareConfig >> "timeToLive"); 
    private _interval = _timeToLive;               // Time between flares (in seconds) 
    private _height = abs (_timeToLive * _sinkRate);                // Drop height for the flare 
    // Position over the unit 
    private _pos = getPosASL _target; 
    _pos set [2, (_pos select 2) + _height]; // Add height 
 
    // Spawn the flare 
    _flare = _flareClass createVehicle _pos;
    _flare setVelocity [wind select 0,wind select 1, _sinkRate]; 
 
    // Optional: log 
    diag_log format ["Spawned flare: %1 over %2", _flareClass, name _target]; 
 
    sleep _interval; 
};
};