// ChatGPT Dec 15 Version.
// Define the function
_fnc_createMapMarkers =
{
  // Define the input parameters
  _side, _refreshInterval

  // Initialize the output array
  _mapMarkers = [];

  // Get the current time
  _time = time;

  // Check if it is time to refresh the map markers
  if (_side getVariable ["lastMapUpdate", 0] < (_time - _refreshInterval)) then
  {
    // Remove any existing map markers
    {
      deleteMarker _x;
    } forEach _side getVariable ["mapMarkers", []];

    // Find all known hostile units
    _knownHostiles = [];
    {
      if (side _x != _side) then
      {
        if (knownAbout _x) then
        {
          _knownHostiles pushBack _x;
        }
      }
    } forEach allUnits;

    // Create a map marker for each known hostile unit
    {
      _marker = createMarker [format ["Hostile_%1", _forEachIndex], position _x];
      _marker setMarkerType "ellipse";
      _marker setMarkerColor "ColorRed";
      _marker setMarkerText format ["Hostile
