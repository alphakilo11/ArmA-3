/*Spieler ausleuchten
TODO
randomize intervall
disable during daylight
use "last known position"
optional include AI Skill
include:
AK_ausleuchten = [{
private _shell = "rhs_ammo_flare_m485" createVehicle ([14600,20700,0] Vectoradd [0,0,500]);      
_shell setVelocity [0, 0, -1];
},120] call CBA_fnc_addperFrameHandler;
transform to function
*/





//Version 1
randomflare = [{
private _allHCs = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _allHCs;
_humanPlayers = count _humanPlayers; 
if (_humanPlayers > 0) then {
private ["_shelltype", "_shellspread", "_nshell", "_shell", "_i","_delay","_altitude"];    
_shelltype = "F_40mm_White"; //"Flare_82mm_AMOS_White" does not work
_shellspread = 250;        
_position = [14500,17600,150];
  _shell = createVehicle [_shelltype, _position, [], _shellspread];    
  _shell setVelocity [0, 0, -1];
} else {
diag_log "No players present - random flares cancelled";
};  
}, 20] call CBA_fnc_addPerFrameHandler;
