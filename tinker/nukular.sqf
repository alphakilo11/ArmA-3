// wrapper for AK_fnc_createPermanentCrater for nuclear explosions
// use for example with smoke shells
private _selectedVehicles = curatorSelected select 0;

{
    [_x, ["Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        // avoid execution on clients where it isnt local
        if !(local _projectile) exitwith {diag_log "Projectile not local!"};
        if !(local _unit) exitwith {diag_log "UNIT NOT LOCAL!"};
        if !(local _gunner) exitwith {diag_log "GUNNER NOT LOCAL!"};
        _projectile addEventHandler ["Explode", {  
            params ["_projectile", "_pos", "_velocity"];
            //[_pos, -47, 85, false, false] remoteExec ["AK_fnc_createPermanentCrater", 2];
        }];
        _projectile addEventHandler ["Deleted", {  
            params ["_entity"];
            private _pos = getPos _entity;
            //[_pos, -(random [7, 9, 12]), 23, false, true] remoteExec ["AK_fnc_createPermanentCrater", 2];
            private _yield = 900; 
            private _radius = 20*_yield^0.4;
            private _craterRadius = (_yield / 1e6) ^(1/3) * 1000 / 2;
            _shell = "SatchelCharge_Remote_Ammo" createVehicle _pos;
            //_shell setPos (getPos _shell vectorAdd [0,0, 300 ]);
            _shell setDamage [1];
            /* DISABLED[_pos, _yield, _radius] call  RHS_fnc_ss21_nuke;
            [str _pos] remoteExec ["hint", 0];
            if ((_pos select 2) < _radius) then {
                [_pos, _craterRadius / -2.5, _craterRadius, false, true] remoteExec ["AK_fnc_createPermanentCrater", 2];
                ["Crater created."] remoteExec ["systemChat", 0];
            }
            */
        }];
        _projectile addEventHandler ["SubmunitionCreated", {  
            params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];
            ["Submunition created."] remoteExec ["hint", 0];
            diag_log "Submun created";
            _submunitionProjectile addEventHandler ["Explode", {
                params ["_projectile", "_pos", "_velocity"];
                //[_pos, -47, 85, false, false] remoteExec ["AK_fnc_createPermanentCrater", 2];
                ["Submunition exploded."] remoteExec ["hint", 0];
            }];
        }];    
         
     }]] remoteExec ["addEventHandler", 0];
     
} forEach _selectedVehicles;

{ 
_x addEventHandler ["Fired", {  
 [_this,  
  [ 
   diag_tickTime, // shotTime 
   getPosASL (_this select 6), // shooter position 
   velocity (_this select 6) // V0 
  ] 
 ] call AK_fnc_ballisticData; 
 }]; 
} forEach _selectedVehicles;
