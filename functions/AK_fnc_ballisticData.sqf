AK_fnc_ballisticData = {
/* Collect some basic ballistic data
BUGS _shotDistance is unreliable, due to ricochets and the projectile beeing deleted
*/
    _dataLogResolution = 0.01; // s of delay between data points
    _shotTime = diag_tickTime;
    _initialTarget = cursorObject; //works even with strong recoil    
    hintSilent format ['%1 is the Initial Target', _initialTarget];
  (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
  
    _projectile addEventHandler ["HitPart", {
        AK_var_testData = _this + AK_var_testData;
        (_this select 0) removeEventHandler ["HitPart", 0];
    }];

  
  _metaData = [_weapon, _muzzle, _mode, _ammo, _magazine, str(_projectile)];
  _metaData pushBack (player weaponDirection (currentWeapon player));
  {
   _metaData pushBack (getNumber (configFile >> "CfgAmmo" >> _ammo >> _x))
  } forEach ["ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"];
  _metaData pushBack (getArray (configFile >> "CfgAmmo" >> _ammo >> "ACE_ballisticCoefficients"));
  _metaData pushBack (getText (configFile >> "CfgWeapons" >> _weapon >> "displayName"));
  _metaData pushBack getPosASL _initialTarget; //(AGLToASL screenToWorld [0.5, 0.5]);
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
      sleep _dataLogResolution;
    };
  _shotDistance = (_posData select 0) distance (_posData select (count _posData - 1));
  _offTarget = (_metaData select 12) distance  (_posData select (count _posData - 1));
  systemChat format ['%1 impact. Flighttime: %2 s Range: %3 m %4 m off target %5', diag_tickTime, diag_tickTime - _shotTime, _shotDistance, _offTarget, _initialTarget];
  if (isNil "AK_var_BallisticData") then {
      AK_var_BallisticData = [];
    };
  AK_var_BallisticData pushBack [_metaData, _timeStamps, _posData, _velocityData];
  };
