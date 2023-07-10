
/* BENCHMARK
A Benchmark to determine how well a system can handle lots of units
1. Place an Ammo Bearer somewhere on Altis
2. Run Multiplayer
3. Make sure that the video settings are comparable
4. Run the code
RESULTS
PC [47.7612,42.7808,43.5967,42.328,41.9948,39.4089,35.3201,30.0188,30.2457,25.7649,26.8007,25.0391,23.7741,24.024,21.6509,20.5656,19.4411,19.7287,17.9977,18.3486,19.5838,18.9573,18.0995,18.2232,19.2771,20.5128,20.6186,19.9501,20.8062,21.2202,20.0501,20.2532,21.3618,21.6216,20.5656,21.9178,22.2222,22.567,23.1548,21.8878,24.8447,23.9163,27.4443,28.3186,28.4698,26.4026,27.9232,28.5714,28.777,30.0188,28.7253,29.7398,31.8725,33.1263,32.6531,33.3333,37.5587,40.6091,38.5542,36.9515,39.312]
GeForceNow 20230710 
*/
_number_of_groups = 12;
_BLUFORSpawnPos = [12884.9,16775.1];
_OPFORSpawnPos = _BLUFORspawnPos getPos [300, 0];
_contestedArea = _BLUFORspawnPos getPos [150, 0];
player setPos _BLUFORSpawnPos;
setViewDistance 2000;
setObjectViewDistance 2000;
setTerrainGrid 1;

for "_i" from 0 to _number_of_groups do {
	_grp = [_BLUFORSpawnPos, west, 8] call BIS_fnc_spawnGroup;
	[_grp , _contestedArea] call CBA_fnc_taskAttack;
};
for "_i" from 0 to _number_of_groups do {
	_grp = [_OPFORSpawnPos, east, 8] call BIS_fnc_spawnGroup;
	[_grp , _contestedArea] call CBA_fnc_taskAttack;
};
[] spawn {
	AK_var_FPS = [];
	for "_i" from 0 to 60 do {
		sleep 5;
		_fps = diag_fps;
		AK_var_FPS pushBack _fps;
		systemChat format ["%1", _fps];
	};
};
