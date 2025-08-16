AK_fnc_logHashMap = {
	params ["_hashMap"];
	_message = text toJSON _hashMap;
	if (count str _message > 1022) then {
		_warningmessage = format ["WARNING: log message exceeds limit of 1022 chars. %1 chars might have been truncated.", count str _message - 1022];
		diag_log _warningmessage;
		systemChat _warningmessage;
	};
	diag_log _message;
};