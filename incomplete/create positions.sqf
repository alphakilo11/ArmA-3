//possible input: form (square, circle, rectangle, ?), number of required positions, spacing x/y/z 
[[[24000,19000,0]], 36, 100] params ["_center", "_numberOfPositions", "_spacing"]; 
for "_i" from 0 to (_numberOfPositions - 1) do { 
_center pushBack ((_center select _i) vectorAdd [_spacing ,0 ,0]); 
}; 
_center
