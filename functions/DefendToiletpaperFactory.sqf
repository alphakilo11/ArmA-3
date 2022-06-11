/*
The Achilles Execute Code Module doesn't like double-slashes, therefore I have to put all comments in here and the code has to be copy-pasted without this block.

Inspired by the toilet paper shortage in Austria in 2020 this scenario has the players defending a toilet paper factory
This will create a huge building and 2 + _numberofprivates hostiles approaching it.
The hostiles will spawn within a radius of _radius.
_pos is the ground zero of the whole scenario and is defined as the players position.

*/

private _pos = getPosATL player;
private _objective = createVehicle ["Land_Factory_Main_F", _pos, [], 100, 'NONE'];
private _markerstr = createMarker ["military1",(getPos _objective)];
_markerstr setMarkerShape "ICON";
_markerstr setMarkerType "n_support";
_markerstr setMarkerText "Klopapierlager";
private _numberofprivates = 10;
private _radius = 2000;
private _typeofunit = ["LOP_BH_Infantry_model_OFI_TRI","LOP_BH_Infantry_model_OFI_M81",'LOP_BH_Infantry_model_OFI_LIZ',"LOP_BH_Infantry_model_OFI_FWDL","LOP_BH_Infantry_model_OFI_ACU","LOP_BH_Infantry_model_M81_TRI","LOP_BH_Infantry_model_M81_LIZ","LOP_BH_Infantry_model_M81_FWDL","LOP_BH_Infantry_model_M81_CHOCO","LOP_BH_Infantry_model_M81_ACU","LOP_BH_Infantry_model_M81","LOP_BH_Infantry_AR","LOP_BH_Infantry_AR_2","LOP_BH_Infantry_AR_Asst","LOP_BH_Infantry_AR_Asst_2","LOP_BH_Infantry_AT","LOP_BH_Infantry_base","LOP_BH_Infantry_Corpsman","LOP_BH_Infantry_Driver","LOP_BH_Infantry_GL","LOP_BH_Infantry_IED","LOP_BH_Infantry_Marksman"];
 private _newGroup = createGroup east;
 _newUnit = _newGroup createUnit ["LOP_BH_Infantry_SL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'SERGEANT';
 _newUnit setFormDir 210.828;
 _newUnit setDir 210.828;
_newUnit = _newGroup createUnit ["LOP_BH_Infantry_TL", _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'CORPORAL';
 _newUnit setFormDir 180.016;
 _newUnit setDir 180.016;
 private _a =0;
 while {_a = _a + 1; _a < (_numberofprivates + 1)} do {
_newUnit = _newGroup createUnit [(selectRandom _typeofunit), _pos, [], _radius, 'CAN_COLLIDE'];
 _newUnit setSkill 0.5;
 _newUnit setRank 'PRIVATE';
 _a + 1;
 };
_newGroup setFormation 'STAG COLUMN';
 _newGroup setCombatMode 'RED';
 _newGroup setBehaviour 'AWARE';
 _newGroup setSpeedMode 'FULL';
_newWaypoint = _newGroup addWaypoint [_pos, 0];
 _newWaypoint setWaypointType "SAD";
