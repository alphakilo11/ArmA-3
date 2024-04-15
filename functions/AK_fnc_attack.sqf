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
