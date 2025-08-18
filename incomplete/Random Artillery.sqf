/* random artillery impacts
	
	TODO
	
*/

// Version 4
// WORKS in DS MP
// CHANGED uiSleep to sleep (https//discordapp.com/channels/105462288051380224/105462984087728128/702843960330027098)
_handle = [] spawn { // the _handle is pointless like this
	feuer = 1;
	while { feuer == 1 } do {
		private _allHCs = entities "HeadlessClient_F";
		private _humanPlayers = allPlayers - _allHCs;
		_humanPlayers = count _humanPlayers;
		if (_humanPlayers > 0) then {
			private ["_shelltype", "_shellspread", "_shell", "_delay", "_altitude"];
			_shelltype = "Sh_155mm_AMOS";
			_shellspread = 1000;
			_altitude = 2000;
			_position = [27000, 23200, _altitude];
			_shell = createVehicle [_shelltype, _position, [], _shellspread];
			_shell setVelocity [0, 0, -50];
			diag_log format ["Feuer %1", time];
		} else {
			diag_log "No players present - random artillery fire cancelled";
		};
		_delay = random [1, 60, 120];
		sleep _delay;
	};
};