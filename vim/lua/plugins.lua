function use(plugins)
	return require('packer').startup(function(use)
		for _, plugin in ipairs(plugins) do
			use(plugin)
		end
	end)
end

use {
	'neovim/nvim-lspconfig';
	'pigpigyyy/Yuescript-vim';
	'vim-scripts/openscad.vim';
	'wbthomason/packer.nvim';
	'ziglang/zig.vim';
	-- Colour Schemes
	'DarkWiiPlayer/papercolor-theme';
	'optionalg/Arcadia';
}
