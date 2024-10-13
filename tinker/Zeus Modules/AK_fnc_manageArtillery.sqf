/*
 * Function: AK_fnc_manageArtillery
 * Description: Manages an artillery battery, creating vehicles and firing rounds at a specified target position.
 * Parameters:
 *   0: ARRAY - Gun List (default: [])
 *   1: STRING - Gun Type (default: "B_MBT_01_arty_F")
 *   2: NUMBER - Number of Guns (default: 6)
 *   3: ARRAY - Position Area Center [x, y, z] (default: [0, 0, 0])
 *   4: NUMBER - Position Area Radius (default: 1693)
 *   5: SIDE - Side of the artillery units (default: west)
 *   6: ARRAY - Target Position [x, y, z] (default: [5000, 5000, 0])
 *   7: NUMBER - Rounds Each Gun Will Fire (default: 8)
 * Returns: ARRAY - Updated Gun List
 * Author: Your Name
 * Example:
 *   [[], "rhs_2s3_tv", 6, [9000, 11000, 0], 1693, east, [5700, 10200, 0], 8] call AK_fnc_manageArtillery;
 */
 AK_fnc_manageArtillery = {
    params [
        ["_gunList", [], [[]]],
        ["_gunType", "B_MBT_01_arty_F", [""]],    
        ["_gunNumber", 6, [0]],
        ["_positionAreaCenter", [0, 0, 0], [[]]],
        ["_positionAreaRadius", 1693, [0]],
        ["_side", west, [sideUnknown]],
        ["_targetPos", [5000, 5000, 0], [[]]],
        ["_roundsEach", 8, [0]]
    ];

    // Check if the battery exists and has at least one valid vehicle
    if (count (_gunList select {!isNull _x}) < 1) then {
        for "_i" from 1 to _gunNumber do {
            private _vehicle = createVehicle [_gunType, _positionAreaCenter, [], _positionAreaRadius];
            _gunList pushBack _vehicle;
            private _group = _side createVehicleCrew _vehicle;
            _group deleteGroupWhenEmpty true;
        };
    } else {
        // Command each vehicle in the battery to fire
        private _magazineType = "";
        {
            _magazineType = (magazines _x) select 0;
            _x doArtilleryFire [_targetPos, _magazineType, _roundsEach];
            _x setAmmo [currentWeapon _x, 999];
        } forEach _gunList;

        // DEBUG: Display hint with firing information
        [format ["%1 units firing %2 rounds each. ETA: %3 s", count _gunList, _roundsEach, (_gunList select 0) getArtilleryETA [_targetPos, _magazineType]]] remoteExec ["hint", 0];
    };
    _gunList
};
