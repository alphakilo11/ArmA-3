{
	[
		test,
		{
			diag_log format
			[
				"Request recieved! Variable test on the server is: %1",
				_this
			];
		}
	]
	remoteExec ["call", remoteExecutedOwner];
}
remoteExec ["call", 2];

// writes the value from the local machine to the server *.rpt file
[test] remoteExecCall ["diag_log", 2];

// works
[[], {
	diag_log test
}] remoteExec ["call", 2];

[[], {
	test = 17;
} ]
remoteExec ["spawn", 2];