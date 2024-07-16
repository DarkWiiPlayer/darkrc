vim.api.nvim_create_user_command("Pin", function()
	vim.bo.bufhidden = nil
end, {})

vim.api.nvim_create_user_command("Drop", function()
	vim.bo.bufhidden = "delete"
end, {})

vim.api.nvim_create_user_command("Ephemeral", function(params)
	if params.args == "" then
		vim.api.nvim_echo({
			{"New buffers are "},
			vim.g.ephemeral_buffers
				and {"ephemeral", "DiffDelete"}
				or {"permanent", "DiffAdd"};
		}, false, {})
	elseif params.args == "on" then
		vim.g.ephemeral_buffers = true
	elseif params.args == "off" then
		vim.g.ephemeral_buffers = false
	else
		vim.api.nvim_echo({{"Unknown option: "}, {params.args, "error"}}, false, {})
	end
end, {nargs = "?", complete = function(lead)
	return vim.fn.filter({ "on", "off" }, function(_, val)
		return val:find("^" .. lead)
	end)
end})

vim.g.ephemeral_buffers = false

vim.api.nvim_create_autocmd("BufAdd", {
	callback = function(args)
		if vim.g.ephemeral_buffers then
			vim.bo[args.buf].bufhidden = "delete"
		end
	end
})
