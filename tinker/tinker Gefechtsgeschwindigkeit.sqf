_ziel = (group unlucky) addWaypoint [(unlucky modelToWorld [0, 40,0]), 1];
zeit = time;
_ziel setWaypointStatements ["true", "diag_log format ['Dauer: %1', (time - zeit)]"];
