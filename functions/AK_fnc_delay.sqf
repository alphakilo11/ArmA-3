/* ---------------------------------------------------------------------------- 
Function: AK_fnc_delay
 
Description: 
    Special tool for ABE to allow a delay between calls of the battlelogger.
Parameters: 
	0: _location	- <ARRAY>
	1: _delayInS	- <NUMBER>
 
Example: 
    (begin example) 
    [[0,0,0], 5] spawn AK_fnc_delay;
    (end) 
 
Returns: 
    NIL
 
Author: 
    AK
---------------------------------------------------------------------------- */
AK_fnc_delay = {
	params ["_location", "_delayInS"];
	if (canSuspend == False) exitWith {
		diag_log "ERROR AK_fnc_delay: Scope is not suspendable";
	};
	sleep _delayInS;
	while {diag_fps < 40} do {
		diag_log format ["AK_fnc_delay: Suspending due to low FPS. %1 groups, %2 units", (count allGroups), (count allUnits)];
		sleep 60;
	};
	[_location] call AK_fnc_battlelogger_standalone;
};
