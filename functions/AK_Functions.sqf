AK_fnc_addCustomRespawnPosition = {
	/*
		Description:
			Adds a custom respawn position using BIS_fnc_addRespawnPosition and optionally locks all crew positions (except passengers).
	
		Parameters:
			_target	 - Namespace, Side, Group or Object: Receiver of the respawn position (e.g., missionNamespace for all)
			_position   - Array, Object or String: Location of the respawn position (ATL array, object, or marker)
			_name	   - String: Name shown for the respawn position
			_lockCrew   - Boolean: Whether to lock all crew positions (driver, gunner, etc., passengers remain unlocked)
	
		Returns:
			Array - [id, name] for use with BIS_fnc_removeRespawnPosition
		Example:
			[BLUFOR, helicopter, getText (configFile >> "CfgVehicles" >> typeOf helicopter >> "displayName"), true] call AK_fnc_addCustomRespawnPosition; 
	*/
	
	params [
		"_target",	  // Namespace, Side, Group or Object
		"_position",	// Array, Object, or String
		"_name",		// String
		["_lockCrew", true] // Boolean (optional)
	];
	
	// Validate basic input
	if (isNil "_target" || isNil "_position" || isNil "_name") exitWith {
		diag_log "[fnc_addCustomRespawnPosition] Error: Invalid parameters.";
		[]
	};
	
	// Add the respawn position
	private _respawnID = [_target, _position, _name] call BIS_fnc_addRespawnPosition;
	
	// Lock crew positions if enabled and _position is an object
	if (_lockCrew && { _position isKindOf "AllVehicles" }) then {
		private _vehicle = _position;
	
		_paths = allTurrets _vehicle;
		{_vehicle lockTurret [_x, true]} forEach _paths;
		_vehicle lockDriver true;};
	
	[_respawnID, _name]
};
AK_fnc_Airattack = { 
 // Made for AK_fnc_quickAirBattle 
 // ENHANCE reorder params and add defaults 
 params ["_spawnPosAnchor", "_mainDirectionVector", "_mainDirection", "_typleListAttackers", "_side", "_angreiferAnzahl", "_angriffsDistanz", "_fahrzeugAbstand", "_gefechtsstreifenBreite", "_angriffsZiel", "_moveOut", "_crewInImmobile"]; 
 private _altitude = 1000;
 _positions = ([_spawnPosAnchor, _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform); 
 _angriffszielPositions = []; 
 if (_moveOut) then { 
  _angriffszielPositions = ([_spawnPosAnchor vectorAdd ((_mainDirectionVector) vectorMultiply _angriffsDistanz), _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform); 
 }; 
 _spawnedGroups = []; 
 
 for "_i" from 0 to (count _positions) do { 
  _spawndata = [(_positions select _i) vectorAdd [0,0,_altitude], _mainDirection, _typleListAttackers select _i, _side, false] call BIS_fnc_spawnVehicle; 
  _vehicle = _spawndata select 0;
  _group = _spawndata select 2; 
  _group deleteGroupWhenEmpty true;
  //_group setBehaviour "SAFE"; 
  _spawnedGroups pushBack _group;
  
  _vehicle flyInHeightASL [_altitude, _altitude, _altitude];
   
 
  if (_moveOut) then { 
   _destination = _angriffszielPositions select _i; 
   _lastWaypoint = _group addWaypoint [_destination, 0];
   _group setVariable ["AK_attack_data", [_group, _angriffsZiel, _gefechtsstreifenBreite]]; 
   _lastWaypoint setWaypointStatements ["true", " 
    _attackData = (group this) getVariable 'AK_attack_data'; 
    _group = _attackData select 0; 
    _angriffsZiel = _attackData select 1; 
    _gefechtsstreifenBreite = _attackData select 2; 
    [_group, _angriffsZiel, _gefechtsstreifenBreite] call CBA_fnc_taskPatrol; 
    " 
   ]; 
  }; 
  if (_crewInImmobile) then { 
   _vehicle allowCrewInImmobile true; 
  }; 
 }; 
 _spawnedGroups 
};AK_fnc_AmbientArtillery = {
        AK_switch_AmbientArtilleryFire = true;
        _shelltype = "Sh_155mm_AMOS";
        _intensity = 1;   
        while {AK_switch_AmbientArtilleryFire == true} do {
            _shellspread = viewDistance;
            _intensityFactor = (viewDistance ^ 2) / (4000 ^ 2);
            _victim = selectRandom allPlayers;
            //TODO change from square to evenly distributed circle
            _expectedVictimPos = getPosASL _victim vectorAdd ((velocity _victim) vectorMultiply 30);
            _barragePos = [(_expectedVictimPos select 0) + _shellspread - 2*(random _shellspread) ,(_expectedVictimPos select 1) + _shellspread - 2*(random _shellspread), 0];
            _barrageShotCount = floor random [1 , 6, 36];
            _barrageDispersion = floor random [50, 250, 500]; 
            for "_i" from 1 to _barrageShotCount do    
             {
                _altitude = random [500, 5000, 25000];    
                _shell = createVehicle [_shelltype, [_barragePos select 0, _barragePos select 1, _altitude], [], _barrageDispersion];    
                _shell setVelocity [0, 0, -50];        
             };
             //DEBUG
             [format ["%1 s: %2 you got %3 Nockerl incoming!", diag_tickTime, _victim, _barrageShotCount]] remoteExec ["systemChat", 0];
             _barrageMarker = createMarker [str diag_tickTime, _barragePos];
             _barrageMarker setMarkerType "hd_dot"; 
             _barrageMarker setMarkerColor "ColorRed";
             _aimMarker = createMarker [(str diag_tickTime) + "Aim", _expectedVictimPos];
             _aimMarker setMarkerType "mil_destroy_noShadow";
             //_barrageMarker setMarkerShape "ELLIPSE"; 
             //_barrageMarker setMarkerSize [_barrageDispersion, _barrageDispersion];
             sleep (random [1 , 60, 180] / _intensity / _intensityFactor);
        };
	};
AK_fnc_attack = {
	// Made for AK_fnc_quickbattle
	// ENHANCE reorder params and add defaults
	// ENHANCE Anmarsch zur Sturmausgangsline 
	// ENHANCE Wegpunkt Zug um Zug festlegen?
	// ENHANCE Verteidiger mit Stellungen versehen _mainDirection = 90;_trench = [[300, 0, 0], _mainDirection, "Land_WW2_TrenchTank", west] call BIS_fnc_spawnVehicle select 0;_group = [(_trench getRelPos [2, 180]), _mainDirection, "B_MBT_01_cannon_F", west] call BIS_fnc_spawnVehicle select 2;_group deleteGroupWhenEmpty true; 

	params ["_spawnPosAnchor", "_mainDirectionVector", "_mainDirection", "_typleListAttackers", "_side", "_angreiferAnzahl", "_angriffsDistanz", "_fahrzeugAbstand", "_gefechtsstreifenBreite", "_linieSturmAngriff", "_angriffsZiel", "_moveOut", "_crewInImmobile"];
	_positions = ([_spawnPosAnchor, _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
	//            _sturmAusgangsstellungPositions = ([_spawnPosAnchor vectorAdd ((_mainDirectionVector) vectorMultiply _linieSturmAngriff), _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
	_angriffszielPositions = [];
	if (_moveOut) then {
		_angriffszielPositions = ([_spawnPosAnchor vectorAdd ((_mainDirectionVector) vectorMultiply _angriffsDistanz), _angreiferAnzahl, _fahrzeugAbstand, _mainDirectionVector, _gefechtsstreifenBreite] call AK_fnc_gefechtsform);
	};
	_spawnedGroups = [];

	for "_i" from 0 to (count _positions) do {
		_spawndata = [_positions select _i, _mainDirection, _typleListAttackers select _i, _side, false] call BIS_fnc_spawnVehicle;
		_group = _spawndata select 2;
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
				[_group, _angriffsZiel, _gefechtsstreifenBreite] call CBA_fnc_taskPatrol;
				"
			];
		};
		if (_crewInImmobile) then {
			(_spawndata select 0) allowCrewInImmobile true;
		};
	};
	_spawnedGroups
};AK_fnc_ballisticData = {   
/*
Collect ballistic data.
The data is saved to localNamespace as variable named str _projectile. It includes following data:
[0: str _unit, 1: _weapon, 2: _muzzle, 3: _mode, 4: _ammo, 5: _magazine, 6: str _gunner, 7: _shotTime, 8: _firerPos, 9: _muzzleVelocity, 10: typeOf _unit]
ENHANCE  
 add inflicted vehicle damage  
 add inflicted casualities 
HEADSUP  
 after attachTo the impact marker is not reliable  
BUGS  
 SPE vehicles that are gradually destroyed by ammo fires may not be detected.  
 _firerPos is not consistant with where the bullet actually starts  
PONDER
    use systemTimeUTC or diag_tickTime? diag_tickTime is 2.6x faster but the former provides more granularity in logging 
EXAMPLE 1 
{ 
_x addEventHandler ["Fired", {  
 [_this,  
  [ 
   diag_tickTime, // shotTime 
   getPosASL (_this select 6), // shooter position 
   velocity (_this select 6) // V0 
  ] 
 ] call AK_fnc_ballisticData; 
 }]; 
} forEach vehicles;  
END EXAMPLE 1  
*/   
    AK_switch_ballisticDataDebug = true;  
   
    (_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];  
    (_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];
    private _projectileString = str _projectile;
    localNamespace setVariable [_projectileString, [str _unit, _weapon, _muzzle, _mode, _ammo, _magazine, str _gunner, _shotTime, _firerPos, _muzzleVelocity, typeOf _unit]];
  
 _projectile addEventHandler ["HitPart", {   
  params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius" ,"_surfaceType", "_instigator"];  
    
  if (alive _hitEntity && !(_hitEntity isKindOf "Building")) then { // rule out buildings and landscape  
   _hitMessage = ["Function", "Event Handler", "Projectile", "Impact Position", "Impact Velocity", "Target Designation", "Target Type", "Target Position", "Target Heading", "Target Velocity", "Target Side", "TickTime", "Components", "NormalAngle", "Surface"] createHashMapFromArray ["AK_fnc_ballisticData", "HitPart", _projectile, _pos, _velocity, _hitEntity,typeOf _hitEntity, getPosASL _hitEntity, direction _hitEntity, velocity _hitEntity, side _hitEntity, diag_tickTime, _components, _normal, _surfaceType];  
   diag_log text (toJSON _hitMessage);  
   if (AK_switch_ballisticDataDebug == true) then {systemChat str _hitMessage;};  
  
   if ((_components select 0) == "head") then {  
 systemChat format ["HEADSHOT by %1 against %2. Range: %3", _projectileOwner, _hitEntity, _projectileOwner distance _hitEntity];  
   };  
   // impactMarker 
   if (AK_switch_ballisticDataDebug == true) then {
   /*
   // create impact marker  
    _marker = "Sign_arrow_blue_F" createVehicle [0,0,0];  
    _marker setPos ASLtoAGL _pos;  
    //_marker attachTo [_hitEntity];   
    _marker setVectorUp (_velocity apply {_x * -1});  
    // create normal-to-surface Marker  
    _marker = "Sign_arrow_F" createVehicle [0,0,0];  
    _marker setPos ASLtoAGL _pos;  
    //_marker attachTo [_hitEntity];   
    _marker setVectorUp _normal;
    */
    hintSilent format ["HitPart: Impact Angle: %1. AA: %2", asin (_velocity vectorCos _normal), [_projectileOwner, _hitEntity] call AK_fnc_getAA]; 
 };  
    
      // assign Event Handler to _hitEntity  
   if (_hitEntity getVariable ["AK_switch_DammagedHandler", false] == false) then {  
 _hitEntity addEventHandler ["Dammaged", {   
  params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];  
  // check if someone caused the damage or it was caused by other factors for example a burning vehicle  
  if (isNull _shooter == false) then {  
   // has a vital HitPoint been damaged  
   if (_hitPoint in ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"]) then {  
    // avoid multiple triggers of dammaged in rapid succession.  
    if ((_unit getVariable ["AK_switch_dammagedCooldown", None]) == _shooter) exitWith {};  
    _unit setVariable ["AK_switch_dammagedCooldown", _shooter];  
    [_unit] spawn {  
  sleep 1;  
  (_this select 0) setVariable ["AK_switch_dammagedCooldown", nil];  
    };  
    // has a vital HitPoint been destroyed  
    _criticalHitPointStatus = [];  
    {_criticalHitPointStatus pushBack (floor (_unit getHitPointDamage _x))} forEach ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"];  
    if !(1 in _criticalHitPointStatus) exitWith {};  
   
    _approxdistance = _unit distance _shooter;  
    _status = 'immobilized';  
    if (_criticalHitPointStatus select 4 == 1 or _criticalHitPointStatus select 5 == 1) then {  
  _status = 'incapacitated';  
    };  
    if (_criticalHitPointStatus select 0 == 1) then {  
  _status = 'destroyed';  
    }; 
    _dammageLogEntry = ["Function", "Event Handler", "Unit", "Selection", "Damage", "HitIndex", "HitPoint", "Shooter", "Projectile", "tickTime", 'Vehicle Damage [hithull, hitltrack, hitrtrack, hitengine, hitturret , hitgun]'] createHashMapFromArray ["AK_fnc_ballisticData", "Vehicle Critical Dammaged", _unit, _selection, _damage, _hitIndex, _hitPoint, _shooter, _projectile, diag_tickTime, _criticalHitPointStatus];    
    diag_log text (toJSON _dammageLogEntry); 
    _dammageMessage = format ["%1 %2 %3 by causing %4 damage to selection %5 at a range of %6 using %7", _shooter, _status, _unit, _damage, _selection, _approxdistance, _projectile];  
    if (AK_switch_ballisticDataDebug == true) then {  
  systemChat _dammageMessage;  
    };  
   };  
  };  
 }];  
   _hitEntity setVariable ["AK_switch_DammagedHandler", true];  
   };  
  };   
 }]; 
 _projectile addEventHandler ["Penetrated", {  
  params ["_projectile", "_hitObject", "_surfaceType", "_entryPoint", "_exitPoint", "_exitVector"];
  _projectile = str _projectile; // createHashMapFromArray seems to be to slow
  _hitObject = str _hitObject;
  systemChat str [_projectile, _hitObject]; 
  _penetrationKeys = ["Function", "Event Handler", "Projectile", "HitObject", "SurfaceType", "EntryPoint", "ExitPoint", "ExitVector", "tickTime"]; 
  _penetrationValues = ["AK_fnc_ballisticData", "Penetrated", _projectile, _hitObject, _surfaceType, _entryPoint, _exitPoint, _exitVector, diag_tickTime]; 
  _penetrationMessage = _penetrationKeys createHashMapFromArray _penetrationValues; 
  diag_log text (toJSON _penetrationMessage); 
 }]; 
 _projectile addEventHandler ["SubmunitionCreated", {  
  params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];  
  _submunitionKeys = ["Function", "Event Handler", "Projectile", "submunitionProjectile", "Position", "Velocity", "tickTime"]; 
  _submunitionValues = ["AK_fnc_ballisticData", "SubmunitionCreated", _projectile, _submunitionProjectile, _pos, _velocity, diag_tickTime]; 
  _submunitionMessage = _submunitionKeys createHashMapFromArray _submunitionValues; 
  diag_log text (toJSON _submunitionMessage);
  if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _submunitionMessage};  
 }]; 
 _projectile addEventHandler ["Explode", {  
  params ["_projectile", "_pos", "_velocity"];
  private _data = localNamespace getVariable [str _projectile,  "None"];
  _shotDistance = _pos distance (_data select 8);
  _explosionKeys = ["Function", "Event Handler", "Projectile", "Position", "Velocity", "tickTime"]; 
  _explosionValues = ["AK_fnc_ballisticData", "Explode", _projectile, _pos, _velocity, diag_tickTime]; 
  _explosionMessage = _explosionKeys createHashMapFromArray _explosionValues; 
  diag_log text (toJSON _explosionMessage);
  /*
   if (AK_switch_ballisticDataDebug == true) then {
       private _ammo = _data select 4;
       private _weapon = _data select 1;
       private _platform = _data select 10;
       systemChat format ["%1 shot by %2 using %3 exploded at a distance of %4 m.", _ammo, _platform, _weapon, _shotDistance];
       private _distanceRecords = player getVariable ["AK_var_distanceRecords", "None"];
       if (typeName _distanceRecords != "HASHMAP") then {
           _distanceRecords = createHashMap;
        };
       _distanceRecords set [_platform, [_weapon, _ammo, _shotDistance]];
       player setVariable ["AK_var_distanceRecords", _distanceRecords];
       };
 */
 }]; 
    _projectile addEventHandler ["Deflected", {  
        params ["_projectile", "_position", "_velocity", "_hitObject"]; 
        _deflectionKeys = ["Function", "Event Handler", "Projectile", "Position", "Velocity", "HitObject", "tickTime"]; 
        _deflectionValues = ["AK_fnc_ballisticData", "Deflected", str _projectile, _position, _velocity, str _hitObject, diag_tickTime]; 
        _deflectionMessage = _deflectionKeys createHashMapFromArray _deflectionValues; 
        diag_log text (toJSON _deflectionMessage);  
    }];
     
    _projectile addEventHandler ["Deleted", { 
        params ["_projectile"];
        private _projectileString = str _projectile;
        private _projectileData = localNamespace getVariable [_projectileString,  "None"];
        private _deletePos = getPos _projectile; 
        private _shotDistance = _deletePos distance (_projectileData select 8);
        private _timeAlive = diag_tickTime - (_projectileData select 7);
        private _dataHashMap = ["Function", "Event", "Projectile", "TimeAlive", "Distance", "AGL", "Avg Speed"] createHashMapFromArray ["AK_fnc_ballisticData", "Deleted", _projectileString, _timeAlive, _shotDistance, _deletePos select 2, _shotDistance / _timeAlive];
        diag_log text (toJSON _dataHashMap);
        localNamespace setVariable [_projectileString, nil];
        if (AK_switch_ballisticDataDebug == true) then {systemChat toJSON _dataHashMap}; //format ["%1 deleted at time %2", _projectile, systemTimeUTC];}; 
    }];
    private _showData = localNamespace getVariable [_projectileString, "None"];
    _showData pushBack (getNumber (configFile >> "CfgWeapons" >> (_showData select 1) >> "maxRange"));
    _showData pushBack "AK_fnc_ballisticData";
    private _logData = ["Unit", "Weapon", "Muzzle", "Mode", "Ammo", "Magazine", "Gunner", "Shottime", "Firer Position", "Muzzle Velocity", "Unittype", "Config maxRange", "Function"] createHashMapFromArray _showData;
    diag_log text toJSON _logData; 
    if (AK_switch_ballisticDataDebug == true) then {
        systemChat str _showData;
        
        /* DISABLED show projectile velocity
        ACE_player setVariable ["AK_ballisticData_activeProjectile", _projectile];
        onEachFrame {hintsilent ((str (round (vectorMagnitude (velocity (ACE_player getVariable["AK_ballisticData_activeProjectile", ACE_player]))))) + " m/s");};
        */
    };
};   
/* ---------------------------------------------------------------------------- 
	Function: AK_fnc_battlelogger_standalone 
	 
	Description: 
	    End and restart an automated battle and log events for later analysis. 
	  
	Parameters: 
	    0: _location- Starting Location <ARRAY>
	 
	Returns: 
	    ?
	 
	Example: 
	    (begin example) 
	    [[0, 0, 0]] call AK_fnc_battlelogger_standalone
	    (end) 
	
	Caveats:
	    needs AK_var_fnc_automatedBattleEngine_unitTypes
	    the code works via Advanced Developer Tools console, but not via ZEN (Execute code) (likely reason: comments)
	    does not work in singleplayer (see HEADSUP)
	
	Author: 
	    AK 
	 
---------------------------------------------------------------------------- */ 
AK_fnc_battlelogger_standalone = {
	_location = _this select 0;
	[
		        {}, // code

		        10, // delay in s 

		        [_location], // parameters 

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
			           // avoid impaired visibility
			0 setFog 0;
			0 setRain 0;
			[[2035, 06, 21, 12, 00]] call BIS_fnc_setDate;
			           // set variables ENHANCE find another way
			_AK_var_fnc_battlelogger_typeEAST = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
			_AK_var_fnc_battlelogger_typeINDEP = (selectRandom AK_var_fnc_automatedBattleEngine_unitTypes);
			_AK_var_fnc_battlelogger_startTime = systemTime;
			            _AK_var_fnc_battlelogger_start_time_float = serverTime; // only for the timeout, new variable iot not break ABE_auswertung.py
			_PosSide1 = [_location, (_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance)];
			_PosSide2 = [(_location vectorAdd _AK_var_fnc_battlelogger_engagementDistance), _location];

			diag_log format ["AKBL %1 Battlelogger starting! %2 vs. %3", _AK_var_fnc_battlelogger_Version, _AK_var_fnc_battlelogger_typeEAST, _AK_var_fnc_battlelogger_typeINDEP];
			           // alternate locations
			if (random 1 >= 0.5) then {
				_templocation = _PosSide1;
				_PosSide1 = _PosSide2;
				_PosSide2 = _templocation;
			};

			_spawnedgroups1 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeEAST, (_PosSide1 select 0), (_PosSide1 select 1), east, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles;
			_spawnedgroups2 = [_AK_var_fnc_battlelogger_numberOfStartingVehicles, _AK_var_fnc_battlelogger_typeINDEP, (_PosSide2 select 0), (_PosSide2 select 1), independent, _AK_var_fnc_battlelogger_vehSpacing, "AWARE", _AK_var_fnc_battlelogger_breiteGefStr, _AK_var_fnc_battlelogger_platoonSize] call AK_fnc_spacedvehicles;
			_AK_battlingUnits = [];
			{
				_AK_battlingUnits pushBack ((_spawnedgroups1 select _x) + (_spawnedgroups2 select _x));
			} forEach [0, 1, 2];

			{
				_x allowCrewInImmobile true
			} forEach (_AK_battlingUnits select 0);

			if (_AK_var_fnc_battlelogger_noFuel == true) then {
				{
					// set fuel
					_x setFuel 0;
				} forEach (_AK_battlingUnits select 0);
			} else {
				{
					// let the vehicles move back and forth
					_wp = _x addWaypoint [[0, 0, 0], 0];
					_wp setWaypointType "CYCLE";
				} forEach (_AK_battlingUnits select 2);
			};
		},

		       // end 
		{
			_east_veh_survivors = ({
				side _x == east
			} count (_AK_battlingUnits select 0));
			_indep_veh_survivors = ({
				side _x == independent
			} count (_AK_battlingUnits select 0));
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

			           // cleanup
			{
				deleteVehicle _x
			} forEach (_AK_battlingUnits select 0);
			{
				deleteVehicle _x
			} forEach (_AK_battlingUnits select 1);
			{
				deleteGroup _x
			} forEach (_AK_battlingUnits select 2);
			_AK_battlingUnits = nil;

			[_location, 5] spawn AK_fnc_delay;
		},

		 {
			true
		}, // Run condition 

		       // exit Condition 
		{
			((({
				alive _x
			} count (_AK_battlingUnits select 1)) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles) or
			(serverTime >= (_AK_var_fnc_battlelogger_timeout + _AK_var_fnc_battlelogger_start_time_float)) or
			((({
				side _x == east
			} count (_AK_battlingUnits select 0)) + ({
				side _x == independent
			} count (_AK_battlingUnits select 0))) <= _AK_var_fnc_battlelogger_numberOfStartingVehicles))
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
		        ]// list of local variables that are serialized between executions.  (optional) <CODE>
	] call CBA_fnc_createPerFrameHandlerObject;
};/* ----------------------------------------------------------------------------
	Function: AK_fnc_battlezone
	
	Description:
	    Creates a battle between east and west. The player can fight alongside one of the parties or choose independent and fight both.
		Execute on the server and use some kind of Garbage Collector otherwise the dead units will quickly kill performance.
	
	Parameters:
	    0: _AZ- Objective <ARRAY> (default: [500, 500, 0])
	    1: _pltstrength- Minimum Number of units per platoon (max. depends on group strength) <NUMBER> (default: 40)
		2: _maxveh- Maximum number of vehicles per group. <NUMBER> (default: 0)
	    3: _spawndelay  - time in seconds between spawn attemtps. <NUMBER> (default: 300)
	
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
// ENHANCE choose factions
// ENHANCE let allies spawn on the same side of the battlefield
// ENHANCE dynamically adapt to number of clients
// ENHANCE cleanup the select select select mess
// BUG in some cycles one side doesn't spawn 
AK_fnc_battlezone = {
	params [
		["_AZ", [1500, 1500, 0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]],
		["_spawndelay", 300, [0]]
	];

	[{
		[] remoteExec ['AK_fnc_storeFPS', -2]
	}, (_spawndelay / 10)] call CBA_fnc_addPerFrameHandler;// publish the clients FPS

	[{
		(_this select 0) params [
			["_AZ", [1500, 1500, 0], [[]]],
			["_pltstrength", 40, [0]],
			["_maxveh", 0, [0]]
		];
		diag_log format ['AK_fnc_battlezone: PerFrameHandler-Variables %1', _this];
		// check performance and skip spawning if too low
		[] remoteExec ['AK_fnc_storeFPS', 0];// update min. FPS
		if (AK_var_MinFPS < 25) exitWith {
			diag_log 'AK_fnc_battlezone: low FPS, skipping spawn.';
			AK_var_MinFPS = 60;
			publicVariable "AK_var_MinFPS";
		};

		// debug
		diag_log format ['Hello I am the server executing AK_fnc_battlezone and these are my variables: %1 - %2 - %3', _this select 0 select 0, _this select 0 select 1, _this select 0 select 2];

		[0, east, _AZ, _pltstrength, _maxveh] call AK_fnc_moveRandomPlatoons;
		[1, west, _AZ, _pltstrength, _maxveh] call AK_fnc_moveRandomPlatoons;// spawn
	}, _spawndelay, [_AZ, _pltstrength, _maxveh]] call CBA_fnc_addPerFrameHandler;
};AK_fnc_Benchmark = {
	// _attackerType = "B_MBT_01_cannon_F";
	// _defenderType = "O_MBT_02_cannon_F";
	AK_var_serverFPS = [];
	publicVariable "AK_var_serverFPS";
	AK_var_clientFPS = [];
	AK_toggle_benchmark = true;
	[{
		_distance = 2400;
		setViewDistance _distance;
		setObjectViewDistance _distance;
		setTerrainGrid 1;
	}] remoteExec ["call", 0];
	if (isDedicated) exitWith {
		diag_log "ERROR: This script only works if it is executed on the curator's client."
	};
	[curatorSelected, true, 31, 17, 2000, 2000] remoteExec ["AK_fnc_quickBattle", 2];

	_lastFrameInfo = [diag_frameno, time];
	[{
		AK_var_serverLastFrameInfo = [diag_frameno, time]
	}] remoteExec ["call", 2];
	while { AK_toggle_benchmark == true } do {
		sleep 10;
		_currentFrameNo = diag_frameno;
		_currentTime = time;
		_lastFrameNo = _lastFrameInfo select 0;
		_lastFrameTime = _lastFrameInfo select 1;
		AK_var_clientFPS pushBack (round ((_currentFrameNo - _lastFrameNo) / (_currentTime - _lastFrameTime)));
		_lastFrameInfo = [_currentFrameNo, _currentTime];
		[{
			publicVariable "AK_var_serverFPS";
			_currentFrameNo = diag_frameno;
			_currentTime = time;
			_lastFrameNo = AK_var_serverLastFrameInfo select 0;
			_lastFrameTime = AK_var_serverLastFrameInfo select 1;
			AK_var_serverFPS pushBack (round ((_currentFrameNo - _lastFrameNo) / (_currentTime - _lastFrameTime)));
			AK_var_serverLastFrameInfo = [_currentFrameNo, _currentTime];
		}] remoteExec ["call", 2];
	};
};/* ----------------------------------------------------------------------------
	Function: AK_fnc_cfgFactionTable
	
	Description:
	    Creates a table of factions.
		Use to provide input to AK_fnc_cfgGroupTable.
	
	Parameters:
	    0: _side- 0 = opfor, 1 = blufor, 2 = independent <NUMBER>
		1: _configName- false = full config entry, true = configName <BOOLEAN> (default: true)
	
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
		case 1: {
			"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses") apply {
				configName _x
			};
		};
		case 0: {
			"getNumber (_x >> 'side') == _side" configClasses (configFile >> "CfgFactionClasses");
		};
	};
};/* ----------------------------------------------------------------------------
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
		["_cfgfaction", "BLU_F", []]
	];
	private ["_cfgSide", "_newCfgEntry", "_arm", "_groups"];

	// get side of _cfgfaction
	_cfgSide = getNumber (configFile >> "CfgFactionClasses" >> _cfgfaction >> "side");
	_newCfgEntry = ("getNumber (_x >> 'side') == _cfgSide" configClasses (configFile >> "CfgGroups") apply {
		configName _x
	}) select 0;
	_newCfgEntry = configFile >> "CfgGroups" >> _newCfgEntry;
	// iterate through arms and get all groups that have matching sides
	_arm = "true" configClasses (_newCfgEntry >> _cfgfaction) apply {
		configName _x
	};
	_groups = [];
	{
		_groups pushBack ("getNumber (_x >> 'side') == _cfgSide" configClasses (_newCfgEntry >> _cfgfaction >> _x));
	} forEach _arm;
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
	private _unittable = "getText (_x >> 'faction') == _cfgfaction and configName _x isKindOf _cfgkind and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles") apply {
		configName _x
	};
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
		[list_of_groups] call AK_fnc_cleangrouplist;
    (end)

Author:
    AK

---------------------------------------------------------------------------- */
AK_fnc_cleangrouplist = {
	params ["_groups"];
	_deletedindex = [];
	{
		if (isNull _x) then {
			_deletedindex pushBack _forEachIndex
		}
	} forEach _groups;
	_deletedindex sort false;
	{
		_groups deleteAt _x
	} forEach _deletedindex;
	_groups;
};
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
AK_fnc_createWeatherFilename = {
    /*
     returns a string based on systemTimeUTC rounded down to half hours
     created to be used with weather updates
    Example
        ['_weatherdata.sqf'] call AK_fnc_createWeatherFilename; 
    */
    params ["_endOfString"];
    private _systemTimeUTC = systemTimeUTC;
    private _filePath = "";
    
    AK_fnc_addLeadingZeros = {
        params ["_inputString", "_desiredStringLength"];
        while {count _inputString < _desiredStringLength} do {
            _inputString = _inputString insert [0, '0'];
        };
        _inputString
    };
    
    AK_fnc_roundDownMinutes = {
        // rounds down to 30 minute intervals
        params ["_value"];
        private _result = 30;
        if (_value < 30) then {_result = 0};
        _result
    };
    
    _filePath = _filePath +
        str (_systemTimeUTC select 0) + 
        ([str (_systemTimeUTC select 1), 2] call AK_fnc_addLeadingZeros) + 
        ([str (_systemTimeUTC select 2), 2] call AK_fnc_addLeadingZeros) + 
        ([str (_systemTimeUTC select 3), 2] call AK_fnc_addLeadingZeros) +
        ([str ([_systemTimeUTC select 4] call AK_fnc_roundDownMinutes), 2] call AK_fnc_addLeadingZeros) +
        '_' +
        (toLower worldName) +
        _endOfString;
    _filePath
};

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
AK_fnc_dataVaultInitialize = {
	AK_object_dataVault = createVehicle ["Land_Laptop_02_unfolded_F", getPosATL player];
	publicVariable "AK_object_dataVault";
	[{
		AK_object_dataVault setVariable ["dataVaultOfNetID" + str clientOwner, [], true];
	}] remoteExec ["call", 0, "AK_dataVault"];
};
 
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
AK_fnc_defend = {
	if (isNil "AK_fnc_differentiateClass") exitWith {
		diag_log "AK_fnc_defend ERROR: AK_fnc_differentiateClass required"
	};

	params ["_refPos", "_numberofgroups", "_side", "_grouptype"];
	 _gkgfDichte = 3.14;// vehicles or groups per km²

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
		if (isNull _gruppe) exitWith {
			diag_log "AK_fnc_defend ERROR: no groups spawned"
		};
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
	private _markerstr = createMarker ["military1", (getPos _objective)];
	_markerstr setMarkerShape "ICON";
	_markerstr setMarkerType "n_support";
	_markerstr setMarkerText "Klopapierlager";
	private _numberofprivates = 10;
	private _radius = 2000;
	private _typeofunit = ["LOP_BH_Infantry_model_OFI_TRI", "LOP_BH_Infantry_model_OFI_M81", 'LOP_BH_Infantry_model_OFI_LIZ', "LOP_BH_Infantry_model_OFI_FWDL", "LOP_BH_Infantry_model_OFI_ACU", "LOP_BH_Infantry_model_M81_TRI", "LOP_BH_Infantry_model_M81_LIZ", "LOP_BH_Infantry_model_M81_FWDL", "LOP_BH_Infantry_model_M81_CHOCO", "LOP_BH_Infantry_model_M81_ACU", "LOP_BH_Infantry_model_M81", "LOP_BH_Infantry_AR", "LOP_BH_Infantry_AR_2", "LOP_BH_Infantry_AR_Asst", "LOP_BH_Infantry_AR_Asst_2", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_base", "LOP_BH_Infantry_Corpsman", "LOP_BH_Infantry_Driver", "LOP_BH_Infantry_GL", "LOP_BH_Infantry_IED", "LOP_BH_Infantry_Marksman"];
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
	while { _a = _a + 1;
	_a < (_numberofprivates + 1) } do {
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
    Special function for ABE to allow a delay between calls of the battlelogger.
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
	if (canSuspend == false) exitWith {
		diag_log "ERROR AK_fnc_delay: Scope is not suspendable";
	};
	_initialFPS = diag_frameNo;
	_initialTime = diag_tickTime;
	sleep _delayInS;
	_longFpsAvg = (diag_frameNo - _initialFPS) / (diag_tickTime - _initialTime);

	while { (_longFpsAvg < 40) or (diag_fpsMin < 40) } do {
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
		if ("CfgGroups" in str _candidate) exitWith {
			"Group"
		};
		"Vehicle";
	} else {
		if ((isClass (configFile >> "CfgVehicles" >> _candidate)) == true) exitWith {
			"Vehicle"
		};
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

	   // execute on server only
	if (isServer == false) exitWith {
		hint "AK_fnc_dynAdjustVisibility has to run on the server";
	};

	    // check server load    
	_serverFPS = diag_fps;
	if (_serverFPS <= _fps) then {
		_fps = _serverFPS
	};

	   // calculate values 
	_referenceValues params ["_verylow", "_low", "_high"];
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
	_wp setWaypointStatements ["true", "_vehicleleader = vehicle leader this;
		{
			deleteVehicle _x
		} forEach crew _vehicleleader + [_vehicleleader];
	deleteGroup (group this);"];
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
			_hitArray pushBack _x;
		}
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
	3: _sinkrate	- Sinkrate <NUMBER> (default: -2)
 
Returns: 
 NIL 
 
Example: 
    (begin example) 
        [player modelToWorld [0, 100, 0], "RED", 120, -2] call AK_fnc_flare; 
    (end) 
 
Author: 
    AK 
 
---------------------------------------------------------------------------- */ 
AK_fnc_flare = {
	params [
		["_position", [0, 0, 0]],
		["_color", "WHITE"],
		["_height", 120],
		["_sinkrate", -2]
	];

	_shell = createVehicle [("F_40mm_" + _color), (_position vectorAdd [0, 0, _height]), [], 0, "NONE"];
	_shell setVelocity [0, 0, _sinkrate];
};
AK_fnc_gefechtsform = {
	// returns a grid of positions on the surface with battle formations of tank companies in mind

	params [
		["_anchorPos", [0, 0, 0], [[]]],
		["_number", 14, [0]],
		["_spacing", 75, [0]],
		["_orientationVector", [0, 1, 0], [[]]],
		["_maxWidth", 650, [0]]
	];
	if (_number < 1) exitWith {
		diag_log "WARNING AK_fnc_gefechtsform: less then 1 positions have been requested"
	};
	private _positions = [];
	private _yOrientationVector = [_orientationVector, 90] call BIS_fnc_rotateVector2D;
	private _xOrientationVector = [_orientationVector, 180] call BIS_fnc_rotateVector2D;
	private _posPerLine = floor (_maxWidth / (_spacing));
	private _lines = floor (_number / _posPerLine);
	for "_line" from 0 to _lines do {
		if ((count _positions) >= _number) exitWith {
			_positions
		};
		private _rowPosition = (_anchorPos vectorAdd (_xOrientationVector vectorMultiply (_line * _spacing)));
		       // add first position
		        _positions pushBack [_rowPosition select 0, _rowPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
		for "_y" from 1 to (ceil (_posPerLine / 2)) do {
			// position to the right
			if ((count _positions) >= _number) exitWith {
				_positions
			};
			private _finalPosition = (_rowPosition vectorAdd (_yOrientationVector vectorMultiply (_y * _spacing)));
			            _positions pushBack [_finalPosition select 0, _finalPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
			if ((count _positions) >= _number) exitWith {
				_positions
			};
			            _yOrientationVector = [_yOrientationVector, 180] call BIS_fnc_rotateVector2D;// reverse the vector
			           // position to the left
			private _finalPosition = (_rowPosition vectorAdd (_yOrientationVector vectorMultiply (_y * _spacing)));
			            _positions pushBack [_finalPosition select 0, _finalPosition select 1, 0]; // set z to 0 to avoid getting positions below the surface
		};
	};
	_positions
};/* ---------------------------------------------------------------------------- 
	Function: AK_fnc_getAA 
	 
	Description: 
		Returns the Aspect Angle. 
	  
	Parameters: 
		0: _fighter - Fighter <OBJECT>
		1: _tgt - Target <OBJECT>
	 
	Returns: 
		Float positive means left hemisphere, negative right ~
	 
	Example: 
		(begin example) 
		onEachFrame {hintSilent str round ([player, unlucky] call AK_fnc_getAA)};
		(end) 
	
	Author: 
		AK 
	 
---------------------------------------------------------------------------- */ 
AK_fnc_getAA = {
	params ["_fighter", "_tgt"];
	_tgtHDG = getDir _tgt;
	_bearing = _tgt getDir _fighter;
	_clockwiseAngle = (_bearing + 360 - _tgtHDG) % 360;
	_Aangle = _clockwiseAngle - 180;
	_Aangle
};
/*
 * Function: AK_fnc_graveDigger
 * Description: Replaces all dead men with graves at their respective positions and orientations.
 * Parameters: None
 * Returns: None
 * Author: Your Name
 * Example:
 *   [] remoteExec ["AK_fnc_graveDigger", 2]; 
 */
AK_fnc_graveDigger = {
	{
		private _grave = ("ACE_Grave" createVehicle getPos _x);
		_grave setDir (getDir _x);
		deleteVehicle _x;
	} forEach allDeadMen;
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
};AK_fnc_listHCs = {
	_collectedUserInfo = [];
	{
		_collectedUserInfo pushBack (getUserInfo _x)
	} forEach allUsers;

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
		["_side", west, [west]], // east, west, resistance
		["_AZ", [500, 500, 0], [[]]],
		["_pltstrength", 40, [0]],
		["_maxveh", 0, [0]]
	];

	private ["_cfgFaction", "_numberOfUnits", "_timeout", "_spawnedgroups", "_vfgrm", "_facing"];

	if (isNil "AK_var_fnc_moveRandomPlatoons_factiontables") then {
		// populate faction tables 
		_sides = [0, 1, 2];
		AK_var_fnc_moveRandomPlatoons_factiontables = [];
		{
			AK_var_fnc_moveRandomPlatoons_factiontables pushBack ([_x] call AK_fnc_cfgFactionTable)
		} forEach _sides;
		// populate group tables 
		AK_var_fnc_moveRandomPlatoons_GroupTables = [];
		{
			AK_var_fnc_moveRandomPlatoons_GroupTables pushBack [];
			_workingTable = AK_var_fnc_moveRandomPlatoons_GroupTables select _x;
			{
				{
					_workingTable pushBack ([_x] call AK_fnc_cfgGroupTable)
				} forEach _x
			} forEach [AK_var_fnc_moveRandomPlatoons_factiontables select _x];
		} forEach _sides;
	};
	// debug
	   // diag_log format ['Hello I am the server executing AK_fnc_moveRandomPlatoons and these are my variables: %1', _this];

	_cfgFaction = str text (selectRandom (AK_var_fnc_moveRandomPlatoons_factiontables select _cfgSide));
	_numberOfUnits = 0;
	_timeout = 0;
	_spawnedgroups = [];
	_vfgrm = _AZ vectorAdd [random [-1500, 0, 1500], random [-1500, 0, 1500], 0];
	_facing = _vfgrm getDir _AZ;

	while { _numberOfUnits < _pltstrength && _timeout < (_pltstrength +1) } do {
		_cfggroup = selectRandom (AK_var_fnc_moveRandomPlatoons_GroupTables select _cfgSide select ((AK_var_fnc_moveRandomPlatoons_factiontables select _cfgSide) findIf {
			_x == _cfgFaction
		}));
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
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_populateMap

Description:
    Populate the map with lots of groups
	
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
		["_referencePosition", [0, 0, 0], [[]]],
		["_areaSideLength", worldSize, [0]],
		["_spacing", true],
		["_groupType", configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [configFile, ""]],
		["_side", east, [east]],
		["_numberOfGroups", 128, [0]], // this is just used to calculate the spacing
		["_landOnly", true, [false]],
		["_serverOnly", true, [false]]
	];

	if (_serverOnly == true and isServer == false) exitWith {
		hint "AK_fnc_populateMap parameters are set to spawn on server only.";
	};

	_random = false;
	if ((typeName _groupType == typeName "") and {
		_groupType == "random"
	}) then {
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
	while { _y < _areaSideLength } do {
		while { _x < _areaSideLength } do {
			if (({
				side _x == _side
			} count allGroups) >= 288) exitWith {
				[_referencePosition, _areaSideLength, _spacing, _groupType, _side, _numberOfGroups, _groupCounter];
			};
			_spawnPosition = _referencePosition vectorAdd [_x, _y, 0];
			if ((_landOnly == true) and {
				surfaceIsWater _spawnPosition == true
			}) then {
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
AK_fnc_quickAirBattle = {  
 /* ----------------------------------------------------------------------------  
 Function: AK_fnc_quickAirBattle  
  
 Description:  
  Quickly set-up a large air battle  
    
 Parameters:  
  ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "GefechtsstreifenBreite"]  
 Returns:  
  NIL  
  
 Example:  
  (begin example)  
   [curatorSelected, true, 12, 12, worldSize] remoteExec ["AK_fnc_quickAirBattle", 2];      
  (end)  
  
 Author:  
  AK  
  
---------------------------------------------------------------------------- */  
 // HEADSUP if you select vehicles on the map you get the groups, if you select them in 3D than you get all units (including each crewmember)  
// ENHANCE defaults for params  
     // assumes that all attackers and defenders each share the same side   
 params ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_gefechtsstreifenBreite"]; // pass two arrays of vehicles seperated in space (eg by curatorSelected)  
 _angreiferFahrzeugAbstand = _gefechtsstreifenBreite / _angreiferAnzahl;  
 _verteidigerFahrzeugAbstand = _gefechtsstreifenBreite / _verteidigerAnzahl;  
  
 _SelectedEntities = _selection select 0;  
 _SelectedGroups = _selection select 1;  
 _parties = [_SelectedEntities] call AK_fnc_GroupbyDistance;  
 _partyA = (_parties select 0);  
 _partyB = (_parties select 1);  
  
 referenceAttacker = _partyA select 0;  
 referenceDefender = _partyB select 0;  
 _angreiferSpawnPosAnchor = getPos referenceAttacker;  
 _angriffsZiel = getPos referenceDefender;  
 _typleListAttackers = [_partyA apply {typeOf _x}, _angreiferAnzahl] call AK_fnc_TypeRatio;  
 _typleListDefenders = [_partyB apply {typeOf _x}, _verteidigerAnzahl] call AK_fnc_TypeRatio;  
 _angreiferSide = side referenceAttacker;  
 _verteidigerSide = side referenceDefender;  
  
 // delete the placeholders   
 [_SelectedEntities, _SelectedGroups] call CBA_fnc_deleteEntity; // remove the "parameters" intentionally not deleting waypoints and markers  
  
 // mark Positions   
 "SmokeShellBlue" createVehicle _angreiferSpawnPosAnchor;  
 "SmokeShellRed" createVehicle _angriffsZiel;  
  
 // general parameters derived from "parameter" units  
 _angriffsRichtung = _angreiferSpawnPosAnchor getDir _angriffsZiel;  
 _wrongVector = [[0, 1, 0], _angriffsRichtung] call BIS_fnc_rotateVector2D;  
 _angriffsRichtungVector = [(_wrongVector select 0) * -1, _wrongVector select 1, 0];  
 _angriffsDistanz = (_angreiferSpawnPosAnchor distance _angriffsZiel) + 1000; // Naechste Aufgabe Kompanie  
 _verteidigerRichtung = _angriffsZiel getDir _angreiferSpawnPosAnchor;  
 _verteidigerRichtungVector = [_angriffsRichtungVector, 180] call BIS_fnc_rotateVector2D;
 
    // redefine Angriffsziel before spawning
    _partyBSpawnPosAnchor = _angriffsZiel;
    _angriffsZiel = [worldSize / 2, worldSize / 2, 0];
      
  
    // spawn party A  
 [  
  {  
   isNull referenceAttacker  
  },  
  {  
   referenceAttacker = nil;  
   _this call AK_fnc_Airattack;  
  },  
  [_angreiferSpawnPosAnchor, _angriffsRichtungVector, _angriffsRichtung, _typleListAttackers, _angreiferSide, _angreiferAnzahl, _angriffsDistanz, _angreiferFahrzeugAbstand, _gefechtsstreifenBreite, _angriffsZiel, true, true]  
 ] call CBA_fnc_waitUntilAndExecute;  
  
    // spawn party B  
  
 [  
  {  
   isNull referenceDefender  
  },  
  {  
   referenceDefender = nil;  
   _this call AK_fnc_Airattack;  
  },  
  [_partyBSpawnPosAnchor, _verteidigerRichtungVector, _verteidigerRichtung, _typleListDefenders, _verteidigerSide, _verteidigerAnzahl, _angriffsDistanz, _verteidigerFahrzeugAbstand, _gefechtsstreifenBreite, _angriffsZiel, true, true]  
 ] call CBA_fnc_waitUntilAndExecute;  
};AK_fnc_quickBattle = {
	/* ----------------------------------------------------------------------------
	Function: AK_fnc_quickBattle

	Description:
		Quickly set-up a large battle
		
	Parameters:
		["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_angreiferGefechtsstreifenBreite", "_verteidigerGefechtsstreifenBreite"]
	Returns:
		NIL

	Example:
		(begin example)
			[curatorSelected, true, 44, 10, 1000, 1000] spawn AK_fnc_quickBattle;    
		(end)

	Author:
		AK

---------------------------------------------------------------------------- */
	// HEADSUP if you select vehicles on the map you get the groups, if you select them in 3D than you get all units (including each crewmember)
	   // ENHANCE how to determine attacker side? currently I use an empty vehicle
	   // ENHANCE defaults for params
	    // assumes that all attackers and defenders each share the same side 
	    params ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_angreiferGefechtsstreifenBreite", "_verteidigerGefechtsstreifenBreite"]; // pass two arrays of vehicles seperated in space (eg by curatorSelected)
	_angreiferFahrzeugAbstand = 100;

	_verteidigerFahrzeugAbstand = 100;

	_SelectedEntities = _selection select 0;
	_SelectedGroups = _selection select 1;
	_parties = [_SelectedEntities] call AK_fnc_GroupbyDistance;
	_initialPartyA = (_parties select 0);
	_initialPartyB = (_parties select 1);

	    // determine type of battle
	_battleType = "eil_bez_Verteidigung";
	_rawAttackers = false;
	_rawDefenders = false;
	_civInA = civilian in (_initialPartyA apply {
		side _x
	});
	_civInB = civilian in (_initialPartyB apply {
		side _x
	});
	if (!_civInA and !_civInB) then {
		_battleType = "Begegnungsgefecht";
	} else {
		if (_civInA) then {
			_rawAttackers = _initialPartyA;
			_rawDefenders = _initialPartyB
		} else {
			_rawAttackers = _initialPartyB;
			_rawDefenders = _initialPartyA
		};
		 _rawAttackers deleteAt ((_rawAttackers apply {
			side _x
		}) find civilian); // remove the attacker "marker"
	};
	if (_battleType == "Begegnungsgefecht") exitWith {
		diag_log "ERROR AK_fnc_quickBattle: Begegnungsgefecht not yet implemented."
	};
	if (_debug) then {
		diag_log format ['Type of battle determined. %1', [_battleType, _rawAttackers, _rawDefenders]]
	};

	referenceAttacker = _rawAttackers select 0;
	referenceDefender = _rawDefenders select 0;
	_angreiferSpawnPosAnchor = getPos referenceAttacker;
	_angriffsZiel = getPos referenceDefender;
	_typleListAttackers = [_rawAttackers apply {
		typeOf _x
	}, _angreiferAnzahl] call AK_fnc_TypeRatio;
	_typleListDefenders = [_rawDefenders apply {
		typeOf _x
	}, _verteidigerAnzahl] call AK_fnc_TypeRatio;
	_angreiferSide = side referenceAttacker;
	_verteidigerSide = side referenceDefender;
	    // delete the placeholders 
	    [_SelectedEntities, _SelectedGroups] call CBA_fnc_deleteEntity; // remove the "parameters" intentionally not deleting waypoints and markers

	    // mark Positions 
	"SmokeShellBlue" createVehicle _angreiferSpawnPosAnchor;
	"SmokeShellRed" createVehicle _angriffsZiel;

	   // general parameters derived from "parameter" units
	_angriffsRichtung = _angreiferSpawnPosAnchor getDir _angriffsZiel;
	_wrongVector = [[0, 1, 0], _angriffsRichtung] call BIS_fnc_rotateVector2D;
	_angriffsRichtungVector = [(_wrongVector select 0) * -1, _wrongVector select 1, 0];
	    _angriffsDistanz = (_angreiferSpawnPosAnchor distance _angriffsZiel) + 1000; // Naechste Aufgabe Kompanie
	    _linieSturmAngriff = _angriffsDistanz - 2000; // 500 bis 1500 m
	_verteidigerRichtung = _angriffsZiel getDir _angreiferSpawnPosAnchor;
	_verteidigerRichtungVector = [_angriffsRichtungVector, 180] call BIS_fnc_rotateVector2D;

	   // spawn attackers
	[
		{
			isNull referenceAttacker
		},
		{
			referenceAttacker = nil;
			_this call AK_fnc_attack;
		},
		[_angreiferSpawnPosAnchor, _angriffsRichtungVector, _angriffsRichtung, _typleListAttackers, _angreiferSide, _angreiferAnzahl, _angriffsDistanz, _angreiferFahrzeugAbstand, _angreiferGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, true, true]
	] call CBA_fnc_waitUntilAndExecute;

	   // spawn defenders

	[
		{
			isNull referenceDefender
		},
		{
			referenceDefender = nil;
			_this call AK_fnc_attack;
		},
		[_angriffsZiel, _verteidigerRichtungVector, _verteidigerRichtung, _typleListDefenders, _verteidigerSide, _verteidigerAnzahl, _angriffsDistanz, _verteidigerFahrzeugAbstand, _verteidigerGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, false, true]
	] call CBA_fnc_waitUntilAndExecute;
};/* Sets random weather */
AK_fnc_randomWeather = {
    if (!isServer) exitWith {
        systemChat "ERROR: has to be executed on the server."
    };
        0 setOvercast random 1; 
        0 setRain random 1; 
        0 setFog [random 1, random [-1, 0, 1], random [-5000, 0, 5000]];
        setWind [random [0, 3, 100], random [0, 3, 100], true];
        forceWeatherChange;
};/*
 * Function: AK_fnc_removeTrees
 * Description: Reduces the number of trees on the entire map by hiding or cutting them down based on the given thresholds.
 * Parameters:
 *   0: NUMBER - Hide Threshold (default: 10)
 *   1: NUMBER - Cut Threshold (default: 90)
 * Returns: None
 * Author: AK
 * Example:
 *   [{[10, 90] spawn AK_fnc_removeTrees;}] remoteExec ["call", 0, "AK_fnc_removeTrees"];
 */
AK_fnc_removeTrees = {
	params [
		["_hideThreshold", 10, [0]],
		["_cutThreshold", 90, [0]]
	];
	_startTime = diag_tickTime;
	_cutCounter = 0;
	_trees = nearestTerrainObjects [[worldSize / 2, worldSize / 2, 0], ["Tree"], worldSize, false];

	[format ["%1 s: %2 trees found", diag_tickTime - _startTime, count _trees]] remoteExec ["systemChat", 0];
	{
		if (_forEachIndex random 100 > _hidethreshold) then {
			hideObject _x;
		} else {
			if ((_forEachIndex + 1) random 100 > _cutThreshold) then {
				_x setDamage 1;
				_cutCounter = _cutCounter + 1;
			};
		};
	} forEach _trees;
	[format ["%1 s: Finished processing %2 trees. %3 have been cut.", diag_tickTime - _startTime, count _trees, _cutCounter]] remoteExec ["systemChat", 0];
};
AK_fnc_setWindFromString = {
/* 
    Description: 
        Parses a wind string in the format "DIRECTION@MAGNITUDE", 
        inverts the direction, converts magnitude from km/h to m/s, 
        and sets the wind using setWind. 
 
    Parameters: 
        0: STRING - Wind string, e.g. "270@20" 
 
    Example: 
        ["270@20"] call fnc_setWindFromString;
    
    Enhance:
        Convert MPS
        Translate Gusts 
*/ 
 
 
    if (isServer == false) then {diag_log "WARNING: AK_fnc_setWindFromString: The effect is global only if it is executed on the server. Wind set locally will sync back to server value in a while."};
    params ["_wind"]; 
 
    private _windarray = _wind splitString "@"; 
    private _windDir = parseNumber (_windarray select 0); 
    private _windMagnitude = parseNumber (_windarray select 1); 
 
    // Invert direction 
    _windDir = (_windDir - 180) call CBA_fnc_simplifyAngle; 
 
    // Convert magnitude to m/s 
    _windMagnitude = _windMagnitude / 1.852; 
 
    private _xValue = (sin _windDir) * _windMagnitude; 
    private _yValue = (cos _windDir) * _windMagnitude; 
 
    setWind [_xValue, _yValue, true]; 
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

	// get the current position of the group 
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

	// spawn  
	{
		_spawned = ([(_spawnpos vectorAdd [_xPos, _yPos, 0]), (_spawnpos getDir _destpos/* This fails when the _destpos is no coordinate*/), _x, _side] call BIS_fnc_spawnVehicle);
			_spawnedvehicles pushBack (_spawned select 0);
			{
				_spawnedunits pushBack _x
			} forEach (_spawned select 1); 
			_spawnedgroups pushBack (_spawned select 2); 
			    _yPos = _yPos + _spacing;   
			   
			if (_yPos > _breitegefstr) then {
				_yPos = 0;   
				        _xPos = _xPos + _spacing;
			};
		} forEach _typeList;  
		  
	// group into platoons if requested  
		if (_platoonsize > 1) then {
			private _nbrplatoons = floor ((count _spawnedgroups) / _platoonsize);  
			private _a = 0;
			private _b = (_platoonsize -1);
			for "_x" from 1 to _nbrplatoons do {
				private _joiners = _spawnedgroups select [_a, _b];
				{
					(units _x) join (_spawnedgroups select (_b + _a));
				} forEach _joiners;
				_spawnedgroups deleteRange [_a, _b];
				_a = _a +1;
			};
		};  
	// assign waypoints etc  
		_xPos = 0;   
		_yPos = 0;  
		_spacing = _spacing * _platoonsize;  
		{
			_x setBehaviour _behaviour;  
			_x deleteGroupWhenEmpty true;
			if !(count _destpos == 0) then {
				_x addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
				_x addWaypoint [getPos leader _x, 10];
				_waypoint = _x addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
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
AK_fnc_spawnBasecamp = {
	params ["_firePos", "_arsenalPos"];
	"Campfire_burning_F" createVehicle _firePos;
	// add container 
	private _container = "B_Slingload_01_Ammo_F" createVehicle _arsenalPos;
	[_container, true] call ace_arsenal_fnc_initBox;
	_lantern = createVehicle ["Lantern_01_Black_F", getPos _container, [], 0, "CAN_COLLIDE"];
	_lantern attachTo [_container, [0, 0, 1.5]];
};
/* ----------------------------------------------------------------------------
Function: AK_fnc_storeFPS

Description:
    Stores current FPS in a public Variable if it's lower than the current value
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
	if !((isNil "_var") or (_fps < _var)) exitWith {};// skip if fps are higher than current value
	AK_var_MinFPS = _fps;
	publicVariable "AK_var_MinFPS";
};
/* Collect positional and matadata of projectiles  
	ENHANCE
	 make data JSON conformal 
	 add aim error by defining an aimpoint 
	HEADSUP 
	 the impact analysis currently works with scopes (as the sway  of other sights will not move the camera or change eyePos) 
	 the impact analysis currently works with flat surfaces that are perpendicular to the shooter and stop the bullet 
	 after attachTo the impact marker is not reliable 
	BUGS 
	 _shotDistance is unreliable, due to ricochets and the projectile beeing deleted  
	 left right calculation doesn't work properly (didn't work when shooting at a heading of 066Â°) 
	 _firerPos is not consistant with where the bullet actually spawns
	 the impact marker is not precise 
	REQUIRES  
	  (vehicle player) addEventHandler ["Fired", {
		[_this, 
			  [  
			   diag_tickTime, // shotTime  
			   getPosASL (_this select 6), // shooter position  
			   velocity (_this select 6) // V0  
			  ]  
		 ] spawn AK_fnc_traceProjectile;
	}]; 
*/ 
AK_fnc_traceProjectile = {
	AK_switch_traceProjectileDebug = true;
	(_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	(_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];

	_posData = [_firerPos];
	_timeStamps = [0];
	_velocityData = [_muzzleVelocity];
	_firedMessage = format ['{
		"Function": "AK_fnc_ballisticData", "Event Handler": "Fired", "Shooter":"%1", "Shooter Type":"%2", "Shooter Position":%3, "Shooter Velocity":%4, "Projectile":"%5", "Muzzle Velocity":%6, "Weapon":"%7", "Ammo":"%8", "Shooter Side":"%9", "tickTime": %10
	}', _gunner, typeOf _unit, getPosASL _gunner, velocity _unit, _projectile, _muzzleVelocity, _weapon, _ammo, side _gunner, _shotTime];
	diag_log _firedMessage;
	if (AK_switch_traceProjectileDebug == true) then {
		systemChat _firedMessage;
	};
	   _dataLogResolution = 0.0055; // s of delay between data points  HEADSUP values below ~ 0.005 will cause a very high number of duplicates  
	   _aimPosInWorld = AGLToASL positionCameraToWorld [0, 0, 0]; // player required! 

	_ins = lineIntersectsSurfaces [
		_aimPosInWorld,
		   AGLToASL positionCameraToWorld [0, 0, 5000], // "Hardcoded max distance: 5000m." player required! 
		player,
		objNull,
		true,
		1,
		"GEOM",
		"NONE"
	];
	_initialTarget = objNull;
	if (count _ins != 0) then {
		_initialTarget = _ins select 0 select 2; // does not work when not aiming directly at the target   
		if (AK_switch_traceProjectileDebug == true) then {
			hintSilent format ['%1 is the Initial Target', _initialTarget];
		};
	};
	_metaData = [_weapon, _muzzle, _mode, _ammo, _magazine, str(_projectile)];
	   _metaData pushBack (player weaponDirection (currentWeapon player)); // 'weaponDirection' 
	{
		_metaData pushBack (getNumber (configFile >> "CfgAmmo" >> _ammo >> _x))
	} forEach ["ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"];// "ACE_bulletMass", "ACE_bulletLength", "ACE_caliber"] 
	   _metaData pushBack (getArray (configFile >> "CfgAmmo" >> _ammo >> "ACE_ballisticCoefficients"));// "ACE_ballisticCoefficients" 
	   _metaData pushBack (getText (configFile >> "CfgWeapons" >> _weapon >> "displayName"));// "weapon_displayName" 
	   _metaData pushBack getPosASL _initialTarget; // 'targetPos' 
	   _metaData pushBack _firerPos; // 'firerPos' 
	  // _initialTarget;// (AGLToASL screenToWorld [0.5, 0.5]);  
	  // systemChat str _metaData; 

	while { isNull _projectile == false } do {
		_bulletVelocity = (velocity _projectile);
		_bulletPosASL = (getPosASL _projectile);
		_posData pushBack _bulletPosASL;
		_timeStamps pushBack diag_tickTime - _shotTime;
		_velocityData pushBack _bulletVelocity;
		 // hintSilent str (_bulletVelocity call CBA_fnc_vectMagn);  
		uiSleep _dataLogResolution;
	};
	_bulletTravelTime = (_timeStamps select (count _timeStamps - 1));
	_shotDistance = _firerPos distance (_posData select (count _posData - 1));
	_impactPos = _posData select (count _posData - 1);
	_offTarget = 'no data';
	_rightLeftOffTarget = 'no data';
	if (count _ins > 0) then {
		_offTarget = _ins select 0 select 0 distance _impactPos;
		_rightLeftOffTarget = [_ins select 0 select 0, _impactPos] call BIS_fnc_distance2D;
		_aimPos = _ins select 0 select 2;
		_ShooterAimAngle = _firerPos getDir _aimPos;
		_normalizedShooterImpactAngle = (_firerPos getDir _impactPos) - _ShooterAimAngle;
		if (_normalizedShooterImpactAngle < 0) then {
			_normalizedShooterImpactAngle = _normalizedShooterImpactAngle + 360;
		};
		if (_normalizedShooterImpactAngle > 180) then {
			_rightLeftOffTarget = _rightLeftOffTarget * -1; // right are positive values, left negative
		};
		if (AK_switch_traceProjectileDebug == true) then {
			systemChat format ['%1 s, %2 m, %3 m off target %4, %5 m off side', _bulletTravelTime, _shotDistance, _offTarget, _initialTarget, _rightLeftOffTarget];
		};
		 // systemChat format ["%1Â° _normalizedShooterImpactAngle. %2Â° _ShooterAimAngle. %3 ShooterImpactAngle. %4 distance _firerPos pos player", _normalizedShooterImpactAngle, _ShooterAimAngle, 
		  // (_firerPos getDir (_posData select (count _posData - 1))), vectorMagnitude (getPosASL player vectorDiff _firerPos)];
	} else {
		systemChat format ["%1 s, %2 m", _bulletTravelTime, _shotDistance];
	};
	if (AK_switch_traceProjectileDebug == true) then {
		_marker = "Sign_arrow_F" createVehicle [0, 0, 0];// "Sign_Sphere10cm_F"  
		_marker setPos ASLToAGL _impactPos;
		_marker setVectorUp (_velocityData select (count _velocityData - 1));
	};
	_impactData = [_bulletTravelTime, _shotDistance, _offTarget, _rightLeftOffTarget];
	if (isNil "AK_var_traceProjectileData") then {
		AK_var_traceProjectileData = []
	};
	AK_var_traceProjectileData pushBack [_metaData, _timeStamps, _posData, _velocityData, _impactData];
};AK_fnc_transferAItoServer = {
	[{
		_transferCounter = 0;
		{
			if (groupOwner _x != 2) then {
				_x setGroupOwner 2;
				_transferCounter = _transferCounter + 1;
			};
		} forEach (allGroups select {
			!isPlayer (leader _x)
		});
		[format ["%1 groups have been transfered to the server.", _transferCounter]] remoteExec ['hint', 0];
	_transferCounter
	}] remoteExec ['call', 2];
};/* ----------------------------------------------------------------------------
Function: AK_fnc_TypeRatio

Description:
    Returns an array of strings with X elements preserving the ratio. (Intended for unit types but will work with all strings)
	It works on a first in first out base meaning that [["BMP2", "T72"], 3] will result in ["BMP2", "T72", "BMP2"]

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
	while { count _res < _numberOfUnits } do {
		{
			if (count _res >= _numberOfUnits) then {
				break;
			};
			_res pushBack _x;
		} forEach _unitTypes;
	};
	_res
};
AK_fnc_updateWeatherfromFile = {
    /*
    Reads weather data from a file and sets it in-game using the ZEN EH. 
    By updating the source file externally and running this function in regular intervals, it's possible to simulate "live" weather 
    Prerequisites 
        CBA 
        ZEN 
    */
    
    private _debug = true;
    
    if !(isServer) exitWith {diag_log "ERROR: AK_fnc_updateWeatherfromFile: Only the server should run this."};
     
    private _path = "\@AK_weatherdata\" + (['_weatherdata.sqf'] call AK_fnc_createWeatherFilename); 
    private _forced = false; 
    
    if !(fileExists _path) exitWith { diag_log format ["ERROR: AK_fnc_updateWeatherfromFile: AK_fnc_updateWeatherfromFile: File (%1) does not exist!", _path]; ["ERROR: updateWeatherFromFile: File not found."] remoteExec ["hint", 0];};
    private _weatherdata = call ([preprocessFile _path] call CBA_fnc_convertStringCode);
    _weatherdata params ["_worldName", "_windX", "_windY", "_gustX", "_gustY", "_visibility", "_overcast", "_fog", "_fogAltitude", "_rain", "_precipitationType", "_lightning"]; 
    if (worldName != _worldName) then {diag_log format ["WARNING: AK_fnc_updateWeatherfromFile: worldName in %1 does not match %2. Wrong weather data might be present.", _path, worldNAme]}; 
    private _wind = [_windX, _windY, true];
    _rainbow = 0;
    _waves = 0;
    _gusts = 0;
    
    [_visibility] remoteExec ["setViewDistance", 0, "viewDistance"];
    [_visibility] remoteExec ["setObjectViewDistance", 0, "getObjectViewDistance"];
    [5000^2 / (5000/_visibility * _visibility^2)] remoteExec ["setTerrainGrid", 0, "terrainGrid"];
    
    if (_fogAltitude != 0) then { // _fogAltitude != 0 triggers the creation of a virtual ceiling using fog with negative decay
        private _mapHeight = getNumber (configFile >> "CfgWorlds" >> worldName >> "minHillsAltitude"); // defaults to 0 if minHilssAltitude is not set
        0 setFog [fog, -1 * (50 / (_fogAltitude + _mapHeight)), _fogAltitude + _mapHeight]; // the required decay value depends on the fog altitude
    } else { 0 setFog [fog, 0.1, 0];}; 
    
    ["ZEN_changeWeather", [_forced, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, _wind, _gusts, _fog]] call CBA_fnc_globalEvent;
    [str (["visibility", 'overcast', 'rain', 'precipitationType', 'lightning', 'rainbow', 'waves', 'wind', 'gusts', 'fog', "_fogAltitude"] createHashMapFromArray 
    [_visibility, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, [_windX, _windY] call BIS_fnc_magnitude, _gusts, _fog, _fogAltitude])] remoteExec ["hint", 0]; 
     
}; 
/* ---------------------------------------------------------------------------- 
Function: AK_fnc_weaponTest 
Description: 
 Beschuss Tests 
 
Parameters: 
 NIL 
 
Returns: 
 NIL 
 
Examples: 
 (begin example) 
  [{ 
   if ((isNil "AK_testRunning") or {AK_testRunning == false}) then { 
    AK_testRunning = true; 
    [] spawn AK_fnc_weaponTest; 
   }; 
  }, 5, []] call CBA_fnc_addPerFrameHandler; 
 (end) 
 
Author: 
 AK 
---------------------------------------------------------------------------- */ 
//BUG creeping memory issue (could not be solved by removing recursive calls)  
//ENHANCE limit the cleanup to the function 
//ENHANCE Create a TgtPool and select Pseudo-randomly from the pool 
 
AK_fnc_weaponTest = { 
 _spacing = 10; 
 _vehicleCount = 20; 
 _anchorPos = [1000, 1000, 0];//[23000, 18000, 0]; //Altis Almyra saltlake 
 _shooting_distance = 300; 
 _shooterCount = 10; 
 _shooter_heading = 090; 
 _shooterType = "rhsusf_army_ucp_maaws"; 
 _shooterSide = west; 
 _shooterWeapon = "rhs_weap_maaws"; 
 _shooterAmmo = "rhs_mag_maaws_HEAT"; 
 _shooterAmmoSpare = 5; 
 _TgtAspect = 180; // 1 to 179 means shooters are facing the right side, -1 to -179 left side 
 _TgtType = selectRandom (("configName _x isKindOf 'tank' and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles")) apply {(configName _x)}); 
 _mannedTargets = true; 
 _tgtSide = east; 
 0 setFog 0;  
 0 setRain 0; 
 setDate [1986, 2, 25, 12, 0]; 
  
 _timeLimit = 20 * _shooterAmmoSpare; 
 _firstTgtPos = (_anchorPos getPos [_shooting_distance, _shooter_heading]) getPos [(_vehicleCount / 2) * _spacing, (_shooter_heading - 90) % 360]; // center the tgt line at player pos 
 _spacingHDG = (_shooter_heading + 90) % 360; 
 _TgtHDG = (_shooter_heading + _TgtAspect) % 360; 
 _firstShooterPos = _anchorPos getPos [(_shooterCount / 2) * _spacing, (_shooter_heading - 90) % 360]; // center the shooter line at player pos 
 _shooterGroup = createGroup _shooterSide; 
 _shooterGroup allowFleeing 0; 
 _shooterGroup deleteGroupWhenEmpty true; 
 _targetList = []; 
 _targetGroups = []; 
 _targetCrewmen = []; 
 for "_i" from 1 to _vehicleCount do { 
  // create TGT 
  _spawnPos = _firstTgtPos getPos [_spacing * _i, _spacingHDG]; 
  _vehicle = _TgtType createVehicle _spawnPos; 
  _vehicle setDir _TgtHDG; 
  _vehicle setFuel 0; 
  _targetList pushBack _vehicle; 
  if (_mannedTargets == true) then { 
   _group = _tgtSide createVehicleCrew _vehicle; 
   _group setCombatMode "BLUE"; 
   _group deleteGroupWhenEmpty true; 
   _vehicle allowCrewInImmobile true; 
   _targetGroups pushBack _group; 
   {_targetCrewmen pushBack _x} forEach (units _group); 
  }; 
  
  // create Shooter 
  if (_i > (_shooterCount)) then {continue}; 
  _spawnPos = _firstShooterPos getPos [_spacing * _i, _spacingHDG]; 
  _vehicle = _shooterGroup createUnit [_shooterType, _spawnPos, [], 0, "NONE"]; 
  _vehicle setDir _shooter_heading; 
  doStop _vehicle; 
  [_vehicle, [[[],[_shooterWeapon,"","","rhs_optic_maaws",[_shooterAmmo,1],[],""],[],[],[],["B_Bergen_mcamo_F",[[_shooterAmmo,_shooterAmmoSpare,1]]],"H_Cap_oli_hs","",[],["","","","","",""]],[]]] call CBA_fnc_setLoadout; 
 }; 
  
 if (((count (_targetList select {!isNull _x})) == _vehicleCount) and ((count ((units _shooterGroup) select {!isNull _x})) == _shooterCount)) then { //check if tgts and shooters have been created 
  // Reporting 
  _questionAllProne = { 
   // uses the shooters going prone when out of ammo and in the presence of enemies. 
   params ["_group"]; 
   ({stance _x == "PRONE"} count (units _group) == count (units _group)) 
  }; 
  
  _start_time = time; 
  [format ["%1 %2 created.", count _targetList, _TgtType]] remoteExec ["systemChat", 0]; 
  if (_mannedTargets == true) then {[format ["%1 crewmen created.", count _targetCrewmen]] remoteExec ["systemChat", 0]};  
  while {(time <= (_start_time + _timeLimit)) and ((_shooterGroup call _questionAllProne) == false)} do { 
   [format ["%1 %2 destroyed. %3 s.", {!alive _x} count _targetList, _TgtType, time - _start_time]] remoteExec ["systemChat", 0]; 
   {_shooterGroup reveal _x} forEach _targetList; 
   sleep 10; 
  }; 
  sleep 20; //to allow for delayed destruction. 
  _destroyedVehicles = {!alive _x} count _targetList; 
  [format ["Final result: %1 %2 destroyed.", _destroyedVehicles, _TgtType]] remoteExec ["systemChat", 0]; 
  if (_mannedTargets == true) then {[format ["%1 crewmen killed.", {!alive _x} count _targetCrewmen]] remoteExec ["systemChat", 0]}; 
  // has a vital HitPoint been destroyed 
  _damageByTarget = []; 
  {  
   _criticalHitPointStatus = []; 
   _unit = _x; 
     { 
      _criticalHitPointStatus pushBack (floor (_unit getHitPointDamage _x)) 
   } forEach ["hithull","hitltrack","hitrtrack","hitengine","hitturret","hitgun"]; 
   _damageByTarget pushBack _criticalHitPointStatus; 
  } forEach _targetList; 
    
  //logging 
  private _resultCache = createHashMap; 
  _resultCache set ["Function", "AK_fnc_weaponTest"];  
  _resultCache set ["systemTimeUTC", systemTimeUTC];  
  _resultCache set ["anchorPos", _anchorPos];  
  _resultCache set ["spacing", _spacing];  
  _resultCache set ["shooting_distance", _shooting_distance];   
  _resultCache set ["shooter_heading", _shooter_heading];  
  _resultCache set ["shooterCount", _shooterCount];  
  _resultCache set ["shooterWeapon", _shooterWeapon];  
  _resultCache set ["shooterAmmo", _shooterAmmo];  
  _resultCache set ["vehicleCount", _vehicleCount];  
  _resultCache set ["TgtType", _TgtType];  
  _resultCache set ["TgtAspect", _TgtAspect];  
  _resultCache set ["mannedTargets", _mannedTargets];  
  _resultCache set ["destroyedVehicles", _destroyedVehicles]; 
  _resultCache set ["damageByTargetHullLtrackRtrackEngineTurretGun", _damageByTarget]; 
  _resultCache set ["KilledShooters", (_shooterCount - ({alive _x} count (units _shooterGroup)))];  
  if (_mannedTargets == true) then { 
   _resultCache set ["killedCrewmen", ({!alive _x} count _targetCrewmen)]; 
   _resultCache set ["createdCrewmen", (count _targetCrewmen)]; 
  }; 
  [toJSON _resultCache, "AK_fnc_weaponTest trial summary"] call CBA_fnc_debug; 
   
 } else {diag_log "WARNING AK_fnc_weaponTest: target or shooter count missmatch. Check if all targets and shooters have been created properly."}; 
 //cleanup 
 {deleteVehicle _x} forEach allUnits; 
 {deleteVehicle _x} forEach allDead; 
 {deleteVehicle _x} forEach vehicles; 
 AK_testRunning = false;    
}; 
