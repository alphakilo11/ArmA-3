AK_fnc_Benchmark = {
	// _attackerType = "B_MBT_01_cannon_F";
	// _defenderType = "O_MBT_02_cannon_F";
	AK_var_serverFPS = [];
	publicVariable "AK_var_serverFPS";
	AK_var_clientFPS = [];
	AK_toggle_benchmark = true;
	[{
		_distance = 2400;
		setViewDistance _distance;
		setObjectViewDistance _distance;
		setTerrainGrid 1;
	}] remoteExec ["call", 0];
	if (isDedicated) exitWith {
		diag_log "ERROR: This script only works if it is executed on the curator's client."
	};
	[curatorSelected, true, 31, 17, 2000, 2000] remoteExec ["AK_fnc_quickBattle", 2];

	_lastFrameInfo = [diag_frameno, time];
	[{
		AK_var_serverLastFrameInfo = [diag_frameno, time]
	}] remoteExec ["call", 2];
	while { AK_toggle_benchmark == true } do {
		sleep 10;
		_currentFrameNo = diag_frameno;
		_currentTime = time;
		_lastFrameNo = _lastFrameInfo select 0;
		_lastFrameTime = _lastFrameInfo select 1;
		AK_var_clientFPS pushBack (round ((_currentFrameNo - _lastFrameNo) / (_currentTime - _lastFrameTime)));
		_lastFrameInfo = [_currentFrameNo, _currentTime];
		[{
			publicVariable "AK_var_serverFPS";
			_currentFrameNo = diag_frameno;
			_currentTime = time;
			_lastFrameNo = AK_var_serverLastFrameInfo select 0;
			_lastFrameTime = AK_var_serverLastFrameInfo select 1;
			AK_var_serverFPS pushBack (round ((_currentFrameNo - _lastFrameNo) / (_currentTime - _lastFrameTime)));
			AK_var_serverLastFrameInfo = [_currentFrameNo, _currentTime];
		}] remoteExec ["call", 2];
	};
};