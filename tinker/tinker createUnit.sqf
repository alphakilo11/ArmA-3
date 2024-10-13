// creates a unit and adds it to the first players group
private _spawnunit = {
	private _leader = (allPlayers select 0);
	private _group = group _leader;
	private _type = "B_Soldier_F";
	private _position = position _leader;
	private _markers = [];
	private _placement = 50;
	private _special = "NONE";
	_group createUnit [_type, _position, _markers, _placement, _special];
};
[_spawnunit] remoteExecCall ["call", 2];
