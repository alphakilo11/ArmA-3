//Current Weather display
onEachFrame {hintSilent str createHashMapFromArray [
    ["Wind (kt)", format ["%1@%2", round (windDir - 180) call CBA_fnc_simplifyAngle, round ((vectorMagnitude wind) * 1.852)]],
    ["Clouds", format ["%1 %%", round(overcast * 100)]],
    ["Lightning", format ["%1 %%", round(lightnings * 100)]],
    ["Rain", format ["%1 %%", round(rain * 100)]],
    ["Fog", str fogParams]
]};


// wind logging
[] spawn {
    AK_toggle_windLogging = true;
    private _currentWind = wind;
    AK_windLog = [[round (windDir - 180) call CBA_fnc_simplifyAngle, round ((vectorMagnitude wind) * 1.852)]];
    while {AK_toggle_windLogging == true} do {
        _newWind = wind;
        if ([_currentWind, _newWind] call BIS_fnc_arrayCompare == false) then {
            AK_windLog pushBack [round (windDir - 180) call CBA_fnc_simplifyAngle, round ((vectorMagnitude wind) * 1.852)];
            _currentWind = _newWind;
        sleep 5;
        };
    };
};