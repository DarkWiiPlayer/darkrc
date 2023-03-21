function use(plugins)
	return require('packer').startup(function(use)
		for _, plugin in ipairs(plugins) do
			use(plugin)
		end
	end)
end

use {
	'wbthomason/packer.nvim';
	'neovim/nvim-lspconfig';
	'pigpigyyy/Yuescript-vim';
	'ziglang/zig.vim';
	'neovim/nvim-lspconfig';
}
