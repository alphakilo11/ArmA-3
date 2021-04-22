//not working
_array = [];
{
	if ((groupOwner _x) == 2) then {
	_array pushBack _x; 
	};
} forEach _allGroups; 

{
	_x setGroupOwner 4;
} forEach _array; 




_gruppe = group (_this select 0);
if ((groupOwner _gruppe) == 2) then { 
"true" remoteExec ["systemChat", -2]};


if ((count allunits) == 36) then { 
"true" remoteExec ["systemChat", -2]};


