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

-- init_options -> during server initialization
-- settings -> sent as config change event right after initialization
local configs = setmetatable({
	yamlls = default {
		settings = {
			yaml = {
				format = { enable = true }
			}
		}
	},
	ruby_lsp = default {
		init_options = {
			formatter = "standard";
			linters = { "standard" };
		}
	},
}, {__index = function() return default end})

for _, language in ipairs {
	"clangd",
	"cssls",
	"html",
	"lua_ls",
	"ruby_lsp",
	"solargraph",
	"standardrb",
	"svelte",
	"tsserver",
	"zls",
	"yamlls", -- bun install --global yaml-language-server
} do
	config[language].setup(ensure_capabilities(configs[language]))
end

-- function _G.ls(name)
-- 	for _, server in pairs(vim.lsp.get_clients()) do
-- 		if server.config.name == name then
-- 			return server
-- 		end
-- 		error("No running language server with name " .. name)
-- 	end
-- end

vim.api.nvim_create_user_command("LspAdd", function(params)
	local language = params.args
	local setup = config[language].setup -- temp variable for better stack trace
	setup(ensure_capabilities(configs[language]))
end, {nargs = 1})
