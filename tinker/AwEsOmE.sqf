// Scale objects
https// community.bistudio.com/wiki/setObjectScale

// use in Zeus mode
curatorCamera setPos [14000, 14000, 5];
[[16000, 17000, 300], [14600, 16800, 0], true] spawn BIS_fnc_setCuratorCamera;

// determine objectType
https// community.bistudio.com/wiki/BIS_fnc_objectType

// bulletCam by KillZoneKid
player addEventHandler ["Fired", {
	_null = _this spawn {
		_missile = _this select 6;
		_cam = "camera" camCreate (position player);
		_cam cameraEffect ["External", "Back"];
		waitUntil {
			if (isNull _missile) exitWith {
				true
			};
			_cam camSetTarget _missile;
			_cam camSetRelPos [0, -3, 0];
			_cam camCommit 0;
		};
		sleep 0.4;
		_cam cameraEffect ["Terminate", "Back"];
		camDestroy _cam;
	};
}];

// bulletCam for vehicles
_unit = vehicle player;
_unit call BIS_fnc_diagBulletCam;
// bulletCamIndex = _unit getVariable "BIS_fnc_diagBulletCam_fired"; 
// _unit removeEventHandler ["fired", bulletCamIndex];

// Kill messages with distances (at time of kill)
{
	_x addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer", "_instigator", "_useEffects"]; 
		diag_log format ["%1, %2", diag_tickTime, _this];
		systemChat format ["%1 killed %2 at %3 m", _killer, _unit, _unit distance _killer];
	}];
} forEach allUnits;


// Create matching smoke at the position of each group leader
private _smokeColors = [
	[west, "SmokeShellBlue"],
	[east, "SmokeShellRed"],
	[resistance, "SmokeShellGreen"],
	[civilian, "SmokeShellWhite"]
];
// Function to get the smoke color based on the side
private _getSmokeColor = {
	params ["_side"];
	private _color = "SmokeShell";
	{
		if (_side isEqualTo (_x select 0)) exitWith {
			_color = _x select 1;
		};
	} forEach _smokeColors;
	_color
};
// Get all group leaders
private _groupLeaders = [];
{_groupLeaders pushBack leader _x} forEach allGroups;
// Loop through each group leader and spawn a smoke grenade
{
	private _leader = _x;
	private _side = side _leader;
	private _smokeType = _side call _getSmokeColor;
	_smokeType createVehicle (getPos _leader);
} forEach _groupLeaders;
