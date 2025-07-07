AK_fnc_createArtilleryShellWithCrater = {
    /* 
        Description: 
            Spawns an artillery shell at a given position and deforms terrain using setTerrainHeight. 
            Optionally damages nearby units. 
     
        Parameters: 
            0: ARRAY - Position to strike [x, y, z] 
            1: NUMBER - Depth of the crater (default: 2) 
            2: NUMBER - Radius of crater(default: 10) 
     
        Example: 
            [screenToWorld [0.5, 0.5], -20, 2 * 20] remoteExec ["AK_fnc_createArtilleryShellWithCrater", 2];
        
        Bugs:
            Big craters are not walkable.
            Grass is still inside the craters. 
    */ 
     
    params [ 
        ["_targetPos", [0,0,0], [[]]], 
        ["_craterdepth", 2, [0]], 
        ["_radius", 15, [0]] 
    ];
    _targetPos = [_targetPos] call TerrainLib_fnc_nearestTerrainPoint;
     // Create explosion effect 
    private _shellType = "RHS_9M79_1_F"; //"Bo_Mk82"; //"gm_rocket_luna_he_3r9_warhead"; //"Sh_155mm_AMOS"; 
    private _explosion = createVehicle [_shellType, _targetPos, [], 0, "CAN_COLLIDE"]; 
    _explosion setVelocity [0,0,-100]; 
    _explosion setVectorDirAndUp [[0, 0, -1], [1, 0, 0]];
    
      
    // hide objects in radius
    _objects = nearestTerrainObjects [ASLToAGL _targetPos, [], _radius, false];
    { hideObjectGlobal _x } forEach _objects;
          
    // create permanent crater
    private _globalSimpleObject = createSimpleObject ["Crater", _targetPos, false]; 
    _globalSimpleObject setObjectScale (_radius / 5);
    
    //remove grass
    private _globalSimpleObject2 = createSimpleObject ["Land_ClutterCutter_large_F", ASLToAGL _targetPos, false]; 
    _globalSimpleObject2 setObjectScale (_radius / 10);
    
    // Deform terrain (crater) 
    [[_targetPos, _radius], _craterdepth, true, 1, 0, 2] call TerrainLib_fnc_addTerrainHeight;
    
     
};
