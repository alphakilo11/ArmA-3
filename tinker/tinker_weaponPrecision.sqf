// creating arrows to inidicate aim point
arrow_red = "Sign_arrow_F" createVehicle [0, 0, 0];
arrow_blue = "Sign_arrow_blue_F" createVehicle [0, 0, 0];
onEachFrame {
	_aimPos = AGLToASL positionCameraToWorld [0, 0, 0];
	_ins = lineIntersectsSurfaces [
		_aimPos,
		  AGLToASL positionCameraToWorld [0, 0, 5000], // "Hardcoded max distance: 5000m." 
		player,
		objNull,
		true,
		1,
		"FIRE",
		"NONE"
	];
	if (count _ins == 0) exitWith {
		arrow_red setPosASL [0, 0, 0]
	};
	// arrow_red setPosASL (_ins select 0 select 0); 
	// arrow_red setVectorUp (_ins select 0 select 1); 
	hintSilent format ["Center position: %1. Range: %2 m. Direction: %3", (_ins select 0 select 0), getPosASL player distance (_ins select 0 select 0), getPosASL player getDir _aimPos];
	  /*_ins = lineIntersectsSurfaces [ 
			  eyePos player, 
		  AGLToASL positionCameraToWorld [0, 0, 5000], // "Hardcoded max distance: 5000m." 
			  player, 
			  objNull, 
			  true, 
			  1, 
			  "FIRE", 
			  "NONE" 
		 ]; 
		 if (count _ins == 0) exitWith {
			arrow_blue setPosASL [0, 0, 0]
		}; 
		 arrow_blue setPosASL (_ins select 0 select 0); 
		 arrow_blue setVectorUp (_ins select 0 select 1);  
	 */
};