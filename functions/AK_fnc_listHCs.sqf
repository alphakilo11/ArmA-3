AK_fnc_listHCs = {
    _collectedUserInfo = [];
    {_collectedUserInfo pushBack (getUserInfo _x)} forEach allUsers;
    
    _headlessClients = [];
    {
        if (_x select 7 == true) then {
            _headlessClients pushBack (_x select 1);
        };
    } forEach _collectedUserInfo;
    _headlessClients;
};