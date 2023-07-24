/* ----------------------------------------------------------------------------
Function: AK_fnc_populateMap

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    ["_referencePosition", [0,0,0], [[]]],    
    ["_areaSideLength", worldSize, [0]],    
    ["_spacing", true],    
    ["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile, ""]],    
    ["_side", east, [east]],     
    ["_numberOfGroups", 128, [0]],   //this is just used to calculate the spacing
    ["_landOnly", true, [false]],   
    ["_serverOnly", true, [false]]   
Returns:
	[_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter]

Example:
    (begin example)
        [[0, 0, 0], worldSize, true, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", independent, 287] spawn AK_fnc_populateMap;    
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_populateMap = {    

  #define RANDOM_CONFIG_CLASS(var) selectRandom ("true" configClasses (var))    
  
 params [    
  ["_referencePosition", [0,0,0], [[]]],    
  ["_areaSideLength", worldSize, [0]],    
  ["_spacing", true],    
  ["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile, ""]],    
  ["_side", east, [east]],     
  ["_numberOfGroups", 128, [0]],   //this is just used to calculate the spacing
  ["_landOnly", true, [false]],   
  ["_serverOnly", true, [false]]   
 ];    
   
 if (_serverOnly == true and isServer == false) exitWith {   
  hint "AK_fnc_populateMap parameters are set to spawn on server only.";   
 };   
  
 _random = false;  
 if ((typeName _groupType == typeName "") and {_groupType == "random"}) then {  
  _random = true;  
 } else {
     if (typeName _groupType == typeName "") exitWith {
         diag_log format ["AK_fnc_populateMap ERROR: got %1, expected configFile or 'random'.", _groupType];
     };
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
   if ((_landOnly == true) and {surfaceIsWater _spawnPosition == true}) then {   
        _x = _x + _spacing;   
        continue;   
    };  
   if (_random == true) then {  
    _groupType = RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(configFile >> "cfgGroups" >> "east")));  
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
