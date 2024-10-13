/* Collect positional and matadata of projectiles  
	ENHANCE
	 make data JSON conformal 
	 add aim error by defining an aimpoint 
	HEADSUP 
	 the impact analysis currently works with scopes (as the sway  of other sights will not move the camera or change eyePos) 
	 the impact analysis currently works with flat surfaces that are perpendicular to the shooter and stop the bullet 
	 after attachTo the impact marker is not reliable 
	BUGS 
	 _shotDistance is unreliable, due to ricochets and the projectile beeing deleted  
	 left right calculation doesn't work properly (didn't work when shooting at a heading of 066Â°) 
	 _firerPos is not consistant with where the bullet actually spawns
	 the impact marker is not precise 
	REQUIRES  
	  (vehicle player) addEventHandler ["Fired", {
		[_this, 
			  [  
			   diag_tickTime, // shotTime  
			   getPosASL (_this select 6), // shooter position  
			   velocity (_this select 6) // V0  
			  ]  
		 ] spawn AK_fnc_traceProjectile;
	}]; 
*/ 
AK_fnc_traceProjectile = {
	AK_switch_traceProjectileDebug = true;
	(_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	(_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];

	_posData = [_firerPos];
	_timeStamps = [0];
	_velocityData = [_muzzleVelocity];
	_firedMessage = format ['{
		"Function": "AK_fnc_ballisticData", "Event Handler": "Fired", "Shooter":"%1", "Shooter Type":"%2", "Shooter Position":%3, "Shooter Velocity":%4, "Projectile":"%5", "Muzzle Velocity":%6, "Weapon":"%7", "Ammo":"%8", "Shooter Side":"%9", "tickTime": %10
	}', _gunner, typeOf _unit, getPosASL _gunner, velocity _unit, _projectile, _muzzleVelocity, _weapon, _ammo, side _gunner, _shotTime];
	diag_log _firedMessage;
	if (AK_switch_traceProjectileDebug == true) then {
		systemChat _firedMessage;
	};
	   _dataLogResolution = 0.0055; // s of delay between data points  HEADSUP values below ~ 0.005 will cause a very high number of duplicates  
	   _aimPosInWorld = AGLToASL positionCameraToWorld [0, 0, 0]; // player required! 

	_ins = lineIntersectsSurfaces [
		_aimPosInWorld,
		   AGLToASL positionCameraToWorld [0, 0, 5000], // "Hardcoded max distance: 5000m." player required! 
		player,
		objNull,
		true,
		1,
		"GEOM",
		"NONE"
	];
	_initialTarget = objNull;
	if (count _ins != 0) then {
		_initialTarget = _ins select 0 select 2; // does not work when not aiming directly at the target   
		if (AK_switch_traceProjectileDebug == true) then {
			hintSilent format ['%1 is the Initial Target', _initialTarget];
		};
	};
	_metaData = [_weapon, _muzzle, _mode, _ammo, _magazine, str(_projectile)];
	   _metaData pushBack (player weaponDirection (currentWeapon player)); // 'weaponDirection' 
	{
		_metaData pushBack (getNumber (configFile >> "CfgAmmo" >> _ammo >> _x))
	} forEach ["ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"];// "ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"] 
	   _metaData pushBack (getArray (configFile >> "CfgAmmo" >> _ammo >> "ACE_ballisticCoefficients"));// "ACE_ballisticCoefficients" 
	   _metaData pushBack (getText (configFile >> "CfgWeapons" >> _weapon >> "displayName"));// "weapon_displayName" 
	   _metaData pushBack getPosASL _initialTarget; // 'targetPos' 
	   _metaData pushBack _firerPos; // 'firerPos' 
	  // _initialTarget;// (AGLToASL screenToWorld [0.5, 0.5]);  
	  // systemChat str _metaData; 

	while { isNull _projectile == false } do {
		_bulletVelocity = (velocity _projectile);
		_bulletPosASL = (getPosASL _projectile);
		_posData pushBack _bulletPosASL;
		_timeStamps pushBack diag_tickTime - _shotTime;
		_velocityData pushBack _bulletVelocity;
		 // hintSilent str (_bulletVelocity call CBA_fnc_vectMagn);  
		uiSleep _dataLogResolution;
	};
	_bulletTravelTime = (_timeStamps select (count _timeStamps - 1));
	_shotDistance = _firerPos distance (_posData select (count _posData - 1));
	_impactPos = _posData select (count _posData - 1);
	_offTarget = 'no data';
	_rightLeftOffTarget = 'no data';
	if (count _ins > 0) then {
		_offTarget = _ins select 0 select 0 distance _impactPos;
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
		if (AK_switch_traceProjectileDebug == true) then {
			systemChat format ['%1 s, %2 m, %3 m off target %4, %5 m off side', _bulletTravelTime, _shotDistance, _offTarget, _initialTarget, _rightLeftOffTarget];
		};
		 // systemChat format ["%1Â° _normalizedShooterImpactAngle. %2Â° _ShooterAimAngle. %3 ShooterImpactAngle. %4 distance _firerPos pos player", _normalizedShooterImpactAngle, _ShooterAimAngle, 
		  // (_firerPos getDir (_posData select (count _posData - 1))), vectorMagnitude (getPosASL player vectorDiff _firerPos)];
	} else {
		systemChat format ["%1 s, %2 m", _bulletTravelTime, _shotDistance];
	};
	if (AK_switch_traceProjectileDebug == true) then {
		_marker = "Sign_arrow_F" createVehicle [0, 0, 0];// "Sign_Sphere10cm_F"  
		_marker setPos ASLToAGL _impactPos;
		_marker setVectorUp (_velocityData select (count _velocityData - 1));
	};
	_impactData = [_bulletTravelTime, _shotDistance, _offTarget, _rightLeftOffTarget];
	if (isNil "AK_var_traceProjectileData") then {
		AK_var_traceProjectileData = []
	};
	AK_var_traceProjectileData pushBack [_metaData, _timeStamps, _posData, _velocityData, _impactData];
};