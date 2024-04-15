 AK_fnc_defend = {  
//creates a number of groups or vehicles in an area around _refPos.  
//Works local and on DS  
//REQUIRED: CBA  
//Params _refPos 3D position  
/*  
Example:  
    (begin example)  
    [[0, 0, 0], 77, resistance, "I_MBT_03_CANNON_F"] spawn AK_fnc_defend;  
    (end)
    (begin example)  
    [[0,0,0], 77, resistance, configFile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad" ] spawn AK_fnc_defend;  
    (end) 
*/  

 if (isNil "AK_fnc_differentiateClass") exitWith {diag_log "AK_fnc_defend ERROR: AK_fnc_differentiateClass required"};  
 
 params ["_refPos", "_numberofgroups", "_side", "_grouptype"];
 _gkgfDichte = 3.14; //vehicles or groups per km²

 private _area = _numberofgroups /_gkgfDichte; 
 private _radius = sqrt(_area / 3.14) * 1000; 
 for "_i" from 1 to _numberofgroups step 1 do {  
  private _vfgrm = [_refPos, 0, _radius] call BIS_fnc_findSafePos;  
  private _gruppe = nil;  
  if ((_grouptype call AK_fnc_differentiateClass) == "Group") then {  
   _gruppe = [_vfgrm, _side, _grouptype] call BIS_fnc_spawnGroup;  
  };  
  if ((_grouptype call AK_fnc_differentiateClass) == "Vehicle") then {  
   _gruppe = ([_vfgrm, 270, _grouptype, _side] call BIS_fnc_spawnVehicle) select 2;  
  };  
  if (isNull _gruppe) exitWith {diag_log "AK_fnc_defend ERROR: no groups spawned"};  
  _gruppe deleteGroupWhenEmpty true;  
//  [_gruppe, _refPos, _radius] call CBA_fnc_taskDefend;  
 };  
};  
