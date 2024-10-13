AK_fnc_transferAItoServer = {
	[{
		_transferCounter = 0;
		{
			if (groupOwner _x != 2) then {
				_x setGroupOwner 2;
				_transferCounter = _transferCounter + 1;
			};
		} forEach (allGroups select {
			!isPlayer (leader _x)
		});
		[format ["%1 groups have been transfered to the server.", _transferCounter]] remoteExec ['hint', 0];
	}] remoteExec ['call', 2];
};