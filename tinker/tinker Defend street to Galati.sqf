/*defend street from Athira to Galati - the heights around galati are amazing for long range engagements 
*/

setViewDistance 5500;
setObjectViewDistance 5500;
setTerrainGrid 2;

{
	[[(missionStart select [0, 5]), time] call BIS_fnc_calculateDateTime, true, true] call BIS_fnc_setDate;
} remoteExec ["call", 2];

player setPos [9982, 19354, 0];
player setDir 124;

// TODO get a proper weapon/vehicle (eg ZSU, mortar, artillery, tank, ATGM) in position and teleport the player into it
// ammo!
// TODO Add Arsenal (use ACE-Arsenal if available ( use something like "if (isclass(configfile >> "CfgWeapons" >> "ACE_EarPlugs"))") and "getLoadedModsInfo")
// FIGHT against all vehicles of one side!!!
// TODO spawn some point-defenders (turrets make sense, as they won't run away)
// ambient artillery for and/or supporting (long-range-)defenders for increased battlefield atmosphere
// destroy buildings/trees?
// TODO spawn waves?
// TODO spawn attacks (eg BMP1, BTR or infantry masses)