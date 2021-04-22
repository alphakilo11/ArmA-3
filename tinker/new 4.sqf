//creates an array of group NetIds for later use

AK_fnc_spacedvehicles = {
params [["_number", 1, [0]], ["_type", "", [""]], ["_spawnpos", [], [[]]], ["_destpos", [], [[]]], ["_spacing", 50, [0]], ["_behaviour", "SAFE", [""]]];

private ["_xPos", "_yPos", "_spawnedgroups"]; 
 
_xPos = 0; 
_yPos = 0;
_spawnedgroups = []; 

for "_x" from 1 to _number do
{ 
    _yPos = _yPos + _spacing; 
    _veh = createVehicle [_type, [(_spawnpos select 0) + _xPos,(_spawnpos select 1) + _yPos, 0], [], 0, "None"]; 
    _grp = createVehicleCrew _veh;
	_grp setBehaviour _behaviour;
	_grp deleteGroupWhenEmpty true;
	_grp addWaypoint [_destpos,(_number*15)];
	_spawnedgroups pushBack (_grp call BIS_fnc_netId);
if (_yPos >= 550) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    };
};
_spawnedgroups
};

//it works
_netids = ["4:14131","4:14148","4:14165","4:14182","4:14199","4:14216","4:14233","4:14250","4:14267","4:14284","4:14301","4:14318","4:14335","4:14352"];
_grps = [];
{_grps pushBack ( _x call BIS_fnc_groupFromNetId)} forEach _netids;
{_x move [23000,17000,0]} forEach _grps;

//still works
_netids = ["4:14131","4:14148","4:14165","4:14182","4:14199","4:14216","4:14233","4:14250","4:14267","4:14284","4:14301","4:14318","4:14335","4:14352"]; 
_grps = []; 
{_grps pushBack ( _x call BIS_fnc_groupFromNetId)} forEach _netids; 
{[getPos (leader _x)] call AK_fnc_flare;
_x addWaypoint [[23000,19000,0], 500]} forEach _grps;


//now it's time to delete them
_netids = ["4:14131","4:14148","4:14165","4:14182","4:14199","4:14216","4:14233","4:14250","4:14267","4:14284","4:14301","4:14318","4:14335","4:14352"]; 
_grps = []; 
{_grps pushBack ( _x call BIS_fnc_groupFromNetId)} forEach _netids; 
{[getPos (leader _x)] call AK_fnc_flare;
_x addWaypoint [[23000,19000,0], 500]} forEach _grps;
