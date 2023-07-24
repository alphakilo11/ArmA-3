defineFunction ["AK_fnc_TypeRatio", { 
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
while {count _res < _numberOfUnits} do {
    { 
        if (count _res >= _numberOfUnits) then { 
            breakOut; 
        }; 
        _res pushBack _x; 
    } forEach _unitTypes;
}; 
_res 
}];
