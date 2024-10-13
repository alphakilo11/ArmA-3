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