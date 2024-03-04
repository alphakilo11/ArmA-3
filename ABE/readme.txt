AK's Automated Battle Engine for Arma 3
I wanted to collect data on how the different vehicles compare to each other.

Launch ABE

Startup Parameters: 
    -autoInit -server
Server Config File:
    loopback = true;
    disableVoN = 1;
    persistent = 1;
    timeStampFormat = "full";
    class Missions
    {
        class TestMission01 // name for the first entry - can be anything (characters/numbers/underscore, but no spaces!)
        {
            template = "ABE.VR";
            difficulty = "veteran";
        };
    };
First run AK_functions.sqf and then use launch_ABE.sqf.

DONTs

20221220 Don't remove 'AKBL Result: ' from the result line of the Battlelogger. (ABE_Auswertung.py uses it to identify the lines)
20221220 Don't use 'Survivors: ' in the battlelogger result message, because this is used by ABE_Auswertung.py to identify the vanilla version.
20221220 Don't use Advanced Garbage Collector (It's unnessecary and might cause problems)
20221219 Don't use CSA38 with ABE. (Many error messages are caused by the mod and I suspect it to cause crashes)
20221219 Don't run it in Singleplayer as Pop-up messages will interrupt the execution.
