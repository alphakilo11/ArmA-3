// 52 ms/10.000 cycles
#define RANDOM_CONFIG_CLASS(var) selectRandom ("true" configClasses (var))
count RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(configFile >> "cfgGroups" >> "west")));

// same as above but takes 132 ms/10.000 cycles
private ["_cfgArray", "_faction", "_group", "_units"];
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West");
_faction = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction);
_arm = configName (selectRandom _cfgArray);
_cfgArray = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm);
_group = configName (selectRandom _cfgArray);
_units = "true" configClasses (configFile >> "CfgGroups" >> "West" >> _faction >> _arm >> _group);
count _units;