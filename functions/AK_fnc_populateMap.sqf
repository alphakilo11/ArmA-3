AK_fnc_populateMap = {  
 /*  

  
  288 is the group limit for each side  
  
  Example:  
   [[0, 0, 0], worldSize, true, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", independent, 287] spawn AK_fnc_populateMap;  
 */  
  
 params [  
  ["_referencePosition", [0,0,0], [[]]],  
  ["_areaSideLength", worldSize, [0]],  
  ["_spacing", true],  
  ["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile]],  
  ["_side", east, [east]],   
  ["_numberOfGroups", 128, [0]], 
  ["_landOnly", true, [false]], 
  ["_serverOnly", true, [false]] 
 ];  
 
 if (_serverOnly == true and isServer == false) exitWith { 
  hint "AK_fnc_populateMap parameters are set to spawn on server only."; 
 }; 
 // auto determine spacing  
 if (_spacing == true) then {  
  _spacing = _areaSideLength / (sqrt _numberOfGroups);  
 };  
  
 enableDynamicSimulationSystem true;  
   
 private _x = 0;  
 private _y = 0;  
 private _groupCounter = 0;   
 while {_y < _areaSideLength} do {  
  while {_x < _areaSideLength} do {  
   if (({side _x == _side} count allGroups) >= 288) exitWith { 
    [_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter]; 
   };  
   _spawnPosition = _referencePosition vectorAdd [_x, _y, 0]; 
   if (_landOnly == true and surfaceIsWater _spawnPosition == true) then { 
        _x = _x + _spacing; 
        continue; 
    };          
   _group = [_spawnPosition, _side, _groupType] call BIS_fnc_spawnGroup;  
   _group deleteGroupWhenEmpty true;   
   _group enableDynamicSimulation true;  
   [_group, _spawnPosition, _spacing * 0.66, 3, 0.1, 0.9] call CBA_fnc_taskDefend;  
   _groupCounter = _groupCounter + 1;  
   _x = _x + _spacing;  
  };  
 _x = 0;  
 _y = _y + _spacing;  
 };  
 [_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter]   
};  
