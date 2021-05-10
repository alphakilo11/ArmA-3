/* Has to run on the same machine as the battle - unless I make AK_battlingUnits global...
Requires: AK_fnc_battlelogger, AK_fnc_spacedvehicles
TODO log remaining vehicles per side
TODO switch sides
TODO stop AK_fnc_battlelogger when shutting down ABE (use prototype) ("(_AKBL getVariable "handle") call CBA_fnc_deletePerFrameHandlerObject;" didn't work)
make all local variables private
*/

AK_ABE = [
{ private _var = missionNamespace getVariable "AK_battlingUnits"; 
if (isNil "_var") then { 
	_AKBL = [] spawn AK_fnc_battlelogger;
	_round = _round + 1; 
	diag_log format ["AKBL round %1", _round];
};
},
	
60,
	
["some_params", [1,2,3]],

{diag_log format ["AKBL Battle Engine starting! %1", _this getVariable "params"];
_round = 0;},

{
 diag_log format ["AKBL stopping Battle Engine! params: %1",   _this getVariable "params"];
 },

{true},

{false},

["_round", "_AKBL"]
] call CBA_fnc_createPerFrameHandlerObject;