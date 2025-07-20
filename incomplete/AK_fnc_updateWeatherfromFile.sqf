AK_fnc_updateWeatherfromFile = {
    /* Reads weather data from a file and sets it in-game using the ZEN EH.
    By updating the source file externally and running this function in regular intervals, it's possible to simulate "live" weather
    Prerequisites
        CBA
        ZEN
    *\
    private _path = "Arma 3\userconfig\myweather\weather.sqf";
    private _forced = true;
    if (fileExists _path) then {private _weatherdata = preprocessFileLineNumbers _path } else exitWith { diag_log format ["File (%1) does not exist!", _path] };
    _weahterdata params ["_worldName", "_windX", "_windY", "_gustX", "_gustY", "_visibility", "_overcast", "_fog", "_rain", "_precipitationType"];
    if (worldName != _worldName) then {diag_log format ["WARNING: AK_fnc_updateWeatherfromFile: worldName in %1 does not match %2. Wrong weather data might be present.", _path, worldNAme];
    private _wind = [_windX, _windY, true];
    [QGVAR(applyWeather), [_forced, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, _wind, _gusts, _fog]] call CBA_fnc_globalEvent;
    
};
