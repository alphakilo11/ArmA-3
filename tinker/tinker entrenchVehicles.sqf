// Create vehicle trench for tanks
// getPos - 1 seems to be a good value for just the commander's turret
{
    _trench = "GRAD_envelope_vehicle" createVehicle [0,0,0];
    _gunner = driver _x;
    _requiredHeight =  ((getPos _x) select 2) + 1;//((ASLToAGL (eyePos _gunner)) select 2) - 2.5;//((_x modelToWorld (_x selectionPosition "hit_main_gun")) select 2) - 1.2;// ; //((getPos _gunner) select 2);
    _trench setPos ((_x getPos [1.5, direction _x]) vectorAdd [0,0,_requiredHeight]);//((getPos _trench) vectorAdd [0,0,_requiredHeight]);
    _trench setDir (direction _x);
    [_requiredHeight, getPos _trench, getPos _x];
} forEach (vehicles select {alive _x});

/*
{
    _trench = "GRAD_envelope_vehicle" createVehicle getPos (_x);
    _gunner = gunner _x;
    _requiredHeight =  ((unlucky modelToWorld (unlucky selectionPosition "hit_main_gun")) select 2) - 1.2;// ((ASLToAGL (eyePos _gunner)) select 2) - 2.5; //((getPos _gunner) select 2);
    _trench setPos ((_x getPos [1.5, direction _x]) vectorAdd [0,0,_requiredHeight]);//((getPos _trench) vectorAdd [0,0,_requiredHeight]);
    _trench setDir (direction _x);
    [_requiredHeight, getPos _trench, getPos _x];
} forEach (vehicles select {alive _x});
*/

// Get the muzzle position of the main gun
_muzzlePos = unlucky modelToWorld (unlucky selectionPosition "hit_main_gun");
_altnmuzzlePos = unlucky selectionPosition "hit_main_gun"; 
[_muzzlePos, _altnmuzzlePos, unlucky selectionNames "FireGeometry"];
