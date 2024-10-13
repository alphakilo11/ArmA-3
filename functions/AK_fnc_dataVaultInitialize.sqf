
/* ----------------------------------------------------------------------------
Function: AK_fnc_dataVaultInitialize

Description:
    Creates an object (Laptop) that serves as namespace for public variables that each client (also the server) creates.
    
Parameters:
    NIL

Example:
    (begin example)
    [] call AK_fnc_dataVaultInitialize;
    (end)

Returns:
    Nil

Author:
    AK
---------------------------------------------------------------------------- */
AK_fnc_dataVaultInitialize = {
	AK_object_dataVault = createVehicle ["Land_Laptop_02_unfolded_F", getPosATL player];
	publicVariable "AK_object_dataVault";
	[{
		AK_object_dataVault setVariable ["dataVaultOfNetID" + str clientOwner, [], true];
	}] remoteExec ["call", 0, "AK_dataVault"];
};
