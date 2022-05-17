//Spawns artillery with a fire mission.
//at some ranges, presumeably between charges, the gun will give an ETA but just not fire.
//"LOP_AA_Static_M252" RHS mortar
//"B_T_MBT_01_arty_F" vanilla NATO SPG
//"B_T_MBT_01_mlrs_F" vanilla NATO MLRS
//TODO only spawn, if not already present
//TODO add dispersion
//TODO transform to  function


//V 5
//ADDED Range and time to Fire Mission
//changed kanone to _kanone
//round ETA and Range
//22.8182 ms
private _position = [[26950, 24950, 0], 0 , 100, 0, 0, 0.1] call BIS_fnc_findSafePos;
private _type = "B_T_MBT_01_arty_F";
private _side = west;
private _kanone = [_position, 180, _type, _side] call BIS_fnc_spawnVehicle;
_kanone = _kanone select 0;
//target (only works local, where the player is aiming at - watch out not to point into grass or shrub)
private _ziel = screenToWorld [0.5,0.5];
//Number of rounds
private _rounds = 3;
//check range 
if (_ETA == -1) exitWith { _kanone sideChat format ["Target out of range"] };
//check if unit is local and set ammo to max
if (local _kanone) then {
	_kanone setAmmo [currentWeapon _kanone, 9999];
} else {
	systemChat "Vehicle must be local to this machine for 'setAmmo' to work";
};
//ammo type
private _munitionsart = getArtilleryAmmo [_kanone] select 0;
//round travel time
private _ETA = _kanone getArtilleryETA [_ziel, _munitionsart];
//range
private _range = (position _kanone) distance _ziel;
//check range
if (_ETA == -1) exitWith { _kanone sideChat format ["Target out of range"] };
//fire
_kanone doArtilleryFire [_ziel, _munitionsart, _rounds];
//report firing (6 seconds added to ETA to allow gun adjustment
(group _kanone) setGroupId ["Hammer"];
_kanone sideChat format ["Fire mission %1%2LMT: %3 rounds %4, ETA: %5 s, Range: %6 m.", (date select 3), (date select 4), _rounds, _munitionsart, round (_ETA + 6), round _range];
//workaround for fire mission complete message (doesn't work for stationary units)
private _finished = (group _kanone) addWaypoint [_position, 25];
//seems to only work as long as _kanone is not a private variable
_finished setWaypointStatements ["true", "_kanone sideChat format ['Fire mission complete.']"];
