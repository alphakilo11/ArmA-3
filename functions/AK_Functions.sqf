AK_fnc_attack = {    
//ENHANCE reorder params and add defaults
//ENHANCE Anmarsch zur Sturmausgangsline 
//ENHANCE Verteidiger mit Stellungen versehen _mainDirection = 90;_trench = [[300,0,0], _mainDirection, "Land_WW2_TrenchTank", west] call BIS_fnc_spawnVehicle select 0;;_group = [(_trench getRelPos [2, 180]), _mainDirection, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle select 2;_group deleteGroupWhenEmpty true; 

    params ["_spawnPosAnchor", "_mainDirectionVector", "_mainDirection", "_typleListAttackers", "_side", "_angreiferAnzahl", "_angriffsDistanz", "_fahrzeugAbstand", "_gefechtsstreifenBreite", "_linieSturmAngriff", "_angriffsZiel", "_moveOut"];
    _positions = ([_spawnPosAnchor, _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
//            _sturmAusgangsstellungPositions = ([_spawnPosAnchor vectorAdd ((_mainDirectionVector) vectorMultiply _linieSturmAngriff), _angreiferAnzahl, _fahrzeugAbstand,_mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
    _angriffszielPositions = [];
    if (_moveOut) then {
        _angriffszielPositions = ([_spawnPosAnchor vectorAdd ((_mainDirectionVector) vectorMultiply _angriffsDistanz), _angreiferAnzahl, _fahrzeugAbstand,_mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
    };
    _spawnedGroups = [];
    
    for "_i" from 0 to (count _positions) do {
        _group = [_positions select _i, _mainDirection, _typleListAttackers select _i, _side, false] call BIS_fnc_spawnVehicle select 2;
        _group deleteGroupWhenEmpty true;
        _spawnedGroups pushBack _group;
        
        if (_moveOut) then {
            _destination = _angriffszielPositions select _i;
            _lastWaypoint = [_group, 100, _destination] call AK_fnc_spacedMovement;
            _group setVariable ["AK_attack_data", [_group, _angriffsZiel, _gefechtsstreifenBreite]];
            _lastWaypoint setWaypointStatements ["true", "
                _attackData = (group this) getVariable 'AK_attack_data';
                _group = _attackData select 0;
                _angriffsZiel = _attackData select 1;
                _gefechtsstreifenBreite = _attackData select 2;
                [_group, _angriffsZiel, _gefechtsstreifenBreite] call CBA_fnc_taskPatrol;"
            ];
        };
        };
    _spawnedGroups
};
/* ---------------------------------------------------------------------------- 
Function: AK_fnc_battlelogger_standalone 
 
Description: 
    End and restart an automated battle and log events for later analysis. 
  
Parameters: 
    0: _location	- Starting Location <ARRAY>
 
Returns: 
    ?
 
Example: 
    (begin example) 
    [[0,0,0]] call AK_fnc_battlelogger_standalone
    (end) 

Caveats:
    needs AK_var_fnc_automatedBattleEngine_unitTypes
    the code works via Advanced Developer Tools console, but not via ZEN (Execute code) (likely reason: comments)
    does NOT work in singleplayer (see HEADSUP)

Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
AK_fnc_battlelogger_standalone = {
    _location = _this select 0;
    [
        {}, // code
        
        10, //delay in s 
        
        [_location], //parameters 
        
        // start 
        {
            _AK_var_fnc_battlelogger_Version = 1.10;
            _AK_var_fnc_battlelogger_numberOfStartingVehicles = 10;
            _AK_var_fnc_battlelogger_engagementDistance = [1000, 0, 0];
            _AK_var_fnc_battlelogger_vehSpacing = 25;
            _AK_var_fnc_battlelogger_breiteGefStr = 500;
            _AK_var_fnc_battlelogger_platoonSize = 1;
            _AK_var_fnc_battlelogger_timeout = 140; // seconds
            _AK_var_fnc_battlelogger_noFuel = true;
            _startFrameNo = diag_frameNo;
            _location = (_this getVariable "params") select 0;
            //avoid impaired visibility
            0 setFog 0;
            0 setRain 0;
            [[2035, 06, 21, 12, 00]] call BIS_fnc_setDate;
            //set variables ENHANCE find another way
            _AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            _AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
            _AK_var_fnc_battlelogger_startTime = systemTime;
            _AK_var_fnc_battlelogger_start_time_float = serverTime; // only for the timeout, new variable iot not break ABE_auswertung.py
            _PosSide1 = [_location, (_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance)];
            _PosSide2 = [(_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance), _location];

            diag_log format ["AKBL %1 Battlelogger starting! %2 vs. %3", _AK_var_fnc_battlelogger_Version, _AK_var_fnc_battlelogger_typeEAST, _AK_var_fnc_battlelogger_typeINDEP];
            //alternate locations
            if (random 1 >= 0.5) then { 
            _templocation = _PosSide1;
            _PosSide1 = _PosSide2; 
            _PosSide2 = _templocation; 
            };

            _spawnedgroups1 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            _spawnedgroups2 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles; 
            _AK_battlingUnits = [];
            { 
            _AK_battlingUnits pushBack ((_spawnedgroups1 select _x) + (_spawnedgroups2 select _x));} forEach [0,1,2];

            {_x allowCrewInImmobile true} forEach (_AK_battlingUnits select 0);

            if (_AK_var_fnc_battlelogger_noFuel == true) then {
                { // set fuel
                    _x setFuel 0;
                } forEach (_AK_battlingUnits select 0);
            } else {
                { // let the vehicles move back and forth
                _wp = _x addWaypoint [[0,0,0], 0]; 
                _wp setWaypointType "CYCLE";} forEach (_AK_battlingUnits select 2);
            };

        }, 
        
        //end 
        { 
            _east_veh_survivors = ({side _x == east} count (_AK_battlingUnits select 0));
            _indep_veh_survivors = ({side _x == independent} count (_AK_battlingUnits select 0));
            _duration = serverTime - _AK_var_fnc_battlelogger_start_time_float;
            _avgFps = (diag_frameNo - _startFrameNo) / _duration;
            _summary = [
                "AKBL Result: ", // Do not remove 'AKBL Result: ' - see readme.txt for details
                _AK_var_fnc_battlelogger_Version,
                _AK_var_fnc_battlelogger_typeEAST,
                _east_veh_survivors,
                _AK_var_fnc_battlelogger_typeINDEP,
                _indep_veh_survivors,
                _AK_var_fnc_battlelogger_numberOfStartingVehicles,
                worldName,
                _location,
                _AK_var_fnc_battlelogger_engagementDistance,
                _AK_var_fnc_battlelogger_vehSpacing,
                _AK_var_fnc_battlelogger_breiteGefStr,
                _AK_var_fnc_battlelogger_platoonSize,
                _AK_var_fnc_battlelogger_startTime,
                systemTime,
                sunOrMoon,
                moonIntensity,
                _AK_var_fnc_battlelogger_noFuel,
                _avgFps
            ];
            diag_log _summary;
            
            //cleanup
            {deleteVehicle _x} forEach (_AK_battlingUnits select 0); 
            {deleteVehicle _x} forEach (_AK_battlingUnits select 1); 
            {deleteGroup _x} forEach (_AK_battlingUnits select 2); 
            _AK_battlingUnits = nil;

            [_location, 5] spawn AK_fnc_delay;
        }, 
        
        {true}, //Run condition 
        
        //exit Condition 
        {
            ((({alive _x} count (_AK_battlingUnits select 1)) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles) or 
            (serverTime >= (_AK_var_fnc_battlelogger_timeout + _AK_var_fnc_battlelogger_start_time_float)) or
            ((({side _x == east} count (_AK_battlingUnits select 0)) + ({side _x == independent} count (_AK_battlingUnits select 0))) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles))
        }, 
        
        [
            "_AK_var_fnc_battlelogger_Version",
            "_AK_var_fnc_battlelogger_numberOfStartingVehicles",
            "_AK_var_fnc_battlelogger_engagementDistance",
            "_AK_var_fnc_battlelogger_vehSpacing",
            "_AK_var_fnc_battlelogger_breiteGefStr",
            "_AK_var_fnc_battlelogger_platoonSize",
            "_AK_var_fnc_battlelogger_timeout",
            "_AK_var_fnc_battlelogger_noFuel",
            "_AK_var_fnc_battlelogger_typeEAST",
            "_AK_var_fnc_battlelogger_typeINDEP",
            "_AK_var_fnc_battlelogger_startTime",
            "_AK_var_fnc_battlelogger_start_time_float",
            "_startFrameNo",
            "_AK_battlingUnits",
            "_location"
        ] //List of local variables that are serialized between executions.  (optional) <CODE>
    ] call CBA_fnc_createPerFrameHandlerObject; 
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_battlezone

Description:
    Creates a battle between east and west. The player can fight alongside one of the parties or choose independent and fight both.
	Execute on the server and use some kind of Garbage Collector otherwise the dead units will quickly kill performance.
	
Parameters:
    0: _AZ		- Objective <ARRAY> (default: [500,500,0])
    1: _pltstrength	- Minimum Number of Units per platoon (max. depends on group strength) <NUMBER> (default: 40)
	2: _maxveh		- Maximum number of vehicles per group. <NUMBER> (default: 0)
    3: _spawndelay  - Time in seconds between spawn attemtps. <NUMBER> (default: 300)

Returns:
	nil

Example:
    (begin example)
		[[21380, 16390, 0], 40, 1, 300] call AK_fnc_battlezone;
    (end)

Requires:
	AK_fnc_moveRandomPlatoons
	AK_fnc_storeFPS

Author:
    AK

---------------------------------------------------------------------------- */
//ENHANCE choose factions
//ENHANCE let allies spawn on the same side of the battlefield
//ENHANCE dynamically adapt to number of clients
//ENHANCE cleanup the select select select mess
//BUG in some cycles one side doesn't spawn 
AK_fnc_battlezone = {
    params [
		["_AZ", [1500,1500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]],
        ["_spawndelay", 300, [0]]
	];

//	[{[] remoteExec ['AK_fnc_storeFPS', -2]}, (_spawndelay / 10)] call CBA_fnc_addPerFrameHandler; //publish the clients FPS

	[{
		(_this select 0) params [ 
		["_AZ", [1500,1500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]]
		];
		diag_log format ['AK_fnc_battlezone: PerFrameHandler-Variables %1', _this];
		//check performance and skip spawning if too low
		[] remoteExec ['AK_fnc_storeFPS', 0]; //update min. FPS
		if (AK_var_MinFPS < 25) exitWith {
			diag_log 'AK_fnc_battlezone: low FPS, skipping spawn.';
			AK_var_MinFPS = 60;
			publicVariable "AK_var_MinFPS";
		}; 
			
		//debug
		diag_log format ['Hello I am the server executing AK_fnc_battlezone and these are my variables: %1 - %2 - %3', _this select 0 select 0, _this select 0 select 1, _this select 0 select 2];

		[0, east, _AZ, _pltstrength, _maxveh] call AK_fnc_moveRandomPlatoons;
		[1, west, _AZ, _pltstrength, _maxveh] call AK_fnc_moveRandomPlatoons; //spawn

    }, _spawndelay, [_AZ, _pltstrength, _maxveh]] call CBA_fnc_addPerFrameHandler;
};/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgFactionTable

Description:
    Creates a table of factions.
	Use to provide input to AK_fnc_cfgGroupTable.
	
Parameters:
    0: _side		- 0 = OPFOR, 1 = BLUFOR, 2 = Independent <NUMBER>
	1: _configName	- false = full config entry, true = configName <BOOLEAN> (default: true)

Returns:
	<ARRAY>

Example:
    (begin example)
		[2] call AK_fnc_cfgFactionTable;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgFactionTable = {
params [
	"_side",
	["_configName", 1]
];
switch (_configName) do {
	case 1: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses") apply {configName _x};};
	case 0: {"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses");};
};
};

/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgGroupTable

Description:
    Creates a table of all groups from a given faction. Some factions have no defined groups.
	
Parameters:
    0: _cfgfaction	- Faction <STRING> (default: "BLU_F")

Returns:
	<ARRAY>

Example:
    (begin example)
		["BLU_F"] call AK_fnc_cfgGroupTable; 
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgGroupTable = {
params [
    ["_cfgfaction","BLU_F", []]
];
private ["_cfgSide", "_newCfgEntry", "_arm", "_groups"];

//get side of _cfgfaction
_cfgSide = getNumber (configFile >> "CfgFactionClasses" >> _cfgfaction >> "side"); 
_newCfgEntry = ("getNumber (_x >> 'side') == _cfgSide" configClasses (configFile >> "CfgGroups") apply {configName _x}) select 0; 
_newCfgEntry = configFile >> "CfgGroups" >> _newCfgEntry;
//iterate through arms and get all groups that have matching sides
_arm = "true" configClasses (_newCfgEntry >> _cfgfaction) apply {configName _x}; 
_groups = []; 
{_groups pushBack ("getNumber (_x >> 'side') == _cfgSide" configClasses (_newCfgEntry >> _cfgfaction >> _x));} forEach _arm; 
flatten _groups; 
};/* ----------------------------------------------------------------------------
Function: AK_fnc_cfgUnitTable

Description:
    Creates a table of units. Use with createUnit.
	
Parameters:
    0: _cfgfaction	- Faction <STRING> (default: "BLU_F")
    1: _cfgkind		- Kind of Vehicle <STRING> (default: "CAManBase")

Returns:
	<ARRAY>

Example:
    (begin example)
		["rhsgref_faction_chdkz", "CAManBase"] call AK_fnc_cfgUnitTable;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */

AK_fnc_cfgUnitTable = {
params [
    ["_cfgfaction", "BLU_F", []],
    ["_cfgkind", "CAManBase", []]
];
private _unittable = "getText (_x >> 'faction') == _cfgfaction and configName _x isKindOf _cfgkind and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles") apply {configName _x};
_unittable
};/* ----------------------------------------------------------------------------
Function: AK_fnc_cleangrouplist

Description:
    Cleans deleted groups from an array of groups. The input array will be altered.
	
Parameters:
    0: _groups	- Array of groups to cleanup <ARRAY>

Returns:
	An array of existing groups.

Example:
    (begin example)
		[list_of_groups] call AK_fnc_delete;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_cleangrouplist = {
params ["_groups"];
_deletedindex = [];
{if (isNull _x) then {_deletedindex pushBack _forEachIndex}} forEach _groups;
_deletedindex sort false;
{_groups deleteAt _x} forEach _deletedindex;
_groups;
};
AK_fnc_dataVaultInitialize = {
/* ----------------------------------------------------------------------------
Function: AK_fnc_dataVaultInitialize

Description:
    Creates an object (Laptop) that serves as namespace for public variables that each client (also the server) creates.
    
Parameters:
    NIL

Example:
    (begin example)
    [] call AK_fnc_dataVaultInitialize;
    (end)

Returns:
    Nil

Author:
    AK
---------------------------------------------------------------------------- */

    AK_object_dataVault = createVehicle ["Land_Laptop_02_unfolded_F", getPosATL player];
    publicVariable "AK_object_dataVault";
    [{AK_object_dataVault setVariable ["dataVaultOfNetID" + str clientOwner, [], true];}] remoteExec ["call", 0, "AK_dataVault"];
    
    //parseNumber ("test4" trim ["test"])
};
 AK_fnc_defend = {  
//creates a number of groups or vehicles in an area around _refPos.  
//Works local and on DS  
//REQUIRED: CBA  
//Params _refPos 3D position  
/*  
Example:  
    (begin example)  
    [[0, 0, 0], 77, resistance, "I_MBT_03_CANNON_F"] spawn AK_fnc_defend;  
    (end)
    (begin example)  
    [[0,0,0], 77, resistance, configFile >> "CfgGroups" >> "West" >> "BLU_CTRG_F" >> "Infantry" >> "CTRG_InfSquad" ] spawn AK_fnc_defend;  
    (end) 
*/  

 if (isNil "AK_fnc_differentiateClass") exitWith {diag_log "AK_fnc_defend ERROR: AK_fnc_differentiateClass required"};  
 
 params ["_refPos", "_numberofgroups", "_side", "_grouptype"];
 _gkgfDichte = 3.14; //vehicles or groups per km²

 private _area = _numberofgroups /_gkgfDichte; 
 private _radius = sqrt(_area / 3.14) * 1000; 
 for "_i" from 1 to _numberofgroups step 1 do {  
  private _vfgrm = [_refPos, 0, _radius] call BIS_fnc_findSafePos;  
  private _gruppe = nil;  
  if ((_grouptype call AK_fnc_differentiateClass) == "Group") then {  
   _gruppe = [_vfgrm, _side, _grouptype] call BIS_fnc_spawnGroup;  
  };  
  if ((_grouptype call AK_fnc_differentiateClass) == "Vehicle") then {  
   _gruppe = ([_vfgrm, 270, _grouptype, _side] call BIS_fnc_spawnVehicle) select 2;  
  };  
  if (isNull _gruppe) exitWith {diag_log "AK_fnc_defend ERROR: no groups spawned"};  
  _gruppe deleteGroupWhenEmpty true;  
//  [_gruppe, _refPos, _radius] call CBA_fnc_taskDefend;  
 };  
};  
/*
The Achilles Execute Code Module doesn't like double-slashes, therefore I have to put all comments in here and the code has to be copy-pasted without this block.

Inspired by the toilet paper shortage in Austria in 2020 this scenario has the players defending a toilet paper factory
This will create a huge building and 2 + _numberofprivates hostiles approaching it.
The hostiles will spawn within a radius of _radius.
_pos is the ground zero of the whole scenario and is defined as the players position.

Klopapier-Lager bewachen
    "Land_Factory_Main_F" größer und cooler weil man raufklettern kann
    "Land_dp_smallFactory_F"
Raum mit Leuten die nix tun (Stab)

Add 1 Group of defenders (for flair) (Police with waypoint dismissed)
Add task
Add triggerable waves
Add Blackout at Missionstart
Add Arsenal/Equipment
Change hostiles
Add random clothes and gear to hostiles


*/
AK_fnc_defendToiletPaperFactory = {
private _pos = getPosATL player;
private _objective = createVehicle ["Land_Factory_Main_F", _pos, [], 100, 'NONE'];
private _markerstr = createMarker ["military1",(getPos _objective)];
_markerstr setMarkerShape "ICON";
_markerstr setMarkerType "n_support";
_markerstr setMarkerText "Klopapierlager";
private _numberofprivates = 10;
private _radius = 2000;
private _typeofunit = ["LOP_BH_Infantry_model_OFI_TRI","LOP_BH_Infantry_model_OFI_M81",'LOP_BH_Infantry_model_OFI_LIZ',"LOP_BH_Infantry_model_OFI_FWDL","LOP_BH_Infantry_model_OFI_ACU","LOP_BH_Infantry_model_M81_TRI","LOP_BH_Infantry_model_M81_LIZ","LOP_BH_Infantry_model_M81_FWDL","LOP_BH_Infantry_model_M81_CHOCO","LOP_BH_Infantry_model_M81_ACU","LOP_BH_Infantry_model_M81","LOP_BH_Infantry_AR","LOP_BH_Infantry_AR_2","LOP_BH_Infantry_AR_Asst","LOP_BH_Infantry_AR_Asst_2","LOP_BH_Infantry_AT","LOP_BH_Infantry_base","LOP_BH_Infantry_Corpsman","LOP_BH_Infantry_Driver","LOP_BH_Infantry_GL","LOP_BH_Infantry_IED","LOP_BH_Infantry_Marksman"];
 private _newGroup = createGroup east;
 _newUnit = _newGroup createUnit ["LOP_BH_Infantry_SL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'SERGEANT';
 _newUnit setFormDir 210.828;
 _newUnit setDir 210.828;
_newUnit = _newGroup createUnit ["LOP_BH_Infantry_TL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'CORPORAL';
 _newUnit setFormDir 180.016;
 _newUnit setDir 180.016;
 private _a =0;
 while {_a = _a + 1; _a < (_numberofprivates + 1)} do {
_newUnit = _newGroup createUnit [(selectRandom _typeofunit), _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'PRIVATE';
 _a + 1;
 };
_newGroup setFormation 'STAG COLUMN';
 _newGroup setCombatMode 'RED';
 _newGroup setBehaviour 'AWARE';
 _newGroup setSpeedMode 'FULL';
_newWaypoint = _newGroup addWaypoint [_pos, 0];
 _newWaypoint setWaypointType "SAD";
 };
/* ---------------------------------------------------------------------------- 
Function: AK_fnc_delay
 
Description: 
    Special tool for ABE to allow a delay between calls of the battlelogger.
Parameters: 
	0: _location	- <ARRAY>
	1: _delayInS	- <NUMBER>
 
Example: 
    (begin example) 
    [[0,0,0], 5] spawn AK_fnc_delay;
    (end) 
 
Returns: 
    NIL
 
Author: 
    AK
---------------------------------------------------------------------------- */
AK_fnc_delay = {
	params ["_location", "_delayInS"];
	if (canSuspend == False) exitWith {
		diag_log "ERROR AK_fnc_delay: Scope is not suspendable";
	};
	_initialFPS = diag_frameNo;
	_initialTime = diag_tickTime;
	sleep _delayInS;
	_longFpsAvg = (diag_frameNo - _initialFPS) / (diag_tickTime - _initialTime);

	while {(_longFpsAvg < 40) or (diag_fpsMin < 40)} do {
		diag_log format ["AK_fnc_delay: Suspending due to low FPS. %1 groups, %2 units, %3 FPS (long average.)", (count allGroups), (count allUnits), _longFpsAvg];
		_initialFPS = diag_frameNo;
		_initialTime = diag_tickTime;		
		sleep 60;
		_longFpsAvg = (diag_frameNo - _initialFPS) / (diag_tickTime - _initialTime);
	};
	[_location] call AK_fnc_battlelogger_standalone;
};
// Function to differentiate config entries between vehicles and groups
// Returns: "Vehicle" if the class is found in CfgVehicles, "Group" if found in CfgGroups, "Unknown" otherwise 
// Example usage 
//_fullPath = configFile >> "CfgGroups" >> "Indep" >> "SPE_US_ARMY" >> "Armored" >> "SPE_M4A1_75_Platoon"; // Example full path 
//_result = [_fullPath] call AK_fnc_differentiateClass; 
// hint format ["%1 is a %2", _fullPath, _result]; 
AK_fnc_differentiateClass = { 
	params ["_candidate"];
	if ((_candidate call BIS_fnc_getCfgIsClass) == true) then {
		if ("CfgGroups" in str _candidate) exitWith { "Group" };
		"Vehicle";
	} else {
		if ((isClass (configFile >> "CfgVehicles" >> _candidate)) == true) exitWith { "Vehicle" };
		"Unkown"	
	};
}; 
 /* ---------------------------------------------------------------------------- 
Function: AK_fnc_dynAdjustVisibility
 
Description: 
    A function used to adjust visibility based on given FPS.
    200 is the lowest value for setViewDistance. 
Parameters: 
    - FPS    <NUMBER>
 
Optional: 
    - Adjust setDynamicSimulationDistance    <BOOL>    (Default: false)   
    - Reference values [critical, low, high]    <ARRAY of NUMBERS>    (Default: [10, 25, 40])
    - Maximum View Distance in m   <NUMBER>    (Default: 7000)  

Example: 
    (begin example) 
    [{[{[diag_fps, true] remoteExec ["AK_fnc_dynAdjustVisibility", 2];}] remoteExec ["call", -2];}, 10] call CBA_fnc_addperFrameHandler;
    (end) 
 
Returns: 
    Adjustment of visibility in m. (0 if unchanged))
 
Author: 
    AK
---------------------------------------------------------------------------- */ 
AK_fnc_dynAdjustVisibility = {
    params [
    ["_fps", 0, [123]],
    ["_dynSim", false, [false]],
    ["_referenceValues", [10, 25, 40], [[]]],
    ["_maxViewDistance", 7000, [123]]
    ];
    
    //execute on server only
    if (isServer == false) exitWith {hint "AK_fnc_dynAdjustVisibility has to run on the server";};

    // check server load    
    _serverFPS = diag_fps;
    if (_serverFPS <= _fps) then {_fps = _serverFPS};

   // calculate values 
    _referenceValues params ["_verylow","_low", "_high"];
    _newViewDistance = viewDistance;
    _increment = floor (_newviewDistance / 10);
    
    if (_fps < _verylow) then {
        _newViewDistance = floor (viewDistance / 2);
    } else {
        if (_fps < _low) then {
            _newViewDistance = viewDistance - _increment;
        } else {
            if ((_fps > _high) and ((viewDistance + _increment) < _maxViewDistance)) then {
                _newViewDistance = viewDistance + _increment;
            };
        };
    };

    _adjustment = _newViewDistance - viewDistance;
    
    // set values
    _newViewDistance remoteExec ["setviewDistance", 0, "Viewdistance"]; 
    _newViewDistance remoteExec ["setObjectViewDistance", 0, "Objectdistance"];
    if (_dynSim == true) then {
        "Group" setDynamicSimulationDistance _newviewDistance;
        "Vehicle" setDynamicSimulationDistance _newviewDistance;
        "EmptyVehicle" setDynamicSimulationDistance _newviewDistance;
    };

    diag_log format ["AK_fnc_dynAdjustVisibility: FPS: %1. Adjusted visibility: %2 m.", _fps, _newViewDistance];
    _adjustment    
};/* ----------------------------------------------------------------------------
Function: AK_fnc_endlessconvoy

Description:
    Create a vehicle moving from A to B. Upon reaching B it is deleted

Parameters:
    - Type of Vehicle (Config Entry)
    - Starting Position (XYZ)
    - End Location (XYZ)

Optional:
- Speed Limit (km/h)

Example:
    (begin example)
    ["B_Truck_01_box_F", [0,0,0], [5000,5000,0]] call AK_fnc_endlessconvoy
    (end)

Advanced Example:
    (begin example)
    [[],{Testversuch = [] spawn {
    for "_x" from 0 to 1 step 0 do {
    ["B_Truck_01_box_F", [0,0,0], [5000,5000,0]] call AK_fnc_endlessconvoy;
    sleep 15;
    };
    };}] remoteExec ["call", 2];

    [[],{terminate Testversuch;}] remoteExec ["call", 2];
    (end)
Returns:
    Nil

Author:
    AK

---------------------------------------------------------------------------- */

//1.initiate function
AK_fnc_endlessconvoy = {
params [
    "_verhicletype", 
    "_startloc", 
    "_endloc", 
    ["_speedlimit", -1]
];
private _vehicle = _verhicletype createVehicle _startloc;
_vehicle setDir (_startloc getDir _endloc);
createVehicleCrew _vehicle;
_vehicle limitSpeed _speedlimit;
private _grp = group _vehicle;
_grp setBehaviour "SAFE";
private _wp = _grp addWaypoint [_endloc, 50];  
_wp setWaypointStatements ["true", "_vehicleleader = vehicle leader this; {deleteVehicle _x} forEach crew _vehicleleader + [_vehicleleader]; deleteGroup (group this);"] ;
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_findString

Description:
    Searches an array of strings for a certain string and returns an array containing all hits.
	
Parameters:
    0: _string	- string to search for <STRING> 
    1: _array	- array to search in <ARRAY>

Returns:
	<ARRAY>

Example:
    (begin example)
		["LIB_", ["LIB_P38","LIB_P08","LIB_M1896","WaltherPPK"]] call AK_fnc_findString;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_findString = {
params ["_string", "_array"];
private _hitArray = [];
{ 
if ([_string, _x] call BIS_fnc_inString) then {
_hitArray pushBack _x;}
} forEach _array;
_hitArray
};/* ---------------------------------------------------------------------------- 
Function: AK_fnc_flare 
 
Description: 
    Pops a small flare 150m overhead the given position. 
  
Parameters: 
    0: _position    - Position of flare <ARRAY>  (Default:[0, 0, 0]))
    1: _color       - Color of flare <STRING> (default: "WHITE")("WHITE", "RED", "GREEN", "YELLOW", "IR")
    2: _height      - Height AGL <NUMBER> (default: 120) 
 
Returns: 
 NIL 
 
Example: 
    (begin example) 
  [player modelToWorld [0, 100, 0], "RED"] call AK_fnc_flare; 
    (end) 
 
Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
AK_fnc_flare = { 
    params [ 
        ["_position", [0, 0, 0]], // Default position is [0, 0, 0] 
        ["_color", "WHITE"], // Default color is "WHITE" 
        ["_height", 120],
        ["_sinkrate", -2]
    ]; 
 
    _shell = createVehicle [("F_40mm_" + _color), (_position vectorAdd [0, 0, _height]), [], 0, "NONE"]; 
    _shell setVelocity [0, 0, _sinkrate]; 
}; 
AK_fnc_gefechtsform = {
    // returns a grid of positions on the surface with battle formations of tank companies in mind

    params [
        ["_anchorPos", [0,0,0], [[]]], 
        ["_number", 14, [0]],
        ["_spacing", 75, [0]], 
        ["_orientationVector", [0,1,0], [[]]], 
        ["_maxWidth", 650, [0]] 
    ];
    if (_number < 1) exitWith {diag_log "WARNING AK_fnc_gefechtsform: less then 1 positions have been requested"};
    private _positions = [];
    private _yOrientationVector = [_orientationVector, 90] call BIS_fnc_rotateVector2D;
    private _xOrientationVector = [_orientationVector, 180] call BIS_fnc_rotateVector2D;
    private _posPerLine = floor (_maxWidth / (_spacing));
    private _lines = floor (_number / _posPerLine);
    for "_line" from 0 to _lines do {
        if ((count _positions) >= _number) exitWith {_positions};
        private _rowPosition = (_anchorPos vectorAdd (_xOrientationVector vectorMultiply (_line * _spacing)));
        //add first position
        _positions pushBack [_rowPosition select 0, _rowPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
        for "_y" from 1 to (ceil (_posPerLine / 2)) do {
            //position to the right
            if ((count _positions) >= _number) exitWith {_positions};
            private _finalPosition = (_rowPosition vectorAdd (_yOrientationVector vectorMultiply (_y * _spacing)));
            _positions pushBack [_finalPosition select 0, _finalPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
            if ((count _positions) >= _number) exitWith {_positions};
            _yOrientationVector = [_yOrientationVector, 180] call BIS_fnc_rotateVector2D; //reverse the vector
            //position to the left
            private _finalPosition = (_rowPosition vectorAdd (_yOrientationVector vectorMultiply (_y * _spacing)));
            _positions pushBack [_finalPosition select 0, _finalPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
                         
        };
    };
_positions
};
/* Identifies 2 Groups which are separated by distance */
AK_fnc_GroupbyDistance = {
	params ["_unsortedObjects"];
	_anchorPos = getPos (_unsortedObjects select 0);
	_distances = [];
	{
		_distances pushBack (_anchorPos distance _x);
	} forEach _unsortedObjects;
	_threshold = (selectMax _distances) / 2;
	_groupA = [];
	_groupB = [];
	for "_i" from 0 to (count _unsortedObjects) - 1 do {
		if ((_distances select _i) > _threshold) then {
			_groupB pushBack (_unsortedObjects select _i);
		} else {
			_groupA pushBack (_unsortedObjects select _i);
		};
	};
	[_groupA, _groupB]
};
AK_fnc_listHCs = {
    _collectedUserInfo = [];
    {_collectedUserInfo pushBack (getUserInfo _x)} forEach allUsers;
    
    _headlessClients = [];
    {
        if (_x select 7 == true) then {
            _headlessClients pushBack (_x select 1);
        };
    } forEach _collectedUserInfo;
    _headlessClients;
};/* ----------------------------------------------------------------------------
Function: AK_fnc_moveRandomPlatoons

Description:
    Spawns random platoons and lets them move toward an objective. When vehicles are spawned a _pltstrength = 40 platoon might end up with up to 20 vehicles.
	
Parameters:
    0: _cfgSide		- 0 = OPFOR, 1 = BLUFOR, 2 = Independent Config's Side <NUMBER> (default: 1)
	1: _side		- Affiliation of the spawned units. <SIDE> (default: west)
	2: _AZ			- Objective <ARRAY> (default: [500,500,0])
	3: _pltstrength	- Minimum Number of Units per platoon (max. depends on group strength) <NUMBER> (default: 40)
	4: _maxveh		- Maximum number of vehicles per group. <NUMBER> (default: 0)

Returns:
	<ARRAY>

Example:
    (begin example)
		[1, west, [21380, 16390, 0], 40, 0] call AK_fnc_moveRandomPlatoons; 
    (end)

Requires:
	AK_fnc_cfgFactionTable
	AK_fnc_cfgGroupTable

Author:
    AK

---------------------------------------------------------------------------- */
//BUG sometimes nothing is spawned, but groups are returned
//BUG server lags when spawning - probably to to reading the configtable every time
//REMARK auffaellig viele Lfz
//ENHANCE add GroupTable to veriable 
AK_fnc_moveRandomPlatoons = {
	params [
		["_cfgSide", 1, [0]],
		["_side", west, [west]], //east, west, resistance
		["_AZ", [500,500,0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]]
	];

	private ["_cfgFaction", "_numberOfUnits", "_timeout", "_spawnedgroups", "_vfgrm", "_facing"];

	if (isNil "AK_var_fnc_moveRandomPlatoons_factiontables") then { 
	//populate faction tables 
	_sides = [0,1,2]; 
	AK_var_fnc_moveRandomPlatoons_factiontables = []; 
	{AK_var_fnc_moveRandomPlatoons_factiontables pushBack ([_x] call AK_fnc_cfgFactionTable)} forEach _sides; 
	//populate group tables 
	AK_var_fnc_moveRandomPlatoons_GroupTables = []; 
	{ 
	AK_var_fnc_moveRandomPlatoons_GroupTables pushBack []; 
	_workingTable = AK_var_fnc_moveRandomPlatoons_GroupTables select _x; 
	{{_workingTable pushBack ([_x] call AK_fnc_cfgGroupTable)} forEach _x} forEach [AK_var_fnc_moveRandomPlatoons_factiontables select _x]; 
	} forEach _sides; 
	};
	//debug
    //diag_log format ['Hello I am the server executing AK_fnc_moveRandomPlatoons and these are my variables: %1', _this];

	_cfgFaction = str text (selectRandom (AK_var_fnc_moveRandomPlatoons_factiontables select _cfgSide));
	_numberOfUnits = 0;
	_timeout = 0;
	_spawnedgroups = [];
	_vfgrm = _AZ vectorAdd [random [-1500, 0, 1500],random [-1500, 0, 1500],0];
	_facing = _vfgrm getDir _AZ;

	while {_numberOfUnits < _pltstrength && _timeout < (_pltstrength +1)} do {
		_cfggroup = selectRandom (AK_var_fnc_moveRandomPlatoons_GroupTables select _cfgSide select ((AK_var_fnc_moveRandomPlatoons_factiontables select _cfgSide) findIf {_x == _cfgFaction}));
		_grp = [_vfgrm, _side, _cfggroup, [], [], [], [], [], _facing, false, _maxveh] call BIS_fnc_spawnGroup;
		_vfgrm = _vfgrm vectorAdd [10, 0, 0];
		_spawnedgroups pushBack _grp;
		_numberOfUnits = _numberOfUnits + count (units _grp);
		_grp deleteGroupWhenEmpty true;
		_grp addWaypoint [_AZ, 100];
		_timeout = _timeout + 1;
	};
	if (_timeout >= (_pltstrength + 1)) then {
		/*_this call AK_fnc_moveRandomPlatoons;*/
		diag_log format ["AK_fnc_moveRandomPlatoons: Hit timeout, %1 units spawned.", _numberOfUnits];
	};
	_spawnedgroups
};/* ----------------------------------------------------------------------------
Function: AK_fnc_populateMap

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    ["_referencePosition", [0,0,0], [[]]],    
    ["_areaSideLength", worldSize, [0]],    
    ["_spacing", true],    
    ["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile, ""]],    
    ["_side", east, [east]],     
    ["_numberOfGroups", 128, [0]],   //this is just used to calculate the spacing
    ["_landOnly", true, [false]],   
    ["_serverOnly", true, [false]]   
Returns:
	[_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter]

Example:
    (begin example)
        [[0, 0, 0], worldSize, true, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", independent, 287] spawn AK_fnc_populateMap;    
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_populateMap = {    

  #define RANDOM_CONFIG_CLASS(var) selectRandom ("true" configClasses (var))    
  
 params [    
  ["_referencePosition", [0,0,0], [[]]],    
  ["_areaSideLength", worldSize, [0]],    
  ["_spacing", true],    
  ["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile, ""]],    
  ["_side", east, [east]],     
  ["_numberOfGroups", 128, [0]],   //this is just used to calculate the spacing
  ["_landOnly", true, [false]],   
  ["_serverOnly", true, [false]]   
 ];    
   
 if (_serverOnly == true and isServer == false) exitWith {   
  hint "AK_fnc_populateMap parameters are set to spawn on server only.";   
 };   
  
 _random = false;  
 if ((typeName _groupType == typeName "") and {_groupType == "random"}) then {  
  _random = true;  
 } else {
     if (typeName _groupType == typeName "") exitWith {
         diag_log format ["AK_fnc_populateMap ERROR: got %1, expected configFile or 'random'.", _groupType];
     };
 };
  
 // auto determine spacing    
 if (_spacing == true) then {    
  _spacing = _areaSideLength / (sqrt _numberOfGroups);    
 };    
    
 enableDynamicSimulationSystem true;    
     
 private _x = 0;    
 private _y = 0;    
 private _groupCounter = 0;     
 while {_y < _areaSideLength} do {    
  while {_x < _areaSideLength} do {    
   if (({side _x == _side} count allGroups) >= 288) exitWith {   
    [_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter];   
   };    
   _spawnPosition = _referencePosition vectorAdd [_x, _y, 0];   
   if ((_landOnly == true) and {surfaceIsWater _spawnPosition == true}) then {   
        _x = _x + _spacing;   
        continue;   
    };  
   if (_random == true) then {  
    _groupType = RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(RANDOM_CONFIG_CLASS(configFile >> "cfgGroups" >> "east")));  
   };             
   _group = [_spawnPosition, _side, _groupType] call BIS_fnc_spawnGroup;    
   _group deleteGroupWhenEmpty true;     
   _group enableDynamicSimulation true;    
   [_group, _spawnPosition, _spacing * 0.66, 3, 0.1, 0.9] call CBA_fnc_taskDefend;    
   _groupCounter = _groupCounter + 1;    
   _x = _x + _spacing;    
  };    
 _x = 0;    
 _y = _y + _spacing;    
 };    
 [_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter]     
};    
AK_fnc_quickBattle = {
    //HEADSUP if you select vehicles on the map you get the groups, if you select them in 3D than you get all units (including each crewmember)
    //ENHANCE how to determine attacker side? currently I use an empty vehicle
    // assumes that all attackers and defenders each share the same side 
    params ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl"]; // pass two arrays of vehicles seperated in space (eg by curatorSelected)
    _angreiferFahrzeugAbstand = 100;
    _angreiferGefechtsstreifenBreite = 650;

    _verteidigerFahrzeugAbstand = 100;
    _verteidigerGefechtsstreifenBreite = 650;
     
    _SelectedEntities = _selection select 0; 
    _SelectedGroups = _selection select 1; 
    _parties = [_SelectedEntities] call AK_fnc_GroupbyDistance; 
    _initialPartyA = (_parties select 0); 
    _initialPartyB = (_parties select 1);
    
    // determine type of battle
    _battleType = "eil_bez_Verteidigung";
    _rawAttackers = false;
    _rawDefenders = false;
    _civInA = civilian in (_initialPartyA apply {side _x});
    _civInB = civilian in (_initialPartyB apply {side _x});
    if (!_civInA and !_civInB) then {_battleType = "Begegnungsgefecht";}
    else {
        if (_civInA) then {_rawAttackers = _initialPartyA; _rawDefenders = _initialPartyB}
        else {_rawAttackers = _initialPartyB; _rawDefenders = _initialPartyA};
        _rawAttackers deleteAt ((_rawAttackers apply {side _x}) find civilian); // remove the attacker "marker"
    };
    if (_battleType == "Begegnungsgefecht") exitWith {diag_log "ERROR AK_fnc_quickBattle: Begegnungsgefecht not yet implemented."};      
    if (_debug) then {diag_log format ['Type of battle determined. %1', [_battleType, _rawAttackers, _rawDefenders]]};
    
    referenceAttacker = _rawAttackers select 0;
    referenceDefender =  _rawDefenders select 0;
    _angreiferSpawnPosAnchor = getPos referenceAttacker; 
    _angriffsZiel = getPos referenceDefender; 
    _typleListAttackers = [_rawAttackers apply {typeOf _x}, _angreiferAnzahl] call AK_fnc_TypeRatio; 
    _typleListDefenders = [_rawDefenders apply {typeOf _x}, _verteidigerAnzahl] call AK_fnc_TypeRatio;
    _angreiferSide = side referenceAttacker;
    _verteidigerSide = side referenceDefender; 
    // delete the placeholders 
    [_SelectedEntities, _SelectedGroups] call CBA_fnc_deleteEntity; // remove the "parameters" intentionally not deleting waypoints and markers
    
    // mark Positions 
    "SmokeShellBlue" createVehicle _angreiferSpawnPosAnchor; 
    "SmokeShellRed" createVehicle _angriffsZiel;
     
    //general parameters derived from "parameter" units
    _angriffsRichtung = _angreiferSpawnPosAnchor getDir _angriffsZiel;
    _wrongVector = [[0, 1, 0], _angriffsRichtung] call BIS_fnc_rotateVector2D;
    _angriffsRichtungVector = [(_wrongVector select 0) * -1, _wrongVector select 1, 0]; 
    _angriffsDistanz = (_angreiferSpawnPosAnchor distance _angriffsZiel) + 1000; // Naechste Aufgabe Kompanie
    _linieSturmAngriff = _angriffsDistanz - 2000; // 500 bis 1500 m
    _verteidigerRichtung = _angriffsZiel getDir _angreiferSpawnPosAnchor;
    _verteidigerRichtungVector = [_angriffsRichtungVector, 180] call BIS_fnc_rotateVector2D;
    
    //spawn attackers
    [
        {isNull referenceAttacker},
        {
            referenceAttacker = nil;
            _this call AK_fnc_attack;
        },
        [_angreiferSpawnPosAnchor, _angriffsRichtungVector, _angriffsRichtung, _typleListAttackers, _angreiferSide, _angreiferAnzahl, _angriffsDistanz, _angreiferFahrzeugAbstand, _angreiferGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, true]
    ] call CBA_fnc_waitUntilAndExecute;     
    
    //spawn defenders
    
    [
        {isNull referenceDefender},
        {
            referenceDefender = nil;
            _this call AK_fnc_attack;  
        },
        [_angriffsZiel, _verteidigerRichtungVector, _verteidigerRichtung, _typleListDefenders, _verteidigerSide, _verteidigerAnzahl, _angriffsDistanz, _verteidigerFahrzeugAbstand, _verteidigerGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, false]
    ] call CBA_fnc_waitUntilAndExecute;
     
};
    /* Sets random weather */
AK_fnc_randomWeather = {
    if (!isServer) exitWith {systemChat "ERROR: has to be executed on the server."};
    0 setOvercast random 1; 
    0 setRain random 1; 
    0 setFog [random 1, random [-1, 0, 1], random [-5000, 0, 5000]];
    setWind [random [0, 3, 100], random [0, 3, 100], true];
    forceWeatherChange;
};
// Function to assign waypoints spaced by distance towards destination 
// Remark: using vectors is faster than getDir
// Parameters: 
//   group: The group to assign waypoints to 
//   distance: The desired spacing between waypoints 
//   destination: The final destination position
// Return: Last issued waypoint 
// Example usage: {[_x, 100, [7020.41,11380.3,0]] call AK_fnc_spacedMovement} forEach (allGroups select {side _x == west}); 
AK_fnc_spacedMovement = { 
    private ["_group", "_distance", "_destination", "_currentPos", "_waypointPos"]; 
    _group = _this select 0; 
    _distance = _this select 1; 
    _destination = _this select 2; 
 
    // Get the current position of the group 
    _currentPos = getPos (leader _group); 
 
    // Calculate the direction towards the destination 
    _dir = _currentPos vectorFromTo _destination; 
    _dir = vectorNormalized _dir; 
 
    // Calculate the number of waypoints needed 
    _numWaypoints = floor((_currentPos distance _destination) / _distance); 
 
    // Assign waypoints 
    for "_i" from 1 to _numWaypoints do { 
        _waypointPos = _currentPos vectorAdd (_dir vectorMultiply (_i * _distance)); 
        _waypoint = _group addWaypoint [_waypointPos, 0];
        _waypoint setWaypointCompletionRadius 10;
    };
 
    // Assign the final destination waypoint 
    _lastwaypoint = _group addWaypoint [_destination, 0];
    
    _lastwaypoint 
}; 
/* ----------------------------------------------------------------------------
Function: AK_fnc_spacedvehicles

Description:
    Create ground and maritime vehicles, space them and let them move to a certain position.
	Also works with Helicopters as long as _spawnpos is over ground.
	
Parameters:
    0: _number		- Number of Vehicles <NUMBER> (default: 1)
    1: _type		- Type of Vehicle <STRING/ARRAY> (providing an array will override _number)
	2: _spawnpos	- Spawn Position <ARRAY>
	3: _destpos		- Destination. [] to stay at position. <ARRAY>
	4:   _side		- <SIDE>
	5: _spacing		- Spacing <NUMBER> (default: 50 m)
	6: _behaviour	- Group behaviour [optional] <STRING> (default: "AWARE")
	7: _breitegefstr- Width of the Area of responsibility <NUMBER> (default: 500 m)
	8: _platoonsize	- Number of vehicles forming one group <NUMBER> (default: 1)

Returns:
	[spawned crews, spawned vehicles, _spawnedgroups]

Example:
    (begin example)
		[4, "B_MBT_01_cannon_F", [23000, 18000 ,0], [22000, 18000, 0], west, 85, "SAFE", 500, 1] spawn AK_fnc_spacedvehicles;
    (end)
	
	(begin advanced example)

	//spawn units
	neuegruppen = [4, "B_MBT_01_cannon_F", [23000, 18000 ,0], [22000, 18000, 0], west, 85, "SAFE", 500, 1] spawn AK_fnc_spacedvehicles;
	neuegruppen;

	//add additional Waypoint
	{_x addWaypoint [[10000,10000,0],500]} forEach neuegruppen;

	//delete
	[neuegruppen] call LM_fnc_delete;
	(end)

Author:
    AK

---------------------------------------------------------------------------- */
//TODO align "formation" with destination and make the attackers keep formation (use "{_x addWaypoint [[15000,17500,0],500];} forEach _array;"?)
//TODO avoid vehicles blowing up on spawn
//TODO add an option to return netID?

AK_fnc_spacedvehicles = {  
params [
["_number", 1, [0]],
["_type", "B_MBT_01_cannon_F"],
["_spawnpos", [], [[]]],
["_destpos", [], [[]]],
["_side", west],
["_spacing", 50, [0]],
["_behaviour", "AWARE", [""]],
["_breitegefstr", 500, [0]],
["_platoonsize", 1, [0]]
];  
  
private ["_xPos", "_yPos", "_spawnedvehicles", "_spawnedunits", "_spawnedgroups", "_typeList"];   
   
_xPos = 0;   
_yPos = 0;
_spawnedunits = [];
_spawnedvehicles = [];  
_spawnedgroups = [];

// check for an array of types
if (_type isEqualType []) then {
	_typeList = _type;
} else {
	_typeList = [];
	for "_i" from 1 to _number do {
		_typeList pushBack _type;
	}
};


//spawn  
{
	_spawned = ([(_spawnpos vectorAdd [_xPos, _yPos, 0]), (_spawnpos getDir _destpos/* This fails when the _destpos is no coordinate*/), _x, _side] call BIS_fnc_spawnVehicle);
	_spawnedvehicles pushBack (_spawned select 0);
	{_spawnedunits pushBack _x} forEach (_spawned select 1); 
	_spawnedgroups pushBack (_spawned select 2); 
    _yPos = _yPos + _spacing;   
   
	if (_yPos > _breitegefstr) then {   
        _yPos = 0;   
        _xPos = _xPos + _spacing;   
    };  
} forEach _typeList;  
  
//group into platoons if requested  
if (_platoonsize > 1) then {   
	private _nbrplatoons = floor ((count _spawnedgroups) / _platoonsize);  
	private _a = 0;
	private _b = (_platoonsize -1);
	for "_x" from 1 to _nbrplatoons do {  
		private _joiners = _spawnedgroups select [_a, _b];
			{(units _x) join (_spawnedgroups select (_b + _a));
		} forEach _joiners;
		_spawnedgroups deleteRange [_a, _b];
		_a = _a +1;
		};  
	};  
//assign waypoints etc  
_xPos = 0;   
_yPos = 0;  
_spacing = _spacing * _platoonsize;  
{
	_x setBehaviour _behaviour;  
	_x deleteGroupWhenEmpty true;
	if !(count _destpos == 0) then {
		_x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];
		_x addWaypoint [getPos leader _x,10];
		_waypoint = _x addWaypoint [_destpos VectorAdd [_xPos,_yPos,0],10];
		_waypoint setWaypointType "CYCLE";  
		_yPos = _yPos + _spacing;  
		if (_yPos > _breitegefstr) then {   
			_yPos = 0;   
			_xPos = _xPos + _spacing;   
		};
	};
} forEach _spawnedgroups;  
[_spawnedvehicles, _spawnedunits, _spawnedgroups];
};  
/* ----------------------------------------------------------------------------
Function: AK_fnc_storeFPS

Description:
    Stores current FPS in a public Variable if it's lower than the curren value
	Probably won't work with multiple clients.
	
Parameters:
    nil

Returns:
	nil

Example:
    (begin example)
		[] call AK_fnc_storeFPS;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_storeFPS = {
	_fps = diag_fps;
	private ["_var"];
	_var = missionNamespace getVariable "AK_var_MinFPS"; 
	if !((isNil _var) or (_fps < _var)) exitWith {}; //skip if fps are higher than current value
	AK_var_MinFPS = _fps;
	publicVariable "AK_var_MinFPS";
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_TypeRatio

Description:
    Returns an array of strings with X elements preserving the ratio. (Intended for unit types but will work with all strings)

Example:
    (begin example)
		[["BMP2", "BMP2", "T72"], 15] call AK_fnc_TypeRatio;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_TypeRatio = {  
params ["_unitTypes", "_numberOfUnits"];   
_unitCounts = count _unitTypes;  
_unitDuplicates = _numberOfUnits / _unitCounts; 
_res = []; 
{  
	_x = _x;  
	for "_i" from 1 to floor _unitDuplicates do {  
	   _res pushBack _x;  
	};  
} forEach _unitTypes; 
while {count _res < _numberOfUnits} do { 
	{  
		if (count _res >= _numberOfUnits) then {  
			break;  
		};  
		_res pushBack _x;  
	} forEach _unitTypes; 
};  
_res  
}; 
