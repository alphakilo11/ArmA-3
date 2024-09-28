AK_fnc_ballisticData = {  
/* Collect ballistic dataENHANCE 
 add inflicted vehicle damage 
 add inflicted casualities 
HEADSUP 
 after attachTo the impact marker is not reliable 
BUGS 
 SPE vehicles that are gradually destroyed by ammo fires may not be detected. 
 _firerPos is not consistant with where the bullet actually starts 
REQUIRES  
  (vehicle player) addEventHandler ["Fired", {   
 [_this,   
  [  
   diag_tickTime, // shotTime  
   getPosASL (_this select 6), // shooter position  
   velocity (_this select 6) // V0  
  ]  
 ] call AK_fnc_ballisticData;  
 }]; 
*/  
 AK_switch_ballisticDataDebug = false; 
  
 (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
 (_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"]; 
 
 _projectile addEventHandler ["HitPart", {  
  params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"]; 
   
  if (alive _hitEntity && !(_hitEntity isKindOf "Building")) then { // rule out buildings and landscape 
   _hitMessage = format ['{"Function": "AK_fnc_ballisticData", "Event Handler": "HitPart", "Projectile":"%1", "Impact Position":%2, "Impact Velocity":%3, "Target Designation":"%4", "Target Type":"%5", "Target Position":%6, "Target Heading":%7, "Target Velocity":%8, "Target Side":"%9", "TickTime": %10, "Components": "%11", "NormalAngle": %12, "Surface": "%13"}', _projectile, _pos, _velocity, _hitEntity,typeOf _hitEntity, getPosASL _hitEntity, direction _hitEntity, velocity _hitEntity, side _hitEntity, diag_tickTime, _components, _normal, _surfaceType]; 
   diag_log _hitMessage; 
   if (AK_switch_ballisticDataDebug == true) then {systemChat _hitMessage;}; 
	
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
	   _dammageLogEntry = format ['{"Function": "AK_fnc_ballisticData", "Event Handler": "Vehicle Critical Dammaged", "Unit": "%1", "Selection": "%2", "Damage": %3, "HitIndex": %4, "HitPoint": "%5", "Shooter": "%6", "Projectile": "%7", "tickTime": %8, "Vehicle Damage ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"]": %9 }', _unit, _selection, _damage, _hitIndex, _hitPoint, _shooter, _projectile, diag_tickTime, _criticalHitPointStatus];   
	   diag_log _dammageLogEntry;
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
		systemChat str _this; 
	}];  
 };  
