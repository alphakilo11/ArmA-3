// ChatGPT Dec 15 Version.
// Define the function
_fnc_getSpawnPositions =
{
  // Define the input parameters
  _shape, _numPositions, _spacingX, _spacingY, _spacingZ

  // Initialize the output array
  _spawnPositions = [];

  // Generate the spawn positions based on the specified shape
  switch (_shape) do
  {
    case "square":
    {
      // Calculate the number of positions per row/column
      _positionsPerRow = ceil(sqrt _numPositions);

      // Generate the spawn positions in a square grid pattern
      for "_row" from 0 to _positionsPerRow - 1 do
      {
        for "_column" from 0 to _positionsPerRow - 1 do
        {
          _spawnPositions pushBack [(_row * _spacingX), (_column * _spacingY), _spacingZ];
        }
      }
    }
    case "circle":
    {
      // Calculate the radius of the circle
      _radius = sqrt((_spacingX * _spacingX) + (_spacingY * _spacingY));

      // Generate the spawn positions in a circle pattern
      for "_i" from 0 to _numPositions - 1 do
      {
        _angle = (_i / _numPositions) * 2 * pi;
        _x = (_radius * cos _angle) + _spacingX;
        _y = (_radius * sin _angle) + _spacingY;
        _spawnPositions pushBack [_x, _y, _spacingZ];
      }
    }
    case "rectangle":
    {
      // Calculate the number of rows/columns
      _numRows = ceil(_numPositions / _spacingX);
      _numColumns = ceil(_numPositions / _spacingY);

      // Generate the spawn positions in a rectangle grid pattern
      for "_row" from 0 to _numRows - 1 do
      {
        for "_column" from 0 to _numColumns - 1 do
        {
          _spawnPositions pushBack [(_
