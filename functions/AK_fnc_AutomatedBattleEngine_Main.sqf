/* ----------------------------------------------------------------------------
Function:
	AK_fnc_AutomatedBattleEngine_Main

Requires:
	AK_fnc_battlelogger, AK_fnc_spacedvehicles

Description:
    Create a Begegungsgefecht between two parties and logs the results.
	
Parameters:
    0: _unitTypes		- Unit Types to choose from (Confignames) <ARRAY> (default: ["B_MBT_01_cannon_F"])
    1: _location 		- Lower left corner of spawn area <ARRAY> (default: [0,0,0])
    2: _delay			- Delay in seconds between execution of this function <INT> (default: 60)

Returns:
	The PFH logic.  <LOCATION>

Example:
	Battle between random armored vehicles (defined as 'tank' in the configFile)
    (begin example)
		[(("configName _x isKindOf 'tank' and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles")) apply {(configName _x)}), [4000, 7000,0], 60] call AK_fnc_automatedBattleEngine;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
/* 
TODO stop AK_fnc_battlelogger when shutting down ABE (use prototype) ("(_AKBL getVariable "handle") call CBA_fnc_deletePerFrameHandlerObject;" didn't work) Likely reason: it was initialized inside an if statement
*/
AK_fnc_automatedBattleEngine = {

	params [
		["_unitTypes", ["B_MBT_01_cannon_F"], [[]]],
		["_location", [0,0,0], [[]]],
		["_delay", 60, [0]]
		];
	AK_var_fnc_automatedBattleEngine_unitTypes = _unitTypes; // store Unittypes for further use (eg AK_fnc_battlelogger)
	AK_var_fnc_automatedBattleEngine_location = _location; // store location for further use (eg AK_fnc_battlelogger)
	// create variable for logging

	AK_ABE = [
		{ // The function you wish to execute.  <CODE>
		private ["_var"];
		_var = missionNamespace getVariable "AK_battlingUnits"; 
		if (isNil "_var") then { 
			_AKBL = [] spawn AK_fnc_battlelogger;
			_round = _round + 1; 
			diag_log format ["ABE round %1", _round];
		} else {
			diag_log "AK Automated Battle Engine already running.";
		};
		},

		_delay, // The amount of time in seconds between executions, 0 for every frame.  (optional, default: 0) <NUMBER>

		[], //Parameters passed to the function executing.  (optional) <ANY>

		{ // Function that is executed when the PFH is added.  (optional) <CODE>
			diag_log format ["ABE Battle Engine starting!"];
			_round = 0;
		},

		{ // Function that is executed when the PFH is removed.  (optional) <CODE>
		 	diag_log format ["ABE stopping Battle Engine!"];
		}, 

		{true}, // Condition that has to return true for the PFH to be executed.  (optional, default {true}) <CODE>

		{false}, //Condition that has to return true to delete the PFH object.  (optional, default {false}) <CODE>

		["_round"] // List of local variables that are serialized between executions.  (optional) <CODE>
	] call CBA_fnc_createPerFrameHandlerObject;
};
