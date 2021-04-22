try this:

null = [thislist] spawn {
    params ["_triggerlist"];
    private _triggerPlayerlist = (_triggerlist select {isPlayer _x});
    if !(_triggerPlayerlist isEqualto []) then {
        private _roundNumber = 0;
        private _playertarget = selectRandom _triggerPlayerlist;
        while {(alive Mortar1) && {(_roundNumber < 3)}} do {
            sleep (random 2);
            Mortar1 commandArtilleryFire [getposatl (_playertarget), "rhs_mag_3vo18_10", 1];
            sleep (3 + (random 3));
            _roundNumber = _roundNumber + 1;
        };
    };
};

Mortar1 commandArtilleryFire [getposatl player, "8Rnd_82mm_Mo_shells", 1];

//works on CSAT SPG
_sog = magazinesAmmo Mortar1 select 0 select 0;
systemChat str _sog;
Mortar1 commandArtilleryFire [getposatl player, _sog, 1];

//get estimated time of impact
_sog = magazinesAmmo Mortar1 select 0 select 0;
systemChat str _sog;
_wann = Mortar1 getArtilleryETA [getposatl player, _sog];
systemChat str _wann;