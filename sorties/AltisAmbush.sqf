_group0 = createGroup [east, true];
_group1 = createGroup [east, true];
_group2 = createGroup [west, true];
_group3 = createGroup [east, true];
_group4 = createGroup [east, true];
_group5 = createGroup [east, true];
_group6 = createGroup [east, true];
_group7 = createGroup [east, true];
_group8 = createGroup [east, true];
_group9 = createGroup [east, true];
_group10 = createGroup [east, true];

_object0 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object0 setVectorDirAndUp [[-0.638691,0.769463,0],[0,0,1]];
_object0 setPosASL [26425.7,22481.7,55.7508];


_object1 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object1 setVectorDirAndUp [[-0.325846,0.945423,0],[0,0,1]];
_object1 setPosASL [26406.9,22554.2,58.5461];


_object2 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object2 setVectorDirAndUp [[-0.730562,-0.682846,0],[0,0,1]];
_object2 setPosASL [26415.2,22641,52.0422];


_object3 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object3 setVectorDirAndUp [[-0.333388,-0.94279,0],[0,0,1]];
_object3 setPosASL [26416.1,22646.1,50.8384];


_object4 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object4 setVectorDirAndUp [[0.304762,0.952429,0],[0,0,1]];
_object4 setPosASL [26452.7,22466.9,50.4892];


_object5 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object5 setVectorDirAndUp [[-0.314104,-0.949389,0],[0,0,1]];
_object5 setPosASL [26459.1,22489.6,51.191];


_object6 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object6 setVectorDirAndUp [[0.144983,0.989434,0],[0,0,1]];
_object6 setPosASL [26438.8,22504.8,57.967];


_object7 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object7 setVectorDirAndUp [[0.862952,-0.505286,0],[0,0,1]];
_object7 setPosASL [26440.6,22544.3,59.3118];


_object8 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object8 setVectorDirAndUp [[0.683962,-0.729518,0],[0,0,1]];
_object8 setPosASL [26430.4,22598.1,61.1841];


_object9 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object9 setVectorDirAndUp [[0.366526,-0.930408,0],[0,0,1]];
_object9 setPosASL [26466,22473.4,49.2687];


_object10 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object10 setVectorDirAndUp [[0.977467,-0.211089,0],[0,0,1]];
_object10 setPosASL [26468.5,22481.7,49.0137];


_object11 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object11 setVectorDirAndUp [[0.0389684,-0.99924,0],[0,0,1]];
_object11 setPosASL [26475.8,22536,52.337];


