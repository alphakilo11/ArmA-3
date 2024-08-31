AK_fnc_transferAItoServer = {
	[{
		_transferCounter = 0;
		{
			if (groupOwner _x != 2) then {
				_x setGroupOwner 2;
				_transferCounter = _transferCounter + 1;
			};
		} forEach (allGroups select {!isPlayer (leader _x)});
		[format ["The owner of unlucky is: %1", owner unlucky]] remoteExec ['systemChat', 0];
		[format ["The owner of zeus is: %1", owner zeus]] remoteExec ['systemChat', 0];
		[format ["%1 groups have been transfered to the server.", _transferCounter]] remoteExec ['hint', 0];
	}] remoteExec ['call', 2];
	[owner player, groupOwner group unlucky]
};