local config = require 'lspconfig'

config.lua_ls.setup {
	on_attach = require 'lsp.attach'
}
config.zls.setup {
	on_attach = require 'lsp.attach'
}
config.standardrb.setup {
	on_attach = require 'lsp.attach'
}
config.clangd.setup {
	on_attach = require 'lsp.attach'
}
config.solargraph.setup {
	on_attach = require 'lsp.attach'
}
config.denols.setup {
	on_attach = require 'lsp.attach'
}
