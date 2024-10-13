/*
 * Function: AK_fnc_removeTrees
 * Description: Reduces the number of trees on the entire map by hiding or cutting them down based on the given thresholds.
 * Parameters:
 *   0: NUMBER - Hide Threshold (default: 10)
 *   1: NUMBER - Cut Threshold (default: 90)
 * Returns: None
 * Author: AK
 * Example:
 *   [{[10, 90] spawn AK_fnc_removeTrees;}] remoteExec ["call", 0, "AK_fnc_removeTrees"];
 */
AK_fnc_removeTrees = {
	params [
	["_hideThreshold", 10, [0]],
	["_cutThreshold", 90, [0]]
	];
	_startTime = diag_tickTime;
	_cutCounter = 0;
	_trees = nearestTerrainObjects [[worldSize / 2, worldSize / 2, 0], ["Tree"], worldSize, false];
	
	[format ["%1 s: %2 trees found", diag_tickTime - _startTime, count _trees]] remoteExec ["systemChat", 0];
	{
		if (_forEachIndex random 100 > _hidethreshold) then {
			hideObject _x;
		} else {
			if ((_forEachIndex + 1) random 100 > _cutThreshold) then {
				_x setDamage 1;
				_cutCounter = _cutCounter + 1;
			};
		};
	} forEach _trees;
	[format ["%1 s: Finished processing %2 trees. %3 have been cut.", diag_tickTime - _startTime, count _trees, _cutCounter]] remoteExec ["systemChat", 0];	
};