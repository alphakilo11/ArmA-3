// Function to assign waypoints spaced by distance towards destination 
// Remark: using vectors is faster than getDir
// Parameters: 
//   group: The group to assign waypoints to 
//   distance: The desired spacing between waypoints 
//   destination: The final destination position
// Return: Last issued waypoint 
// Example usage: {[_x, 100, [7020.41,11380.3,0]] call AK_fnc_spacedMovement} forEach (allGroups select {side _x == west}); 
AK_fnc_spacedMovement = {
	private ["_group", "_distance", "_destination", "_currentPos", "_waypointPos"];
	_group = _this select 0;
	_distance = _this select 1;
	_destination = _this select 2;

	// get the current position of the group 
	_currentPos = getPosWorld (leader _group);

	// Calculate the direction towards the destination 
	_dir = _currentPos vectorFromTo _destination;
	_dir = vectorNormalized _dir;

	// Calculate the number of waypoints needed 
	_numWaypoints = floor((_currentPos distance _destination) / _distance);

	// Assign waypoints 
	for "_i" from 1 to _numWaypoints do {
		_waypointPos = _currentPos vectorAdd (_dir vectorMultiply (_i * _distance));
		_waypoint = _group addWaypoint [_waypointPos, 0];
		_waypoint setWaypointCompletionRadius 10;
	};

	// Assign the final destination waypoint 
	_lastwaypoint = _group addWaypoint [_destination, 0];

	_lastwaypoint
};
