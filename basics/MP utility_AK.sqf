//Return all clients Machine network ID, if they are Headless Clients and their FPS once a minute.
fps1 = [{{ 
 [ 
  [clientOwner,(!hasInterface && !isDedicated), diag_fps],  
  { 
   systemChat format 
   [ 
    "ClientOwner: %1. HC: %2. Min FPS: %3", 
    _this select 0, _this select 1, _this select 2 
   ]; 
  } 
 ] 
 remoteExec ["call", remoteExecutedOwner];  
}  
remoteExec ["call", 0];}, 60, []] call CBA_fnc_addPerFrameHandler; 


//logs the network ID of the selected unit when executed on the server (use Development Tools->Execute Code)
_str = owner (_this select 1);
diag_log _str;

//transfers the group ownership (=locality) (has to be executed on the server)
group (_this select 1) setGroupOwner 7;


//checks if players are present on the server (eg suspend repeated spawning of units until players are present)
private _allHCs = entities "HeadlessClient_F";  
private _humanPlayers = allPlayers - _allHCs;    
if ((count _humanPlayers) > 0) then {} else {  
diag_log "No players present - ";  
};    