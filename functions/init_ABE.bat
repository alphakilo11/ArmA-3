REM merges the required functions for the Automated Battle Engine into one file

copy /b AK_fnc_spacedvehicles.sqf + AK_fnc_battlelogger.sqf + AK_fnc_AutomatedBattleEngine_Main.sqf init.sqf
REM move init.sqf "C:\Google Drive\ArmA 3\Homebrew\Automated Battle Engine"