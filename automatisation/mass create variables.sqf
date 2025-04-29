//Create variable names with loops
//use setVariable and getVariable to actually use them
_result = [];
for "_i" from 1 to 5 do {
	_result pushBack ("AK_fnc_" + str _i)};
_result; //["AK_fnc_1","AK_fnc_2","AK_fnc_3","AK_fnc_4","AK_fnc_5"]