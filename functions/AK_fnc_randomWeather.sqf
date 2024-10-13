/* Sets random weather */
AK_fnc_randomWeather = {
    if (!isServer) exitWith {
        systemChat "ERROR: has to be executed on the server."
    };
        0 setOvercast random 1; 
        0 setRain random 1; 
        0 setFog [random 1, random [-1, 0, 1], random [-5000, 0, 5000]];
        setWind [random [0, 3, 100], random [0, 3, 100], true];
        forceWeatherChange;
};