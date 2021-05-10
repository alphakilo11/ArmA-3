AK_test1 = [{
//function
_veh = _AK_battlingUnits select 0;
_units = _AK_battlingUnits select 1;
_groups = _AK_battlingUnits select 2;
systemChat str _AK_battlingUnits;
},
10, //delay in s
[], //parameters
// start
{systemChat "Battlelogger starting!";
_AK_battlingUnits = ["a1", ["b1", "b2"], "c1"]; //initialize the global variable
},
//end
{
	systemChat "Battle over. Battlelogger shutting down";
	_AK_battlingUnits = nil;
	},
{true}, //Run condition
//exit Condition
{false},
_AK_battlingUnits, //List of local variables that are serialized between executions.
] call CBA_fnc_createPerFrameHandlerObject;
