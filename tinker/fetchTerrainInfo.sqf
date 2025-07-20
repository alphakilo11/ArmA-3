// extract selected terrain (=map) info from the Config
private _terrainList = ('getText (_x >> "description") != ""' configClasses (configFile >> "CfgWorlds"));//["rhs_ammo_3of11", "rhs_ammo_3of26", "rhs_ammo_3of56", "rhs_ammo_3of69m"];
_terrainList = _terrainList apply {configName _x};
systemChat str (_terrainList select 5);
private _collected_results = [];

 {
_results = [];
  _results pushBack _x;
  _results pushBack (getText (configFile >> "CfgWorlds" >> _x >> "description"));
  _results pushBack getNumber (configFile >> "CfgWorlds" >> _x >> "latitude");
  _results pushBack getNumber (configFile >> "CfgWorlds" >> _x >> "longitude");
  _results pushBack getNumber (configFile >> "CfgWorlds" >> _x >> "elevationOffset");
  _collected_results pushBack _results;
 } forEach _terrainList;
_collected_results;
