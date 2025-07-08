//wind in knots
onEachFrame {hintSilent format ["%1@%2", round (windDir - 180) call CBA_fnc_simplifyAngle, round ((vectorMagnitude wind) * 1.852)]};