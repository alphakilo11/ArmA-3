// doesn't work
// 0.0052 ms
_spawngroup = {
	private _numberofprivates = 8;
	private _position = [25722, 21374];
	private _radius = 500;
	private _typeofunit = ["LOP_BH_Infantry_model_OFI_TRI", "LOP_BH_Infantry_model_OFI_M81", 'LOP_BH_Infantry_model_OFI_LIZ', "LOP_BH_Infantry_model_OFI_FWDL", "LOP_BH_Infantry_model_OFI_ACU", "LOP_BH_Infantry_model_M81_TRI", "LOP_BH_Infantry_model_M81_LIZ", "LOP_BH_Infantry_model_M81_FWDL", "LOP_BH_Infantry_model_M81_CHOCO", "LOP_BH_Infantry_model_M81_ACU", "LOP_BH_Infantry_model_M81", "LOP_BH_Infantry_AR", "LOP_BH_Infantry_AR_2", "LOP_BH_Infantry_AR_Asst", "LOP_BH_Infantry_AR_Asst_2", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_base", "LOP_BH_Infantry_Corpsman", "LOP_BH_Infantry_Driver", "LOP_BH_Infantry_GL", "LOP_BH_Infantry_IED", "LOP_BH_Infantry_Marksman"];
	private _newGroup = createGroup east;
	_a = 0;
	while {
		_a = _a + 1;
		_a < (_numberofprivates + 1)
	} do {
		_newUnit = _newGroup createUnit [(selectRandom _typeofunit), _position, [], _radius, 'CAN_COLLIDE'];
	};
};
[_spawngroup] remoteExec ["spawn", 2];