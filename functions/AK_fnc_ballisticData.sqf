AK_fnc_ballisticData = { 
/* Collect ballistic data for players 
ENHANCE
	add aim error by defining an aimpoint
	add impact Aspect Angle
	add impact angle relative to armor
	add inflicted vehicle damage
	add inflicted casualities
HEADSUP
	the impact analysis currently works with scopes (as the sway  of other sights will not move the camera or change eyePos)
	the impact analysis currently works with flat surfaces that are perpendicular to the shooter and stop the bullet
	after attachTo the impact marker is not reliable
BUGS
	SPE vehicles that are gradually destroyed by ammo fires will not be detected.
	_shotDistance is unreliable, due to ricochets and the projectile beeing deleted 
	left right calculation doesn't work properly (didn't work when shooting at a heading of 066Â°)
	_firerPos is not consistant with where the bullet actually starts
REQUIRES 
  (vehicle player) addEventHandler ["Fired", {  
 [_this,  
  [ 
   diag_tickTime, // shotTime 
   getPosASL (_this select 6), // shooter position 
   velocity (_this select 6) // V0 
  ] 
 ] spawn AK_fnc_ballisticData; 
 }];
*/ 
	_logMessageheader = ";AK_fnc_ballisticData";
	_dataLogResolution = 0.0055; // s of delay between data points  HEADSUP values below ~ 0.005 will cause a very high number of duplicates
	//_shotTime = diag_tickTime;
	_aimPosInWorld = AGLToASL positionCameraToWorld [0,0,0]; // PLAYER required!
	 (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	 (_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];
	_ins = lineIntersectsSurfaces [ 
	  _aimPosInWorld, 
	  AGLToASL positionCameraToWorld [0,0,5000], // "Hardcoded max distance: 5000m." PLAYER required!
	  player, 
	  objNull, 
	  true, 
	  1, 
	  "GEOM", 
	  "NONE" 
	 ];
	 _initialTarget = objNull; 
	if (count _ins != 0) then {
		_initialTarget = _ins select 0 select 2; // does NOT work when not aiming directly at the target  
		//hintSilent format ['%1 is the Initial Target', _initialTarget];  
	};

	_projectile addEventHandler ["HitPart", { 
	  if (isNil "AK_var_testData") then { 
		  AK_var_testData = []; 
		};
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"];
		//systemChat str _this;
		/*
		_marker = "Sign_arrow_blue_F" createVehicle [0,0,0];
		_marker setPos ASLtoAGL _pos;
		_marker attachTo [_hitEntity]; 
		_marker setVectorUp (_velocity apply {_x * -1});
		*/
		if (alive _hitEntity) then {
			systemChat format ["%1 or %2 hit %3 with %4. Side: %5", _instigator, _projectileOwner, _hitEntity, _projectile, side _hitEntity]; // _instigator seems to be 'any' all the time and _projectileOwner delivers unreliable results
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
							if (_criticalHitPointStatus select 4 == 1 || _criticalHitPointStatus select 5 == 1) then {
								_status = 'incapacitated';
							};
							if (_criticalHitPointStatus select 0 == 1) then {
								_status = 'destroyed';
							};
							AK_var_testData pushBack _this;
							_message = format ["%1 %2 %3 by causing %4 damage to selection %5 at a range of %6 using %7", _shooter, _status, _unit, _damage, _selection, _approxdistance, _projectile];
							systemChat _message;
							// diag_log _message;
						};
					};
				}];
			_hitEntity setVariable ["AK_switch_DammagedHander", true];
			};
		};
		//AK_var_testData pushBack _this; 
		//(_this select 0) removeEventHandler ["HitPart", 0]; //remove after first hit to avoid logging multiple hits 
	}]; 
   
  _metaData = [_weapon, _muzzle, _mode, _ammo, _magazine, str(_projectile)]; 
  _metaData pushBack (player weaponDirection (currentWeapon player)); // 'weaponDirection'
  { 
   _metaData pushBack (getNumber (configFile >> "CfgAmmo" >> _ammo >> _x)) 
  } forEach ["ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"]; //"ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"]
  _metaData pushBack (getArray (configFile >> "CfgAmmo" >> _ammo >> "ACE_ballisticCoefficients")); //"ACE_ballisticCoefficients"
  _metaData pushBack (getText (configFile >> "CfgWeapons" >> _weapon >> "displayName")); //"weapon_displayName"
  _metaData pushBack getPosASL _initialTarget; // 'targetPos'
  _metaData pushBack _firerPos; // 'firerPos'
 //_initialTarget; //(AGLToASL screenToWorld [0.5, 0.5]); 
  //systemChat str _metaData;   
  _posData = [_firerPos]; 
  _timeStamps =  [0]; 
  _velocityData = [_muzzleVelocity];
  diag_log format ['%1;%2;%3', _logMessageheader, _gunner, _projectile]; 
  while {isNull _projectile == false} do { 
	  _bulletVelocity = (velocity _projectile); 
	  _bulletPosASL = (getPosASL _projectile); 
	  _posData pushBack _bulletPosASL; 
	  _timeStamps pushBack diag_tickTime - _shotTime; 
	  _velocityData pushBack _bulletVelocity;
	  //hintSilent str (_bulletVelocity call CBA_fnc_vectMagn); 
	  uisleep _dataLogResolution; 
	};
	_bulletTravelTime =  (_timeStamps select (count _timeStamps - 1)); 
  _shotDistance = _firerPos distance (_posData select (count _posData - 1));
  _impactPos = _posData select (count _posData - 1);
	_offTarget = 'no data';
  _rightLeftOffTarget = 'no data';
  if (count _ins > 0) then {
	  _offTarget = _ins select 0 select 0 distance  _impactPos;
	  _rightLeftOffTarget = [_ins select 0 select 0, _impactPos] call BIS_fnc_distance2D;
	  _aimPos = _ins select 0 select 2;
	  _ShooterAimAngle = _firerPos getDir _aimPos;
	  _normalizedShooterImpactAngle = (_firerPos getDir _impactPos) - _ShooterAimAngle;
	  if (_normalizedShooterImpactAngle < 0) then {
		  _normalizedShooterImpactAngle = _normalizedShooterImpactAngle + 360;
	  };
	  if (_normalizedShooterImpactAngle > 180) then {
		  _rightLeftOffTarget = _rightLeftOffTarget * -1; // right are positive values, left negative
	  };
	  //systemChat format ['%1 s, %2 m, %3 m off target %4, %5 m off side', _bulletTravelTime, _shotDistance, _offTarget, _initialTarget, _rightLeftOffTarget];
	  //systemChat format ["%1Â° _normalizedShooterImpactAngle. %2Â° _ShooterAimAngle. %3 ShooterImpactAngle. %4 distance _firerPos pos player", _normalizedShooterImpactAngle, _ShooterAimAngle,
	  // (_firerPos getDir (_posData select (count _posData - 1))), vectorMagnitude (getPosASL player vectorDiff _firerPos)];
	} else {
		systemChat format ["%1 s, %2 m", _bulletTravelTime, _shotDistance];
};
/* obsolete by projectile EH?
	_marker = "Sign_arrow_F" createVehicle [0,0,0]; //"Sign_Sphere10cm_F" 
	_marker setPos ASLtoAGL _impactPos;
	_marker setVectorUp (_velocityData select (count _velocityData - 1));
*/
	_impactData = [_bulletTravelTime, _shotDistance, _offTarget, _rightLeftOffTarget];
	
  if (isNil "AK_var_BallisticData") then { 
	  AK_var_BallisticData = []; 
	}; 
  AK_var_BallisticData pushBack [_metaData, _timeStamps, _posData, _velocityData, _impactData]; 
  }; 
