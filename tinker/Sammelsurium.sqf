AK_fnc_recordFPS = {
	[{
		if (isNil "AK_object_dataVAult") then {
			[] call AK_fnc_dataVaultInitialize;
		};
	
	}] remoteExec ["call", 2];
};

(allVariables AK_object_dataVAult) select {"datavaultofnetid" in _x};

for "_x" from 0 to 14 do {
	for "_y" from 0 to 7 do {
		_group = [[_x * 1000,_y * 1000,0], west, 8] call BIS_fnc_spawnGroup;
		_group deleteGroupWhenEmpty true;
		[_group] call CBA_fnc_taskPatrol;
	};
};

onEachFrame {hintsilent str (round diag_fps)}

// delete dead vehicles
{ 
	deleteVehicle _x; 

} forEach allDeadMen;

