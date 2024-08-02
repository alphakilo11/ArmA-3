AK_fnc_ballisticData = {
/* Collect some basic ballistic data
BUG getPos is logging the Altitude above ground
BUGS _shotDistance is unreliable, due to ricochets and the projectile beeing deleted
ENHANCE Get the proper weapon name

Call with
(vehicle player) addEventHandler ["Fired", { 
  [_this] spawn AK_fnc_ballisticData;
}];
*/
  (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
  _metaData = [_weapon, _muzzle, _mode, _ammo, _magazine, str(_projectile)];
  _metaData pushBack (player weaponDirection (currentWeapon player));
  {
   _metaData pushBack (getNumber (configFile >> "CfgAmmo" >> _ammo >> _x))
  } forEach ["ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"];
  _metaData pushBack (getArray (configFile >> "CfgAmmo" >> _ammo >> "ACE_ballisticCoefficients"));
  _metaData pushBack (getText (configFile >> "CfgWeapons" >> _weapon >> "displayName"));
  systemChat str _metaData;  
  _posData = [];
  _timeStamps =  [];
  _velocityData = [];
  _shotTime = diag_tickTime;
  while {isNull _projectile == false} do {
	  _posData pushBack (getPosASL _projectile);
	  _timeStamps pushBack diag_tickTime - _shotTime;
	  _velocityData pushBack (velocity _projectile);
	  sleep 0.01;
	};
  _shotDistance = (_posData select 0) distance (_posData select (count _posData - 1)); 
  systemChat format ['%1 impact. Flighttime: %2 s Range: %3 m', diag_tickTime, diag_tickTime - _shotTime, _shotDistance];
  if (isNil "AK_var_BallisticData") then {
	  AK_var_BallisticData = [];
	};
  AK_var_BallisticData pushBack [_metaData, _timeStamps, _posData, _velocityData];
  };
