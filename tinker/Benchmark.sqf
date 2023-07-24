
/* BENCHMARK
A Benchmark to determine how well a system can handle lots of units
1. Place an Ammo Bearer somewhere on Altis
2. Run Multiplayer
3. Make sure that the video settings are comparable
4. Run the code
RESULTS
PC [47.7612,42.7808,43.5967,42.328,41.9948,39.4089,35.3201,30.0188,30.2457,25.7649,26.8007,25.0391,23.7741,24.024,21.6509,20.5656,19.4411,19.7287,17.9977,18.3486,19.5838,18.9573,18.0995,18.2232,19.2771,20.5128,20.6186,19.9501,20.8062,21.2202,20.0501,20.2532,21.3618,21.6216,20.5656,21.9178,22.2222,22.567,23.1548,21.8878,24.8447,23.9163,27.4443,28.3186,28.4698,26.4026,27.9232,28.5714,28.777,30.0188,28.7253,29.7398,31.8725,33.1263,32.6531,33.3333,37.5587,40.6091,38.5542,36.9515,39.312]
Shadow_PC_20230711 = [26.936,31.0078,31.9361,31.6832,32.3887,31.1284,29.7398,24.1692,23.0548,20.3304,19.8265,19.2308,19.0024,19.1388,18.018,16.3265,17.1858,16.8776,18.2648,13.9373,14.1844,13.901,15.5642,14.8837,16.178,16.632,18.0587,17.8174,16.2437,18.2232,18.1406,18.1406,18.2648,19.0476,19.5599,19.3705,19.8511,19.6078,19.4647,20.1765,21.025,20.8333,21.978,20.9424,22.4719,24.2057,24.1327,24.5023,27.1647,28.9855,30.6513,30.1318,32.0641,31.3725,28.6225,32,34.4086,36.1174,39.1198,39.7022,45.3258]
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
player allowDamage false;
