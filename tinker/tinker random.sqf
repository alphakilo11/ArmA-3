[center, minDist, maxDist, objDist, waterMode, maxGrad, shoreMode, blacklistPos, defaultPos] call BIS_fnc_findSafePos



[unlucky, unlucky, 300, 7, "MOVE", "SAFE", "YELLOW", "FULL", "STAG COLUMN", "unlucky call CBA_fnc_searchNearby", [3, 6, 9]] call CBA_fnc_taskPatrol;

_handle = [] spawn {
_array = [];
for "_x" from 1 to 10 do {
_seed = time;
_exs = position player select 0;
_y = position player select 1;
_test = _seed random [_exs, _y];
_array pushBack _test;
uisleep 1;
};
};
_array;

//requires a (moving) unit named seed
_handle = [] spawn {
for "_x" from 1 to 100 do {
_seed = time;
_exs = position seed select 0;
_y = position seed select 1;
_test = _seed random [_exs, _y];
_seed = random 1;
_test2 = _seed random [_exs, _y];
_pos = [(23000 + (_test * 1000)),(18000 + (_test2 *1000))];  
"B_T_MBT_01_TUSK_F" createVehicle _pos;
uisleep 1;
};
};

//strong linear weighted
_handle = [] spawn {
for "_x" from 1 to 100 do {
_seed = random 1;
_exs = random 1;
_y = random 1;
_test = _seed random [_exs, _y];
_seed = random 1;
_test2 = _seed random [_exs, _y];
_pos = [(4000 + (_test * 1000)),(4000 + (_test2 *1000))];  
"Land_TreeBin_F" createVehicle _pos;
};
};
