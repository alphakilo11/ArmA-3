//To generate a list of all available items, you can use the `CfgWeapons`, `CfgMagazines`, `CfgVehicles`, and `CfgGlasses` classes. You can iterate over these classes and add the items to the respective lists. Here is an example:


_allWeapons = [];
_allMagazines = [];
_allUniforms = [];
_allHeadgears = [];
_allVests = [];
_allBackpacks = [];
_allGlasses = [];

{
    _weapon = configName _x;
    if (_weapon isKindOf "Rifle" || _weapon isKindOf "Pistol" || _weapon isKindOf "Launcher") then {
        _allWeapons pushBack _weapon;
    };
} forEach ("true" configClasses (configFile >> "CfgWeapons"));

{
    _magazine = configName _x;
    _allMagazines pushBack _magazine;
} forEach ("true" configClasses (configFile >> "CfgMagazines"));

{
    _uniform = configName _x;
    if (_uniform isKindOf "Uniform_Base") then {
        _allUniforms pushBack _uniform;
    };
} forEach ("true" configClasses (configFile >> "CfgWeapons"));

{
    _headgear = configName _x;
    if (_headgear isKindOf "Headgear_Base") then {
        _allHeadgears pushBack _headgear;
    };
} forEach ("true" configClasses (configFile >> "CfgWeapons"));

{
    _vest = configName _x;
    if (_vest isKindOf "Vest_Base") then {
        _allVests pushBack _vest;
    };
} forEach ("true" configClasses (configFile >> "CfgWeapons"));

{
    _backpack = configName _x;
    if (_backpack isKindOf "Backpack_Base") then {
        _allBackpacks pushBack _backpack;
    };
} forEach ("true" configClasses (configFile >> "CfgVehicles"));

{
    _glass = configName _x;
    _allGlasses pushBack _glass;
} forEach ("true" configClasses (configFile >> "CfgGlasses"));


//Then, you can select a random weapon from the `_allWeapons` list and add it to the soldier. After that, you can filter the `_allMagazines` list to select only the magazines that fit the selected weapon. You can use the `getArray` function with the `"cfgWeapons" >> _weapon >> "magazines"` path to get a list of all magazines that fit the weapon. Then, you can use the `arrayIntersect` function to get the intersection of this list and the `_allMagazines` list. This will give you a list of all available magazines that fit the selected weapon. Here is an example:

_unit = _this select 0;
_rndUnitType = ["I_Soldier_02_F","I_soldier_F","I_Soldier_lite_F","I_Soldier_lite_F","I_Soldier_A_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_SL_F","I_Soldier_TL_F","I_Soldier_M_F","I_Soldier_LAT_F","I_Soldier_AT_F","I_Soldier_AA_F","I_medic_F","I_Soldier_repair_F","I_Soldier_exp_F","I_engineer_F","I_Spotter_F","I_Sniper_F"] call BIS_fnc_selectRandom;
_unit = group player createUnit [_rndUnitType, Position player, [], 0, "FORM"];

_RandomWeapon = _allWeapons call BIS_fnc_selectRandom;
_unit addWeapon _RandomWeapon;

_weaponCompatibleMagazines = getArray (configFile >> "CfgWeapons" >> _RandomWeapon >> "magazines");
_RandomMagazine = (_allMagazines arrayIntersect _weaponCompatibleMagazines) call BIS_fnc_selectRandom;
_unit addMagazine _RandomMagazine;


//Please note that this code assumes that the `BIS_fnc_selectRandom` function will return an empty string if the input array is empty. If this is not the case, you might want to add a check to make sure that the `_weaponCompatibleMagazines` array is not empty before calling the `BIS_fnc_selectRandom` function.
