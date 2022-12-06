/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgGroupTable

Description:
    Creates a table of all groups from a given faction. Some factions have no defined groups.
	
Parameters:
    0: _cfgfaction	- Faction <STRING> (default: "BLU_F")

Returns:
	<ARRAY>

Example:
    (begin example)
		["BLU_F"] call AK_fnc_cfgGroupTable; 
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgGroupTable = {
params [
    ["_cfgfaction","BLU_F", []]
];
private ["_cfgSide", "_newCfgEntry", "_arm", "_groups"];

//get side of _cfgfaction
_cfgSide = getNumber (configFile >> "CfgFactionClasses" >> _cfgfaction >> "side"); 
_newCfgEntry = ("getNumber (_x >> 'side') == _cfgSide" configClasses (configFile >> "CfgGroups") apply {configName _x}) select 0; 
_newCfgEntry = configFile >> "CfgGroups" >> _newCfgEntry;
//iterate through arms and get all groups that have matching sides
_arm = "true" configClasses (_newCfgEntry >> _cfgfaction) apply {configName _x}; 
_groups = []; 
{_groups pushBack ("getNumber (_x >> 'side') == _cfgSide" configClasses (_newCfgEntry >> _cfgfaction >> _x));} forEach _arm; 
flatten _groups; 
};