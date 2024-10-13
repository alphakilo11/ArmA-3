// track shots for later analysis (eg determining effective range of weapons)
player addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	systemChat format ["%1, %2, %3, %4, %5, %6, %7, %8", _unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _vehicle];
	_projectile addEventHandler ["HitPart", {
		params ["_projectile", "_hitEntity", "_projectileOwner", "_pos", "_velocity", "_normal", "_component", "_radius", "_surfaceType"];
		systemChat format ["%1, %2, %3, %4, %5, %6, %7, %8, %9", _projectile, _hitEntity, _projectileOwner, _pos, _velocity, _normal, _component, _radius, _surfaceType];
		systemChat format ["Distance: %1 m", player distance _pos];
		systemChat format ["getDir: %1", getDir _hitEntity];
	}];
}];

unlucky addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"];
	diag_log format ["%1, %2, %3, %4, %5, %6, %7, %8, %9, %10, %11", _target, _shooter, _projectile, _position, _velocity, _selection, _ammo, _vector, _radius, _surfaceType, _isDirect];
}];