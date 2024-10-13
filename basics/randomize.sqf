// Create an array of random cases and summarize the results 
_arr = [];
_cases = [1, 2, 3, 4, 5];
for "_i" from 1 to 50000 do {
	_arr pushBack selectRandom _cases
};
_results = [];
{
	_a = _x;
	_results pushBack ({
		_x == _a
	} count _arr);
}forEach _cases;
_results;