// switch through and fire all available weapons
[] spawn {
	_weaponsArray = 'getNumber (_x >> "ACE_barrelLength") > 0' configClasses (configFile >> "CfgWeapons");
	_testWeapons = [];
	for "_i" from 0 to 9 do {
		_candidate = selectRandom _weaponsArray;
		_mags =  (_candidate >> "magazines") call BIS_fnc_getCfgDataArray;
		if (count _mags > 0) then {
			_testWeapons pushBack _candidate;
		};
	};
	_testWeapons = _weaponsArray;
	_counter = 0;
	{ 
		// Select a random weapon and its magazine from the array 
		_candidateWeapon = _x;  
		_magazine = ((_candidateWeapon >> "magazines") call BIS_fnc_getCfgDataArray) select 0;
		_fireMode = (getArray (_candidateWeapon >> "modes")) select 0; 
		 
		// Assign the random weapon and magazine to the player
		_candidateWeapon = configName _candidateWeapon; 
		player addMagazine _magazine; 
		player addWeapon _candidateWeapon; 
		 
		// Wait for a short moment to ensure the weapon is equipped 
		sleep 2; 
		 
		// Force the player to fire the weapon 
		player selectWeapon _candidateWeapon; 
		player forceWeaponFire [_candidateWeapon, _fireMode];
		
		_counter = _counter + 1;
		systemChat format ["%1 weapons fired. %2 to go.", _counter, count _testWeapons - _counter]; 
	} forEach _testWeapons;
	systemChat str count _testWeapons; 
};



// creating multiple groups 
_spacing = 316;
_anchorPoint = [10200, 18900, 0];
_groupType = configFile >> "CfgGroups" >> "Indep" >> "LIB_US_ARMY" >> "Armored" >> "LIB_M4A3_75_Platoon"; // configFile >> "CfgGroups" >> "Indep" >> "SPE_US_ARMY" >> "Armored" >> "SPE_M4A1_75_Platoon";
_side = independent;
for "_x" from 0 to 1 do { 
    for "_y" from 0 to 1 do { 
        _group = [[(_anchorPoint select 0) + _x * _spacing,(_anchorPoint select 1) + _y * _spacing, 0], _side, _groupType] call BIS_fnc_spawnGroup; 
        _group deleteGroupWhenEmpty true;
        [_group] call CBA_fnc_taskPatrol; 
    }; 
};


// Versuch objecte im Visier des Spieler zu identifizieren
onEachFrame {
_facingPosition = screenToWorld [0.5, 0.5];
_allObjects = nearestObjects [_facingPosition, ["CAManBase"], 5];
_relevantObjects = _allObjects select {alive _x};
hintSilent format ["%1 %2",_relevantObjects, _facingPosition];
};

// drawLine3D experiment
AK_var_drawline = true;
AK_var_testCoordinates = [[9487.56,21802.4,18.3415],[9491.27,21794.5,18.9956],[9494.85,21786.9,19.6253],[9498.51,21779.2,20.2682],[9502.25,21771.2,20.9236],[9506.28,21762.7,21.6273],[9510.38,21754,22.3421],[9514.45,21745.4,23.0499],[9518.29,21737.3,23.7156],[9522,21729.4,24.3578],[9525.58,21721.8,24.9769],[9529.04,21714.4,25.5737],[9532.48,21707.1,26.1653],[9535.9,21699.9,26.7519],[9539.4,21692.5,27.3501],[9542.78,21685.3,27.9267],[9546.13,21678.2,28.4984],[9549.47,21671.1,29.0653],[9552.78,21664.1,29.6275],[9556.08,21657.1,30.1849],[9559.36,21650.2,30.7377],[9562.71,21643,31.3015],[9565.94,21636.2,31.8449],[9569.25,21629.2,32.3993],[9572.45,21622.4,32.9336],[9575.81,21615.2,33.4938],[9578.68,21609.1,33.9283],[9580.26,21605.8,34.0877],[9580.37,21605.6,34.0984]]; 
onEachFrame { 
    if (AK_var_drawline == true) then { 
        //drawLine3D [ASLToAGL eyePos player, ASLToAGL eyePos unlucky, [1,0,0,1]]; 
       // drawLine3D [getPos player, getPos cursorTarget, [1,1,1,1]];
       for "_i" from 0 to (count AK_var_testCoordinates - 2) do {
           drawLine3D [ASLToAGL (AK_var_testCoordinates select _i), ASLToAGL (AK_var_testCoordinates select (_i + 1)), [1,0,0,1]];
        //_startPoint = ASLToAGL [9579.37,21620.9,33.2578];
        //_endPoint = _startPoint vectorAdd [311.375,-559.462,47.0785]; 
        //drawLine3D [_startPoint, _endPoint, [1,0,0,1]];  
    }; 
};


// Hashmap experiment
private _myHashMap = createHashMap; 

_myHashMap set ["key1", []];
player setVariable ["testhashmap", _myHashMap];

_retrievedMap = player getVariable ["testhashmap", ""];
_retrievedArray = _retrievedMap get "key1";
_retrievedArray pushBack 42;
_retrievedMap set ["key1", _retrievedArray];
player setVariable ["testhashmap", _retrievedMap];

_jodesisdiemap = player getVariable ["testhashmap", ""];
_jodesisdiemap get "key1"


// creating a target and experimenting with "Dammaged" EventHandler
_target = 'C_man_p_beggar_F' createVehicle (player getPos [500, direction player]);

_target addEventHandler ["Dammaged", { 
 params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];
 AK_var_testData  pushBack _this; 
}];


// FPS aufzeichnen
AK_fnc_recordFPS = {
	[{
		if (isNil "AK_object_dataVAult") then {
			[] call AK_fnc_dataVaultInitialize;
		};
	
	}] remoteExec ["call", 2];
};

(allVariables AK_object_dataVAult) select {"datavaultofnetid" in _x};

// creating a grid of groups
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
