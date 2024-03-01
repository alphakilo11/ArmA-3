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
	_initialFPS = diag_frameNo;
	_initialTime = diag_tickTime;
	sleep _delayInS;
	_longFpsAvg = (diag_frameNo - _initialFPS) / (diag_tickTime - _initialTime);

	while {(_longFpsAvg < 40) or (diag_fpsMin < 40)} do {
		diag_log format ["AK_fnc_delay: Suspending due to low FPS. %1 groups, %2 units, %3 FPS (long average.)", (count allGroups), (count allUnits), _longFpsAvg];
		_initialFPS = diag_frameNo;
		_initialTime = diag_tickTime;		
		sleep 60;
		_longFpsAvg = (diag_frameNo - _initialFPS) / (diag_tickTime - _initialTime);
	};
	[_location] call AK_fnc_battlelogger_standalone;
};
