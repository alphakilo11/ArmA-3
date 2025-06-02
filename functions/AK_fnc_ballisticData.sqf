AK_fnc_ballisticData = {  
/* Collect ballistic data
ENHANCE 
 add inflicted vehicle damage 
 add inflicted casualities 
HEADSUP 
 after attachTo the impact marker is not reliable 
BUGS 
 SPE vehicles that are gradually destroyed by ammo fires may not be detected. 
 _firerPos is not consistant with where the bullet actually starts 

EXAMPLE 1
{
(_x) addEventHandler ["Fired", { 
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
EXAMPLE 2
{
(_x) addEventHandler ["Fired", { 
 [_this, 
  [
   diag_tickTime, // shotTime
   getPosASL (_this select 6), // shooter position
   velocity (_this select 6) // V0
  ]
 ] call AK_fnc_ballisticData;
 }];
} forEach allPlayers; 
END EXAMPLE 2
*/  
 AK_switch_ballisticDataDebug = true; 
  
 (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
 (_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"]; 
 
 _projectile addEventHandler ["HitPart", {  
  params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"]; 
   
  if (alive _hitEntity && !(_hitEntity isKindOf "Building")) then { // rule out buildings and landscape 
   _hitMessage = ["Function", "Event Handler", "Projectile", "Impact Position", "Impact Velocity", "Target Designation", "Target Type", "Target Position", "Target Heading", "Target Velocity", "Target Side", "TickTime", "Components", "NormalAngle", "Surface"] createHashMapFromArray ["AK_fnc_ballisticData", "HitPart", _projectile, _pos, _velocity, _hitEntity,typeOf _hitEntity, getPosASL _hitEntity, direction _hitEntity, velocity _hitEntity, side _hitEntity, diag_tickTime, _components, _normal, _surfaceType]; 
   diag_log text (toJSON _hitMessage); 
   if (AK_switch_ballisticDataDebug == true) then {systemChat str _hitMessage;}; 
	
   if ((_components select 0) == "head") then { 
	systemChat format ["HEADSHOT by %1 against %2. Range: %3", _projectileOwner, _hitEntity, _projectileOwner distance _hitEntity]; 
   }; 
   // impactMarker
   if (AK_switch_ballisticDataDebug == true) then { 
	   _marker = "Sign_arrow_blue_F" createVehicle [0,0,0]; 
	   _marker setPos ASLtoAGL _pos; 
	   //_marker attachTo [_hitEntity];  
	   _marker setVectorUp (_velocity apply {_x * -1}); 
	   // normalMarker 
	   _marker = "Sign_arrow_F" createVehicle [0,0,0]; 
	   _marker setPos ASLtoAGL _pos; 
	   //_marker attachTo [_hitEntity];  
	   _marker setVectorUp _normal;
	}; 
 
   if (_hitEntity getVariable ["AK_switch_DammagedHander", false] == false) then { 
	_hitEntity addEventHandler ["Dammaged", {  
	 params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"]; 
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
	   _dammageLogEntry = ["Function", "Event Handler", "Unit", "Selection", "Damage", "HitIndex", "HitPoint", "Shooter", "Projectile", "tickTime", 'Vehicle Damage [hithull, hitltrack, hitrtrack, hitengine, hitturret , hitgun]'] createHashMapFromArray ["AK_fnc_ballisticData", "Vehicle Critical Dammaged", _unit, _selection, _damage, _hitIndex, _hitPoint, _shooter, _projectile, diag_tickTime, _criticalHitPointStatus];   
	   diag_log text (toJSON _dammageLogEntry);
	   _dammageMessage = format ["%1 %2 %3 by causing %4 damage to selection %5 at a range of %6 using %7", _shooter, _status, _unit, _damage, _selection, _approxdistance, _projectile]; 
	   if (AK_switch_ballisticDataDebug == true) then { 
		hintSilent _dammageMessage; 
	   }; 
	  }; 
	 }; 
	}]; 
   _hitEntity setVariable ["AK_switch_DammagedHander", true]; 
   }; 
  };  
 }];
	_projectile addEventHandler ["Penetrated", { 
		params ["_projectile", "_hitObject", "_surfaceType", "_entryPoint", "_exitPoint", "_exitVector"];
		_penetrationKeys = ["Function", "Event Handler", "Projectile", "HitObject", "SurfaceType", "EntryPoint", "ExitPoint", "ExitVector", "tickTime"];
		_penetrationValues = ["AK_fnc_ballisticData", "Penetrated", _projectile, _hitObject, _surfaceType, _entryPoint, _exitPoint, _exitVector, diag_tickTime];
		_penetrationMessage = createHashMapFromArray [_penetrationKeys, _penetrationValues];
		diag_log text (toJSON _penetrationMessage);
	}];
	_projectile addEventHandler ["SubmunitionCreated", { 
		params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"]; 
		_submunitionKeys = ["Function", "Event Handler", "Projectile", "submunitionProjectile", "Position", "Velocity", "tickTime"];
		_submunitionValues = ["AK_fnc_ballisticData", "SubmunitionCreated", _projectile, _submunitionProjectile, _pos, _velocity, diag_tickTime];
		_submunitionMessage = createHashMapFromArray [_submunitionKeys, _submunitionValues];
		diag_log text (toJSON _submunitionMessage);
	}];
	_projectile addEventHandler ["Explode", { 
		params ["_projectile", "_pos", "_velocity"]; 
		_explosionKeys = ["Function", "Event Handler", "Projectile", "Position", "Velocity", "tickTime"];
		_explosionValues = ["AK_fnc_ballisticData", "Explode", _projectile, _pos, _velocity, diag_tickTime];
		_explosionMessage = createHashMapFromArray [_explosionKeys, _explosionValues];
		diag_log text (toJSON _explosionMessage);
	}];
	_projectile addEventHandler ["Deflected", { 
		params ["_projectile", "_pos", "_velocity", "_hitObject"];
		_deflectionKeys = ["Function", "Event Handler", "Projectile", "Position", "Velocity", "HitObject", "tickTime"];
		_deflectionValues = ["AK_fnc_ballisticData", "Deflected", _projectile, _pos, _velocity, _hitObject, diag_tickTime];
		_deflectionMessage = createHashMapFromArray [_deflectionKeys, _deflectionValues];
		diag_log text (toJSON _deflectionMessage);	
	}];  
 };  
