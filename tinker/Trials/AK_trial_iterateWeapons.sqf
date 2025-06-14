/* ---------------------------------------------------------------------------- 
Function: AK_trial_iterateWeapons 
 
Description: 
	Automatically tests all  Primary weapons 
 
Parameters: 
	- None 
 
Example: 
	(begin example) 
	None 
	(end) 
 
Returns: 
	None 
 
Author: 
	AK 
 
---------------------------------------------------------------------------- */

[] spawn { 
	if(isNil "AK_fnc_ballisticData" == true) exitWith {
		_message = "AK_fnc_aiWeaponTestSuite ERROR: AK_fnc_ballisticData not found. Aborting...";
		[_message] remoteExec ["systemChat", 0];
		diag_log _message;
	}; 
	// Spawn the subject soldier and target vehicle
	private _anchorPos = [0, 0,0]; 
	private _spawnedEntities = [_anchorPos, 0, "B_soldier_F", west] call BIS_fnc_spawnVehicle; 
	private _subject = _spawnedEntities select 0; 
	private _target = "B_APC_Wheeled_01_cannon_F" createVehicle (_anchorPos getPos [100, 0]); 
 
	// Make both invincible 
	_subject allowDamage false; 
	_target allowDamage false; 
 
	// Set subject behavior 
	group _subject setBehaviour "AWARE";
	
	// Enable ballistic Data 
	_subject addEventHandler ["Fired", {  
	[
		_this,  
		[ 
			diag_tickTime, // shotTime 
			getPosASL (_this select 6), // shooter position 
			velocity (_this select 6) // V0 
		] 
	] call AK_fnc_ballisticData; 
	}];

 
	// Fetch weapons with ACE barrel length and scope >= 2 
	private _weaponsArray = 'getNumber (_x >> "ACE_barrelLength") > 0 && getNumber (_x >> "scope") >= 2'  
		configClasses (configFile >> "CfgWeapons"); 
 
	// Filter weapons with available magazines 
	private _testWeapons = _weaponsArray;
	/* DISABLED 
	private _attempts = 0; 
	while {count _testWeapons < 10 && _attempts < 50} do { 
		private _candidate = selectRandom _weaponsArray; 
		private _mags = (_candidate >> "magazines") call BIS_fnc_getCfgDataArray; 
		if (count _mags > 0) then { 
			_testWeapons pushBackUnique _candidate; 
		}; 
0		_attempts = _attempts + 1; 
	}; 
	 */
	private _counter = 0; 
 
	{ 
		private _candidateWeapon = configName _x; 
		private _compatibleMags = [_candidateWeapon] call BIS_fnc_compatibleMagazines; 
		private _modes = getArray (configFile >> "CfgWeapons" >> _candidateWeapon >> "modes"); 
		private _fireMode = if (count _modes > 0) then {_modes select 0} else {"Single"}; 
 
		if (count _compatibleMags > 0) then { 
			removeAllWeapons _subject; 
			_subject addWeapon _candidateWeapon; 
 
			{ 
				private _mag = _x; 
				_subject addPrimaryWeaponItem _mag; 
				_subject selectWeapon _candidateWeapon; 
				_subject doTarget _target; 
				sleep 1; 
 
				// Fire  
				_subject forceWeaponFire [_candidateWeapon, _fireMode]; 
 
				//[format ["Fired mag: %1 from weapon: %2", _mag, _candidateWeapon]] remoteExec ["systemChat", 0]; 
				removeAllPrimaryWeaponItems _subject; 
				sleep 1; 
			} forEach _compatibleMags; 
 
			_counter = _counter + 1;
			private _message = format ["%1 weapons tested. %2 to go.", _counter, count _testWeapons - _counter];
			diag_log _message; 
			//[format ["%1 weapons tested. %2 to go.", _counter, count _testWeapons - _counter]] remoteExec ["systemChat", 0]; 
		}; 
	} forEach _testWeapons; 
 
	//[format ["Test complete. %1 weapons tested.", _counter]] remoteExec ["systemChat", 0]; 
}; 
