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
	"html",
	"cssls",
	"clangd",
	"tsserver",
	"lua_ls",
	"solargraph",
	"standardrb",
	"zls",
	"yamlls" -- bun install --global yaml-language-server
} do
	config[language].setup(ensure_capabilities(default))
end
