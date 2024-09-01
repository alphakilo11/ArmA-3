AK_fnc_ballisticData = { 
/* Collect some basic ballistic data 
BUGS _shotDistance is unreliable, due to ricochets and the projectile beeing deleted 
*/ 
	_dataLogResolution = 0.0055; // s of delay between data points  HEADSUP values below ~ 0.005 will cause a very high number of duplicates
	_shotTime = diag_tickTime;
	_firerPos = AGLToASL positionCameraToWorld [0,0,0];
	_ins = lineIntersectsSurfaces [ 
	  _firerPos, 
	  AGLToASL positionCameraToWorld [0,0,5000], // "Hardcoded max distance: 5000m." 
	  player, 
	  objNull, 
	  true, 
	  1, 
	  "GEOM", 
	  "NONE" 
	 ]; 
	
	_initialTarget = _ins select 0 select 2; // does NOT work when not aiming directly at the target  
	hintSilent format ['%1 is the Initial Target', _initialTarget]; 
	(_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"]; 
   /* WIP
	_projectile addEventHandler ["HitPart", { 
	  if (isNil "AK_var_testData") then { 
		  AK_var_testData = []; 
		}; 
		AK_var_testData pushBack _this; 
		//(_this select 0) removeEventHandler ["HitPart", 0]; //remove after first hit to avoid logging multiple hits 
	}]; 
*/ 
   
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
  _posData = []; 
  _timeStamps =  []; 
  _velocityData = []; 
  while {isNull _projectile == false} do { 
	  _bulletVelocity = (velocity _projectile); 
	  _bulletPosASL = (getPosASL _projectile); 
	  _posData pushBack _bulletPosASL; 
	  _timeStamps pushBack diag_tickTime - _shotTime; 
	  _velocityData pushBack _bulletVelocity;
	  //hintSilent str (_bulletVelocity call CBA_fnc_vectMagn); 
	  uisleep _dataLogResolution; 
	}; 
  _shotDistance = _firerPos distance (_posData select (count _posData - 1)); 
  _offTarget = _ins select 0 select 0 distance  (_posData select (count _posData - 1)); 
  systemChat format ['%1 s, %2 m, %3 m off target %4, %5 m off side', diag_tickTime - _shotTime, _shotDistance, _offTarget, _initialTarget, [_ins select 0 select 0, (_posData select (count _posData - 1))] call BIS_fnc_distance2D]; 
  if (isNil "AK_var_BallisticData") then { 
	  AK_var_BallisticData = []; 
	}; 
  AK_var_BallisticData pushBack [_metaData, _timeStamps, _posData, _velocityData]; 
  }; 
