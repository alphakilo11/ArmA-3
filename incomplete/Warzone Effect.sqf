//works in 3DEN graphic but will not influence the mission.
_pos = [8000,10100,0]; 
_radius = 1000; 
_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius];  
{if ((random 1) > 0.7) then {_x setDamage 1}} forEach _buildings; 

//destroy trees works on dedicated server (server). Also testet with _radius 4000 but took minutes to complete.
// 7 km took ~45' on Altis.
//sleep does nothing

 _pos = [6000,8600,0];
_radius = 1000;
_buildings = (nearestObjects [[_pos select 0, _pos select 1, 0],[], _radius]) - ([_pos select 0, _pos select 1, 0] nearObjects _radius); 
   sleep 1; 
   {if ((random 1) > 0.4) then {_x setDamage 1}} forEach _buildings;
   
//destroy buildings; works on dedicated server (server) also testet ok with _radius 10000
//sleep does nothing
 _pos = [6000,8600,0];
_radius = 1000;
_buildings = [_pos select 0, _pos select 1, 0] nearObjects ["house", _radius]; 
   sleep 1; 
   {if ((random 1) > 0.4) then {_x setDamage 1}} forEach _buildings;   