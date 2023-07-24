_desiredStrengthPartyA = 10;
_desiredStrengthPartyB = 10;

_SelectedEntities = curatorSelected select 0;
_SelectedGroups = curatorSelected select 1;
_parties = [curatorSelected select 0] call AK_fnc_GroupbyDistance;
_initialPartyA = (_parties select 0);
_initialPartyB = (_parties select 1);
_posA = getPos (_initialPartyA select 0);
_posB = getPos (_initialPartyB select 0);
_typleListPartyA = [_initialPartyA apply {typeOf _x}, _desiredStrengthPartyA] call AK_fnc_TypeRatio;
_typleListPartyB = [_initialPartyB apply {typeOf _x}, _desiredStrengthPartyB] call AK_fnc_TypeRatio;
// delete the placeholders
{deleteVehicle _x} forEach _SelectedEntities;
// mark Positions
"SmokeShellBlue" createVehicle _posA;
"SmokeShellRed" createVehicle _posB;
// spawn Party A
[1, _typleListPartyA, _posA, _posB, west, 50, "AWARE", 500, 1] spawn AK_fnc_spacedvehicles;
// spawn Party B
[1, _typleListPartyB, _posB, _posA, east, 50, "AWARE", 500, 1] spawn AK_fnc_spacedvehicles; 
