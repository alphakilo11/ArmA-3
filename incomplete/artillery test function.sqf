//WIP artillery lethality test function
// Use createAgent?
//works with _lowerLeftCorner (= southwestern corner), but it's probably better to generally work with center positions
["Sh_125mm_HEAT_T_Yellow", [10500, 9400 ,0], 5, 50] params ["_shellType", "_center", "_spacing", "_sidelength"];
private _numberOfUnits = (1+ (_sidelength / _spacing)) ^ 2;
private _lowerLeftCorner = _center vectorAdd [-(_sidelength /2), -(_sidelength /2),0];
[_numberOfUnits, "C_man_p_beggar_F", _lowerLeftCorner, [], independent, _spacing, "COMBAT", _sidelength, 1] call AK_fnc_spacedvehicles;
private _shell = _shellType createVehicle (_center vectorAdd [0,0,150]);
_shell setVelocity [0, 0, -1];