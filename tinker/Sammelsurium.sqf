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
	_subject = unlucky;
	_target = target;
	group _subject setBehaviour "AWARE"; // AI will not fire when "SAFE"
	_weaponsArray = 'getNumber (_x >> "ACE_barrelLength") > 0' configClasses (configFile >> "CfgWeapons");
	_testWeapons = [];
	for "_i" from 1 to 10 do {
		_candidate = selectRandom _weaponsArray;
		_mags = (_candidate >> "magazines") call BIS_fnc_getCfgDataArray;
		if (count _mags > 0) then {
			_testWeapons pushBack _candidate;
		};
	};
	//_testWeapons = _weaponsArray;
	_counter = 0;
	{
		// select a random weapon and its magazine from the array 
		_candidateWeapon = _x;
		_magazine = [configName _candidateWeapon] call bis_fnc_compatibleMagazines select 0;
		_fireMode = (getArray (_candidateWeapon >> "modes")) select 0;

		// Assign the random weapon and magazine to the subject
		_candidateWeapon = configName _candidateWeapon;
		_subject addWeapon _candidateWeapon;
		_subject addPrimaryWeaponItem _magazine; // Load mag into weapon
		// Wait for a short moment to ensure the weapon is equipped 
		
		_subject selectWeapon _candidateWeapon;
		_subject doTarget _target;
		sleep 2;
		_subject forceWeaponFire [_candidateWeapon, _fireMode];

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


// shows gun elevation relative to world in mil
onEachFrame {
	_vehicle = vehicle player;
	private _weaponDir = _vehicle vectorModelToWorld (_vehicle weaponDirection (currentWeapon _vehicle)); 
	private _elevationAngle = asin (_weaponDir select 2);
	hintSilent str round (_elevationAngle / 360 * 6400); 
};


// player stats
((getPlayerScores player) select 0); // Infantry kills
AK_testEventHandler = (vehicle player) addEventHandler ["Fired", { 
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	//diag_log str (_unit getVariable "AK")
	_unitStats = _unit getVariable ["AK_unitStats", 0];
	if ((typeName _unitStats) != "HASHMAP") then {
		_unitStats = createHashMap;
	};
	_keyString = str (_weapon + ', ' + _ammo);
	_shotCount = _unitStats getOrDefault [_keyString, 0];
	_shotCount = _shotCount + 1;
	_unitStats set [_keyString, _shotCount];
	_unit setVariable ["AK_unitStats", _unitStats];
	systemChat str this;
	systemChat str [_weapon,_ammo, _shotCount];
	_projectile addEventHandler ["HitPart", { 
		 params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"];
		 [str _this] call CBA_fnc_log; 
	}];
	AK_var_trackedProjectile = _projectile;
	onEachFrame {hintSilent str [round vectorMagnitude velocity AK_var_trackedProjectile, round (getPosASL AK_var_trackedProjectile select 2)]};
}]; 


// BULLETCAM
//(vehicle player) call BIS_fnc_diagBulletCam; 
//[vehicle player] call CBA_fnc_addUnitTrackProjectiles;
(vehicle player) addEventHandler ["Fired", {
	_null = _this spawn {
		_missile = _this select 6;
		_cam = "camera" camCreate (position player);
		_cam cameraEffect ["External", "Back"];
		// Launch sequence
		_cam camSetTarget _missile;
		_cam camSetRelPos [-10,-10 - 10 * (vectorMagnitude velocity _missile / 150),5];// artillery [-20, -50, 20]; // missiles [-10, -25, 10]
		_cam camCommit 0;
		systemChat str (vectorMagnitude velocity _missile);
		sleep 3.5;
		if (vectorMagnitude velocity (_this select 6) > 333) exitWith {
			systemChat "The camera is not suited for projectiles faster than 333 m/s";
			_cam cameraEffect ["Terminate", "Back"];
			camDestroy _cam;
		};
		while {true} do {
			if (isNull _missile) exitWith {};
			// inflight
			_cam camSetTarget _missile;
			_cam camSetRelPos [-100 * (vectorMagnitude velocity _missile / 330),300 * (vectorMagnitude velocity _missile / 330),0];// artillery [-20, -50, 20]; // missiles [-10, -25, 10]
			_cam camCommit 0;
			sleep (900 / ((vectorMagnitude velocity _missile) + 1));
		};
		sleep 7;
		_cam cameraEffect ["Terminate", "Back"];
		camDestroy _cam;
		};
}];


// provide basic info about MPKilled events
// if remote controlling a unit, the controller will be the instigator
// will not work for explosives
//HEADSUP this function uses allDead. As soon es corpses are deleted, the data will be incorrect.
//HEADSUP Scores are wiped, as soon as the function is called.
AK_var_killdistances = [];
AK_hitcounter = 0;
AK_StatsIteration = 1;
{
    if (_x getVariable ["AK_var_StatsActive", 0] != AK_StatsIteration) then {
        _x setVariable ["AK_var_StatsActive", AK_StatsIteration];
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer", "_instigator", "_useEffects"];
            private _ammoType = currentMagazine _killer;
            private _actualKiller = _instigator;
            if (_killer isKindOf "CAManBase") then {_actualKiller = _killer};
            private _tatWaffe = currentMuzzle _actualKiller;
            if (_actualKiller isKindOf "UAV") then {_tatWaffe = currentMuzzle _killer}; // HEADSUP will not work for all UAVs (UGV, Falcon)
            private _distance = _unit distance _actualKiller;
            if (_distance < 1) exitWith {}; // killed by vehicle explosion 
            diag_log format ["%1, %2", diag_tickTime, _this];
            //systemChat format ["%1, %2, %3", _unit, _killer, _instigator];
            systemChat format ["%1 killed %2 at %3 m using %4 with %5", _actualKiller, _unit, _distance, _tatWaffe, _ammoType]; // distances and the weapon are just approximations (a soldier might fire an ATGM and switch back to his rifle before it hits the target)
            AK_var_killdistances pushBack _distance;
        }];
        /* DISABLED
        _x addMPEventHandler ["MPHit", { 
            params ["_unit", "_causedBy", "_damage", "_instigator"]; // soldier: _instigator will be "zeus" if a unit is remote controlled
            systemChat format ["%2 or %4 hit %1 using %5 with %6 causing %3 damage.", _unit, _causedBy, _damage, _instigator, currentMuzzle _causedBy, currentMagazine _causedBy];
            AK_hitcounter = AK_hitcounter + 1;
            hintSilent format ["%1 hits, %2 kills, %3 average hits/kill", AK_hitcounter, count allDead,  AK_hitcounter / count allDead];
        }];
        */
    };
} forEach allUnits;



