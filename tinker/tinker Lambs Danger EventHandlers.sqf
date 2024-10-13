// works
["lambs_danger_OnContact", {
	systemChat "Contact!";
}] call CBA_fnc_addEventHandler;

["lambs_danger_OnContact", {
	params ["_unit", "_group"];
	systemChat format ["Unit: %1 of group %2 has contact!", _unit, _group];
}] call CBA_fnc_addEventHandler;