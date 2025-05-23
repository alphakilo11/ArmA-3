// returns a list containing the typenames of the selected vehicles
_vehicleTypes = [];
{
	_vehicleTypes pushBack (typeOf _x)
} forEach (curatorSelected select 0);
_vehicleTypes;

/* a function that spawns random vehicles from  given array of types and let's them patrol an area 
	 
	Area Array format: [centre, a, b, angle, isRectangle, c] 
	 centre: Array format Position2D or PositionAGL, Object or group  
	 a: Number - x axis (x / 2)  
	 b: Number - y axis (y / 2)  
	 angle: Number - (Optional, default 0) rotation angle  
	 isRectangle: Boolean - (Optional, default false) true if rectangle, false if ellipse  
	 c: Number - (Optional, default -1: unlimited) z axis (z / 2) 
*/ 
AK_fnc_VehiclesPatrolArea = {
	params ["_centerpoint", "_radius", "_vehicleNumber", "_vehicleTypes", "_side", "_searchRadius"];
	for "_i" from 1 to _vehicleNumber do {
		_spawnPos = _centerpoint getPos [_radius * sqrt random 1, random 360];
		_spawned = [_spawnPos, random 360, selectRandom _vehicleTypes, _side] call BIS_fnc_spawnVehicle;
		(_spawned select 2) deleteGroupWhenEmpty true;
		(_spawned select 0) allowCrewInImmobile true;
		  [(_spawned select 2), [_spawnPos, _searchRadius, _searchRadius, 0, true], 'Relaxed'] call CBA_fnc_taskSearchArea; // [[1000, 1000, 0], 1000, 1000, 0, true]
	};
};

// _vehicleTypes = ["rhs_t14_tv", "rhs_t72ba_tv", "rhs_t72bb_tv", "rhs_t72bc_tv", "rhs_t72bd_tv", "rhs_t72be_tv", "rhs_t80", "rhs_t80a", "rhs_t80b", "rhs_t80bk", "rhs_t80bv", "rhs_t80u", "rhs_t80u45m", "rhs_t80ue1", "rhs_t80uk", "rhs_t80um", "rhs_t90_tv", "rhs_t90a_tv", "rhs_t90am_tv", "rhs_t90saa_tv", "rhs_t90sab_tv", "rhs_t90sm_tv", "rhs_bmp1_tv", "rhs_bmp1d_tv", "rhs_bmp1k_tv", "rhs_bmp1p_tv", "rhs_bmp2e_tv", "rhs_bmp2_tv", "rhs_bmp2d_tv", "rhs_bmp2k_tv", "rhs_brm1k_tv", "rhs_prp3_tv", "rhs_t15_tv", "rhs_2s1_at_tv", "rhs_2s3_at_tv", "rhs_btr80a_msv", "rhs_btr80_msv", "rhs_btr70_msv", "rhs_btr60_msv", "RHS_BM21_MSV_01", "rhs_bmp3_msv", "rhs_bmp3_late_msv", "rhs_bmp3m_msv", "rhs_bmp3mera_msv", "rhs_Ob_681_2", "RHS_ZU23_MSV", "rhs_SPG9M_MSV", "rhs_Kornet_9M133_2_msv", "rhs_Metis_9k115_2_msv", "rhs_9k79", "rhs_9k79_K", "rhs_9k79_B", "rhs_bmd1", "rhs_bmd1k", "rhs_bmd1p", "rhs_bmd1pk", "rhs_bmd1r", "rhs_bmd2", "rhs_bmd2k", "rhs_bmd2m", "rhs_bmd4_vdv", "rhs_bmd4m_vdv", "rhs_bmd4ma_vdv", "rhs_sprut_vdv", "rhs_gaz66_zu23_vdv", "RHS_Ural_Zu23_VDV_01", "rhs_pts_vmf", "rhs_zsu234_aa"]; 
_vehicleTypes = [];
{
	if ((configName _x) isKindOf "Tank" && {
		getNumber (_x >> "scope") == 2
	}) then {
		_vehicleTypes pushBack configName _x;
	};
} forEach ("true" configClasses (configFile >> "CfgVehicles"));
[[15000, 20000, 0], 1000, 31, _vehicleTypes, east, 200] spawn AK_fnc_VehiclesPatrolArea;
// [[13000, 20000, 0], 1000, 31, _vehicleTypes, west, 200] spawn AK_fnc_VehiclesPatrolArea;

// equipping the player with a random primary weapon
[] spawn {
	_weaponsArray = 'getNumber (_x >> "ACE_barrelLength") > 0' configClasses (configFile >> "CfgWeapons");
	 // select a random weapon and its magazine from the array  
	_candidateWeapon = selectRandom _weaponsArray;
	_magazine = ((_candidateWeapon >> "magazines") call BIS_fnc_getCfgDataArray) select 0;
	_fireMode = (getArray (_candidateWeapon >> "modes")) select 0;

	  // Assign the random weapon and magazine to the player 
	_candidateWeapon = configName _candidateWeapon;
	for "_i" from 0 to 5 do {
		player addMagazine _magazine;
	};
	player addWeapon _candidateWeapon;
};

