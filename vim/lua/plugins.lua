function use(plugins)
	return require('packer').startup(function(use)
		for _, plugin in ipairs(plugins) do
			use(plugin)
		end
	end)
end

use {
	'neovim/nvim-lspconfig';
	{ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } };
	{ 'nvim-treesitter/nvim-treesitter', { cmd = 'TSUpdate' } };
	{ 'nvim-neo-tree/neo-tree.nvim',
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	},
	'leafo/moonscript-vim';
	'pigpigyyy/Yuescript-vim';
	'vim-scripts/openscad.vim';
	'wbthomason/packer.nvim';
	'ziglang/zig.vim';
	-- Colour Schemes
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
