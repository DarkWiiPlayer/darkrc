local function use(plugins)
	return require('packer').startup(function(use)
		for _, plugin in ipairs(plugins) do
			local success, message = pcall(use, plugin)
			if not success then
				print(message)
			end
		end
	end)
end

use {
	'wbthomason/packer.nvim';
	{ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } };
	{ 'nvim-treesitter/nvim-treesitter', { cmd = ':TSUpdate' } };
	{ 'nvim-neo-tree/neo-tree.nvim',
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		};
		config = require 'pack.setup.neotree';
	};
	{
		"stevearc/aerial.nvim", config = function()
			require("aerial").setup()
		end
	};
	{
		"simrat39/symbols-outline.nvim", config = function()
			require("symbols-outline").setup()
		end
	};
	{ 'jinh0/eyeliner.nvim', config = function()
		require('eyeliner').setup {
			highlight_on_key = true;
			dim = true;
		}
	end};
	'leafo/moonscript-vim';
	'neovim/nvim-lspconfig';
	'pigpigyyy/Yuescript-vim';
	'vim-scripts/openscad.vim';
	'ziglang/zig.vim';
--	Colour Schemes
	'AlessandroYorba/Alduin';
	'AlessandroYorba/Sierra';
	'DarkWiiPlayer/papercolor-theme';
	'ayu-theme/ayu-vim';
	'dracula/vim';
	'jaredgorski/fogbell.vim';
	'optionalg/Arcadia';
	'rakr/vim-two-firewatch';
	'rebelot/kanagawa.nvim';
	'sainnhe/sonokai';
	'shaunsingh/nord.nvim';
	'sts10/vim-pink-moon';
	'whatyouhide/vim-gotham';
}