// switch through and fire all available weapons
[] spawn {
	_weaponsArray = 'getNumber (_x >> "ACE_barrelLength") > 0' configClasses (configFile >> "CfgWeapons");
	_testWeapons = [];
	for "_i" from 0 to 9 do {
		_candidate = selectRandom _weaponsArray;
		_mags = (_candidate >> "magazines") call BIS_fnc_getCfgDataArray;
		if (count _mags > 0) then {
			_testWeapons pushBack _candidate;
		};
	};
	_testWeapons = _weaponsArray;
	_counter = 0;
	{
		// select a random weapon and its magazine from the array 
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
_groupList = [];
for "_x" from 0 to 1 do {
	for "_y" from 0 to 1 do {
		_group = [[(_anchorPoint select 0) + _x * _spacing, (_anchorPoint select 1) + _y * _spacing, 0], _side, _groupType] call BIS_fnc_spawnGroup;
		_group deleteGroupWhenEmpty true;
		[_group] call CBA_fnc_taskPatrol;
		_groupList pushBack _group;
	};
};
_groupList

// Versuch objecte im Visier des Spieler zu identifizieren
onEachFrame {
	_facingPosition = screenToWorld [0.5, 0.5];
	_allObjects = nearestObjects [_facingPosition, ["CAManBase"], 5];
	_relevantObjects = _allObjects select {
		alive _x
	};
	hintSilent format ["%1 %2", _relevantObjects, _facingPosition];
};

// drawLine3D experiment
AK_var_drawline = true;
AK_var_testCoordinates = [[9487.56, 21802.4, 18.3415], [9491.27, 21794.5, 18.9956], [9494.85, 21786.9, 19.6253], [9498.51, 21779.2, 20.2682], [9502.25, 21771.2, 20.9236], [9506.28, 21762.7, 21.6273], [9510.38, 21754, 22.3421], [9514.45, 21745.4, 23.0499], [9518.29, 21737.3, 23.7156], [9522, 21729.4, 24.3578], [9525.58, 21721.8, 24.9769], [9529.04, 21714.4, 25.5737], [9532.48, 21707.1, 26.1653], [9535.9, 21699.9, 26.7519], [9539.4, 21692.5, 27.3501], [9542.78, 21685.3, 27.9267], [9546.13, 21678.2, 28.4984], [9549.47, 21671.1, 29.0653], [9552.78, 21664.1, 29.6275], [9556.08, 21657.1, 30.1849], [9559.36, 21650.2, 30.7377], [9562.71, 21643, 31.3015], [9565.94, 21636.2, 31.8449], [9569.25, 21629.2, 32.3993], [9572.45, 21622.4, 32.9336], [9575.81, 21615.2, 33.4938], [9578.68, 21609.1, 33.9283], [9580.26, 21605.8, 34.0877], [9580.37, 21605.6, 34.0984]];
onEachFrame {
	if (AK_var_drawline == true) then {
		// drawLine3D [ASLToAGL eyePos player, ASLToAGL eyePos unlucky, [1, 0, 0, 1]]; 
		       // drawLine3D [getPos player, getPos cursorTarget, [1, 1, 1, 1]];
		for "_i" from 0 to (count AK_var_testCoordinates - 2) do {
			drawLine3D [ASLToAGL (AK_var_testCoordinates select _i), ASLToAGL (AK_var_testCoordinates select (_i + 1)), [1, 0, 0, 1]];
			       // _startPoint = ASLToAGL [9579.37, 21620.9, 33.2578];
			       // _endPoint = _startPoint vectorAdd [311.375, -559.462, 47.0785]; 
			       // drawLine3D [_startPoint, _endPoint, [1, 0, 0, 1]];
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
		AK_var_testData pushBack _this;
	}];

	// FPS aufzeichnen
	AK_fnc_recordFPS = {
		[{
			if (isNil "AK_object_dataVAult") then {
				[] call AK_fnc_dataVaultInitialize;
			};
		}] remoteExec ["call", 2];
	};

	(allVariables AK_object_dataVAult) select {
		"datavaultofnetid" in _x
	};

	// creating a grid of groups
	for "_x" from 0 to 14 do {
		for "_y" from 0 to 7 do {
			_group = [[_x * 1000, _y * 1000, 0], west, 8] call BIS_fnc_spawnGroup;
			_group deleteGroupWhenEmpty true;
			[_group] call CBA_fnc_taskPatrol;
		};
	};

	onEachFrame {
		hintSilent str (round diag_fps)
	}

	// delete dead vehicles
	{
		deleteVehicle _x;
	} forEach allDeadMen;

	// drawing 3D lines and different methods to get what the player is looking at
	AK_var_drawline = true;
	onEachFrame {
		if (AK_var_drawline == true) then {
			// drawLine3D [ASLToAGL eyePos player, ASLToAGL eyePos unlucky, [1, 0, 0, 1]];
			       // drawLine3D [getPos player, getPos cursorTarget, [1, 1, 1, 1]];
			_endPoint = screenToWorld [0.5, 0.5];
			drawLine3D [ASLToAGL eyePos player, _endPoint, [1, 0, 0, 1]];
			systemChat str cursorObject
		};
	};


// Get all magazines in the vehicle
private _vehicle = vehicle player;
private _magazines = magazines _vehicle;

// Remove all magazines except smoke shells
{
    private _magazineClass = _x;
    private _isSmokeShell = {
        params ["_magazineClass"];
        private _config = configFile >> "CfgMagazines" >> _magazineClass;
        private _displayName = getText (_config >> "displayName");
        private _description = getText (_config >> "descriptionShort");
        
        // Check if magazine contains "smoke" in either display name or description
        ("SMOKE" in toUpper _displayName) || 
        ("SMOKE" in toUpper _description) ||
        ("smoke_" in toLower _magazineClass)
    };

    if !(_magazineClass call _isSmokeShell) then {
        _vehicle removeMagazine _x;
    };
} forEach _magazines;