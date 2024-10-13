// kinda works, but the functions are never executed so the result is: "It's {
	time
}, {
	group Zeus1
} is at {
	position Zeus1
}"
// POSSIBLE REASON these are functions an you have to call them before handing them over - TRY [[_pos(), _zeit(), _gruppe()], _tellme] remoteExec ["spawn", 2];
private _pos = {
	position Zeus1
};
private _zeit = {
	time
};
private _gruppe = {
	group Zeus1
};
private _tellme = {
	params ["_pos", "_zeit", "_gruppe"];
	diag_log format ["It's %1, %2 is at %3", _zeit, _gruppe, _pos];
};
[[_pos, _zeit, _gruppe], _tellme] remoteExec ["spawn", 2];

private _pos = {
	position player
};
private _zeit = {
	time
};
private _gruppe = {
	group player
};
private _tellme = {
	params ["_pos", "_zeit", "_gruppe"];
	systemChat format ["It's %1, %2 is at %3", _zeit, _gruppe, _pos];
};
call [[_pos, _zeit, _gruppe], _tellme];

// TODO make it execute the functions first
private _pos = {
	position player
};
private _zeit = {
	time
};
private _gruppe = {
	group player
};
private _tellme = {
	params ["_pos", "_zeit", "_gruppe"];
	diag_log format ["It's %1, %2 is at %3", _zeit, _gruppe, _pos];
};
[_pos, _zeit, _gruppe] call _tellme;
// returns "It's {
	time
}, {
	group player
} is at {
	position player
}"

call {
	params ["_1", "_2", "_3"];
	systemChat format ["It's %1, %2 is at %3", _2, _3, _1];
};

[[1, 2, 3], {
	{
		systemChat str _x;
	} forEach _this;
}] remoteexeccall ["call", 0];

[1, 4, 2, "bla"] call {
	systemChat str _this;
};

private _spam1 = {
	systemChat "blabla";
};

private _spam2 = {
	systemChat "laber";
};

private _spam3 = {
	systemChat "nisch";
};

call _spam2;
call _spam3;
call _spam1;