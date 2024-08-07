return function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	--vim.keymap.set('v', '<C-k>', vim.lsp.buf.signature_help, bufopts)

	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)

	vim.api.nvim_buf_create_user_command(bufnr, "LspSetWorkspace", function()
		for _, workspace in ipairs(vim.lsp.buf.list_workspace_folders()) do
			vim.lsp.buf.remove_workspace_folder(workspace)
		end
		vim.lsp.buf.add_workspace_folder(vim.cmd("pwd"))
	end, {})

	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	if require("telescope") then
		vim.keymap.set('n', 'gr', function() vim.cmd("Telescope lsp_references") end, bufopts)
	else
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	end
	--vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format()
	end, {})

	vim.api.nvim_buf_create_user_command(bufnr, "LspWorkspaces", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, {})

	vim.api.nvim_buf_create_user_command(bufnr, "Rename", function(params)
		if #params.fargs > 0 then
			vim.lsp.buf.rename(params.fargs[1])
		else
			vim.lsp.buf.rename()
		end
	end, {nargs = "?"})

	vim.api.nvim_buf_create_user_command(bufnr, "LspDocumentHighlight", function(args)
		local disable = vim.b.document_highlight
		arg = args.fargs[1]
		if arg then
			if string.lower(arg) == "on" then
				disable = false
			elseif string.lower(arg) == "off" then
				disable = true
			else
				error "Argument must be either 'on' or 'off' or absent"
			end
		end
		if disable then
			require("lsp.document_highlight").stop(bufnr)
			vim.b.document_highlight = false
		else
			require("lsp.document_highlight").start(bufnr)
			vim.b.document_highlight = true
		end
	end, {nargs = "?", complete = function(lead)
		return vim.fn.filter({ "on", "off" }, function(_, val)
			return val:find("^" .. lead)
		end)
	end})
end
