private [ "_pos", "_shelltype", "_shellspread", "_nshell", "_shell", "_i","_delay",”_alt”]; 
_pos = [0,0,0]; 
_shelltype      = "Sh_155mm_AMOS"; 
_shellspread = 8000; 
_nshell  = 5000; 
_delay  = 5; 
_alt = 1000;
if (isnil "_delay") then {_delay = 1}; 
for [{_i=0},{_i<_nshell},{_i=_i+1}] do 
 { 
  _shell = _shelltype createVehicle [(_pos select 0) + _shellspread - 2*(random _shellspread) ,(_pos select 1) + _shellspread - 2*(random _shellspread), _alt]; 
  _shell setVelocity [0, 0, -50]; 
  sleep _delay; 
 }; 

//what's the difference?
private [ "_pos", "_shelltype", "_shellspread", "_nshell", "_shell", "_i","_delay","_altitude"];   
_pos = [3500,2600,0];   
_shelltype      = "Sh_155mm_AMOS";   
_shellspread = 2000;   
_nshell  = 50;   
_delay  = 0.1;  
_altitude = 5000; 
if (isnil "_delay") then {_delay = 1};   
for [{_i=0},{_i<_nshell},{_i=_i+1}] do   
 {   
  _shell = _shelltype createVehicle [(_pos select 0) + _shellspread - 2*(random _shellspread) ,(_pos select 1) + _shellspread - 2*(random _shellspread), _altitude];   
  _shell setVelocity [0, 0, -50];   
sleep _delay;   
 };   


//Somme Artilleriefeuer
randomartkavala2 = [{  
private _allHCs = entities "HeadlessClient_F";  
private _humanPlayers = allPlayers - _allHCs;  
_humanPlayers = count _humanPlayers;   
if (_humanPlayers > 0) then {  
private ["_shelltype", "_shellspread", "_nshell", "_shell", "_i","_delay","_altitude"];      
_shelltype = "Sh_155mm_AMOS";   
_shellspread = 1200;          
_position = [3700,13300,1000];  
  _shell = createVehicle [_shelltype, _position, [], _shellspread];      
  _shell setVelocity [0, 0, -50];  
} else {  
diag_log "No players present - random flares cancelled";  
};    
}, (1/7)] call CBA_fnc_addPerFrameHandler;