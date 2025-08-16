AK_fnc_Benchmark = {
	/* 
	 Author: AK 
	 Name: AK_fnc_Benchmark 
	 Date: [20250806] 
	 Required: CBA_A3
	 
	 Description: 
	  Benchmarks game performance by simulating a battle between two unit types and logs FPS over time. 
	 
	 Parameters: 
	  0: NUMBER - View distance / visibility (in meters) 
	  1: STRING - Vehicle class name for side A 
	  2: STRING - Vehicle class name for side B 
	  3: NUMBER - Unit strength for side A (AI count or group strength) 
	  4: NUMBER - Unit strength for side B 
	  5: NUMBER - Log interval in seconds (e.g., 1 = every second) 
	  6: NUMBER - Total battle duration in seconds 
	 
	 Returns: 
	  Nothing. Logs FPS to RPT and displays a hint on completion. 
	 
	 Example: 
	  [7000, "O_MBT_02_cannon_F", "B_MBT_01_cannon_F",  44 ,44, 1, 180] spawn AK_fnc_Benchmark; 
		  
	 Notes: 
	  - Results are output via diag_log therefore there is a limit of fps entries that will be written to the rpt file.
	  - Make sure to execute on all machines
	  - Example vehicle pairings: "gm_ge_army_Leopard1a1a1", "gm_gc_army_t55a", "O_MBT_02_cannon_F", "B_MBT_01_cannon_F", "SPE_PzKpfwV_G","SPE_M4A3_76", "CUP_B_Challenger2_NATO", "CUP_O_T90_RU", "B_AMF_TANK_01", "B_AMF_AMX10_RCR_01_F", "vn_o_armor_t54b_01", "vn_b_armor_m48_01_02", "CSA38_ltm38_LATE2", "CSA38_lt35", "US85_M1A1", "CSLA_T72M1","rhs_t14_tv", "rhsusf_m1a2sep2wd_usarmy"
	  - vehicles must be of beligerent sides, otherwise they will not fight.
	*/ 

	// parameters
	params ["_visibility", "_vehicleTypeA", "_vehicleTypeB", "_strengthA", "_strengthB", "_logIntervall", "_battleDuration"];
	// set the Map Data
	_BenchmarkMapData = createHashMapFromArray [
		["Altis", createHashMapFromArray [
			["curatorCamPos", [27252,21103.1,39.6024]],
			["curatorCamDirAndUp", [[-0.970741,0.10446,-0.216445],[-0.215233,0.0231611,0.976276]]],
			["sideAPos", [25800,20800,0]],
			["sideBPos", [26595,21200,0]],
			["gefechtsStreifenBreite", 800]
			]
		],
		["gm_weferlingen_summer", createHashMapFromArray [
			["curatorCamPos", [19763.5,19449.8,29.956]],
			["curatorCamDirAndUp", [[-0.801397,-0.56934,-0.183415],[-0.149526,-0.106229,0.983031]]],
			["sideAPos", [18000,19100,0]],
			["sideBPos", [19400,18900,0]],
			["gefechtsStreifenBreite", 1000]
			]	
		]	
	];

	// load mapData
	_currentMapData = _BenchmarkMapData get worldName;
	
	//set weather and time
	0 setOvercast 0;
	forceWeatherChange;
	0 setFog 0;
	forceWeatherChange;
	setDate [2025, 6, 21, 12, 0];
	
	// set camera
	if (hasInterface == true) then {
		curatorCamera setPos (_currentMapData get "curatorCamPos");
		curatorCamera setVectorDirAndUp (_currentMapData get "curatorCamDirAndUp");
	};		
	sleep 1;

	// Set visibility
	setViewDistance _visibility;
	setObjectViewDistance _visibility;
	setTerrainGrid (5000^2 / (5000/_visibility * _visibility^2));
	
	sleep 10;
	
	//record FPS
	[
		{
			_this select 0 params ["_endTime", "_fpsArray", "_start_frameno", "_startTime"];
			_this select 1 params ["_handle"];
			if (diag_tickTime < _endTime) then {
				_fpsArray pushBack (round diag_fps);
			} else {
				diag_log format ["AK_fnc_Benchmark result: %1", _fpsArray];
				[format ["AK_fnc_Benchmark terminated. Average FPS: %1. Average FPS 2: %2", _fpsArray call BIS_fnc_arithmeticMean, ((diag_frameno - _start_frameno) / (diag_tickTime - _startTime))]] remoteExec ["hint", 0];
				[_handle] call CBA_fnc_removePerFrameHandler;
			};
		},
		_logIntervall,
		[diag_tickTime + _battleDuration, [], diag_frameno, diag_tickTime]
	] call CBA_fnc_addPerFrameHandler;
	
	// spawn units on server
	if (isServer == true) then {
		// Spawn initial units
		_group0 = createGroup [west, true];
		_group1 = createGroup [east, true];
		
		_object0 = createVehicle [_vehicleTypeA, _currentMapData get "sideAPos", [], 0, "CAN_COLLIDE"];
		[_object0, _group0] call BIS_fnc_spawnCrew;
		// spawn the attackers "marker" for AK_fnc_quickBattle
		_object1 = createVehicle [_vehicleTypeA, (_currentMapData get "sideAPos") vectorAdd [50, 0,0], [], 0, "CAN_COLLIDE"];
		
		_object2 = createVehicle [_vehicleTypeB, _currentMapData get "sideBPos", [], 0, "CAN_COLLIDE"];	[_object2, _group1] call BIS_fnc_spawnCrew;
	
		// Start Battle
		[[[_object0, _object2, _object1], [_group0, _group1]], false, _strengthA, _strengthB, _currentMapData get "gefechtsStreifenBreite", _currentMapData get "gefechtsStreifenBreite"] spawn AK_fnc_quickBattle;	
	};	
		
	diag_log text toJSON (["Function", "_visibility", "_vehicleTypeA", "_vehicleTypeB", "_strengthA", "_strengthB"] createHashMapFromArray ["AK_fnc_Benchmark", _visibility, _vehicleTypeA, _vehicleTypeB, _strengthA, _strengthB]);
};
