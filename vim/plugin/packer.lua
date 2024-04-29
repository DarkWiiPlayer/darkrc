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
		config = require 'config.neotree';
	};
	{
		"stevearc/aerial.nvim", config = function()
			require("aerial").setup()
		end
	};
	{
		"hedyhli/outline.nvim", config = require 'config.outline';
	};
	'folke/twilight.nvim';
	'leafo/moonscript-vim';
	'ms-jpq/coq_nvim';
	'ms-jpq/coq.artifacts';
	'ms-jpq/coq.thirdparty';
	'neovim/nvim-lspconfig';
	'pigpigyyy/Yuescript-vim';
	'vim-scripts/openscad.vim';
	'ziglang/zig.vim';
--	Colour Schemes
	'AlessandroYorba/Alduin';
	'AlessandroYorba/Sierra';
	'DarkWiiPlayer/papercolor-theme';
	'EdenEast/nightfox.nvim';
	'axvr/photon.vim';
	'ayu-theme/ayu-vim';
	'dracula/vim';
	'jaredgorski/fogbell.vim';
	'kvrohit/mellow.nvim';
	'optionalg/Arcadia';
	'rakr/vim-two-firewatch';
	'rebelot/kanagawa.nvim';
	'sainnhe/sonokai';
	'shaunsingh/nord.nvim';
	'sts10/vim-pink-moon';
	'whatyouhide/vim-gotham';
}
