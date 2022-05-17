//creates a unit and adds it to the players group (to which players group?)
private _spawnunit = {
    private _leader = (allplayers select 0);
    private _group = group _leader;
    private _type = "B_Soldier_F";
    private _position = position _leader;
    private _markers = [];
    private _placement = 50;
    private _special = "NONE";
    _group createUnit [_type, _position, _markers, _placement, _special];
};
[_spawnunit] remoteExecCall ["call", 2];



//does nothing without error
private _spawnunit = {
private _leader = (allplayers select 0);
private _group = group _leader;
private _type = "B_Soldier_F";
private _position = position _leader;
private _markers = [];
private _placement = 50;
private _special = "NONE";
_group createUnit [_type, _position, _markers, _placement, _special];
};
[] remoteExecCall ["_spawnunit", 2];


//works local and on server
//Warning: Adding units to a remote group is not safe. Please use setGroupOwner to change the group owner first.
{
private _leader = (allplayers select 0);
private _group = group _leader;
private _type = "B_Soldier_F";
private _position = position _leader;
private _markers = [];
private _placement = 50;
private _special = "NONE";
_group createUnit [_type, _position, _markers, _placement, _special];
} remoteExec ["call", 2];



//works local and on server
{
private _leader = (allplayers select 0);
private _group = group _leader;
private _type = "B_Soldier_F";
private _position = position _leader;
private _markers = [];
private _placement = 50;
private _special = "NONE";
_group createUnit [_type, _position, _markers, _placement, _special];
} remoteExec ["bis_fnc_call", 2];



//works local and on server
private _leader = (allplayers select 0);
private _group = group _leader;
private _type = "B_Soldier_F";
private _position = position _leader;
private _markers = [];
private _placement = 50;
private _special = "NONE";
_group createUnit [_type, _position, _markers, _placement, _special];