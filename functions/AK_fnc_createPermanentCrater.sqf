AK_fnc_createPermanentCrater = {
    /* 
        Description: 
            Spawns an artillery shell at a given position and deforms terrain using setTerrainHeight. 
            Optionally damages nearby units. 
     
        Parameters: 
            0: ARRAY - Position to strike [x, y, z] 
            1: NUMBER - Depth of the crater (default: 2) 
            2: NUMBER - Radius of crater(default: 10)
            3: BOOL - should a generic shell be created  
     
        Example: 
            [screenToWorld [0.5, 0.5], -20, 2 * 20, true, true] remoteExec ["AK_fnc_createPermanentCrater", 2];
        
        Enhance:
            Create different crater decals
            handle decals not present (eg GM)
        Bugs:
            Big craters are not walkable.
            Grass is still inside the craters. (The size of the grass cutter after scaling seems to be inconsistant)
            crater decals overlapping will cause flickering
            watersurfaces filling deep craters have no waves
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
        /* DISABLED
        // create permanent crater
        
        private _globalSimpleObject = createSimpleObject ["Crater", _targetPos, false];
        if (_radius > 4) then {
            _globalSimpleObject setObjectScale (_radius / 4);
        };
        
        //remove grass
        private _globalSimpleObject2 = createSimpleObject ["Land_ClutterCutter_large_F", ASLToAGL _targetPos, false]; 
        _globalSimpleObject2 setObjectScale (_radius / 10);
        */
    };    
    // Deform terrain (crater) 
    [[_targetPos, _radius], _craterdepth, true, 1, 0, 2] call TerrainLib_fnc_addTerrainHeight;
    
     
};
