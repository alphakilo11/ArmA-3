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