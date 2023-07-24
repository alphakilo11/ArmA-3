AK_fnc_ZeusQuickBattle = { 
    _selectedUnits = curatorSelected "Curator";
    {
        params ["_vehicle1", "_vehicle2", "_type", "_attackers", "_defenders"];
        _vehicle1Type = typeOf _vehicle1;
        _vehicle2Type = typeOf _vehicle2;
        _vehicle1group = [_vehicle1, EAST, _attackers] call BIS_fnc_spawnGroup;
        _vehicle2group = [_vehicle2, WEST, _defenders] call BIS_fnc_spawnGroup;
        if (_type == "attack") then {
            [_vehicle1group, _vehicle2 getPosition _vehicle2, _attackers, _defenders] call CBA_fnc_taskAttack;
        } else {
            [_vehicle2group, _vehicle1 getPosition _vehicle1, _defenders] call CBA_fnc_taskDefend;
        };
    } forEach _selectedUnits;
};
