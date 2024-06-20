vim.api.nvim_create_user_command("BHD", function()
	vim.bo.bufhidden = "delete"
end, {})

vim.api.nvim_create_user_command("BHK", function()
	vim.bo.bufhidden = nil
end, {})

vim.g.ephemeral_buffers = false

vim.api.nvim_create_autocmd("BufAdd", {
	callback = function(args)
		if vim.g.ephemeral_buffers then
			vim.bo[args.buf].bufhidden = "delete"
		end
	end
})
