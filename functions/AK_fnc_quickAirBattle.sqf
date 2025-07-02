AK_fnc_quickAirBattle = {  
 /* ----------------------------------------------------------------------------  
 Function: AK_fnc_quickAirBattle  
  
 Description:  
  Quickly set-up a large air battle  
    
 Parameters:  
  ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "GefechtsstreifenBreite"]  
 Returns:  
  NIL  
  
 Example:  
  (begin example)  
   [curatorSelected, true, 12, 12, worldSize] remoteExec ["AK_fnc_quickAirBattle", 2];      
  (end)  
  
 Author:  
  AK  
  
---------------------------------------------------------------------------- */  
 // HEADSUP if you select vehicles on the map you get the groups, if you select them in 3D than you get all units (including each crewmember)  
// ENHANCE defaults for params  
     // assumes that all attackers and defenders each share the same side   
 params ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_gefechtsstreifenBreite"]; // pass two arrays of vehicles seperated in space (eg by curatorSelected)  
 _angreiferFahrzeugAbstand = _gefechtsstreifenBreite / _angreiferAnzahl;  
 _verteidigerFahrzeugAbstand = _gefechtsstreifenBreite / _verteidigerAnzahl;  
  
 _SelectedEntities = _selection select 0;  
 _SelectedGroups = _selection select 1;  
 _parties = [_SelectedEntities] call AK_fnc_GroupbyDistance;  
 _partyA = (_parties select 0);  
 _partyB = (_parties select 1);  
  
 referenceAttacker = _partyA select 0;  
 referenceDefender = _partyB select 0;  
 _angreiferSpawnPosAnchor = getPos referenceAttacker;  
 _angriffsZiel = getPos referenceDefender;  
 _typleListAttackers = [_partyA apply {typeOf _x}, _angreiferAnzahl] call AK_fnc_TypeRatio;  
 _typleListDefenders = [_partyB apply {typeOf _x}, _verteidigerAnzahl] call AK_fnc_TypeRatio;  
 _angreiferSide = side referenceAttacker;  
 _verteidigerSide = side referenceDefender;  
  
 // delete the placeholders   
 [_SelectedEntities, _SelectedGroups] call CBA_fnc_deleteEntity; // remove the "parameters" intentionally not deleting waypoints and markers  
  
 // mark Positions   
 "SmokeShellBlue" createVehicle _angreiferSpawnPosAnchor;  
 "SmokeShellRed" createVehicle _angriffsZiel;  
  
 // general parameters derived from "parameter" units  
 _angriffsRichtung = _angreiferSpawnPosAnchor getDir _angriffsZiel;  
 _wrongVector = [[0, 1, 0], _angriffsRichtung] call BIS_fnc_rotateVector2D;  
 _angriffsRichtungVector = [(_wrongVector select 0) * -1, _wrongVector select 1, 0];  
 _angriffsDistanz = (_angreiferSpawnPosAnchor distance _angriffsZiel) + 1000; // Naechste Aufgabe Kompanie  
 _verteidigerRichtung = _angriffsZiel getDir _angreiferSpawnPosAnchor;  
 _verteidigerRichtungVector = [_angriffsRichtungVector, 180] call BIS_fnc_rotateVector2D;
 
    // redefine Angriffsziel before spawning
    _partyBSpawnPosAnchor = _angriffsZiel;
    _angriffsZiel = [worldSize / 2, worldSize / 2, 0];
      
  
    // spawn party A  
 [  
  {  
   isNull referenceAttacker  
  },  
  {  
   referenceAttacker = nil;  
   _this call AK_fnc_Airattack;  
  },  
  [_angreiferSpawnPosAnchor, _angriffsRichtungVector, _angriffsRichtung, _typleListAttackers, _angreiferSide, _angreiferAnzahl, _angriffsDistanz, _angreiferFahrzeugAbstand, _gefechtsstreifenBreite, _angriffsZiel, true, true]  
 ] call CBA_fnc_waitUntilAndExecute;  
  
    // spawn party B  
  
 [  
  {  
   isNull referenceDefender  
  },  
  {  
   referenceDefender = nil;  
   _this call AK_fnc_Airattack;  
  },  
  [_partyBSpawnPosAnchor, _verteidigerRichtungVector, _verteidigerRichtung, _typleListDefenders, _verteidigerSide, _verteidigerAnzahl, _angriffsDistanz, _verteidigerFahrzeugAbstand, _gefechtsstreifenBreite, _angriffsZiel, true, true]  
 ] call CBA_fnc_waitUntilAndExecute;  
};