local config = require 'lspconfig'

local ensure_capabilities
xpcall(function()
	ensure_capabilities = require("coq").lsp_ensure_capabilities
end, function()
	function ensure_capabilities(...)
		return ...
	end
end)

local default = { on_attach = require 'lsp.attach' }
for _, language in ipairs {
	"clangd",
	"cssls",
	"html",
	"lua_ls",
	"solargraph",
	"standardrb",
	"svelte",
	"tsserver",
	"yamlls", -- bun install --global yaml-language-server
	"zls",
--	"ruby_lsp",
} do
	config[language].setup(ensure_capabilities(default))
end
