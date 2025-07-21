AK_fnc_updateWeatherfromFile = {    /* Reads weather data from a file and sets it in-game using the ZEN EH. 
    By updating the source file externally and running this function in regular intervals, it's possible to simulate "live" weather 
    Prerequisites 
        CBA 
        ZEN 
    */
    if !(isServer) exitWith {diag_log "ERROR: AK_fnc_updateWeatherfromFile: Only the server should run this."};
     
    private _path = "\@AK_weatherdata\" + (['_weatherdata.sqf'] call AK_fnc_createWeatherFilename); 
    private _forced = true; 
    
    if !(fileExists _path) exitWith { diag_log format ["ERROR: AK_fnc_updateWeatherfromFile: AK_fnc_updateWeatherfromFile: File (%1) does not exist!", _path]; ["ERROR: updateWeatherFromFile: File not found."] remoteExec ["hint", 0];};
    private _weatherdata = call ([preprocessFile _path] call CBA_fnc_convertStringCode);
    _weatherdata params ["_worldName", "_windX", "_windY", "_gustX", "_gustY", "_visibility", "_overcast", "_fog", "_rain", "_precipitationType"]; 
    if (worldName != _worldName) then {diag_log format ["WARNING: AK_fnc_updateWeatherfromFile: worldName in %1 does not match %2. Wrong weather data might be present.", _path, worldNAme]}; 
    private _wind = [_windX, _windY, true];
    _lightning = 0;
    _rainbow = 0;
    _waves = 0;
    _gusts = 0;
    /* OBSOLETE
    [_wind] remoteExec ["setWind", 0];
    [0, _overcast] remoteExec ["setOvercast", 0];
    [] remoteExec ["forceWeatherChange", 0];
    */ 
    [_visibility] remoteExec ["setViewDistance", 0, "viewDistance"];
    [_visibility] remoteExec ["setObjectViewDistance", 0, "getObjectViewDistance"];
    [5000^2 / (5000/_visibility * _visibility^2)] remoteExec ["setTerrainGrid", 0, "terrainGrid"];
    
    ["ZEN_changeWeather", [_forced, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, _wind, _gusts, _fog]] call CBA_fnc_globalEvent;
    [str (["visibility", 'overcast', 'rain', 'precipitationType', 'lightning', 'rainbow', 'waves', 'wind', 'gusts', 'fog'] createHashMapFromArray 
    [_visibility, _overcast, _rain, _precipitationType, _lightning, _rainbow, _waves, [_windX, _windY] call BIS_fnc_magnitude, _gusts, _fog])] remoteExec ["hint", 0]; 
     
}; 
