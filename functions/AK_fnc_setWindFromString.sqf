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
