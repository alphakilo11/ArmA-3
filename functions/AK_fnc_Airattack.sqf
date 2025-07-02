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
};