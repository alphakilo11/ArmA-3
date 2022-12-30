_non_contenders = ['rhsusf_m113_usarmy_M240', 'LIB_PzKpfwV_no_lods_DLV', 'vn_b_armor_m113_acav_02_rok_army', 'gm_ge_army_m109g', 'rhsusf_m113_usarmy_medical', 'LIB_UniversalCarrier_w_DLV', 'LIB_SdKfz124_DLV', 'CUP_B_M113A3_Med_USA', 'LIB_UniversalCarrier', 'gm_ge_army_m113a1g_command', 'LIB_UniversalCarrier_w', 'CUP_B_M113A3_Repair_USA', 'rhs_prp3_vv', 'CUP_I_BMP_HQ_UN', 'LIB_UniversalCarrier_desert_DLV', 'CUP_O_BMP2_AMB_sla', 'CUP_B_M113A3_Repair_olive_USA', 'ffaa_et_toa_ambulancia']
_randomTanks = (("configName _x isKindOf 'tank' and getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles")) apply {(configName _x)})
_contenders = _randomTanks - _non_contenders
[_contenders, [4000, 7000,0], 60] call AK_fnc_automatedBattleEngine;
