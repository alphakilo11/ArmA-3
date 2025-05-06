AK_fnc_quickBattle = {
	/* ----------------------------------------------------------------------------
	Function: AK_fnc_quickBattle

	Description:
		Quickly set-up a large battle
		
	Parameters:
		["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_angreiferGefechtsstreifenBreite", "_verteidigerGefechtsstreifenBreite"]
	Returns:
		NIL

	Example:
		(begin example)
			[curatorSelected, true, 44, 10, 1000, 1000] spawn AK_fnc_quickBattle;    
		(end)

	Author:
		AK

---------------------------------------------------------------------------- */
	// HEADSUP if you select vehicles on the map you get the groups, if you select them in 3D than you get all units (including each crewmember)
	   // ENHANCE how to determine attacker side? currently I use an empty vehicle
	   // ENHANCE defaults for params
	    // assumes that all attackers and defenders each share the same side 
	    params ["_selection", "_debug", "_angreiferAnzahl", "_verteidigerAnzahl", "_angreiferGefechtsstreifenBreite", "_verteidigerGefechtsstreifenBreite"]; // pass two arrays of vehicles seperated in space (eg by curatorSelected)
	_angreiferFahrzeugAbstand = 100;

	_verteidigerFahrzeugAbstand = 100;

	_SelectedEntities = _selection select 0;
	_SelectedGroups = _selection select 1;
	_parties = [_SelectedEntities] call AK_fnc_GroupbyDistance;
	_initialPartyA = (_parties select 0);
	_initialPartyB = (_parties select 1);

	    // determine type of battle
	_battleType = "eil_bez_Verteidigung";
	_rawAttackers = false;
	_rawDefenders = false;
	_civInA = civilian in (_initialPartyA apply {
		side _x
	});
	_civInB = civilian in (_initialPartyB apply {
		side _x
	});
	if (!_civInA and !_civInB) then {
		_battleType = "Begegnungsgefecht";
	} else {
		if (_civInA) then {
			_rawAttackers = _initialPartyA;
			_rawDefenders = _initialPartyB
		} else {
			_rawAttackers = _initialPartyB;
			_rawDefenders = _initialPartyA
		};
		 _rawAttackers deleteAt ((_rawAttackers apply {
			side _x
		}) find civilian); // remove the attacker "marker"
	};
	if (_battleType == "Begegnungsgefecht") exitWith {
		diag_log "ERROR AK_fnc_quickBattle: Begegnungsgefecht not yet implemented."
	};
	if (_debug) then {
		diag_log format ['Type of battle determined. %1', [_battleType, _rawAttackers, _rawDefenders]]
	};

	referenceAttacker = _rawAttackers select 0;
	referenceDefender = _rawDefenders select 0;
	_angreiferSpawnPosAnchor = getPos referenceAttacker;
	_angriffsZiel = getPos referenceDefender;
	_typleListAttackers = [_rawAttackers apply {
		typeOf _x
	}, _angreiferAnzahl] call AK_fnc_TypeRatio;
	_typleListDefenders = [_rawDefenders apply {
		typeOf _x
	}, _verteidigerAnzahl] call AK_fnc_TypeRatio;
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
	    _linieSturmAngriff = _angriffsDistanz - 2000; // 500 bis 1500 m
	_verteidigerRichtung = _angriffsZiel getDir _angreiferSpawnPosAnchor;
	_verteidigerRichtungVector = [_angriffsRichtungVector, 180] call BIS_fnc_rotateVector2D;

	   // spawn attackers
	[
		{
			isNull referenceAttacker
		},
		{
			referenceAttacker = nil;
			_this call AK_fnc_attack;
		},
		[_angreiferSpawnPosAnchor, _angriffsRichtungVector, _angriffsRichtung, _typleListAttackers, _angreiferSide, _angreiferAnzahl, _angriffsDistanz, _angreiferFahrzeugAbstand, _angreiferGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, true, true]
	] call CBA_fnc_waitUntilAndExecute;

	   // spawn defenders

	[
		{
			isNull referenceDefender
		},
		{
			referenceDefender = nil;
			_this call AK_fnc_attack;
		},
		[_angriffsZiel, _verteidigerRichtungVector, _verteidigerRichtung, _typleListDefenders, _verteidigerSide, _verteidigerAnzahl, _angriffsDistanz, _verteidigerFahrzeugAbstand, _verteidigerGefechtsstreifenBreite, _linieSturmAngriff, _angriffsZiel, false, true]
	] call CBA_fnc_waitUntilAndExecute;
};