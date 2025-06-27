//comparing arrays and Hashmaps
// 9.2314 ms Arma 3 2.20 7800X3D
for "_i" from 1 to 10000 do {
    localNamespace setVariable ["Spam", [123, "AK", [2.4,2.3, 14.2]]];
    _data = localNamespace getVariable ["Spam", "None"];
    _requiredValue = _data select 1;
};
// 15.865 ms Arma 3 2.20 7800X3D
for "_i" from 1 to 10000 do {
    localNamespace setVariable ["Spam", ["Test", "Spam", "Blub"] createHashMapFromArray [123, "AK", [2.4,2.3, 14.2]]];
    _data = localNamespace getVariable ["Spam", "None"];
    _requiredValue = _data getOrDefault ["Spam", "NotFound"];
};