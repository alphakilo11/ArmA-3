/* ---------------------------------------------------------------------------- 
Function: AK_fnc_weaponTest 
Description: 
 Beschuss Tests 
 
Parameters: 
 NIL 
 
Returns: 
 NIL 
 
Examples: 
 (begin example) 
  [{ 
   if ((isNil "AK_testRunning") or {AK_testRunning == false}) then { 
    AK_testRunning = true; 
    [] spawn AK_fnc_weaponTest; 
   }; 
  }, 5, []] call CBA_fnc_addPerFrameHandler; 
 (end) 
 
Author: 
 AK 
---------------------------------------------------------------------------- */ 
//BUG creeping memory issue (could not be solved by removing recursive calls)  
//ENHANCE limit the cleanup to the function 
//ENHANCE Create a TgtPool and select Pseudo-randomly from the pool 
 
AK_fnc_weaponTest = { 
 _spacing = 10; 
 _vehicleCount = 20; 
 _anchorPos = [1000, 1000, 0];//[23000, 18000, 0]; //Altis Almyra saltlake 
 _shooting_distance = 300; 
 _shooterCount = 10; 
 _shooter_heading = 090; 
 _shooterType = "rhsusf_army_ucp_maaws"; 
 _shooterSide = west; 
 _shooterWeapon = "rhs_weap_maaws"; 
 _shooterAmmo = "rhs_mag_maaws_HEAT"; 
 _shooterAmmoSpare = 5; 
 _TgtAspect = 180; // 1 to 179 means shooters are facing the right side, -1 to -179 left side 
 _TgtType = selectRandom (("configName _x isKindOf 'tank' and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles")) apply {(configName _x)}); 
 _mannedTargets = true; 
 _tgtSide = east; 
 0 setFog 0;  
 0 setRain 0; 
 setDate [1986, 2, 25, 12, 0]; 
  
 _timeLimit = 20 * _shooterAmmoSpare; 
 _firstTgtPos = (_anchorPos getPos [_shooting_distance, _shooter_heading]) getPos [(_vehicleCount / 2) * _spacing, (_shooter_heading - 90) % 360]; // center the tgt line at player pos 
 _spacingHDG = (_shooter_heading + 90) % 360; 
 _TgtHDG = (_shooter_heading + _TgtAspect) % 360; 
 _firstShooterPos = _anchorPos getPos [(_shooterCount / 2) * _spacing, (_shooter_heading - 90) % 360]; // center the shooter line at player pos 
 _shooterGroup = createGroup _shooterSide; 
 _shooterGroup allowFleeing 0; 
 _shooterGroup deleteGroupWhenEmpty true; 
 _targetList = []; 
 _targetGroups = []; 
 _targetCrewmen = []; 
 for "_i" from 1 to _vehicleCount do { 
  // create TGT 
  _spawnPos = _firstTgtPos getPos [_spacing * _i, _spacingHDG]; 
  _vehicle = _TgtType createVehicle _spawnPos; 
  _vehicle setDir _TgtHDG; 
  _vehicle setFuel 0; 
  _targetList pushBack _vehicle; 
  if (_mannedTargets == true) then { 
   _group = _tgtSide createVehicleCrew _vehicle; 
   _group setCombatMode "BLUE"; 
   _group deleteGroupWhenEmpty true; 
   _vehicle allowCrewInImmobile true; 
   _targetGroups pushBack _group; 
   {_targetCrewmen pushBack _x} forEach (units _group); 
  }; 
  
  // create Shooter 
  if (_i > (_shooterCount)) then {continue}; 
  _spawnPos = _firstShooterPos getPos [_spacing * _i, _spacingHDG]; 
  _vehicle = _shooterGroup createUnit [_shooterType, _spawnPos, [], 0, "NONE"]; 
  _vehicle setDir _shooter_heading; 
  doStop _vehicle; 
  [_vehicle, [[[],[_shooterWeapon,"","","rhs_optic_maaws",[_shooterAmmo,1],[],""],[],[],[],["B_Bergen_mcamo_F",[[_shooterAmmo,_shooterAmmoSpare,1]]],"H_Cap_oli_hs","",[],["","","","","",""]],[]]] call CBA_fnc_setLoadout; 
 }; 
  
 if (((count (_targetList select {!isNull _x})) == _vehicleCount) and ((count ((units _shooterGroup) select {!isNull _x})) == _shooterCount)) then { //check if tgts and shooters have been created 
  // Reporting 
  _questionAllProne = { 
   // uses the shooters going prone when out of ammo and in the presence of enemies. 
   params ["_group"]; 
   ({stance _x == "PRONE"} count (units _group) == count (units _group)) 
  }; 
  
  _start_time = time; 
  [format ["%1 %2 created.", count _targetList, _TgtType]] remoteExec ["systemChat", 0]; 
  if (_mannedTargets == true) then {[format ["%1 crewmen created.", count _targetCrewmen]] remoteExec ["systemChat", 0]};  
  while {(time <= (_start_time + _timeLimit)) and ((_shooterGroup call _questionAllProne) == false)} do { 
   [format ["%1 %2 destroyed. %3 s.", {!alive _x} count _targetList, _TgtType, time - _start_time]] remoteExec ["systemChat", 0]; 
   {_shooterGroup reveal _x} forEach _targetList; 
   sleep 10; 
  }; 
  sleep 20; //to allow for delayed destruction. 
  _destroyedVehicles = {!alive _x} count _targetList; 
  [format ["Final result: %1 %2 destroyed.", _destroyedVehicles, _TgtType]] remoteExec ["systemChat", 0]; 
  if (_mannedTargets == true) then {[format ["%1 crewmen killed.", {!alive _x} count _targetCrewmen]] remoteExec ["systemChat", 0]}; 
  // has a vital HitPoint been destroyed 
  _damageByTarget = []; 
  {  
   _criticalHitPointStatus = []; 
   _unit = _x; 
     { 
      _criticalHitPointStatus pushBack (floor (_unit getHitPointDamage _x)) 
   } forEach ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"]; 
   _damageByTarget pushBack _criticalHitPointStatus; 
  } forEach _targetList; 
    
  //logging 
  private _resultCache = createHashMap; 
  _resultCache set ["Function", "AK_fnc_weaponTest"];  
  _resultCache set ["systemTimeUTC", systemTimeUTC];  
  _resultCache set ["anchorPos", _anchorPos];  
  _resultCache set ["spacing", _spacing];  
  _resultCache set ["shooting_distance", _shooting_distance];   
  _resultCache set ["shooter_heading", _shooter_heading];  
  _resultCache set ["shooterCount", _shooterCount];  
  _resultCache set ["shooterWeapon", _shooterWeapon];  
  _resultCache set ["shooterAmmo", _shooterAmmo];  
  _resultCache set ["vehicleCount", _vehicleCount];  
  _resultCache set ["TgtType", _TgtType];  
  _resultCache set ["TgtAspect", _TgtAspect];  
  _resultCache set ["mannedTargets", _mannedTargets];  
  _resultCache set ["destroyedVehicles", _destroyedVehicles]; 
  _resultCache set ["damageByTargetHullLtrackRtrackEngineTurretGun", _damageByTarget]; 
  _resultCache set ["KilledShooters", (_shooterCount - ({alive _x} count (units _shooterGroup)))];  
  if (_mannedTargets == true) then { 
   _resultCache set ["killedCrewmen", ({!alive _x} count _targetCrewmen)]; 
   _resultCache set ["createdCrewmen", (count _targetCrewmen)]; 
  }; 
  [toJSON _resultCache, "AK_fnc_weaponTest trial summary"] call CBA_fnc_debug; 
   
 } else {diag_log "WARNING AK_fnc_weaponTest: target or shooter count missmatch. Check if all targets and shooters have been created properly."}; 
 //cleanup 
 {deleteVehicle _x} forEach allUnits; 
 {deleteVehicle _x} forEach allDead; 
 {deleteVehicle _x} forEach vehicles; 
 AK_testRunning = false;    
}; 
