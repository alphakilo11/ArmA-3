/* ----------------------------------------------------------------------------
	Function: AK_fnc_spacedgroups
	
	Description:
	    Creates groups.
	
	Parameters:
	    0: _side- side <side>
	1: _number- Number of groups <NUMBER> (default: 1)
	    2: _type- type of group (config entry)<CONFIG>
	3: _spawnpos- spawn position <ARRAY>
	4: _destpos- Destination <ARRAY>
	5: _spacing- Spacing <NUMBER> (default: 50 m)
	6: _behaviour- Group behaviour [optional] <STRING> (default: "SAFE") 
	
	Returns:
	ARRAY of spawned groups.
	
	Example:
	    (begin example)
	[east, 12, (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"), [23000, 18000, 0], [15000, 17000, 0], 50, "COMBAT"] call AK_fnc_spacedgroups;
	    (end)
	
	Author:
	    AK
	
---------------------------------------------------------------------------- */

// TODO setSkill

AK_fnc_spacedgroups = {
	params [["_side", west], ["_number", 1, [0]], ["_type", (configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "SAFE", [""]]];

	private ["_xPos", "_yPos", "_spawnedgroups"];

	_xPos = 0;
	_yPos = 0;
	_spawnedgroups = [];

	for "_x" from 1 to _number do
	{
		_yPos = _yPos + _spacing;
		private _newGroup = [[(_spawnpos select 0) + _xPos, (_spawnpos select 1) + _yPos, 0], _side, _type] call BIS_fnc_spawnGroup;
		_newGroup setBehaviour _behaviour;
		_newGroup deleteGroupWhenEmpty true;
		_newGroup addWaypoint [_destpos vectorAdd [_xPos, _yPos, 0], 10];
		_spawnedgroups pushBack _newGroup;
		if (_yPos >= 550) then {
			_yPos = 0;
			_xPos = _xPos + _spacing;
		};
	};
	_spawnedgroups
};