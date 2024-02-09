local config = require 'lspconfig'

local default = { on_attach = require 'lsp.attach' }
for _, language in ipairs {
	"html",
	"cssls",
	"clangd",
	"tsserver",
	"lua_ls",
	"solargraph",
	"standardrb",
	"zls",
} do
	config[language].setup(default)
end
