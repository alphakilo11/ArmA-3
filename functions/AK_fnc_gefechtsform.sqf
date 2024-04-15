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
