/* Collect ballistic data
	ENHANCE 
	- Add inflicted vehicle damage 
	- Add inflicted casualties 
	HEADSUP 
	- After attachTo, the impact marker is not reliable 
	BUGS 
	- SPE vehicles that are gradually destroyed by ammo fires may not be detected. 
	- _firerPos is not consistent with where the bullet actually starts 
	REQUIRES  
	(vehicle player) addEventHandler ["Fired", {
		[_this, 
			        [  
			            diag_tickTime, // shotTime  
			            getPosASL (_this select 6), // shooter position  
			            velocity (_this select 6) // V0  
			        ]  
		    ] call AK_fnc_ballisticData;
	}]; 
*/
AK_fnc_ballisticData = {
	AK_switch_ballisticDataDebug = false;

	(_this select 0) params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	(_this select 1) params ["_shotTime", "_firerPos", "_muzzleVelocity"];

	_projectile addEventHandler ["HitPart", {
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_components", "_radius", "_surfaceType", "_instigator"];

		 if (alive _hitEntity && !(_hitEntity isKindOf "Building")) then {
			// rule out buildings and landscape 
			_hitMessage = ["Function", "Event Handler", "Projectile", "Impact Position", "Impact Velocity", "Target Designation", "Target Type", "Target Position", "Target Heading", "Target Velocity", "Target Side", "TickTime", "Components", "NormalAngle", "Surface"] createHashMapFromArray ["AK_fnc_ballisticData", "HitPart", _projectile, _pos, _velocity, _hitEntity, typeOf _hitEntity, getPosASL _hitEntity, direction _hitEntity, velocity _hitEntity, side _hitEntity, diag_tickTime, _components, _normal, _surfaceType];
			diag_log (toJSON _hitMessage);
			if (AK_switch_ballisticDataDebug == true) then {
				systemChat str _hitMessage;
			};

			if ((_components select 0) == "head") then {
				systemChat format ["HEADSHOT by %1 against %2. Range: %3", _projectileOwner, _hitEntity, _projectileOwner distance _hitEntity];
			};
			   // impactMarker
			if (AK_switch_ballisticDataDebug == true) then {
				_marker = "Sign_arrow_blue_F" createVehicle [0, 0, 0];
				_marker setPos ASLToAGL _pos;
				  // _marker attachTo [_hitEntity];  
				_marker setVectorUp (_velocity apply {
					_x * -1
				});
				   // normalMarker 
				_marker = "Sign_arrow_F" createVehicle [0, 0, 0];
				_marker setPos ASLToAGL _pos;
				  // _marker attachTo [_hitEntity];  
				_marker setVectorUp _normal;
			};

			if (_hitEntity getVariable ["AK_switch_DammagedHander", false] == false) then {
				_hitEntity addEventHandler ["Dammaged", {
					params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];
					 // check if someone caused the damage or it was caused by other factors for example a burning vehicle 
					if (isNull _shooter == false) then {
						// has a vital HitPoint been damaged 
						if (_hitPoint in ["hithull", "hitltrack", "hitrtrack", "hitengine", "hitturret", "hitgun"]) then {
							// avoid multiple triggers of dammaged in rapid succession. 
							if ((_unit getVariable ["AK_switch_dammagedCooldown", None]) == _shooter) exitWith {};
							_unit setVariable ["AK_switch_dammagedCooldown", _shooter];
							[_unit] spawn {
								sleep 1;
								(_this select 0) setVariable ["AK_switch_dammagedCooldown", nil];
							};
							   // has a vital HitPoint been destroyed 
							_criticalHitPointStatus = [];
							{
								_criticalHitPointStatus pushBack (floor (_unit getHitPointDamage _x))
							} forEach ["hithull", "hitltrack", "hitrtrack", "hitengine", "hitturret", "hitgun"];
							if !(1 in _criticalHitPointStatus) exitWith {};

							_approxdistance = _unit distance _shooter;
							_status = 'immobilized';
							if (_criticalHitPointStatus select 4 == 1 or _criticalHitPointStatus select 5 == 1) then {
								_status = 'incapacitated';
							};
							if (_criticalHitPointStatus select 0 == 1) then {
								_status = 'destroyed';
							};
							_dammageLogEntry = format ['{
								"Function": "AK_fnc_ballisticData", "Event Handler": "Vehicle Critical Dammaged", "Unit": "%1", "Selection": "%2", "Damage": %3, "HitIndex": %4, "HitPoint": "%5", "Shooter": "%6", "Projectile": "%7", "tickTime": %8, "Vehicle Damage ["hithull", "hitltrack", "hitrtrack", "hitengine", "hitturret", "hitgun"]": %9
							}', _unit, _selection, _damage, _hitIndex, _hitPoint, _shooter, _projectile, diag_tickTime, _criticalHitPointStatus];
							diag_log _dammageLogEntry;
							_dammageMessage = format ["%1 %2 %3 by causing %4 damage to selection %5 at a range of %6 using %7", _shooter, _status, _unit, _damage, _selection, _approxdistance, _projectile];
							if (AK_switch_ballisticDataDebug == true) then {
								hintSilent _dammageMessage;
							};
						};
					};
				}];
				_hitEntity setVariable ["AK_switch_DammagedHander", true];
			};
		};
	}];
	_projectile addEventHandler ["Penetrated", {
		params ["_projectile", "_hitObject", "_surfaceType", "_entryPoint", "_exitPoint", "_exitVector"];
		_penetratedMessage = format ['{
			"Function": "AK_fnc_ballisticData", "Event Handler": "Penetrated", "Projectile": "%1", "HitObject": "%2", "SurfaceType": "%3", "EntryPoint": %4, "ExitPoint": %5, "ExitVector": %6, "tickTime": %7
		}', _projectile, _hitObject, _surfaceType, _entryPoint, _exitPoint, _exitVector, diag_tickTime];
		// systemChat str _penetratedMessage;
		diag_log _penetratedMessage;
	}];
	_projectile addEventHandler ["SubmunitionCreated", {
		params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];
		_submunitionCreatedMessage = format ['{
			"Function": "AK_fnc_ballisticData", "Event Handler": "SubmunitionCreated", "Projectile": "%1", "submunitionProjectile": "%2", "Position": %3, "Velocity": %4, "tickTime": %5
		}', _projectile, _submunitionProjectile, _pos, _velocity, diag_tickTime];
		// systemChat str _submunitionCreatedMessage;
		diag_log _submunitionCreatedMessage;
	}];
	_projectile addEventHandler ["Explode", {
		params ["_projectile", "_pos", "_velocity"];
		_explodeMessage = format ['{
			"Function": "AK_fnc_ballisticData", "Event Handler": "Explode", "Projectile": "%1", "Position": %2, "Velocity": %3, "tickTime": %5
		}', _projectile, _pos, _velocity, diag_tickTime];
		// systemChat str _explodeMessage;
		diag_log _explodeMessage;
	}];
	_projectile addEventHandler ["Deflected", {
		params ["_projectile", "_pos", "_velocity", "_hitObject"];
		_deflectedMessage = format ['{
			"Function": "AK_fnc_ballisticData", "Event Handler": "Deflected", "Projectile": "%1", "Position": %2, "Velocity": %3, "HitObject": "%4", "tickTime": %5
		}', _projectile, _pos, _velocity, _hitObject, diag_tickTime];
		// systemChat str _deflectedMessage;
		diag_log _deflectedMessage;
	}];
};
