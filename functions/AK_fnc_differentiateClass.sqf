// Function to differentiate config entries between vehicles and groups
// Returns: "Vehicle" if the class is found in CfgVehicles, "Group" if found in CfgGroups, "Unknown" otherwise 
// Example usage 
//_fullPath = configFile >> "CfgGroups" >> "Indep" >> "SPE_US_ARMY" >> "Armored" >> "SPE_M4A1_75_Platoon"; // Example full path 
//_result = [_fullPath] call AK_fnc_differentiateClass; 
// hint format ["%1 is a %2", _fullPath, _result]; 
AK_fnc_differentiateClass = { 
	params ["_candidate"];
	if ((_candidate call BIS_fnc_getCfgIsClass) == true) then {
		if ("CfgGroups" in str _candidate) exitWith { "Group" };
		"Vehicle";
	} else {
		if ((isClass (configFile >> "CfgVehicles" >> _candidate)) == true) exitWith { "Vehicle" };
		"Unkown"	
	};
}; 
 