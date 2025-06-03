/* ----------------------------------------------------------------------------  
 Function: AK_fnc_createRandomSoldier  
   
 Description:  
     Creates a group of random armed soldiers  
    
 Parameters:  
     _position  
   
 Returns:  
     ? 
   
 Example:  
     (begin example)  
     [getPos player] call AK_fnc_createRandomSoldier; 
     (end)  
  
 BUGS: 
     will spawn chicken and ACE Observers resulting in less than _groupSize combatants
  
 Author:  
     AK     
---------------------------------------------------------------------------- */ 
AK_fnc_createRandomSoldier = {
    private _groupSize = 8;
    private _groupSide = west;
    private _position = _this select 0;
    
    // Get all soldier configs from config.bin
    private _soldierConfigs = configFile >> "CfgVehicles";
    systemChat str _soldierConfigs;
    
    // Check if config exists
    if (!isClass _soldierConfigs) exitWith {
        diag_log "Error: SoldierWB config not found!";
        objNull;
    };
    
    // Get random soldier class
    private _soldierClasses = [];
    {
        if (
        ("Man" in ([_x, true] call BIS_fnc_returnParents)) &&
        ((getText (_x >> "role")) != "Unarmed")
        ) then {
            _soldierClasses pushBack configName _x;
        };
    } forEach configProperties [_soldierConfigs, "isClass _x"];
    
    // Check if we found any soldiers
    if (_soldierClasses isEqualTo []) exitWith {
        systemChat str count _soldierClasses;
        diag_log "Error: No playable soldiers found in config!";
        objNull;
    };
    systemChat str count _soldierClasses;    
    // Select random soldier class
    _spawnClasses = [];
    _roles = [];
    for "_i" from 1 to _groupSize do {
        _classToSpawn = selectRandom _soldierClasses;
        _spawnClasses pushBack _classToSpawn;
        _roles pushBack (getText (configFile >> "CfgVehicles" >> _classToSpawn >> "role"));
    };
    
    //debug
    //diag_log (_spawnClasses createHashMapFromArray _roles);
    
    _group = [_position, _groupSide, _spawnClasses] call BIS_fnc_spawnGroup;
    _group deleteGroupWhenEmpty true;
    {
        private _soldier = _x;
        // Check if soldier already has a primary weapon
        if (primaryWeapon _soldier == "") then {
            // Define the weapon and magazine classnames
            private _weapon = "hgun_PDW2000_F";
            private _magazine = "30Rnd_9x21_Mag";
        
            // Add weapon and magazines
            _soldier addWeapon _weapon;
            for "_i" from 1 to 5 do {
                _soldier addItemToUniform _magazine;
            };
        };
    } forEach (units _group);
};
