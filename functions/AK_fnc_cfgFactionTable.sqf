/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgFactionTable

Description:
    Creates a table of factions.
	Use to provide input to AK_fnc_cfgGroupTable.
	
Parameters:
    0: _side		- 0 = OPFOR, 1 = BLUFOR, 2 = Independent <NUMBER>
	1: _configName	- false = full config entry, true = configName <BOOLEAN> (default: true)

Returns:
	<ARRAY>

Example:
    (begin example)
		[2] call AK_fnc_cfgFactionTable;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgFactionTable = {
params [
	"_side",
	["_configName", 1]
];
switch (_configName) do {
	case 1: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses") apply {configName _x};};
	case 0: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses");};
};
};

