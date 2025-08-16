AK_fnc_createPermanentCrater = {
	/* 
		Description:
			Creates a permanent crater at a specified location by deforming the terrain using `setTerrainHeight`.
			Optionally spawns a shell explosion and visual crater decals.
			Can also hide terrain objects and remove clutter (grass).

		Parameters:
			0: ARRAY - Position to strike in format [x, y, z].
			1: NUMBER - Depth of the crater (default: 2).
			2: NUMBER - Radius of the crater (default: 15).
			3: BOOL - If true, spawns an artillery shell effect (default: true).
			4: BOOL - If true, creates visual crater decals and hides nearby objects (default: true).

		Prerequesites
			Global Mobilization
			TerrainLib
		Example:
			[screenToWorld [0.5, 0.5], -20, 40, true, true] remoteExec ["AK_fnc_createPermanentCrater", 2];

		Enhancements to consider:
			- Add support for multiple crater decal types.
			- Gracefully handle missing assets (e.g., decals from Global Mobilization DLC).

		Known Issues:
			- Large craters may not be walkable.
			- Grass may remain inside the crater (clutter removal is inconsistent with scaling).
			- Overlapping crater decals may cause visual flickering.
			- Water-filled craters lack surface wave effects.
	*/ 
	 
	params [ 
		["_targetPos", [0,0,0], [[]]], 
		["_craterdepth", 2, [0]], 
		["_radius", 15, [0]],
		["_createShell", true, [true]],
		["_createCraterVisuals", true, [true]] 
	];
	_targetPos = [_targetPos] call TerrainLib_fnc_nearestTerrainPoint;
	 // Create explosion effect
	if (_createShell == true) then { 
		private _shellType = "Sh_155mm_AMOS"; //"RHS_9M79_1_F"; //"Bo_Mk82"; //"gm_rocket_luna_he_3r9_warhead"; //"Sh_155mm_AMOS"; 
		private _shell = createVehicle [_shellType, _targetPos, [], 0, "CAN_COLLIDE"]; 
		_shell setVelocity [0,0,-100]; 
		_shell setVectorDirAndUp [[0, 0, -1], [1, 0, 0]];
	};
	  
	if (_createCraterVisuals == true) then {
		// hide objects in radius
		_objects = nearestTerrainObjects [ASLToAGL _targetPos, [], _radius, false];
		{ hideObjectGlobal _x } forEach _objects;
			  
		createSimpleObject ["land_gm_nuke_crater_decal_01", _targetPos, false];	  
		
		// create permanent crater
		
		private _globalSimpleObject = createSimpleObject ["Crater", _targetPos, false];
		if (_radius > 4) then {
			_globalSimpleObject setObjectScale (_radius / 4);
		};
		
		//remove grass
		private _globalSimpleObject2 = createSimpleObject ["Land_ClutterCutter_large_F", ASLToAGL _targetPos, false]; 
		_globalSimpleObject2 setObjectScale (_radius / 10);
		
	};	
	// Deform terrain (crater) 
	[[_targetPos, _radius], _craterdepth, true, 1, 0, 2] call TerrainLib_fnc_addTerrainHeight;
		 
};
