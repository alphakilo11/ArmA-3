//gets spawned groups into testvar to use at a later time (eg delete or change waypoints)
//might be easier to use "testvar = [14, "B_MBT_01_cannon_F", [23000,18000,0], [15000,17000,0], 50, "COMBAT"] call AK_fnc_spacedvehicles"
AK_fnc_spacedvehicles2 = {
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
	_spawnedgroups pushBack _grp;
if (_yPos >= 550) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    };
};
testvar = _spawnedgroups
};

//works fine on dedicated server (without ACE and blastcore)
_cfgArray = "(  
 (getNumber (_x >> 'scope') >= 2) &&  
 { 
  getNumber (_x >> 'side') == 1 &&  
  { getText (_x >> 'vehicleClass') in ['Armored'] } 
 } 
)" configClasses (configFile >> "CfgVehicles"); 
 
_xPos = 0; 
_yPos = 0; 
 
{ 
    _yPos = _yPos + 50; 
    _veh = createVehicle [(configName _x), [14000,17000,0] vectorAdd [_xPos, _yPos, 0], [], 0, "None"];
	_crew = createVehicleCrew _veh;
	_crew addWaypoint [[10300,19100,0],500];
    if (_yPos >= 1000) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    }; 
} forEach _cfgArray; 


//only RHS (tanks not included) units
//works fine on dedicated server (without ACE and blastcore)
_testarray = "(   
 (getNumber (_x >> 'scope') >= 2) &&   
 {  
  getNumber (_x >> 'side') == 1 &&   
  { getText (_x >> 'vehicleClass') in ['Armored', 'Car', 'Air'] }  
 }  
)" configClasses (configFile >> "CfgVehicles"); 

_testarray2 = [];
{_testarray2 pushBack configName _x} forEach _testarray;

_testarray3 = [];
{if (["rhs", _x] call BIS_fnc_inString) then {
_testarray3 pushBack _x}} forEach _testarray2;
 
_xPos = 0; 
_yPos = 0; 
 
{ 
    _yPos = _yPos + 50; 
    _veh = createVehicle [_x, [14000,17000,0] vectorAdd [_xPos, _yPos, 0], [], 0, "None"];
	_crew = createVehicleCrew _veh;
	_crew addWaypoint [[10300,19100,0],500];
    if (_yPos >= 1000) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    }; 
} forEach _testarray3; 


//works but drops the server FPS to 2
_testarray = "(    
 (getNumber (_x >> 'scope') >= 2) &&    
 {   
  getNumber (_x >> 'side') == 1
 }   
)" configClasses (configFile >> "CfgVehicles");  
 
_testarray2 = []; 
{_testarray2 pushBack configName _x} forEach _testarray; 
 
_testarray3 = []; 
{if (["rhs", _x] call BIS_fnc_inString) then { 
_testarray3 pushBack _x}} forEach _testarray2; 
  
_xPos = 0;  
_yPos = 0;  
  
{  
    _yPos = _yPos + 50;  
    _veh = createVehicle [_x, [14000,17000,0] vectorAdd [_xPos, _yPos, 0], [], 0, "None"]; 
 _crew = createVehicleCrew _veh; 
 _crew addWaypoint [[10300,19100,0],500]; 
    if (_yPos >= 1000) then {  
        _yPos = 0;  
        _xPos = _xPos + 50;  
    };  
} forEach _testarray3; 


//only RHS tanks
//works fine on dedicated server (without ACE and blastcore)
_testarray = "(   
 (getNumber (_x >> 'scope') >= 2) &&   
 {  
  getNumber (_x >> 'side') == 1 &&   
  { getText (_x >> 'vehicleClass') in ['rhs_vehclass_tank'] }  
 }  
)" configClasses (configFile >> "CfgVehicles"); 

_testarray2 = [];
{_testarray2 pushBack configName _x} forEach _testarray;

_testarray3 = [];
{if (["rhs", _x] call BIS_fnc_inString) then {
_testarray3 pushBack _x}} forEach _testarray2;
 
_xPos = 0; 
_yPos = 0; 
 
{ 
    _yPos = _yPos + 50; 
    _veh = createVehicle [_x, [14000,17000,0] vectorAdd [_xPos, _yPos, 0], [], 0, "None"];
	_crew = createVehicleCrew _veh;
	_crew addWaypoint [[10300,19100,0],500];
    if (_yPos >= 1000) then { 
        _yPos = 0; 
        _xPos = _xPos + 50; 
    }; 
} forEach _testarray3; 
