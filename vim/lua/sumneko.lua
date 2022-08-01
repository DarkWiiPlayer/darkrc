local lsp_flags = require('lspconfig').sumneko_lua.setup{
	on_attach = require 'on_lsp_attach',
}
vim.api.nvim_command("LspStart")
