// WIP Function to deliver coordinates (eg for spawn positions)
// possible input: form (square, circle, rectangle, ?), number of required positions, spacing x/y/z 
// currently this creates an eastbound line starting at _center
[[[24000, 19000, 0]], 100, 5] params ["_center", "_numberOfPositions", "_spacing"];
for "_i" from 0 to (_numberOfPositions - 1) do {
	_center pushBack ((_center select _i) vectorAdd [_spacing, 0, 0]);
};
_center;