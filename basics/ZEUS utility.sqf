// get the config name of the selected object
_str = typeOf (_this select 1);
systemChat str _str;

// get the skill of the selected unit
private _skill = [];
{
	_skill pushBack (_this select 1) skillFinal _x
} forEach ["aimingAccuracy", "aimingShake", "aimingSpeed", "spotDistance", "spotTime", "courage", "reloadSpeed", "commanding", "general"];
systemChat _skill;