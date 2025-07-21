["ZEN_changeWeather", { 
    // I wasn't able to find out the actual name of Eventhandler, so I copied the code from Github.com/zen-mod 
    params ["_forced", "_overcast", "_rain", "_precipitationType", "_lightning", "_rainbow", "_waves", "_wind", "_gusts", "_fog"]; 
 
    0 setOvercast _overcast; 
    0 setLightnings _lightning; 
    0 setRainbow _rainbow; 
    0 setWaves _waves; 
    0 setGusts _gusts; 
 
    if (isServer) then { 
        0 setRain _rain; 
        0 setFog _fog; 
        setWind _wind; 
 
        switch (_precipitationType) do { 
            // Reset to default 
            case 0: { 
                [] call BIS_fnc_setRain; 
            }; 
            // Set to snow 
            case 1: { 
                [ 
                    "a3\data_f\snowflake4_ca.paa", // rainDropTexture 
                    4, // texDropCount 
                    0.01, // minRainDensity 
                    25, // effectRadius 
                    0.05, // windCoef 
                    2.5, // dropSpeed 
                    0.5, // rndSpeed 
                    0.5, // rndDir 
                    0.07, // dropWidth 
                    0.07, // dropHeight 
                    [1, 1, 1, 0.5], // dropColor 
                    0.0, // lumSunFront 
                    0.2, // lumSunBack 
                    0.5, // refractCoef 
                    0.5, // refractSaturation 
                    true, // snow 
                    false // dropColorStrong 
                ] call BIS_fnc_setRain; 
            }; 
        }; 
 
        if (_forced) then { 
            forceWeatherChange; 
        }; 
    }; 
}] call CBA_fnc_addEventHandler;
