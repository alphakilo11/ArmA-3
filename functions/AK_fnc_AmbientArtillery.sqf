AK_fnc_AmbientArtillery = {
        AK_switch_AmbientArtilleryFire = true;
        _shelltype = "Sh_155mm_AMOS";
        _intensity = 1;   
        while {AK_switch_AmbientArtilleryFire == true} do {
            _shellspread = viewDistance;
            _intensityFactor = (viewDistance ^ 2) / (4000 ^ 2);
            _victim = selectRandom allPlayers;
            //TODO change from square to evenly distributed circle
            _expectedVictimPos = getPosASL _victim vectorAdd ((velocity _victim) vectorMultiply 30);
            _barragePos = [(_expectedVictimPos select 0) + _shellspread - 2*(random _shellspread) ,(_expectedVictimPos select 1) + _shellspread - 2*(random _shellspread), 0];
            _barrageShotCount = floor random [1 , 6, 36];
            _barrageDispersion = floor random [50, 250, 500]; 
            for "_i" from 1 to _barrageShotCount do    
             {
                _altitude = random [500, 5000, 25000];    
                _shell = createVehicle [_shelltype, [_barragePos select 0, _barragePos select 1, _altitude], [], _barrageDispersion];    
                _shell setVelocity [0, 0, -50];        
             };
             //DEBUG
             [format ["%1 s: %2 you got %3 Nockerl incoming!", diag_tickTime, _victim, _barrageShotCount]] remoteExec ["systemChat", 0];
             _barrageMarker = createMarker [str diag_tickTime, _barragePos];
             _barrageMarker setMarkerType "hd_dot"; 
             _barrageMarker setMarkerColor "ColorRed";
             _aimMarker = createMarker [(str diag_tickTime) + "Aim", _expectedVictimPos];
             _aimMarker setMarkerType "mil_destroy_noShadow";
             //_barrageMarker setMarkerShape "ELLIPSE"; 
             //_barrageMarker setMarkerSize [_barrageDispersion, _barrageDispersion];
             sleep (random [1 , 60, 180] / _intensity / _intensityFactor);
        };
	};
