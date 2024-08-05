return function(variable, value)
	vim.fn.chansend(vim.v.stderr, string.format(
		"\x1b]1337;SetUserVar=%s=%s\x07\n",
		variable,
		vim.base64.encode(value)
	))
end
