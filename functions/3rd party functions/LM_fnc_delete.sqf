/*
	Author: Lou Montana

	Description:
		Deletes anything that is passed to it.

	Parameters:
		0: ANYTHING
		1: NUMBER or ARRAY or STRING - see examples below

	Returns:
		ANYTHING (false in case of a bad parameter, e.g null or number)

	Examples:
		cursorObject   call LM_fnc_delete
		group player   call LM_fnc_delete
		myLocation     call LM_fnc_delete
		myScriptHandle call LM_fnc_delete
		myTeamMember   call LM_fnc_delete
		myControl      call LM_fnc_delete
		myDisplay      call LM_fnc_delete
		mySimpleTask   call LM_fnc_delete
		"myMarker"     call LM_fnc_delete
		[myDisplay, 1] call LM_fnc_delete // display + errorCode
		["myMarker", "local"]             call LM_fnc_delete // uses deleteMarkerLocal
		["myIdentity", "identity"]        call LM_fnc_delete // uses deleteIdentity
		["myCustomStatus", "status"]      call LM_fnc_delete // uses deleteStatus
		["myFrameworkTaskId", "task"]     call LM_fnc_delete // uses BIS_fnc_deleteTask
		[units group player]              call LM_fnc_delete // USE [] for arrays!
		[waypoints group player select 3] call LM_fnc_delete // waypoint - USE [] as a waypoint is an array
		[group player, 3]                 call LM_fnc_delete // waypoint as well
		blufor             call LM_fnc_delete // deletes all the blufor units (keeping the side centre)
		[blufor, "center"] call LM_fnc_delete // deletes the side centre
		[myArray, 3]       call LM_fnc_delete // myArray deleteAt 3
		[myArray, [0, 3]]  call LM_fnc_delete // myArray deleteRange [0, 3]
		[[group player, "myMarker", blufor, myScriptHandle]] call LM_fnc_delete // everything can be mixed together
*/

params [
	"_argument",
	["_parameter", {}, [0, [], ""]]
];

if (isNil "_argument" ||
	{
		_argument in [objNull, grpNull, controlNull, displayNull, locationNull, scriptNull, taskNull, teamMemberNull] ||
		{ _argument isEqualTypeAny [0, {}, configNull, missionNamespace] }
	}
) exitWith { false };

if (_argument isEqualType objNull) exitWith // ...the initial reason this function was written
{
	if (vehicle _argument == _argument) then
	{
		if !(crew _argument isEqualTo []) then
		{
			{ _argument deleteVehicleCrew _x } forEach crew _argument;
		};
		private _vehicleCargo = getVehicleCargo _argument;
		if !(_vehicleCargo isEqualTo []) then
		{
			[_vehicleCargo] call LM_fnc_delete;
		};
		deleteVehicle _argument;
	} else {
		objectParent _argument deleteVehicleCrew _argument;
	};
};
if (_argument isEqualType grpNull) exitWith
{
	if (!isNil "_parameter" && { _parameter isEqualType 0 }) exitWith { deleteWaypoint [_argument, _parameter] };
	[units _argument] call LM_fnc_delete;
	deleteGroup _argument;
};
if (_argument isEqualType []) exitWith
{
	private _mustExit = false;
	if (!isNil "_parameter") then
	{
		if (_parameter isEqualType 0) exitWith { _mustExit = true; _argument deleteAt _parameter };
		if (_parameter isEqualType [] && { count _item1 > 1 && _item1 isEqualTypeAll 0 }) exitWith
		{
			_mustExit = true;
			_parameter params ["_from", "_range"];
			_argument deleteRange [_from, _range];
		};
	};
	if (_mustExit) exitWith {};
	{ [_x] call LM_fnc_delete } forEach _argument;
};
if (_argument isEqualType "") exitWith
{
	private _mustExit = false;
	if (!isNil "_parameter" && { _parameter isEqualType "" }) then
	{
		if (_parameter == "identity") exitWith { _mustExit = true; deleteIdentity _argument };
		if (_parameter == "status")   exitWith { _mustExit = true; deleteStatus _argument };
		if (_parameter == "local")    exitWith { _mustExit = true; deleteMarkerLocal _argument };
		if (_parameter == "task")     exitWith
		{
			_mustExit = true;
			[_argument, allUnits + allDeadMen + [blufor, opfor, independent, civilian]] call BIS_fnc_deleteTask;
		};
	};
	if (_mustExit) exitWith {};
	deleteMarker _argument;
};
if (_argument isEqualType scriptNull)     exitWith { terminate _argument };
if (_argument isEqualType locationNull)   exitWith { deleteLocation _argument };
if (_argument isEqualType blufor)         exitWith
{
	if (!isNil "_parameter" && { _parameter isEqualType "" && { _parameter == "center" } }) then
	{
		deleteCenter _argument;
	} else {
		[allGroups select { side _x == _argument }] call LM_fnc_delete;
	};
};
if (_argument isEqualType controlNull) exitWith { ctrlDelete _argument };
if (_argument isEqualType displayNull) exitWith
{
	private _exitCode = 0;
	if (!isNil "_parameter" && { _parameter isEqualType 0 }) then { _exitCode = _parameter };
	_argument closeDisplay _exitCode;
};
if (_argument isEqualType taskNull && _parameter isEqualType objNull) exitWith { _parameter removeSimpleTask _argument };
if (_argument isEqualType teamMemberNull) exitWith { deleteTeam _argument };

false;