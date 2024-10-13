/* Identifies 2 Groups which are separated by distance */
AK_fnc_GroupbyDistance = {
	params ["_unsortedObjects"];
	_anchorPos = getPos (_unsortedObjects select 0);
	_distances = [];
	{
		_distances pushBack (_anchorPos distance _x);
	} forEach _unsortedObjects;
	_threshold = (selectMax _distances) / 2;
	_groupA = [];
	_groupB = [];
	for "_i" from 0 to (count _unsortedObjects) - 1 do {
		if ((_distances select _i) > _threshold) then {
			_groupB pushBack (_unsortedObjects select _i);
		} else {
			_groupA pushBack (_unsortedObjects select _i);
		};
	};
	[_groupA, _groupB]
};