_object12 = createVehicle ["rhsgref_BRDM2_HQ_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object12 setVectorDirAndUp [[-0.751937,-0.65715,-0.0523777],[-0.0708764,0.00159594,0.997484]];
_object12 setPosASL [26945.5,23253.7,18.7995];
[_object12, ["olive",1], [], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object12;
clearWeaponCargoGlobal _object12;
clearMagazineCargoGlobal _object12;
clearBackpackCargoGlobal _object12;

{_object12 addItemCargoGlobal _x} forEach [["FirstAidKit",4],["Medikit",1],["ACE_rope12",2]];
{_object12 addWeaponCargoGlobal _x} forEach [["rhs_weap_igla",1]];
{_object12 addMagazineCargoGlobal _x} forEach [["rhs_30Rnd_545x39_7N6_AK",30],["rhs_10Rnd_762x54mmR_7N1",10],["rhs_100Rnd_762x54mmR",3],["rhs_mag_rdg2_white",2],["rhs_mag_rgd5",9],["rhs_VOG25",20],["rhs_VG40OP_white",5],["rhs_GRD40_White",5],["rhs_mag_9k38_rocket",2]];
{_object12 addBackpackCargoGlobal _x} forEach [["rhs_sidor",3]];

{_object12 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object12;
{_object12 addMagazineTurret _x} forEach [["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250]];
_object13 = _group0 createUnit ["rhs_msv_crew", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object13 setPosASL [26944.5,23252.4,19.6728];
_object13 setDir 228.848;
_object13 setRank "PRIVATE";
_object13 setSkill 0.5;
_object13 setUnitPos "Auto";
_group0 selectLeader _object13;
['_object13_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object13_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object13]] call BIS_fnc_addStackedEventHandler;


_object14 = _group0 createUnit ["rhs_msv_crew", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object14 setPosASL [26944.2,23252.8,19.4458];
_object14 setDir 228.848;
_object14 setRank "SERGEANT";
_object14 setSkill 0.5;
_object14 setUnitPos "Auto";
['_object14_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	[_unit, [[[],[],["rhs_weap_pya","","","",["rhs_mag_9x19_17",17],[],""],["rhs_uniform_flora",[["FirstAidKit",1],["rhs_mag_9x19_17",2,17],["rhs_mag_rdg2_white",1,1]]],["rhs_vest_pistol_holster",[["rhs_mag_nspd",1,1]]],[],"rhs_tsh4_ess","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[["aceax_textureOptions",[]]]]] call CBA_fnc_setLoadout;
	_unit call BIN_fnc_CBRNHoseInit;
	['_object14_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object14]] call BIS_fnc_addStackedEventHandler;


_object15 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object15 setVectorDirAndUp [[-0.831639,-0.552373,-0.0570935],[-0.0518207,-0.0251688,0.998339]];
_object15 setPosASL [26962.8,23267.7,19.6767];
[_object15, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object15;
clearWeaponCargoGlobal _object15;
clearMagazineCargoGlobal _object15;
clearBackpackCargoGlobal _object15;

{_object15 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object15 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object15;
{_object15 addMagazineTurret _x} forEach [];
_object16 = _group1 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object16 setPosASL [26961.5,23266,20.9325];
_object16 setDir 238.796;
_object16 setRank "PRIVATE";
_object16 setSkill 0.5;
_object16 setUnitPos "Auto";
_group1 selectLeader _object16;
['_object16_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object16_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object16]] call BIS_fnc_addStackedEventHandler;


_object17 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object17 setVectorDirAndUp [[0.68847,-0.725265,0],[0,0,1]];
_object17 setPosASL [26509.5,22470,47.7942];


_object18 = _group2 createUnit ["rhsusf_socom_marsoc_jtac", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object18 setPosASL [26247.5,22492.1,62.5042];
_object18 setDir 311.487;
_object18 setRank "PRIVATE";
_object18 setSkill 0.5;
_object18 setUnitPos "Auto";
['_object18_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	[_unit, [[["rhs_weap_m4a1_mstock_grip3","rhsusf_acc_SF3P556","rhsusf_acc_anpeq15_top","rhsusf_acc_eotech_xps3",["rhs_mag_30Rnd_556x45_M855A1_Stanag",30],[],"rhsusf_acc_rvg_blk"],[],["rhsusf_weap_glock17g4","","","",["rhsusf_mag_17Rnd_9x19_FMJ",17],[],""],["rhs_uniform_g3_m81",[["FirstAidKit",1],["rhsusf_ANPVS_15",1],["rhs_Booniehat_m81",1]]],["rhsusf_mbav_mg",[["rhsusf_acc_nt4_black",1],["rhs_mag_30Rnd_556x45_M855A1_Stanag",6,30],["rhsusf_mag_17Rnd_9x19_FMJ",2,17],["rhs_mag_m18_yellow",2,1],["rhs_mag_m18_purple",2,1],["I_IR_Grenade",2,1],["Chemlight_red",3,1],["rhs_mag_m67",1,1]]],[],"rhsusf_opscore_mar_fg_pelt","rhs_googles_clear",["Laserdesignator","","","",["Laserbatteries",1],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[["aceax_textureOptions",[]]]]] call CBA_fnc_setLoadout;
	_unit call BIN_fnc_CBRNHoseInit;
	['_object18_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object18]] call BIS_fnc_addStackedEventHandler;


_object19 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object19 setVectorDirAndUp [[-0.809817,-0.586013,-0.0280258],[-0.0124633,-0.0305753,0.999455]];
_object19 setPosASL [26977.1,23278.7,20.4188];
[_object19, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object19;
clearWeaponCargoGlobal _object19;
clearMagazineCargoGlobal _object19;
clearBackpackCargoGlobal _object19;

{_object19 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object19 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object19;
{_object19 addMagazineTurret _x} forEach [];
_object20 = _group3 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object20 setPosASL [26975.9,23277,21.7049];
_object20 setDir 236.418;
_object20 setRank "PRIVATE";
_object20 setSkill 0.5;
_object20 setUnitPos "Auto";
_group3 selectLeader _object20;
['_object20_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object20_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object20]] call BIS_fnc_addStackedEventHandler;


_object21 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object21 setVectorDirAndUp [[-0.84286,-0.538133,0.000478819],[-0.016902,0.0273623,0.999483]];
_object21 setPosASL [26993.1,23290.9,20.4452];
[_object21, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object21;
clearWeaponCargoGlobal _object21;
clearMagazineCargoGlobal _object21;
clearBackpackCargoGlobal _object21;

{_object21 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object21 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object21;
{_object21 addMagazineTurret _x} forEach [];
_object22 = _group4 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object22 setPosASL [26991.8,23289.3,21.8215];
_object22 setDir 239.911;
_object22 setRank "PRIVATE";
_object22 setSkill 0.5;
_object22 setUnitPos "Auto";
_group4 selectLeader _object22;
['_object22_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object22_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object22]] call BIS_fnc_addStackedEventHandler;


_object23 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object23 setVectorDirAndUp [[0.928538,-0.371238,0],[0,0,1]];
_object23 setPosASL [26520.7,22535.6,43.382];


_object24 = createVehicle ["ModuleMine_APERSBoundingMine_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object24 setVectorDirAndUp [[-0.311207,-0.950342,0],[0,0,1]];
_object24 setPosASL [26521,22547.7,42.6302];


_object25 = createVehicle ["rhsusf_mrzr4_d", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object25 setVectorDirAndUp [[0.39159,0.912859,-0.115518],[-0.0232378,0.135315,0.99053]];
_object25 setPosASL [26252.9,22486.1,63.6319];
_object25 setFuel 0.992416;
[_object25, ["standard",1], ["tailgateHide",0,"tailgate_open",0,"cage_fold",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object25;
clearWeaponCargoGlobal _object25;
clearMagazineCargoGlobal _object25;
clearBackpackCargoGlobal _object25;

{_object25 addItemCargoGlobal _x} forEach [["FirstAidKit",8],["Medikit",1],["ACE_rope6",1]];
{_object25 addWeaponCargoGlobal _x} forEach [["rhs_weap_m4_carryhandle",2]];
{_object25 addMagazineCargoGlobal _x} forEach [["rhs_mag_30Rnd_556x45_M855A1_Stanag",30],["rhs_mag_M433_HEDP",20],["rhsusf_100Rnd_556x45_soft_pouch",11],["rhs_mag_M441_HE",10],["rhs_mag_m714_White",4],["rhs_mag_m662_red",2],["rhs_mag_m67",4],["rhs_mag_m18_green",2],["rhs_mag_m18_red",2],["rhs_mag_an_m8hc",4]];
{_object25 addBackpackCargoGlobal _x} forEach [["rhsusf_falconii",4]];

{_object25 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object25;
{_object25 addMagazineTurret _x} forEach [];
_object26 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object26 setVectorDirAndUp [[-0.856962,-0.514779,-0.0248746],[-0.0283903,-0.00103959,0.999596]];
_object26 setPosASL [27007.9,23302.3,20.8655];
[_object26, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object26;
clearWeaponCargoGlobal _object26;
clearMagazineCargoGlobal _object26;
clearBackpackCargoGlobal _object26;

{_object26 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object26 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object26;
{_object26 addMagazineTurret _x} forEach [];
_object27 = _group5 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object27 setPosASL [27006.6,23300.7,22.1809];
_object27 setDir 241.414;
_object27 setRank "PRIVATE";
_object27 setSkill 0.5;
_object27 setUnitPos "Auto";
_group5 selectLeader _object27;
['_object27_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object27_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object27]] call BIS_fnc_addStackedEventHandler;


_object28 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object28 setVectorDirAndUp [[-0.85654,-0.515923,-0.0127389],[-0.0204492,0.00926459,0.999748]];
_object28 setPosASL [27023,23315.4,21.3817];
[_object28, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object28;
clearWeaponCargoGlobal _object28;
clearMagazineCargoGlobal _object28;
clearBackpackCargoGlobal _object28;

{_object28 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object28 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object28;
{_object28 addMagazineTurret _x} forEach [];
_object29 = _group6 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object29 setPosASL [27021.6,23313.8,22.7287];
_object29 setDir 241.361;
_object29 setRank "PRIVATE";
_object29 setSkill 0.5;
_object29 setUnitPos "Auto";
_group6 selectLeader _object29;
['_object29_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object29_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object29]] call BIS_fnc_addStackedEventHandler;


_object30 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object30 setVectorDirAndUp [[-0.857418,-0.514612,-0.00278604],[-0.0195973,0.027241,0.999437]];
_object30 setPosASL [27040.8,23329.8,21.1203];
[_object30, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object30;
clearWeaponCargoGlobal _object30;
clearMagazineCargoGlobal _object30;
clearBackpackCargoGlobal _object30;

{_object30 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object30 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object30;
{_object30 addMagazineTurret _x} forEach [];
_object31 = _group7 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object31 setPosASL [27039.4,23328.2,22.4927];
_object31 setDir 241.499;
_object31 setRank "PRIVATE";
_object31 setSkill 0.5;
_object31 setUnitPos "Auto";
_group7 selectLeader _object31;
['_object31_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object31_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object31]] call BIS_fnc_addStackedEventHandler;


_object32 = createVehicle ["rhsgref_ins_zil131", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object32 setVectorDirAndUp [[0.991074,0.132754,0.01216],[-0.00701998,-0.0391176,0.99921]];
_object32 setPosASL [26305.8,22063.1,63.1575];
[_object32, ["CHDKZ",1], ["Door_LF",0,"Door_RF",0,"spare_hide",0,"rearnum_hide",0,"bench_hide",0,"cover_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object32;
clearWeaponCargoGlobal _object32;
clearMagazineCargoGlobal _object32;
clearBackpackCargoGlobal _object32;

{_object32 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object32 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object32;
{_object32 addMagazineTurret _x} forEach [];
_object33 = createVehicle ["rhsgref_ins_zil131", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object33 setVectorDirAndUp [[0.991086,0.132503,0.0138364],[-0.00836356,-0.041771,0.999092]];
_object33 setPosASL [26303.5,22059.4,63.0193];
[_object33, ["CHDKZ",1], ["Door_LF",0,"Door_RF",0,"spare_hide",0,"rearnum_hide",0,"bench_hide",0,"cover_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object33;
clearWeaponCargoGlobal _object33;
clearMagazineCargoGlobal _object33;
clearBackpackCargoGlobal _object33;

{_object33 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object33 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object33;
{_object33 addMagazineTurret _x} forEach [];
_object34 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object34 setVectorDirAndUp [[-0.858119,-0.51207,0.0376372],[0.014044,0.0498666,0.998657]];
_object34 setPosASL [27060.3,23345.2,20.4597];
[_object34, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object34;
clearWeaponCargoGlobal _object34;
clearMagazineCargoGlobal _object34;
clearBackpackCargoGlobal _object34;

{_object34 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object34 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object34;
{_object34 addMagazineTurret _x} forEach [];
_object35 = _group8 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object35 setPosASL [27059,23343.6,21.914];
_object35 setDir 241.658;
_object35 setRank "PRIVATE";
_object35 setSkill 0.5;
_object35 setUnitPos "Auto";
_group8 selectLeader _object35;
['_object35_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object35_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object35]] call BIS_fnc_addStackedEventHandler;


_object36 = createVehicle ["rhs_gaz66_flat_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object36 setVectorDirAndUp [[-0.858099,-0.509032,0.067477],[0.0450014,0.0563534,0.997396]];
_object36 setPosASL [27083.8,23363.7,18.9616];
[_object36, ["standard",1], ["bench_hide",1,"cover_hide",0,"spare_hide",0,"rear_numplate_hide",1,"light_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object36;
clearWeaponCargoGlobal _object36;
clearMagazineCargoGlobal _object36;
clearBackpackCargoGlobal _object36;

{_object36 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object36 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object36;
{_object36 addMagazineTurret _x} forEach [];
_object37 = _group9 createUnit ["rhs_msv_driver", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object37 setPosASL [27082.4,23362.1,20.4828];
_object37 setDir 241.784;
_object37 setRank "PRIVATE";
_object37 setSkill 0.5;
_object37 setUnitPos "Auto";
_group9 selectLeader _object37;
['_object37_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	_unit call BIN_fnc_CBRNHoseInit;
	['_object37_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object37]] call BIS_fnc_addStackedEventHandler;


_object38 = createVehicle ["rhsgref_ins_zil131", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object38 setVectorDirAndUp [[0.991002,0.132793,0.0167595],[-0.0117211,-0.0386328,0.999184]];
_object38 setPosASL [26310.1,22060.7,63.0809];
[_object38, ["CHDKZ",1], ["Door_LF",0,"Door_RF",0,"spare_hide",0,"rearnum_hide",0,"bench_hide",0,"cover_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object38;
clearWeaponCargoGlobal _object38;
clearMagazineCargoGlobal _object38;
clearBackpackCargoGlobal _object38;

{_object38 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object38 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object38;
{_object38 addMagazineTurret _x} forEach [];
_object39 = createVehicle ["rhsgref_ins_zil131", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object39 setVectorDirAndUp [[0.991049,0.132462,0.0165695],[-0.0118995,-0.0359698,0.999282]];
_object39 setPosASL [26314.1,22064.4,63.232];
[_object39, ["CHDKZ",1], ["Door_LF",0,"Door_RF",0,"spare_hide",0,"rearnum_hide",0,"bench_hide",0,"cover_hide",0], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object39;
clearWeaponCargoGlobal _object39;
clearMagazineCargoGlobal _object39;
clearBackpackCargoGlobal _object39;

{_object39 addItemCargoGlobal _x} forEach [["FirstAidKit",10],["ACE_rope12",2]];

{_object39 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object39;
{_object39 addMagazineTurret _x} forEach [];
_object40 = createVehicle ["rhsgref_BRDM2_HQ_msv", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object40 setVectorDirAndUp [[-0.976533,0.214844,0.014982],[0.0188183,0.0158218,0.999698]];
_object40 setPosASL [27108.8,23370.8,17.9411];
[_object40, ["olive",1], [], true] call BIS_fnc_initVehicle;

clearItemCargoGlobal _object40;
clearWeaponCargoGlobal _object40;
clearMagazineCargoGlobal _object40;
clearBackpackCargoGlobal _object40;

{_object40 addItemCargoGlobal _x} forEach [["FirstAidKit",4],["Medikit",1],["ACE_rope12",2]];
{_object40 addWeaponCargoGlobal _x} forEach [["rhs_weap_igla",1]];
{_object40 addMagazineCargoGlobal _x} forEach [["rhs_30Rnd_545x39_7N6_AK",30],["rhs_10Rnd_762x54mmR_7N1",10],["rhs_100Rnd_762x54mmR",3],["rhs_mag_rdg2_white",2],["rhs_mag_rgd5",9],["rhs_VOG25",20],["rhs_VG40OP_white",5],["rhs_GRD40_White",5],["rhs_mag_9k38_rocket",2]];
{_object40 addBackpackCargoGlobal _x} forEach [["rhs_sidor",3]];

{_object40 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object40;
{_object40 addMagazineTurret _x} forEach [["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250],["rhs_mag_762x54mm_250",[0],250]];
_object41 = _group10 createUnit ["rhs_msv_crew", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object41 setPosASL [27107.1,23370.9,18.9322];
_object41 setDir 282.408;
_object41 setRank "PRIVATE";
_object41 setSkill 0.5;
_object41 setUnitPos "Auto";
_group10 selectLeader _object41;
['_object41_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	[_unit, [[[],[],["rhs_weap_pya","","","",["rhs_mag_9x19_17",17],[],""],["rhs_uniform_flora",[["FirstAidKit",1],["rhs_mag_9x19_17",2,17],["rhs_mag_rdg2_white",1,1]]],["rhs_vest_pistol_holster",[["rhs_mag_nspd",1,1]]],[],"rhs_tsh4_ess","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[["aceax_textureOptions",[]]]]] call CBA_fnc_setLoadout;
	_unit call BIN_fnc_CBRNHoseInit;
	['_object41_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object41]] call BIS_fnc_addStackedEventHandler;


_object42 = _group10 createUnit ["rhs_msv_crew", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object42 setPosASL [27107.2,23371.5,18.7228];
_object42 setDir 282.408;
_object42 setRank "SERGEANT";
_object42 setSkill 0.5;
_object42 setUnitPos "Auto";
['_object42_nextFrameHandle', 'onEachFrame', {
	params ["_unit"];
	[_unit, [[[],[],["rhs_weap_pya","","","",["rhs_mag_9x19_17",17],[],""],["rhs_uniform_flora",[["FirstAidKit",1],["rhs_mag_9x19_17",2,17],["rhs_mag_rdg2_white",1,1]]],["rhs_vest_pistol_holster",[["rhs_mag_nspd",1,1]]],[],"rhs_tsh4_ess","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]],[["aceax_textureOptions",[]]]]] call CBA_fnc_setLoadout;
	_unit call BIN_fnc_CBRNHoseInit;
	['_object42_nextFrameHandle', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler;
}, [_object42]] call BIS_fnc_addStackedEventHandler;


_object43 = createVehicle ["LOP_AFR_OPF_Static_SPG9", [0, 0, 0], [], 0, "CAN_COLLIDE"];
_object43 setVectorDirAndUp [[-0.032922,-0.998842,0.0350848],[0.0944017,0.0318393,0.995025]];
_object43 setPosASL [26311,22472.3,62.6337];
[_object43, [], [], true] call BIS_fnc_initVehicle;

{_object43 removeMagazineTurret (_x select [0, 2])} forEach magazinesAllTurrets _object43;
{_object43 addMagazineTurret _x} forEach [["FakeWeapon",[-1],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_pg9v",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9vm",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_og9v",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9vnt",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1],["rhs_mag_pg9n",[0],1]];

_group0 setFormation "WEDGE";
_group0 setBehaviour "SAFE";
_group0 setCombatMode "YELLOW";
_group0 setSpeedMode "LIMITED";

_waypoint = [_group0, 0];
_waypoint setWaypointPosition [[26945.7,23253.7,18.7883], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group0 setCurrentWaypoint [_group0, 1];

_group1 setFormation "WEDGE";
_group1 setBehaviour "SAFE";
_group1 setCombatMode "YELLOW";
_group1 setSpeedMode "LIMITED";

_waypoint = [_group1, 0];
_waypoint setWaypointPosition [[26963,23267.8,19.7354], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group1 setCurrentWaypoint [_group1, 1];

_group2 setFormation "WEDGE";
_group2 setBehaviour "AWARE";
_group2 setCombatMode "YELLOW";
_group2 setSpeedMode "NORMAL";

_waypoint = [_group2, 0];
_waypoint setWaypointPosition [[26359.1,22190,61.3442], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group2 setCurrentWaypoint [_group2, 1];

_group3 setFormation "WEDGE";
_group3 setBehaviour "SAFE";
_group3 setCombatMode "YELLOW";
_group3 setSpeedMode "LIMITED";

_waypoint = [_group3, 0];
_waypoint setWaypointPosition [[26977.1,23278.8,22.0247], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group3 setCurrentWaypoint [_group3, 1];

_group4 setFormation "WEDGE";
_group4 setBehaviour "SAFE";
_group4 setCombatMode "YELLOW";
_group4 setSpeedMode "LIMITED";

_waypoint = [_group4, 0];
_waypoint setWaypointPosition [[26993.1,23290.9,20.4615], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group4 setCurrentWaypoint [_group4, 1];

_group5 setFormation "WEDGE";
_group5 setBehaviour "SAFE";
_group5 setCombatMode "YELLOW";
_group5 setSpeedMode "LIMITED";

_waypoint = [_group5, 0];
_waypoint setWaypointPosition [[27008,23302.3,22.4779], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group5 setCurrentWaypoint [_group5, 1];

_group6 setFormation "WEDGE";
_group6 setBehaviour "SAFE";
_group6 setCombatMode "YELLOW";
_group6 setSpeedMode "LIMITED";

_waypoint = [_group6, 0];
_waypoint setWaypointPosition [[27023,23315.4,22.9967], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group6 setCurrentWaypoint [_group6, 1];

_group7 setFormation "WEDGE";
_group7 setBehaviour "SAFE";
_group7 setCombatMode "YELLOW";
_group7 setSpeedMode "LIMITED";

_waypoint = [_group7, 0];
_waypoint setWaypointPosition [[27040.8,23329.7,21.1314], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group7 setCurrentWaypoint [_group7, 1];

_group8 setFormation "WEDGE";
_group8 setBehaviour "SAFE";
_group8 setCombatMode "YELLOW";
_group8 setSpeedMode "LIMITED";

_waypoint = [_group8, 0];
_waypoint setWaypointPosition [[27060.3,23345,20.5038], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group8 setCurrentWaypoint [_group8, 1];

_group9 setFormation "WEDGE";
_group9 setBehaviour "SAFE";
_group9 setCombatMode "YELLOW";
_group9 setSpeedMode "LIMITED";

_waypoint = [_group9, 0];
_waypoint setWaypointPosition [[27083.6,23363.5,19.0063], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group9 setCurrentWaypoint [_group9, 1];

_group10 setFormation "WEDGE";
_group10 setBehaviour "SAFE";
_group10 setCombatMode "YELLOW";
_group10 setSpeedMode "LIMITED";

_waypoint = [_group10, 0];
_waypoint setWaypointPosition [[27108.7,23370.7,17.9384], -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointName "";
_waypoint setWaypointDescription "";
_waypoint setWaypointFormation "NO CHANGE";
_waypoint setWaypointBehaviour "UNCHANGED";
_waypoint setWaypointCombatMode "NO CHANGE";
_waypoint setWaypointSpeed "UNCHANGED";
_waypoint setWaypointTimeout [0,0,0];
_waypoint setWaypointCompletionRadius 0;
_waypoint setWaypointStatements ["true",""];
_waypoint setWaypointScript "";

_group10 setCurrentWaypoint [_group10, 1];


_object13 moveInDriver _object12;
_object14 moveInCommander _object12;
_object16 moveInDriver _object15;
_object20 moveInDriver _object19;
_object22 moveInDriver _object21;
_object27 moveInDriver _object26;
_object29 moveInDriver _object28;
_object31 moveInDriver _object30;
_object35 moveInDriver _object34;
_object37 moveInDriver _object36;
_object41 moveInDriver _object40;
_object42 moveInCommander _object40;
