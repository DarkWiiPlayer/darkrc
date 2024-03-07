return function()
	vim.keymap.set("n", "<leader>o", "<cmd>OutlineOpen<CR><cmd>OutlineFocus<CR>", { desc = "Toggle Outline" })
	require("outline").setup {
		outline_window = {
			position = "right";
			width = 20;
			relative_width = false;
		};
	}
end
