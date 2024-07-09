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
setmetatable(default, {__call = function(self, other)
	local new = {}
	for _, tab in ipairs{self, other} do
		for key, value in pairs(tab) do
			new[key] = value
		end
	end
	return new
end})

for key, value in pairs {
	"clangd",
	"cssls",
	"html",
	"lua_ls",
	"solargraph",
	"standardrb",
	"svelte",
	"tsserver",
	"zls",
	yamlls = default {
		settings = {
			yaml = {
				format = { enable = true }
			}
		}
	}, -- bun install --global yaml-language-server
	"ruby_lsp",
} do
	local language, settings if type(key) == "string" then
		language, settings = key, value
	else
		language, settings = value, default
	end

	config[language].setup(ensure_capabilities(settings))
end

function _G.ls(name)
	for _, server in pairs(vim.lsp.get_clients()) do
		if server.config.name == name then
			return server
		end
		error("No running language server with name " .. name)
	end
end
