/*spawn group every 600 seconds. If all 3 are executed at once it creates bugs (vehicles are not deleted and might clog the server. )
67,6 ms (BIS_fnc_spawnGroup seems to be very slow)
//TODO
add radius to _vfgrm (to avoid exploding on spawn)
randomize intervall
2. assign CBA attack module
+ merge the three scripts into one (params: _side, _vfgrm, "West")
4. stop all relevant loops when no players present
*/

//testing
spawnwest = [{
private _allHCs = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _allHCs;
_humanPlayers = count _humanPlayers; 
if (_humanPlayers > 0) then {
//skip reading config, if westgroups is already defined
if (isNil westgroups) then {
westgroups = []; 
{ 
 _faction = _x; 
 { 
  _type = _x; 
  { 
   westgroups pushBack _x; 
  } forEach ("true" configClasses _type); 
 } forEach ("true" configClasses _faction); 
} forEach ("true" configClasses (configFile >> "CfgGroups" >> "West")); 
_grp = selectRandom westgroups;
} else {
diag_log "groups already defined, skipping config readout";
};
//spawn group 
private _vfgrm = [27000, 24200]; 
private _marschziel = getPos AZ;
private _side = West; 
_gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup; 
_gruppe addWaypoint [_marschziel, 100]; 
_gruppe deleteGroupWhenEmpty true; 
diag_log format ["%1 spawned at %2. Will move to %3.", _gruppe, _vfgrm, _marschziel];
} else {
diag_log "No players present - spawn cancelled";
};
}, 600] call CBA_fnc_addPerFrameHandler;



//Version 3 (72.7857 ms)
spawnwest = [{
private _allHCs = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _allHCs;
_humanPlayers = count _humanPlayers; 
if (_humanPlayers > 0) then {
_groups = []; 
{ 
 _faction = _x; 
 { 
  _type = _x; 
  { 
   _groups pushBack _x; 
  } forEach ("true" configClasses _type); 
 } forEach ("true" configClasses _faction); 
} forEach ("true" configClasses (configFile >> "CfgGroups" >> "West")); 
_grp = selectRandom _groups;
 //spawn group 
private _vfgrm = [27000, 24200]; 
private _marschziel = [27000, 23200];
private _side = West; 
_gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup; 
_gruppe addWaypoint [_marschziel, 100]; 
_gruppe deleteGroupWhenEmpty true; 
diag_log format ["%1 spawned at %2. Will move to %3.", _gruppe, _vfgrm, _marschziel];
} else {
diag_log "No players present - spawn cancelled";
};
}, 600] call CBA_fnc_addPerFrameHandler;

//spawn random OPFOR group
spawneast = [{
private _allHCs = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _allHCs;
_humanPlayers = count _humanPlayers; 
if (_humanPlayers > 0) then {
_groups = []; 
{ 
 _faction = _x; 
 { 
  _type = _x; 
  { 
   _groups pushBack _x; 
  } forEach ("true" configClasses _type); 
 } forEach ("true" configClasses _faction); 
} forEach ("true" configClasses (configFile >> "CfgGroups" >> "East")); 
_grp = selectRandom _groups;
 //spawn group 
private _vfgrm = [24250, 21950]; 
private _marschziel = getPos AZ;
private _side = East; 
_gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup; 
_gruppe addWaypoint [_marschziel, 100]; 
_gruppe deleteGroupWhenEmpty true; 
diag_log format ["%1 spawned at %2. Will move to %3.", _gruppe, _vfgrm, _marschziel];
} else {
diag_log "No players present - spawn cancelled";
};
}, 600] call CBA_fnc_addPerFrameHandler;

spawnguer = [{
private _allHCs = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _allHCs;
_humanPlayers = count _humanPlayers; 
if (_humanPlayers > 0) then {
_groups = []; 
{ 
 _faction = _x; 
 { 
  _type = _x; 
  { 
   _groups pushBack _x; 
  } forEach ("true" configClasses _type); 
 } forEach ("true" configClasses _faction); 
} forEach ("true" configClasses (configFile >> "CfgGroups" >> "Indep")); 
_grp = selectRandom _groups;
 //spawn group 
private _vfgrm = [26000, 23200]; 
private _marschziel = [27000, 23200];
private _side = INDEPENDENT; 
_gruppe = [_vfgrm, _side, _grp] call BIS_fnc_spawnGroup; 
_gruppe addWaypoint [_marschziel, 100]; 
_gruppe deleteGroupWhenEmpty true; 
diag_log format ["%1 spawned at %2. Will move to %3.", _gruppe, _vfgrm, _marschziel];
} else {
diag_log "No players present - spawn cancelled";
};
}, 600] call CBA_fnc_addPerFrameHandler;
