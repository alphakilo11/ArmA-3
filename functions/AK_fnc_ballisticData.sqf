AK_fnc_ballisticData = {   
/*
Collect ballistic data.
The data is saved to localNamespace as variable named str _projectile. It includes following data:
[0: str _unit, 1: _weapon, 2: _muzzle, 3: _mode, 4: _ammo, 5: _magazine, 6: str _gunner, 7: _shotTime, 8: _firerPos, 9: _muzzleVelocity, 10: typeOf _unit]
ENHANCE  
 add inflicted vehicle damage  
 add inflicted casualities 
HEADSUP  
 after attachTo the impact marker is not reliable  
BUGS  
 SPE vehicles that are gradually destroyed by ammo fires may not be detected.  
 _firerPos is not consistant with where the bullet actually starts  
PONDER
	use systemTimeUTC or diag_tickTime? diag_tickTime is 2.6x faster but the former provides more granularity in logging 
EXAMPLE 1 
{ 
_x addEventHandler ["Fired", {  
 [_this,  
  [ 
   diag_tickTime, // shotTime 
   getPosASL (_this select 6), // shooter position 
   velocity (_this select 6) // V0 
  ] 
 ] call AK_fnc_ballisticData; 
 }]; 
} forEach vehicles;  
END EXAMPLE 1  
*/   
	AK_switch_ballisticDataDebug = false;  
   
	(_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];  
	(_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];
	private _projectileString = str _projectile;
	localNamespace setVariable [_projectileString, [str _unit, _weapon, _muzzle, _mode, _ammo, _magazine, str _gunner, _shotTime, _firerPos, _muzzleVelocity, typeOf _unit]];
  
 _projectile addEventHandler ["HitPart", {   
  params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"];
  _eventTime = diag_tickTime;
  private _projectileString = str _projectile;
  private _hitEntityString = str _hitEntity;
  private _targetSideString = str (side _hitEntity);	
  if (alive _hitEntity && !(_hitEntity isKindOf "Building")) then { // rule out buildings and landscape  
   _hitMessage = ["Function", "Event", "Projectile", "Impact Position", "Impact Velocity", "Target Designation", "Target Type", "Target Position", "Target Heading", "Target Velocity", "Target Side", "TickTime", "Components", "NormalAngle", "Surface"] createHashMapFromArray ["AK_fnc_ballisticData", "HitPart", _projectileString, _pos, _velocity, _hitEntityString,typeOf _hitEntity, getPosASL _hitEntity, direction _hitEntity, velocity _hitEntity, _targetSideString, _eventTime, _components, _normal, _surfaceType];  
   _hitMessage spawn AK_fnc_logHashMap;  
   if (AK_switch_ballisticDataDebug == true) then {systemChat str _hitMessage;};  
  
   if ((_components select 0) == "head") then {  
 systemChat format ["HEADSHOT by %1 against %2. Range: %3", _projectileOwner, _hitEntity, _projectileOwner distance _hitEntity];  
   };  
   // impactMarker 
   if (AK_switch_ballisticDataDebug == true) then {
   /*
   // create impact marker  
	_marker = "Sign_arrow_blue_F" createVehicle [0,0,0];  
	_marker setPos ASLtoAGL _pos;  
	//_marker attachTo [_hitEntity];   
	_marker setVectorUp (_velocity apply {_x * -1});  
	// create normal-to-surface Marker  
	_marker = "Sign_arrow_F" createVehicle [0,0,0];  
	_marker setPos ASLtoAGL _pos;  
	//_marker attachTo [_hitEntity];   
	_marker setVectorUp _normal;
	*/
	hintSilent format ["HitPart: Impact Angle: %1. AA: %2", asin (_velocity vectorCos _normal), [_projectileOwner, _hitEntity] call AK_fnc_getAA]; 
 };  
	
	  // assign Event Handler to _hitEntity  
   if (_hitEntity getVariable ["AK_switch_DammagedHandler", false] == false) then {  
 _hitEntity addEventHandler ["Dammaged", {   
  params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];
  _eventTime = diag_tickTime;
  _projectileString = str _projectile;
  _shooterString = str _shooter;
  _unitString = str _unit;  
  // check if someone caused the damage or it was caused by other factors for example a burning vehicle  
  if (isNull _shooter == false) then {  
   // has a vital HitPoint been damaged  
   if (_hitPoint in ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"]) then {  
	// avoid multiple triggers of dammaged in rapid succession.  
	if ((_unit getVariable ["AK_switch_dammagedCooldown", None]) == _shooter) exitWith {};  
	_unit setVariable ["AK_switch_dammagedCooldown", _shooter];  
	[_unit] spawn {  
  sleep 1;  
  (_this select 0) setVariable ["AK_switch_dammagedCooldown", nil];  
	};  
	// has a vital HitPoint been destroyed  
	_criticalHitPointStatus = [];  
	{_criticalHitPointStatus pushBack (floor (_unit getHitPointDamage _x))} forEach ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"];  
	if !(1 in _criticalHitPointStatus) exitWith {};  
   
	_approxdistance = _unit distance _shooter;  
	_status = 'immobilized';  
	if (_criticalHitPointStatus select 4 == 1 or _criticalHitPointStatus select 5 == 1) then {  
  _status = 'incapacitated';  
	};  
	if (_criticalHitPointStatus select 0 == 1) then {  
  _status = 'destroyed';  
	}; 
	_dammageLogEntry = ["Function", "Event", "Unit", "Selection", "Damage", "HitIndex", "HitPoint", "Shooter", "Projectile", "tickTime", 'Vehicle Damage [hithull, hitltrack, hitrtrack, hitengine, hitturret , hitgun]'] createHashMapFromArray ["AK_fnc_ballisticData", "Vehicle Critical Dammaged", _unitString, _selection, _damage, _hitIndex, _hitPoint, _shooterString, _projectileString, _eventTime, _criticalHitPointStatus];	
	_dammageLogEntry spawn AK_fnc_logHashMap; 
	_dammageMessage = format ["%1 %2 %3 by causing %4 damage to selection %5 at a range of %6 using %7", _shooter, _status, _unit, _damage, _selection, _approxdistance, _projectileString];  
	if (AK_switch_ballisticDataDebug == true) then {  
  systemChat _dammageMessage;  
	};  
   };  
  };  
 }];  
   _hitEntity setVariable ["AK_switch_DammagedHandler", true];  
   };  
  };   
 }]; 
 _projectile addEventHandler ["Penetrated", {  
  params ["_projectile", "_hitObject", "_surfaceType", "_entryPoint", "_exitPoint", "_exitVector"];
  _eventTime = diag_tickTime;
  _projectileString = str _projectile; // createHashMapFromArray seems to be to slow
  _hitObjectString = str _hitObject; 
  _penetrationKeys = ["Function", "Event", "Projectile", "HitObject", "SurfaceType", "EntryPoint", "ExitPoint", "ExitVector", "tickTime"]; 
  _penetrationValues = ["AK_fnc_ballisticData", "Penetrated", _projectileString, _hitObjectString, _surfaceType, _entryPoint, _exitPoint, _exitVector, _eventTime]; 
  _penetrationMessage = _penetrationKeys createHashMapFromArray _penetrationValues; 
  _penetrationMessage spawn AK_fnc_logHashMap;
  if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _penetrationMessage;}; 
 }]; 
 _projectile addEventHandler ["SubmunitionCreated", {  
	  params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];
	  _eventTime = diag_tickTime;
	  _projectileString = str _projectile;
	  _submunitionString = str _submunitionProjectile;  
	  _submunitionKeys = ["Function", "Event", "Projectile", "submunitionProjectile", "Position", "Velocity", "tickTime"]; 
	  _submunitionValues = ["AK_fnc_ballisticData", "SubmunitionCreated", _projectileString, _submunitionString, _pos, _velocity, _eventTime]; 
	  _submunitionMessage = _submunitionKeys createHashMapFromArray _submunitionValues; 
	  _submunitionMessage spawn AK_fnc_logHashMap;
	  if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _submunitionMessage};
	  _submunitionProjectile addEventHandler ["Deleted", { 
		params ["_projectile"];
		_eventTime = diag_tickTime;
		private _projectileString = str _projectile;
		private _deletePos = getPosASL _projectile; 
		private _dataHashMap = ["Function", "Event", "Projectile", "Position", "tickTime"] createHashMapFromArray ["AK_fnc_ballisticData", "Submunition Deleted", _projectileString, _deletePos, _eventTime];
		_dataHashMap spawn AK_fnc_logHashMap;
		if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _dataHashMap};
		}];  
  }]; 
 _projectile addEventHandler ["Explode", {  
  params ["_projectile", "_pos", "_velocity"];
  _eventTime = diag_tickTime;
  private _projectileString = str _projectile;
  private _data = localNamespace getVariable [_projectileString,  "None"];
  _shotDistance = _pos distance (_data select 8);
  _explosionKeys = ["Function", "Event", "Projectile", "Position", "Velocity", "tickTime"]; 
  _explosionValues = ["AK_fnc_ballisticData", "Explode", _projectileString, _pos, _velocity, _eventTime]; 
  _explosionMessage = _explosionKeys createHashMapFromArray _explosionValues; 
  _explosionMessage spawn AK_fnc_logHashMap;
  /*
   if (AK_switch_ballisticDataDebug == true) then {
	   private _ammo = _data select 4;
	   private _weapon = _data select 1;
	   private _platform = _data select 10;
	   systemChat format ["%1 shot by %2 using %3 exploded at a distance of %4 m.", _ammo, _platform, _weapon, _shotDistance];
	   private _distanceRecords = player getVariable ["AK_var_distanceRecords", "None"];
	   if (typeName _distanceRecords != "HASHMAP") then {
		   _distanceRecords = createHashMap;
		};
	   _distanceRecords set [_platform, [_weapon, _ammo, _shotDistance]];
	   player setVariable ["AK_var_distanceRecords", _distanceRecords];
	   };
 */
 }]; 
	_projectile addEventHandler ["Deflected", {  
		params ["_projectile", "_position", "_velocity", "_hitObject"];
		_eventTime = diag_tickTime;
		private _projectileString = str _projectile; 
		_deflectionKeys = ["Function", "Event", "Projectile", "Position", "Velocity", "HitObject", "tickTime"]; 
		_deflectionValues = ["AK_fnc_ballisticData", "Deflected", _projectileString, _position, _velocity, str _hitObject, _eventTime]; 
		_deflectionMessage = _deflectionKeys createHashMapFromArray _deflectionValues; 
		_deflectionMessage spawn AK_fnc_logHashMap;  
	}];
	 
	_projectile addEventHandler ["Deleted", { 
		params ["_projectile"];
		_eventTime = diag_tickTime;
		private _projectileString = str _projectile;
		private _projectileData = localNamespace getVariable [_projectileString,  "None"];
		private _deletePos = getPosASL _projectile; 
		private _shotDistance = _deletePos distance (_projectileData select 8);
		private _dataHashMap = ["Function", "Event", "Projectile", "tickTime", "Position"] createHashMapFromArray ["AK_fnc_ballisticData", "Deleted", _projectileString, _eventTime, _deletePos];
		_dataHashMap spawn AK_fnc_logHashMap;
		localNamespace setVariable [_projectileString, nil];
		if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _dataHashMap}; //format ["%1 deleted at time %2", _projectile, systemTimeUTC];}; 
	}];
	private _showData = localNamespace getVariable [_projectileString, "None"];
	_showData pushBack (getNumber (configFile >> "CfgWeapons" >> (_showData select 1) >> "maxRange"));
	_showData pushBack "AK_fnc_ballisticData";
	_showData pushBack _projectileString;
	private _logData = ["Unit", "Weapon", "Muzzle", "Mode", "Ammo", "Magazine", "Gunner", "tickTime", "Firer Position", "Muzzle Velocity", "Unittype", "Config maxRange", "Function", "Projectile"] createHashMapFromArray _showData;
	[_logData] spawn AK_fnc_logHashMap;
	if (AK_switch_ballisticDataDebug == true) then {
		systemChat str _showData;
		
		/* DISABLED show projectile velocity
		ACE_player setVariable ["AK_ballisticData_activeProjectile", _projectile];
		onEachFrame {hintsilent ((str (round (vectorMagnitude (velocity (ACE_player getVariable["AK_ballisticData_activeProjectile", ACE_player]))))) + " m/s");};
		*/
	};
};   
