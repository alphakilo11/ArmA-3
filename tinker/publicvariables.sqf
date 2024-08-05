unlucky setVariable ["AK_var_test"+str clientOwner, 42, true];
publicVariable "unlucky";
[{
[str (allVariables unlucky)] remoteExec ["systemChat", -2];
}] remoteExec ["call", 2];
[{
[str (unlucky getVariable ["AK_var_test4", ""])] remoteExec ["systemChat", -2];
}] remoteExec ["call", 2];

unlucky getVariable ["AK_var_test" + str clientOwner, ""];