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

for "_x" from 0 to 14 do {
    for "_y" from 0 to 7 do {
        _group = [[_x * 1000,_y * 1000,0], west, 8] call BIS_fnc_spawnGroup;
        _group deleteGroupWhenEmpty true;
        [_group] call CBA_fnc_taskPatrol;
    };
};

// drawing 3D lines and different methods to get what the player is looking at
AK_var_drawline = true;
onEachFrame {
    if (AK_var_drawline == true) then {
        //drawLine3D [ASLToAGL eyePos player, ASLToAGL eyePos unlucky, [1,0,0,1]];
       // drawLine3D [getPos player, getPos cursorTarget, [1,1,1,1]];
        _endPoint = screenToWorld [0.5, 0.5];
        drawLine3D [ASLToAGL eyePos player, _endPoint, [1,0,0,1]];
        systemChat str cursorObject
    };
};
